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
  
  /**
   * Event for MobileContextMenu
   */
  public class MobileContextMenuEvent extends Event
  {
    /**
     * Menu item Clicked
     */
    public static const MENU_ITEM_CLICKED:String = "menuItemClicked";
    
    /**
     * itemClicked
     */
    public var menuItem:Object;
    
    /**
     * @Constructor
     */
    public function MobileContextMenuEvent(type:String, menuItem:Object, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      this.menuItem = menuItem;
      super(type, bubbles, cancelable);
    }
  }
}