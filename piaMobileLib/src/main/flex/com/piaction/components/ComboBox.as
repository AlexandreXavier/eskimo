package com.piaction.components
{
    import flash.events.MouseEvent;
    
    import mx.collections.IList;
    import mx.controls.listClasses.ListBase;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import spark.components.Label;
    import spark.components.supportClasses.Skin;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;
    
    /**
     * Skinclass of popup
     */
    [Style(name = "popupSkinClass", inherit = "no", type = "Class")]
    
    /**
     * The ComboBox control lets the user make a single choice within a set of mutually exclusive choices.
     */
    public class ComboBox extends SkinnableComponent
    {
        public function ComboBox()
        {
            super();ListBase
            this.addEventListener(MouseEvent.CLICK, popUpList);
        }
        
        [SkinPart(required = "true")]
        public var selectedLabel:Label;
        
        private var _dataProvider:IList;
        
        private var _labelField:String = "label";
        
        private var popUp:UniqueChoiceList = new UniqueChoiceList();
        
        /**
         *  The name of the field in the data provider items to display 
         *  as the label. 
         * 
         *  If labelField is set to an empty string (""), no field will 
         *  be considered on the data provider to represent label.
         *
         *  @default "label" 
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
            var popupSkinClass:Object = getStyle("popupSkinClass");
            if(popupSkinClass != null)
            {
              popUp.setStyle("skinClass", popupSkinClass);
            }
            popUp.dataProvider = dataProvider;
            popUp.addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
            popUp.labelField = labelField;
            popUp.width = stage.stageWidth * 0.6;
            // center popup
            popUp.x = stage.stageWidth * 0.04;
            PopUpManager.addPopUp(popUp, this);
            popUp.y = stage.stageHeight / 2 - popUp.height;
        }
        
        protected function onIndexChange(event:IndexChangeEvent):void
        {
            var selecteditem:Object = popUp.selectedItem;
            if (selecteditem != null && selecteditem.hasOwnProperty(labelField))
            {
                selectedLabel.text = selecteditem[labelField];
            }
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            PopUpManager.removePopUp(popUp);
        }
        
        public function get selectedItem():Object
        {
            return popUp.selectedItem;
        }
    }
}
