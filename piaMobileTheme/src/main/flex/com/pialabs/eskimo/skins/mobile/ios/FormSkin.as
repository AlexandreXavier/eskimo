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
  import flash.events.Event;
  
  import mx.core.IVisualElement;
  import mx.events.FlexEvent;
  import mx.states.State;
  
  import spark.components.Group;
  import spark.components.supportClasses.Skin;
  import spark.layouts.FormLayout;
  import spark.layouts.VerticalLayout;
  import spark.primitives.RectangularDropShadow;
  
  /**
   * Define the border color
   * @defaults 0xb4b7bb
   */
  [Style(name = "borderColor", inherit = "no", type = "uint")]
  /**
   * Define the border alpha
   * @defaults 1
   */
  [Style(name = "borderAlpha", inherit = "no", type = "Number")]
  
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
      
      addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
    }
    
    private function onCreationComplete(event:Event):void
    {
      invalidateDisplayList();
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (!contentGroup)
      {
        contentGroup = new Group();
        addElementAt(contentGroup, 0);
        
        var vlayout:FormLayout = new FormLayout();
        vlayout.horizontalAlign = "justify";
        vlayout.paddingTop = 0;
        vlayout.paddingBottom = 0;
        vlayout.paddingLeft = 15;
        vlayout.paddingRight = 5;
        
        vlayout.gap = 0;
        
        contentGroup.layout = vlayout;
        
        contentGroup.setStyle("showErrorSkin", true);
        contentGroup.setStyle("showErrorTip", true);
        
        contentGroup.top = 0;
        contentGroup.right = 0;
        contentGroup.bottom = 0;
        contentGroup.left = 0;
        
        
        var rectShadow:RectangularDropShadow = new RectangularDropShadow();
        addElement(rectShadow);
        rectShadow.top = 0;
        rectShadow.right = 0;
        rectShadow.bottom = 0;
        rectShadow.left = 0;
        rectShadow.angle = 90;
        rectShadow.distance = 1;
        rectShadow.color = 0xFFFFFF;
        rectShadow.blurX = 0;
        rectShadow.blurY = 0;
        rectShadow.alpha = 0.5;
        rectShadow.tlRadius = rectShadow.trRadius = rectShadow.blRadius = rectShadow.brRadius = 10;
        
      }
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      layoutContent(unscaledWidth, unscaledHeight);
    }
    
    protected function layoutContent(unscaledWidth:Number, unscaledHeight:Number):void
    {
      var strkColor:uint = getStyle("borderColor");
      var strkAlpha:Number = getStyle("borderAlpha");
      
      graphics.clear();
      
      if (!isNaN(getStyle("backgroundColor")))
      {
        var bgColor:uint = getStyle("backgroundColor");
        var bgAlpha:Number = getStyle("backgroundAlpha");
        
        graphics.lineStyle(1, strkColor, strkAlpha, true);
        graphics.beginFill(bgColor, bgAlpha);
        
        graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight - 1, 20, 20);
        
        graphics.endFill();
      }
      
      
      // Adding lines
      var formItem:IVisualElement;
      var gap:int;
      if (contentGroup.layout.hasOwnProperty("gap"))
      {
        gap = contentGroup.layout["gap"];
      }
      
      if (contentGroup.layout is VerticalLayout || contentGroup.layout is FormLayout)
      {
        graphics.lineStyle(1, strkColor, 0, true);
        graphics.beginFill(strkColor, strkAlpha);
        for (var i:int = 0; i < contentGroup.numElements - 1; i++)
        {
          formItem = contentGroup.getElementAt(i);
          
          if (formItem is spark.components.FormItem)
          {
            var lineY:int = formItem.getLayoutBoundsY() + formItem.getLayoutBoundsHeight() + gap / 2;
            graphics.drawRect(0, lineY, unscaledWidth, 1);
          }
        }
        graphics.endFill();
      }
    }
  
  }
}
