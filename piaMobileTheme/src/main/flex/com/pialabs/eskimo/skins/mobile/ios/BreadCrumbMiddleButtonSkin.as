package com.pialabs.eskimo.skins.mobile.ios
{
  import com.pialabs.eskimo.skins.mobile.ios.assets.BreadCrumbButton_down;
  
  import mx.core.DPIClassification;
  
  
  public class BreadCrumbMiddleButtonSkin extends BreadCrumbFirstButtonSkin
  {
    public function BreadCrumbMiddleButtonSkin()
    {
      super();
      
      switch (applicationDPI)
      {
        case DPIClassification.DPI_320:
        case DPIClassification.DPI_240:
        default:
        {
          // 160
          downBorderSkin = BreadCrumbButton_down;
          layoutPaddingLeft = 25;
          break;
        }
      }
    }
  }
}
