package com.piaction.controls
{
  import com.piaction.skins.android.AlertSkin;
  import com.piaction.skins.ios.AlertSkin;
  import com.piaction.skins.ios.ButtonSkin;
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.system.Capabilities;
  
  import mx.core.FlexGlobals;
  import mx.core.IFlexDisplayObject;
  import mx.events.CloseEvent;
  import mx.events.FlexEvent;
  import mx.managers.ISystemManager;
  import mx.managers.PopUpManager;
  import mx.styles.CSSStyleDeclaration;
  import mx.styles.StyleManager;
  
  import spark.components.Button;
  import spark.components.Group;
  import spark.components.Label;
  import spark.components.supportClasses.SkinnableComponent;
  
  [Event(name="close", type="mx.events.CloseEvent")]
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
    public static const CANCEL:uint= 0x0008;
    /**
     *  Value that remove modal background
     */
    public static const NONMODAL:uint = 0x8000;
    
    /**
     *  A bitmask that contains <code>Alert.OK</code>, <code>Alert.CANCEL</code>, 
     *  <code>Alert.YES</code>, and/or <code>Alert.NO</code> indicating
     *  the buttons available in the Alert control.
     */
    public var buttonFlags:uint = OK;
    
    /**
     * @private
     */
    public var buttonFlagsChanged:Boolean = true;
    
    private var _text:String;
    private var _title:String;
    
    [SkinPart(required="false")]
    public var titleDisplay:Label;
    
    [SkinPart(required="false")]
    public var textDisplay:Label;
    
    [SkinPart(required="false")]
    public var controlBarGroup:Group;
    
    /**
     * @private
     */
    protected var buttonOK:Button = new Button();
    protected var buttonCANCEL:Button = new Button();
    protected var buttonYES:Button = new Button();
    protected var buttonNO:Button = new Button();
    
    
    protected static var _okLabel:String = "OK";
    protected static var _cancelLabel:String = "Cancel";
    protected static var _yesLabel:String = "Yes";
    protected static var _noLabel:String = "No";
    protected static var _buttonHeight:Number = 50;
    
    /**
     * @private
     */
    private static var classConstructed:Boolean = classConstruct();
    
    /**
     * @private
     */
    protected static function classConstruct():Boolean
    {
      var styles:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.piaction.controls.SkinnableAlert");
      if(!styles)
      {
        styles = new CSSStyleDeclaration();
      }
      
      styles.defaultFactory = function():void
      {
        if (Capabilities.version.substr(0,3) == "IOS")
        {
          this.skinClass =  com.piaction.skins.ios.AlertSkin;
        }
        else
        {
          this.skinClass = com.piaction.skins.android.AlertSkin
        }
      }
      
      FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.piaction.controls.SkinnableAlert", styles, false);
      
      return true;
    }
    
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
      
      buttonOK.percentHeight = 100;
      buttonCANCEL.percentHeight = 100;
      buttonYES.percentHeight = 100;
      buttonNO.percentHeight = 100;
      
      buttonOK.label = _okLabel;
      buttonCANCEL.label = _cancelLabel;
      buttonYES.label = _yesLabel;
      buttonNO.label = _noLabel;
      
    }
    
    /**
     * @private
     */
    protected override function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      if(instance == controlBarGroup)
      {
        controlBarGroup.height = _buttonHeight;
        controlBarGroup.removeAllElements();
        if(buttonFlags & SkinnableAlert.OK)
        {
          controlBarGroup.addElement(buttonOK);
        }
        if(buttonFlags & SkinnableAlert.YES)
        {
          controlBarGroup.addElement(buttonYES);
        }
        if(buttonFlags & SkinnableAlert.NO)
        {
          controlBarGroup.addElement(buttonNO);
        }
        if(buttonFlags & SkinnableAlert.CANCEL)
        {
          controlBarGroup.addElement(buttonCANCEL);
        }
      }
      if(instance == titleDisplay)
      {
        titleDisplay.text = _title;
      }
      if(instance == textDisplay)
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
      if(buttonFlagsChanged)
      {
        if(controlBarGroup)
        {
          controlBarGroup.removeAllElements();
          if(buttonFlags & SkinnableAlert.OK)
          {
            controlBarGroup.addElement(buttonOK);
          }
          if(buttonFlags & SkinnableAlert.YES)
          {
            controlBarGroup.addElement(buttonYES);
          }
          if(buttonFlags & SkinnableAlert.NO)
          {
            controlBarGroup.addElement(buttonNO);
          }
          if(buttonFlags & SkinnableAlert.CANCEL)
          {
            controlBarGroup.addElement(buttonCANCEL);
          }
        }
        
        buttonFlagsChanged = false;
      }
    }
    
    /**
     * Show na Alert control
     */
    public static function show(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null):void
    {
      var modal:Boolean = (flags & SkinnableAlert.NONMODAL) ? false : true;
      
      if (!parent)
      {
        var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
        // no types so no dependencies
        var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
        if (mp && mp.useSWFBridge())
          parent = Sprite(sm.getSandboxRoot());
        else
          parent = Sprite(FlexGlobals.topLevelApplication);
      }
      
      
      var alert:SkinnableAlert = new SkinnableAlert();
      
      if (flags & SkinnableAlert.OK||
        flags & SkinnableAlert.CANCEL ||
        flags & SkinnableAlert.YES ||
        flags & SkinnableAlert.NO)
      {
        alert.buttonFlags = flags;
      }
      
      alert.text = text;
      alert.title = title;
      
      if (closeHandler != null)
        alert.addEventListener(CloseEvent.CLOSE, closeHandler);
      
      alert.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
      
      
      PopUpManager.addPopUp(alert, parent, modal);
    }
    
    /**
     * @private
     */
    protected static function onCreationComplete(event:FlexEvent):void
    {
      PopUpManager.centerPopUp(event.target as IFlexDisplayObject);
    }
    
    /**
     * Text of the Alert control
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
     * Text of the title control
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
     * Text of the o lLabel control
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
     * Text of the cancel label of Alert control
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
     * Text of the yes Label of Alert control
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
     * Text of the no Label of Alert control
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
     * Text of the button height of Alert control
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
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE,false, false, SkinnableAlert.OK));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected function onCancelClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE,false, false, SkinnableAlert.CANCEL));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected function onYesClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE,false, false, SkinnableAlert.YES));
      PopUpManager.removePopUp(this);
    }
    
    /**
     * @private
     */
    protected function onNoClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE,false, false, SkinnableAlert.NO));
      PopUpManager.removePopUp(this);
    }
    
  }
}