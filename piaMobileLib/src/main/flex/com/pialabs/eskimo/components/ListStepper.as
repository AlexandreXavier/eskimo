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
  import flash.events.Event;
  import flash.geom.Point;
  
  import mx.core.mx_internal;
  import mx.events.FlexEvent;
  
  import spark.components.Button;
  import spark.components.supportClasses.ListBase;
  
  use namespace mx_internal;
  
  /**
   *  The ListStepper control lets you select an item among a collection, and navigate in it using <code>decrementButton</code> and  <code>incrementButton</code>
   */
  public class ListStepper extends ListBase
  {
    /**
     *  A skin part that defines the  button that,
     *  when pressed, decrements the <code>selectedIndex</code> property
     */
    [SkinPart(required = "false")]
    public var decrementButton:Button;
    
    //----------------------------------
    //  incrementButton
    //----------------------------------
    
    
    /**
     *  A skin part that defines the  button that,
     *  when pressed, increments the <code>selectedIndex</code> property
     */
    [SkinPart(required = "false")]
    public var incrementButton:Button;
    
    public function ListStepper()
    {
      super();
      
      addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }
    
    /**
     *  @private
     */
    protected var _allowValueWrap:Boolean = false;
    
    [Inspectable(category = "General", defaultValue = "false")]
    
    /**
     *  Determines the behavior of the control for a step when the current
     *  <code>selectedIndex</code> is either the <code>dataProvider.length</code>
     *  or 0 value.
     *  If <code>allowValueWrap</code> is <code>true</code>, then the
     *  <code>selectedIndex</code> property wraps from the <code>dataProvider.length</code>
     *  to the 0 value, or from
     *  the <code>minimum</code> to the <code>dataProvider.length</code> value.
     *
     *  @default false
     *
     */
    public function get allowValueWrap():Boolean
    {
      return _allowValueWrap;
    }
    
    /**
     *  @private
     */
    public function set allowValueWrap(value:Boolean):void
    {
      _allowValueWrap = value;
    }
    
    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == incrementButton)
      {
        incrementButton.focusEnabled = false;
        incrementButton.addEventListener(FlexEvent.BUTTON_DOWN, incrementButton_buttonDownHandler);
        incrementButton.autoRepeat = true;
      }
      else if (instance == decrementButton)
      {
        decrementButton.focusEnabled = false;
        decrementButton.addEventListener(FlexEvent.BUTTON_DOWN, decrementButton_buttonDownHandler);
        decrementButton.autoRepeat = true;
      }
    }
    
    /**
     *  @private
     */
    override protected function partRemoved(partName:String, instance:Object):void
    {
      super.partRemoved(partName, instance);
      
      if (instance == incrementButton)
      {
        incrementButton.removeEventListener(FlexEvent.BUTTON_DOWN, incrementButton_buttonDownHandler);
      }
      else if (instance == decrementButton)
      {
        decrementButton.removeEventListener(FlexEvent.BUTTON_DOWN, decrementButton_buttonDownHandler);
      }
    }
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
      if (selectedIndex == -1 && dataProvider)
      {
        selectedIndex = 0;
      }
      
      ensureIndexIsVisible(selectedIndex);
      
      super.commitProperties();
    
    }
    
    /**
     *  @private
     */
    override protected function measure():void
    {
      super.measure();
      
      measuredHeight = 130;
    }
    
    /**
     *  @private
     */
    public function changeValueByStep(increase:Boolean = true):void
    {
      if (allowValueWrap)
      {
        if (increase && (selectedIndex == dataProvider.length - 1))
        {
          selectedIndex = 0;
        }
        else if (!increase && (selectedIndex == 0))
        {
          selectedIndex = dataProvider.length - 1;
        }
        else
        {
          selectedIndex += increase ? 1 : -1;
        }
      }
      else
      {
        selectedIndex += increase ? 1 : -1;
      }
    }
    
    //--------------------------------------------------------------------------
    // 
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Handle a click on the incrementButton. This should
     *  increment <code>value</code> by <code>stepSize</code>.
     */
    protected function incrementButton_buttonDownHandler(event:Event):void
    {
      var prevValue:Number = selectedIndex;
      
      changeValueByStep(true);
      
      if (selectedIndex != prevValue)
      {
        dispatchEvent(new Event("change"));
      }
    }
    
    /**
     *  @private
     *  Handle a click on the decrementButton. This should
     *  decrement <code>value</code> by <code>stepSize</code>.
     */
    protected function decrementButton_buttonDownHandler(event:Event):void
    {
      var prevValue:Number = selectedIndex;
      
      changeValueByStep(false);
      
      if (selectedIndex != prevValue)
      {
        dispatchEvent(new Event("change"));
      }
    }
    
    /**
     *  A convenience method that handles scrolling a data item
     *  into view.
     *
     *  If the data item at the specified index is not completely
     *  visible, the List scrolls until it is brought into
     *  view. If the data item is already in view, no additional
     *  scrolling occurs.
     *
     *  @param index The index of the data item.
     */
    public function ensureIndexIsVisible(index:int):void
    {
      if (!layout)
      {
        return;
      }
      
      var spDelta:Point = dataGroup.layout.getScrollPositionDeltaToElement(index);
      
      if (spDelta)
      {
        dataGroup.horizontalScrollPosition += spDelta.x;
        dataGroup.verticalScrollPosition += spDelta.y;
      }
    }
    
    /**
    * @private
    */
    override public function set selectedIndex(value:int):void
    {
      value = Math.max(0, value);
      
      if (dataProvider)
      {
        value = Math.min(value, dataProvider.length);
      }
      
      super.selectedIndex = value;
    }
    
    /**
     * @private
     */
    protected function onCreationComplete(event:Event):void
    {
      ensureIndexIsVisible(selectedIndex);
    }
  }
}
