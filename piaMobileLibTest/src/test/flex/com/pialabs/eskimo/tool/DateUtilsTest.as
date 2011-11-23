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
package com.pialabs.eskimo.tool
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