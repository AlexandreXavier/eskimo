package com.piaction.components
{
    import flash.events.MouseEvent;
    
    import mx.events.ItemClickEvent;
    
    import spark.components.CheckBox;
    import spark.components.supportClasses.ItemRenderer;

    /**
     *  The CheckBoxItemRenderer class defines the checkbox item renderer
     *  This is a simple item renderer with a single checkbox component.
     */
    public class CheckBoxItemRenderer extends ItemRenderer
    {
        public function CheckBoxItemRenderer()
        {
          super();
          this.showsCaret = false;
          autoDrawBackground = false;
        }
        
        protected var checkBox : CheckBox;
        
        override protected function createChildren():void{
            super.createChildren();
            this.checkBox = new CheckBox();
            addElement(this.checkBox);
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            checkBox.selected = selected;
            checkBox.label = label;
        }
    }
}