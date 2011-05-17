package com.piaction.components
{
  import flash.events.Event;
  
  import mx.states.State;
  
  import spark.components.Group;
  import spark.components.Label;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.core.IDisplayText;
  import com.piaction.skins.CalendarItemSkin;
  
  /**
   * Calendar item
   */
  public class CalendarItem extends SkinnableComponent
  {
    /**
     * Normal State
     */
    public static var NORMAL_STATE:String = "normal";
    /**
     * Highlight state
     */
    public static var HIGHLIGHT_STATE:String = "highlight";
    
    /**
     * Label display for the summary
     */
    [SkinPart(required="true")]
    public var _label:IDisplayText;
    
    /**
     * Header Label display for the dates information
     */
    [SkinPart(required="true")]
    public var headerLabel:IDisplayText;
    
    /**
     * @private
     */
    private var _text:String;
    
    private var _startDate:Date;
    
    private var _endDate:Date;
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      if(_label)
      {
        _label.text = _text;
      }
      if(headerLabel)
      {
        headerLabel.text = computeHeaderLabel(_startDate, _endDate);
      }
      super.commitProperties();
    }
    
    /**
     * End date of the item
     */
    public function get endDate():Date
    {
      return _endDate;
    }
    /**
     * @private
     */
    public function set endDate(value:Date):void
    {
      if( _endDate !== value)
      {
        _endDate = value;
        invalidateProperties();
      }
    }
    
    /**
     * Start date of the item
     */
    public function get startDate():Date
    {
      return _startDate;
    }
    /**
     * @private
     */
    public function set startDate(value:Date):void
    {
      if( _startDate !== value)
      {
        _startDate = value;
        invalidateProperties();
      }
    }
    
    /**
     * The summary of the item
     */
    public function get text():String
    {
      return _text;
    }
    
    /**
     * @private
     */
    public function set text(value:String):void
    {
      if( _text !== value)
      {
        _text = value;
        
        invalidateProperties();
      }
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      if(_label == instance)
      {
        _label.text = text;
      }
      if(headerLabel == instance)
      {
        headerLabel.text = computeHeaderLabel(_startDate, _endDate);
      }
    }
    
    /**
     * @private
     */
    public function computeHeaderLabel(date:Date, endDate:Date):String
    {
      if(!date) return "";
      
      return dateLabel(date)+" - "+dateLabel(endDate);
    }
    
    /**
     * @private
     */
    public function dateLabel(date:Date):String
    {
      if(!date) return "";
      
      var hStr:String = "" + date.hours;
      var mStr:String = date.minutes>9 ? "" + date.minutes : "0" + date.minutes;
      return hStr+":"+mStr;
    }
    
    /**
     * Constructor
     */
    public function CalendarItem(text:String, startDate:Date, endDate:Date)
    {
      this.setStyle("skinClass", CalendarItemSkin);
      this.text = text;
      this.startDate = startDate;
      this.endDate = endDate;
      
      states = [new State({name:NORMAL_STATE}), new State({name:HIGHLIGHT_STATE})];
      
      
    }
    
    /**
     * Highlight the item
     */
    public function set highlight(value:Boolean):void
    {
      if (value)
      {
        currentState = HIGHLIGHT_STATE;
      }
      else
      {
        currentState = NORMAL_STATE;
      }
      invalidateSkinState();
    }
    /**
     * Know if the text is truncated
     */
    public function isTruncated():Boolean
    {
      return _label.isTruncated;
    }
    /**
     * @private
     */
    protected override function getCurrentSkinState():String
    {
      return currentState;
    }
    /**
     * @private
     */
    public function compareTo(item:Object, startTimeField:String, endTimeField:String, textField:String):Boolean
    {
      return this.startDate.time == item[startTimeField].time && 
        this.endDate.time == item[endTimeField].time && 
        this.text == item[textField];
    }
    
  }
}