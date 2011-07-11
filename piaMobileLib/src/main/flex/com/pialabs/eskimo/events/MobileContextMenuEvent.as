package com.pialabs.eskimo.events
{
  import flash.events.Event;
  
  /**
   * Event for MobileContextMenu
   */
  public class MobileContextMenuEvent extends Event
  {
    /**
     * Menu item Clicked
     */
    public static const MENU_ITEM_CLICKED:String = "menuItemClicked";
    
    /**
     * itemClicked
     */
    public var menuItem:Object;
    
    /**
     * @Constructor
     */
    public function MobileContextMenuEvent(type:String, menuItem:Object, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      this.menuItem = menuItem;
      super(type, bubbles, cancelable);
    }
  }
}