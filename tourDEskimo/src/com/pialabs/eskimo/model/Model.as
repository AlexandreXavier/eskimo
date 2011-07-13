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
    
    public static const IOS:String = "IOS";
    public static const ANDROID:String = "ANDROID";
    public static const OS_STYLES:ArrayCollection = new ArrayCollection([IOS, ANDROID]);
    
    
    public function Model()
    {
      samples = new Samples();
      currentItem = samples;
    }
    
    public function findParent(item:Sample):Category
    {
      return getParentOf(item, samples);
    }
    
    /**
    * Create a basic list of name
    */
    public static function createPersonList():ArrayCollection
    {
      return new ArrayCollection(["Jean Dupont", "John Doe", "Mike Smith", "Jing Ming", "Esteban Garcia"
                                  , "Eva Shlinberg"]);
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
