package com.piaction.skins.mobile.ios
{
    import com.piaction.skins.mobile.ios.assets.ActionBarBackground;
    
    import flash.display.DisplayObject;
    
    import spark.skins.mobile.ActionBarSkin;
    
    /**
     * The IOS skin class for the Spark ActionBar component.
     * @see spark.components.ActionBar
     */
    public class ActionBarSkin extends spark.skins.mobile.ActionBarSkin
    {
        
        
        /**
         * @private
         */
        private var _fill:DisplayObject;
        
        /**
         * The fill class of the button
         */
        public var fillClass:Class;
        
        
        public function ActionBarSkin()
        {
            super();
            
            fillClass = ActionBarBackground;
        }
        
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            // add separate chromeColor fill graphic as the first layer
            if (!_fill && fillClass)
            {
                _fill = new fillClass();
                addChildAt(_fill, 1);
            }
            
            if (_fill)
            {
                // move to the first layer
                if (getChildIndex(_fill) > 1)
                {
                    removeChild(_fill);
                    addChildAt(_fill, 1);
                }
                
                setElementSize(_fill, unscaledWidth, unscaledHeight - 1);
            }
        }
        
        /**
         *  @private
         */
        override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
        {
            var chromeColor:uint = getStyle("chromeColor");
            
            if ((chromeColor != 0x878787))
            {
                // apply tint instead of fill
                applyColorTransform(_fill, 0x878787, chromeColor);
            }
            
            graphics.clear();
            
            graphics.beginFill(0x2D3642, 1);
            
            graphics.drawRect(0, unscaledHeight - 1, unscaledWidth, 1);
            
            graphics.clear();
        }
    }
}
