package com.piaction.skins.mobile.ios
{
  
  import com.piaction.skins.mobile.ios.assets.HSliderThumb_up;
  
  import spark.skins.mobile.ButtonSkin;
  
  public class HSliderThumbSkin extends ButtonSkin
  {
    public function HSliderThumbSkin()
    {
      super();
      
      upBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderThumb_up;
      downBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderThumb_down;
    }
  }
}