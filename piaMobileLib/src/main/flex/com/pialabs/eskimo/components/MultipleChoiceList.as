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
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import mx.collections.IList;
  import mx.core.ClassFactory;
  import mx.core.InteractionMode;
  import mx.core.mx_internal;
  import mx.events.SandboxMouseEvent;
  import mx.managers.DragManager;
  
  import spark.components.IItemRenderer;
  import spark.components.List;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.events.IndexChangeEvent;
  import spark.events.RendererExistenceEvent;
  import spark.layouts.VerticalLayout;
  
  use namespace mx_internal;
  
  /**
   * Component represented by a list of CheckBox (uses Switch skin on iOs) item .
   * ItemRender must dispatch <code>Event.CHANGE</code> event when user click on it.
   *
   * @see com.pialabs.eskimo.components.CheckBoxItemRenderer
   */
  public class MultipleChoiceList extends List
  {
    
    /**
     * Constructor
     */
    public function MultipleChoiceList()
    {
      super();
      
      itemRenderer = new ClassFactory(CheckBoxItemRenderer);
      
      allowMultipleSelection = true;
      
      var verticalLayout:VerticalLayout = new VerticalLayout();
      verticalLayout.horizontalAlign = "contentJustify";
      layout = verticalLayout;
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == scroller)
      {
        scroller.setStyle("verticalScrollPolicy", "auto");
      }
      if (instance == dataGroup)
      {
        dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, onRendererAdd);
        dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, onRendererRemove);
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
    }
    
    /**
     * @private
     */
    protected function onRendererAdd(event:RendererExistenceEvent):void
    {
      event.renderer.addEventListener(Event.CHANGE, onRendererChange, false, 0, true);
    }
    
    /**
     * @private
     */
    protected function onRendererRemove(event:RendererExistenceEvent):void
    {
      event.renderer.removeEventListener(Event.CHANGE, onRendererChange);
    }
    
    /**
    * @private
    */
    override protected function mouseUpHandler(event:Event):void
    {
      if (getStyle("interactionMode") == InteractionMode.TOUCH)
      {
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false);
        systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpHandler, false);
      }
      else
      {
        super.mouseUpHandler(event);
      }
    
    }
    
    /**
     * @private
     */
    protected function onRendererChange(event:Event):void
    {
      if (getStyle("interactionMode") == InteractionMode.TOUCH)
      {
        if (allowMultipleSelection)
        {
          var newIndex:int = (event.currentTarget as IItemRenderer).itemIndex;
          
          setSelectedIndices(calculateSelectedIndices(newIndex, pendingSelectionShiftKey, pendingSelectionCtrlKey), true);
        }
      }
    
    }
  }
}
