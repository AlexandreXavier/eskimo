package com.piaction.skins.mobile.ios
{
    import com.piaction.skins.mobile.ios.assets.HSliderTrack_fill;
    import com.piaction.skins.mobile.ios.assets.HSliderTrack_normal;
    
    import flash.display.DisplayObject;
    
    /**
     * Skin for the HSlider track
     * @see spark.components.HSlider
     */
    public class HSliderTrackSkin extends ButtonSkin
    {
        /**
         * Constructor
         */
        public function HSliderTrackSkin()
        {
            super();
            measuredDefaultHeight = 13;
            measuredDefaultWidth = 33;
            
            upBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderTrack_normal;
            downBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderTrack_normal;
            fillClass = HSliderTrack_fill;
            
            measuredMinHeight = measuredDefaultHeight;
            measuredMinWidth = measuredDefaultWidth;
        }
    }
}
