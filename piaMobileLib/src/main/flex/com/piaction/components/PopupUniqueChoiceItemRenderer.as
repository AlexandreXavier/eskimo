package com.piaction.components
{
    
    import mx.core.FlexGlobals;
    import mx.graphics.SolidColorStroke;
    import mx.styles.CSSStyleDeclaration;
    
    import spark.components.LabelItemRenderer;
    import spark.components.RadioButton;
    import spark.components.RadioButtonGroup;
    import spark.components.supportClasses.ItemRenderer;
    import spark.primitives.Line;
    
    public class PopupUniqueChoiceItemRenderer extends ItemRenderer
    {
        private var radioButton:RadioButton;
        
        private var _radioGroup:RadioButtonGroup;
        
        private var bottomLine:Line;
        
        public function PopupUniqueChoiceItemRenderer()
        {
            this.showsCaret = false;
            autoDrawBackground = false;
        }
        
        override protected function childrenCreated():void
        {
            super.childrenCreated();
            
            
            if (radioButton == null)
            {
                radioButton = new RadioButton();
                radioButton.percentWidth = 100;
                radioButton.percentHeight = 100;
                
                bottomLine = new Line();
                bottomLine.height = 1;
                bottomLine.stroke = new SolidColorStroke(0x000000);
                bottomLine.bottom = -8;
                
                addElement(radioButton);
                addElement(bottomLine);
            }
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            radioButton.selected = selected;
            radioButton.label = label;
        }
        
        override public function set data(value:Object):void
        {
            super.data = value;
            
            invalidateProperties();
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            bottomLine.width = unscaledWidth;
        }
    }
}