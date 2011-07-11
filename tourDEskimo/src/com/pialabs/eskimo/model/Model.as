package com.pialabs.eskimo.model
{
  import flash.system.Capabilities;
  
  import mx.collections.ArrayCollection;
  
  
  public class Model
  {
    private static var instance:Model;
    
    public static function getInstance():Model
    {
      if (instance == null)
      {
        instance = new Model();
      }
      
      return instance;
    }
    
    [Bindable]
    public var samples:Category;
    [Bindable]
    public var currentItem:Sample;
    [Bindable]
    public var osStyle:String;
    
    public static const IOS:String = "IOS";
    public static const ANDROID:String = "ANDROID";
    public static const OS_STYLES:ArrayCollection = new ArrayCollection([IOS, ANDROID]);
    
    
    public function Model()
    {
      samples = new Samples();
      currentItem = samples;
      if (Capabilities.version.indexOf("AND") == 0)
      {
        osStyle = ANDROID;
      }
      else
      {
        // if we are not on IOS or ANDROID we choose IOS
        osStyle = IOS;
      }
    }
    
    public function findParent(item:Sample):Category
    {
      return getParentOf(item, samples);
    }
    
    protected function getParentOf(item:Sample, searchNode:Category):Category
    {
      for each (var sample:Sample in searchNode.samples)
      {
        if (sample == item)
        {
          return searchNode;
        }
        else if (sample is Category)
        {
          var category:Category = getParentOf(item, sample as Category);
          if (category != null)
          {
            return category;
          }
        }
      }
      return null;
    }
  }
}
