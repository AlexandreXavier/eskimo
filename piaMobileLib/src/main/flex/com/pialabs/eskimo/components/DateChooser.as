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
     *  The last year selectable in the control.
     *
     *  @default 2040
     */
    public var maxYear:Number = 2040;
    
    /**
     *  The first year selectable in the control.
     *
     *  @default 1980
     */
    public var minYear:Number = 1980;
    
    private var _datePattern:String = DateUtils.defaultDateTimePattern;
    private var _datePatternChange:Boolean = true;
    
    private var _selectedDate:Date = new Date();
    
    private var _selectedDateChange:Boolean = true;
    ;
    
    private var _dayProviderChange:Boolean;
    private var _monthProviderChange:Boolean;
    private var _yearProviderChange:Boolean;
    
    private var _dayProvider:IList;
    private var _monthProvider:IList;
    private var _yearProvider:IList;
    
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
        dayList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
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
    
    private function createMonthProvider():void
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
    
    private function createYearProvider():void
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
    
    private function createDayProvider(endDateOfMonth:Number):void
    {
      var array:Array = new Array();
      
      var dateUtils:DateUtils = new DateUtils();
      var dayPattern:String = dateUtils.dayPattern(datePattern);
      for (var day:Number = 1; day <= endDateOfMonth; day++)
      {
        array.push(dateUtils.formatDay(day, dayPattern));
      }
      
      _dayProvider = new ArrayCollection(array);
      _dayProviderChange = true;
    
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      var dateUtils:DateUtils = new DateUtils();
      
      if (_datePatternChange)
      {
        createYearProvider();
        
        createMonthProvider();
        
        createDayProvider(dateUtils.numberDayInMonth(_selectedDate.month + 1, _selectedDate.fullYear));
        
        _datePatternChange = false;
        _selectedDateChange = false;
      }
      
      if (_selectedDateChange)
      {
        createDayProvider(dateUtils.numberDayInMonth(_selectedDate.month + 1, _selectedDate.fullYear));
        
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
      if (_dayProviderChange)
      {
        dayList.dataProvider = _dayProvider;
        _dayProviderChange = false;
        
      }
      
      selectYear();
      selectMonth();
      selectDateOfMonth()
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
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
    
    private function onMonthOrYearChange(event:Event):void
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
    
    
    private function onDayChange(event:Event):void
    {
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
    
    private function selectDateOfMonth():void
    {
      var dateOfMonth:Number = selectedDate.date - 1;
      dayList.validateNow();
      dayList.selectedIndex = dateOfMonth;
    }
    
    private function selectMonth():void
    {
      var month:Number = selectedDate.month;
      monthList.validateNow();
      monthList.selectedIndex = month;
    }
    
    private function selectYear():void
    {
      var year:Number = selectedDate.fullYear;
      var selectedIndex:Number = year - minYear;
      
      yearList.validateNow();
      yearList.selectedIndex = Math.max(0, selectedIndex);
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
  
  }
}
