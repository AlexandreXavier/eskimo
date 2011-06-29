package com.piaction.components
{
    
    import mx.core.FlexGlobals;
    import mx.core.IFlexDisplayObject;
    import mx.core.ILayoutElement;
    import mx.graphics.GradientEntry;
    import mx.graphics.LinearGradient;
    import mx.graphics.SolidColorStroke;
    import mx.styles.CSSStyleDeclaration;
    
    import spark.components.LabelItemRenderer;
    import spark.components.RadioButton;
    import spark.components.RadioButtonGroup;
    import spark.components.supportClasses.ItemRenderer;
    import spark.primitives.BitmapImage;
    import spark.primitives.Line;
    import spark.primitives.Rect;
    
    public class PopupUniqueChoiceItemRenderer extends ItemRenderer
    {
        private var radioButton:RadioButton;
        
        private var rect:Rect;
        
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
                radioButton.setStyle("iconPlacement" , "right");
                radioButton.x = this.parent.width * 0.04;
                radioButton.percentWidth = 92;
                radioButton.percentHeight = 100;
            
                addElement(radioButton);
                
                createGradientLine();
            }
        }
        
        private function createGradientLine():void
        {
            rect = new Rect();
            rect.height = 1;
            rect.bottom = -8;
            rect.left = 2;
            
            var linearGradient:LinearGradient = new LinearGradient();
            rect.fill = linearGradient;
            var colorFrom:GradientEntry = new GradientEntry();
            colorFrom.color = 0xFFFFFF;
            var colorTo:GradientEntry = new GradientEntry();
            colorTo.color = 0x000000;
            
            linearGradient.entries = [colorFrom, colorTo, colorFrom];
            
            addElement(rect);
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
            rect.width = unscaledWidth - 4;
        }
    }
}