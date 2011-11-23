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
package com.pialabs.eskimo.components
{
  import com.pialabs.eskimo.data.SectionTitleLabel;
  
  import flash.display.GradientType;
  import flash.geom.Matrix;
  
  import spark.components.IconItemRenderer;
  import spark.components.List;
  
  
  /**
   *  The SectionItemRenderer class displays a different background color, height
   *  and text align for SectionTitleLabel. Used in the
   *  list-based control.
   */
  public class SectionItemRenderer extends IconItemRenderer implements ISectionRenderer
  {
    private var _isSectionTitle:Boolean;
    
    public function SectionItemRenderer()
    {
      super();
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      
      if (_isSectionTitle)
      {
        var listOwner:List = (this.owner as List);
        
        var sectionBackgroundColor:uint = getStyle("backgroundColor");
        
        var colors:Array = [0, 0];
        var alphas:Array = [0.2, 0];
        var ratios:Array = [0, 255];
        var matrix:Matrix = new Matrix();
        
        // opaque background
        graphics.beginFill(sectionBackgroundColor);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
        
        // gradient overlay
        matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
        graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
      }
      else
      {
        super.drawBackground(unscaledWidth, unscaledHeight);
      }
    
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    public function get isSectionTitle():Boolean
    {
      return _isSectionTitle;
    }
    
    public function set isSectionTitle(value:Boolean):void
    {
      _isSectionTitle = value;
    }
  }
}
