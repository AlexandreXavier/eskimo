package com.piaction.components
{
  import flexunit.framework.Assert;
  
  public class PageIndicatorTest
  {
    
    private var _pageIndicator:PageIndicator;
    
    [Before]
    public function setUp():void
    {
      _pageIndicator = new PageIndicator();
    }
    
    [After]
    public function tearDown():void
    {
    }
    
    [BeforeClass]
    public static function setUpBeforeClass():void
    {
    }
    
    [AfterClass]
    public static function tearDownAfterClass():void
    {
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
  }
}
