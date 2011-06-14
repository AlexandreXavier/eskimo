package com.piaction.components
{
  import com.piaction.skins.android.UniqueChoiceListSkin;
  
  import flash.events.Event;
  
  import mx.collections.IList;
  import mx.core.FlexGlobals;
  import mx.styles.CSSStyleDeclaration;
  
  import spark.components.List;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.events.IndexChangeEvent;
  
  /**
   * Selected index changed
   */
  [Event(name="change", type="spark.events.IndexChangeEvent")]
  
  /**
   * Component that switch between ListWheel and list of radioButton item
   */
  public class UniqueChoiceList extends SkinnableComponent
  {
    /**
     * List Display Skin Part
     */
    [SkinPart(required="true")]
    public var listDisplay:List;
    
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
     * Constructor
     */
    public function UniqueChoiceList()
    {
      super();
    }
    
    /**
     * LabelField of the list
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
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if(instance == listDisplay)
      {
        listDisplay.addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
        listDisplay.labelField = labelField;
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
        listDisplay.dataProvider = dataProvider;
        _dataProviderChange = false;
      }
      
      if(listDisplay != null)  listDisplay.labelField = labelField;
      
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
     * The current selected item
     */
    public function set selectedItem(value:Object):void
    {
      listDisplay.selectedItem = value;  
    }
    
    /**
     * @private
     */
    public function get selecteditem():Object
    {
      return listDisplay.selectedItem;
    }
  }
}