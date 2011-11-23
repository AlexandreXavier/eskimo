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
  import com.pialabs.eskimo.utils.DateUtils;
  
  import flash.events.Event;
  
  import mx.collections.ArrayCollection;
  import mx.collections.IList;
  
  import spark.components.Group;
  import spark.components.Label;
  import spark.components.supportClasses.ListBase;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.events.IndexChangeEvent;
  
  /**
   *  Dispatched after the selection has changed.
   *  This event is dispatched when the user interacts with the control.
   */
  [Event(name = "change", type = "spark.events.IndexChangeEvent")]
  
  /**
   *  The DateChooser displays the column of the days of the month, month and the year.
   *  Each column represented by a ListWheel on iOs and a ListStepper on android.
   */
  [ResourceBundle("i18n")]
  public class DateChooser extends SkinnableComponent
  {
    public function DateChooser()
    {
      super();
    }
    
    [SkinPart(required = "true")]
    public var dateInput:Group;
    
    [SkinPart(required = "true")]
    public var dayGroup:Group;
    
    [SkinPart(required = "true")]
    public var monthGroup:Group;
    
    [SkinPart(required = "true")]
    public var yearGroup:Group;
    
    [SkinPart(required = "true")]
    public var dayList:ListBase;
    
    [SkinPart(required = "true")]
    public var monthList:ListBase;
    
    [SkinPart(required = "true")]
    public var yearList:ListBase;
    
    [SkinPart(required = "false")]
    public var dayLabel:Label;
    
    [SkinPart(required = "false")]
    public var monthLabel:Label;
    
    [SkinPart(required = "false")]
    public var yearLabel:Label;
    
    /**
     * @private
     */
    protected var _maxYear:Number = 2040;
    
    /**
     * @private
     */
    protected var _minYear:Number = 1980;
    
    /**
     * @private
     */
    protected var _datePattern:String = DateUtils.defaultDateTimePattern;
    protected var _datePatternChange:Boolean = true;
    
    /**
     * @private
     */
    protected var _selectedDate:Date = new Date();
    
    /**
     * @private
     */
    private var _selectedDateChange:Boolean = true;
    private var _monthProviderChange:Boolean;
    private var _yearProviderChange:Boolean;
    
    /**
     * @private
     */
    [Bindable]
    protected var _dayProvider:IList = new ArrayCollection();
    protected var _monthProvider:IList;
    protected var _yearProvider:IList;
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      if (monthList == instance)
      {
        monthList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
      }
      if (yearList == instance)
      {
        yearList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
      }
      
      if (dayList == instance)
      {
        dayList.addEventListener(IndexChangeEvent.CHANGE, onDayChange);
        dayList.dataProvider = _dayProvider;
      }
      
      if (dayLabel == instance)
      {
        dayLabel.text = resourceManager.getString("i18n", "day.label");
      }
      if (monthLabel == instance)
      {
        monthLabel.text = resourceManager.getString("i18n", "month.label");
      }
      if (yearLabel == instance)
      {
        yearLabel.text = resourceManager.getString("i18n", "year.label");
      }
    }
    
    /**
     * @private
     */
    protected function createMonthProvider():void
    {
      var array:Array = new Array();
      
      var dateUtils:DateUtils = new DateUtils();
      var monthPattern:String = dateUtils.monthPattern(datePattern);
      for (var index:int = 1; index < 13; index++)
      {
        array.push(dateUtils.formatShortMonth(index, monthPattern));
      }
      
      _monthProvider = new ArrayCollection(array);
      _monthProviderChange = true;
    
    }
    
    /**
     * @private
     */
    protected function createYearProvider():void
    {
      var array:Array = new Array();
      
      var dateUtils:DateUtils = new DateUtils();
      var yearPattern:String = dateUtils.yearPattern(datePattern);
      for (var year:Number = minYear; year <= maxYear; year++)
      {
        array.push(dateUtils.formatYear(year, yearPattern));
      }
      
      _yearProvider = new ArrayCollection(array);
      _yearProviderChange = true;
    
    }
    
    /**
     * @private
     */
    protected function createDayProvider(endDateOfMonth:Number):void
    {
      var dateUtils:DateUtils = new DateUtils();
      var dayPattern:String = dateUtils.dayPattern(datePattern);
      
      var dayProviderLength:int = _dayProvider.length;
      if (dayProviderLength > endDateOfMonth)
      {
        for (var dayIndex:Number = dayProviderLength - 1; dayIndex >= endDateOfMonth; dayIndex--)
        {
          _dayProvider.removeItemAt(dayIndex);
        }
      }
      else if (dayProviderLength < endDateOfMonth)
      {
        for (var day:Number = dayProviderLength + 1; day <= endDateOfMonth; day++)
        {
          _dayProvider.addItem(dateUtils.formatDay(day, dayPattern));
        }
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      var dateUtils:DateUtils = new DateUtils();
      
      var numberDaynMonth:int = dateUtils.numberDayInMonth(_selectedDate.month + 1, _selectedDate.fullYear);
      
      if (_datePatternChange)
      {
        createYearProvider();
        
        createMonthProvider();
        
        createDayProvider(numberDaynMonth);
        
        updateListPositions();
        
        _datePatternChange = false;
        _selectedDateChange = false;
      }
      
      if (_selectedDateChange)
      {
        if (_dayProvider.length != numberDaynMonth)
        {
          createDayProvider(numberDaynMonth);
        }
        
        _selectedDateChange = false;
      }
      
      if (_yearProviderChange)
      {
        yearList.dataProvider = _yearProvider;
        _yearProviderChange = false;
        
      }
      if (_monthProviderChange)
      {
        monthList.dataProvider = _monthProvider;
        _monthProviderChange = false;
        
      }
      
      selectYear();
      selectMonth();
      selectDateOfMonth();
    }
    
    /**
     * @private
     */
    protected function updateListPositions():void
    {
      var dayIndex:int = datePattern.indexOf(DateUtils.DAY_CHAR);
      var monthIndex:int = datePattern.indexOf(DateUtils.MONTH_CHAR);
      var yearIndex:int = datePattern.indexOf(DateUtils.YEAR_CHAR);
      
      var minIndex:int = Math.min(dayIndex, monthIndex, yearIndex);
      var maxIndex:int = Math.max(dayIndex, monthIndex, yearIndex);
      
      if (dayIndex < 0 || monthIndex < 0 || yearIndex < 0)
      {
        throw(new Error("datePattern must contain d, M and y"));
      }
      var dayPos:int = 1;
      var monthPos:int = 1;
      var yearPos:int = 1;
      
      if (dayIndex == minIndex)
      {
        dayPos = 0;
      }
      else if (dayIndex == maxIndex)
      {
        dayPos = 2;
      }
      
      if (monthIndex == minIndex)
      {
        monthPos = 0;
      }
      else if (monthIndex == maxIndex)
      {
        monthPos = 2;
      }
      
      if (yearIndex == minIndex)
      {
        yearPos = 0;
      }
      else if (yearIndex == maxIndex)
      {
        yearPos = 2;
      }
      
      dateInput.setElementIndex(dayGroup, dayPos);
      dateInput.setElementIndex(monthGroup, monthPos);
      dateInput.setElementIndex(yearGroup, yearPos);
    }
    
    /**
     * @private
     */
    protected function onMonthOrYearChange(event:Event):void
    {
      var dateUtils:DateUtils = new DateUtils();
      
      var newYear:int = yearList.selectedIndex + minYear;
      var newMonth:int = monthList.selectedIndex;
      var newDay:int = Math.min(dayList.selectedIndex + 1, dateUtils.numberDayInMonth(newMonth + 1, newYear));
      
      _selectedDate.setFullYear(newYear, newMonth, newDay);
      
      _selectedDateChange = true;
      
      invalidateProperties();
      
      var evt:Event = new IndexChangeEvent(IndexChangeEvent.CHANGE);
      dispatchEvent(evt);
    }
    
    /**
     * @private
     */
    protected function onDayChange(event:Event):void
    {
      var dateUtils:DateUtils = new DateUtils();
      
      var newYear:int = yearList.selectedIndex + minYear;
      var newMonth:int = monthList.selectedIndex;
      var newDay:int = Math.min(dayList.selectedIndex + 1, dateUtils.numberDayInMonth(newMonth + 1, newYear));
      
      _selectedDate.setFullYear(newYear, newMonth, newDay);
      
      var evt:Event = new IndexChangeEvent(IndexChangeEvent.CHANGE);
      dispatchEvent(evt);
    }
    
    /**
     *  The date that is currently selected.
     */
    public function get selectedDate():Date
    {
      return _selectedDate;
    }
    
    /**
     * Setting this property deselects the currently selected
     *  date and selects the newly specified date.
     */
    public function set selectedDate(value:Date):void
    {
      if (value != _selectedDate)
      {
        _selectedDate = value;
        
        _selectedDateChange = true;
        
        invalidateProperties();
      }
    }
    
    /**
     * @private
     */
    protected function selectDateOfMonth():void
    {
      var dateOfMonth:Number = selectedDate.date - 1;
      
      dayList.validateNow();
      
      dayList.selectedIndex = dateOfMonth;
      
      dayList.invalidateProperties();
    }
    
    /**
     * @private
     */
    protected function selectMonth():void
    {
      var month:Number = selectedDate.month;
      monthList.validateNow();
      monthList.selectedIndex = month;
      monthList.invalidateProperties();
    }
    
    /**
    * @private
    */
    protected function selectYear():void
    {
      var year:Number = selectedDate.fullYear;
      var selectedIndex:Number = year - minYear;
      yearList.validateNow();
      yearList.selectedIndex = Math.max(0, selectedIndex);
      yearList.invalidateProperties();
    }
    
    /**  The pattern string used by the DateChooser object to format
     *  dates.
     *
     *  @default OS locale
     */
    public function get datePattern():String
    {
      return _datePattern;
    }
    
    /**
     * @private
     */
    public function set datePattern(value:String):void
    {
      _datePattern = value;
      
      _datePatternChange = true;
      
      invalidateProperties();
    }
    
    /**
     *  The last year selectable in the control.
     *
     *  @default 2040
     */
    public function get maxYear():Number
    {
      return _maxYear;
    }
    
    /**
     * @private
     */
    public function set maxYear(value:Number):void
    {
      _maxYear = value;
      
      _datePatternChange = true;
      
      invalidateProperties();
    }
    
    /**
     *  The first year selectable in the control.
     *
     *  @default 1980
     */
    public function get minYear():Number
    {
      return _minYear;
    }
    
    /**
     * @private
     */
    public function set minYear(value:Number):void
    {
      _minYear = value;
      
      _datePatternChange = true;
      
      invalidateProperties();
    }
  
  }
}
