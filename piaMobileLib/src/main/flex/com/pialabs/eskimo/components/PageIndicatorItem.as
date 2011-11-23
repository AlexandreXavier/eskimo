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
  import spark.components.supportClasses.SkinnableComponent;
  
  
  [SkinState("normal")]
  [SkinState("selected")]
  
  /**
  * Item for PageIndicatorComponent
  */
  public class PageIndicatorItem extends SkinnableComponent
  {
    /**
    * @private
    */
    private var _selected:Boolean;
    /**
     * @private
     */
    protected var _index:int;
    
    /**
     * @private
     */
    public function PageIndicatorItem()
    {
      super();
    }
    
    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
      return (_selected ? "selected" : "normal");
    }
    
    /**
     * @private
     */
    override protected function measure():void
    {
      super.measure();
      
      measuredWidth = 5;
      measuredHeight = 5;
    }
    
    /**
     * @private
     */
    public function get index():int
    {
      return _index;
    }
    
    /**
     * @private
     */
    public function set index(value:int):void
    {
      _index = value;
    }
    
    /**
     * @private
     */
    public function get selected():Boolean
    {
      return _selected;
    }
    
    /**
     * @private
     */
    public function set selected(value:Boolean):void
    {
      if (value != _selected)
      {
        _selected = value;
        
        invalidateSkinState();
        skin.invalidateDisplayList();
      }
    }
  }
}
