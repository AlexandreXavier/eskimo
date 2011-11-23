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
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.ui.Keyboard;
  
  import mx.collections.IList;
  import mx.events.ItemClickEvent;
  import mx.managers.IFocusManagerComponent;
  import mx.managers.PopUpManager;
  
  import spark.components.Label;
  import spark.components.supportClasses.SkinnableComponent;
  
  /**
   * Skinclass of popup
   */
  [Style(name = "popupSkinClass", inherit = "no", type = "Class")]
  
  /**
   *  Dispatched when the user clicks on an item in the control.
   *
   *  @eventType mx.events.ItemClickEvent.ITEM_CLICK
   */
  [Event(name = "itemClick", type = "mx.events.ItemClickEvent")]
  
  /**
   * The ComboBox control lets the user make a single choice within a set of mutually exclusive choices.
   */
  public class ComboBox extends SkinnableComponent implements IFocusManagerComponent
  {
    /**
     * @private
     */
    protected static const POPUP_PADDING_PERCENT:Number = 4;
    
    
    [SkinPart(required = "true")]
    public var selectedLabelDisplay:Label;
    /**
     * @private
     */
    protected var _dataProvider:IList;
    
    /**
     * @private
     */
    protected var _selectedItem:Object;
    
    /**
     * @private
     */
    private var _selectedItemChange:Boolean = true;
    /**
     * @private
     */
    private var _defaultSelectedLabel:String = "Select";
    /**
     * @private
     */
    private var _labelField:String = "label";
    /**
     * @private
     */
    protected var popUp:UniqueChoiceList = new UniqueChoiceList();
    
    /**
     * Constructor
     */
    public function ComboBox()
    {
      super();
      this.addEventListener(MouseEvent.CLICK, popUpList);
    }
    
    /**
     *  The name of the field in the data provider items to display
     *  as the label.
     *
     *  If labelField is set to an empty string (""), no field will
     *  be considered on the data provider to represent label.
     *
     *  @default "label"
     */
    public function get labelField():String
    {
      return _labelField;
    }
    
    public function set labelField(value:String):void
    {
      _labelField = value;
    }
    
    public function set dataProvider(value:IList):void
    {
      if (value != _dataProvider)
      {
        _dataProvider = value;
        invalidateProperties();
      }
    }
    
    /**
     *  Set of data to be viewed.
     */
    public function get dataProvider():IList
    {
      return _dataProvider;
    }
    
    protected function popUpList(event:MouseEvent):void
    {
      focusManager.setFocus(this);
      var popupSkinClass:Object = getStyle("popupSkinClass");
      if (popupSkinClass != null)
      {
        popUp.setStyle("skinClass", popupSkinClass);
      }
      popUp.dataProvider = dataProvider;
      popUp.addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
      popUp.labelField = labelField;
      
      // center popup
      popUp.width = systemManager.getSandboxRoot().width * (100 - 2 * POPUP_PADDING_PERCENT) / 100;
      popUp.maxHeight = systemManager.getSandboxRoot().height * (100 - 2 * POPUP_PADDING_PERCENT) / 100;
      
      popUp.x = systemManager.getSandboxRoot().width * POPUP_PADDING_PERCENT / 100;
      PopUpManager.addPopUp(popUp, this, true);
      popUp.y = systemManager.getSandboxRoot().height / 2 - popUp.height / 2;
      
      systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
    
    }
    
    protected function onItemClick(event:ItemClickEvent):void
    {
      var selecteditem:Object = popUp.selectedItem;
      
      _selectedItem = selecteditem;
      
      _selectedItemChange = true;
      
      invalidateProperties();
      
      var evt:Event = event.clone();
      dispatchEvent(evt);
      
      PopUpManager.removePopUp(popUp);
      
      systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }
    
    /**
     *  The item that is currently selected.
     */
    public function get selectedItem():Object
    {
      return _selectedItem;
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
      popUp.selectedItem = value;
      if (value != _selectedItem)
      {
        _selectedItem = value;
        
        _selectedItemChange = true;
        
        invalidateProperties();
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_selectedItemChange && _selectedItem)
      {
        if (_selectedItem.hasOwnProperty(labelField))
        {
          selectedLabelDisplay.text = _selectedItem[labelField];
        }
        else
        {
          selectedLabelDisplay.text = _selectedItem.toString();
        }
        _selectedItemChange = false;
      }
      else if (selectedLabelDisplay != null)
      {
        selectedLabelDisplay.text = _defaultSelectedLabel;
      }
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == selectedLabelDisplay)
      {
        selectedLabelDisplay.text = _defaultSelectedLabel;
      }
    }
    
    /**
     * @private
     */
    protected function onKeyDown(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.BACK)
      {
        event.preventDefault();
        
        PopUpManager.removePopUp(popUp);
        
        systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      }
    }
    
    /**
     * The default selected label when no item is selected yet.
     * @default Select
     */
    public function get prompt():String
    {
      return _defaultSelectedLabel;
    }
    
    /**
     * @private
     */
    public function set prompt(value:String):void
    {
      _defaultSelectedLabel = value;
      
      invalidateProperties();
    }
  
  }
}
