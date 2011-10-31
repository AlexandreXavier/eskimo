package com.pialabs.eskimo.skins.mobile.ios
{
  import mx.core.DPIClassification;
  import mx.core.UIComponent;
  
  
  public class BreadCrumbLastButtonSkin extends BreadCrumbFirstButtonSkin
  {
    public function BreadCrumbLastButtonSkin()
    {
      super();
      
      switch (applicationDPI)
      {
        case DPIClassification.DPI_320:
        case DPIClassification.DPI_240:
        default:
        {
          // 160
          layoutPaddingLeft = 25;
          
          upBorderSkin = UIComponent;
          downBorderSkin = UIComponent;
          selectedBorderSkin = UIComponent;
          break;
        }
        
      }
    }
  }
}
