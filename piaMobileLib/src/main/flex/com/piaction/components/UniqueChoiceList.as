package com.piaction.components
{
  import flash.events.Event;
  
  import mx.collections.IList;
  
  import spark.components.List;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.events.IndexChangeEvent;
  
  /**
   *  Dispatched after the selection has changed. 
   *  This event is dispatched when the user interacts with the control.
   */
  [Event(name="change", type="spark.events.IndexChangeEvent")]
  
  /**
   * Component that switch between ListWheel and list of radioButton item
   */
  public class UniqueChoiceList extends SkinnableComponent
  {
    /**
     * list Display Skin Part
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
    private var _selectedItem:Object;
    
    /**
     * @private
     */
    private var _selectedItemChange:Boolean;
    
    /**
     * @private
     */
    protected var _labelField:String = "label";
    
    /**
     * Constructor
     */
    public function UniqueChoiceList()
    {
      super();
    }
    
    /**
     *  The name of the field in the data provider items to display 
     *  as the label. 
     *
     *  @default "label" 
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
     *  Set of data to be viewed.
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
      
      if(_selectedItemChange)
      {
          listDisplay.selectedItem = _selectedItem;
          _selectedItemChange = false;
      }
      
      if(listDisplay != null)
      {
        listDisplay.labelField = labelField;
      }
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
     * Setting this property deselects the currently selected 
     *  item and selects the newly specified item.
     *
     *  <p>Setting <code>selectedItem</code> to an item that is not 
     *  in this component results in no selection, 
     *  and <code>selectedItem</code> being set to <code>undefined</code>.</p>
     */
    public function set selectedItem(value:Object):void
    {
        if(value != _selectedItem)
        {
            _selectedItem = value;
            
            _selectedItemChange = true;
            
            invalidateProperties();
        }
    }
    
    /**
     *  The item that is currently selected. 
     */
    public function get selectedItem():Object
    {
      return listDisplay.selectedItem;
    }
  }
}