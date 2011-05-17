package com.piaction.components
{
  /**
   * Time item of the Calendar Component
   */
  public class TimeItem
  {
    /**
     * Hour field
     */
    public var hours:int;
    /**
     * Minute field
     */
    public var minutes:int;
    
    /**
     * Constructor
     */
    public function TimeItem(hours:int, minutes:int)
    {
      this.hours = hours;
      this.minutes = minutes;
    }
    
    /**
     * Label getter
     */
    public function get label():String
    {
      
      if (hours == -1 && minutes == -1)
      {
        return "";
      }
      var hStr:String = "" + hours;
      var mStr:String = minutes>9 ? "" + minutes : "0" + minutes;
      
      
      return hStr+":"+mStr;
    }
    
  }
}