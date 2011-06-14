package com.piaction.components
{
  import com.piaction.skins.ios.MobileCheckBoxSkin;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.system.Capabilities;
  
  import mx.core.FlexGlobals;
  import mx.styles.CSSStyleDeclaration;
  
  import spark.components.CheckBox;
  import spark.components.Group;
  import spark.primitives.Rect;
  import spark.skins.spark.CheckBoxSkin;
  
  [SkinState("draggedAndSelected")]
  [SkinState("dragged")]
  
  /**
   * Check box that enable switch between android checkbox and ios switch
   */
  public class MobileCheckBox extends CheckBox
  {
    /**
     *  @private
     */
    [SkinPart(required="false")]
    public var cursorGroup:Group;
    /**
     *  @private
     */
    [SkinPart(required="false")]
    public var buttonGroup:Group;
    /**
     *  @private
     */
    public var cursorPosition:Number;
    /**
     *  @private
     */
    protected var cursorDragged:Boolean;
    /**
     *  @private
     */
    protected var dragOffset:int;
    protected var dragInitialX:int;
    /**
     *  @private
     */
    protected var DRAG_THRESHOLD:int = 5;
    
    /**
     * Constructor
     */
    public function MobileCheckBox()
    {
      super();
    }
    
    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if(instance == cursorGroup)
      {
        addEventListener(MouseEvent.MOUSE_DOWN, onCursorDown, false, 0, true);
      }
    }
    
    /**
     *  @private
     */
    protected function onCursorDown(event:MouseEvent):void
    {
      if(cursorGroup)
      {
        systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        
        dragOffset = cursorGroup.mouseX;
        
        dragInitialX = mouseX;
      }
    }
    
    /**
     *  @private
     */
    protected function onMouseMove(event:MouseEvent):void
    {
      var delta:int = Math.abs(dragInitialX - mouseX);
      
      if(!cursorDragged && delta > DRAG_THRESHOLD){
        systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, onStageUp, false, 0, true);
        cursorDragged = true;
        invalidateSkinState();
      }
      
      if(cursorDragged)
      {
        var point:Point = new Point(event.localX, event.localY);
        point = event.target.localToGlobal(point);
        point = buttonGroup.globalToLocal(point);
        
        var cursorX:int = point.x - dragOffset;
        cursorX = Math.min(cursorX, buttonGroup.width - cursorGroup.width);
        cursorX = Math.max(cursorX, 0);
        cursorGroup.x = cursorX;
      }
    }
    
    /**
     *  @private
     */
    override protected function buttonReleased():void
    {
      if(!cursorDragged){
        selected = !selected;
      }
      
      finishDrag();
      
      dispatchEvent(new Event(Event.CHANGE));
    }
    
    /**
     *  @private
     */
    private function onStageUp(event:MouseEvent):void
    {
      finishDrag();
      
    }
    /**
     *  @private
     */
    protected function finishDrag():void
    {
      systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      
      systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
      
      if(cursorDragged)
      {
        if(cursorGroup.x + cursorGroup.width/2 < buttonGroup.width/2)
        {
          selected = false;
        }
        else
        {
          selected = true;
        }
        
        dispatchEvent(new Event(Event.CHANGE));
      }
      
      cursorDragged = false;
      
      invalidateSkinState();
    }
    
    /**
     *  @private
     */
    override protected function getCurrentSkinState():String
    {
      if (!enabled)
        return "disabled";
      
      var state:String;
      
      if(cursorDragged)
        state = "dragged";  
      else
        state = "up";
      
      if (!selected)
        return state;
      else
        return state + "AndSelected";
    }
  }
}