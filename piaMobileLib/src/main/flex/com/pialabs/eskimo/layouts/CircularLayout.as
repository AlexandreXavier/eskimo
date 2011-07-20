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
    /**
     * @private
     */
    private var _angle:Number = 0;
    /**
     * @private
     */
    private var _itemWidth:Number = 75;
    /**
     * @private
     */
    private var _itemHeight:Number = 75;
    /**
     * @private
     */
    private var _depthRation:Number = 0.5;
    /**
     * @private
     */
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
    
    /**
     * Current rotation angle of the layout
     */
    public function get angle():Number
    {
      return _angle;
    }
    
    /**
     * @private
     */
    public function set angle(value:Number):void
    {
      _angle = value;
      target.invalidateDisplayList();
    }
    
    /**
     * Width of an item
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
      target.invalidateDisplayList();
    }
    
    /**
     * Height of an item
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
      target.invalidateDisplayList();
    }
    
    /**
     * Depth of the farest item (between 0 and 1).
     */
    public function get depthRation():Number
    {
      return _depthRation;
    }
    
    /**
     * @private
     */
    public function set depthRation(value:Number):void
    {
      value = Math.min(0.99, value);
      value = Math.max(0, value);
      _depthRation = value;
      target.invalidateDisplayList();
    }
    
    /**
     * Height ratio (normaly between -1 and 1).
     * 0 is equivalent to horizontal circle layout and 1, -1 to vertical circle layout.
     */
    public function get heightRatio():Number
    {
      return _heightRatio;
    }
    
    /**
     * @private
     */
    public function set heightRatio(value:Number):void
    {
      _heightRatio = value;
      target.invalidateDisplayList();
    }
  
  
  }
}
