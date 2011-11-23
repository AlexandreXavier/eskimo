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
  
  /**
  * Object use to check the properties in the tests case.
  */
  public final class PropertyData
  {
    private var _propertyName:String;
    private var _propertyValue:Object;
    
    /**
    * Constructor
    */
    public function PropertyData(propertyName:String, propertyValue:Object)
    {
      _propertyName = propertyName;
      _propertyValue = propertyValue;
    }
    
    /**
    * The value of the property
    */
    public function get propertyValue():Object
    {
      return _propertyValue;
    }
    
    /**
    * @private
    */
    public function set propertyValue(value:Object):void
    {
      _propertyValue = value;
    }
    
    /**
    * The name of the property
    */
    public function get propertyName():String
    {
      return _propertyName;
    }
    
    /**
    * @private
    */
    public function set propertyName(value:String):void
    {
      _propertyName = value;
    }
  
  }
}
