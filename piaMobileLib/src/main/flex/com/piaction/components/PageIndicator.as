package com.piaction.components
{
  import mx.graphics.SolidColor;
  
  import spark.components.BorderContainer;
  import spark.components.HGroup;
  import spark.primitives.Rect;
  
  public class PageIndicator extends BorderContainer
  {
    // properties 
    private var _selectedIndex:int = 0;
    private var _previousIndex:int = 0;
    private var _selectedIndexChanged:Boolean = true;
    
    private var _pageCount:int = 1;
    private var _previousPageCount:int = 0;
    private var _pageCountChanged:Boolean = true;
    
    // component
    private var _itemContainer:HGroup;
    
    public function PageIndicator()
    {
      super();
      this.backgroundFill = new SolidColor(0);
      this.minHeight = 40;
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (_itemContainer == null)
      {
        _itemContainer = new HGroup();
        _itemContainer.percentWidth = 100;
        _itemContainer.height = 30;
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
    
    // --------------------------------------------
    // Accessors
    // --------------------------------------------
    public function set pageCount(value:int):void
    {
      if (value != _pageCount)
      {
        _previousPageCount = _pageCount;
        _pageCount = value;
        _pageCountChanged = true;
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
      if (_selectedIndex != value)
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
      if (_selectedIndex < _pageCount)
      {
        _previousIndex = _selectedIndex;
        _selectedIndex++;
        _selectedIndexChanged = true;
      }
    }
    
    public function previous():void
    {
      if (_selectedIndex > 0)
      {
        _previousIndex = _selectedIndex;
        _selectedIndex--;
        _selectedIndexChanged = true;
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
          _itemContainer.addElement(new PageIndicatorItem());
        }
      }
      else
      {
        // remove elements
        gap = _pageCount - _previousPageCount;
        for (index = _pageCount; index > gap; index--)
        {
          _itemContainer.removeElementAt(index);
        }
      }
    }
    
    private function updateSelectedItem():void
    {
      var item:PageIndicatorItem = PageIndicatorItem(_itemContainer.getElementAt(_previousIndex));
      item.opacity = 0.5;
      item = PageIndicatorItem(_itemContainer.getElementAt(_selectedIndex));
      item.opacity = 1;
    }
  
  
  }
}
