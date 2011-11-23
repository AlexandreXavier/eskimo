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
  import com.pialabs.eskimo.events.DeletableListEvent;
  
  import flash.events.Event;
  
  import mx.core.ClassFactory;
  import mx.core.IVisualElement;
  import mx.core.UIComponent;
  import mx.core.mx_internal;
  import mx.events.StateChangeEvent;
  import mx.states.State;
  
  import spark.components.IItemRenderer;
  import spark.components.List;
  
  use namespace mx_internal;
  
  /**
   * Dispatched when an item is deleted
   */
  [Event(name = "itemDeleted", type = "com.pialabs.eskimo.events.DeletableListEvent")]
  
  /**
   * List that can contain deletable itemrenderers. Use can swith to edition mode then remove item from the list.
   * @see com.pialabs.eskimo.components.DeletableItemRenderer
   * @see com.pialabs.eskimo.components.DeletableItemRendererOverlay
   */
  public class DeletableList extends List
  {
    /**
     * Normal State const.
     */
    protected static const NORMAL_STATE:String = "normal";
    /**
     * Edition State const. The user is able to remove item from the list.
     */
    protected static const EDITION_STATE:String = "edition";
    
    /**
     * @private
     */
    protected var _editionMode:Boolean;
    
    /**
     * @private
     */
    protected var _invalidateItemRendererState:Boolean;
    
    /**
     * @private
     */
    public function DeletableList()
    {
      super();
      
      itemRenderer = new ClassFactory(DeletableItemRenderer);
    }
    
    /**
     * @private
     */
    public function invalidateItemRendererState():void
    {
      _invalidateItemRendererState = true;
      invalidateProperties();
    }
    
    /**
     * @private
     */
    override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
    {
      super.updateRenderer(renderer, itemIndex, data);
      
      if (renderer is DeletableItemRenderer)
      {
        updateRendererState(renderer);
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_invalidateItemRendererState && dataGroup)
      {
        
        for (var i:int = 0; i < dataGroup.numElements; i++)
        {
          var renderer:IVisualElement = useVirtualLayout ? dataGroup.getVirtualElementAt(i) : dataGroup.getElementAt(i);
          
          if (renderer != null)
          {
            updateRendererState(renderer);
          }
        }
        
        dataGroup.clearFreeRenderers();
        
        _invalidateItemRendererState = false;
      }
    
    }
    
    /**
    * Update the renderer state between EDITION_STATE and NORMAL_STATE.
    */
    protected function updateRendererState(renderer:IVisualElement):void
    {
      if (_editionMode)
      {
        (renderer as UIComponent).currentState = EDITION_STATE;
      }
      else
      {
        (renderer as UIComponent).currentState = NORMAL_STATE;
      }
    }
    
    /**
     * Modify the delete button label
     */
    public static function set deleteLabel(value:String):void
    {
      DeletableItemRenderer.deleteLabel = value;
    }
    
    /**
     * Switch into edition mode
     */
    public function set editionMode(value:Boolean):void
    {
      _editionMode = value;
      _invalidateItemRendererState = true;
      
      invalidateProperties();
    }
    
    /**
     * @private
     */
    public function get editionMode():Boolean
    {
      return _editionMode;
    }
  }


}
