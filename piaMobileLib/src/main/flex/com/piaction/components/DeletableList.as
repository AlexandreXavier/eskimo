package com.piaction.components
{
  import com.piaction.events.DeletableListEvent;
  import com.piaction.skins.ios.DeletableItemRenderer;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import mx.core.ClassFactory;
  import mx.core.IVisualElement;
  import mx.core.UIComponent;
  import mx.events.StateChangeEvent;
  import mx.states.State;
  
  import spark.components.List;
  
  /**
   * Dispatched when an item is deleted
   */
  [Event(name="itemDeleted", type="com.piaction.events.DeletableListEvent")]
  
  /**
   * List that can contain deletable itemrenderers
   */
  public class DeletableList extends List
  {
    /**
     * Normal State const
     */
    public static const NORMAL_STATE:String = "normal";
    /**
     * Edition State const
     */
    public static const EDITION_STATE:String = "edition";
    
    /**
     * @private
     */
    private var _invalidateItemRendererState:Boolean;
    
    /**
     * @private
     */
    public function DeletableList()
    {
      super();
      
      states = [new State({name:"normal"}),new State({name:"edition"})];
      
      itemRenderer = new ClassFactory(DeletableItemRenderer);
      
      addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCurrentStateChange);
    }
    
    /**
     * @private
     */
    public function invalidateItemRendererState():void
    {
      _invalidateItemRendererState = true;
      invalidateProperties();
    }
    
    /**
     * @private
     */
    override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
    {
      super.updateRenderer(renderer, itemIndex, data);
      
      if(currentState)
      {
        (renderer as DeletableItemRenderer).currentState = currentState;
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if(_invalidateItemRendererState)
      {
        for(var i:int=0; i<dataGroup.numElements; i++)
        {
          var itemRenderer:IVisualElement = useVirtualLayout ? dataGroup.getVirtualElementAt(i) : dataGroup.getElementAt(i);
          if(itemRenderer != null){
            (itemRenderer as UIComponent).currentState = currentState; 
          }
        }
        _invalidateItemRendererState = false;
      }
      
    }
    
    /**
     * @private
     */
    private function onCurrentStateChange(event:Event):void
    {
      invalidateItemRendererState();
    }
  }
  
  
}