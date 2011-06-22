package com.piaction.components
{
    import com.piaction.events.ConfirmEvent;
    import com.piaction.skins.ios.ConfirmButtonSkin;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    
    import mx.core.FlexGlobals;
    import mx.core.IButton;
    import mx.events.FlexEvent;
    import mx.events.StateChangeEvent;
    import mx.states.State;
    import mx.styles.CSSStyleDeclaration;
    
    import spark.components.Button;
    import spark.components.supportClasses.SkinnableComponent;
    
    /**
     *  Dispatched after the focus has changed.
     *
     *  @eventType spark.events.ConfirmEvent.ENTER_CONFIRMATION
     */
    [Event(name = "enterConfirmation", type = "com.piaction.events.ConfirmEvent")]
    
    /**
     *  Dispatched after the focus has changed.
     *
     *  @eventType spark.events.ConfirmEvent.CANCEL
     */
    [Event(name = "cancel", type = "com.piaction.events.ConfirmEvent")]
    
    /**
     *  Dispatched after the focus has changed.
     *
     *  @eventType spark.events.ConfirmEvent.CONFIRM
     */
    [Event(name = "confirm", type = "com.piaction.events.ConfirmEvent")]
    
    
    [SkinState("normal")]
    [SkinState("confirmation")]
    
    /**
     * Skinclass of request button
     */
    [Style(name = "buttonSkinClass", inherit = "no", type = "Class")]
    /**
     * Color of request button
     */
    [Style(name = "buttonColor", inherit = "no", type = "uint")]
    /**
     * chromeColor of request button
     */
    [Style(name = "buttonChromeColor", inherit = "no", type = "uint")]
    /**
     * icon of request button
     */
    [Style(name = "buttonIcon", inherit = "no", type = "Object")]
    
    /**
     * Skinclass of cancel button
     */
    [Style(name = "cancelButtonSkinClass", inherit = "no", type = "Class")]
    /**
     * Color of cancel button
     */
    [Style(name = "cancelColor", inherit = "no", type = "uint")]
    /**
     * chromeColor of cancel button
     */
    [Style(name = "cancelChromeColor", inherit = "no", type = "uint")]
    
    /**
     * Skinclass of confirm button
     */
    [Style(name = "confirmButtonSkinClass", inherit = "no", type = "Class")]
    /**
     * Color of confirm button
     */
    [Style(name = "confirmColor", inherit = "no", type = "uint")]
    /**
     * chromeColor of confirm button
     */
    [Style(name = "confirmChromeColor", inherit = "no", type = "uint")]
    
    /**
     * percentWidth of request button
     */
    [Style(name = "buttonPercentWidth", inherit = "no", type = "Number")]
    
    /**
     * Confirmation Button
     */
    public class ConfirmButton extends SkinnableComponent
    {
        /**
         * Request button
         */
        [SkinPart(required = "true")]
        public var button:Button;
        
        /**
         * Cancel button
         */
        [SkinPart(required = "true")]
        public var cancelButton:Button;
        
        /**
         * Validation button
         */
        [SkinPart(required = "true")]
        public var confirmButton:Button;
        
        /**
         * @private
         */
        private var _buttonLabel:String = "";
        private var _cancelLabel:String = "Cancel";
        private var _confirmLabel:String = "Confirm";
        
        /**
         * Normal state
         */
        public static var NORMAL_STATE:String = "normal";
        /**
         * Confirmation state
         */
        public static var CONFIRMATION_STATE:String = "confirmation";
        
        /**
         * Constructor
         */
        public function ConfirmButton()
        {
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            addEventListener(StateChangeEvent.CURRENT_STATE_CHANGING, onStateChange);
        }
        
        /**
         * @private
         * Creation complete handler
         */
        private function onCreationComplete(event:Event):void
        {
            states = [new State({name: NORMAL_STATE}), new State({name: CONFIRMATION_STATE})];
        }
        
        /**
         * @private
         * State change handler
         */
        private function onStateChange(event:StateChangeEvent):void
        {
            invalidateSkinState();
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
                button.setStyle("color", getStyle("buttonColor"));
                button.setStyle("chromeColor", getStyle("buttonChromeColor"));
                button.setStyle("skinClass", getStyle("buttonSkinClass"));
                button.setStyle("icon", getStyle("buttonIcon"));
                button.percentWidth = getStyle("buttonPercentWidth");
            }
            
            if (cancelButton)
            {
                cancelButton.setStyle("color", getStyle("cancelColor"));
                cancelButton.setStyle("chromeColor", getStyle("cancelChromeColor"));
                cancelButton.setStyle("skinClass", getStyle("cancelButtonSkinClass"));
            }
            
            if (confirmButton)
            {
                confirmButton.setStyle("color", getStyle("confirmColor"));
                confirmButton.setStyle("chromeColor", getStyle("confirmChromeColor"));
                confirmButton.setStyle("skinClass", getStyle("confirmButtonSkinClass"));
            }
        }
        
        /**
         * @private
         * Request button click handler
         */
        protected function onButtonClick(event:MouseEvent):void
        {
            currentState = CONFIRMATION_STATE;
            dispatchEvent(new ConfirmEvent(ConfirmEvent.ENTER_CONFIRMATION));
        }
        
        /**
         * @private
         * Cancel button click handler
         */
        protected function onCancelClick(event:MouseEvent):void
        {
            currentState = NORMAL_STATE;
            dispatchEvent(new ConfirmEvent(ConfirmEvent.CANCEL));
        }
        
        /**
         * @private
         * Validation button click handler
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
         * Label of request button
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
         * Label of cancel button
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
         * Label of validation button
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
         * Cancel the confirmation
         */
        public function cancel():void
        {
            currentState = NORMAL_STATE;
            validateNow();
            dispatchEvent(new ConfirmEvent(ConfirmEvent.CANCEL));
        }
    }
}