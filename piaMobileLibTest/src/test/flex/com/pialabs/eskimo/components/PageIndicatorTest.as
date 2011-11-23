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
  import com.pialabs.eskimo.tool.PropertyData;
  import com.pialabs.eskimo.tool.TestHelper;
  
  import flexunit.framework.Assert;
  
  import mx.events.FlexEvent;
  
  import org.flexunit.async.Async;
  import org.fluint.sequence.SequenceCaller;
  import org.fluint.sequence.SequenceRunner;
  import org.fluint.sequence.SequenceSetter;
  import org.fluint.sequence.SequenceWaiter;
  import org.fluint.uiImpersonation.UIImpersonator;
  
  public class PageIndicatorTest
  {
    
    private var _pageIndicator:PageIndicator;
    
    [Before(ui)]
    public function setUp():void
    {
      _pageIndicator = new PageIndicator();
      UIImpersonator.addChild(_pageIndicator);
    }
    
    [After(ui)]
    public function tearDown():void
    {
      UIImpersonator.removeChild(_pageIndicator);
      _pageIndicator = null;
    }
    
    
    [Test(async)]
    public function testSetPageCountLesserThanSelectedIndex():void
    {
      var selectedIndexProperty:PropertyData = new PropertyData('selectedIndex', 2);
      
      var sequence:SequenceRunner = new SequenceRunner(this);
      sequence.addStep(new SequenceSetter(_pageIndicator, {pageCount: 4}));
      sequence.addStep(new SequenceSetter(_pageIndicator, {selectedIndex: 3}));
      sequence.addStep(new SequenceWaiter(_pageIndicator, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceSetter(_pageIndicator, {pageCount: 3}));
      sequence.addStep(new SequenceWaiter(_pageIndicator, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceCaller(_pageIndicator, TestHelper.handleVerifyProperty, [selectedIndexProperty
                                                                                            , _pageIndicator]));
      sequence.run();
    }
    
    [Test]
    public function testNext():void
    {
      // defaut case
      _pageIndicator.next();
      Assert.assertEquals(0, _pageIndicator.selectedIndex);
      // normal case
      _pageIndicator.pageCount = 2;
      Assert.assertEquals(0, _pageIndicator.selectedIndex);
      _pageIndicator.next();
      Assert.assertEquals(1, _pageIndicator.selectedIndex);
      // when the max is already selected
      _pageIndicator.next();
      Assert.assertEquals(1, _pageIndicator.selectedIndex);
    }
    
    [Test]
    public function testPrevious():void
    {
      // normal case
      _pageIndicator.pageCount = 2;
      _pageIndicator.selectedIndex = 1;
      _pageIndicator.previous();
      Assert.assertEquals(0, _pageIndicator.selectedIndex);
      // when the min is already selected
      _pageIndicator.previous();
      Assert.assertEquals(0, _pageIndicator.selectedIndex);
    }
    
    [Test]
    public function testPageCount():void
    {
      // page count to 0
      _pageIndicator.pageCount = 0;
      Assert.assertEquals(1, _pageIndicator.pageCount);
    }
    
    [Test(async)]
    public function testSelectedIndexIsGreaterThanPageCount():void
    {
      var selectedIndexProperty:PropertyData = new PropertyData('selectedIndex', 0);
      
      var sequence:SequenceRunner = new SequenceRunner(this);
      sequence.addStep(new SequenceSetter(_pageIndicator, {pageCount: 4}));
      sequence.addStep(new SequenceSetter(_pageIndicator, {selectedIndex: 5}));
      sequence.addStep(new SequenceWaiter(_pageIndicator, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceCaller(_pageIndicator, TestHelper.handleVerifyProperty, [selectedIndexProperty
                                                                                            , _pageIndicator]));
      sequence.run();
    }
  
  }
}
