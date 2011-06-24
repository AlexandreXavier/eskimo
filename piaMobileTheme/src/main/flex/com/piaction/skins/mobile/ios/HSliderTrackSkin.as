package com.piaction.skins.mobile.ios
{
  import com.piaction.skins.mobile.ios.assets.HSliderTrack_fill;
  import com.piaction.skins.mobile.ios.assets.HSliderTrack_normal;
  
  import flash.display.DisplayObject;
  
  import spark.skins.mobile.ButtonSkin;
  
  public class HSliderTrackSkin extends ButtonSkin
  {
    /**
     * @private
     */
    private var _fill:DisplayObject;
    
    /**
     * @private
     */
    private var colorized:Boolean;
    
    /**
     * The fill class of the button
     */
    public var fillClass:Class;
    
    public function HSliderTrackSkin()
    {
      super();
      measuredDefaultHeight = 13;
      measuredDefaultWidth = 33;
      
      upBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderTrack_normal;
      downBorderSkin = com.piaction.skins.mobile.ios.assets.HSliderTrack_normal;
      fillClass = HSliderTrack_fill;
    }
    
    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      // add separate chromeColor fill graphic as the first layer
      if (!_fill && fillClass)
      {
        _fill = new fillClass();
        addChildAt(_fill, 0);
      }
      
      if (_fill)
      {
        // move to the first layer
        if (getChildIndex(_fill) > 0)
        {
          removeChild(_fill);
          addChildAt(_fill, 0);
        }
        
        setElementSize(_fill, unscaledWidth, unscaledHeight);
      }
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      // omit call to super.drawBackground(), apply tint instead and don't draw fill
      var chromeColor:uint = getStyle("chromeColor");
      
      if (colorized || (chromeColor != 0xCCCCCC))
      {
        // apply tint instead of fill
        applyColorTransform(_fill, 0xCCCCCC, chromeColor);
        
        // if we restore to original color, unset colorized
        colorized = (chromeColor != 0xCCCCCC);
      }
    }
  }
}
