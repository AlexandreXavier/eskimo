/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.pialabs.eskimo.components
{
    import flash.events.Event;
    
    import mx.collections.IList;
    
    import spark.components.List;
    import spark.components.SkinnableDataContainer;
    import spark.components.supportClasses.ListBase;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;
    
    /**
     *  Dispatched after the selection has changed.
     *  This event is dispatched when the user interacts with the control.
     */
    [Event(name = "change", type = "spark.events.IndexChangeEvent")]
    
    
    public class ChoiceList extends SkinnableComponent
    {
        public function ChoiceList()
        {
            super();
        }
        
        
        /**
         * list Display Skin Part
         */
        [SkinPart(required = "true")]
        public var listDisplay:ListBase;
        
        /**
         * @private
         */
        protected var _dataProvider:IList;
        
        /**
         * @private
         */
        protected var _dataProviderChange:Boolean;
        
        /**
         * @private
         */
        protected var _selectedChange:Boolean;
        
        /**
         * @private
         */
        protected var _labelField:String = "label";
        
        /**
         *  The name of the field in the data provider items to display
         *  as the label.
         *
         *  @default "label"
         */
        public function get labelField():String
        {
            return _labelField;
        }
        
        /**
         * @private
         */
        public function set labelField(value:String):void
        {
            _labelField = value;
            invalidateProperties();
        }
        
        /**
         * @private
         */
        public function set dataProvider(value:IList):void
        {
            if (value != _dataProvider)
            {
                _dataProvider = value;
                
                _dataProviderChange = true;
                
                invalidateProperties();
            }
        }
        
        /**
         *  List of choice
         */
        public function get dataProvider():IList
        {
            return _dataProvider;
        }
        
        /**
         * @private
         */
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == listDisplay)
            {
                listDisplay.addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
                listDisplay.labelField = labelField;
            }
        }
        
        /**
         * @private
         */
        protected function onIndexChange(event:IndexChangeEvent):void
        {
            var evt:Event = event.clone();
            
            dispatchEvent(evt);
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (listDisplay != null)
            {
              listDisplay.labelField = labelField;
            }
            
            if (_dataProviderChange)
            {
                listDisplay.dataProvider = dataProvider;
                _dataProviderChange = false;
            }
            
        }
    }
}
