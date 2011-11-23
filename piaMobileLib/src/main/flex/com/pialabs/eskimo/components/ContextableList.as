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
  import com.pialabs.eskimo.events.ContextableListEvent;
  import com.pialabs.eskimo.events.MobileContextMenuEvent;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.utils.Timer;
  
  import mx.core.mx_internal;
  
  import spark.components.IItemRenderer;
  import spark.components.List;
  
  use namespace mx_internal;
  
  /**
   * Dispatched when a long click was executed.
   */
  [Event(name = "itemLongPress", type = "com.pialabs.eskimo.events.ContextableListEvent")]
  
  /**
   * Dispatched when an item of the context menu was clicked.
   */
  [Event(name = "contextMenuItemClick", type = "com.pialabs.eskimo.events.ContextableListEvent")]
  
  /**
   * List that displays a contextMenu on item long click. The context menu will allow you to execute differents actions on an item.
   * @see com.pialabs.eskimo.components.MobileContextMenu
   */
  public class ContextableList extends List
  {
    /**
     * Time to wait (in millisecond) before displaying the context menu.
     */
    public static var TIME_CLICK:Number = 700;
    
    /**
     * @private
     */
    private var _timer:Timer;
    /**
     * @private
     */
    protected var _contextMenuItems:Array;
    protected var _contextList:MobileContextMenu;
    /**
     * @private
     */
    protected var _mouseDownPoint:Point;
    
    /**
     * @private
     */
    protected var _contextIndex:int;
    /**
     * @private
     */
    protected var _contextRenderer:IItemRenderer;
    /**
     * @private
     */
    protected var _contextData:Object;
    /**
     * @private
     */
    protected var _contextMenuLabelField:String = "label";
    
    
    
    /**
     * Constructor
     */
    public function ContextableList()
    {
      super();
    
    }
    
    /**
     * @private
     */
    override protected function item_mouseDownHandler(event:MouseEvent):void
    {
      super.item_mouseDownHandler(event);
      
      _timer = new Timer(TIME_CLICK, 1);
      _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
      _timer.start();
      
      
      systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
      
      _mouseDownPoint = event.target.localToGlobal(new Point(event.localX, event.localY));
    }
    
    /**
     * @private
     */
    override protected function mouseUpHandler(event:Event):void
    {
      super.mouseUpHandler(event);
      
      _mouseDownPoint = null
      
      _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
      _timer.stop();
      systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }
    
    /**
     * @private
     */
    protected function onMouseMove(event:MouseEvent):void
    {
      if (!_mouseDownPoint)
      {
        return;
      }
      
      var pt:Point = new Point(event.localX, event.localY);
      pt = event.target.localToGlobal(pt);
      
      const DRAG_THRESHOLD:int = 20;
      
      if (Math.abs(_mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(_mouseDownPoint.y - pt.y) > DRAG_THRESHOLD)
      {
        _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
        _timer.stop();
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      }
    
    }
    
    /**
     * @private
     */
    protected function onTimerComplete(event:TimerEvent):void
    {
      _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
      
      if (mouseDownIndex == -1)
      {
        return;
      }
      
      _contextIndex = mouseDownIndex;
      _contextData = dataProvider.getItemAt(mouseDownIndex);
      _contextRenderer = dataGroup.getElementAt(mouseDownIndex) as IItemRenderer;
      
      dispatchEvent(new ContextableListEvent(ContextableListEvent.ITEM_LONG_PRESS, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer));
      
      if (_contextMenuItems)
      {
        showContextMenu();
      }
    }
    
    /**
     * Context menu items.
     */
    public function get contextMenuItems():Array
    {
      return _contextMenuItems;
    }
    
    /**
     * @private
     */
    protected function showContextMenu():void
    {
      selectedIndex = _contextIndex;
      
      _contextList = MobileContextMenu.show(_contextMenuItems, _contextRenderer.label, this, true);
      
      _contextList.labelField = _contextMenuLabelField;
      
      _contextList.addEventListener(MobileContextMenuEvent.MENU_ITEM_CLICKED, onMobileContextMenuClicked, false, 0, true);
      _contextList.addEventListener(Event.CANCEL, onMobileContextMenuCanceled, false, 0, true);
    }
    
    /**
     * @private
     */
    protected function onMobileContextMenuClicked(event:MobileContextMenuEvent):void
    {
      var evt:ContextableListEvent = new ContextableListEvent(ContextableListEvent.CONTEX_MENU_ITEM_CLICK, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer, event.menuItem);
      
      selectedIndex = -1;
      
      dispatchEvent(evt);
      
      _contextList = null;
    }
    
    /**
     * @private
     */
    protected function onMobileContextMenuCanceled(event:Event):void
    {
      selectedIndex = -1;
      
      _contextList = null;
    }
    
    
    /**
     * Items displayed in the context menu.
     */
    public function set contextMenuItems(value:Array):void
    {
      _contextMenuItems = value;
    }
    
    /**
     * The current context menu opened.
     * @see com.pialabs.eskimo.components.MobileContextMenu.
     */
    public function get currentContextMenu():MobileContextMenu
    {
      return _contextList;
    }
    
    /**
     * LabelField used to display items label in the context menu.
     */
    public function get contextMenuLabelField():String
    {
      return _contextMenuLabelField;
    }
    
    /**
     * @private
     */
    public function set contextMenuLabelField(value:String):void
    {
      _contextMenuLabelField = value;
    }
  
  
  }
}
