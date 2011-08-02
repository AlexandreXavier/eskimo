package com.pialabs.eskimo.components
{
  import com.pialabs.eskimo.events.DeletableListEvent;
  
  import flash.display.FrameLabel;
  import flash.events.Event;
  
  import mx.events.FlexEvent;
  import mx.states.AddChild;
  import mx.states.State;
  
  import spark.components.IconItemRenderer;
  
  /**
   * ChromeColor of the delete button.
   * @default 0xCC2A27
   */
  [Style(name = "deleteButtonChromeColor", inherit = "yes", type = "uint")]
  /**
   * Text color of the delete button
   * @default 0xFFFFFF
   */
  [Style(name = "deleteButtonColor", inherit = "yes", type = "uint")]
  /**
   * Width of the delete button.
   * @default NaN
   */
  [Style(name = "deleteButtonWidth", inherit = "yes", type = "Number")]
  /**
   * Height of the delete button.
   * @default NaN
   */
  [Style(name = "deleteButtonHeight", inherit = "yes", type = "Number")]
  /**
   * height of the delete button.
   * @default 0xCC2A27
   */
  [Style(name = "editIcon", inherit = "yes", type = "Class")]
  /**
   * Edit button icon width
   * @default 27 px
   */
  [Style(name = "editIconWidth", inherit = "yes", type = "Number")]
  /**
   * Width of the edit icon.
   * @default 27 px
   */
  [Style(name = "editIconHeight", inherit = "yes", type = "Number")]
  
  /**
   * Default itemRenderer of the DeletableList.
   * the component has two states : "normal" and "edition"
   *
   * In "edition" state, DeletableItemrenderer use DeletableItemRendererOverlay component to show the edit and delete button.
   * @see com.pialabs.eskimo.components.DeletableList
   * @see com.pialabs.eskimo.components.DeletableItemRendererOverlay
   */
  public class DeletableItemRenderer extends IconItemRenderer
  {
    /**
     * @private
     */
    private var _deleteOverlay:DeletableItemRendererOverlay;
    
    /**
     * @private
     * Label of the delete buttons.
     */
    protected static var _deleteLabel:String = "Delete";
    
    /**
     * @Constructor
     */
    public function DeletableItemRenderer()
    {
      super();
      
      states = [new State({name: "normal"}), new State({name: "edition"}), new State({name: "confirmation"})]
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      super.createChildren();
    
    }
    
    /**
     * @private
     */
    protected function onDelete(event:Event):void
    {
      var parentList:DeletableList = owner as DeletableList;
      
      var e:DeletableListEvent = new DeletableListEvent(DeletableListEvent.ITEM_DELETED, false, false, mouseX, mouseY, this, false, false, false, true, 0, itemIndex, data, this);
      parentList.dispatchEvent(e);
      
      var itemIndex:int = parentList.dataProvider.getItemIndex(data);
      
      if (itemIndex != -1)
      {
        parentList.dataProvider.removeItemAt(itemIndex);
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      maxWidth = unscaledWidth;
      
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if (_deleteOverlay)
      {
        _deleteOverlay.width = unscaledWidth;
        _deleteOverlay.height = unscaledHeight;
      }
    
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_deleteOverlay)
      {
        _deleteOverlay.deleteLabel = _deleteLabel;
      }
    }
    
    /**
     * @private
     */
    override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
    {
      super.stateChanged(oldState, newState, recursive);
      
      if (newState == "edition")
      {
        if (!_deleteOverlay)
        {
          _deleteOverlay = new DeletableItemRendererOverlay();
        }
        
        _deleteOverlay.addEventListener("delete", onDelete, false, 0, true);
        _deleteOverlay.deleteLabel = _deleteLabel;
        addChild(_deleteOverlay);
        if (initialized)
        {
          _deleteOverlay.addEventListener(FlexEvent.CREATION_COMPLETE, onOverlayAdded);
          return;
        }
      }
      if (newState == "normal")
      {
        if (_deleteOverlay)
        {
          _deleteOverlay.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
        }
      }
      if (_deleteOverlay)
      {
        _deleteOverlay.currentState = newState;
      }
    }
    
    /**
     * @private
     */
    private function stateChangeComplete_handler(event:Event):void
    {
      // We get called directly with null if there's no skin to listen to.
      if (event)
      {
        event.target.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeComplete_handler);
      }
      
      if (_deleteOverlay && _deleteOverlay.parent)
      {
        removeChild(_deleteOverlay);
      }
      _deleteOverlay = null
    }
    
    /**
     * @private
     */
    private function onOverlayAdded(event:Event):void
    {
      _deleteOverlay.currentState = currentState;
    }
    
    /**
     * Label of the delete buttons.
     */
    public static function set deleteLabel(value:String):void
    {
      _deleteLabel = value;
    }
  
  }
}
