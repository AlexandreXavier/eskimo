package com.pialabs.eskimo.components
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.events.ItemClickEvent;
    
    import spark.components.CheckBox;
    import spark.components.List;
    import spark.components.supportClasses.ItemRenderer;
    
    /**
     *  The CheckBoxItemRenderer class defines the checkbox item renderer
     *  This is a simple item renderer with a single checkbox component.
     */
    public class CheckBoxItemRenderer extends ItemRenderer
    {
        /**
        * Contructor
        */
        public function CheckBoxItemRenderer()
        {
            super();
            this.showsCaret = false;
            autoDrawBackground = false;
        }
        
        /**
         * CheckBox Componenet
         */
        protected var checkBox:CheckBox;
        
        /**
         * @private
         */
        override protected function createChildren():void
        {
            super.createChildren();
            this.checkBox = new CheckBox();
            addElement(this.checkBox);
            
            this.checkBox.addEventListener(Event.CHANGE, onToggleChange);
            
            this.checkBox.percentWidth = 100;
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            checkBox.selected = selected;
            checkBox.label = label;
        }
        
        /**
         * @private
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            checkBox.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
        }
        
        
        /**
         * @private
         */
        protected function onToggleChange(event:Event):void
        {
            if (checkBox.selected != selected)
            {
                var changeEvent:Event = new Event(Event.CHANGE);
                dispatchEvent(changeEvent);
            }
        }
    }
}
