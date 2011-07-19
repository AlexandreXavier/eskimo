package com.pialabs.eskimo.skins.mobile.ios
{
  
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_down;
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_up;
  
  /**
   * The iOS skin class for the Spark HSlider thumb
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
      
      upBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_up;
      downBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_down;
      fillClass = null;
      
      measuredDefaultWidth = 29;
      measuredDefaultHeight = 29;
      
      measuredMinWidth = 29;
      measuredMinHeight = 29;
    }
  }
}
