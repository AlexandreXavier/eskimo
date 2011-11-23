/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.pialabs.eskimo.components.maps
{
  import com.pialabs.eskimo.controls.SkinnableAlert;
  
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.LocationChangeEvent;
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.media.StageWebView;
  import flash.system.Capabilities;
  import flash.utils.ByteArray;
  import flash.utils.Dictionary;
  import flash.utils.Timer;
  
  import mx.core.ByteArrayAsset;
  import mx.core.FlexGlobals;
  import mx.core.UIComponent;
  import mx.events.FlexEvent;
  import mx.utils.Base64Decoder;
  import mx.utils.Base64Encoder;
  
  /**
  * Dispatch when google map is initialized
  */
  [Event(name = "complete", type = "flash.events.Event")]
  
  /**
  * Dispatch if an error occured during loading
  */
  
  [Event(name = "error", type = "flash.events.ErrorEvent")]
  
  /**
  * Dispatch when a marker is clicked
  */
  [Event(name = "markerClicked", type = "com.pialabs.eskimo.components.maps.GMapEvent")]
  /**
  * Dispatch when bounds change
  */
  [Event(name = "boundsChanged", type = "com.pialabs.eskimo.components.maps.GMapEvent")]
  public class GMap extends UIComponent
  {
    /**
     * @private
     */
    public var webView:StageWebView;
    
    /**
     * @private
     */
    private var _zoom:Number;
    /**
     * @private
     */
    private var _mapInitialized:Boolean = false;
    /**
     * @private
     */
    private var _overlayVisible:Boolean = true;
    
    /**
     * @private
     */
    private var _center:Point = new Point();
    
    /**
     * @private
     */
    private var _directoryTmp:File = File.documentsDirectory.resolvePath("eskimoTmp/");
    
    /**
     * @private
     */
    private var _fileTmp:File = _directoryTmp.resolvePath("index.html");
    
    /**
     * @private
     */
    private var _currentOS:String;
    
    /**
     * @private
     * For callback iOS demands http://, qnx message:// and android don't care...
     */
    private var protecolBridge:String = "http";
    
    /**
     * @private
     */
    private var _isIOS:Boolean;
    private var _isQNX:Boolean;
    
    /**
     * @private
     */
    private var _iOSCSSTimer:Timer;
    
    /**
    * @private
    */
    public var debugMode:Boolean = false;
    
    
    /**
    * JS callback dictionnary
    */
    protected var _callbacks:Dictionary = new Dictionary(true);
    
    
    /**
    * Constructor
    */
    public function GMap()
    {
      super();
      
      _currentOS = Capabilities.os.toLocaleUpperCase();
      
      _isIOS = _currentOS.lastIndexOf("IPHONE") != -1;
      _isQNX = _currentOS.lastIndexOf("QNX") != -1;
      
      if (_isQNX)
      {
        _fileTmp = File.createTempFile();
        // Qnx don't listen for callback if the protocol is http:// (BUT iOS is waiting for http://...)
        protecolBridge = "message";
      }
      
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage, false, 0, true);
      
      webView = new StageWebView();
      
      webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging);
      webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChanging);
      
      addCallBack("onInitialized", onInitialized);
      addCallBack("onMarkerClicked", onMarkerClicked);
      addCallBack("onMarkerAdded", onMarkerAdded);
      addCallBack("onBoundsChanged", onBoundsChanged);
    }
    
    private function onAddedToStage(event:Event):void
    {
      init();
    }
    
    private function onRemovedToStage(event:Event):void
    {
      webView.stage = null;
      webView = null;
      
      deleteTmpFiles();
    }
    
    /**
     * @private
     *
     * Just override to re-scale due to auto-orientation project nature
     * */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if (webView)
      {
        var point:Point = localToGlobal(new Point());
        
        var ratio:Number = FlexGlobals.topLevelApplication.runtimeDPI / FlexGlobals.topLevelApplication.applicationDPI;
        
        webView.viewPort = new Rectangle(point.x, point.y, unscaledWidth * ratio, unscaledHeight * ratio);
      }
    }
    
    /**
    * @private
    */
    protected function init():void
    {
      webView.viewPort = new Rectangle(0, 200, stage.stageWidth, 400);
      if (_isIOS)
      {
        webView.stage = this.stage;
      }
      else
      {
        webView.stage = null;
      }
      
      var html:String = GMapHTMLTemplate.HTML_TEMPLATE.toString();
      
      // Because of QNX exception we replace the protocol if necessary
      html = html.replace("http://[CallBack]", protecolBridge + "://[CallBack]");
      
      var _fileStream:FileStream = new FileStream();
      _fileStream.open(_fileTmp, FileMode.WRITE);
      _fileStream.writeUTFBytes(html);
      _fileStream.close();
      
      webView.loadURL(_fileTmp.url);
      
      webView.addEventListener(Event.COMPLETE, onWebViewReady, false, 0, true);
      webView.addEventListener(ErrorEvent.ERROR, onWebViewError, false, 0, true);
    
    
    }
    
    /**
     * Generic StageWebView Listener. Controls LOCATION_CHANGING events for catching special cases.
     */
    private function onLocationChanging(e:Event):void
    {
      var currLocation:String = unescape((e as LocationChangeEvent).location);
      if (debugMode)
      {
        trace("onLocationChanging", currLocation);
      }
      
      if (currLocation.indexOf(protecolBridge + '://[CallBack]') == 0)
      {
        applyCallBack(currLocation.split(protecolBridge + '://[CallBack]')[1]);
        e.preventDefault();
      }
      else if (currLocation.indexOf('http://') == 0 || currLocation.indexOf('https://') == 0)
      {
        e.preventDefault();
      }
      else if (_isIOS && currLocation.indexOf('about:blank') == 0)
      {
      }
    }
    
    private function onCSSTimer(event:TimerEvent):void
    {
      onInitialized(false);
    }
    
    /**
     * @private
     */
    private function onWebViewReady(event:Event):void
    {
      if (!_isIOS)
      {
        webView.loadURL('javascript:');
      }
      
      deleteTmpFiles();
    }
    
    /**
     * @private
     */
    private function onWebViewError(event:ErrorEvent):void
    {
      if (debugMode)
      {
        trace(event.toString());
      }
      dispatchEvent(event.clone());
      
      deleteTmpFiles();
    }
    
    private function deleteTmpFiles():void
    {
      if (_fileTmp.exists)
      {
        _fileTmp.deleteFile();
      }
      if (_directoryTmp.exists)
      {
        _directoryTmp.deleteDirectory(true);
      }
    }
    
    /**
     * @private
     */
    protected function onMarkerClicked(lat:Number, lng:Number):void
    {
      var event:GMapEvent = new GMapEvent(GMapEvent.MARKER_CLICKED);
      event.lat = lat;
      event.lng = lng;
      event.zoom = _zoom;
      
      dispatchEvent(event);
    }
    
    protected function onMarkerAdded():void
    {
      if (_overlayVisible)
      {
        showOverlays();
      }
    }
    
    /**
     * @private
     */
    private function onInitialized(fromJS:Boolean = true):void
    {
      //if iOS, wait for css...
      if (_isIOS && fromJS)
      {
        // TODO OUTCH! find a better way to wait the right moment
        _iOSCSSTimer = new Timer(200, 1);
        _iOSCSSTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCSSTimer);
        _iOSCSSTimer.start();
        return;
      }
      
      _mapInitialized = true;
      
      webView.stage = this.stage;
      
      if (_center.x != 0 && _center.y != 0)
      {
        setCenter(_center.x, _center.y);
      }
      
      zoom = _zoom;
      
      if (_overlayVisible)
      {
        showOverlays();
      }
      
      dispatchEvent(new Event(Event.COMPLETE));
    }
    
    protected function onBoundsChanged(lat:Number, lng:Number, zoom:Number):void
    {
      _zoom = zoom;
      
      _center.x = lat;
      _center.y = lng;
      
      var event:GMapEvent = new GMapEvent(GMapEvent.BOUNNDS_CHANGED);
      event.lat = lat;
      event.lng = lng;
      event.zoom = _zoom;
      
      dispatchEvent(event);
    }
    
    /**
     * Set the center of the map
     */
    public function setCenter(lat:Number, lng:Number):void
    {
      if (_mapInitialized)
      {
        callJSFunction('setCenter', lat, lng);
      }
      
      _center = new Point(lat, lng);
    }
    
    /**
    * Get current center of the map
    */
    public function getCenter():Point
    {
      return _center;
    }
    
    [Bindable(event = "boundsChanged")]
    /**
     * Zoom
     */
    public function get zoom():Number
    {
      return _zoom;
    }
    
    /**
    * @private
    */
    public function set zoom(value:Number):void
    {
      if (_zoom == value)
      {
        return;
      }
      
      _zoom = value;
      if (_mapInitialized)
      {
        callJSFunction("setZoom", value);
      }
    }
    
    /**
     * Add a marker on the map (the map needs to be initialized first).
     */
    public function addMarker(lat:Number, lng:Number, title:String = null, description:String = null, showMarkerWindow:Boolean = false):void
    {
      if (_mapInitialized)
      {
        callJSFunction('addMarker', lat, lng, title, description, showMarkerWindow);
      }
    }
    
    /**
     * Add a marker image on the map (the map needs to be initialized first).
     */
    public function addMarkerImage(lat:Number, lng:Number, iconURL:String, iconWidth:Number, iconHeight:Number, anchor:Point, title:String = null, description:String = null, showMarkerWindow:Boolean = false):void
    {
      if (_mapInitialized)
      {
        callJSFunction('addMarkerImage', lat, lng, iconURL, iconWidth, iconHeight, anchor.x, anchor.y, title, description, showMarkerWindow);
      }
    }
    
    /**
     * Show all overlays
     */
    public function showOverlays():void
    {
      if (_mapInitialized)
      {
        callJSFunction('showOverlays');
      }
      
      _overlayVisible = true;
    }
    
    /**
     * Hide all overlays
     */
    public function clearOverlays():void
    {
      if (_mapInitialized)
      {
        callJSFunction('clearOverlays');
      }
      
      _overlayVisible = false;
    }
    
    /**
     * Delete all overlays
     */
    public function deleteOverlays():void
    {
      if (_mapInitialized)
      {
        callJSFunction('deleteOverlays');
      }
    }
    
    public function fitToMarkers():void
    {
      if (_mapInitialized)
      {
        callJSFunction('fitToMarkers');
      }
    }
    
    /**
     * Know if the map is initialized or not
     */
    public function get mapInitialized():Boolean
    {
      return _mapInitialized;
    }
    
    /**
    * @private
    * Add a js callback
    */
    private function addCallBack(key:String, func:Function):void
    {
      _callbacks[key] = func;
    }
    
    /**
     * @private
     * Apply a callback from JS
     */
    private function applyCallBack(jSonArgs:String):void
    {
      //iOS don't link when we put jSON directly in URl, so we convert it in Base64...
      var base64Encoder:Base64Decoder = new Base64Decoder();
      base64Encoder.decode(jSonArgs);
      var ba:ByteArray = base64Encoder.toByteArray();
      
      var serializeObject:Object = JSON.parse(ba.readUTFBytes(ba.length));
      
      var func:Function = _callbacks[serializeObject.method];
      
      if (debugMode)
      {
        trace("applyCallBack", serializeObject.method);
      }
      
      if (func != null)
      {
        func.apply(null, serializeObject.arguments);
      }
    }
    
    /**
     * @private
     * Call a JS function
     */
    public function callJSFunction(functionName:String, ... arguments):void
    {
      if (!_mapInitialized)
      {
        return;
      }
      
      if (debugMode)
      {
        trace("callJSFunction", functionName, arguments);
      }
      
      var serializeObject:Object = {};
      serializeObject.method = functionName;
      serializeObject.arguments = arguments;
      
      var jSonArgs:String = JSON.stringify(serializeObject);
      
      //iOS don't link when we put jSON directly in URl, so we convert it in Base64...
      var base64Encoder:Base64Encoder = new Base64Encoder();
      base64Encoder.encode(jSonArgs, 0, jSonArgs.length);
      var argsEncoded:String = base64Encoder.toString();
      argsEncoded = argsEncoded.split("\n").join("");
      
      webView.loadURL("javascript:doCall('" + argsEncoded + "')");
    }
  
  }
}
