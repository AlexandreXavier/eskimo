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
  import mx.states.State;
  
  import spark.components.Group;
  import spark.components.supportClasses.Skin;
  import spark.layouts.VerticalLayout;
  
  /**
  * The android skin class for a Spark Form container.
  * @see spark.components.Form
  * @see spark.layouts.FormLayout
  */
  public class FormSkin extends Skin
  {
    public var contentGroup:Group;
    
    public function FormSkin()
    {
      super();
      
      states = [new State({name: "normal"}), new State({name: "error"}), new State({name: "disabled"})];
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (!contentGroup)
      {
        contentGroup = new Group();
        addElement(contentGroup);
        
        var vlayout:VerticalLayout = new VerticalLayout();
        vlayout.horizontalAlign = "justify";
        vlayout.paddingTop = 0;
        vlayout.paddingBottom = 0;
        vlayout.gap = 10;
        
        contentGroup.layout = vlayout;
        
        contentGroup.setStyle("showErrorSkin", true);
        contentGroup.setStyle("showErrorTip", true);
        
        contentGroup.top = 0;
        contentGroup.right = 0;
        contentGroup.bottom = 0;
        contentGroup.left = 0;
        
      }
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      layoutContent(unscaledWidth, unscaledHeight);
    }
    
    protected function layoutContent(unscaledWidth:Number, unscaledHeight:Number):void
    {
      contentGroup.width = unscaledWidth;
      
      if (!isNaN(getStyle("backgroundColor")))
      {
        var bgColor:uint = getStyle("backgroundColor");
        var bgAlpha:Number = getStyle("backgroundAlpha");
        
        graphics.beginFill(bgColor, bgAlpha);
        
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        
        graphics.endFill();
      }
    }
  
  }
}
