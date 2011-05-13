package com.piaction.layouts
{
  import flash.display.Sprite;
  import flash.geom.Point;
  
  import mx.core.ILayoutElement;
  import mx.core.IVisualElement;
  import mx.core.UIComponent;
  import mx.effects.Tween;
  
  import spark.layouts.supportClasses.LayoutBase;
  import spark.primitives.Rect;
  
  public class SlideLayout  extends LayoutBase
  {
    public static var VERTICAL:String = "vertical";
    public static var HORIZONTAL:String = "horizontal";
    
    private var _mask:Sprite = new Sprite();
    
    protected var _tween:Tween;
    protected var _oldIndex:int = -1;
    
    protected var _index:uint = 0;
    
    public var direction:int = 1;
    
    public var orientation:String = HORIZONTAL;
    
    private var _newElement:IVisualElement;
    private var _oldElement:IVisualElement

    
    public function get index() : Number
    {
      return _index;
    }
    
    public function set index(value:Number):void
    {
      if (_index != value && target != null && value >= 0 && value < target.numElements)
      {
        if (_tween != null && _oldIndex>=0)
        {
          _tween.endTween();
        }
        _oldIndex = _index
        _index = value;
        target.invalidateDisplayList();
      }
      
    }
    
    override public function updateDisplayList(width:Number, height:Number):void
    {
      super.updateDisplayList(width, height);
      var numElements:int = target.numElements;
      
      if(_oldIndex == -1 )
      {
        for (var i:uint = 0; i < numElements; i++)
        {
          var element:IVisualElement = getVisualElement(i);
          if (i == index)
          {
            showVisualElement(element,true);
            element.setLayoutBoundsSize(width, height);
            element.setLayoutBoundsPosition(0,0);
          }
          else
          {
            showVisualElement(element,false);
          }
        }
      }
      else
      {
        createViewPort(width, height);
        
        _newElement = getVisualElement(_index);
        showVisualElement(_newElement, true);
        _newElement.setLayoutBoundsSize(width, height);
        
        if (orientation == HORIZONTAL)
        {
          _newElement.setLayoutBoundsPosition(-direction * width, 0);
        }
        else if (orientation == VERTICAL)
        {
          _newElement.setLayoutBoundsPosition(0, -direction * height);
        }
        _oldElement = getVisualElement(_oldIndex);
        
        _tween=new Tween(this, 0, width, 300, 30, tweenUpdateHandler, tweenEndHandler);
      }
    }
    
    
    private function createViewPort(width:Number, height:Number):void
    {
      var targetPosition:Point = target.localToGlobal(new Point())
      _mask.graphics.clear();
      _mask.graphics.beginFill(0xFFFFFF);
      _mask.graphics.drawRect(targetPosition.x, targetPosition.y, width, height);
      _mask.graphics.endFill();
      target.mask = _mask
    }
    
    private function tweenUpdateHandler(value:String):void
    {
      var position:int = int(value);
      
      if (orientation == HORIZONTAL)
      {
        _newElement.setLayoutBoundsPosition(direction * position - direction * _oldElement.width, 0);
      
        _oldElement.setLayoutBoundsPosition(direction * position, 0);
      }
      else if (orientation == VERTICAL)
      {
        _newElement.setLayoutBoundsPosition(0, direction * position - direction * _oldElement.height);
        
        _oldElement.setLayoutBoundsPosition(0, direction * position);
      }
    }
    
    private function tweenEndHandler(value:String):void
    {
      _newElement.setLayoutBoundsPosition(0, 0);
      
      showVisualElement(_oldElement, false);
      
      _oldIndex = -1
        
      target.mask = null;
    }
    
    protected function showVisualElement(element:IVisualElement, show:Boolean):void
    {
      element.visible = show;
      element.includeInLayout = show;
    }
    
    protected function getVisualElement(index:int):IVisualElement
    {
      var element:IVisualElement;
      if(useVirtualLayout)
      {
        element= target.getVirtualElementAt(index);
      }
      else
      {
        element=target.getElementAt(index);
      }
      return element;
    }
    
  }
} 