package com.pialabs.eskimo.components.maps
{
  import flash.events.Event;
  
  /**
  * Event dispatch by GMap component
  */
  public class GMapEvent extends Event
  {
    public static const MARKER_CLICKED:String = "markerClicked";
    public static const BOUNNDS_CHANGED:String = "boundsChanged";
    
    public var lat:Number;
    public var lng:Number;
    public var zoom:Number;
    
    public function GMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
      super(type, bubbles, cancelable);
    }
  }
}
