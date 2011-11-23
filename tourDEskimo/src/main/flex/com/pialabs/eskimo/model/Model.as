/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.pialabs.eskimo.model
{
  import com.pialabs.eskimo.data.SectionTitleLabel;
  
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
    public static const QNX:String = "QNX";
    public static const OS_STYLES:ArrayCollection = new ArrayCollection([IOS, ANDROID, QNX]);
    
    
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
                                  , "Eva Shlinberg", "Cecilia Grant"]);
    }
    
    /**
    * Create a basic list of name
    */
    public static function createLongPersonList():ArrayCollection
    {
      return new ArrayCollection(["Jean Dupont", "John Doe", "Mike Smith", "Jing Ming", "Esteban Garcia"
                                  , "Eva Shlinberg", "Cecilia Grant", "Pat Bracken", "Phyllis Adams", "Rebecca Densmore"
                                  , "Richard Morton", "Donna Boone", "Elvin Baum", "Felicia Adams"]);
    }
    
    public static function createGroupPersonList():ArrayCollection
    {
      return new ArrayCollection([new SectionTitleLabel("J"), "Jean Dupont", "John Doe", "Jing Ming"
                                                        , new SectionTitleLabel("M"), "Mike Smith"
                                                        , new SectionTitleLabel("E"), "Esteban Garcia", "Eva Shlinberg"]);
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
