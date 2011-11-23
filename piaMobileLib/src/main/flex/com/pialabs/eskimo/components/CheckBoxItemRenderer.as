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
