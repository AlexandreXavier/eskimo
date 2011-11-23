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
package com.pialabs.eskimo.components
{
  import flexunit.framework.Assert;
  
  import mx.collections.ArrayCollection;
  
  import org.hamcrest.object.nullValue;
  
  import spark.layouts.HorizontalLayout;
  import spark.layouts.supportClasses.LayoutBase;
  
  public class SlideDataGroupTest
  {
    private var _slideDataGroup:SlideDataGroup;
    private var _dp:ArrayCollection = new ArrayCollection([{source: "data/img/photo01.jpg"}
                                                            , {source: "data/img/photo02.jpg"}
                                                            , {source: "data/img/photo03.jpg"}]);
    
    [Before]
    public function setUp():void
    {
      _slideDataGroup = new SlideDataGroup();
    }
    
    [After]
    public function tearDown():void
    {
      _slideDataGroup = null;
    }
    
    [Test(description = "Check if the method set layout dispatch an error when the layout is not a SlideLayout", expects = "Error")]
    public function testSet_layout_error():void
    {
      _slideDataGroup.layout = new HorizontalLayout();
    }
    
    [Test]
    public function testNext():void
    {
      _slideDataGroup.dataProvider = _dp;
      Assert.assertEquals(0, _slideDataGroup.selectedIndex);
      _slideDataGroup.next();
      Assert.assertEquals(1, _slideDataGroup.selectedIndex);
    }
    
    [Test]
    public function testNextLast():void
    {
      _slideDataGroup.dataProvider = _dp;
      var lastIndex:int = _slideDataGroup.count - 1;
      _slideDataGroup.selectedIndex = lastIndex;
      Assert.assertEquals(lastIndex, _slideDataGroup.selectedIndex);
      _slideDataGroup.next();
      Assert.assertEquals(lastIndex, _slideDataGroup.selectedIndex);
    }
    
    [Test]
    public function testPreviousFirst():void
    {
      _slideDataGroup.dataProvider = _dp;
      Assert.assertEquals(0, _slideDataGroup.selectedIndex);
      _slideDataGroup.previous();
      Assert.assertEquals(0, _slideDataGroup.selectedIndex);
    }
    
    [Test]
    public function testPrevious():void
    {
      _slideDataGroup.dataProvider = _dp;
      var lastIndex:int = _slideDataGroup.count - 1;
      _slideDataGroup.selectedIndex = lastIndex;
      Assert.assertEquals(lastIndex, _slideDataGroup.selectedIndex);
      _slideDataGroup.previous();
      Assert.assertEquals(lastIndex - 1, _slideDataGroup.selectedIndex);
    }
  }
}
