package com.pialabs.eskimo.events
{
  import flash.events.Event;

  public class MobileCalendarEvent extends Event
  {
    public static const NEXT_MONTH_CLICKED:String = "nextMonthClicked";
    public static const NEXT_YEAR_CLICKED:String = "nextYearClicked";
    public static const PRV_MONTH_CLICKED:String = "prvMonthClicked";
    public static const PRV_YEAR_CLICKED:String = "prvYearClicked";
    
    public function MobileCalendarEvent(type:String)
    {
      super(type);
    }
    
    // Override the inherited clone() method.
    override public function clone():Event {
      return new MobileCalendarEvent(type);
    }
  }
}