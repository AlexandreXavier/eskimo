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
package com.pialabs.eskimo.components
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import mx.core.FlexGlobals;
  import mx.core.mx_internal;
  import mx.events.FlexEvent;
  import mx.managers.PopUpManager;
  
  import org.osmf.events.TimeEvent;
  
  import spark.components.Label;
  import spark.components.supportClasses.SkinnableComponent;
  
  use namespace mx_internal;
  
  /**
  * Margin to the top of the screen
  */
  [Style(name = "marginTop", inherit = "no", type = "Number")]
  /**
   * Margin to the bottom of the screen
   */
  [Style(name = "marginBottom", inherit = "no", type = "Number")]
  /**
   * Margin to the left of the screen
   */
  [Style(name = "marginLeft", inherit = "no", type = "Number")]
  /**
   * Margin to the right of the screen
   */
  [Style(name = "marginRight", inherit = "no", type = "Number")]
  
  [SkinState("normal")]
  [SkinState("closed")]
  
  /**
  * A toast is a component containing a quick little message for the user. The toast class helps you create and show those.
  * When the toast is shown to the user, appears as a floating component over the application. It will never receive focus.
  */
  public class Toast extends SkinnableComponent
  {
    [SkinPart(required = "true")]
    public var labelDisplay:Label;
    
    /**
     * @private
     */
    protected var _label:String;
    protected var _duration:int = 1000;
    
    /**
     * @private
     */
    protected var _displayTimer:Timer;
    protected var _opened:Boolean;
    protected var _gravity:uint = BOTTOM | HORIZONTAL_CENTER;
    protected var _xOffset:Number = 0;
    protected var _yOffset:Number = 0;
    
    /**
     * Top position
     */
    public static const TOP:uint = 0x0001;
    /**
     * Bottom position
     */
    public static const BOTTOM:uint = 0x0002;
    /**
     * Vertical center position
     */
    public static const VERTICAL_CENTER:uint = 0x0004;
    /**
     * Left position
     */
    public static const LEFT:uint = 0x0008;
    /**
     * Right position
     */
    public static const RIGHT:uint = 0x0010;
    /**
     * Horizontal center position
     */
    public static const HORIZONTAL_CENTER:uint = 0x0020;
    
    /**
     * @private
     */
    protected static var _toastQueue:Vector.<Toast>;
    protected static var _currentToastDisplayed:Toast;
    
    /**
     * Constructor
     */
    public function Toast()
    {
      super();
      
      mouseChildren = mouseEnabled = false;
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      if (instance == labelDisplay)
      {
        labelDisplay.text = _label;
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      var paddingTop:Number = getStyle("marginTop");
      var paddingBottom:Number = getStyle("marginBottom");
      
      var horizontalAlign:String = getStyle("horizontalAlign");
      var paddingLeft:Number = getStyle("marginLeft");
      var paddingRight:Number = getStyle("marginRight");
      
      var toastX:Number = 0;
      var toastY:Number = 0;
      
      if (_gravity & TOP)
      {
        toastY = paddingTop;
      }
      else if (_gravity & VERTICAL_CENTER)
      {
        toastY = (parent.height - unscaledHeight) / 2;
      }
      else
      {
        toastY = parent.height - unscaledHeight - paddingBottom;
      }
      
      if (_gravity & LEFT)
      {
        toastX = paddingLeft;
      }
      else if (_gravity & RIGHT)
      {
        toastX = parent.width - unscaledWidth - paddingRight;
      }
      else
      {
        toastX = (parent.width - unscaledWidth) / 2;
      }
      
      toastX -= _xOffset;
      toastY -= _yOffset;
      
      setLayoutBoundsPosition(toastX, toastY);
    }
    
    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
      var skinState:String;
      
      if (_opened)
      {
        skinState = "normal";
      }
      else
      {
        skinState = "closed";
      }
      
      return skinState;
    }
    
    /**
     * Add a new Toast in the diplay queue.
     * If it is the first element of the queue, the toast is directly displayed
     */
    public static function show(label:String, duration:int = 2000):Toast
    {
      var toast:Toast = new Toast();
      
      toast.label = label;
      toast.duration = duration;
      
      if (_currentToastDisplayed == null)
      {
        _currentToastDisplayed = toast;
        toast.displayNow();
      }
      else
      {
        queueToast(toast);
      }
      
      return toast;
    }
    
    /**
     * @private
     */
    protected static function queueToast(toast:Toast):void
    {
      if (_toastQueue == null)
      {
        _toastQueue = new Vector.<Toast>();
      }
      _toastQueue.push(toast);
    }
    
    /**
     * @private
     */
    protected static function displayNextToast():void
    {
      if (_toastQueue == null)
      {
        _currentToastDisplayed = null;
      }
      else
      {
        var toast:Toast = _toastQueue.shift();
        
        if (toast)
        {
          _currentToastDisplayed = toast;
          toast.displayNow();
        }
        else
        {
          _currentToastDisplayed = null;
        }
      }
    }
    
    /**
     * @private
     */
    mx_internal function displayNow():void
    {
      PopUpManager.addPopUp(this, FlexGlobals.topLevelApplication.systemManager.getSandboxRoot());
      
      _displayTimer = new Timer(_duration, 1);
      _displayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
      _displayTimer.start();
      
      addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    
    }
    
    /**
     * @private
     */
    protected function onCreationComplete(event:FlexEvent):void
    {
      removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
      
      _opened = true;
      invalidateSkinState();
    }
    
    /**
     * @private
     */
    protected function onTimerComplete(event:Event):void
    {
      _opened = false;
      
      _displayTimer.stop();
      _displayTimer.removeEventListener(TimeEvent.COMPLETE, onTimerComplete);
      
      skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onCloseComplete);
      
      invalidateSkinState();
    }
    
    /**
     * @private
     */
    protected function onCloseComplete(event:FlexEvent):void
    {
      skin.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onCloseComplete);
      
      
      PopUpManager.removePopUp(this);
      
      
      Toast.displayNextToast();
    }
    
    /**
     * Toast label
     */
    public function get label():String
    {
      return _label;
    }
    
    /**
     * @private
     */
    public function set label(value:String):void
    {
      _label = value;
      
      if (labelDisplay)
      {
        labelDisplay.text = value;
      }
    }
    
    /**
     * Toast display duration
     */
    public function get duration():int
    {
      return _duration;
    }
    
    /**
     * @private
     */
    public function set duration(value:int):void
    {
      _duration = value;
      
      if (_displayTimer)
      {
        _displayTimer.delay = value;
      }
    }
    
    /**
    * @private
    */
    override protected function measure():void
    {
      super.measure();
      
      var rootDisplayObject:DisplayObject = FlexGlobals.topLevelApplication.systemManager.getSandboxRoot();
      
      var paddingLeft:Number = getStyle("marginLeft");
      var paddingRight:Number = getStyle("marginRight");
      
      maxWidth = rootDisplayObject.width - paddingLeft - paddingRight;
    }
    
    /**
     * Set the location at which the notification should appear on the screen.
     * @default Toast.BOTTOM|Toast.HORIZONTAL_CENTER
     */
    public function setGravity(value:uint, xOffset:Number = 0, yOffset:Number = 0):void
    {
      _gravity = value;
      
      _xOffset = xOffset;
      _yOffset = yOffset;
      
      invalidateDisplayList();
    }
    
    /**
    * Close the view if it's showing, or don't show it if it isn't showing yet.
    */
    public function cancel():void
    {
      if (_toastQueue)
      {
        var index:int = _toastQueue.indexOf(this);
        
        if (index != -1)
        {
          _toastQueue.splice(index, 1);
        }
      }
      
      if (_displayTimer.running)
      {
        onTimerComplete(null);
      }
    }
  
  }
}
