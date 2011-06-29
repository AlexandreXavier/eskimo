package com.piaction.tool
{
  
  /**
  * Object use to check the properties in the tests case.
  */
  public final class PropertyData
  {
    private var _propertyName:String;
    private var _propertyValue:Object;
    
    /**
    * Constructor
    */
    public function PropertyData(propertyName:String, propertyValue:Object)
    {
      _propertyName = propertyName;
      _propertyValue = propertyValue;
    }
    
    /**
    * The value of the property
    */
    public function get propertyValue():Object
    {
      return _propertyValue;
    }
    
    /**
    * @private
    */
    public function set propertyValue(value:Object):void
    {
      _propertyValue = value;
    }
    
    /**
    * The name of the property
    */
    public function get propertyName():String
    {
      return _propertyName;
    }
    
    /**
    * @private
    */
    public function set propertyName(value:String):void
    {
      _propertyName = value;
    }
  
  }
}
