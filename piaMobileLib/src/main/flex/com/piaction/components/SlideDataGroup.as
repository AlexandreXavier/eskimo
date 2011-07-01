package com.piaction.components
{
  import com.piaction.layouts.SlideLayout;
  
  import flash.events.Event;
  import flash.events.TransformGestureEvent;
  
  import spark.components.DataGroup;
  import spark.layouts.supportClasses.LayoutBase;
  
  /**
   *  Dispatched when the index of the selected item changed.
   *
   * @eventType flash.events.Event
   */
  [Event(name = "selectedIndexChanged", type = "flash.events.Event")]
  
  /**
   * SlideDataGroup is a DataGroup which enable Swipe between the elements.
   * Slide Container can only have a SlideLayout layout.
   * It provides acces to the selected item and method to go to the next or previous item.
   *
   */
  public class SlideDataGroup extends DataGroup
  {
    /**
     * Specifies the vertical direction for elements.
     */
    public static const VERTICAL:String = "vertical";
    /**
     * Specifies the horizontal direction for elements.
     */
    public static const HORIZONTAL:String = "horizontal";
    /**
     * Direction normal (left to right or top to bottom)
     */
    public static const NORMAL:int = 1;
    /**
     * Direction reverse (right to left or bottom to top)
     */
    public static const REVERSE:int = -1;
    
    /**
    * Constructor
    */
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
    
    [Inspectable(type = "String", defaultValue = "horizontal", verbose = 1, enumeration = "horizontal, vertical")]
    /**
     * Orientation of the slide. It take only the values: SlideContainer.VERTICAL or SlideContainer.HORIZONTAL.
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
      if (value != slideLayout.orientation && (value == SlideDataGroup.VERTICAL || value == SlideDataGroup.HORIZONTAL))
      {
        slideLayout.orientation = value;
      }
    }
    
    [Inspectable(type = "int", defaultValue = "1", verbose = 1, enumeration = "1, -1")]
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
    [Bindable('selectedIndexChanged')]
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
    * @private
    */
    public function set selectedItem(value:*):void
    {
      slideLayout.index = dataProvider.getItemIndex(value);
    }
    
    /**
    * Number of the items to display.
    */
    public function get count():int
    {
      return dataProvider.length;
    }
    
    /**
    * Display the next item.
    */
    public function next():void
    {
      slideLayout.index += slideLayout.direction;
    }
    
    /**
     * display the previous item.
     */
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
    
    /**
    * @private
    */
    private function get slideLayout():SlideLayout
    {
      return (layout as SlideLayout);
    }
    
    /**
    * @private
    */
    private function onIndexChanged(event:Event):void
    {
      dispatchEvent(new Event("selectedIndexChanged"));
    }
  }
}
