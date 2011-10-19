package com.pialabs.eskimo.skins.mobile.android
{
  import mx.states.State;
  
  import spark.skins.mobile.supportClasses.MobileSkin;
  
  public class PageIndicatorItemSkin extends MobileSkin
  {
    public function PageIndicatorItemSkin()
    {
      super();
      
      states = [new State("normal"), new State("selected")];
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      var color:uint;
      var alpha:Number;
      if (currentState == "normal")
      {
        color = getStyle("chromeColor");
        alpha = getStyle("chromeAlpha");
      }
      else
      {
        color = getStyle("selectedChromeColor");
        alpha = getStyle("selectedChromeAlpha");
      }
      graphics.clear();
      graphics.beginFill(color, alpha);
      
      graphics.drawEllipse(0, 0, unscaledWidth, unscaledHeight);
      
      graphics.endFill();
    }
  
  }
}
