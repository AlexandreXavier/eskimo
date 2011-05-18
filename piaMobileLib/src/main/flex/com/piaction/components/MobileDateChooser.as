package com.piaction.components
{
  import com.piaction.skins.DateChooserHeaderSkin;
  import com.piaction.events.MobileCalendarEvent;
  
  import flash.events.Event;
  
  import mx.containers.Canvas;
  import mx.controls.DateChooser;
  import mx.core.UITextField;
  import mx.core.mx_internal;
  import mx.events.FlexEvent;
  
  use namespace mx_internal;
  
  /**
  * Alpha of the grid overlay
  */
  [Style(name="gridAlpha", inherit="no", type="Number")]
  /**
   * Color of the grid overlay
   */
  [Style(name="gridColor", inherit="no", type="uint")]
  
  /**
   * MobileDateChosser is a date chooser for mobile extending mx DateChooser
   */
  public class MobileDateChooser extends DateChooser
  {
    /**
     * @private
     */
    private var customHeader:DateChooserHearder = new DateChooserHearder();
    /**
     * @private
     */
    private var overlayLayer:Canvas = new Canvas();
    
    /**
     * Header height
     */
    public static var HEADER_HEIGHT:int = 50;
    
    /**
    * @private
    */
    override protected function createChildren():void {
      super.createChildren();
      monthDisplay.explicitHeight = HEADER_HEIGHT - 8; // 92 + 8 = 100
      super.measure();
      
      customHeader.width = this.width;
      customHeader.height = HEADER_HEIGHT;

      customHeader.addEventListener(MobileCalendarEvent.NEXT_MONTH_CLICKED, goToNextMonth);
      customHeader.addEventListener(MobileCalendarEvent.PRV_MONTH_CLICKED, goToPreviousMonth);
      customHeader.addEventListener(MobileCalendarEvent.NEXT_YEAR_CLICKED, goToNextYear);
      customHeader.addEventListener(MobileCalendarEvent.PRV_YEAR_CLICKED, goToPreviousYear);
      
      addChild(customHeader);
      
      addChild(overlayLayer);
      
      
      for(var i:int=0;i <7;i++){
        var foo:UITextField = mx_internal::dateGrid.dayBlocksArray[i][0] as UITextField;
        foo.background=true;
        foo.backgroundColor=0xDDDDDD;
      }
      
      dateGrid.setStyle("paddingTop", 0);
      dateGrid.setStyle("paddingRight", 0);
      dateGrid.setStyle("paddingBottom", 0);
      dateGrid.setStyle("paddingLeft", 0);
      
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      customHeader.width = this.width;
      customHeader.height = HEADER_HEIGHT;
      
      
      if(customHeader.yearLabel != null)
      {
        customHeader.yearLabel.text = yearDisplay.text;
      }
      if(customHeader.monthLabel != null)
      {
        customHeader.monthLabel.text = monthDisplay.text;
      }
      
      setChildIndex(overlayLayer, numChildren-1);
      overlayLayer.width = width;
      overlayLayer.height = height;
      
      overlayLayer.graphics.clear();
      
      var color:uint = getStyle("gridColor");
      var alpha:Number = getStyle("gridAlpha");
      overlayLayer.graphics.lineStyle(1, color, alpha);
      
      var calendarHeight:Number = dateGrid.height;
      var calendarWidth:Number = dateGrid.width;
        for(var i:int=0; i<7; i++)
        {
          overlayLayer.graphics.moveTo(0, i * calendarHeight/7 + HEADER_HEIGHT);
          overlayLayer.graphics.lineTo(calendarWidth + 1, i * calendarHeight/7 + HEADER_HEIGHT );
        }
        for(i=1; i<7; i++)
        {
          overlayLayer.graphics.moveTo(i * calendarWidth/7 + 1, HEADER_HEIGHT + 1 );
          overlayLayer.graphics.lineTo(i * calendarWidth/7 + 1, calendarHeight + HEADER_HEIGHT );
        }
      overlayLayer.graphics.endFill();
    }
    /**
     * Go to previous year
     */
    public function goToPreviousYear(event:MobileCalendarEvent = null):void
    {
      downYearButton.dispatchEvent(new Event(FlexEvent.BUTTON_DOWN));
    }
    /**
     * Go to next year
     */
    public function goToNextYear(event:MobileCalendarEvent = null):void
    {
      upYearButton.dispatchEvent(new Event(FlexEvent.BUTTON_DOWN));
    }
    /**
     * Go to previous month
     */
    public function goToPreviousMonth(event:MobileCalendarEvent = null):void
    {
      backMonthButton.dispatchEvent(new Event(FlexEvent.BUTTON_DOWN));
    }
    /**
     * Go to next month
     */
    public function goToNextMonth(event:MobileCalendarEvent = null):void
    {
      fwdMonthButton.dispatchEvent(new Event(FlexEvent.BUTTON_DOWN));
    }
  }
}