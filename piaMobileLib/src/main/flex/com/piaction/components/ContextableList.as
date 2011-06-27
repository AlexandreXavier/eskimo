package com.piaction.components
{
    import com.piaction.events.ContextableListEvent;
    import com.piaction.events.MobileContextMenuEvent;
    
    import flash.display.DisplayObject;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
    import mx.collections.ArrayCollection;
    import mx.core.FlexGlobals;
    import mx.core.mx_internal;
    import mx.managers.PopUpManager;
    import mx.managers.PopUpManagerChildList;
    import mx.styles.CSSStyleDeclaration;
    
    import spark.components.IItemRenderer;
    import spark.components.List;
    import spark.components.supportClasses.ItemRenderer;
    import spark.events.IndexChangeEvent;
    import spark.filters.DropShadowFilter;
    import spark.filters.GlowFilter;
    import spark.layouts.VerticalLayout;
    import spark.layouts.supportClasses.LayoutBase;
    
    use namespace mx_internal;
    
    /**
     * Item long press event
     */
    [Event(name = "itemLongPress", type = "com.piaction.events.ContextableListEvent")]
    
    /**
     * Context menu item click event
     */
    [Event(name = "contextMenuItemClick", type = "com.piaction.events.ContextableListEvent")]
    
    /**
     * List that enable long click and a menu on Item
     */
    public class ContextableList extends List
    {
        public static const TIME_CLICK:Number = 700;

        /**
         * @private
         */
        private var _timer:Timer = new Timer(TIME_CLICK, 1);
        /**
         * @private
         */
        private var _contextMenuItems:Array;
        /**
         * @private
         */
        protected var _contextList:MobileContextMenu;
        /**
         * @private
         */
        protected var _mouseDownPoint:Point;
        
        /**
         * @private
         */
        protected var _contextIndex:int;
        /**
         * @private
         */
        protected var _contextRenderer:IItemRenderer;
        /**
         * @private
         */
        protected var _contextData:Object;
        
        
        
        /**
         * Constructor
         */
        public function ContextableList()
        {
            super();
        
        }
        
        /**
         * @private
         */
        override protected function item_mouseDownHandler(event:MouseEvent):void
        {
            super.item_mouseDownHandler(event);
            
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
            _timer.start();
            
            
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
            
            _mouseDownPoint = event.target.localToGlobal(new Point(event.localX, event.localY));
        }
        
        /**
         * @private
         */
        override protected function mouseUpHandler(event:Event):void
        {
            super.mouseUpHandler(event);
            
            _mouseDownPoint = null
            
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            _timer.stop();
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        /**
         * @private
         */
        protected function onMouseMove(event:MouseEvent):void
        {
            if (!_mouseDownPoint)
            {
                return;
            }
            
            var pt:Point = new Point(event.localX, event.localY);
            pt = event.target.localToGlobal(pt);
            
            const DRAG_THRESHOLD:int = 20;
            
            if (Math.abs(_mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(_mouseDownPoint.y - pt.y) > DRAG_THRESHOLD)
            {
                _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
                _timer.stop();
                systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            }
        
        }
        
        /**
         * @private
         */
        private function onTimerComplete(event:TimerEvent):void
        {
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            
            if (mouseDownIndex == -1)
            {
                return;
            }
            
            _contextIndex = mouseDownIndex;
            _contextData = dataProvider.getItemAt(mouseDownIndex);
            _contextRenderer = dataGroup.getElementAt(mouseDownIndex) as IItemRenderer;
            
            dispatchEvent(new ContextableListEvent(ContextableListEvent.ITEM_LONG_PRESS, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer));
            
            if (_contextMenuItems)
            {
                showContextMenu();
            }
        }
        
        /**
         * Context menu items
         */
        public function get contextMenuItems():Array
        {
            return _contextMenuItems;
        }
        
        /**
         * @private
         */
        protected function showContextMenu():void
        {
            selectedIndex = _contextIndex;
            
            _contextList = MobileContextMenu.show(_contextMenuItems, _contextRenderer.label, this, true, "parent");
            
            _contextList.addEventListener(MobileContextMenuEvent.MENU_ITEM_CLICKED, onMobileContextMenuClicked, false, 0, true);
            _contextList.addEventListener(Event.CANCEL, onMobileContextMenuCanceled, false, 0, true);
            
            _contextList.width = unscaledWidth * 0.90;
            _contextList.maxHeight = unscaledHeight * 0.90;
        }
        
        /**
         * @private
         */
        protected function onMobileContextMenuClicked(event:MobileContextMenuEvent):void
        {
            var evt:ContextableListEvent = new ContextableListEvent(ContextableListEvent.CONTEX_MENU_ITEM_CLICK, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer, event.menuItem);
            
            selectedIndex = -1;
            
            dispatchEvent(evt);
        }
        
        protected function onMobileContextMenuCanceled(event:Event):void
        {
            selectedIndex = -1;
        }
        
        
        /**
         * @private
         */
        public function set contextMenuItems(value:Array):void
        {
            _contextMenuItems = value;
        }
    }
}
