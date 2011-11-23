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
  import com.pialabs.eskimo.layouts.CircularLayout;
  
  import flash.display.DisplayObject;
  import flash.display.InteractiveObject;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.utils.getTimer;
  
  import mx.core.mx_internal;
  import mx.events.EffectEvent;
  import mx.events.ItemClickEvent;
  import mx.events.SandboxMouseEvent;
  
  import spark.components.List;
  import spark.effects.Animate;
  import spark.effects.animation.MotionPath;
  import spark.effects.animation.SimpleMotionPath;
  import spark.effects.easing.EasingFraction;
  import spark.layouts.supportClasses.LayoutBase;
  
  use namespace mx_internal;
  
  [Event(name = "itemClick", type = "mx.events.ItemClickEvent")]
  
  /**
  * CarrouselList is a list that display a carrousel.
  * @see com.pialabs.eskimo.layouts.CircularLayout
  */
  public class CarouselList extends List
  {
    /**
    * @private
    */
    protected var mouseDownX:Number;
    /**
    * @private
    */
    protected var originalMouseDownX:Number;
    /**
     * @private
     */
    protected var mouseDownY:Number;
    
    /**
     * @private
     */
    public static const EVENT_HISTORY_LENGTH:int = 5;
    /**
     * @private
     */
    public static const ANGLE_SENSIBILITY:int = 500;
    /**
     * @private
     */
    public static const MAX_VELOCITY:Number = 0.7;
    /**
     * @private
     */
    public static const TOUCH_SENSIBILITY:Number = 10;
    /**
     * @private
     */
    private var isThrowing:Boolean;
    
    /**
     * @private
     * History of EVENT_HISTORY_LENGTH last mouse positions.
     */
    private var mouseEventCoordinatesHistory:Vector.<Point>;
    
    /**
     * @private
     * History of EVENT_HISTORY_LENGTH last mouse positions.
     */
    private var mouseEventTimeHistory:Vector.<int>;
    
    /**
     * @private
     * Current position on histories arrays.
     */
    private var mouseEventLength:Number = 0;
    
    /**
     * @private
     * StartTime of historisation.
     */
    private var startTime:int;
    
    /**
     * @private
     * Roll animations.
     */
    private var _animateThrow:Animate = new Animate();
    private var _animate:Animate = new Animate();
    
    private var _selectedItemChanged:Boolean;
    
    /**
     * @private
     * Scroll velovity (px/ms).
     */
    private var _currentVelocity:Number;
    
    /**
     * Constructor
     */
    public function CarouselList()
    {
      super();
      
      super.layout = new CircularLayout();
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      
      mouseEventCoordinatesHistory = new Vector.<Point>(EVENT_HISTORY_LENGTH);
      mouseEventTimeHistory = new Vector.<int>(EVENT_HISTORY_LENGTH);
    }
    
    override protected function commitProperties():void
    {
      if (selectedIndex == -1)
      {
        selectedIndex = 0;
      }
      
      ensureIndexIsVisible(_proposedSelectedIndex);
      
      super.commitProperties();
    }
    
    
    /**
     * @private
     */
    protected function onMouseDown(event:MouseEvent):void
    {
      mouseDownX = originalMouseDownX = this.mouseX;
      mouseDownY = this.mouseY;
      
      clearHistory();
      dataGroup.filters = null;
      _animateThrow.stop();
      _animate.stop();
      
      var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
      
      sbRoot.addEventListener(Event.ENTER_FRAME, onEnterFrame);
      sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onMouseUp);
      sbRoot.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      
      // this is the point from which all deltas are based.
      startTime = getTimer();
      
      isThrowing = false;
    }
    
    /**
     * @private
     */
    protected function onEnterFrame(event:Event):void
    {
      if (Math.abs(this.mouseX - originalMouseDownX) > TOUCH_SENSIBILITY)
      {
        isThrowing = true;
      }
      
      (layout as CircularLayout).angle -= (this.mouseX - mouseDownX) * Math.PI / ANGLE_SENSIBILITY;
      
      
      var currentIndex:int = (mouseEventLength % EVENT_HISTORY_LENGTH);
      
      // add time history as well
      mouseEventTimeHistory[currentIndex] = getTimer() - startTime;
      mouseEventCoordinatesHistory[currentIndex] = new Point(0, (mouseDownX - this.mouseX));
      
      // increment current length if appropriate
      mouseEventLength++;
      
      startTime = getTimer();
      
      
      mouseDownX = this.mouseX;
      mouseDownY = this.mouseY;
    }
    
    /**
     * @private
     */
    protected function onMouseUp(event:Event):void
    {
      var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
      
      sbRoot.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
      
      sbRoot.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onMouseUp);
      
      throwScroll();
    }
    
    /**
     * @private
     * Move history cleaning.
     */
    protected function clearHistory():void
    {
      for (var i:int = 0; i < EVENT_HISTORY_LENGTH; i++)
      {
        mouseEventCoordinatesHistory[i] = null;
        mouseEventTimeHistory[i] = null;
      }
    }
    
    /**
     * Throw the list thanks to the move histories to compute the velocity.
     */
    protected function throwScroll():void
    {
      var currentIndex:int = (mouseEventLength % EVENT_HISTORY_LENGTH);
      
      mouseEventTimeHistory[currentIndex] = getTimer() - startTime;
      mouseEventCoordinatesHistory[currentIndex] = new Point(0, (mouseDownX - this.mouseX));
      
      var duration:int = Math.abs(2000 * currentVelocity);
      
      var newAngle:Number = (layout as CircularLayout).angle + (currentVelocity * duration) * Math.PI / ANGLE_SENSIBILITY;
      
      var smp:SimpleMotionPath = new SimpleMotionPath("angle");
      smp.valueFrom = (layout as CircularLayout).angle;
      smp.valueTo = newAngle;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animateThrow.addEventListener(EffectEvent.EFFECT_END, onThrowEnd);
      
      //set the SimpleMotionPath to the Animate Object
      _animateThrow.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateThrow.motionPaths = smps;
      _animateThrow.duration = duration;
      _animateThrow.play([(layout as CircularLayout)]); //run the animation
    }
    
    
    /**
     * @private
     */
    protected function onThrowEnd(event:Event):void
    {
      scrollToItem();
    }
    
    /**
     * Get the current velovity of the movment.
     */
    protected function get currentVelocity():Number
    {
      var dist:Number = 0;
      var time:Number = 0;
      for (var i:int = 0; i < EVENT_HISTORY_LENGTH; i++)
      {
        if (mouseEventCoordinatesHistory[i])
        {
          dist += mouseEventCoordinatesHistory[i].y;
          time += mouseEventTimeHistory[i];
        }
      }
      
      dist /= EVENT_HISTORY_LENGTH;
      time /= EVENT_HISTORY_LENGTH;
      
      _currentVelocity = (dist / time);
      _currentVelocity = Math.max(-MAX_VELOCITY, _currentVelocity);
      _currentVelocity = Math.min(MAX_VELOCITY, _currentVelocity);
      
      return _currentVelocity;
    }
    
    /**
     * Layout can only be CircularLayout for the moment.
     * @see com.pialabs.eskimo.layouts.CircularLayout
     */
    override public function set layout(value:LayoutBase):void
    {
      if (value is CircularLayout)
      {
        super.layout = value;
      }
    }
    
    /**
     * @private
     */
    protected function scrollToItem():void
    {
      if (!layout || !dataProvider)
      {
        return;
      }
      
      // var newAngle:Number = index * 2 * Math.PI / dataProvider.length;
      
      var scrollIndex:int = getNearrestIndex();
      
      ensureIndexIsVisible(scrollIndex);
    }
    
    
    /**
     * @private
     */
    override public function ensureIndexIsVisible(index:int):void
    {
      if (dataGroup == null || dataProvider == null)
      {
        return;
      }
      
      _animateThrow.stop();
      _animate.stop();
      
      var newAngle:Number = index * 2 * Math.PI / dataProvider.length;
      
      if (absoluteAngle - newAngle > Math.PI)
      {
        newAngle += (Math.PI * 2);
      }
      else if (absoluteAngle - newAngle < -Math.PI)
      {
        newAngle -= (Math.PI * 2);
      }
      
      if (absoluteAngle == newAngle)
      {
        return;
      }
      
      var smp:SimpleMotionPath = new SimpleMotionPath("angle");
      smp.valueFrom = absoluteAngle;
      smp.valueTo = newAngle;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animate.addEventListener(EffectEvent.EFFECT_END, onRollEnd);
      
      //set the SimpleMotionPath to the Animate Object
      _animate.motionPaths = smps;
      
      _animate.play([layout]);
    }
    
    /**
     * @private
     */
    protected function onRollEnd(event:Event):void
    {
      if (isThrowing)
      {
        setSelectedIndex(getNearrestIndex(), true);
      }
    }
    
    override protected function mouseUpHandler(event:Event):void
    {
      if (isThrowing)
      {
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false);
        systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpHandler, false);
      }
      else
      {
        if (mouseDownIndex != -1)
        {
          var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK, true);
          e.item = dataProvider.getItemAt(mouseDownIndex);
          e.index = mouseDownIndex;
          e.relatedObject = mouseDownObject as InteractiveObject;
          dispatchEvent(e);
        }
        super.mouseUpHandler(event);
        
      }
    }
    
    /**
     * @private
     */
    protected function get elmementAngle():Number
    {
      var result:Number = 2 * Math.PI / dataProvider.length;
      return result;
    }
    
    /**
     * @private
     */
    public function get absoluteAngle():Number
    {
      var result:Number = (layout as CircularLayout).angle % (2 * Math.PI);
      if (result < 0)
      {
        result += 2 * Math.PI;
      }
      return result;
    }
    
    /**
     * @private
     */
    protected function getNearrestIndex():int
    {
      var index:int = (absoluteAngle + elmementAngle / 2) * dataProvider.length / (2 * Math.PI);
      return index;
    }
  
  }
}
