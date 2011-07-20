package com.pialabs.eskimo.components
{
  import com.pialabs.eskimo.layouts.CircularLayout;
  
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.utils.getTimer;
  
  import mx.events.EffectEvent;
  import mx.events.SandboxMouseEvent;
  
  import spark.components.List;
  import spark.effects.Animate;
  import spark.effects.animation.MotionPath;
  import spark.effects.animation.SimpleMotionPath;
  import spark.effects.easing.EasingFraction;
  import spark.layouts.supportClasses.LayoutBase;
  
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
    
    /**
     * @private
     */
    private function onMouseDown(event:MouseEvent):void
    {
      mouseDownX = this.mouseX;
      mouseDownY = this.mouseY;
      
      clearHistory();
      dataGroup.filters = null;
      _animateThrow.stop();
      
      var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
      
      sbRoot.addEventListener(Event.ENTER_FRAME, onEnterFrame);
      sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onMouseUp);
      sbRoot.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      
      // this is the point from which all deltas are based.
      startTime = getTimer();
    }
    
    /**
     * @private
     */
    private function onEnterFrame(event:Event):void
    {
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
    private function onMouseUp(event:Event):void
    {
      var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
      
      sbRoot.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
      
      sbRoot.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      
      throwScroll();
    }
    
    /**
     * @private
     * Move history cleaning.
     */
    private function clearHistory():void
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
    private function throwScroll():void
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
      
      //set the SimpleMotionPath to the Animate Object
      _animateThrow.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateThrow.motionPaths = smps;
      _animateThrow.duration = duration;
      _animateThrow.play([(layout as CircularLayout)]); //run the animation
    }
    
    /**
     * Get the current velovity of the movment.
     */
    public function get currentVelocity():Number
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
  }
}
