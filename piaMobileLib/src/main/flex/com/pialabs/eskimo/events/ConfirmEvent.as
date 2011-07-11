package com.pialabs.eskimo.events
{
  import flash.events.Event;
  
  /**
   * Event for ConfirmButton
   */
  public class ConfirmEvent extends Event
  {
    public static const ENTER_CONFIRMATION:String = "enterConfirmation";
    public static const CONFIRM:String = "confirm";
    public static const CANCEL:String = "cancel";
    
    
    /**
    * Constructor
    */
    public function ConfirmEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      //TODO: implement function
      super(type, bubbles, cancelable);
    }
  }
}