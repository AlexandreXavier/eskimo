package com.piaction.components
{
    import flash.events.Event;
    
    import mx.collections.IList;
    
    import spark.components.List;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;

    
    /**
     * Component represented by a list of CheckBox (uses Switch skin on iOs) item .
     * 
     * @see com.piaction.components.CheckBoxItemRenderer
     */
    public class MultipleChoiceList extends ChoiceList
    {
        
        /**
         * Constructor
         */
        public function MultipleChoiceList()
        {
            super();
        }
        
        /**
         * @private
         */
        private var _selectedItems:Vector.<Object>;
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if(_selectedChange)
            {
                listDisplay.selectedItems = _selectedItems;
                _selectedChange = false;
            }
        }
        
        /**  
         * Setting this property deselects the currently selected 
         *  items and selects the newly specified items.
         */
        public function set selectedItems(value:Vector.<Object>):void
        {
            if(value != _selectedItems)
            {
                _selectedItems = value;
                
                _selectedChange = true;
                
                invalidateProperties();
            }
        }
        
        /**
         *  A Vector of Objects representing the currently selected data items. 
         */
        public function get selectedItems():Vector.<Object>
        {
            return listDisplay.selectedItems;
        }
    }
}