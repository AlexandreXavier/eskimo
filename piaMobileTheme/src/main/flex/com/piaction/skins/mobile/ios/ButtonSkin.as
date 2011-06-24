package com.piaction.skins.mobile.ios
{
    import com.piaction.skins.mobile.ios.assets.Button_down;
    import com.piaction.skins.mobile.ios.assets.Button_fill;
    import com.piaction.skins.mobile.ios.assets.Button_up;
    
    import flash.display.DisplayObject;
    
    import mx.core.DPIClassification;
    
    import spark.skins.mobile.ButtonSkin;
    import spark.skins.mobile.supportClasses.MobileSkin;
    
    
    public class ButtonSkin extends spark.skins.mobile.ButtonSkin
    {
        public function ButtonSkin()
        {
            super();
            
            switch (applicationDPI)
            {
                case DPIClassification.DPI_320:
                {
                    // 320
                    layoutBorderSize = 0;
                    layoutPaddingTop = 0;
                    layoutPaddingBottom = 0;
                    layoutPaddingLeft = 20;
                    layoutPaddingRight = 20;
                    measuredDefaultWidth = 116;
                    measuredDefaultHeight = 54;
                    
                    upBorderSkin = Button_up;
                    downBorderSkin = Button_down;
                    fillClass = Button_fill;
                    
                    break;
                }
                case DPIClassification.DPI_240:
                {
                    // 240
                    layoutBorderSize = 0;
                    layoutPaddingTop = 0;
                    layoutPaddingBottom = 0;
                    layoutPaddingLeft = 15;
                    layoutPaddingRight = 15;
                    measuredDefaultWidth = 87;
                    measuredDefaultHeight = 42;
                    
                    upBorderSkin = Button_up;
                    downBorderSkin = Button_down;
                    fillClass = Button_fill;
                    
                    break;
                }
                default:
                {
                    // 160
                    layoutBorderSize = 0;
                    layoutPaddingTop = 0;
                    layoutPaddingBottom = 0;
                    layoutPaddingLeft = 10;
                    layoutPaddingRight = 10;
                    measuredDefaultWidth = 58;
                    measuredDefaultHeight = 28;
                    
                    upBorderSkin = Button_up;
                    downBorderSkin = Button_down;
                    fillClass = Button_fill;
                    
                    break;
                }
            }
            
            // beveled buttons do not scale down
            minHeight = measuredDefaultHeight;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        private var _fill:DisplayObject;
        
        public var fillClass:Class;
        
        private var colorized:Boolean;
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         */
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            super.labelDisplayShadow.y = super.labelDisplayShadow.y - 2;
            
            // add separate chromeColor fill graphic as the first layer
            if (!_fill && fillClass)
            {
                _fill = new fillClass();
                addChildAt(_fill, 0);
            }
            
            if (_fill)
            {
                // move to the first layer
                if (getChildIndex(_fill) > 0)
                {
                    removeChild(_fill);
                    addChildAt(_fill, 0);
                }
                
                setElementSize(_fill, unscaledWidth, unscaledHeight);
            }
        }
        
        /**
         *  @private
         */
        override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
        {
            // omit call to super.drawBackground(), apply tint instead and don't draw fill
            var chromeColor:uint = getStyle("chromeColor");
            
            if (colorized || (chromeColor != 0xCCCCCC))
            {
                // apply tint instead of fill
                applyColorTransform(_fill, 0xCCCCCC, chromeColor);
                
                // if we restore to original color, unset colorized
                colorized = (chromeColor != 0xCCCCCC);
            }
        }
    }
}
