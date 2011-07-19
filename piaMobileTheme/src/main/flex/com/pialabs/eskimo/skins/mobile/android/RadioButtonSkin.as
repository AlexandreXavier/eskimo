package com.pialabs.eskimo.skins.mobile.android
{
    import flash.display.DisplayObject;
    
    import spark.components.IconPlacement;
    import spark.skins.mobile.RadioButtonSkin;
    
    /**
     * The android skin class for the Spark RadioButton component.
     * 
     * Extends spark.skins.mobile.RadioButtonSkin to have space between the radiobutton and its label.
     * 
     * @see spark.components.RadioButton
     * 
     */
    public class RadioButtonSkin extends spark.skins.mobile.RadioButtonSkin
    {
        public function RadioButtonSkin()
        {
            super();
        }
        
        /**
         *  @private
         */
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            var iconPlacement:String = getStyle("iconPlacement");
            var isHorizontal:Boolean = (iconPlacement == IconPlacement.LEFT || iconPlacement == IconPlacement.RIGHT);
            
            var iconX:Number = 0;
            var iconY:Number = 0;
            var unscaledIconWidth:Number = 0;
            var unscaledIconHeight:Number = 0;
            
            var iconDisplay:DisplayObject = getIconDisplay();
            
            var viewWidth:Number = Math.max(unscaledWidth - layoutPaddingLeft - layoutPaddingRight, 0);
            var viewHeight:Number = Math.max(unscaledHeight - layoutPaddingTop - layoutPaddingBottom, 0);
            
            
            if (iconDisplay)
            {
                unscaledIconWidth = getElementPreferredWidth(iconDisplay);
                unscaledIconHeight = getElementPreferredHeight(iconDisplay);
            }
            
            var iconViewWidth:Number = Math.min(unscaledIconWidth, viewWidth);
            var iconViewHeight:Number = Math.min(unscaledIconHeight, viewHeight);
            
            if (isHorizontal)
            {
                if (iconPlacement == IconPlacement.RIGHT)
                {
                    iconX = unscaledWidth - layoutPaddingRight - iconViewWidth;
                    iconY = (viewHeight - iconViewHeight) / 2;
                    
                    setElementSize(iconDisplay, iconViewWidth, iconViewHeight);
                    setElementPosition(iconDisplay, iconX, iconY);
                    
                    // position the symbols to align with the background "icon"
                    if (symbolIcon)
                    {
                        setElementPosition(symbolIcon, iconDisplay.x, iconDisplay.y);
                    }
                }
                
            }
        
        }
    }
}
