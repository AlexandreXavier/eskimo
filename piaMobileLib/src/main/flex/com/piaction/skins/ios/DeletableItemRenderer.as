package com.piaction.skins.ios
{
    import com.piaction.components.DeletableList;
    import com.piaction.events.DeletableListEvent;
    
    import flash.display.FrameLabel;
    import flash.events.Event;
    
    import mx.events.FlexEvent;
    import mx.states.AddChild;
    import mx.states.State;
    
    import spark.components.IconItemRenderer;
    
    
    
    public class DeletableItemRenderer extends IconItemRenderer
    {
        private var _deleteOverlay:DeletableItemRendererOverlay;
        
        public function DeletableItemRenderer()
        {
            super();
            
            states = [new State({name: "normal"}), new State({name: "edition"}), new State({name: "confirmation"})]
        }
        
        override protected function createChildren():void
        {
            super.createChildren();
        
        }
        
        protected function onDelete(event:Event):void
        {
            var parentList:DeletableList = owner as DeletableList;
            
            var e:DeletableListEvent = new DeletableListEvent(DeletableListEvent.ITEM_DELETED, false, false, mouseX, mouseY, this, false, false, false, true, 0, itemIndex, data, this);
            parentList.dispatchEvent(e);
            
            parentList.dataProvider.removeItemAt(parentList.dataProvider.getItemIndex(data));
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            maxWidth = unscaledWidth;
            
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (_deleteOverlay)
            {
                _deleteOverlay.width = unscaledWidth;
                _deleteOverlay.height = unscaledHeight;
            }
        
        }
        
        override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
        {
            super.stateChanged(oldState, newState, recursive);
            
            if (newState == "edition")
            {
                if (!_deleteOverlay)
                {
                    _deleteOverlay = new DeletableItemRendererOverlay();
                    _deleteOverlay.addEventListener("delete", onDelete, false, 0, true);
                    _deleteOverlay.addEventListener(FlexEvent.CREATION_COMPLETE, onOverlayAdded);
                    addChild(_deleteOverlay);
                }
                return;
            }
            if (newState == "normal")
            {
                if (_deleteOverlay)
                {
                    _deleteOverlay.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
                }
            }
            if (_deleteOverlay)
            {
                _deleteOverlay.currentState = newState;
            }
        }
        
        private function stateChangeComplete_handler(event:Event):void
        {
            // We get called directly with null if there's no skin to listen to.
            if (event)
            {
                event.target.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
            }
            
            if (_deleteOverlay && _deleteOverlay.parent)
            {
                removeChild(_deleteOverlay);
            }
            _deleteOverlay = null
        }
        
        private function onOverlayAdded(event:Event):void
        {
            _deleteOverlay.currentState = currentState;
        }
    
    }
}
