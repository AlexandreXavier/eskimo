package com.piaction.skins.mobile.ios
{
    
    import com.piaction.skins.mobile.ios.assets.HSliderThumb_up;
    
    /**
     * Skin for the HSlider thumb
     * @see spark.components.HSlider
     */
    public class HSliderThumbSkin extends ButtonSkin
    {
        
        /**
         * Constructor
         */
        public function HSliderThumbSkin()
        {
            super();
            
            upBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderThumb_up;
            downBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderThumb_down;
            fillClass = null;
            
            measuredDefaultWidth = 29;
            measuredDefaultHeight = 29;
            
            measuredMinWidth = 29;
            measuredMinHeight = 29;
        }
    }
}
