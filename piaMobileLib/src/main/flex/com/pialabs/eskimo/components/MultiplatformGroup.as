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
package com.pialabs.eskimo.components
{
  import flash.system.Capabilities;
  
  import mx.core.IVisualElement;
  import mx.core.UIComponent;
  
  import spark.components.Group;
  
  /**
   * Group container that render children for a specfic platform (ios, android, qnx).
   */
  public class MultiplatformGroup extends Group
  {
    /**
     * IOS platform
     */
    public static const IOS:String = "IOS";
    /**
     * Android platform
     */
    public static const ANDROID:String = "AND";
    /**
     * QNX platform
     */
    public static const QNX:String = "QNX";
    
    /**
     * @private
     */
    protected var _type:String = ANDROID;
    
    /**
     * @private
     */
    protected var _typeChanged:Boolean = true;
    
    /**
     * @private
     */
    protected var _systemType:String;
    
    /**
     * @private
     */
    protected var _switchable:Boolean;
    
    /**
     * @private
     */
    protected var _childrens:Vector.<UIComponent> = new Vector.<UIComponent>();
    
    /**
     * @private
     */
    public function MultiplatformGroup()
    {
      super();
      
      _systemType = Capabilities.version.substr(0, 3).toLocaleUpperCase();
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_typeChanged)
      {
        if (_systemType != _type)
        {
          saveChildrens();
          includeInLayout = visible = false;
        }
        else if (_systemType == _type)
        {
          while (_childrens.length > 0)
          {
            addElement(_childrens.shift());
          }
          includeInLayout = visible = true;
        }
        
        _typeChanged = false;
      }
    }
    
    /**
     * @private
     */
    protected function saveChildrens():void
    {
      while (numChildren > 0)
      {
        var visualElement:IVisualElement = removeElementAt(0);
        
        if (_switchable)
        {
          _childrens.push(visualElement);
        }
      }
    }
    
    [Inspectable(category = "General", enumeration = "IOS,AND,QNX", defaultValue = "AND")]
    /**
     * Select the platform
     */
    public function set type(value:String):void
    {
      if (value != _type)
      {
        _type = value;
        
        _typeChanged = true;
        
        invalidateProperties();
      }
    }
    
    /**
     * @private
     */
    public function get type():String
    {
      return _type;
    }
    
    /**
     * @private
     */
    override public function addElementAt(element:IVisualElement, index:int):IVisualElement
    {
      if (_systemType == _type)
      {
        return super.addElementAt(element, index);
      }
      else
      {
        _childrens.splice(index, 0, element);
      }
      return element;
    }
    
    /**
     * @private
     */
    public function set switchable(value:Boolean):void
    {
      _switchable = value;
    }
    
    /**
     * @private
     */
    public function get switchable():Boolean
    {
      return _switchable;
    }
  
  
  }
}
