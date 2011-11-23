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
  import com.pialabs.eskimo.events.MobileContextMenuEvent;
  
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.StageOrientationEvent;
  import flash.ui.Keyboard;
  
  import mx.collections.ArrayCollection;
  import mx.events.FlexEvent;
  import mx.managers.PopUpManager;
  
  import spark.components.Label;
  import spark.components.List;
  import spark.components.SkinnablePopUpContainer;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.events.IndexChangeEvent;
  
  /**
   * Item clicked
   */
  [Event(name = "menuItemClicked", type = "com.pialabs.eskimo.events.MobileContextMenuEvent")]
  
  /**
   * Cancel event, ContextMenu closed without selecting an item
   */
  [Event(name = "cancel", type = "flash.events.Event")]
  
  /**
   * header height
   * @default 50
   */
  [Style(name = "headerHeight", inherit = "no", type = "Number")]
  
  /**
   * Context menu icon
   */
  [Style(name = "contextMenuIcon", inherit = "no", type = "Class")]
  
  /**
   * Header visible
   * @default true
   */
  [Style(name = "headerVisible", inherit = "no", type = "Boolean")]
  
  /**
   *  The normal state without header.
   */
  [SkinState("normalWithoutHeader")]
  /**
   *  The closed state without header.
   */
  [SkinState("closedWithoutHeader")]
  /**
   *  The disabled state without header.
   */
  [SkinState("disabledWithoutHeader")]
  
  /**
   * Android like mobile context menu
   */
  public class MobileContextMenu extends SkinnablePopUpContainer
  {
    /**
     * @private
     */
    [SkinPart]
    public var listDisplay:List;
    
    /**
     * @private
     */
    [SkinPart(required = "false")]
    public var headerDisplay:Label;
    
    /**
     * @private
     */
    protected var _menuItems:Array;
    /**
     * @private
     */
    protected var _headerLabel:String;
    /**
     * @private
     */
    protected var _labelField:String = "label";
    
    
    
    /**
     * @constructor
     */
    public function MobileContextMenu()
    {
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, true);
    }
    
    protected function onAddedToStage(event:Event):void
    {
      systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
      
      owner.addEventListener(Event.RESIZE, ownerSizeChange, false, 0, true);
    }
    
    /**
     * @private
     */
    protected function removeFromStage(event:Event):void
    {
      systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      
      owner.removeEventListener(Event.RESIZE, ownerSizeChange);
    }
    
    /**
     * @private
     */
    protected function ownerSizeChange(event:Event):void
    {
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    override protected function measure():void
    {
      super.measure();
      
      measuredWidth = owner.width * 0.9;
      maxHeight = owner.height * 0.9;
    
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == listDisplay)
      {
        listDisplay.dataProvider = new ArrayCollection(_menuItems);
        listDisplay.addEventListener(IndexChangeEvent.CHANGE, onIndexChange, false, 0, true);
        listDisplay.labelField = _labelField;
      }
      else if (instance == headerDisplay)
      {
        headerDisplay.text = _headerLabel;
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      PopUpManager.centerPopUp(this);
    }
    
    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
      var skinState:String = super.getCurrentSkinState();
      
      if (getStyle("headerVisible") == false)
      {
        skinState += "WithoutHeader";
      }
      
      return skinState;
    }
    
    /**
     * @private
     */
    protected function onIndexChange(event:IndexChangeEvent):void
    {
      var evt:MobileContextMenuEvent = new MobileContextMenuEvent(MobileContextMenuEvent.MENU_ITEM_CLICKED, _menuItems[event.newIndex]);
      
      dispatchEvent(evt);
      
      close(true);
    }
    
    /**
     * Show an android like mobile context menu
     */
    public static function show(menuItems:Array, headerLabel:String = "", parent:DisplayObjectContainer = null, modal:Boolean = true):MobileContextMenu
    {
      var menu:MobileContextMenu = new MobileContextMenu();
      
      menu.open(parent, true);
      
      menu.menuItems = menuItems;
      menu.headerLabel = headerLabel;
      
      return menu;
    }
    
    /**
     * @private
     */
    protected function onKeyDown(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.BACK)
      {
        close(true);
        event.preventDefault();
        dispatchEvent(new Event(Event.CANCEL));
      }
    }
    
    /**
     * @private
     */
    public function get menuItems():Array
    {
      return _menuItems;
    }
    
    /**
     * @private
     */
    public function set menuItems(value:Array):void
    {
      _menuItems = value;
      if (listDisplay)
      {
        listDisplay.dataProvider = new ArrayCollection(_menuItems);
      }
      
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    public function get headerLabel():String
    {
      return _headerLabel;
    }
    
    /**
     * @private
     */
    public function set headerLabel(value:String):void
    {
      _headerLabel = value;
      if (headerDisplay)
      {
        headerDisplay.text = _headerLabel;
      }
      
      invalidateDisplayList();
    }
    
    /**
     * List's label field
     */
    public function get labelField():String
    {
      return _labelField;
    }
    
    /**
     * @private
     */
    public function set labelField(value:String):void
    {
      _labelField = value;
      if (listDisplay)
      {
        listDisplay.labelField = _labelField;
      }
    }
  
  
  
  }
}
