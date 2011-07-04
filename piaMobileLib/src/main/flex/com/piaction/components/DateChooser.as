package com.piaction.components
{
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
        public var dateOfMonthList:List;
        
        [SkinPart(required = "true")]
        public var monthList:List;
        
        [SkinPart(required = "true")]
        public var yearList:List;
        
        public var maxYear:Number = 2020;
        
        public var minYear:Number = 2005;
        
        private var _selectedDate:Date = new Date();
        
        private var _selectedDateChange:Boolean;
        
        private var _dateOfMonthProviderChange:Boolean;
        
        private var _dateOfMonthProvider:IList;
        
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
            yearList.addEventListener(IndexChangeEvent.CHANGE, onMonthOrYearChange);
            selectYear();
          }
          
          if(dateOfMonthList == instance)
          {
            dateOfMonthProvider = 30;
          }
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
          super.commitProperties();
          
          if(_dateOfMonthProviderChange)
          {
            dateOfMonthList.dataProvider = _dateOfMonthProvider;
            _dateOfMonthProviderChange = false;
          }
        }
        
        private function onMonthOrYearChange(event:IndexChangeEvent):void
        {
          var curDate:Date = currentDate;
          if(curDate.month == 7)
          {
            dateOfMonthProvider = 31;
          }
          else
          {
            dateOfMonthProvider = 30;
          }
        }
        
        private function get currentDate():Date
        {
          var date:Date = new Date();
          date.date = dateOfMonthList.selectedIndex;
          date.month = monthList.selectedIndex;
          date.fullYear = minYear + yearList.selectedIndex;
          
          return date;
        }
        
        private function set dateOfMonthProvider(endDateOfMonth:Number):void
        {
          _dateOfMonthProvider = new ArrayCollection();
          for(var date:Number = 0; date < endDateOfMonth; date++)
          {
            _dateOfMonthProvider.addItem(date + 1);
          }
          
          dateOfMonthList.dataProvider = _dateOfMonthProvider;
          _dateOfMonthProviderChange = true;
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
          dateOfMonthList.selectedIndex = dateOfMonth;
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