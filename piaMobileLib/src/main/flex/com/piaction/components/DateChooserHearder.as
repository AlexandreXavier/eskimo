package com.piaction.components
{
  import com.piaction.events.MobileCalendarEvent;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import spark.components.Label;
  
  import spark.components.Button;
  import spark.components.supportClasses.SkinnableComponent;
  import com.piaction.skins.DateChooserHeaderSkin;
  
  /**
  * Header component on the MobileDateChooser
  */
  public class DateChooserHearder extends SkinnableComponent
  {
    /**
     * @private
     */
    [SkinPart(required="false")]
    public var prevMonthButton:Button;
    /**
     * @private
     */
    [SkinPart(required="false")]
    public var nextMonthButton:Button;
    /**
     * @private
     */
    [SkinPart(required="false")]
    public var prevYearButton:Button;
    /**
     * @private
     */
    [SkinPart(required="false")]
    public var nextYearButton:Button;
    /**
     * @private
     */
    [SkinPart(required="false")]
    public var monthLabel:Label;
    /**
     * @private
     */
    [SkinPart(required="false")]
    public var yearLabel:Label;
    /**
     * @private
     */
    private var _month:String;
    private var _year:String;

    /**
     * Constuctor
     */
    public function DateChooserHearder()
    {
      super();
      if(getStyle("skinClass") == null)
        setStyle("skinClass", DateChooserHeaderSkin);
    }
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if(instance == prevMonthButton)
      {
        prevMonthButton.addEventListener(MouseEvent.CLICK, prevMonthClick);
      }
      if(instance == nextMonthButton)
      {
        nextMonthButton.addEventListener(MouseEvent.CLICK, nextMonthClick);
      }
      if(instance == prevYearButton)
      {
        prevYearButton.addEventListener(MouseEvent.CLICK, prevYearClick);
      }
      if(instance == nextYearButton)
      {
        nextYearButton.addEventListener(MouseEvent.CLICK, nextYearClick);
      }
      if(instance == monthLabel)
      {
        monthLabel.text = _month;
      }
      if(instance == yearLabel)
      {
        yearLabel.text = _year;
      }
    }
    /**
     * @private
     */
    private function prevMonthClick(event:Event):void
    {
      dispatchEvent(new MobileCalendarEvent(MobileCalendarEvent.PRV_MONTH_CLICKED))
    }
    /**
     * @private
     */
    private function nextMonthClick(event:Event):void
    {
      dispatchEvent(new MobileCalendarEvent(MobileCalendarEvent.NEXT_MONTH_CLICKED))
    }
    /**
     * @private
     */
    private function prevYearClick(event:Event):void
    {
      dispatchEvent(new MobileCalendarEvent(MobileCalendarEvent.PRV_YEAR_CLICKED))
    }
    /**
     * @private
     */
    private function nextYearClick(event:Event):void
    {
      dispatchEvent(new MobileCalendarEvent(MobileCalendarEvent.NEXT_YEAR_CLICKED))
    }
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      if(monthLabel)
      {
        monthLabel.text = _month;
      }
      if(yearLabel)
      {
        yearLabel.text = _year;
      }
    }
    
    /**
     * @private
     */
    public function set month(value:String):void
    {
      if(_month != value){
        _month = value;
        invalidateProperties();
      }
    }
    /**
     * @private
     */
    public function set year(value:String):void
    {
      if(_year != value){
        _year = value;
        invalidateProperties();
      }
    }
  }
}