package com.piaction.utils
{
  import flash.globalization.DateTimeStyle;
  
  import spark.formatters.DateTimeFormatter;
  import spark.globalization.StringTools;

  public class DateUtils
  {
    public function DateUtils()
    {
    }
    
    private static var _dateTimeFormatter:DateTimeFormatter = new DateTimeFormatter();
    
    public static const DAY_CHAR:String = "d";
    
    public static const MONTH_CHAR:String = "M";
    
    public static const YEAR_CHAR:String = "y";
    
    public function numberDayInMonth(month:Number, year:Number):int
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
    
    public function isLeapYear(year:Number):Boolean
    {
      return (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0));
    }
    
    public function format(date:Date, dateTimePattern:String = null):String
    {
      if(dateTimePattern == null)
      {
        dateTimePattern = _dateTimeFormatter.dateTimePattern;
      }
      _dateTimeFormatter.dateTimePattern = "MMM";
      return _dateTimeFormatter.format(date);
    }
    
    public function formatMonth(month:int, mPattern:String):String
    {
      var date:Date = new Date();
      date.date = 1;
      date.month = month - 1;

      _dateTimeFormatter.dateTimePattern = mPattern;
      return _dateTimeFormatter.format(date);
    }
   
    public function formatDay(day:Number, dPattern:String):String
    {
      if(dPattern == null)
      {
        return "" + day;
      }
      var patternSize:int = dPattern.length;

      return formatTwoDigits(day, patternSize);
    }
    
    public function formatYear(year:Number, yPattern:String):String
    {
      if(yPattern == null)
      {
        return "" + year;
      }
      var patternSize:int = yPattern.length;
      if(patternSize <= 2)
      {
        year = year - 100 * Math.floor(year / 100);
      }
      return formatTwoDigits(year, patternSize);
    }
    
    private function formatTwoDigits(value:int, patternSize:int):String
    {
      var valueStr:String;
      if(value < 10 && patternSize == 2)
      {
        valueStr = "0" + value;
      }
      else
      {
        valueStr = "" + value;
      }
      return valueStr;
    }
    
    public function dayPattern(dayPattern:String = null):String
    {
      return retrievePattern(DAY_CHAR, dayPattern);
    }
    
    public function monthPattern(datePattern:String = null):String
    {
      return retrievePattern(MONTH_CHAR, datePattern);
    }
    
    public function yearPattern(yearPattern:String = null):String
    {
      return retrievePattern(YEAR_CHAR, yearPattern);
    }
    
    private function retrievePattern(ch:String , datePattern:String = null):String
    {
/*      if(datePattern == null)
      {
        datePattern = _dateTimeFormatter.dateTimePattern;
      }*/
      var patternMaxIndex:int = datePattern.length - 1;
      var patternIndex:int = datePattern.indexOf(ch);
      var foundChar:Boolean = patternIndex > -1;
      
      if(foundChar)
      {
        var pattern:String = ch;
        patternIndex++;
        while(patternMaxIndex >= patternIndex && (datePattern.charAt(patternIndex) == ch))
        {
          patternIndex++;
          pattern += ch;
        }
        return pattern;
      }
      return null;
    }
  }
}