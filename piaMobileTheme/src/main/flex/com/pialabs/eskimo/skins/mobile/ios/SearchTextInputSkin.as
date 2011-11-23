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
  import com.pialabs.eskimo.skins.mobile.ios.assets.TextInput_border;
  
  import flash.display.DisplayObject;
  
  import spark.filters.DropShadowFilter;
  import spark.skins.mobile.TextInputSkin;
  
  [Style(name = "icon", inherit = "no", type = "Class")]
  
  /**
   * The iOS skin class for the Spark TextInput component
   * @see spark.components.TextInput
   */
  public class SearchTextInputSkin extends spark.skins.mobile.TextInputSkin
  {
    private var _icon:DisplayObject;
    private var _iconClass:Class;
    
    public function SearchTextInputSkin()
    {
      super();
      layoutCornerEllipseSize = 32;
      borderClass = com.pialabs.eskimo.skins.mobile.ios.assets.TextInput_border;
      
      filters = [new DropShadowFilter(4, 90, 0, 0.5, 4, 4, 1, 1, true)];
    
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      
      _iconClass = getStyle("icon");
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      if (!_icon && _iconClass)
      {
        _icon = new _iconClass();
        addChild(_icon);
      }
      
      
      // position & size the text
      var paddingLeft:Number = getStyle("paddingLeft");
      var paddingRight:Number = getStyle("paddingRight");
      var paddingTop:Number = getStyle("paddingTop");
      var paddingBottom:Number = getStyle("paddingBottom");
      
      var iconWidth:int = 0;
      
      if (_icon)
      {
        iconWidth = unscaledHeight - paddingTop - paddingTop;
        setElementSize(_icon, iconWidth, iconWidth);
        setElementPosition(_icon, paddingLeft, (unscaledHeight - iconWidth) / 2);
      }
      
      var textDisplayWidth:int = unscaledWidth - paddingLeft - paddingRight - iconWidth;
      
      super.textDisplay.x = paddingLeft + iconWidth;
      super.textDisplay.width = textDisplayWidth;
      
      if (super.promptDisplay)
      {
        super.promptDisplay.x = paddingLeft + iconWidth;
        super.promptDisplay.width = textDisplayWidth;
      }
    }
  }
}
