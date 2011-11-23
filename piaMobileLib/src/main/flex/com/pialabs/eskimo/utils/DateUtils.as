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
package com.pialabs.eskimo.utils
{
  import flash.globalization.DateTimeFormatter;
  import flash.globalization.LocaleID;

  public class DateUtils
  {
    public function DateUtils()
    {
    }
    
    public static var dateTimeFormatter:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
    
    public static var defaultDateTimePattern:String = dateTimeFormatter.getDateTimePattern();
    
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
        dateTimePattern = dateTimeFormatter.getDateTimePattern();
      }
      dateTimeFormatter.setDateTimePattern("MMM");
      return dateTimeFormatter.format(date);
    }
    
    public function formatShortMonth(month:int, mPattern:String):String
    {
      var date:Date = new Date();
      date.date = 1;
      date.month = month - 1;

      dateTimeFormatter.setDateTimePattern(mPattern);

      return dateTimeFormatter.format(date);
    }
   
    public function formatDay(day:Number, dPattern:String):String
    {
      if(dPattern == null)
      {
        return day.toString();
      }
      var patternSize:int = dPattern.length;

      return formatTwoDigits(day, patternSize);
    }
    
    public function formatYear(year:Number, yPattern:String):String
    {
      if(yPattern == null)
      {
        return year.toString();
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
        valueStr = value.toString();
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