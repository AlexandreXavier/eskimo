package com.piaction.components
{
    import com.piaction.events.MobileContextMenuEvent;
    import com.piaction.skins.android.MobileContextMenuSkin;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import mx.collections.ArrayCollection;
    import mx.core.FlexGlobals;
    import mx.managers.PopUpManager;
    import mx.managers.PopUpManagerChildList;
    import mx.styles.CSSStyleDeclaration;
    
    import spark.components.Label;
    import spark.components.List;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;
    
    /**
     * Item clicked
     */
    [Event(name = "menuItemClicked", type = "com.piaction.events.MobileContextMenuEvent")]
    
    /**
     * Cancel event, ContextMenu closed without selecting an item
     */
    [Event(name = "cancel", type = "flash.events.Event")]
    
    /**
     * header height
     */
    [Style(name = "headerHeight", inherit = "no", type = "Number")]
    
    /**
     * Context menu icon
     */
    [Style(name = "contextMenuIcon", inherit = "no", type = "Class")]
    
    /**
     * Header visible
     */
    [Style(name = "headerVisible", inherit = "no", type = "Boolean")]
    
    /**
     * Android like mobile context menu
     */
    public class MobileContextMenu extends SkinnableComponent
    {
        /**
         * @private
         */
        [SkinPart]
        public var listDisplay:List;
        
        /**
         * @private
         */
        [SkinPart(required = "false")]
        public var headerDisplay:Label;
        
        /**
         * @private
         */
        private var _menuItems:Array;
        /**
         * @private
         */
        private var _headerLabel:String;
        
        /**
         * @private
         */
        [Embed(source = 'com/piaction/assets/img/contextMenuIcon.png')]
        private static var defaultIcon:Class;
        
        /**
         * @private
         */
        private static var classConstructed:Boolean = classConstruct();
        
        /**
         * @private
         */
        protected static function classConstruct():Boolean
        {
            var styles:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.piaction.components.MobileContextMenu");
            if (!styles)
            {
                styles = new CSSStyleDeclaration();
            }
            
            styles.defaultFactory = function():void
            {
                this.skinClass = MobileContextMenuSkin;
                this.headerHeight = 50;
                this.contextMenuIcon = defaultIcon;
                this.headerVisible = true;
            }
            
            FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.piaction.components.MobileContextMenu", styles, false);
            
            
            return true;
        }
        
        /**
         * @constructor
         */
        public function MobileContextMenu()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
            addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, true);
        }
        
        private function onAddedToStage(event:Event):void
        {
            systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
        }
        
        /**
         * @private
         */
        private function removeFromStage(event:Event):void
        {
            systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }
        
        /**
         * @private
         */
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == listDisplay)
            {
                listDisplay.dataProvider = new ArrayCollection(_menuItems);
                listDisplay.addEventListener(IndexChangeEvent.CHANGE, onIndexChange, false, 0, true);
            }
            else if (instance == headerDisplay)
            {
                headerDisplay.text = _headerLabel;
            }
        }
        
        /**
         * @private
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            PopUpManager.centerPopUp(this);
        }
        
        /**
         * @private
         */
        protected function onIndexChange(event:IndexChangeEvent):void
        {
            var evt:MobileContextMenuEvent = new MobileContextMenuEvent(MobileContextMenuEvent.MENU_ITEM_CLICKED, _menuItems[event.newIndex]);
            
            dispatchEvent(evt);
            
            PopUpManager.removePopUp(this);
        }
        
        /**
         * Show an android like mobile context menu
         */
        public static function show(menuItems:Array, headerLabel:String = "", parent:DisplayObject = null, modal:Boolean = true, childList:String = null):MobileContextMenu
        {
            var menu:MobileContextMenu = PopUpManager.createPopUp(parent, MobileContextMenu, true, childList) as MobileContextMenu;
            
            
            menu.menuItems = menuItems;
            menu.headerLabel = headerLabel;
            
            return menu;
        }
        
        /**
         * @private
         */
        protected function onKeyDown(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.BACK)
            {
                PopUpManager.removePopUp(this);
                event.preventDefault();
                dispatchEvent(new Event(Event.CANCEL));
            }
        }
        
        /**
         * @private
         */
        public function get menuItems():Array
        {
            return _menuItems;
        }
        
        /**
         * @private
         */
        public function set menuItems(value:Array):void
        {
            _menuItems = value;
            if (listDisplay)
            {
                listDisplay.dataProvider = new ArrayCollection(_menuItems);
            }
            
            invalidateDisplayList();
        }
        
        /**
         * @private
         */
        public function get headerLabel():String
        {
            return _headerLabel;
        }
        
        /**
         * @private
         */
        public function set headerLabel(value:String):void
        {
            _headerLabel = value;
            if (headerDisplay)
            {
                headerDisplay.text = _headerLabel;
            }
            
            invalidateDisplayList();
        }
    
    }
}