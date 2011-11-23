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
package com.pialabs.eskimo.layouts
{
  import com.pialabs.eskimo.components.SlideDataGroup;
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.system.Capabilities;
  
  import mx.core.FlexGlobals;
  import mx.core.IVisualElement;
  import mx.effects.Tween;
  
  import spark.events.IndexChangeEvent;
  import spark.layouts.supportClasses.LayoutBase;
  
  [Event(name = "indexChange", type = "spark.events.IndexChangeEvent")]
  
  /**
   * Layout that enable slide bitween visual element
   */
  public class SlideLayout extends LayoutBase
  {
    /**
     * Oriantation vertival
     */
    public static var VERTICAL:String = "vertical";
    /**
     * Oriantation horizontal
     */
    public static var HORIZONTAL:String = "horizontal";
    
    /**
     * @private
     */
    private var _mask:Sprite = new Sprite();
    /**
     * @private
     */
    protected var _tween:Tween;
    /**
     * @private
     */
    protected var _oldIndex:int = -1;
    /**
     * @private
     */
    protected var _index:uint = 0;
    
    /**
    * Direction of the slide
    */
    public var direction:int = 1;
    
    /**
    * Duration of the transition.
    */
    public var slideDuration:int = 300;
    
    
    /**
     * Oriantation of the slide
     */
    public var orientation:String = HORIZONTAL;
    
    /**
     * @private
     */
    private var _direction:int;
    /**
     * @private
     */
    private var _newElement:IVisualElement;
    /**
     * @private
     */
    private var _oldElement:IVisualElement
    
    /**
     * currentitem index visible in the layout
     */
    [Bindable("indexChanged")]
    public function get index():Number
    {
      return _index;
    }
    
    /**
     * @private
     */
    public function set index(value:Number):void
    {
      if (_index != value && target != null && value >= 0 && value < target.numElements)
      {
        if (_tween != null && _oldIndex >= 0)
        {
          _tween.endTween();
        }
        _oldIndex = _index;
        _index = value;
        dispatchEvent(new Event("indexChanged"));
        target.invalidateDisplayList();
      }
    
    }
    
    /**
     * @private
     */
    override public function updateDisplayList(width:Number, height:Number):void
    {
      super.updateDisplayList(width, height);
      
      var numElements:int = target.numElements;
      
      var element:IVisualElement;
      
      // If it use virtual layout, we only have to positionate the current element
      if (useVirtualLayout)
      {
        if (_oldIndex == -1)
        {
          // Beware that calling getVirtualElementAt function create an instanse of the renderer
          element = getVisualElement(_index);
          showVisualElement(element, true);
          element.setLayoutBoundsSize(width, height);
          element.setLayoutBoundsPosition(0, 0);
          
          createExtraRendererInstance(width, height);
        }
        
      }
      // Else we have to positionate/set visibility all elements
      else
      {
        if (_oldIndex == -1)
        {
          for (var i:uint = 0; i < numElements; i++)
          {
            element = getVisualElement(i);
            if (i == _index)
            {
              showVisualElement(element, true);
              element.setLayoutBoundsSize(width, height);
              element.setLayoutBoundsPosition(0, 0);
            }
            else
            {
              showVisualElement(element, false);
            }
          }
        }
      }
      
      if (_oldIndex != -1)
      {
        _oldElement = getVisualElement(_oldIndex);
        _oldElement.setLayoutBoundsSize(width, height);
        showVisualElement(_oldElement, true);
        
        _newElement = getVisualElement(_index);
        showVisualElement(_newElement, true);
        _newElement.setLayoutBoundsSize(width, height);
        
        _direction = direction * (_oldIndex - _index);
        
        var tweenEndValue:Number;
        if (orientation == HORIZONTAL)
        {
          _newElement.setLayoutBoundsPosition(-_direction * width, 0);
          tweenEndValue = width;
        }
        else if (orientation == VERTICAL)
        {
          _newElement.setLayoutBoundsPosition(0, -_direction * height);
          tweenEndValue = height;
        }
        
        if (_tween)
        {
          _tween.stop();
        }
        
        _tween = new Tween(this, 0, tweenEndValue, slideDuration, 30, tweenUpdateHandler, tweenEndHandler);
      }
    }
    
    private function createExtraRendererInstance(width:Number, height:Number):void
    {
      if (!(target is SlideDataGroup) || (target as SlideDataGroup).virtualRendererPreloadEnable == false)
      {
        return;
      }
      
      var virtualInstanceNumber:int = 3;
      
      var element:IVisualElement;
      
      var firstIndex:int = Math.max(_index - Math.floor(virtualInstanceNumber / 2), 0);
      var lastIndex:int = Math.min(_index + Math.floor(virtualInstanceNumber / 2), target.numElements - 1);
      for (var j:uint = firstIndex; j <= lastIndex; j++)
      {
        element = getVisualElement(j);
        if (j != _index)
        {
          showVisualElement(element, false);
          element.setLayoutBoundsSize(width, height);
        }
      }
    }
    
    
    /**
     * @private
     */
    private function tweenUpdateHandler(value:String):void
    {
      var position:int = int(value);
      
      if (orientation == HORIZONTAL)
      {
        _newElement.setLayoutBoundsPosition(_direction * position - _direction * _oldElement.width, 0);
        
        _oldElement.setLayoutBoundsPosition(_direction * position, 0);
      }
      else if (orientation == VERTICAL)
      {
        _newElement.setLayoutBoundsPosition(0, _direction * position - _direction * _oldElement.height);
        
        _oldElement.setLayoutBoundsPosition(0, _direction * position);
      }
    }
    
    /**
     * @private
     */
    private function tweenEndHandler(value:String):void
    {
      _newElement.setLayoutBoundsPosition(0, 0);
      
      showVisualElement(_oldElement, false);
      
      _oldIndex = -1;
      
      target.invalidateDisplayList();
    }
    
    /**
     * @private
     */
    protected function showVisualElement(element:IVisualElement, show:Boolean):void
    {
      element.visible = show;
      element.includeInLayout = show;
    }
    
    /**
     * @private
     */
    protected function getVisualElement(index:int):IVisualElement
    {
      var element:IVisualElement;
      if (useVirtualLayout)
      {
        element = target.getVirtualElementAt(index);
      }
      else
      {
        element = target.getElementAt(index);
      }
      return element;
    }
  
  }
}
