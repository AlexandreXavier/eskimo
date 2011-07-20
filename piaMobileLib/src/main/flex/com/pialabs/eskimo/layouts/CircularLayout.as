package com.pialabs.eskimo.layouts
{
  import flash.display.DisplayObject;
  
  import mx.core.IVisualElement;
  
  import spark.layouts.supportClasses.LayoutBase;
  
  public class CircularLayout extends LayoutBase
  {
    private var _angle:Number = 0;
    
    private var _itemWidth:Number = 75;
    private var _itemHeight:Number = 75;
    
    public function CircularLayout()
    {
      super();
    }
    
    /**
     * @private
     */
    override public function updateDisplayList(width:Number, height:Number):void
    {
      super.updateDisplayList(width, height);
      var numElements:int = target.numElements;
      
      var index:int = 0;
      
      for (var i:uint = 0; i < numElements; i++)
      {
        var element:IVisualElement = getVisualElement(i);
        var sizeRatio:Number = (Math.sin(i * 2 * Math.PI / numElements + _angle)) / 3 + 1;
        var elementWidth:Number = _itemWidth * sizeRatio;
        var elementHeight:Number = _itemHeight * sizeRatio;
        var elementX:Number = Math.cos(i * 2 * Math.PI / numElements + _angle) * (width - elementWidth) / 2 + (width - elementWidth) / 2;
        var elementY:Number = Math.sin(i * 2 * Math.PI / numElements + _angle) * (height - elementHeight) / 2 + (height - elementHeight) / 2;
        
        element.setLayoutBoundsPosition(elementX, elementY);
        element.setLayoutBoundsSize(elementWidth, elementHeight);
        
        element.depth = sizeRatio;
      }
    }
    
    /**
     * @private
     */
    protected function getVisualElement(index:int):IVisualElement
    {
      var element:IVisualElement;
      if (useVirtualLayout)
      {
        element = target.getVirtualElementAt(index);
      }
      else
      {
        element = target.getElementAt(index);
      }
      return element;
    }
    
    public function get angle():Number
    {
      return _angle;
    }
    
    public function set angle(value:Number):void
    {
      _angle = value;
      target.invalidateDisplayList();
    }
    
    public function get itemWidth():Number
    {
      return _itemWidth;
    }
    
    public function set itemWidth(value:Number):void
    {
      _itemWidth = value;
      target.invalidateDisplayList();
    }
    
    public function get itemHeight():Number
    {
      return _itemHeight;
    }
    
    public function set itemHeight(value:Number):void
    {
      _itemHeight = value;
      target.invalidateDisplayList();
    }
  
  
  }
}
