package com.pialabs.eskimo.events
{
  import flash.display.InteractiveObject;
  
  import spark.components.IItemRenderer;
  import spark.events.ListEvent;
  
  public class DeletableListEvent extends ListEvent
  {
    public static const ITEM_DELETED:String = "itemDeleted";
    
    public function DeletableListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0, itemIndex:int=-1, item:Object=null, itemRenderer:IItemRenderer=null)
    {
      super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, itemIndex, item, itemRenderer);
    }
  }
}