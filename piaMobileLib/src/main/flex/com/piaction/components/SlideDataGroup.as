package com.piaction.components
{
  import com.piaction.layouts.SlideLayout;
  
  import flash.events.TransformGestureEvent;
  
  import spark.components.DataGroup;
  import spark.components.SkinnableContainer;
  import spark.layouts.supportClasses.LayoutBase;
  
  /**
   * SlideDataGroup is a DataGroup which enable Swipe bitween elements
   */
  public class SlideDataGroup extends DataGroup
  {
    /**
     * Oriantation vertival
     */
    public static const VERTICAL:String = "vertical";
    /**
     * Oriantation horizontal
     */
    public static const HORIZONTAL:String = "horizontal";
    /**
     * Direction normal
     */
    public static const NORMAL:int = 1;
    /**
     * Direction reverse
     */
    public static const REVERSE:int = -1;
    
    public function SlideDataGroup()
    {
      super();
      super.layout = new SlideLayout();
      addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe)
    }
    
    /**
     * @private
     */
    override public function set layout(value:LayoutBase):void
    {
      if( value is SlideLayout )
      {
        super.layout = value;
      }
      else
      {
        throw(new Error("Slide Container can only have a SlideLayout layout"));
      }
    }
    
    /**
     * Oriantation of the slide SlideContainer.VERTICAL or SlideContainer.HORIZONTAL
     */
    public function get orientation():String
    {
      return (layout as SlideLayout).orientation;
    }
    
    /**
     * @private
     */
    public function set orientation(value:String):void
    {
      (layout as SlideLayout).orientation = value;
    }
    
    /**
     * Direction of the slide SlideContainer.NORMAL or SlideContainer.REVERSE
     */
    public function get direction():int
    {
      return (layout as SlideLayout).direction;
    }
    
    /**
     * @private
     */
    public function set direction(value:int):void
    {
      (layout as SlideLayout).direction = value;
    }
    
    /**
     * @private
     */
    private function onSwipe(event:TransformGestureEvent):void
    {
      var lt:SlideLayout = layout as SlideLayout;
      if (event.offsetX != 0)
      {
          lt.index -= (layout as SlideLayout).direction * event.offsetX;
      }
      
      if (event.offsetY != 0)
      {
          lt.index -= (layout as SlideLayout).direction* event.offsetY;
      }
    }
  }
}