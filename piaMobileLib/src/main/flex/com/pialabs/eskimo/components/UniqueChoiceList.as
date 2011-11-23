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
  import spark.events.IndexChangeEvent;
  
  /**
   * Component represented by a ListWheel on iOs and a list of radioButton item on android.
   *
   * @see com.pialabs.eskimo.components.CheckBoxItemRenderer
   */
  public class UniqueChoiceList extends ChoiceList
  {
    /**
     * @private
     */
    protected var _selectedItem:Object;
    
    /**
     * Constructor
     */
    public function UniqueChoiceList()
    {
      super();
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_selectedChange)
      {
        listDisplay.selectedItem = _selectedItem;
        dispatchEvent(new IndexChangeEvent("change"));
        _selectedChange = false;
      }
    }
    
    /**
     * Setting this property deselects the currently selected
     *  item and selects the newly specified item.
     *
     *  <p>Setting <code>selectedItem</code> to an item that is not
     *  in this component results in no selection,
     *  and <code>selectedItem</code> being set to <code>undefined</code>.</p>
     */
    public function set selectedItem(value:Object):void
    {
      if (value != _selectedItem)
      {
        _selectedItem = value;
        
        _selectedChange = true;
        
        invalidateProperties();
      }
    }
    
    /**
     *  The item currently selected.
     */
    [Bindable("change")]
    public function get selectedItem():Object
    {
      return listDisplay.selectedItem;
    }
  }
}
