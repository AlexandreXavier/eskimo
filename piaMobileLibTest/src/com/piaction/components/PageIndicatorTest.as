package com.piaction.components
{
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
      var passThroughData:Object = new Object();
      passThroughData.propertyName = 'selectedIndex';
      passThroughData.propertyValue = 2;
      
      var sequence:SequenceRunner = new SequenceRunner(this);
      sequence.addStep(new SequenceSetter(_pageIndicator, {pageCount: 4}));
      sequence.addStep(new SequenceSetter(_pageIndicator, {selectedIndex: 3}));
      sequence.addStep(new SequenceWaiter(_pageIndicator, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceSetter(_pageIndicator, {pageCount: 3}));
      sequence.addStep(new SequenceWaiter(_pageIndicator, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceCaller(_pageIndicator, handleVerifyProperty, [passThroughData]));
      sequence.run();
    }
    
    protected function handleVerifyProperty(passThroughData:Object):void
    {
      Assert.assertEquals(passThroughData.propertyValue, _pageIndicator[passThroughData.propertyName]);
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
      
      // test on multiple pages
      _pageIndicator.selectedIndex = 0;
      _pageIndicator.pageCount = 6;
    }
    
    [Test]
    public function testPrevious():void
    {
      // default
      _pageIndicator.previous();
      Assert.assertEquals(PageIndicator.DEFAULT_INDEX, _pageIndicator.selectedIndex);
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
    
    [Test]
    public function testSelectedIndexIsNegatif():void
    {
      _pageIndicator.selectedIndex = -1;
      Assert.assertEquals(0, _pageIndicator.selectedIndex);
    
    }
    
    [Test(async)]
    public function testSelectedIndexIsGreaterThanPageCount():void
    {
      var passThroughData:Object = new Object();
      passThroughData.propertyName = 'selectedIndex';
      passThroughData.propertyValue = 0;
      
      var sequence:SequenceRunner = new SequenceRunner(this);
      sequence.addStep(new SequenceSetter(_pageIndicator, {pageCount: 4}));
      sequence.addStep(new SequenceSetter(_pageIndicator, {selectedIndex: 5}));
      sequence.addStep(new SequenceWaiter(_pageIndicator, FlexEvent.UPDATE_COMPLETE, 1500));
      sequence.addStep(new SequenceCaller(_pageIndicator, handleVerifyProperty, [passThroughData]));
      sequence.run();
    }
  
  }
}
