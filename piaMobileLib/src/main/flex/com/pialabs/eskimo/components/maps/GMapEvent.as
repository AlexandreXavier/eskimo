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
package com.pialabs.eskimo.components.maps
{
  import flash.events.Event;
  
  /**
  * Event dispatch by GMap component
  */
  public class GMapEvent extends Event
  {
    public static const MARKER_CLICKED:String = "markerClicked";
    public static const BOUNNDS_CHANGED:String = "boundsChanged";
    
    public var lat:Number;
    public var lng:Number;
    public var zoom:Number;
    
    public function GMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
      super(type, bubbles, cancelable);
    }
  }
}
