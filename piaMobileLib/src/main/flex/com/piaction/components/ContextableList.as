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
  public class ContextableList extends List
  {
    private var _timer:Timer = new Timer(800, 1);
    private var _contextMenuItems:ArrayCollection;
    
    private var _contextList:List = new List();
    
    protected var _mouseDownPoint:Point;
    
    private var _contextListLayout:LayoutBase;
    
    protected var _contextIndex:int;
    protected var _contextRenderer:IItemRenderer;
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
    
    public function ContextableList()
    {
      super();
      
      _contextList.filters = [new GlowFilter(0, 1, 10, 10)];

      _contextListLayout = new VerticalLayout();
      
      (_contextListLayout as VerticalLayout).verticalAlign = "contentHeight";
      (_contextListLayout as VerticalLayout).horizontalAlign = "justify";
      (_contextListLayout as VerticalLayout).gap = 0;
      
      _contextList.layout = _contextListLayout;
      
      
    }

    override protected function item_mouseDownHandler(event:MouseEvent):void
    {
      super.item_mouseDownHandler(event);
      
      _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
      _timer.start();
      
      
      systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
      
      _mouseDownPoint = event.target.localToGlobal(new Point(event.localX, event.localY));
    }
    
    override protected function mouseUpHandler(event:Event):void
    {
      super.mouseUpHandler(event);
      
      _mouseDownPoint = null
      
      _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
      _timer.stop();
      systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }
    
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
    
    public function get contextMenuItems():ArrayCollection
    {
      return _contextMenuItems;
    }
    
    public function set contextMenuItems(value:ArrayCollection):void
    {
      _contextMenuItems = value;
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      _contextList.styleName = getStyle("contexListStyleName");
      _contextList.width = unscaledWidth * 0.80;
      _contextList.maxHeight = unscaledHeight * 0.80;
    }
    
    protected function onKeyDown(event:KeyboardEvent):void
    {
      if(event.keyCode == Keyboard.BACK)
      {
        hideContextMenu();
        event.preventDefault();
      }
    }
    
    protected function showContextMenu():void
    {
      _contextList.dataProvider = _contextMenuItems;
      PopUpManager.addPopUp(_contextList, this, true, PopUpManagerChildList.PARENT);
      PopUpManager.centerPopUp(_contextList);
      
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
      
      _contextList.addEventListener(IndexChangeEvent.CHANGE, onIndexChange, false, 0, true);
    }
    
    protected function hideContextMenu():void
    {
      PopUpManager.removePopUp(_contextList);
      removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      _contextList.removeEventListener(IndexChangeEvent.CHANGE, onIndexChange);
    }
    
    protected function onIndexChange(event:IndexChangeEvent):void
    {
      var evt:ContextableListEvent = new ContextableListEvent(ContextableListEvent.CONTEX_MENU_ITEM_CLICK, false, false, mouseX, mouseY, this, false, false, false, true, 0, _contextIndex, _contextData, _contextRenderer, _contextMenuItems.getItemAt(event.newIndex));
      
      dispatchEvent(evt);
      
      hideContextMenu();
    }
  }
}