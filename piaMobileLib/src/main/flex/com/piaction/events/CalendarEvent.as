package com.piaction.events
{
  import flash.events.Event;
  import flash.geom.Rectangle;
  
  import mx.core.UIComponent;
  import com.piaction.components.CalendarItem;
  
  /**
  * Event dispatch by Calendar component
  */
  public class CalendarEvent extends Event
  {
    /**
     * An activity have been added
     */
    public static const ACTIVITY_ADDED:String = "activityAdded";
    /**
     * An activity have been clicked
     */
    public static const ACTIVITY_CLICK:String = "activityClick";
    /**
     * An activity have been downed
     */
    public static const ACTIVITY_DOWN:String = "activityDown";
    /**
     * An activity have been double clicked
     */
    public static const ACTIVITY_DOUBLE_CLICK:String = "activityDoubleClick";
    
    /**
     * start date
     */
    public var startDate:Date;
    /**
     * end date
     */
    public var endDate:Date;
    /**
     * x position of the activity
     */
    public var startX:int;
    /**
     * y position of the activity
     */
    public var startY:int;
    /**
     * x position of the activity end
     */
    public var endX:int;
    /**
     * x position of the activity end
     */
    public var endY:int;
    
    /**
     * Current item renderer
     */
    public var itemRenderer:CalendarItem;
    
    /**
    * Constructor
    */
    public function CalendarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
    /**
     * Constructor
     */
    public static function newAddedActivityEvent(calendarItem:CalendarItem):CalendarEvent
    {
      var event:CalendarEvent = new CalendarEvent(ACTIVITY_ADDED);
      initEventFromCalendarItem(event, calendarItem);
      
      return event;
    }
    /**
     * Constructor
     */
    public static function newClickActivityEvent(calendarItem:CalendarItem):CalendarEvent
    {
      var event:CalendarEvent = new CalendarEvent(ACTIVITY_CLICK);
      initEventFromCalendarItem(event, calendarItem);
      
      return event;
    }
    /**
     * Create a new down event
     */
    public static function newDownActivityEvent(calendarItem:CalendarItem):CalendarEvent
    {
      var event:CalendarEvent = new CalendarEvent(ACTIVITY_DOWN);
      initEventFromCalendarItem(event, calendarItem);
      
      return event;
    }
    /**
     * Create a new click event
     */
    public static function newDoubleClickActivityEvent(calendarItem:CalendarItem):CalendarEvent
    {
      var event:CalendarEvent = new CalendarEvent(ACTIVITY_DOUBLE_CLICK);
      initEventFromCalendarItem(event, calendarItem);
      
      return event;
    }
    /**
     * init an event with an activity
     */
    private static function initEventFromCalendarItem(event:CalendarEvent, calendarItem:CalendarItem):void
    {
      var bound:Rectangle = calendarItem.getBounds(calendarItem.stage);
      event.startDate = calendarItem.startDate;
      event.endDate = calendarItem.endDate;
      event.startX = bound.x;
      event.startY = bound.y;
      event.endX = bound.x + bound.width,
      event.endY = bound.y + bound.height
      event.itemRenderer = calendarItem;
    }
    /**
    * @private
    */
    override public function clone():Event
    {
      var event:CalendarEvent = new CalendarEvent(this.type, this.bubbles);

      event.startDate = this.startDate;
      event.endDate = this.endDate;
      event.startX = this.startX;
      event.startY = this.startY;
      event.endX = this.endX;
      event.endY = this.endY;
      event.itemRenderer = this.itemRenderer;
      
      return event;
    }
    
  }
}