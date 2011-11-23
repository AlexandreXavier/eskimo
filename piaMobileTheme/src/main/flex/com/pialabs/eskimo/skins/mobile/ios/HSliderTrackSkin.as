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
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_fill;
  import com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_normal;
  
  /**
   * The iOS skin class for the Spark HSlider track
   * @see spark.components.HSlider
   */
  public class HSliderTrackSkin extends ButtonSkin
  {
    /**
     * Constructor
     */
    public function HSliderTrackSkin()
    {
      super();
      measuredDefaultHeight = 13;
      measuredDefaultWidth = 33;
      
      upBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_normal;
      downBorderSkin = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_normal;
      fillClass = com.pialabs.eskimo.skins.mobile.ios.assets.HSliderTrack_fill;
      
      measuredMinHeight = measuredDefaultHeight;
      measuredMinWidth = measuredDefaultWidth;
    }
  }
}
