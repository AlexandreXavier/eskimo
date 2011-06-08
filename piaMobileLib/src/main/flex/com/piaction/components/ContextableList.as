package com.piaction.components
{
  import com.piaction.events.ContextableListEvent;
  
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
  
  [Event(name="itemLongPress", type="com.piaction.events.ContextableListEvent")]
  [Event(name="contextMenuItemClick", type="com.piaction.events.ContextableListEvent")]
  
  [Style(name="contexListStyleName", inherit="no", type="String")]
  
  /**
   * List that enable long click and a menu on Item
   */
  public class ContextableList extends List
  {
    /**
     * @private
     */
    private var _timer:Timer = new Timer(800, 1);
    /**
     * @private
     */
    private var _contextMenuItems:Array;
    /**
     * @private
     */
    protected var _contextList:List = new List();
    /**
     * @private
     */
    protected var _mouseDownPoint:Point;
    
    /**
     * @private
     */
    private var _contextListLayout:LayoutBase;
    
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
     * @private
     */
    private static var classConstructed:Boolean = classConstruct();
    
    /**
     * @private
     */
    protected static function classConstruct():Boolean
    {
      var styles:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("com.piaction.components.ContextableList");
      if(!styles)
      {
        styles = new CSSStyleDeclaration();
      }
      
      styles.defaultFactory = function():void
      {
        this.contexListStyleName =  "defaultContextListStyle";
      }
      
      FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("com.piaction.components.ContextableList", styles, false);
      
      styles = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration(".defaultContextListStyle");
      if(!styles)
      {
        styles = new CSSStyleDeclaration();
      }
      
      styles.defaultFactory = function():void
      {
        this.borderVisible =  true;
        this.borderColor = 0xAAAAAA;
      }
      
      FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration(".defaultContextListStyle", styles, false);
      return true;
    }
    
    /**
     * Constructor
     */
    public function ContextableList()
    {
      super();
      
      _contextList.filters = [new GlowFilter(0, 1, 15, 15)];
      
      _contextListLayout = new VerticalLayout();
      
      (_contextListLayout as VerticalLayout).verticalAlign = "contentHeight";
      (_contextListLayout as VerticalLayout).horizontalAlign = "justify";
      (_contextListLayout as VerticalLayout).gap = 0;
      
      _contextList.layout = _contextListLayout;
      
      
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
        return;
      
      var pt:Point = new Point(event.localX, event.localY);
      pt = event.target.localToGlobal(pt);
      
      const DRAG_THRESHOLD:int = 20;
      
      if (Math.abs(_mouseDownPoint.x - pt.x) > DRAG_THRESHOLD ||
        Math.abs(_mouseDownPoint.y - pt.y) > DRAG_THRESHOLD)
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
      
      if(mouseDownIndex == -1)
        return;
      
      _contextIndex = mouseDownIndex;
      _contextData = dataProvider.getItemAt(mouseDownIndex);
      _contextRenderer = dataGroup.getElementAt(mouseDownIndex) as IItemRenderer;
      
      dispatchEvent(new ContextableListEvent(ContextableListEvent.ITEM_LONG_PRESS, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer));
      
      if(_contextMenuItems) showContextMenu();
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
    protected function onKeyDown(event:KeyboardEvent):void
    {
      if(event.keyCode == Keyboard.BACK)
      {
        hideContextMenu();
        event.preventDefault();
      }
    }
    
    /**
     * @private
     */
    protected function showContextMenu():void
    {
      selectedIndex = _contextIndex;
      
      _contextList.dataProvider = new ArrayCollection(_contextMenuItems);
      PopUpManager.addPopUp(_contextList, this, true, PopUpManagerChildList.PARENT);
      PopUpManager.centerPopUp(_contextList);
      
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
      
      _contextList.addEventListener(IndexChangeEvent.CHANGE, onIndexChange, false, 0, true);
    }
    
    /**
     * @private
     */
    protected function hideContextMenu():void
    {
      PopUpManager.removePopUp(_contextList);
      removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      _contextList.removeEventListener(IndexChangeEvent.CHANGE, onIndexChange);
    }
    
    /**
     * @private
     */
    protected function onIndexChange(event:IndexChangeEvent):void
    {
      var evt:ContextableListEvent = new ContextableListEvent(ContextableListEvent.CONTEX_MENU_ITEM_CLICK, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer, _contextMenuItems[event.newIndex]);
      
      dispatchEvent(evt);
      
      hideContextMenu();
    }
    
    
    /**
     * @private
     */
    public function set contextMenuItems(value:Array):void
    {
      _contextMenuItems = value;
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      _contextList.styleName = getStyle("contexListStyleName");
      _contextList.width = unscaledWidth * 0.80;
      _contextList.maxHeight = unscaledHeight * 0.80;
    }
  }
}