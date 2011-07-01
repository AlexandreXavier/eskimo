package com.piaction.components
{
  import com.piaction.layouts.SlideLayout;
  
  import flash.events.Event;
  import flash.events.TransformGestureEvent;
  
  import mx.binding.utils.BindingUtils;
  import mx.events.IndexChangedEvent;
  
  import spark.components.DataGroup;
  import spark.components.SkinnableContainer;
  import spark.events.IndexChangeEvent;
  import spark.layouts.supportClasses.LayoutBase;
  
  /**
   * SlideDataGroup is a DataGroup which enable Swipe between the elements.
   * Slide Container can only have a SlideLayout layout.
   *
   */
  public class SlideDataGroup extends DataGroup
  {
    /**
     * Specifies a vertical direction for elements.
     */
    public static const VERTICAL:String = "vertical";
    /**
     * Specifies left-to-right direction for elements.
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
    
    private var _selectedIndex:int = 0;
    
    
    public function SlideDataGroup()
    {
      super();
      super.layout = new SlideLayout();
      addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
      slideLayout.addEventListener("indexChanged", onIndexChanged);
    
    }
    
    /**
     * @private
     */
    override public function set layout(value:LayoutBase):void
    {
      if (value is SlideLayout)
      {
        super.layout = value;
        layout.addEventListener("indexChanged", onIndexChanged);
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
      return slideLayout.orientation;
    }
    
    /**
     * @private
     */
    public function set orientation(value:String):void
    {
      slideLayout.orientation = value;
    }
    
    /**
     * Direction of the slide SlideContainer.NORMAL or SlideContainer.REVERSE
     */
    public function get direction():int
    {
      return slideLayout.direction;
    }
    
    /**
     * @private
     */
    public function set direction(value:int):void
    {
      slideLayout.direction = value;
    }
    
    /**
    * The index of the selected item.
    */
    [Bindable('indexChanged')]
    public function get selectedIndex():int
    {
      return slideLayout.index;
    }
    
    /**
    * @private
    */
    public function set selectedIndex(value:int):void
    {
      if (value != slideLayout.index)
      {
        slideLayout.index = value;
      }
    }
    
    /**
    * The selected item.
    */
    public function get selectedItem():*
    {
      return dataProvider.getItemAt(selectedIndex);
    }
    
    /**
    * Number of the items to display.
    */
    public function get count():int
    {
      return dataProvider.length;
    }
    
    public function next():void
    {
      slideLayout.index += slideLayout.direction;
    }
    
    public function previous():void
    {
      slideLayout.index -= slideLayout.direction;
    }
    
    /**
     * @private
     */
    private function onSwipe(event:TransformGestureEvent):void
    {
      var lt:SlideLayout = layout as SlideLayout;
      if (event.offsetX != 0)
      {
        lt.index -= slideLayout.direction * event.offsetX;
      }
      
      if (event.offsetY != 0)
      {
        lt.index -= slideLayout.direction * event.offsetY;
      }
    }
    
    private function get slideLayout():SlideLayout
    {
      return (layout as SlideLayout);
    }
    
    protected function onIndexChanged(event:Event):void
    {
      dispatchEvent(new Event("indexChanged"));
    }
  }
}
