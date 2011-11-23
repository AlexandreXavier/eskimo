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