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
* along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/
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
