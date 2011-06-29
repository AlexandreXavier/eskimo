package com.piaction.components
{
    
    import mx.core.FlexGlobals;
    import mx.styles.CSSStyleDeclaration;
    
    import spark.components.LabelItemRenderer;
    import spark.components.RadioButton;
    import spark.components.RadioButtonGroup;
    import spark.components.supportClasses.ItemRenderer;
    
    /**
     *  The UniqueChoiceItemRenderer class defines the radio item renderer
     *  This is a simple item renderer with a single radio button component.
     */
    public class UniqueChoiceItemRenderer extends ItemRenderer
    {
        private var radioButton:RadioButton;
        
        public function UniqueChoiceItemRenderer()
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
                
                
                
                addElement(radioButton);
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
    
    }
}
