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
package com.pialabs.eskimo.skins.mobile.android
{
    import flash.display.DisplayObject;
    
    import spark.components.IconPlacement;
    import spark.skins.mobile.CheckBoxSkin;
    
    /**
     * The android skin class for the Spark Checkbox component.
     * 
     * Extends spark.skins.mobile.CheckBoxSkin to have space between the checkbox and its label.
     * 
     * @see spark.components.CheckBox
     * 
     */
    public class CheckBoxSkin extends spark.skins.mobile.CheckBoxSkin
    {
        public function CheckBoxSkin()
        {
            super();
        }
        
        /**
         *  @private
         */
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            var iconPlacement:String = getStyle("iconPlacement");
            var isHorizontal:Boolean = (iconPlacement == IconPlacement.LEFT || iconPlacement == IconPlacement.RIGHT);
            
            var iconX:Number = 0;
            var iconY:Number = 0;
            var unscaledIconWidth:Number = 0;
            var unscaledIconHeight:Number = 0;
            
            var iconDisplay:DisplayObject = getIconDisplay();
            
            var viewWidth:Number = Math.max(unscaledWidth - layoutPaddingLeft - layoutPaddingRight, 0);
            var viewHeight:Number = Math.max(unscaledHeight - layoutPaddingTop - layoutPaddingBottom, 0);
            
            
            if (iconDisplay)
            {
                unscaledIconWidth = getElementPreferredWidth(iconDisplay);
                unscaledIconHeight = getElementPreferredHeight(iconDisplay);
            }
            
            var iconViewWidth:Number = Math.min(unscaledIconWidth, viewWidth);
            var iconViewHeight:Number = Math.min(unscaledIconHeight, viewHeight);
            
            if (isHorizontal)
            {
                if (iconPlacement == IconPlacement.RIGHT)
                {
                    iconX = unscaledWidth - layoutPaddingRight - iconViewWidth;
                    iconY = (viewHeight - iconViewHeight) / 2;
                    
                    setElementSize(iconDisplay, iconViewWidth, iconViewHeight);
                    setElementPosition(iconDisplay, iconX, iconY);
                    
                    // position the symbols to align with the background "icon"
                    if (symbolIcon)
                    {
                        setElementPosition(symbolIcon, iconDisplay.x, iconDisplay.y);
                    }
                }
                
            }
        
        }
    }
}
