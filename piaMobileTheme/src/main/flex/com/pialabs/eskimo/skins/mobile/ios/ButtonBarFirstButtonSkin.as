package com.pialabs.eskimo.skins.mobile.ios
{
  import com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_down;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_fill;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_selected;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_up;
  
  import mx.core.DPIClassification;
  
  /**
   * The iOS skin class for the first Button of ButtonBar component.
   *
   *  @see spark.components.ButtonBar
   */
  public class ButtonBarFirstButtonSkin extends ButtonSkin
  {
    public function ButtonBarFirstButtonSkin()
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
          
          upBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_up;
          downBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_down;
          selectedBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_selected;
          fillClass = com.pialabs.eskimo.skins.mobile.ios.assets.ButtonBarFirst_fill;
          
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
