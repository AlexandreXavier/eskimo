package com.piaction.components
{
  import com.piaction.skins.CalendarHearderRenderer;
  import com.piaction.skins.CalendarSkin;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TransformGestureEvent;
  import flash.geom.Rectangle;
  
  import mx.collections.ArrayCollection;
  import mx.collections.IList;
  import mx.core.ClassFactory;
  import mx.events.CollectionEvent;
  import mx.events.CollectionEventKind;
  import mx.events.ResizeEvent;
  import mx.formatters.DateFormatter;
  
  import spark.components.DataGrid;
  import spark.components.Group;
  import spark.components.Label;
  import spark.components.gridClasses.GridColumn;
  import spark.components.gridClasses.GridSelectionMode;
  import spark.skins.spark.DefaultGridItemRenderer;
  import com.piaction.skins.CalendarItemSkin;
  import com.piaction.events.CalendarEvent;
  
  [Event(name="activityAdded", type="com.piaction.events.CalendarEvent")]
  [Event(name="activityClick", type="com.piaction.events.CalendarEvent")]
  [Event(name="activityDown", type="com.piaction.events.CalendarEvent")]
  /**
  * Compoenent that display a week or day calendar
  */
  public class Calendar extends DataGrid
  {
    /**
    * layer of the calendar
    */
    [Bindable]
    [SkinPart(required="true")]
    public var calendarLayer:Group;
    /**
     * layer of the content
     */
    [Bindable]
    [SkinPart(required="true")]
    public var contentLayer:Group;
    
    /**
     * Hour step
     */
    public static const HOUR_UNIT:int = 1;
    
    public static const HALF_HOUR_UNIT:int = 2;
    /**
     * Day mode
     */
    public static const DAY_MODE:String ="dayMode";
    /**
     * Week mode
     */
    public static const WEEK_MODE:String ="weekMode";
    /**
     * Work week mode
     */
    public static const WORK_WEEK_MODE:String ="workWeekMode";
    
    
    /**
     * Action of edition
     */
    private static const EDITION_ACTION:String ="edition";
    /**
     * Action of creation
     */
    private static const CREATION_ACTION:String ="creation";
    
    
    /**
     * Width a the time column
     */
    public const timeColumnWidth:int = 56; 
    
    
    /**
     * Bolean to display or not the header
     */
    [Bindable]
    public var displayHeader:Boolean = true;
    
    /**
     * Time step btween rows
     */
    [Bindable]
    public var unit:int = HALF_HOUR_UNIT;
    
    /**
     * Start time label field
     */
    public var startTimeField:String = "startDate";
    
    /**
     * End time label field
     */
    public var endTimeField:String = "endDate";
    
    /**
     * Summary label field
     */
    public var textField:String = "summary";
    
    
    /**
     * @private
     */
    private var _mode:String;
    
    private var _currentDate:Date = getFirstDateOfWeek(new Date());
    
    private var _startDate:int = 8;
    
    
    private var _redrawCalendar:Boolean;
    
    private var _firstDisplayedDate:Date;
    
    private var _lastDisplayedDate:Date;
    
    private var _timeDataProvider:IList = new ArrayCollection();
    
    private var _firstDayColumn:GridColumn;
    
    private var _secondDayColumn:GridColumn;
    
    private var _thirdDayColumn:GridColumn;
    
    private var _fourthDayColumn:GridColumn;
    
    private var _fifthDayColumn:GridColumn;
    
    private var _sixthDayColumn:GridColumn;
    
    private var _seventhDayColumn:GridColumn;
    
    private var _dayColumnWidth:int;
    
    private var _itemBeingAdded:CalendarItem;
    
    private var _currentAction:String;
    
    private var _onPan:Boolean;
    
    private var _rowHeight:Number;
    
    private var _currentDateChanged:Boolean;
    
    private var _resetDisplayRange:Boolean;
    
    private var _modeChanged:Boolean;
    
    /**
     * @private
     * Pool of renderer for optimization
     */
    private static var  _itemRendererPool:Array = new Array();
    
    /**
     * Constructor
     */
    public function Calendar()
    {
      super();
      
      setStyle("skinClass", CalendarSkin);
      selectionMode = GridSelectionMode.NONE;
      addEventListener(ResizeEvent.RESIZE, onResize);
      super.columns = new ArrayCollection();
      
      populatePool();
    }
    
    /**
     * Start date of the calendar delaut : 8h
     */
    public function get startDate():int
    {
      return _startDate;
    }
    
    /**
     * @private
     */
    public function set startDate(value:int):void
    {
      _startDate = value;
    }
    
    /**
    * Mode of the Calendar DAY_MODE, WEEK_MODe, WORK_WEEK_MODE
    */
    [Bindable(event="modeChange")]
    public function get mode():String
    {
      return _mode;
    }
    
    /**
     * @private
     */
    public function set mode(value:String):void
    {
      if( _mode !== value)
      {
        _mode = value;
        _modeChanged = true;
        invalidateProperties();
        dispatchEvent(new Event("modeChange"));
      }
    }
    
    /**
     * Current date of the calendar
     */
    public function get currentDate():Date
    {
      return _currentDate;
    }
    
    /**
     * @private
     */
    public function set currentDate(value:Date):void
    {
      if (_currentDate == null ||
        (value != null && _currentDate.time != value.time))
      {
         _currentDate = value;
        _currentDateChanged = true;
        
        invalidateProperties();
      }
      
    }
    
    /**
     * Data provider
     */
    override public function set dataProvider(value:IList):void
    {
      if (value != null && value != _timeDataProvider)
      {
        if (_timeDataProvider != null)
        {
          _timeDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
          _timeDataProvider.removeEventListener(CollectionEventKind.REFRESH, onRefresh);
        }
        
        _timeDataProvider = value;
        _timeDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
        _timeDataProvider.addEventListener(CollectionEventKind.REFRESH, onRefresh);
        
        invalidateCalendarLayer();
      }
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == grid)
      {
        var timeItem:IList = new ArrayCollection();
        
        for (var i:int = 0; i < 24; i++)
        {
          timeItem.addItem(new TimeItem(i, 0));
          
          if (unit == HALF_HOUR_UNIT)
          {
            timeItem.addItem(new TimeItem(-1, -1));
          }
          
        }
        
        super.dataProvider = timeItem;
      }
      
      if (instance == scroller)
      {
        scroller.setStyle('verticalScrollPolicy', 'off');
        scroller.setStyle('horizontalScrollPolicy', 'off');
        
        scroller.doubleClickEnabled = true;
        scroller.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
        scroller.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        scroller.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        scroller.addEventListener(TransformGestureEvent.GESTURE_PAN, onPan);
        
        invalidateDisplayRange();
      }
      
    }
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      
      if (_modeChanged)
      {
        var columnsList:IList = new ArrayCollection();
        
        var timeColumn:GridColumn = new GridColumn();
        timeColumn.sortable = false;
        timeColumn.headerText = "";
        timeColumn.dataField = "label";
        timeColumn.width = timeColumnWidth;
        //timeColumn.itemRenderer = new ClassFactory(CalendarTimeItemRenderer);
        columnsList.addItem(timeColumn);
        
        columnHeaderGroup.headerRenderer = new ClassFactory(CalendarHearderRenderer);
        
        if (mode == DAY_MODE)
        {
          _firstDayColumn = new GridColumn();
          columnsList.addItem(_firstDayColumn);
        }
        
        if (mode == WEEK_MODE)
        {
          _firstDayColumn = new GridColumn();
          columnsList.addItem(_firstDayColumn);
          
          _secondDayColumn = new GridColumn();
          columnsList.addItem(_secondDayColumn);
          
          _thirdDayColumn = new GridColumn();
          columnsList.addItem(_thirdDayColumn);
          
          _fourthDayColumn = new GridColumn();
          columnsList.addItem(_fourthDayColumn);
          
          _fifthDayColumn = new GridColumn();
          columnsList.addItem(_fifthDayColumn);
          
          _sixthDayColumn = new GridColumn();
          columnsList.addItem(_sixthDayColumn);
          
          _seventhDayColumn = new GridColumn();
          columnsList.addItem(_seventhDayColumn);
        }
        
        if (mode == WORK_WEEK_MODE)
        {
          _firstDayColumn = new GridColumn();
          columnsList.addItem(_firstDayColumn);
          
          _secondDayColumn = new GridColumn();
          columnsList.addItem(_secondDayColumn);
          
          _thirdDayColumn = new GridColumn();
          columnsList.addItem(_thirdDayColumn);
          
          _fourthDayColumn = new GridColumn();
          columnsList.addItem(_fourthDayColumn);
          
          _fifthDayColumn = new GridColumn();
          columnsList.addItem(_fifthDayColumn);
        }
        
        super.columns = columnsList;
        
        resetDayColumnWidth();
        invalidateCalendarLayer();
      }
      
     
      if (_currentDateChanged || _modeChanged)
      {
        var dateFormatter:DateFormatter = new DateFormatter();
        
        
        if (mode == DAY_MODE)
        {
          dateFormatter.formatString = "EEEE DD MMMM";
          _firstDisplayedDate = currentDate;
          _lastDisplayedDate = new Date();
          _lastDisplayedDate.setTime(currentDate.getTime());
          _lastDisplayedDate.setDate(_lastDisplayedDate.date + 1);
          
          _firstDayColumn.headerText = dateFormatter.format(currentDate);
        }
        else
        { 
          dateFormatter.formatString = "EEE. DD MMMM";
          _firstDisplayedDate =  getFirstDateOfWeek(currentDate);
          
          var date:Date = new Date()
          date.setTime(_firstDisplayedDate.getTime());
          date.setDate(date.getDate() - 1 );
          for (var i:int = 1; i < columns.length; i++)
          {
            var column:GridColumn = columns[i];
            
            date.setDate(date.getDate() + 1);
            column.headerText = dateFormatter.format(date);
          }
          
          date.setDate(date.getDate() + 1);
          _lastDisplayedDate = date;
          
        }
        
        _currentDateChanged = false;
        invalidateCalendarLayer();
        invalidateDisplayRange();
      }
      
      
      if (_modeChanged)
      {
        _modeChanged = false;
      }
    }
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if (isNaN(_rowHeight))
      {
        retrieveRowHeight();
        resetDisplayRange();
      }
      
      if (_redrawCalendar && !isNaN(_rowHeight))
      {
        for(var i:int=0; i< calendarLayer.numElements; i++)
        {
          storeItemRenderer( calendarLayer.getElementAt(i) as CalendarItem );
        }
        
        calendarLayer.removeAllElements();
        for( i = 0; i<_timeDataProvider.length; i++ )
        {
         
          var item:Object = _timeDataProvider[i];
          
          if( (item[startTimeField] as Date).time >= _firstDisplayedDate.time && (item[endTimeField] as Date).time <= _lastDisplayedDate.time )
          {
            var calendarItem:CalendarItem = getItemrenderer(item[textField], item[startTimeField], item[endTimeField]);
            calendarItem.width = _dayColumnWidth;
            calendarItem.x = retrieveDateX(item[startTimeField]);
            
            calendarItem.y = retrieveDateY(item[startTimeField]);
            calendarItem.height = retrieveDurationHeight(item[startTimeField], item[endTimeField]);
            
            calendarLayer.addElement(calendarItem);
          }
        }
        _redrawCalendar = false;
      }
      
      if (_resetDisplayRange)
      {
        resetDisplayRange();
        _resetDisplayRange = false;
      }
      
      skin.invalidateDisplayList();
      
    }
    
    
    /**
     * Hilight items in the Calendar
     */
    public function set highlightedItems(value:ArrayCollection):void
    { 
      for (var i:int = 0; i < calendarLayer.numChildren; i++)
      {
        var calendarItem:CalendarItem = calendarLayer.getElementAt(i) as CalendarItem;
        
        var highlight:Boolean = false;
        for( var j:int = 0; j<value.length; j++ )
        {
          var item:Object = _timeDataProvider[j];
          if (calendarItem.compareTo(item, startTimeField, endTimeField, textField))
          {
            highlight = true;
          }
        }
        
        calendarItem.highlight = highlight;
      }
    }
    /**
     * @private
     */
    private function onResize(event:ResizeEvent):void
    {
      resetDayColumnWidth();
      invalidateCalendarLayer();
      invalidateDisplayRange();
    }
    /**
     * @private
     */
    private function onCollectionChange(event:CollectionEvent):void
    {
      invalidateCalendarLayer();
    }
    /**
     * @private
     */
    private function onRefresh(event:CollectionEventKind):void
    {
      invalidateCalendarLayer();
    }
    /**
     * @private
     */
    private function onDoubleClick(e:MouseEvent):void
    {
      if (e.target is CalendarItemSkin)
      {
        dispatchEvent(CalendarEvent.newDoubleClickActivityEvent(CalendarItemSkin(e.target).hostComponent));
      }
      else if (e.target is Label)
      {
        dispatchEvent(CalendarEvent.newDoubleClickActivityEvent(CalendarItemSkin(e.target.parentDocument).hostComponent));
      }
    }
    /**
     * @private
     */
    private function onMouseDown(e:MouseEvent):void
    {
      resetItemBeingAdded();
      
      if (e.target is DefaultGridItemRenderer)
      {
        if (editable)
        {
          scroller.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
          _itemBeingAdded = getItemrenderer("", null, null);
          _itemBeingAdded.width = _dayColumnWidth;
          
          var localeY:int = retrieveLocaleYFromStageY(e.stageY);
          _itemBeingAdded.setLayoutBoundsPosition(timeColumnWidth, retrieveTopTimeYFromY(localeY));
          _itemBeingAdded.height = _rowHeight;
          calendarLayer.addElement(_itemBeingAdded);
          _currentAction = CREATION_ACTION;
        }
      }
      else
      {
        _currentAction = EDITION_ACTION;
        if (e.target is CalendarItemSkin)
        {
          callLater(dispatchActivityDown, [CalendarEvent.newDownActivityEvent(CalendarItemSkin(e.target).hostComponent)]);
        }
        else if (e.target is Label && e.target.parentDocument is CalendarItemSkin)
        {
          callLater(dispatchActivityDown, [CalendarEvent.newDownActivityEvent(CalendarItemSkin(e.target.parentDocument).hostComponent)]);
        }
      }
    }
    /**
     * @private
     */
    private function dispatchActivityDown(event:CalendarEvent):void
    {
      dispatchEvent(event);
    }
    /**
     * @private
     */
    private function onMouseUp(e:MouseEvent):void
    {
      if (_onPan)
      {
        scroller.setStyle('verticalScrollPolicy', 'off');
        _onPan = false;
      }
      
      if (_currentAction == EDITION_ACTION)
      {
        if (e.target is CalendarItemSkin)
        {
          dispatchEvent(CalendarEvent.newClickActivityEvent(CalendarItemSkin(e.target).hostComponent));
        }
        else if (e.target is Label && e.target.parentDocument)
        {
          dispatchEvent(CalendarEvent.newClickActivityEvent(CalendarItemSkin(e.target.parentDocument).hostComponent));
        }
      }
      else if (_currentAction == CREATION_ACTION)
      {
        scroller.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        
        var localeY:int = retrieveLocaleYFromStageY(e.stageY);
        var nextCalendarItem:CalendarItem = retreiveNextCalendarItemFromY(_itemBeingAdded.y);
        if(nextCalendarItem != null)
        {
          localeY = localeY < nextCalendarItem.y ? localeY : nextCalendarItem.y;
        }
        
        _itemBeingAdded.height = retrieveBottomTimeYFromY(localeY)- _itemBeingAdded.y; 
        
        _itemBeingAdded.startDate = retrieveDateFromPosition(_itemBeingAdded.x, _itemBeingAdded.y);
        _itemBeingAdded.endDate = retrieveDateFromPosition(_itemBeingAdded.x, _itemBeingAdded.y + _itemBeingAdded.height);
        
        if (_itemBeingAdded.startDate.time < _itemBeingAdded.endDate.time)
        {
          dispatchEvent(CalendarEvent.newAddedActivityEvent(_itemBeingAdded));
        }
        else 
        {
          resetItemBeingAdded();
        }
      }
      
      _currentAction = null;
    }
    /**
     * @private
     */
    private function onMouseMove(e:MouseEvent):void
    {
      if (!_onPan && _itemBeingAdded != null)
      {
        var localY:int = retrieveLocaleYFromStageY(e.stageY);
        var nextCalendarItem:CalendarItem = retreiveNextCalendarItemFromY(_itemBeingAdded.y);
        if(nextCalendarItem != null)
        {
          localY = localY < nextCalendarItem.y ? localY : nextCalendarItem.y;
        }
        _itemBeingAdded.height = retrieveBottomTimeYFromY(localY) - _itemBeingAdded.y;
      }
      else 
      {
        if (calendarLayer.containsElement(_itemBeingAdded))
        {
          calendarLayer.removeElement(_itemBeingAdded);
          storeItemRenderer(_itemBeingAdded);
        }
        _itemBeingAdded = null;
        _currentAction = null;
      }
    }
    /**
     * @private
     */
    private function onPan(e:TransformGestureEvent):void
    {
      _onPan = true; 
      scroller.setStyle('verticalScrollPolicy', 'on');
    }
    
    /**
     * @private
     */
    private function resetItemBeingAdded():void
    {
      if (calendarLayer.containsElement(_itemBeingAdded))
      {
        calendarLayer.removeElement(_itemBeingAdded);
      }
      
      _itemBeingAdded = null;
    }
    
    /**
     * @private
     */
    private function retrieveTopTimeYFromY(y:int):int
    {
      return  int((y / _rowHeight)) * _rowHeight;
    }
    /**
     * @private
     */
    private function retrieveBottomTimeYFromY(y:int):int
    {
      var numberLine:int = y / _rowHeight;
      var rest:int = y % _rowHeight;
      
      if (rest > 3)
      {
        numberLine += 1;
      }
      
      return  numberLine * _rowHeight;
    }
    
    /**
     * @private
     */
    private function retrieveLocaleYFromStageY(stageY:int):int
    {
      var scrollerStagePosition:Rectangle = scroller.getBounds(stage);
      return stageY + contentLayer.verticalScrollPosition - scrollerStagePosition.y;
    }
    /**
     * @private
     */
    private function retrieveDateY(date:Date):int
    {
      var y:int;
      
      if (unit == HALF_HOUR_UNIT)
      {
        y = (date.getHours() * 2 + date.minutes / 30) * _rowHeight;
      }
      
      if (unit == HOUR_UNIT)
      {
        y = (date.getHours() + date.minutes / 60) * _rowHeight;
      }
      
      return y
    }
    /**
     * @private
     */
    private function retrieveDateX(date:Date):int
    {
      var columnIndex:int = date.getDate() - _firstDisplayedDate.getDate();
      return columnIndex * (_dayColumnWidth + 1) + timeColumnWidth;
    }
    /**
     * @private
     */
    private function retrieveStartTimeY():int
    {
      var y:int;
      
      if (unit == HALF_HOUR_UNIT)
      {
        y = _startDate * 2 * _rowHeight;
      }
      
      if (unit == HOUR_UNIT)
      {
        y = _startDate * _rowHeight;
      }
      
      return y;
    }
    /**
     * @private
     */
    private function retrieveDurationHeight(startDate:Date, endDate:Date):int
    {
      return retrieveDateY(endDate) - retrieveDateY(startDate);
    }
    /**
     * @private
     */
    private function retrieveRowHeight():void
    {
      _rowHeight = grid.rowHeight;
    }
    /**
     * @private
     */
    private function retrieveDateFromPosition(x:int, y:int):Date
    {
      var hours:int = 0;
      var minutes:int = 0;
      
      if (unit == HALF_HOUR_UNIT)
      {
        var halfHours:int = y / _rowHeight;
        hours =  halfHours / 2;
        minutes = halfHours % 2 * 30;
      }
      
      if (unit == HOUR_UNIT)
      {
        hours = y / _rowHeight;
      }
      
      
      var dayIndex:int = (x - timeColumnWidth) / (_dayColumnWidth + 1);
      
      var date:Date = new Date();
      date.setTime(_firstDisplayedDate);
      date.setDate(date.getDate() + dayIndex);
      date.setHours(hours);
      date.setMinutes(minutes);
      
      return date;
    }
    /**
     * @private
     */
    private function retreiveNextCalendarItemFromY(y:int):CalendarItem
    {
      var nextCalendarItem:CalendarItem;
      for (var i:int = 0; i < calendarLayer.numChildren; i++)
      {
        var calendarItem:CalendarItem = calendarLayer.getElementAt(i) as CalendarItem;
        if(calendarItem.y > y && (nextCalendarItem == null || calendarItem.y < nextCalendarItem.y))
        {
          nextCalendarItem = calendarItem;
        }
      }
      return nextCalendarItem;
    }
    /**
     * @private
     */
    private function resetDayColumnWidth():void
    {
      _dayColumnWidth = (this.width - timeColumnWidth) / (columns.length - 1);
    }
    /**
     * @private
     */
    private function resetDisplayRange():void
    {
      if (contentLayer != null)
      {
        contentLayer.verticalScrollPosition = retrieveStartTimeY() - 19; // 19 to stand little up from the time label
      }
    }
    /**
     * @private
     */
    private function invalidateDisplayRange():void
    {
      _resetDisplayRange = true;
      invalidateDisplayList();
    }
    /**
     * @private
     */
    private function invalidateCalendarLayer():void
    {
      _redrawCalendar = true;
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function populatePool():void
    {
      while( _itemRendererPool.length < 20 )
      {
        storeItemRenderer(new CalendarItem("", new Date(), new Date()));
      }
    }
    /**
     * @private
     */
    private function storeItemRenderer(item:CalendarItem):void
    {
      _itemRendererPool.push(item);
      item.text = "";
      item.startDate = null;
      item.endDate = null;
    }
    /**
     * @private
     */
    private function getItemrenderer(text:String, startDate:Date, endDate:Date):CalendarItem
    {
      var result:CalendarItem;
      if(_itemRendererPool.length > 0){
        result = _itemRendererPool.shift();
        result.text = text;
        result.startDate = startDate;
        result.endDate = endDate;
      }else
      {
        result = new CalendarItem(text, startDate, endDate);
      }
      
      return result;
    }
    /**
     * @private
     */
    public static function getFirstDateOfWeek(date:Date):Date
    {
      if(date == null)
        date = new Date();
      var result:Date = new Date();
      result.setTime(date.getTime());
      result.setHours(0, 0, 0, 0);
      
      var day:int = result.day;
      if( day == 0 )
      {
        day = 7;
      }
      
      result.date = result.date - day + 1;
      
      return result;
    }
    
  }
}