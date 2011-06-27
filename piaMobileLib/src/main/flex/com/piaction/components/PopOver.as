package com.piaction.components
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import spark.components.SkinnablePopUpContainer;
    
    /**
     * Skin states
     */
    [SkinState("topPosition")]
    [SkinState("rightPosition")]
    [SkinState("bottomPosition")]
    [SkinState("leftPosition")]
    [SkinState("topPositionAndClosed")]
    [SkinState("rightPositionAndClosed")]
    [SkinState("bottomPositionAndClosed")]
    [SkinState("leftPositionAndClosed")]
    
    /**
     * Color of popup's background
     */
    [Style(name = "popupBackgroundColor", inherit = "no", type = "uint")]
    
    public class PopOver extends SkinnablePopUpContainer
    {
        /**
         * Vertical direction
         */
        public static const VERTICAL_DIRECTION:String = "vertical";
        /**
         * Horizontal direction
         */
        public static const HORIZONTAL_DIRECTION:String = "horizontal";
        
        /**
         * Positions of the pop over per head of the target
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
         * Overlappig limit of the target by the pop over
         */
        public static var LIMIT_TARGET_OVERLAPING:int = 10;
        
        /**
         * Constructor
         */
        public function PopOver()
        {
            super();
        }
        
        /**
         *  Opens the container as a pop-over, and set is position autaumaticaly.
         */
        override public function open(owner:DisplayObjectContainer, modal:Boolean = false):void
        {
            _authorizeSkinInvalidation = false;
            super.open(owner, modal);
            _authorizeSkinInvalidation = true;
            
            _currentPosition = UNKNOW_POSITION
            
            invalidateDisplayList();
        }
        
        /**
         * @private
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (target == null)
            {
                _currentPosition = UNKNOW_POSITION;
                invalidateSkinState();
                return;
            }
            
            //create rectange in owner coordinates
            var targetRect:Rectangle = target.getRect(this.owner);
            var contentRect:Rectangle = owner.getRect(this.owner);
            
            var globalPosition:Point;
            var parrentPosition:Point;
            
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
        
        private function updateVerticalPosition(contentRect:Rectangle, targetRect:Rectangle):void
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
            
            var contentOffset:Rectangle = owner.getRect(parent);
            newXPosition += contentOffset.x + xOffset;
            newYPosition += contentOffset.y + yOffset;
            
            //We positionnate the pop-over
            this.x = newXPosition;
            this.y = newYPosition;
        }
        
        private function updateHorizontalPosition(contentRect:Rectangle, targetRect:Rectangle):void
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
            
            var contentOffset:Rectangle = owner.getRect(parent);
            newXPosition += contentOffset.x + xOffset;
            newYPosition += contentOffset.y + yOffset;
            
            //We positionnate the pop-over
            this.x = newXPosition;
            this.y = newYPosition;
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
         * Set the target og the pop over
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
         * the direction of the pop-up
         *
         * If the direction is setted to vertical, the pop-over can take the position top or bottom
         * And if the direction is setted to horizontal, the pop-over can take the position left or right
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
         * Position of the pop-over regards of the target
         */
        public function get currentPosition():String
        {
            return _currentPosition;
        }
        
        /**
         * @private
         */
        public function get targetCenterOffset():int
        {
            return _targetCenterOffset;
        }
    
    }
}
