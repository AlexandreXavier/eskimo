package com.piaction.components
{
  import mx.graphics.SolidColor;
  
  import spark.components.BorderContainer;
  import spark.components.HGroup;
  
  /**
   * Define the color of the page items
  */
  [Style(name = "pageItemColor", type = "Number", format = "Color", inherit = "yes")]
  
  /**
   * Define the size of the page items
   */
  [Style(name = "pageItemSize", type = "Number", inherit = "yes")]
  
  public class PageIndicator extends BorderContainer
  {
    // constants
    public static const ITEM_GAP:int = 18;
    public static const DEFAULT_INDEX:int = 0;
    public static const DEFAULT_PAGE_COUNT:int = 1;
    
    // properties 
    private var _selectedIndex:int = DEFAULT_INDEX;
    private var _previousIndex:int = DEFAULT_INDEX;
    private var _selectedIndexChanged:Boolean = true;
    
    private var _pageCount:int = DEFAULT_PAGE_COUNT;
    private var _previousPageCount:int = 0;
    private var _pageCountChanged:Boolean = true;
    
    private var _pageItemColorChanged:Boolean = false;
    private var _pageItemSizeChanged:Boolean = false;
    
    // component
    private var _itemContainer:HGroup;
    private var _sizeChanged:Boolean = true;
    
    public function PageIndicator()
    {
      super();
      this.backgroundFill = new SolidColor(0);
      this.minHeight = 40;
    }
    
    override public function styleChanged(styleProp:String):void
    {
      super.styleChanged(styleProp);
      if (styleProp == "pageItemColor")
      {
        _pageItemColorChanged = true;
        invalidateDisplayList();
        return;
      }
      if (styleProp == "pageItemSize")
      {
        _pageItemSizeChanged = true;
        invalidateDisplayList();
        return;
      }
    }
    
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
      
      if (_pageItemColorChanged || _pageItemSizeChanged)
      {
        for (var index:int = 0; index < _itemContainer.numChildren; index++)
        {
          var item:PageIndicatorItem = PageIndicatorItem(_itemContainer.getElementAt(index));
          if (_pageItemColorChanged)
          {
            item.fillColor = this.getStyle("pageItemColor");
          }
          if (_pageItemSizeChanged)
          {
            item.size = this.getStyle("pageItemSize");
          }
          
        }
        _pageItemColorChanged = false;
        _pageItemSizeChanged = false;
      }
    }
    
    // --------------------------------------------
    // Accessors
    // --------------------------------------------
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
    
    public function get pageCount():int
    {
      return _pageCount;
    }
    
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
    
    public function get selectedIndex():int
    {
      return _selectedIndex;
    }
    
    // --------------------------------------------
    // Methods
    // --------------------------------------------
    public function next():void
    {
      if (_selectedIndex < _pageCount - 1)
      {
        selectedIndex = _selectedIndex + 1;
      }
    }
    
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
        item.alpha = 0.5;
        item.invalidateDisplayList();
      }
      
      item = PageIndicatorItem(_itemContainer.getElementAt(_selectedIndex));
      item.alpha = 1;
    }
    
    private function createPageItem():PageIndicatorItem
    {
      var result:PageIndicatorItem = new PageIndicatorItem();
      result.size = this.getStyle("pageItemSize");
      result.fillColor = this.getStyle("pageItemColor");
      
      return result;
    }
  }
}
