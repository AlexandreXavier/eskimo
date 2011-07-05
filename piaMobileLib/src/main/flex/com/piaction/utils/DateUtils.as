package com.piaction.utils
{
  public class DateUtils
  {
    public function DateUtils()
    {
    }
    
    public static function numberDayInMonth(month:Number, year:Number):int
    {
      var numberDay:int = 0;

      if(month == 4 || month == 6 || month == 9 || month == 11)
      {
        return 30;
      }
      else if(month == 2)
      {
        if(isLeapYear(year))
        {
          return 29;
        }
        return 28;
      }
      else
      {
        return 31;
      }
    }
    
    public static function isLeapYear(year:Number):Boolean
    {
      return (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0));
    }
  }
}