package com.piaction.tool
{
  import com.pialabs.eskimo.utils.DateUtils;
  
  import flexunit.framework.Assert;

  public class DateUtilsTest
  {
    public function DateUtilsTest()
    {
    }
    
    [Test]
    public function monthPatternTest():void
    {
      var dateUtils:DateUtils = new DateUtils();
      var monthPattern:String = dateUtils.monthPattern("dd MMM yyyy");
      Assert.assertEquals(monthPattern, "MMM");
      
      monthPattern = dateUtils.monthPattern("dd M yyyy");
      Assert.assertEquals(monthPattern, "M");
    }
    
    [Test]
    public function yearPatternTest():void
    {
      var dateUtils:DateUtils = new DateUtils();
      var yearPattern:String = dateUtils.yearPattern("dd MMM yyyy");
      Assert.assertEquals(yearPattern, "yyyy");
      
      yearPattern = dateUtils.yearPattern("yy dd M");
      Assert.assertEquals(yearPattern, "yy");
    }
  }
}