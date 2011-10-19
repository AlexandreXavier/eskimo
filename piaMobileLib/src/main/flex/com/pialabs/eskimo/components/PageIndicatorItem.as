package com.pialabs.eskimo.components
{
  import spark.components.supportClasses.SkinnableComponent;
  
  
  [SkinState("normal")]
  [SkinState("selected")]
  
  /**
  * Item for PageIndicatorComponent
  */
  public class PageIndicatorItem extends SkinnableComponent
  {
    /**
    * @private
    */
    private var _selected:Boolean;
    /**
     * @private
     */
    private var _index:int;
    
    /**
     * @private
     */
    public function PageIndicatorItem()
    {
      super();
    }
    
    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
      return (_selected ? "selected" : "normal");
    }
    
    /**
     * @private
     */
    override protected function measure():void
    {
      super.measure();
      
      measuredWidth = 5;
      measuredHeight = 5;
    }
    
    /**
     * @private
     */
    public function get index():int
    {
      return _index;
    }
    
    /**
     * @private
     */
    public function set index(value:int):void
    {
      _index = value;
    }
    
    /**
     * @private
     */
    public function get selected():Boolean
    {
      return _selected;
    }
    
    /**
     * @private
     */
    public function set selected(value:Boolean):void
    {
      if (value != _selected)
      {
        _selected = value;
        
        invalidateSkinState();
        skin.invalidateDisplayList();
      }
    }
  }
}
