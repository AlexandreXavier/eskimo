package com.piaction.components
{
    import com.piaction.utils.DateUtils;
    
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    
    import spark.components.List;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.events.IndexChangeEvent;

    public class DateChooser extends SkinnableComponent
    {
        public function DateChooser()
        {
            super();
        }
        
        [SkinPart(required = "true")]
        public var dayList:List;
        
        [SkinPart(required = "true")]
        public var monthList:List;
        
        [SkinPart(required = "true")]
        public var yearList:List;
        
        public var maxYear:Number = 2020;
        
        public var minYear:Number = 2005;
        
        private var _selectedDate:Date = new Date();
        
        private var _selectedDateChange:Boolean;
        
        private var _dayProviderChange:Boolean;
        
        private var _dayProvider:IList;
        
        override protected function partAdded(partName:String, instance:Object):void
        {
          if(monthList == instance)
          {
            var monthProvider:ArrayCollection = new ArrayCollection();
            monthList.dataProvider = monthProvider;
            for(var index:int = 1; index < 13; index = index + 1)
            {
              monthProvider.addItem(index);
            }
            selectMonth();
            monthList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
          }
          if(yearList == instance)
          {
            var yearProvider:ArrayCollection = new ArrayCollection();
            yearList.dataProvider = yearProvider;
            for(var year:Number = minYear; year <= maxYear; year++)
            {
              yearProvider.addItem(year);
            }
            selectYear();
            yearList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
          }
          
          if(dayList == instance)
          {
            dayProvider = DateUtils.numberDayInMonth(selectedDate.month + 1, selectedDate.fullYear);
            dayList.selectedIndex = selectedDate.date - 1;
          }
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
        
        private function onMonthOrYearChange(event:IndexChangeEvent):void
        {
          var year:Number = minYear + yearList.selectedIndex;
          dayProvider = DateUtils.numberDayInMonth(monthList.selectedIndex + 1, year);
          
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
        }
        
        private function set dayProvider(endDateOfMonth:Number):void
        {
          _dayProvider = new ArrayCollection();
          for(var date:Number = 1; date <= endDateOfMonth; date++)
          {
            _dayProvider.addItem(date);
          }
          
          dayList.dataProvider = _dayProvider;
          _dayProviderChange = true;
          invalidateProperties();
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