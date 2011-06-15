package com.piaction.components
{
  import com.piaction.skins.ios.PopOverSkin;
  
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import spark.components.SkinnablePopUpContainer;
  import spark.primitives.Rect;
  
  [SkinState("topPosition")]
  [SkinState("rightPosition")]
  [SkinState("bottomPosition")]
  [SkinState("leftPosition")]
  public class PopOver extends SkinnablePopUpContainer
  {
    
    public static const VERTICAL_DIRECTION:String = "vertical";
    public static const HORIZONTAL_DIRECTION:String = "horizontal";
    
    public static const TOP_POSITION:String = "topPosition";
    public static const BOTTOM_POSITION:String = "bottomPosition";
    public static const RIGHT_POSITION:String = "rightPosition";
    public static const LEFT_POSITION:String = "leftPosition";
    
    protected var _target:DisplayObject;
    protected var _direction:String = VERTICAL_DIRECTION;
    protected var _currentPosition:String = TOP_POSITION;
    
    protected var _targetCenterOffset:int;
    
    public function PopOver()
    {
      super();
      
      setStyle("skinClass", PopOverSkin);
    }
    
    override public function open(owner:DisplayObjectContainer, modal:Boolean=false):void
    {
      super.open(owner, modal);
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      var targetRect:Rectangle = target.getRect(this.owner);
      var contentRect:Rectangle = owner.getRect(this.owner);
      var contentOffset:Rectangle = owner.getRect(parent);
      
      var leftRect:Rectangle = new Rectangle(
        0, 0,
        Math.max(targetRect.x, 0), contentRect.height);
      
      var rightRect:Rectangle = new Rectangle(
        Math.max(targetRect.x + targetRect.width, 0), 0,
        Math.min(contentRect.width - targetRect.x - targetRect.width, contentRect.width), contentRect.height);
      
      var topRect:Rectangle = new Rectangle(
        0, 0,
        contentRect.width, Math.max(targetRect.y, 0));
      
      var bottomRect:Rectangle = new Rectangle(
        0, Math.max(targetRect.y + targetRect.height,0), 
        contentRect.width, Math.min(contentRect.height - targetRect.y - targetRect.height, contentRect.height));
      
      var globalPosition:Point;
      var parrentPosition:Point;
      
      var newXPosition:int;
      var newYPosition:int;
      var xOffset:int = 0;
      var yOffset:int = 0;
      if(_direction == VERTICAL_DIRECTION)
      {
        if(topRect.height > bottomRect.height)
        {
          newYPosition = topRect.height - this.height;
          
          _currentPosition = TOP_POSITION;
        }
        else
        {
          newYPosition = bottomRect.y;
          _currentPosition = BOTTOM_POSITION;
        }
        
        newXPosition = targetRect.x + targetRect.width/2 - this.width/2;
        
        if(newXPosition + this.width > contentRect.width)
        {
          xOffset = (contentRect.width - this.width) - newXPosition;
        }
        if(newXPosition < 0)
        {
          xOffset = -newXPosition;
        }
        
        
      }
      else if(_direction == HORIZONTAL_DIRECTION)
      {
        if(leftRect.width > rightRect.width)
        {
          newXPosition = leftRect.width - this.width;
          _currentPosition = LEFT_POSITION;
        }
        else
        {
          newXPosition = rightRect.x;
          _currentPosition = RIGHT_POSITION;
        }
        
        newYPosition = targetRect.y + targetRect.height/2 - this.height/2;
        
        if(newYPosition + this.height > contentRect.height)
        {
          yOffset = (contentRect.height - this.height) - newYPosition;
        }
        if(newYPosition < 0)
        {
          yOffset = -newYPosition;
        }
      }
      
      this.x = contentOffset.x + newXPosition + xOffset;
      this.y = contentOffset.y + newYPosition + yOffset;
      
      var targetParentRect:Rectangle = target.getBounds(this.parent);
      if(_direction == VERTICAL_DIRECTION)
      {
        _targetCenterOffset = (targetParentRect.x + targetParentRect.width/2) - (this.x + unscaledWidth/2);
      }
      else
      {
        _targetCenterOffset = (targetParentRect.y + targetParentRect.height/2) - (this.y + unscaledHeight/2);
      }

      invalidateSkinState();
    }
    
    override protected function getCurrentSkinState():String
    {
      return _currentPosition;
    }
    
    public function get target():DisplayObject
    {
      return _target;
    }
    
    public function set target(value:DisplayObject):void
    {
      _target = value;
    }
    
    override protected function measure():void {
      
      super.measure();
      
      
    }

    public function get direction():String
    {
      return _direction;
    }

    public function set direction(value:String):void
    {
      _direction = value;
    }

    public function get currentPosition():String
    {
      return _currentPosition;
    }

    public function get targetCenterOffset():int
    {
      return _targetCenterOffset;
    }


  }
  
}