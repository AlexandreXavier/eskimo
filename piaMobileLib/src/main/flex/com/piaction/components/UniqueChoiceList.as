package com.piaction.components
{
  import com.piaction.skins.android.UniqueChoiceItemRenderer;
  
  import flash.events.Event;
  import flash.system.Capabilities;
  
  import mx.collections.IList;
  import mx.core.ClassFactory;
  import mx.core.IVisualElement;
  
  import spark.components.Group;
  import spark.components.List;
  import spark.components.RadioButtonGroup;
  import spark.events.IndexChangeEvent;
  import spark.layouts.BasicLayout;
  import spark.layouts.supportClasses.LayoutBase;
  
  /**
   * Selected index changed
   */
  [Event(name="change", type="spark.events.IndexChangeEvent")]
  
  /**
   * Component that switch between ListWheel and list of radioButton item
   */
  public class UniqueChoiceList extends Group
  {
    /**
     * @private
     */
    protected var list:List;
    
    /**
     * @private
     */
    protected var _dataProvider:IList;
    
    /**
     * @private
     */
    private var _dataProviderChange:Boolean;
    
    /**
     * @private
     */
    protected var _labelField:String;
    
    /**
     * @private
     */
    protected var _layout:LayoutBase;
    
    /**
     * @private
     */
    private var _layoutChange:Boolean;
    
    /**
     * @private
     */
    public function UniqueChoiceList()
    {
      super();
      
      super.layout = new BasicLayout();
    }
    
    /**
     * @private
     */
    public function get labelField():String
    {
      return _labelField;
    }
    
    /**
     * @private
     */
    public function set labelField(value:String):void
    {
      _labelField = value;
    }
    
    /**
     * @private
     */
    public function set dataProvider( value:IList ):void
    {
      if(value != _dataProvider)
      {
        _dataProvider = value ;
        
        _dataProviderChange = true;
        
        invalidateProperties();
      }
    }
    
    /**
     * @private
     */
    public function get dataProvider():IList
    {
      return _dataProvider;
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      super.createChildren();
      
      if(list == null)
      {
        if (Capabilities.version.substr(0,3) == "AND")
        {
          list = new List();
          list.itemRenderer = new ClassFactory(UniqueChoiceItemRenderer);
          list.setStyle("verticalScrollPolicy", "off");
        }
        else
        {
          list = new ListWheel();
        }
        
        list.percentWidth = 100;
        list.percentHeight = 100;
        
        list.addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
        
        addElement(list);
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if(_dataProviderChange)
      {
        list.dataProvider = dataProvider;
        _dataProviderChange = false;
      }
      
      if(list.selectedIndex == -1)
      {
        list.selectedIndex = -1;
      }
      
      if(_layoutChange)
      {
        if(!(list is ListWheel))
          list.layout = _layout;
        _layoutChange = false;
      }
      
      list.labelField = labelField;
      
    }
    
    /**
     * @private
     */
    protected function onIndexChange(event:IndexChangeEvent):void
    {
      var evt:Event = event.clone();
      
      dispatchEvent(evt);
    }
    
    /**
     * @private
     */
    public function set selectedItem(value:Object):void
    {
      list.selectedItem = value;  
    }
    
    /**
     * @private
     */
    public function get selecteditem():Object
    {
      return list.selectedItem;
    }
    
    /**
     * @private
     */
    override public function set layout(value:LayoutBase):void
    {
      _layout = value;
      
      _layoutChange = true;
      
      invalidateProperties();
    }
    
    /**
     * @private
     */
    override public function get layout():LayoutBase
    {
      return _layout;
    }
  }
}