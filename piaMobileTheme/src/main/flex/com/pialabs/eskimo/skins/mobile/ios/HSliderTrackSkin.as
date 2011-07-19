package com.pialabs.eskimo.skins.mobile.ios
{
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_fill;
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_normal;
  
  /**
   * The iOS skin class for the Spark HSlider track
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
      
      upBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_normal;
      downBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_normal;
      fillClass = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_fill;
      
      measuredMinHeight = measuredDefaultHeight;
      measuredMinWidth = measuredDefaultWidth;
    }
  }
}
