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
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.StageOrientationEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.core.FlexGlobals;
  import mx.events.FlexEvent;
  
  import spark.components.SkinnablePopUpContainer;
  
  /**
   * Top position skin state
   */
  [SkinState("topPosition")]
  /**
   * Right position skin state
   */
  [SkinState("rightPosition")]
  /**
   * Bottom position skin state
   */
  [SkinState("bottomPosition")]
  /**
   * Left position skin state
   */
  [SkinState("leftPosition")]
  /**
   * Top position and closed skin state
   */
  [SkinState("topPositionAndClosed")]
  /**
   * Right position and closed skin state
   */
  [SkinState("rightPositionAndClosed")]
  /**
   * Bottom position and closed skin state
   */
  [SkinState("bottomPositionAndClosed")]
  /**
   * Left position and closed skin state
   */
  [SkinState("leftPositionAndClosed")]
  
  /**
   * A popOver is a mix between a popUp and a tooltip. It displays a kind of popUp close to a display object.
   */
  public class PopOver extends SkinnablePopUpContainer
  {
    /**
     * Vertical direction.
     */
    public static const VERTICAL_DIRECTION:String = "vertical";
    /**
     * Horizontal direction.
     */
    public static const HORIZONTAL_DIRECTION:String = "horizontal";
    
    /**
     * Positions of the pop over relative to the target.
     */
    public static const UNKNOW_POSITION:String = "unknowPosition";
    public static const TOP_POSITION:String = "topPosition";
    public static const BOTTOM_POSITION:String = "bottomPosition";
    public static const RIGHT_POSITION:String = "rightPosition";
    public static const LEFT_POSITION:String = "leftPosition";
    
    /**
     * @private
     */
    protected var _target:DisplayObject;
    protected var _direction:String = VERTICAL_DIRECTION;
    protected var _currentPosition:String = UNKNOW_POSITION;
    protected var _targetCenterOffset:int;
    
    /**
     * @private
     */
    private var _authorizeSkinInvalidation:Boolean = true;
    
    /**
     * Overlappig limit of the target by the pop over.
     *
     * @defaults 10 px
     */
    public static var LIMIT_TARGET_OVERLAPING:int = 10;
    
    /**
     * Constructor
     */
    public function PopOver()
    {
      super();
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, onAddedToStage, false, 0, true);
    }
    
    /**
     *  Display the PopOver, and set is position autaumaticaly.
     */
    override public function open(owner:DisplayObjectContainer, modal:Boolean = false):void
    {
      _authorizeSkinInvalidation = false;
      super.open(owner, modal);
      _authorizeSkinInvalidation = true;
      
      _currentPosition = UNKNOW_POSITION;
      
      invalidateDisplayList();
    }
    
    protected function onAddedToStage(event:Event):void
    {
      owner.addEventListener(Event.RESIZE, ownerSizeChange, false, 0, true);
    }
    
    /**
     * @private
     */
    protected function removeFromStage(event:Event):void
    {
      owner.removeEventListener(Event.RESIZE, ownerSizeChange);
    }
    
    /**
     * @private
     */
    protected function ownerSizeChange(event:Event):void
    {
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      layoutComponent(unscaledWidth, unscaledHeight);
    }
    
    /**
     * Set the position of the popOver relative to the coordinates of the targetted display object.
     */
    protected function layoutComponent(unscaledWidth:Number, unscaledHeight:Number):void
    {
      if (target == null)
      {
        _currentPosition = UNKNOW_POSITION;
        invalidateSkinState();
        return;
      }
      
      //create rectange in owner coordinates
      var targetRect:Rectangle = target.getRect(this.owner);
      var contentRect:Rectangle = owner.getRect(this.owner);
      contentRect.width = owner.width;
      contentRect.height = owner.height;
      
      var globalPosition:Point;
      var parentPosition:Point;
      
      //if the direction is vertical
      if (_direction == VERTICAL_DIRECTION)
      {
        updateVerticalPosition(contentRect, targetRect);
      }
      //else if the dirrection is horizontal
      else if (_direction == HORIZONTAL_DIRECTION)
      {
        updateHorizontalPosition(contentRect, targetRect);
      }
      
      //Then wee loop if the pop-over is front of his target
      var targetParentRect:Rectangle = target.getBounds(this.parent);
      if (_direction == VERTICAL_DIRECTION)
      {
        _targetCenterOffset = (targetParentRect.x + targetParentRect.width / 2) - (this.x + unscaledWidth / 2);
      }
      else
      {
        _targetCenterOffset = (targetParentRect.y + targetParentRect.height / 2) - (this.y + unscaledHeight / 2);
      }
      
      invalidateSkinState();
    }
    
    /**
     * @private
     */
    protected function updateVerticalPosition(contentRect:Rectangle, targetRect:Rectangle):void
    {
      var topRect:Rectangle = new Rectangle(0, 0, contentRect.width, Math.max(targetRect.y, 0));
      
      var bottomRect:Rectangle = new Rectangle(0, Math.max(targetRect.y + targetRect.height, 0), contentRect.width, Math.min(contentRect.height - targetRect.y - targetRect.height, contentRect.height));
      
      var newXPosition:int;
      var newYPosition:int;
      
      var xOffset:int = 0;
      var yOffset:int = 0;
      
      //If there is more place in the top space
      if (topRect.height > bottomRect.height)
      {
        // we put the bottom side of the pop-over in front of the target's top side
        newYPosition = topRect.height - unscaledHeight;
        
        // If the pop-over is out of the ower rect we can start overlapping of the target
        if (newYPosition < 0)
        {
          newYPosition = Math.min(0, targetRect.y + targetRect.height - unscaledHeight - LIMIT_TARGET_OVERLAPING);
        }
        
        _currentPosition = TOP_POSITION;
      }
      //If there is more place in the bottom space
      else
      {
        // we put the top side of the pop-over in front of the target's bottom side
        newYPosition = bottomRect.y;
        
        // If the pop-over is out of the ower rect we can start overlapping of the target
        if (newYPosition > contentRect.height - unscaledHeight)
        {
          newYPosition = Math.max(contentRect.height - unscaledHeight, targetRect.y + LIMIT_TARGET_OVERLAPING);
        }
        
        _currentPosition = BOTTOM_POSITION;
      }
      
      // compute X position
      newXPosition = targetRect.x + targetRect.width / 2 - this.width / 2;
      
      if (newXPosition + unscaledWidth > contentRect.width)
      {
        xOffset = (contentRect.width - unscaledWidth) - newXPosition;
      }
      if (newXPosition < 0)
      {
        xOffset = -newXPosition;
      }
      
      var contentOffset:Rectangle = parent.getRect(owner);
      newXPosition += -contentOffset.x + xOffset;
      newYPosition += -contentOffset.y + yOffset;
      
      //We positionnate the pop-over
      setLayoutBoundsPosition(newXPosition, newYPosition);
    }
    
    /**
     * @private
     */
    protected function updateHorizontalPosition(contentRect:Rectangle, targetRect:Rectangle):void
    {
      //Compute the différente available spaces (top, right, bottom and left)
      var leftRect:Rectangle = new Rectangle(0, 0, Math.max(targetRect.x, 0), contentRect.height);
      
      var rightRect:Rectangle = new Rectangle(Math.max(targetRect.x + targetRect.width, 0), 0, Math.min(contentRect.width - targetRect.x - targetRect.width, contentRect.width), contentRect.height);
      
      var newXPosition:int;
      var newYPosition:int;
      
      var xOffset:int = 0;
      var yOffset:int = 0;
      
      //If there is more place in the left space
      if (leftRect.width > rightRect.width)
      {
        // we put the right side of the pop-over in front of the target's left side
        newXPosition = leftRect.width - unscaledWidth;
        
        // If the pop-over is out of the ower rect we can start overlapping of the target
        if (newXPosition < 0)
        {
          newXPosition = Math.min(0, targetRect.x + targetRect.width - unscaledWidth - LIMIT_TARGET_OVERLAPING);
        }
        
        _currentPosition = LEFT_POSITION;
      }
      //If there is more place in the right space
      else
      {
        // we put the left side of the pop-over in front of the target's right side
        newXPosition = rightRect.x;
        
        // If the pop-over is out of the ower rect we can start overlapping of the target
        if (newXPosition > contentRect.width - unscaledWidth)
        {
          newXPosition = Math.max(contentRect.width - unscaledWidth, targetRect.x + LIMIT_TARGET_OVERLAPING);
        }
        
        _currentPosition = RIGHT_POSITION;
      }
      
      // compute Y position
      newYPosition = targetRect.y + targetRect.height / 2 - unscaledHeight / 2;
      
      if (newYPosition + unscaledHeight > contentRect.height)
      {
        yOffset = (contentRect.height - unscaledHeight) - newYPosition;
      }
      if (newYPosition < 0)
      {
        yOffset = -newYPosition;
      }
      
      var contentOffset:Rectangle = parent.getBounds(owner);
      newXPosition += -contentOffset.x + xOffset;
      newYPosition += -contentOffset.y + yOffset;
      
      //We positionnate the pop-over
      setLayoutBoundsPosition(newXPosition, newYPosition);
    }
    
    /**
     * @private
     */
    override public function invalidateSkinState():void
    {
      if (_authorizeSkinInvalidation)
      {
        super.invalidateSkinState();
      }
    }
    
    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
      var skinState:String = super.getCurrentSkinState();
      if (_currentPosition != UNKNOW_POSITION)
      {
        skinState = isOpen ? _currentPosition : _currentPosition + "AndClosed";
      }
      return skinState;
    }
    
    /**
     * Display object targeted by the PopOver.
     */
    public function get target():DisplayObject
    {
      return _target;
    }
    
    /**
     * @private
     */
    public function set target(value:DisplayObject):void
    {
      _target = value;
    }
    
    [Inspectable(category = "General", enumeration = "vertical,horizontal", defaultValue = "vertical")]
    /**
     * The direction of the popOver.
     *
     * If the direction is set to vertical, the pop-over can take the position top or bottom.
     * And if the direction is set to horizontal, the pop-over can take the position left or right.
     *
     */
    public function set direction(value:String):void
    {
      _direction = value;
    }
    
    /**
     * @private
     */
    public function get direction():String
    {
      return _direction;
    }
    
    /**
     * Position of the popOver regards of the target. This position is defined automatically by the popOver regarding the requested direction and the available space on the screen.
     *
     * Possible values are :
     *   - TOP_POSITION
     *   - BOTTOM_POSITION
     *   - RIGHT_POSITION
     *   - LEFT_POSITION
     */
    public function get currentPosition():String
    {
      return _currentPosition;
    }
    
    /**
     * Difference in pixel between the center of target center and the pop-over center (horizontaly or verticaly).
     */
    public function get targetCenterOffset():int
    {
      return _targetCenterOffset;
    }
  
  }
}
