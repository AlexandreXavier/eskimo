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
  import com.pialabs.eskimo.components.ListWheelItemRenderer;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_fill;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_rightPath;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_selectionRect;
  import com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_selectionRectBounds;
  
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.utils.getTimer;
  
  import mx.controls.Alert;
  import mx.core.ClassFactory;
  import mx.events.CollectionEvent;
  import mx.events.FlexEvent;
  import mx.logging.Log;
  
  import spark.components.ButtonBar;
  import spark.components.ButtonBarButton;
  import spark.components.DataGroup;
  import spark.components.Group;
  import spark.components.HGroup;
  import spark.components.Label;
  import spark.components.List;
  import spark.components.VGroup;
  import spark.components.supportClasses.ButtonBarHorizontalLayout;
  import spark.components.supportClasses.ListBase;
  import spark.layouts.HorizontalLayout;
  import spark.layouts.VerticalLayout;
  import spark.skins.mobile.ListSkin;
  import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
  import spark.skins.mobile.supportClasses.MobileSkin;
  
  /**
   *  The iOS skin class for the Spark ButtonBar component.
   *
   */
  public class ListWheelSkin extends ListSkin
  {
    
    
    /**
     * @private
     */
    private var _fill:DisplayObject;
    private var _rightPath:DisplayObject;
    private var _leftPath:DisplayObject;
    private var _selectionRectBounds:DisplayObject;
    private var _selectionRectBoundsTopHalf:DisplayObject;
    private var _selectionRectBoundsBottomHalf:DisplayObject;
    
    /**
     * The fill class of the button
     */
    public var fillClass:Class;
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
    public function ListWheelSkin()
    {
      super();
      
      fillClass = com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_fill;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    override protected function initializationComplete():void
    {
      super.initializationComplete();
      dataGroup.addEventListener('dataProviderChanged', onDataChanged, false, 0, true);
    }
    
    protected function onDataChanged(event:Event):void
    {
      dataGroup.typicalItem = calculateWidestItem();
      scroller.hasFocusableChildren = false;
      
    }
    
    protected function calculateWidestItem():Object
    {
      var str:String;
      var strWidth:int = 0;
      var maxStrWidth:int = 0;
      var maxItem:Object;
      if (dataGroup.dataProvider)
      {
        for each (var item:Object in dataGroup.dataProvider)
        {
          str = hostComponent.itemToLabel(item);
          strWidth = measureText(str).width;
          
          if ( strWidth > maxStrWidth)
          {
            maxStrWidth = strWidth;
            maxItem = item;
          }
        }
      }
      
      return maxItem;
    }
    
    override protected function measure():void
    {
      super.measure();
      measuredHeight = 150;
      minWidth = 15;
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.layoutContents(unscaledWidth, unscaledHeight);
      
      var borderWidth:Number = 3;
      
      if (!_fill && fillClass)
      {
        _fill = new fillClass();
        addChildAt(_fill, 1);
      }
      
      if (_fill)
      {
        // move to the first layer
        if (getChildIndex(_fill) > 1)
        {
          removeChild(_fill);
          addChildAt(_fill, 1);
        }
        setElementPosition(_fill, borderWidth, 0);
        setElementSize(_fill, unscaledWidth - (borderWidth*2), unscaledHeight);
      }
      
      if (!_rightPath){
        _rightPath = new com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_rightPath();
        addChildAt(_rightPath, 2);
      }
      
      
      if (!_leftPath){
        _leftPath = new com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_leftPath();
        addChildAt(_leftPath, 3);
      }
      
      var rowHeight:Number = ListWheel(hostComponent).rowHeight;
      
      if (!_selectionRectBounds){
        _selectionRectBounds = new com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_selectionRectBounds();
        addChildAt(_selectionRectBounds, 4);
      }
      if (!_selectionRectBoundsTopHalf){
        _selectionRectBoundsTopHalf = new com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_selectionRect();
        addChildAt(_selectionRectBoundsTopHalf, 5);
      }
      if (!_selectionRectBoundsBottomHalf){
        _selectionRectBoundsBottomHalf = new com.pialabs.eskimo.skins.mobile.ios.assets.ListWheel_selectionRect();
        addChildAt(_selectionRectBoundsBottomHalf, 6);
      }
      
      setElementSize(_leftPath, borderWidth, unscaledHeight);
      setElementPosition(_leftPath, 0, 0);
      
      setElementSize(_rightPath, borderWidth, unscaledHeight);
      setElementPosition(_rightPath, unscaledWidth - borderWidth, 0);
      
      setElementSize(_selectionRectBounds, unscaledWidth, rowHeight);
      setElementPosition(_selectionRectBounds, 0, (unscaledHeight-rowHeight)/2);
      
      setElementSize(_selectionRectBoundsTopHalf, unscaledWidth, rowHeight/2);
      setElementPosition(_selectionRectBoundsTopHalf, 0, (unscaledHeight-rowHeight)/2);
      
      setElementSize(_selectionRectBoundsBottomHalf, unscaledWidth, rowHeight/2);
      setElementPosition(_selectionRectBoundsBottomHalf, 0, unscaledHeight/2);
    }
    
    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      var chromeColor:uint = getStyle("chromeColor");
      
      if (chromeColor && chromeColor != 0xcccccc)
      {
        applyColorTransform(_fill, 0xcccccc, chromeColor);
        applyColorTransform(_leftPath, 0xcccccc, chromeColor);
        applyColorTransform(_rightPath, 0xcccccc, chromeColor);
      }
      
      var gradientColorBegin:uint = getStyle("gradientColorBegin");
      if ((gradientColorBegin != 0xcccccc))
      {
        applyColorTransform(_selectionRectBoundsTopHalf, 0xcccccc, gradientColorBegin);
      }
      var gradientColorEnd:uint = getStyle("gradientColorEnd");
      if ((gradientColorEnd != 0xcccccc))
      {
        applyColorTransform(_selectionRectBoundsBottomHalf, 0xcccccc, gradientColorEnd);
      }
    }
  }
}
