package com.piaction.components
{
    import flash.events.MouseEvent;
    
    import mx.collections.IList;
    import mx.managers.PopUpManager;
    
    import spark.components.Label;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;
    
    public class ComboBox extends SkinnableComponent
    {
        public function ComboBox()
        {
            super();
            this.labelField = "label";
            this.addEventListener(MouseEvent.CLICK, popUpList);
        }
        
        [SkinPart(required = "true")]
        public var selectedLabel:Label;
        
        private var _dataProvider:IList;
        
        private var _labelField:String;
        
        private var popUp:UniqueChoiceList = new UniqueChoiceList();
        
        /**
         * LabelField of the list
         */
        public function get labelField():String
        {
            return _labelField;
        }
        
        public function set labelField(value:String):void
        {
            _labelField = value;
        }
        
        public function set dataProvider(value:IList):void
        {
            if (value != _dataProvider)
            {
                _dataProvider = value;
                invalidateProperties();
            }
        }
        
        public function get dataProvider():IList
        {
            return _dataProvider;
        }
        
        public function popUpList(event:MouseEvent):void
        {
            popUp.dataProvider = dataProvider;
            popUp.addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
            popUp.labelField = labelField;
            popUp.width = stage.stageWidth * 0.9;
            PopUpManager.centerPopUp(popUp);
            PopUpManager.addPopUp(popUp, this);
        }
        
        protected function onIndexChange(event:IndexChangeEvent):void
        {
            var selecteditem:Object = popUp.selectedItem;
            if (selecteditem != null && selecteditem.hasOwnProperty(labelField))
            {
                selectedLabel.text = selecteditem[labelField];
            }
            PopUpManager.removePopUp(popUp);
        }
        
        public function get selectedItem():Object
        {
            return popUp.selectedItem;
        }
    }
}
