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
  import com.pialabs.eskimo.components.ListWheel;
  
  import spark.components.ButtonBar;
  import spark.components.ButtonBarButton;
  import spark.components.DataGroup;
  import spark.components.Group;
  import spark.components.HGroup;
  import spark.components.Label;
  import spark.components.VGroup;
  import spark.components.supportClasses.ButtonBarHorizontalLayout;
  import spark.components.supportClasses.ListBase;
  import spark.layouts.HorizontalLayout;
  import spark.layouts.VerticalLayout;
  import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
  import spark.skins.mobile.supportClasses.MobileSkin;
  
  /**
   *  The iOS skin class for the Spark ButtonBar component.
   *
   */
  public class DateChooserSkin extends MobileSkin
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
    public function DateChooserSkin()
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
    public var hostComponent:com.pialabs.eskimo.components.DateChooser;
    
    public var dateInput:Group;
    
    public var dayGroup:Group;
    
    public var monthGroup:Group;
    
    public var yearGroup:Group;
    
    public var dayList:ListBase;
    
    public var monthList:ListBase;
    
    public var yearList:ListBase;
    
    public var dayLabel:Label;
    
    public var monthLabel:Label;
    
    public var yearLabel:Label;
    
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
      // Set up the child components
      if (!dateInput)
      {
        dateInput = new HGroup();
      }
      
      if (!dayGroup)
      {
        dayGroup = new VGroup();
      }
      
      if (!monthGroup)
      {
        monthGroup = new VGroup();
      }
      
      if (!yearGroup)
      {
        yearGroup = new VGroup();
      }
      
      if (!dayList)
      {
        dayList = new ListWheel();
        dayList.minHeight = 10;
        dayList.minWidth = 75;
      }
      
      if (!monthList)
      {
        monthList = new ListWheel();
        monthList.minHeight = 10;
        monthList.minWidth = 75;
      }
      
      if (!yearList)
      {
        yearList = new ListWheel();
        yearList.minHeight = 10;
        yearList.minWidth = 75;
      }
      
      if (!dayLabel)
      {
        dayLabel = new Label();
      }
      
      if (!monthLabel)
      {
        monthLabel = new Label();
      }
      
      if (!yearLabel)
      {
        yearLabel = new Label();
      }
      
      dayGroup.addElement(dayLabel);
      dayGroup.addElement(dayList);
      
      monthGroup.addElement(monthLabel);
      monthGroup.addElement(monthList);
      
      yearGroup.addElement(yearLabel);
      yearGroup.addElement(yearList);
      
      dateInput.addElement(dayGroup);
      dateInput.addElement(monthGroup);
      dateInput.addElement(yearGroup);
    }
    
    /**
     *  @private
     */
    override protected function measure():void
    {
      measuredWidth = dateInput.measuredWidth;
      measuredHeight = dateInput.measuredHeight;
      
      measuredMinWidth = 225;
      measuredMinHeight = 175;
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      var paddingLeft:Number = getStyle("paddingLeft");
      var paddingTop:Number = getStyle("paddingTop");
      
      var dateInputLayout:HorizontalLayout= dateInput.layout as HorizontalLayout
      dateInputLayout.gap = 0;
      dateInputLayout.verticalAlign = "bottom";
      dateInputLayout.clipAndEnableScrolling = true;
      dateInputLayout.variableColumnWidth = true;
      
      
      var dayGroupLayout:VerticalLayout= dayGroup.layout as VerticalLayout
      dayGroupLayout.horizontalAlign = "center";
      
      var monthGroupLayout:VerticalLayout= monthGroup.layout as VerticalLayout
      monthGroupLayout.horizontalAlign = "center";
      
      var yearGroupLayout:VerticalLayout= yearGroup.layout as VerticalLayout
      yearGroupLayout.horizontalAlign = "center";
      
      addChild(dateInput);
      setElementSize(dateInput, unscaledWidth, unscaledHeight);
      setElementPosition(dateInput, paddingLeft, paddingTop);
    }
  }
}
