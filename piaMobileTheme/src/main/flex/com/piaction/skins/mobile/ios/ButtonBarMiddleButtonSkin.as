package com.piaction.skins.mobile.ios
{
    import com.piaction.skins.mobile.ios.assets.ButtonBarMiddle_down;
    import com.piaction.skins.mobile.ios.assets.ButtonBarMiddle_fill;
    import com.piaction.skins.mobile.ios.assets.ButtonBarMiddle_selected;
    import com.piaction.skins.mobile.ios.assets.ButtonBarMiddle_up;
    import com.piaction.skins.mobile.ios.assets.Button_down;
    import com.piaction.skins.mobile.ios.assets.Button_fill;
    import com.piaction.skins.mobile.ios.assets.Button_up;
    
    import flash.display.DisplayObject;
    
    import mx.core.DPIClassification;
    
    import spark.skins.mobile.supportClasses.MobileSkin;
    
    
    public class ButtonBarMiddleButtonSkin extends ButtonSkin
    {
        public function ButtonBarMiddleButtonSkin()
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
                    
                    upBorderSkin = ButtonBarMiddle_up;
                    downBorderSkin = ButtonBarMiddle_down;
                    selectedBorderSkin = ButtonBarMiddle_selected;
                    fillClass = ButtonBarMiddle_fill;
                    
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
                    
                    upBorderSkin = ButtonBarMiddle_up;
                    downBorderSkin = ButtonBarMiddle_down;
                    selectedBorderSkin = ButtonBarMiddle_selected;
                    fillClass = ButtonBarMiddle_fill;
                    
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
                    
                    upBorderSkin = ButtonBarMiddle_up;
                    downBorderSkin = ButtonBarMiddle_down;
                    selectedBorderSkin = ButtonBarMiddle_selected;
                    fillClass = ButtonBarMiddle_fill;
                    
                    break;
                }
            }
            
            // beveled buttons do not scale down
            minHeight = measuredDefaultHeight;
        }
        
        
        protected var selectedBorderSkin:Class;
        
        /**
         *  @private
         */
        override protected function getBorderClassForCurrentState():Class
        {
            var isSelected:Boolean = currentState.indexOf("Selected") >= 0;
            
            if (isSelected && selectedBorderSkin)
            {
                return selectedBorderSkin;
            }
            else if (isSelected || currentState.indexOf("down") >= 0)
            {
                return downBorderSkin;
            }
            else
            {
                return upBorderSkin;
            }
        }
    }
}
