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
  
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_down;
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_up;
  
  /**
   * The iOS skin class for the Spark HSlider thumb
   * @see spark.components.HSlider
   */
  public class HSliderThumbSkin extends ButtonSkin
  {
    
    /**
     * Constructor
     */
    public function HSliderThumbSkin()
    {
      super();
      
      upBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_up;
      downBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderThumb_down;
      fillClass = null;
      
      measuredDefaultWidth = 29;
      measuredDefaultHeight = 29;
      
      measuredMinWidth = 29;
      measuredMinHeight = 29;
    }
  }
}
