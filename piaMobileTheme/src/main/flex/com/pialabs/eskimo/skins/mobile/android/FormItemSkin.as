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
  import flash.events.Event;
  
  import mx.containers.utilityClasses.ConstraintColumn;
  import mx.containers.utilityClasses.ConstraintRow;
  import mx.events.FlexEvent;
  import mx.states.State;
  
  import spark.components.FormItem;
  import spark.components.Group;
  import spark.components.HGroup;
  import spark.components.Label;
  import spark.components.supportClasses.Skin;
  import spark.layouts.FormItemLayout;
  import spark.layouts.VerticalLayout;
  
  /**
   * @copy spark.skins.spark.ApplicationSkin#hostComponent
   */
  [HostComponent("spark.components.FormItem")]
  
  [States("normal", "disabled", "error", "required", "requiredAndDisabled", "requiredAndError")]
  
  /**
  * Form item skins for Android
  */
  public class FormItemSkin extends Skin
  {
    public var contentGroup:Group;
    public var topGroup:Group;
    
    public var helpContentGroup:Group;
    public var labelDisplay:Label;
    public var errorTextDisplay:Label;
    
    [Bindable]
    public var hostComponent:FormItem;
    
    /**
    * @private
    */
    public function FormItemSkin()
    {
      super();
      
      states = [new State({name: "normal"}), new State({name: "disabled"}), new State({name: "error"})
                           , new State({name: "required"}), new State({name: "requiredAndDisabled"})
                           , new State({name: "requiredAndError"})];
      
      
      var formItemLayout:VerticalLayout = new VerticalLayout();
      
      layout = formItemLayout;
      
      addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
    }
    
    /**
     * @private
     */
    private function onCreationComplete(event:Event):void
    {
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (!topGroup)
      {
        topGroup = new HGroup();
        addElement(topGroup);
        topGroup.styleName = this;
        
        topGroup.percentWidth = 100;
      }
      if (!labelDisplay)
      {
        labelDisplay = new Label();
        labelDisplay.id = "labelDisplay";
        
        topGroup.addElementAt(labelDisplay, 0);
      }
      if (!errorTextDisplay)
      {
        errorTextDisplay = new Label();
        errorTextDisplay.id = "errorTextDisplay";
        
        topGroup.addElement(errorTextDisplay);
        
        errorTextDisplay.percentWidth = 100;
        errorTextDisplay.percentHeight = 100;
        errorTextDisplay.baseline = 0;
      }
      if (!contentGroup)
      {
        contentGroup = new Group();
        
        contentGroup.setStyle("showErrorTip", false);
        contentGroup.setStyle("showErrorSkin", true);
        
        contentGroup.left = 0;
        contentGroup.right = 0;
        contentGroup.top = 0;
        contentGroup.bottom = 0;
        
        var vlayout:VerticalLayout = new VerticalLayout();
        vlayout.horizontalAlign = "justify";
        
        contentGroup.layout = vlayout;
        addElement(contentGroup);
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
  
  
  }
}
