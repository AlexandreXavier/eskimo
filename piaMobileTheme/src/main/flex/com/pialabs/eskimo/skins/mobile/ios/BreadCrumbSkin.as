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
  import flash.display.GradientType;
  import flash.geom.Matrix;
  
  import mx.core.UIComponent;
  
  import spark.components.ButtonBar;
  import spark.components.ButtonBarButton;
  import spark.components.DataGroup;
  import spark.components.supportClasses.ButtonBarHorizontalLayout;
  import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
  import spark.skins.mobile.supportClasses.MobileSkin;
  
  
  [Style(name = "borderColor", inherit = "no", type = "uint", format = "Color")]
  
  [Style(name = "borderAlpha", inherit = "no", type = "Number")]
  
  /**
   *  The iOS skin class for the BreadCrumb component.
   *
   *  @see com.pialabs.eskimo.components.BreadCrumb
   */
  public class BreadCrumbSkin extends MobileSkin
  {
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     *
     */
    public function BreadCrumbSkin()
    {
      super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:ButtonBar;
    
    /**
     *  @copy spark.components.ButtonBar#firstButton
     */
    public var firstButton:ButtonBarButtonClassFactory;
    
    /**
     *  @copy spark.components.ButtonBar#lastButton
     */
    public var lastButton:ButtonBarButtonClassFactory;
    
    /**
     *  @copy spark.components.ButtonBar#middleButton
     */
    public var middleButton:ButtonBarButtonClassFactory;
    
    /**
     *  @copy spark.components.SkinnableDataContainer#dataGroup
     */
    public var dataGroup:DataGroup;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function createChildren():void
    {
      // Set up the class factories for the buttons
      if (!firstButton)
      {
        firstButton = new ButtonBarButtonClassFactory(ButtonBarButton);
        firstButton.skinClass = BreadCrumbFirstButtonSkin;
      }
      
      if (!lastButton)
      {
        lastButton = new ButtonBarButtonClassFactory(ButtonBarButton);
        lastButton.skinClass = BreadCrumbLastButtonSkin;
      }
      
      if (!middleButton)
      {
        middleButton = new ButtonBarButtonClassFactory(ButtonBarButton);
        middleButton.skinClass = BreadCrumbMiddleButtonSkin;
      }
      
      // create the data group to house the buttons
      if (!dataGroup)
      {
        dataGroup = new DataGroup();
        var hLayout:ButtonBarHorizontalLayout = new ButtonBarHorizontalLayout();
        hLayout.gap = -20;
        dataGroup.layout = hLayout;
        addChild(dataGroup);
      }
    }
    
    /**
     *  @private
     */
    override protected function commitCurrentState():void
    {
      alpha = (currentState == "disabled") ? 0.5 : 1;
    }
    
    /**
     *  @private
     */
    override protected function measure():void
    {
      measuredWidth = dataGroup.measuredWidth;
      measuredHeight = dataGroup.measuredHeight;
      
      measuredMinWidth = dataGroup.measuredMinWidth;
      measuredMinHeight = dataGroup.measuredMinHeight;
    }
    
    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      setElementPosition(dataGroup, 0, 0);
      
      var dataGroupWidth:Number = dataGroup.getPreferredBoundsWidth();
      dataGroupWidth = Math.min(dataGroupWidth, unscaledWidth);
      setElementSize(dataGroup, dataGroupWidth, unscaledHeight);
      
      for (var i:int = 0; i < dataGroup.numElements; i++)
      {
        (dataGroup.getElementAt(i) as UIComponent).depth = dataGroup.numElements - i;
      }
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      //super.drawBackground(unscaledWidth, unscaledHeight);
      
      var chromeColor:uint = getStyle("chromeColor");
      var fillAlpha:Number = getStyle("fillAlpha");
      var borderColor:uint = getStyle("borderColor");
      var borderAlpha:Number = getStyle("borderAlpha");
      
      graphics.clear();
      graphics.beginFill(chromeColor, fillAlpha);
      
      graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
      
      
      
      var gradientBoxMatrix:Matrix = new Matrix();
      gradientBoxMatrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
      graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.5, 0, 0.3], [0, 128, 255], gradientBoxMatrix);
      graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
      
      graphics.endFill();
      
      graphics.lineStyle(1, borderColor, borderAlpha);
      graphics.moveTo(0, 0);
      graphics.lineTo(unscaledWidth, 0);
      graphics.moveTo(0, unscaledHeight - 1);
      graphics.lineTo(unscaledWidth, unscaledHeight - 1);
    }
  }
}
