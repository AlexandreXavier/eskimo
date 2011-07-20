package com.pialabs.eskimo.layouts
{
  import flash.display.DisplayObject;
  
  import mx.core.IVisualElement;
  
  import spark.layouts.supportClasses.LayoutBase;
  
  /**
  * Layout that order children in 3D circle.
  */
  public class CircularLayout extends LayoutBase
  {
    private var _angle:Number = 0;
    
    private var _itemWidth:Number = 75;
    private var _itemHeight:Number = 75;
    private var _depthRation:Number = 0.7;
    private var _heightRatio:Number = 1;
    
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
        var elementAngle:Number = i * 2 * Math.PI / numElements + _angle;
        var element:IVisualElement = getVisualElement(i);
        var sizeRatio:Number = ((Math.sin(elementAngle) + 1) / 2) * (1 - _depthRation) + _depthRation;
        var elementWidth:Number = _itemWidth * sizeRatio;
        var elementHeight:Number = _itemHeight * sizeRatio;
        var elementX:Number = Math.cos(elementAngle) * (width - _itemWidth) / 2 + (width - elementWidth) / 2;
        var elementY:Number = Math.sin(elementAngle) * (height - _itemHeight) * _heightRatio / 2 + (height - elementHeight) / 2;
        
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
    
    public function get depthRation():Number
    {
      return _depthRation;
    }
    
    public function set depthRation(value:Number):void
    {
      value = Math.min(0.99, value);
      value = Math.max(0, value);
      _depthRation = value;
      target.invalidateDisplayList();
    }
    
    public function get heightRatio():Number
    {
      return _heightRatio;
    }
    
    public function set heightRatio(value:Number):void
    {
      _heightRatio = value;
      target.invalidateDisplayList();
    }
  
  
  }
}
