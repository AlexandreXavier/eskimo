/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.pialabs.eskimo.skins.mobile.ios
{
  import com.pialabs.eskimo.skins.mobile.ios.assets.Button_down;
  import com.pialabs.eskimo.skins.mobile.ios.assets.Button_fill;
  import com.pialabs.eskimo.skins.mobile.ios.assets.Button_up;
  
  import flash.display.DisplayObject;
  
  import mx.core.DPIClassification;
  
  import spark.skins.mobile.ButtonSkin;
  
  /**
  * Alpha property for the fill background
  */
  [Style(name = "fillAlpha", inherit = "no", type = "Number")]
  
  /**
   * The iOS skin class for the Spark Button component.
   *
   *  @see spark.components.Button
   */
  public class ButtonSkin extends spark.skins.mobile.ButtonSkin
  {
    /**
     * Constructor
     */
    public function ButtonSkin()
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
          
          upBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.Button_up;
          downBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.Button_down;
          fillClass = com.pialabs.eskimo.skins.mobile.ios.assets.Button_fill;
          
          break;
        }
      }
      
      // beveled buttons do not scale down
      measuredMinHeight = measuredDefaultHeight;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    protected var _fill:DisplayObject;
    
    /**
     * @private
     */
    protected var colorized:Boolean;
    
    /**
     * The fill class of the button
     */
    public var fillClass:Class;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      super.labelDisplayShadow.y = super.labelDisplayShadow.y - 2;
      
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
    
    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      if (!_fill)
      {
        return;
      }
      
      // omit call to super.drawBackground(), apply tint instead and don't draw fill
      var chromeColor:uint = getStyle("chromeColor");
      
      if (colorized || (chromeColor != 0xCCCCCC))
      {
        // apply tint instead of fill
        applyColorTransform(_fill, 0xCCCCCC, chromeColor);
        
        // if we restore to original color, unset colorized
        colorized = (chromeColor != 0xCCCCCC);
      }
      
      var fillAlpha:Number = getStyle("fillAlpha");
      if (!isNaN(fillAlpha))
      {
        _fill.alpha = fillAlpha;
      }
    }
  
  }
}
