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
  import com.pialabs.eskimo.skins.mobile.ios.assets.ActionBarBackground;
  
  import flash.display.DisplayObject;
  
  import spark.skins.mobile.ActionBarSkin;
  
  /**
   * The iOS skin class for the Spark ActionBar component.
   * @see spark.components.ActionBar
   */
  public class ActionBarSkin extends spark.skins.mobile.ActionBarSkin
  {
    
    
    /**
     * @private
     */
    private var _fill:DisplayObject;
    
    /**
     * The fill class of the button
     */
    public var fillClass:Class;
    
    
    public function ActionBarSkin()
    {
      super();
      
      fillClass = com.pialabs.eskimo.skins.mobile.ios.assets.ActionBarBackground;
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      // add separate chromeColor fill graphic as the first layer
      if (!_fill && fillClass)
      {
        _fill = new fillClass();
        addChildAt(_fill, 1);
      }
      
      if (_fill)
      {
        // move to the first layer
        if (getChildIndex(_fill) > 1)
        {
          removeChild(_fill);
          addChildAt(_fill, 1);
        }
        
        setElementSize(_fill, unscaledWidth, unscaledHeight - 1);
      }
    }
    
    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      var chromeColor:uint = getStyle("chromeColor");
      
      if ((chromeColor != 0x878787))
      {
        // apply tint instead of fill
        applyColorTransform(_fill, 0x878787, chromeColor);
      }
      
      graphics.clear();
      
      graphics.beginFill(0x2D3642, 1);
      
      graphics.drawRect(0, unscaledHeight - 1, unscaledWidth, 1);
      
      graphics.clear();
    }
  }
}
