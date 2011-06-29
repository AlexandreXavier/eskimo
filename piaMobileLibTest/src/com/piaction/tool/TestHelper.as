package com.piaction.tool
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import flexunit.framework.Assert;
  
  public class TestHelper
  {
    /**
    * Check if the specified property value matches with the value of the target.
    *
    * @param propertyData
    *           the object used to define the property name and value to check
    * @param target
    *           the object used to check the property
    */
    public static function handleVerifyProperty(propertyData:Object, target:Object):void
    {
      Assert.assertEquals(propertyData.propertyValue, target[propertyData.propertyName]);
    }
  
  }
}
