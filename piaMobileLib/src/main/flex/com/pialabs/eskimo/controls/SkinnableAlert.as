package com.pialabs.eskimo.controls
{
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.StageOrientationEvent;
  import flash.ui.Keyboard;
  
  import mx.core.FlexGlobals;
  import mx.core.IFlexDisplayObject;
  import mx.events.CloseEvent;
  import mx.events.FlexEvent;
  import mx.managers.ISystemManager;
  import mx.managers.PopUpManager;
  
  import spark.components.Button;
  import spark.components.Group;
  import spark.components.Label;
  import spark.components.PopUpPosition;
  import spark.components.supportClasses.SkinnableComponent;
  
  /**
   * Evant dispatched when the Alert is closed
   * @eventType mx.events.CloseEvent.CLOSE
   */
  [Event(name = "close", type = "mx.events.CloseEvent")]
  
  /**
   * Define the chrome background color the Alert comtrol
   * @defaults ios: 0x031037, android: 0x424242
   */
  [Style(name = "backgroundColor", inherit = "no", type = "uint")]
  
  /**
   * Define the chrome background alpha the Alert comtrol
   * @defaults 0.9
   */
  [Style(name = "backgroundAlpha", inherit = "no", type = "uint")]
  
  /**
   * Style of the OK button
   * @defaults "okButtonStyle"
   */
  [Style(name = "okButtonStyleName", inherit = "no", type = "String")]
  /**
   * Style of the CANCEL button
   * @defaults "cancelButtonStyle"
   */
  [Style(name = "cancelButtonStyleName", inherit = "no", type = "String")]
  /**
   * Style of the YES button
   * @defaults "yesButtonStyle"
   */
  [Style(name = "yesButtonStyleName", inherit = "no", type = "String")]
  /**
   * Style of the NO button
   * @defaults "noButtonStyle"
   */
  [Style(name = "noButtonStyleName", inherit = "no", type = "String")]
  
  /**
   * This component allow the user to display an Alert.
   * It automatically uses iOS or Android 's style depending to the execution platform.
   *
   * It follows the mx.controls.Alert 's behavior.
   */
  public class SkinnableAlert extends SkinnableComponent
  {
    /**
     *  Value that enables a Yes button on the Alert control
     */
    public static const YES:uint = 0x0001;
    /**
     *  Value that enables a No button on the Alert control
     */
    public static const NO:uint = 0x0002;
    /**
     *  Value that enables a OK button on the Alert control
     */
    public static const OK:uint = 0x0004;
    /**
     *  Value that enables a Cancel button on the Alert control
     */
    public static const CANCEL:uint = 0x0008;
    /**
     *  Value that remove modal background
     */
    public static const NONMODAL:uint = 0x8000;
    
    /**
     *  A bitmask that contains <code>SkinnableAlert.OK</code>, <code>SkinnableAlert.CANCEL</code>,
     *  <code>SkinnableAlert.YES</code>, and/or <code>SkinnableAlert.NO</code> indicating
     *  the buttons available in the SkinnableAlert control.
     */
    public var buttonFlags:uint = OK;
    
    /**
     * @private
     */
    public var buttonFlagsChanged:Boolean = true;
    
    /**
     * @private
     */
    private var _text:String;
    /**
     * @private
     */
    private var _title:String;
    
    /**
     * Title skin part
     */
    [SkinPart(required = "false")]
    public var titleDisplay:Label;
    
    /**
     * Text skin part
     */
    [SkinPart(required = "false")]
    public var textDisplay:Label;
    
    /**
     * Control bar group skin part
     */
    [SkinPart(required = "false")]
    public var controlBarGroup:Group;
    
    /**
     * @private
     */
    protected var buttonOK:Button = new Button();
    /**
     * @private
     */
    protected var buttonCANCEL:Button = new Button();
    /**
     * @private
     */
    protected var buttonYES:Button = new Button();
    /**
     * @private
     */
    protected var buttonNO:Button = new Button();
    
    
    /**
     * @private
     */
    protected static var _okLabel:String = "OK";
    /**
     * @private
     */
    protected static var _cancelLabel:String = "Cancel";
    /**
     * @private
     */
    protected static var _yesLabel:String = "Yes";
    /**
     * @private
     */
    protected static var _noLabel:String = "No";
    /**
     * @private
     */
    protected static var _buttonHeight:Number = 50;
    
    
    /**
     * Constructor
     */
    public function SkinnableAlert()
    {
      buttonOK = new Button();
      buttonCANCEL = new Button();
      buttonYES = new Button();
      buttonNO = new Button();
      
      buttonOK.addEventListener(MouseEvent.CLICK, onOKClick);
      buttonCANCEL.addEventListener(MouseEvent.CLICK, onCancelClick);
      buttonYES.addEventListener(MouseEvent.CLICK, onYesClick);
      buttonNO.addEventListener(MouseEvent.CLICK, onNoClick);
      
      buttonOK.percentWidth = 100;
      buttonCANCEL.percentWidth = 100;
      buttonYES.percentWidth = 100;
      buttonNO.percentWidth = 100;
      
      buttonOK.percentHeight = 100;
      buttonCANCEL.percentHeight = 100;
      buttonYES.percentHeight = 100;
      buttonNO.percentHeight = 100;
      
      buttonOK.label = _okLabel;
      buttonCANCEL.label = _cancelLabel;
      buttonYES.label = _yesLabel;
      buttonNO.label = _noLabel;
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, true);
    }
    
    private function onAddedToStage(event:Event):void
    {
      systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
      
      stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange, false, 0, true);
    }
    
    /**
     * @private
     */
    private function removeFromStage(event:Event):void
    {
      systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      
      stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange);
    }
    
    /**
     * @private
     */
    private function onOrientationChange(event:Event):void
    {
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    protected override function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      if (instance == controlBarGroup)
      {
        controlBarGroup.height = _buttonHeight;
        controlBarGroup.removeAllElements();
        if (buttonFlags & SkinnableAlert.OK)
        {
          controlBarGroup.addElement(buttonOK);
        }
        if (buttonFlags & SkinnableAlert.YES)
        {
          controlBarGroup.addElement(buttonYES);
        }
        if (buttonFlags & SkinnableAlert.NO)
        {
          controlBarGroup.addElement(buttonNO);
        }
        if (buttonFlags & SkinnableAlert.CANCEL)
        {
          controlBarGroup.addElement(buttonCANCEL);
        }
      }
      if (instance == titleDisplay)
      {
        titleDisplay.text = _title;
      }
      if (instance == textDisplay)
      {
        textDisplay.text = _text;
      }
    }
    
    /**
     * @private
     */
    protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      if (buttonFlagsChanged)
      {
        if (controlBarGroup)
        {
          controlBarGroup.removeAllElements();
          if (buttonFlags & SkinnableAlert.OK)
          {
            controlBarGroup.addElement(buttonOK);
          }
          if (buttonFlags & SkinnableAlert.YES)
          {
            controlBarGroup.addElement(buttonYES);
          }
          if (buttonFlags & SkinnableAlert.NO)
          {
            controlBarGroup.addElement(buttonNO);
          }
          if (buttonFlags & SkinnableAlert.CANCEL)
          {
            controlBarGroup.addElement(buttonCANCEL);
          }
        }
        
        buttonFlagsChanged = false;
        
        buttonOK.styleName = getStyle("okButtonStyleName");
        buttonCANCEL.styleName = getStyle("cancelButtonStyleName");
        buttonYES.styleName = getStyle("yesButtonStyleName");
        buttonNO.styleName = getStyle("noButtonStyleName");
      }
      
      PopUpManager.centerPopUp(this);
    }
    
    /**
    * @private
    */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (textDisplay)
      {
        textDisplay.text = _text;
      }
    }
    
    /**
     * Create and show an Alert control
     * @param text     Text showed in the Alert control
     * @param title    Title of the Alert control
     * @param flags    A bitmask that contains <code>SkinnableAlert.OK</code>, <code>SkinnableAlert.CANCEL</code>,
     *                 <code>SkinnableAlert.YES</code>, and/or <code>SkinnableAlert.NO</code> indicating
     *                 the buttons available in the SkinnableAlert control.
     * @param closeHandler  Close function callback
     *
     */
    public static function show(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null):SkinnableAlert
    {
      var modal:Boolean = (flags & SkinnableAlert.NONMODAL) ? false : true;
      
      if (!parent)
      {
        var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
        // no types so no dependencies
        var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
        if (mp && mp.useSWFBridge())
        {
          parent = Sprite(sm.getSandboxRoot());
        }
        else
        {
          parent = Sprite(FlexGlobals.topLevelApplication);
        }
      }
      
      
      var alert:SkinnableAlert = new SkinnableAlert();
      
      if (flags & SkinnableAlert.OK || flags & SkinnableAlert.CANCEL || flags & SkinnableAlert.YES || flags & SkinnableAlert.NO)
      {
        alert.buttonFlags = flags;
      }
      
      alert.text = text;
      alert.title = title;
      
      if (closeHandler != null)
      {
        alert.addEventListener(CloseEvent.CLOSE, closeHandler);
      }
      
      alert.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
      
      
      PopUpManager.addPopUp(alert, parent, modal);
      
      return alert;
    }
    
    /**
     * @private
     */
    protected static function onCreationComplete(event:FlexEvent):void
    {
      PopUpManager.centerPopUp(event.target as IFlexDisplayObject);
    }
    
    /**
     * Text of the SkinnableAlert control
     */
    public function get text():String
    {
      return _text;
    }
    
    /**
     * @private
     */
    public function set text(value:String):void
    {
      _text = value;
    }
    
    /**
     * Title of the SkinnableAlert control
     */
    public function get title():String
    {
      return _title;
    }
    
    /**
     * @private
     */
    public function set title(value:String):void
    {
      _title = value;
    }
    
    /**
     * Label of the OK button
     */
    public static function get okLabel():String
    {
      return _okLabel;
    }
    
    /**
     * @private
     */
    public static function set okLabel(value:String):void
    {
      _okLabel = value;
    }
    
    /**
     * Label of the CANCEL button
     */
    public static function get cancelLabel():String
    {
      return _cancelLabel;
    }
    
    /**
     * @private
     */
    public static function set cancelLabel(value:String):void
    {
      _cancelLabel = value;
    }
    
    /**
     * Label of the YES button
     */
    public static function get yesLabel():String
    {
      return _yesLabel;
    }
    
    /**
     * @private
     */
    public static function set yesLabel(value:String):void
    {
      _yesLabel = value;
    }
    
    /**
     * Label of the NO button
     */
    public static function get noLabel():String
    {
      return _noLabel;
    }
    
    /**
     * @private
     */
    public static function set noLabel(value:String):void
    {
      _noLabel = value;
    }
    
    /**
     * Buttons height
     */
    public static function get buttonHeight():Number
    {
      return _buttonHeight;
    }
    
    /**
     * @private
     */
    public static function set buttonHeight(value:Number):void
    {
      _buttonHeight = value;
    }
    
    /**
     * @private
     */
    protected function onOKClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, SkinnableAlert.OK));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected function onCancelClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, SkinnableAlert.CANCEL));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected function onYesClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, SkinnableAlert.YES));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected function onNoClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, SkinnableAlert.NO));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected override function measure():void
    {
      super.measure();
      
      measuredMinWidth = 300;
      measuredMinHeight = 150;
      
      measuredWidth = 300;
    }
    
    /**
     * @private
     */
    protected function onKeyDown(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.BACK)
      {
        event.preventDefault();
      }
    }
  
  }
}
