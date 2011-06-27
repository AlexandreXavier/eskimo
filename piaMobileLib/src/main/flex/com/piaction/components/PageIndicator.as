package com.piaction.components
{
  import spark.components.BorderContainer;
  import spark.components.HGroup;
  
  /**
   * Define the color of the page items
   *
   * @default 0xFFFFFF
   */
  [Style(name = "pageItemColor", type = "Number", format = "Color", inherit = "yes")]
  
  /**
   * Define the alpha of the page items
   *
   * @default 0.5
   */
  [Style(name = "pageItemAlpha", type = "Number", inherit = "yes")]
  
  /**
   * Define the color of the selected page item
   * @default 0xFFFFFF
   */
  [Style(name = "selectedPageItemColor", type = "Number", format = "Color", inherit = "yes")]
  
  /**
   * Define the alpha of the selected page item
   * @default 1
   */
  [Style(name = "selectedPageItemAlpha", type = "Number", inherit = "yes")]
  
  /**
   * Define the size of the page items
   * @default 30
   */
  [Style(name = "pageItemSize", type = "Number", inherit = "yes")]
  
  /**
   * Define the size of the page items
   * @default 30
   */
  [Style(name = "selectedPageItemSize", type = "Number", inherit = "yes")]
  
  /**
   * This component displays the number of available pages and indicates the current page.
   * The color, the size and the alpha of items are customizable
   *
   */
  public class PageIndicator extends BorderContainer
  {
    // constants
    /**
    * The gap between the page items
    */
    public static const ITEM_GAP:int = 18;
    /**
    * The default selected page index
    */
    public static const DEFAULT_INDEX:int = 0;
    /**
    * The default number of pages
    */
    public static const DEFAULT_PAGE_COUNT:int = 1;
    
    // properties 
    private var _selectedIndex:int = DEFAULT_INDEX;
    private var _previousIndex:int = DEFAULT_INDEX;
    private var _selectedIndexChanged:Boolean = true;
    
    private var _pageCount:int = DEFAULT_PAGE_COUNT;
    private var _previousPageCount:int = 0;
    private var _pageCountChanged:Boolean = true;
    
    private var _pageItemColorChanged:Boolean = false;
    private var _pageItemAlphaChanged:Boolean = false;
    private var _selectedPageItemColorChanged:Boolean = false;
    private var _selectedPageItemAlphaChanged:Boolean = false;
    private var _pageItemSizeChanged:Boolean = false;
    private var _selectedPageItemSizeChanged:Boolean = false;
    
    // component
    private var _itemContainer:HGroup;
    private var _sizeChanged:Boolean = true;
    
    public function PageIndicator()
    {
      super();
    }
    
    /**
     * @private
     */
    override protected function measure():void
    {
      super.measure();
      
      measuredMinHeight = 40;
    }
    
    /**
     * @private
     */
    override public function styleChanged(styleProp:String):void
    {
      super.styleChanged(styleProp);
      if (styleProp == "pageItemColor")
      {
        _pageItemColorChanged = true;
        invalidateDisplayList();
        return;
      }
      if (styleProp == "pageItemAlpha")
      {
        _pageItemAlphaChanged = true;
        invalidateDisplayList();
        return;
      }
      if (styleProp == "pageItemSize")
      {
        _pageItemSizeChanged = true;
        invalidateDisplayList();
        return;
      }
      if (styleProp == "selectedPageItemSize")
      {
        _selectedPageItemSizeChanged = true;
        invalidateDisplayList();
        return;
      }
      if (styleProp == "selectedPageItemColor")
      {
        _selectedPageItemColorChanged = true;
        invalidateDisplayList();
        return;
      }
      if (styleProp == "selectedPageItemAlpha")
      {
        _selectedPageItemAlphaChanged = true;
        invalidateDisplayList();
        return;
      }
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (_itemContainer == null)
      {
        _itemContainer = new HGroup();
        _itemContainer.percentHeight = 100;
        _itemContainer.gap = ITEM_GAP;
        _itemContainer.left = ITEM_GAP;
        _itemContainer.right = ITEM_GAP;
        _itemContainer.verticalAlign = "middle";
        
        this.addElement(_itemContainer);
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_pageCountChanged)
      {
        updatePageItems();
        if (_selectedIndex > _pageCount - 1)
        {
          selectedIndex = _pageCount - 1
        }
        _pageCountChanged = false;
      }
      if (_selectedIndexChanged)
      {
        updateSelectedItem();
        _selectedIndexChanged = false;
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if (_sizeChanged)
      {
        var itemsWidth:int = pageCount * this.getStyle("pageItemSize");
        var intervalsWidth:int = (_pageCount - 1) * ITEM_GAP;
        var bordersWidth:int = ITEM_GAP * 2;
        _itemContainer.width = itemsWidth + intervalsWidth + bordersWidth;
        this.width = _itemContainer.width;
        
        _sizeChanged = false;
      }
      
      if (_pageItemColorChanged || _pageItemAlphaChanged || _pageItemSizeChanged)
      {
        updatePageItemDisplay();
      }
      if (_selectedPageItemAlphaChanged || _selectedPageItemColorChanged || _selectedPageItemSizeChanged)
      {
        updateSelectedItemDisplay();
      }
    }
    
    // --------------------------------------------
    // Accessors
    // --------------------------------------------
    /**
     * @private
     */
    public function set pageCount(value:int):void
    {
      if (value != _pageCount && value > 0)
      {
        _previousPageCount = _pageCount;
        _pageCount = value;
        _pageCountChanged = true;
        _sizeChanged = true;
        invalidateProperties();
        invalidateDisplayList();
      }
    }
    
    /**
    * The number of the available pages.
    * If the selected page index is greater than the new page count, the index is the new last page index available.
    *
    * @default 1
    */
    public function get pageCount():int
    {
      return _pageCount;
    }
    
    /**
     * @private
     */
    public function set selectedIndex(value:int):void
    {
      if (_selectedIndex != value && value >= 0 && value <= _pageCount)
      {
        _previousIndex = _selectedIndex;
        _selectedIndex = value;
        _selectedIndexChanged = true;
        invalidateProperties();
        invalidateDisplayList();
      }
    }
    
    /**
     * The index of the selected page.
     * The index cannot be lesser than 0 or greater than the last available page index.
     *
     * @default 0
     */
    public function get selectedIndex():int
    {
      return _selectedIndex;
    }
    
    // --------------------------------------------
    // Methods
    // --------------------------------------------
    
    /**
     *  Select the next page if it exists.
     *  If there is no page avaible, it does nothing.
     */
    public function next():void
    {
      if (_selectedIndex < _pageCount - 1)
      {
        selectedIndex = _selectedIndex + 1;
      }
    }
    
    /**
     *  Select the previous page if it exists.
     *  If there is no page avaible, it does nothing.
     */
    public function previous():void
    {
      if (_selectedIndex > 0)
      {
        selectedIndex = _selectedIndex - 1;
      }
    }
    
    // --------------------------------------------
    // Operations
    // --------------------------------------------
    private function updatePageItems():void
    {
      var index:int = 0;
      var gap:int = 0;
      
      // add missing elements
      if (_pageCount > _previousPageCount)
      {
        gap = _pageCount - _previousPageCount;
        for (index = 0; index <= gap; index++)
        {
          _itemContainer.addElement(createPageItem());
        }
      }
      else
      {
        // remove elements
        while (_itemContainer.numChildren != _pageCount)
        {
          _itemContainer.removeElementAt(_pageCount);
        }
      }
    }
    
    private function updateSelectedItem():void
    {
      var item:PageIndicatorItem = null;
      if (_previousIndex < _pageCount)
      {
        item = PageIndicatorItem(_itemContainer.getElementAt(_previousIndex))
        item.alpha = this.getStyle("pageItemAlpha");
        item.ellipseBackground.color = this.getStyle("pageItemColor");
      }
      
      item = PageIndicatorItem(_itemContainer.getElementAt(_selectedIndex));
      item.alpha = this.getStyle("selectedPageItemAlpha");
      item.ellipseBackground.color = this.getStyle("selectedPageItemColor");
    }
    
    private function createPageItem():PageIndicatorItem
    {
      var result:PageIndicatorItem = new PageIndicatorItem();
      updatePageItemSize(result);
      result.ellipseBackground.color = this.getStyle("pageItemColor");
      result.alpha = this.getStyle("pageItemAlpha");
      
      return result;
    }
    
    private function updatePageItemSize(pageItem:PageIndicatorItem):void
    {
      var size:Number = this.getStyle("pageItemSize");
      pageItem.ellipse.width = size;
      pageItem.ellipse.height = size;
    }
    
    private function updateSelectedPageItemSize(pageItem:PageIndicatorItem):void
    {
      var size:Number = this.getStyle("selectedPageItemSize");
      pageItem.ellipse.width = size;
      pageItem.ellipse.height = size;
    }
    
    private function updatePageItemDisplay():void
    {
      for (var index:int = 0; index < _itemContainer.numChildren; index++)
      {
        if (index != _selectedIndex)
        {
          var item:PageIndicatorItem = PageIndicatorItem(_itemContainer.getElementAt(index));
          if (_pageItemColorChanged || _pageItemAlphaChanged || _pageItemSizeChanged)
          {
            if (_pageItemColorChanged)
            {
              item.ellipseBackground.color = this.getStyle("pageItemColor");
            }
            if (_pageItemAlphaChanged)
            {
              item.alpha = this.getStyle("pageItemAlpha");
            }
            if (_pageItemSizeChanged)
            {
              updatePageItemSize(item);
            }
          }
        }
      }
      _pageItemColorChanged = false;
      _pageItemAlphaChanged = false;
      _pageItemSizeChanged = false;
    }
    
    private function updateSelectedItemDisplay():void
    {
      var item:PageIndicatorItem = PageIndicatorItem(_itemContainer.getElementAt(_selectedIndex));
      
      if (_selectedPageItemColorChanged)
      {
        item.ellipseBackground.color = this.getStyle("selectedPageItemColor");
        _selectedPageItemColorChanged = false;
      }
      if (_selectedPageItemAlphaChanged)
      {
        item.alpha = this.getStyle("selectedPageItemAlpha");
        _selectedPageItemAlphaChanged = false;
      }
      if (_selectedPageItemSizeChanged)
      {
        updateSelectedPageItemSize(item);
        _selectedPageItemSizeChanged = false;
      }
    }
  }
}
