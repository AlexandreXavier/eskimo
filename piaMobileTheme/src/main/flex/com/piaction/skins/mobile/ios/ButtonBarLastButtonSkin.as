package com.piaction.skins.mobile.ios
{
    import com.piaction.skins.mobile.ios.assets.ButtonBarLast_down;
    import com.piaction.skins.mobile.ios.assets.ButtonBarLast_fill;
    import com.piaction.skins.mobile.ios.assets.ButtonBarLast_selected;
    import com.piaction.skins.mobile.ios.assets.ButtonBarLast_up;
    import com.piaction.skins.mobile.ios.assets.ButtonBarMiddle_fill;
    import com.piaction.skins.mobile.ios.assets.ButtonBarMiddle_up;
    import com.piaction.skins.mobile.ios.assets.Button_down;
    import com.piaction.skins.mobile.ios.assets.Button_fill;
    import com.piaction.skins.mobile.ios.assets.Button_up;
    
    import flash.display.DisplayObject;
    
    import mx.core.DPIClassification;
    
    import spark.skins.mobile.supportClasses.MobileSkin;
    
    /**
     * The IOS skin class for the last Button of ButtonBar component.
     *
     *  @see spark.components.ButtonBar
     */
    public class ButtonBarLastButtonSkin extends ButtonSkin
    {
        public function ButtonBarLastButtonSkin()
        {
            super();
            
            switch (applicationDPI)
            {
                case DPIClassification.DPI_320:
                case DPIClassification.DPI_240:
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
                    
                    upBorderSkin = ButtonBarLast_up;
                    downBorderSkin = ButtonBarLast_down;
                    selectedBorderSkin = ButtonBarLast_selected;
                    fillClass = ButtonBarLast_fill;
                    
                    break;
                }
            }
            
            // beveled buttons do not scale down
            minHeight = measuredDefaultHeight;
        }
        
        /**
         *  @private
         */
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
