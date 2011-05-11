package com.piaction.components
{
  import com.piaction.skins.ios.ConfirmButtonSkin;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import mx.core.IButton;
  import mx.events.FlexEvent;
  import mx.events.StateChangeEvent;
  import mx.states.State;
  
  import spark.components.Button;
  import spark.components.supportClasses.SkinnableComponent;
  
  [Event(name="buttonClick", type="flash.events.Event")]
  [Event(name="cancel", type="flash.events.Event")]
  [Event(name="confirm", type="flash.events.Event")]
  
  [SkinState("normal")]
  [SkinState("confirmation")]
  
  [Style(name="buttonSkinClass", inherit="no", type="Class")]
  [Style(name="buttonColor", inherit="no", type="uint")]
  [Style(name="buttonChromeColor", inherit="no", type="uint")]
  [Style(name="buttonIcon", inherit="no", type="Object")]
  
  [Style(name="cancelButtonSkinClass", inherit="no", type="Class")]
  [Style(name="cancelColor", inherit="no", type="uint")]
  [Style(name="cancelChromeColor", inherit="no", type="uint")]
  
  [Style(name="confirmButtonSkinClass", inherit="no", type="Class")]
  [Style(name="confirmColor", inherit="no", type="uint")]
  [Style(name="confirmChromeColor", inherit="no", type="uint")]
  [Style(name="buttonPercentWidth", inherit="no", type="Number")]
  public class ConfirmButton extends SkinnableComponent
  {
    
    [SkinPart(required="true")]
    public var button:Button;
    
    [SkinPart(required="true")]
    public var cancelButton:Button;
    
    [SkinPart(required="true")]
    public var confirmButton:Button;
    
    private var _buttonLabel:String = "";
    private var _cancelLabel:String = "Cancel";
    private var _confirmLabel:String = "Confirm";
    
    public static var NORMAL_STATE:String = "normal";
    public static var CONFIRMATION_STATE:String = "confirmation";
    
    public function ConfirmButton()
    {
      addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
      addEventListener(StateChangeEvent.CURRENT_STATE_CHANGING, onStateChange);
      
      if(getStyle("skinClass") == null) setStyle("skinClass", ConfirmButtonSkin);
    }
    
    private function onCreationComplete(event:Event):void
    {
      states = [new State({name:NORMAL_STATE}), new State({name:CONFIRMATION_STATE})];
    }
    
    private function onStateChange(event:StateChangeEvent):void
    {
      invalidateSkinState();
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
      if(instance == button)
      {
        button.addEventListener(MouseEvent.CLICK, onButtonClick);
        button.label = _buttonLabel;
      }
      if(instance == cancelButton)
      {
        cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
        cancelButton.label = _cancelLabel;
      }
      if(instance == confirmButton)
      {
        confirmButton.addEventListener(MouseEvent.CLICK, onConfirmClick);
        confirmButton.label = _confirmLabel;
      }
      
      invalidateProperties();
    }
    
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if(button)
      {
        button.label = _buttonLabel;
      }
      if(cancelButton)
      {
        cancelButton.label = _cancelLabel;
      }
      if(confirmButton)
      {
        confirmButton.label = _confirmLabel;
      }
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if(button)
      {
        button.setStyle("color", getStyle("buttonColor"));
        button.setStyle("chromeColor", getStyle("buttonChromeColor"));
        button.setStyle("skinClass", getStyle("buttonSkinClass"));
        button.setStyle("icon", getStyle("buttonIcon"));
        button.percentWidth = getStyle("buttonPercentWidth");
      }
      
      if(cancelButton)
      {
        cancelButton.setStyle("color", getStyle("cancelColor"));
        cancelButton.setStyle("chromeColor", getStyle("cancelChromeColor"));
        cancelButton.setStyle("skinClass", getStyle("cancelButtonSkinClass"));
      }
      
      if(confirmButton)
      {
        confirmButton.setStyle("color", getStyle("confirmColor"));
        confirmButton.setStyle("chromeColor", getStyle("confirmChromeColor"));
        confirmButton.setStyle("skinClass", getStyle("confirmButtonSkinClass"));
      }
    }
    
    protected function onButtonClick(event:MouseEvent):void
    {
      currentState = CONFIRMATION_STATE;
      dispatchEvent(new Event("buttonClick"));
    }
    
    protected function onCancelClick(event:MouseEvent):void
    {
      currentState = NORMAL_STATE;
      dispatchEvent(new Event("cancel"));
    }
    
    protected function onConfirmClick(event:MouseEvent):void
    {
      currentState = NORMAL_STATE;
      dispatchEvent(new Event("confirm"));
    }
    
    protected override function getCurrentSkinState():String
    {
      return currentState;
    }
    
    public function get buttonLabel():String
    {
      return _buttonLabel;
    }
    
    public function set buttonLabel(value:String):void
    {
      _buttonLabel = value;
      invalidateProperties();
    }
    
    public function get cancelLabel():String
    {
      return _cancelLabel;
    }
    
    public function set cancelLabel(value:String):void
    {
      _cancelLabel = value;
      invalidateProperties();
    }
    
    public function get confirmLabel():String
    {
      return _confirmLabel;
    }
    
    public function set confirmLabel(value:String):void
    {
      _confirmLabel = value;
      invalidateProperties();
    }
    
    public function cancel():void
    {
      currentState = NORMAL_STATE;
      validateNow();
      dispatchEvent(new Event("cancel"));
    }
  }
}