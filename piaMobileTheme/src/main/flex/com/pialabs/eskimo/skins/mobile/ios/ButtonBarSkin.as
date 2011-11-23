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
  import spark.components.ButtonBar;
  import spark.components.ButtonBarButton;
  import spark.components.DataGroup;
  import spark.components.supportClasses.ButtonBarHorizontalLayout;
  import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
  import spark.skins.mobile.supportClasses.MobileSkin;
  
  /**
   *  The iOS skin class for the Spark ButtonBar component.
   *
   *  @see spark.components.ButtonBar
   */
  public class ButtonBarSkin extends MobileSkin
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
    public function ButtonBarSkin()
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
        firstButton.skinClass = com.pialabs.eskimo.skins.mobile.ios.ButtonBarFirstButtonSkin;
      }
      
      if (!lastButton)
      {
        lastButton = new ButtonBarButtonClassFactory(ButtonBarButton);
        lastButton.skinClass = com.pialabs.eskimo.skins.mobile.ios.ButtonBarLastButtonSkin;
      }
      
      if (!middleButton)
      {
        middleButton = new ButtonBarButtonClassFactory(ButtonBarButton);
        middleButton.skinClass = com.pialabs.eskimo.skins.mobile.ios.ButtonBarMiddleButtonSkin;
      }
      
      // create the data group to house the buttons
      if (!dataGroup)
      {
        dataGroup = new DataGroup();
        var hLayout:ButtonBarHorizontalLayout = new ButtonBarHorizontalLayout();
        hLayout.gap = 0;
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
      setElementSize(dataGroup, unscaledWidth, unscaledHeight);
    }
  }
}
