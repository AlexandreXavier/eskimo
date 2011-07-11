package com.pialabs.eskimo.events
{
  import flash.display.InteractiveObject;
  
  import spark.components.IItemRenderer;
  import spark.events.ListEvent;
  
  /**
   * Events dispatch by ContextableList Component
   */
  public class ContextableListEvent extends ListEvent
  {
    /**
     * Long press Event
     */
    public static const ITEM_LONG_PRESS:String = "itemLongPress";
    
    /**
     * Context Menu clicked
     */
    public static const CONTEX_MENU_ITEM_CLICK:String = "contextMenuItemClick";
    
    /**
     * Menu item clicked
     */
    public var menuItem:Object;
    
    /**
     * Constructor
     */
    public function ContextableListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0, itemIndex:int=-1, item:Object=null, itemRenderer:IItemRenderer=null, menuItem:Object=null)
    {
      this.menuItem = menuItem;
      
      super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, itemIndex, item, itemRenderer);
    }
  }
}