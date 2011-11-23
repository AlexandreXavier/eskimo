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
  import flash.display.GradientType;
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  
  import mx.events.ItemClickEvent;
  
  import spark.components.LabelItemRenderer;
  import spark.components.RadioButton;
  
  /**
   *  The RightRadioButtonRenderer class defines the radio item renderer
   *  This contains a text component and a right-align radio button.
   */
  public class RightRadioButtonRenderer extends RadioButtonItemRenderer
  {
    public function RightRadioButtonRenderer()
    {
      super();
      padding = 10;
    }
    
    protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      drawBackground(unscaledWidth, unscaledHeight);
    }
    
    override protected function measure():void
    {
      super.measure();
      
      measuredHeight = radioButton.getPreferredBoundsHeight() + padding * 2;
    }
    
    /**
     *  Renders a background for the item renderer.
     */
    protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      var colors:Array = [0x000000, 0x000000, 0x000000];
      
      var alphas:Array = [0, 0.7, 0];
      
      //Array of color distribution ratios.
      //The value defines percentage of the width where the color is sampled at 100%
      var ratios:Array = [0, 128, 255];
      
      var matrix:Matrix = new Matrix();
      // gradient overlay
      var linePadding:int = 2;
      matrix.createGradientBox(unscaledWidth - 2 * linePadding, unscaledHeight, 0, 0, 0);
      
      graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
      graphics.drawRect(linePadding, unscaledHeight, unscaledWidth - 2 * linePadding, 1);
      graphics.endFill();
      
      // Down state have a gradient overlay
      if (down)
      {
        var colors_down:Array = [0x000000, 0x000000];
        var alphas_down:Array = [.2, .1];
        var ratios_down:Array = [0, 255];
        var matrix_down:Matrix = new Matrix();
        
        // gradient overlay
        matrix_down.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
        graphics.beginGradientFill(GradientType.LINEAR, colors_down, alphas_down, ratios_down, matrix_down);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
      }
    }
  }
}
