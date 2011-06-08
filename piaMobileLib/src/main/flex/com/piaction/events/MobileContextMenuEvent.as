package com.piaction.events
{
  import flash.events.Event;
  
  public class MobileContextMenuEvent extends Event
  {
    public static const MENU_ITEM_CLICKED:String = "menuItemClicked";
    
    public var menuItem:Object;
    
    public function MobileContextMenuEvent(type:String, menuItem:Object, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      this.menuItem = menuItem;
      super(type, bubbles, cancelable);
    }
  }
}