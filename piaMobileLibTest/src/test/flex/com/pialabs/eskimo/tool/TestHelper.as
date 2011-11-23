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
package com.pialabs.eskimo.tool
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import flexunit.framework.Assert;
  
  public class TestHelper
  {
    /**
    * Check if the specified property value matches with the value of the target.
    *
    * @param propertyData
    *           the object used to define the property name and value to check
    * @param target
    *           the object used to check the property
    */
    public static function handleVerifyProperty(propertyData:Object, target:Object):void
    {
      Assert.assertEquals(propertyData.propertyValue, target[propertyData.propertyName]);
    }
  
  }
}
