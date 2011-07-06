package com.piaction.components
{
    import com.piaction.utils.DateUtils;
    
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.formatters.DateFormatter;
    
    import spark.components.Group;
    import spark.components.List;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;
    import spark.formatters.DateTimeFormatter;

    /**
     *  Dispatched after the selection has changed. 
     *  This event is dispatched when the user interacts with the control.
     */
    [Event(name="change", type="spark.events.IndexChangeEvent")]
    
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
        public var dayList:List;
        
        [SkinPart(required = "true")]
        public var monthList:List;
        
        [SkinPart(required = "true")]
        public var yearList:List;
        
        public var maxYear:Number;
        
        public var minYear:Number;
        
        public var datePattern:String;
        
        private var _selectedDate:Date = new Date();
        
        private var _selectedDateChange:Boolean;
        
        private var _dayProviderChange:Boolean;
        
        private var _dayProvider:IList;
        
        override protected function partAdded(partName:String, instance:Object):void
        {
/*          setStyle("locale", "fr-FR");
          trace("locale " + getStyle('locale'));*/
          if(monthList == instance)
          {
            createMonthProvider();
          }
          if(yearList == instance)
          {
            createYearProvider();
          }
          
          if(dayList == instance)
          {
            var dateUtils:DateUtils = new DateUtils();
            dayProvider = dateUtils.numberDayInMonth(selectedDate.month + 1, selectedDate.fullYear);
            dayList.selectedIndex = selectedDate.date - 1;
            
            dayList.addEventListener(IndexChangeEvent.CHANGE, onDayChange);
          }
        }
        
        private function createMonthProvider():void
        {
          var monthProvider:ArrayCollection = new ArrayCollection();
          monthList.dataProvider = monthProvider;
          
          var dateUtils:DateUtils = new DateUtils();
          var monthPattern:String = dateUtils.monthPattern(datePattern);
          for(var index:int = 1; index < 13; index++)
          {
            monthProvider.addItem(dateUtils.formatMonth(index, monthPattern));
          }
          selectMonth();
          monthList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
        }
        
        private function createYearProvider():void
        {
          var yearProvider:ArrayCollection = new ArrayCollection();
          yearList.dataProvider = yearProvider;
          
          var dateUtils:DateUtils = new DateUtils();
          var yearPattern:String = dateUtils.yearPattern(datePattern);
          for(var year:Number = minYear; year <= maxYear; year++)
          {
            yearProvider.addItem(dateUtils.formatYear(year, yearPattern));
          }
          selectYear();
          yearList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
        }
        
        private function set dayProvider(endDateOfMonth:Number):void
        {
          _dayProvider = new ArrayCollection();
          var dateUtils:DateUtils = new DateUtils();
          var dayPattern:String = dateUtils.dayPattern(datePattern);
          for(var day:Number = 1; day <= endDateOfMonth; day++)
          {
            _dayProvider.addItem(dateUtils.formatDay(day, dayPattern));
          }
          
          dayList.dataProvider = _dayProvider;
          _dayProviderChange = true;
          invalidateProperties();
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
          super.commitProperties();
          
          if(_dayProviderChange)
          {
            dayList.dataProvider = _dayProvider;
            _dayProviderChange = false;
          }
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
          super.updateDisplayList(unscaledWidth, unscaledHeight);
          
          var dayIndex:int = datePattern.indexOf(DateUtils.DAY_CHAR);
          var monthIndex:int = datePattern.indexOf(DateUtils.MONTH_CHAR);
          var yearIndex:int = datePattern.indexOf(DateUtils.YEAR_CHAR);

          var minIndex:int = Math.min(dayIndex, monthIndex, yearIndex);
          var maxIndex:int = Math.max(dayIndex, monthIndex, yearIndex);
          
          if(dayIndex < 0 || monthIndex < 0 || yearIndex < 0)
          {
            throw(new Error("datePattern must contain d, M and y"));
          }
          var dayPos:int = 1;
          var monthPos:int = 1;
          var yearPos:int = 1;
          
          if(dayIndex == minIndex)
          {
            dayPos = 0;
          }
          else if(dayIndex == maxIndex)
          {
            dayPos = 2;
          }
          if(monthIndex == minIndex)
          {
            monthPos = 0;
          }
          else if(monthIndex == maxIndex)
          {
            monthPos = 2;
          }
          if(yearIndex == minIndex)
          {
            yearPos = 0;
          }
          else if(yearIndex == maxIndex)
          {
            yearPos = 2;
          }
          dateInput.setElementIndex(dayGroup, dayPos);
          dateInput.setElementIndex(monthGroup, monthPos);
          dateInput.setElementIndex(yearGroup, yearPos);  
        }
        private function onMonthOrYearChange(event:IndexChangeEvent):void
        {
          var dateUtils:DateUtils = new DateUtils();
          var year:Number = minYear + yearList.selectedIndex;
          dayProvider = dateUtils.numberDayInMonth(monthList.selectedIndex + 1, year);
          
          var currentIndex:int = dayList.selectedIndex;
          dayList.validateNow();
          if(_dayProvider.length > currentIndex)
          {
            dayList.selectedIndex = currentIndex;
          }
          else
          {
            dayList.selectedIndex = _dayProvider.length - 1;
          }
          
          var evt:Event = event.clone();
          dispatchEvent(evt);
        }
        
        
        private function onDayChange(event:IndexChangeEvent):void
        {
          var evt:Event = event.clone();
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
          if(value != _selectedDate)
          {
            _selectedDate = value;
            
            _selectedDateChange = true;
            
            invalidateProperties();
          }
        }
        
        private function selectDateOfMonth():void
        {
          var dateOfMonth:Number = selectedDate.date;
          dayList.selectedIndex = dateOfMonth;
        }
        
        private function selectMonth():void
        {
          var month:Number = selectedDate.month;
          monthList.selectedIndex = month;
        }
        
        private function selectYear():void
        {
          var year:Number = selectedDate.fullYear;
          var selectedIndex:Number = year - minYear;
          yearList.selectedIndex = Math.max(0, selectedIndex);
        }
    }
}