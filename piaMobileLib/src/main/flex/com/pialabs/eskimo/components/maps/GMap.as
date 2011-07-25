package com.pialabs.eskimo.components.maps
{
  import com.adobe.serialization.json.JSON;
  
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.LocationChangeEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.media.StageWebView;
  import flash.system.Capabilities;
  import flash.utils.ByteArray;
  import flash.utils.Dictionary;
  
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
    * JS callback dictionnary
    */
    protected var _callbacks:Dictionary = new Dictionary(true);
    
    
    /**
    * Constructor
    */
    public function GMap()
    {
      super();
      
      var currentOS:String = Capabilities.os.toLocaleUpperCase();
      if (currentOS.lastIndexOf("QNX") != -1)
      {
        _fileTmp = File.createTempFile();
      }
      
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage, false, 0, true);
      
      webView = new StageWebView();
      
      webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChanging);
      
      addCallBack("onInitialized", onInitialized);
      addCallBack("onMarkerClicked", onMarkerClicked);
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
      webView.stage = null;
      
      var html:String = GMapHTMLTemplate.HTML_TEMPLATE.toString();
      
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
      
      if (currLocation.indexOf('message://[CallBack]') != -1)
      {
        applyCallBack(currLocation.split('message://[CallBack]')[1]);
        e.preventDefault();
      }
      else if (currLocation.indexOf('http://') != -1 || currLocation.indexOf('https://') != -1)
      {
        e.preventDefault();
      }
    
    }
    
    /**
     * @private
     */
    private function onWebViewReady(event:Event):void
    {
      webView.loadURL('javascript:');
      
      deleteTmpFiles();
    }
    
    /**
     * @private
     */
    private function onWebViewError(event:ErrorEvent):void
    {
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
      
      dispatchEvent(event);
    }
    
    /**
     * @private
     */
    private function onInitialized():void
    {
      _mapInitialized = true;
      
      webView.stage = this.stage;
      
      setCenter(_center.x, _center.y);
      zoom = _zoom;
      
      if (_overlayVisible)
      {
        showOverlays();
      }
      
      webView.stage = this.stage;
      
      dispatchEvent(new Event(Event.COMPLETE));
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
     * Zoom
     */
    public function set zoom(value:Number):void
    {
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
      
      if (_overlayVisible)
      {
        showOverlays();
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
      
      if (_overlayVisible)
      {
        showOverlays();
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
      var serializeObject:Object = JSON.decode(jSonArgs);
      
      var func:Function = _callbacks[serializeObject.method];
      
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
      var serializeObject:Object = {};
      serializeObject.method = functionName;
      serializeObject.arguments = arguments;
      
      var jSonArgs:String = JSON.encode(serializeObject);
      
      webView.loadURL("javascript:doCall('" + jSonArgs + "')");
    }
  
  }
}
