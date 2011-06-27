package com.piaction.components
{
    import com.piaction.events.DeletableListEvent;
    
    import flash.events.Event;
    
    import mx.core.ClassFactory;
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    import mx.events.StateChangeEvent;
    import mx.states.State;
    
    import spark.components.List;
    
    /**
     * Dispatched when an item is deleted
     */
    [Event(name = "itemDeleted", type = "com.piaction.events.DeletableListEvent")]
    
    /**
     * List that can contain deletable itemrenderers
     */
    public class DeletableList extends List
    {
        /**
         * Normal State const
         */
        protected static const NORMAL_STATE:String = "normal";
        /**
         * Edition State const
         */
        protected static const EDITION_STATE:String = "edition";
        
        /**
         * @private
         */
        protected var _editionMode:Boolean;
        
        /**
         * @private
         */
        private var _invalidateItemRendererState:Boolean;
        
        /**
         * @private
         */
        public function DeletableList()
        {
            super();
            
            itemRenderer = new ClassFactory(DeletableItemRenderer);
            
            addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCurrentStateChange);
        }
        
        /**
         * @private
         */
        public function invalidateItemRendererState():void
        {
            _invalidateItemRendererState = true;
            invalidateProperties();
        }
        
        /**
         * @private
         */
        override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
        {
            super.updateRenderer(renderer, itemIndex, data);
            
            if (currentState && renderer is DeletableItemRenderer)
            {
                (renderer as DeletableItemRenderer).currentState = currentState;
            }
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (_invalidateItemRendererState && dataGroup)
            {
                for (var i:int = 0; i < dataGroup.numElements; i++)
                {
                    var itemRenderer:IVisualElement = useVirtualLayout ? dataGroup.getVirtualElementAt(i) : dataGroup.getElementAt(i);
                    if (itemRenderer != null)
                    {
                        if (_editionMode)
                        {
                            (itemRenderer as UIComponent).currentState = EDITION_STATE;
                        }
                        else
                        {
                            (itemRenderer as UIComponent).currentState = NORMAL_STATE;
                        }
                    }
                }
                _invalidateItemRendererState = false;
            }
        
        }
        
        /**
         * @private
         */
        private function onCurrentStateChange(event:Event):void
        {
            invalidateItemRendererState();
        }
        
        /**
         * Modify the delete button label
         */
        public static function set deleteLabel(value:String):void
        {
            DeletableItemRenderer.deleteLabel = value;
        }
        
        /**
         * Switch into edition mode
         */
        public function set editionMode(value:Boolean):void
        {
            _editionMode = value;
            _invalidateItemRendererState = true;
            
            invalidateProperties();
        }
        
        /**
         * @private
         */
        public function get editionMode():Boolean
        {
            return _editionMode;
        }
    }


}
