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
  import flash.errors.IllegalOperationError;
  
  import mx.core.IVisualElement;
  
  import spark.components.Group;
  import spark.events.IndexChangeEvent;
  import spark.layouts.HorizontalAlign;
  import spark.layouts.HorizontalLayout;
  import spark.layouts.VerticalAlign;
  
  /**
   * Define the alpah of an item.
   */
  [Style(name = "chromeAlpha", type = "Number", inherit = "yes")]
  
  /**
   * Define the color of the selected page item.
   */
  [Style(name = "selectedChromeColor", type = "uint", format = "Color", inherit = "yes")]
  
  /**
   * Define the alpha of the selected page item.
   * @default 1
   */
  [Style(name = "selectedChromeAlpha", type = "Number", inherit = "yes")]
  
  /**
   * Item skin class
   */
  [Style(name = "itemSkinClass", type = "Class", inherit = "no")]
  
  /**
  * Dispatched when selected index change
  */
  [Event(name = "change", type = "flash.events.Event.IndexChangeEvent")]
  
  /**
   * This component displays the number of available pages and indicates the current page.
   * The color, the size and the alpha of items are customizable.
   *
   */
  public class PageIndicator extends Group
  {
    /**
     * @private
     */
    protected var _pageCount:uint;
    protected var _selectedIndex:int = 0;
    
    /**
     * @private
     */
    private var _pageCountChange:Boolean;
    private var _selectedIndexChange:Boolean;
    
    /**
     * @private
     */
    protected var _itemWidth:Number = 10;
    protected var _itemHeight:Number = 10;
    
    /**
     * @private
     */
    protected var _autoLoop:Boolean;
    
    /**
    * Vector of added elements
    */
    protected var _elements:Vector.<PageIndicatorItem>;
    
    /**
     * @private
     */
    public function PageIndicator()
    {
      super();
      
      var hLayout:HorizontalLayout = new HorizontalLayout();
      hLayout.horizontalAlign = HorizontalAlign.CENTER;
      hLayout.verticalAlign = VerticalAlign.MIDDLE;
      layout = hLayout;
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      var element:PageIndicatorItem;
      var itemSkinClass:Class = getStyle("itemSkinClass");
      
      if (_pageCountChange)
      {
        removeAllElements();
        _elements = new Vector.<PageIndicatorItem>();
        
        for (var i:int = 0; i < _pageCount; i++)
        {
          element = new PageIndicatorItem();
          element.setStyle("skinClass", itemSkinClass);
          element.index = i;
          
          _elements.push(element);
          
          super.addElementAt(element, numElements);
        }
        
        _selectedIndexChange = true;
        _pageCountChange = false;
      }
      
      if (_selectedIndexChange)
      {
        for (var j:int = 0; j < _pageCount; j++)
        {
          element = _elements[j];
          
          element.selected = (j == _selectedIndex);
        }
        _selectedIndexChange = false;
      }
    }
    
    /**
    * @private
    */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      
      var element:PageIndicatorItem;
      
      for (var j:int = 0; j < _pageCount; j++)
      {
        element = _elements[j];
        
        var eltWidth:Number = isNaN(itemWidth) ? element.getPreferredBoundsWidth() : itemWidth;
        var eltHeight:Number = isNaN(itemHeight) ? element.getPreferredBoundsHeight() : itemHeight;
        
        element.width = eltWidth;
        element.height = eltHeight;
        
      }
      
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    /**
     * Select the next item
     */
    public function next():int
    {
      selectedIndex++;
      
      return _selectedIndex;
    }
    
    /**
     * Select the previous item
     */
    public function previous():int
    {
      selectedIndex--;
      
      return _selectedIndex;
    }
    
    /**
     * Item number
     */
    public function get pageCount():uint
    {
      return _pageCount;
    }
    
    /**
     * @private
     */
    public function set pageCount(value:uint):void
    {
      _pageCount = value;
      
      _pageCountChange = true;
      
      invalidateProperties();
    }
    
    [Bindable("change")]
    /**
     * Current selected index
     */
    public function get selectedIndex():int
    {
      return _selectedIndex;
    }
    
    /**
     * @private
     */
    public function set selectedIndex(value:int):void
    {
      if (_selectedIndex == value)
      {
        return;
      }
      
      var oldIndex:int = _selectedIndex;
      
      if (value < _pageCount && value >= 0)
      {
        
        _selectedIndex = value;
        _selectedIndexChange = true;
        
        dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, oldIndex, _selectedIndex));
        
        invalidateProperties();
      }
      else if (_autoLoop)
      {
        if (value < 0)
        {
          _selectedIndex = (value % _pageCount) + _pageCount;
        }
        else
        {
          _selectedIndex = value % _pageCount;
        }
        _selectedIndexChange = true;
        
        dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, oldIndex, _selectedIndex));
        
        invalidateProperties();
      }
    }
    
    /**
     * Item width
     */
    public function get itemWidth():Number
    {
      return _itemWidth;
    }
    
    /**
     * @private
     */
    public function set itemWidth(value:Number):void
    {
      _itemWidth = value;
      
      invalidateDisplayList();
    }
    
    /**
     * Item height
     */
    public function get itemHeight():Number
    {
      return _itemHeight;
    }
    
    /**
     * @private
     */
    public function set itemHeight(value:Number):void
    {
      _itemHeight = value;
      
      invalidateDisplayList();
    }
    
    /**
     * Enable looping
     */
    public function get autoLoop():Boolean
    {
      return _autoLoop;
    }
    
    /**
     * @private
     */
    public function set autoLoop(value:Boolean):void
    {
      _autoLoop = value;
    }
    
    /**
    * @private
    */
    override public function addElementAt(element:IVisualElement, index:int):IVisualElement
    {
      throw new IllegalOperationError("You cannot add element to this component");
    }
  
  
  }
}
