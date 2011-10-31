package com.pialabs.eskimo.skins.mobile.ios
{
  import com.pialabs.eskimo.skins.mobile.ios.assets.BreadCrumbButton_down;
  import com.pialabs.eskimo.skins.mobile.ios.assets.BreadCrumbButton_up;
  import com.pialabs.eskimo.skins.mobile.ios.assets.BreadCrumbFirstButton_down;
  
  import mx.core.DPIClassification;
  import mx.core.UIComponent;
  
  
  public class BreadCrumbFirstButtonSkin extends ButtonSkin
  {
    public function BreadCrumbFirstButtonSkin()
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
          layoutPaddingLeft = 5;
          layoutPaddingRight = 25;
          measuredDefaultWidth = 58;
          measuredDefaultHeight = 28;
          
          upBorderSkin = BreadCrumbButton_up;
          downBorderSkin = BreadCrumbFirstButton_down;
          selectedBorderSkin = UIComponent;
          fillClass = null;
          
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
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.drawBackground(unscaledWidth, unscaledHeight);
      
      var isSelected:Boolean = currentState.indexOf("Selected") >= 0;
      
      if (_fill)
      {
        _fill.visible = !isSelected;
      }
    }
  
  }
}
