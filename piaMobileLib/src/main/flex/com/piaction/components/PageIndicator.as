package com.piaction.components
{
  import mx.graphics.SolidColor;
  import mx.graphics.SolidColorStroke;
  
  import spark.components.BorderContainer;
  import spark.components.HGroup;
  import spark.primitives.Ellipse;
  
  public class PageIndicator extends BorderContainer
  {
    // constants
    public static var ITEM_GAP:int = 18;
    
    // properties 
    private var _selectedIndex:int = 0;
    private var _previousIndex:int = 0;
    private var _selectedIndexChanged:Boolean = true;
    
    private var _pageCount:int = 1;
    private var _previousPageCount:int = 0;
    private var _pageCountChanged:Boolean = true;
    
    private var _itemSize:int = 14;
    
    // component
    private var _itemContainer:HGroup;
    private var _sizeChanged:Boolean = true;
    
    public function PageIndicator()
    {
      super();
      this.percentWidth = 100;
      this.backgroundFill = new SolidColor(0);
      this.minHeight = 40;
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (_itemContainer == null)
      {
        _itemContainer = new HGroup();
        _itemContainer.percentHeight = 100;
        _itemContainer.gap = ITEM_GAP;
        _itemContainer.verticalAlign = "middle";
        
        _itemContainer.setStyle("paddingLeft", ITEM_GAP);
        _itemContainer.setStyle("paddingRight", ITEM_GAP);
        
        this.addElement(_itemContainer);
      }
    }
    
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_pageCountChanged)
      {
        updatePageItems();
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
        var itemsWidth:int = pageCount * _itemSize;
        var intervalsWidth:int = (_pageCount - 1) * ITEM_GAP;
        var bordersWidth:int = ITEM_GAP * 2;
        _itemContainer.width = itemsWidth + intervalsWidth + bordersWidth;
        _sizeChanged = false;
      }
    }
    
    // --------------------------------------------
    // Accessors
    // --------------------------------------------
    public function set pageCount(value:int):void
    {
      if (value != _pageCount && value > _selectedIndex)
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
        while (_itemContainer.columnCount != _pageCount)
        {
          _itemContainer.removeElementAt(_pageCount);
        }
        /*gap = _pageCount - _previousPageCount;
        for (index = _pageCount; index > gap; index--)
        {
          _itemContainer.removeElementAt(index);
        }*/
      }
    }
    
    private function updateSelectedItem():void
    {
      var item:PageIndicatorItem = PageIndicatorItem(_itemContainer.getElementAt(_previousIndex))
      item.alpha = 0.5;
      
      item.invalidateDisplayList();
      item = PageIndicatorItem(_itemContainer.getElementAt(_selectedIndex));
      item.alpha = 1;
    }
    
    private function createPageItem():PageIndicatorItem
    {
      var result:PageIndicatorItem = new PageIndicatorItem();
      // TODO : add accessible style for bullet
      result.size = 14;
      result.fillColor = 0xFFFFFF;
      
      return result;
    }
  
  }
}
