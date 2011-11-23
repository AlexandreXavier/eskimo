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
  import com.pialabs.eskimo.data.SectionTitleLabel;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import mx.collections.IList;
  import mx.core.ClassFactory;
  import mx.core.IDataRenderer;
  import mx.core.IFactory;
  import mx.core.IVisualElement;
  import mx.core.UIComponent;
  import mx.core.mx_internal;
  import mx.events.PropertyChangeEvent;
  
  import spark.components.Group;
  import spark.components.IItemRenderer;
  import spark.components.List;
  import spark.layouts.VerticalLayout;
  import spark.utils.LabelUtil;
  
  use namespace mx_internal;
  
  /**
   *  Dispatched after the selection has changed.
   *  This event is dispatched when the user interacts with the control.
   */
  [Event(name = "change", type = "spark.events.IndexChangeEvent")]
  
  /**
   * Defines the section style
   *
   * @default .sectionRendererStyle
   */
  [Style(name = "sectionRendererStyleName", inherit = "no", type = "String")]
  
  
  /**
   * List that contains some section to order item.
   *
   * SectionList renderers must implements com.pialabs.eskimo.components.ISectionRenderer.
   *
   * @see com.pialabs.eskimo.components.SectionItemRenderer
   * @see com.pialabs.eskimo.components.ISectionRenderer
   * @see com.pialabs.eskimo.data.SectionTitleLabel
   */
  public class SectionList extends List
  {
    /**
     * @private
     */
    protected var _sectionHeight:Number = 27;
    /**
     * @private
     */
    protected var _isSectionTitleFunction:Function = defaultIsSectionTitleFunction;
    /**
     * @private
     */
    protected var _sectionLabelField:String = "label";
    /**
     * @private
     */
    protected var _maintainSectionOnTop:Boolean = false;
    
    
    [SkinPart(required = "false")]
    public var currentSectionRendererLayer:Group;
    
    /**
     * @private
     */
    protected var currentSectionRenderer:IVisualElement;
    
    /**
     * @private
     */
    protected var previousSectionIndex:int;
    /**
     * @private
     */
    protected var nextSectionIndex:int;
    
    /**
     * @private
     */
    private var _itemRendererChange:Boolean = true;
    
    /**
     * @private
     */
    protected var _regenerateSectionIndices:Boolean = false;
    
    /**
     * @private
     */
    protected var _sestionTitleIndices:Vector.<int> = new Vector.<int>();
    
    /**
     * @private
     */
    public function SectionList()
    {
      super();
      itemRenderer = new ClassFactory(SectionItemRenderer);
      var sectionLayout:VerticalLayout = new VerticalLayout();
      sectionLayout.variableRowHeight = true;
      sectionLayout.gap = 0;
      sectionLayout.horizontalAlign = "contentJustify";
      this.layout = sectionLayout;
    }
    
    override protected function dataProvider_collectionChangeHandler(event:Event):void
    {
      super.dataProvider_collectionChangeHandler(event);
      
      _regenerateSectionIndices = true;
      
      invalidateDisplayList();
    }
    
    private function generateSectionIndicesVector():void
    {
      _sestionTitleIndices = new Vector.<int>();
      
      if (dataProvider)
      {
        for (var i:int = 0; i < dataProvider.length; i++)
        {
          if (_isSectionTitleFunction(dataProvider.getItemAt(i)))
          {
            _sestionTitleIndices.push(i);
          }
        }
      }
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == scroller)
      {
        scroller.viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
      }
    
    }
    
    /**
     * @private
     */
    protected function propertyChangeHandler(event:PropertyChangeEvent):void
    {
      if (event.property == "verticalScrollPosition" && _maintainSectionOnTop && currentSectionRenderer != null)
      {
        updateCurrentSectionTitleRendererPosition()
      }
    }
    
    /**
     * @private
     */
    protected function updateCurrentSectionTitleRendererPosition():void
    {
      var indicesInView:Vector.<int> = dataGroup.getItemIndicesInView();
      var firstVisibleIndice:int = indicesInView.length > 0 ? indicesInView[0] : -1;
      var found:Boolean;
      
      previousSectionIndex = getPreviousSectionTitleIndex(firstVisibleIndice);
      
      
      if (previousSectionIndex == -1)
      {
        currentSectionRenderer.visible = false;
        return;
      }
      
      var visu:IVisualElement = dataGroup.getVirtualElementAt(previousSectionIndex);
      
      if (visu)
      {
        point = (visu as UIComponent).localToGlobal(new Point());
        point = currentSectionRendererLayer.globalToLocal(point);
        
        if (point.y >= 0)
        {
          currentSectionRenderer.visible = false;
          return;
        }
      }
      
      nextSectionIndex = getNextSectionTitleIndex(firstVisibleIndice + 1);
      
      
      currentSectionRenderer.visible = true;
      
      var previousItem:Object = dataProvider.getItemAt(previousSectionIndex);
      (currentSectionRenderer as IItemRenderer).label = itemToLabel(previousItem);
      
      
      
      visu = dataGroup.getVirtualElementAt(nextSectionIndex);
      var currectionSectionY:Number = 0;
      var point:Point;
      
      if (visu)
      {
        point = (visu as UIComponent).localToGlobal(new Point());
        point = currentSectionRendererLayer.globalToLocal(point);
        
        currectionSectionY = Math.min(point.y - currentSectionRenderer.getLayoutBoundsHeight(), 0);
      }
      
      currentSectionRenderer.setLayoutBoundsPosition(0, currectionSectionY);
    
    }
    
    /**
     * @private
     */
    protected function getPreviousSectionTitleIndex(index:int):int
    {
      if (_sestionTitleIndices.length == 0)
      {
        return -1;
      }
      
      for (var i:int = _sestionTitleIndices.length - 1; i >= 0; i--)
      {
        if (index >= _sestionTitleIndices[i])
        {
          return _sestionTitleIndices[i];
        }
      }
      return -1;
    }
    
    /**
     * @private
     */
    protected function getNextSectionTitleIndex(index:int):int
    {
      if (_sestionTitleIndices.length == 0)
      {
        return -1;
      }
      
      for (var i:int = 0; i < _sestionTitleIndices.length; i++)
      {
        if (index <= _sestionTitleIndices[i])
        {
          return _sestionTitleIndices[i];
        }
      }
      return -1;
    }
    
    /**
     * @private
     */
    override protected function item_mouseDownHandler(event:MouseEvent):void
    {
      var data:Object;
      if (event.currentTarget is IItemRenderer)
      {
        data = IDataRenderer(event.currentTarget).data;
      }
      
      var isTitle:Boolean = _isSectionTitleFunction(data);
      if (isTitle)
      {
        event.preventDefault();
      }
      super.item_mouseDownHandler(event);
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_itemRendererChange)
      {
        if (currentSectionRendererLayer)
        {
          currentSectionRendererLayer.removeAllElements()
          
          if (itemRenderer)
          {
            currentSectionRenderer = itemRenderer.newInstance();
            currentSectionRenderer.percentWidth = 100;
            
            if (currentSectionRenderer is ISectionRenderer)
            {
              (currentSectionRenderer as ISectionRenderer).isSectionTitle = true;
            }
            
            currentSectionRendererLayer.addElement(currentSectionRenderer);
          }
        }
        
        if (_regenerateSectionIndices)
        {
          generateSectionIndicesVector();
          _regenerateSectionIndices = false;
        }
      }
    
    }
    
    /**
    * @private
    */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      var sectionRendererStyleName:String = getStyle("sectionRendererStyleName");
      
      if (currentSectionRenderer)
      {
        (currentSectionRenderer as UIComponent).styleName = sectionRendererStyleName;
        (currentSectionRenderer as UIComponent).height = sectionHeight;
        
        if (_maintainSectionOnTop)
        {
          updateCurrentSectionTitleRendererPosition()
        }
        else
        {
          currentSectionRenderer.visible = false;
        }
      }
    
    }
    
    /**
     * @private
     */
    override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
    {
      var sectionRendererStyleName:String = getStyle("sectionRendererStyleName");
      //enderer.height = sectionHeight;
      
      if (renderer is ISectionRenderer)
      {
        var isTitle:Boolean = _isSectionTitleFunction(data);
        var rendererStyleName:String = (renderer as UIComponent).styleName as String;
        if (isTitle)
        {
          if (renderer is IDataRenderer)
          {
            (renderer as IDataRenderer).data = data;
          }
          
          (renderer as ISectionRenderer).isSectionTitle = true;
          
          if (renderer is IItemRenderer)
          {
            (renderer as IItemRenderer).label = LabelUtil.itemToLabel(data, sectionLabelField);
          }
          
          (renderer as UIComponent).height = sectionHeight;
          if (rendererStyleName == null || rendererStyleName.lastIndexOf(sectionRendererStyleName) == -1)
          {
            (renderer as UIComponent).styleName += " " + sectionRendererStyleName;
          }
          
          return;
        }
        else
        {
          (renderer as ISectionRenderer).isSectionTitle = false;
          (renderer as UIComponent).height = NaN;
          
          
          if (rendererStyleName)
          {
            rendererStyleName.split(sectionRendererStyleName).join("");
          }
          (renderer as UIComponent).styleName = "";
        }
      }
      
      super.updateRenderer(renderer, itemIndex, data);
    }
    
    /**
     * Height of section titles renderers
     */
    public function get sectionHeight():Number
    {
      return _sectionHeight;
    }
    
    /**
     * @private
     */
    public function set sectionHeight(value:Number):void
    {
      _sectionHeight = value;
      
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function defaultIsSectionTitleFunction(item:Object):Boolean
    {
      return (item is SectionTitleLabel);
    }
    
    /**
     * Label field for the section title item
     */
    public function get sectionLabelField():String
    {
      return _sectionLabelField;
    }
    
    /**
     * @private
     */
    public function set sectionLabelField(value:String):void
    {
      _sectionLabelField = value;
    }
    
    /**
    * Function defined to tell to the sectionList if the item is a section title or a normal item.
    * By default, the SectionList look for com.pialabs.eskimo.data.SectionTitleLabel in the dataProvider.
    */
    public function get isSectionTitleFunction():Function
    {
      return _isSectionTitleFunction;
    }
    
    
    /**
    * @private
    */
    public function set isSectionTitleFunction(value:Function):void
    {
      _isSectionTitleFunction = value;
      
      _regenerateSectionIndices = true;
      
      invalidateProperties();
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    override public function set itemRenderer(value:IFactory):void
    {
      super.itemRenderer = value;
      
      _itemRendererChange = true;
      
      invalidateProperties();
    }
    
    /**
     * @private
     */
    override public function set dataProvider(value:IList):void
    {
      super.dataProvider = value;
      
      _regenerateSectionIndices = true;
      
      invalidateProperties();
      invalidateDisplayList();
    }
    
    /**
     * Display the current section title on top of the list
     */
    public function get maintainSectionOnTop():Boolean
    {
      return _maintainSectionOnTop;
    }
    
    /**
     * @private
     */
    public function set maintainSectionOnTop(value:Boolean):void
    {
      _maintainSectionOnTop = value;
      
      invalidateDisplayList();
    }
  
  
  }
}
