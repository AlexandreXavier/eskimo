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
  import com.pialabs.eskimo.events.ConfirmEvent;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import mx.events.FlexEvent;
  import mx.events.StateChangeEvent;
  import mx.states.State;
  
  import spark.components.Button;
  import spark.components.supportClasses.SkinnableComponent;
  
  /**
   *  Dispatched when the button is clicked.
   *
   *  @eventType com.pialabs.eskimo.events.ConfirmEvent.ENTER_CONFIRMATION
   */
  [Event(name = "enterConfirmation", type = "com.pialabs.eskimo.events.ConfirmEvent")]
  
  /**
   *  Dispatched when the cancel button is clicked.
   *
   *  @eventType com.pialabs.eskimo.events.ConfirmEvent.CANCEL
   */
  [Event(name = "cancel", type = "com.pialabs.eskimo.events.ConfirmEvent")]
  
  /**
   *  Dispatched when the confirm button is clicked.
   *
   *  @eventType com.pialabs.eskimo.events.ConfirmEvent.CONFIRM
   */
  [Event(name = "confirm", type = "com.pialabs.eskimo.events.ConfirmEvent")]
  
  
  [SkinState("normal")]
  [SkinState("confirmation")]
  
  /**
   * Skinclass of the request button.
   */
  [Style(name = "buttonSkinClass", inherit = "no", type = "Class")]
  /**
   * Color of the request button.
   *
   * @default 0xFFFFFF
   */
  [Style(name = "buttonColor", inherit = "no", type = "uint")]
  /**
   * chromeColor of the request button.
   */
  [Style(name = "buttonChromeColor", inherit = "no", type = "uint")]
  /**
   * icon of the request button.
   */
  [Style(name = "buttonIcon", inherit = "no", type = "Object")]
  
  /**
   * Skinclass of the cancel button.
   */
  [Style(name = "cancelButtonSkinClass", inherit = "no", type = "Class")]
  /**
   * Color of the cancel button.
   */
  [Style(name = "cancelColor", inherit = "no", type = "uint")]
  /**
   * chromeColor of the cancel button.
   */
  [Style(name = "cancelChromeColor", inherit = "no", type = "uint")]
  
  /**
   * Skinclass of the confirm button.
   */
  [Style(name = "confirmButtonSkinClass", inherit = "no", type = "Class")]
  /**
   * Color of the confirm button.
   */
  [Style(name = "confirmColor", inherit = "no", type = "uint")]
  /**
   * chromeColor of the confirm button.
   *
   * @default 0xFF3333
   */
  [Style(name = "confirmChromeColor", inherit = "no", type = "uint")]
  
  /**
   * percentWidth of the request button.
   */
  [Style(name = "buttonPercentWidth", inherit = "no", type = "Number")]
  
  /**
   * This component is a button with a confirmation state to validate or cancel the action.
   * The first button, the cancel button and the confirm button are customizable.
   *
   */
  public class ConfirmButton extends SkinnableComponent
  {
    /**
     * Request button.
     */
    [SkinPart(required = "true")]
    public var button:Button;
    
    /**
     * Cancel button.
     */
    [SkinPart(required = "false")]
    public var cancelButton:Button;
    
    /**
     * Validation button.
     */
    [SkinPart(required = "true")]
    public var confirmButton:Button;
    
    /**
     * @private
     */
    protected var _buttonLabel:String = "";
    protected var _cancelLabel:String = "";
    protected var _confirmLabel:String = "";
    
    /**
     * Normal state.
     */
    public static const NORMAL_STATE:String = "normal";
    /**
     * Confirmation state.
     */
    public static const CONFIRMATION_STATE:String = "confirmation";
    
    /**
     * @private
     */
    private var _buttonColorChanged:Boolean = true;
    private var _buttonChromeColorChanged:Boolean = true;
    private var _buttonSkinClassChanged:Boolean = true;
    private var _buttonIconChanged:Boolean = true;
    private var _buttonPercentWidthChanged:Boolean = true;
    private var _cancelColorChanged:Boolean = true;
    private var _cancelChromeColorChanged:Boolean = true;
    private var _cancelButtonSkinClassChanged:Boolean = true;
    private var _confirmColorChanged:Boolean = true;
    private var _confirmChromeColorChanged:Boolean = true;
    private var _confirmButtonSkinClassChanged:Boolean = true;
    
    /**
     * Constructor.
     */
    public function ConfirmButton()
    {
      addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
      addEventListener(StateChangeEvent.CURRENT_STATE_CHANGING, onStateChange);
    }
    
    /**
     * @private
     * Creation complete handler.
     */
    protected function onCreationComplete(event:Event):void
    {
      states = [new State({name: NORMAL_STATE}), new State({name: CONFIRMATION_STATE})];
      currentState = NORMAL_STATE;
    }
    
    /**
     * @private
     * State change handler.
     */
    protected function onStateChange(event:StateChangeEvent):void
    {
      invalidateSkinState();
    }
    
    /**
     * @private
     */
    override public function styleChanged(styleProp:String):void
    {
      super.styleChanged(styleProp);
      
      // button style changed
      if (isButtonUpdatedStyle(styleProp))
      {
        return;
      }
      // cancel button style changed
      if (isCancelButtonUpdatedStyle(styleProp))
      {
        return;
      }
      // confirm button style changed
      isConfirmButtonUpdatedStyle(styleProp);
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      if (instance == button)
      {
        button.addEventListener(MouseEvent.CLICK, onButtonClick);
        button.label = _buttonLabel;
      }
      if (instance == cancelButton)
      {
        cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
        cancelButton.label = _cancelLabel;
      }
      if (instance == confirmButton)
      {
        confirmButton.addEventListener(MouseEvent.CLICK, onConfirmClick);
        confirmButton.label = _confirmLabel;
      }
      
      invalidateProperties();
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (button)
      {
        button.label = _buttonLabel;
      }
      if (cancelButton)
      {
        cancelButton.label = _cancelLabel;
      }
      if (confirmButton)
      {
        confirmButton.label = _confirmLabel;
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if (button)
      {
        updateButtonDisplayList();
      }
      if (cancelButton)
      {
        updateCancelButtonDisplayList();
      }
      if (confirmButton)
      {
        updateConfirmButtonDisplayList();
      }
    }
    
    
    /**
     * @private
     */
    protected function updateConfirmButtonDisplayList():void
    {
      if (_confirmColorChanged)
      {
        confirmButton.setStyle("color", getStyle("confirmColor"));
        _confirmColorChanged = false;
      }
      if (_confirmChromeColorChanged)
      {
        confirmButton.setStyle("chromeColor", getStyle("confirmChromeColor"));
        _confirmChromeColorChanged = false;
      }
      if (_confirmButtonSkinClassChanged)
      {
        confirmButton.setStyle("skinClass", getStyle("confirmButtonSkinClass"));
        _confirmButtonSkinClassChanged = false;
      }
    }
    
    /**
     * @private
     */
    protected function updateCancelButtonDisplayList():void
    {
      if (_cancelColorChanged)
      {
        cancelButton.setStyle("color", getStyle("cancelColor"));
        _cancelColorChanged = false;
      }
      if (_cancelChromeColorChanged)
      {
        cancelButton.setStyle("chromeColor", getStyle("cancelChromeColor"));
        _cancelChromeColorChanged = false;
      }
      if (_cancelButtonSkinClassChanged)
      {
        cancelButton.setStyle("skinClass", getStyle("cancelButtonSkinClass"));
        _cancelButtonSkinClassChanged = false;
      }
    }
    
    /**
     * @private
     */
    protected function updateButtonDisplayList():void
    {
      if (_buttonColorChanged)
      {
        button.setStyle("color", getStyle("buttonColor"));
        _buttonColorChanged = false;
      }
      if (_buttonChromeColorChanged)
      {
        button.setStyle("chromeColor", getStyle("buttonChromeColor"));
        _buttonChromeColorChanged = false;
      }
      if (_buttonSkinClassChanged)
      {
        button.setStyle("skinClass", getStyle("buttonSkinClass"));
        _buttonSkinClassChanged = false;
      }
      if (_buttonIconChanged)
      {
        button.setStyle("icon", getStyle("buttonIcon"));
        _buttonIconChanged = false;
      }
      if (_buttonPercentWidthChanged)
      {
        button.percentWidth = getStyle("buttonPercentWidth");
        _buttonPercentWidthChanged = false;
      }
    }
    
    /**
     * @private
     */
    protected function isConfirmButtonUpdatedStyle(styleProp:String):Boolean
    {
      if (styleProp == "confirmColor")
      {
        _confirmColorChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "confirmChromeColor")
      {
        _confirmChromeColorChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "confirmButtonSkinClass")
      {
        _confirmButtonSkinClassChanged = true;
        invalidateDisplayList();
        return true;
      }
      return false;
    }
    
    /**
     * @private
     */
    protected function isCancelButtonUpdatedStyle(styleProp:String):Boolean
    {
      if (styleProp == "cancelColor")
      {
        _cancelColorChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "cancelChromeColor")
      {
        _cancelChromeColorChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "cancelButtonSkinClass")
      {
        _cancelButtonSkinClassChanged = true;
        invalidateDisplayList();
        return true;
      }
      return false;
    }
    
    /**
    * @private
    */
    protected function isButtonUpdatedStyle(styleProp:String):Boolean
    {
      if (styleProp == "buttonColor")
      {
        _buttonColorChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "buttonChromeColor")
      {
        _buttonChromeColorChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "buttonSkinClass")
      {
        _buttonSkinClassChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "buttonIcon")
      {
        _buttonIconChanged = true;
        invalidateDisplayList();
        return true;
      }
      if (styleProp == "buttonPercentWidth")
      {
        _buttonPercentWidthChanged = true;
        invalidateDisplayList();
        return true;
      }
      return false;
    }
    
    /**
     * @private
     * Request button click handler.
     */
    protected function onButtonClick(event:MouseEvent):void
    {
      currentState = CONFIRMATION_STATE;
      dispatchEvent(new ConfirmEvent(ConfirmEvent.ENTER_CONFIRMATION));
    }
    
    /**
     * @private
     * Cancel button click handler.
     */
    protected function onCancelClick(event:MouseEvent):void
    {
      currentState = NORMAL_STATE;
      dispatchEvent(new ConfirmEvent(ConfirmEvent.CANCEL));
    }
    
    /**
     * @private
     * Validation button click handler.
     */
    protected function onConfirmClick(event:MouseEvent):void
    {
      currentState = NORMAL_STATE;
      dispatchEvent(new ConfirmEvent(ConfirmEvent.CONFIRM));
    }
    
    /**
     * @private
     */
    protected override function getCurrentSkinState():String
    {
      return currentState;
    }
    
    /**
     * Label of the request button.
     *
     */
    public function get buttonLabel():String
    {
      return _buttonLabel;
    }
    
    /**
     * @private
     */
    public function set buttonLabel(value:String):void
    {
      _buttonLabel = value;
      invalidateProperties();
    }
    
    /**
     * Label of the cancel button.
     *
     */
    public function get cancelLabel():String
    {
      return _cancelLabel;
    }
    
    /**
     * @private
     */
    public function set cancelLabel(value:String):void
    {
      _cancelLabel = value;
      invalidateProperties();
    }
    
    /**
     * Label of the validation button.
     *
     */
    public function get confirmLabel():String
    {
      return _confirmLabel;
    }
    
    /**
     * @private
     */
    public function set confirmLabel(value:String):void
    {
      _confirmLabel = value;
      invalidateProperties();
    }
    
    /**
     * Cancel the confirmation.
     */
    public function cancel():void
    {
      currentState = NORMAL_STATE;
      validateNow();
      dispatchEvent(new ConfirmEvent(ConfirmEvent.CANCEL));
    }
  }
}
