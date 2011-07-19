package com.pialabs.eskimo.components
{
  
  import flash.events.MouseEvent;
  
  import mx.core.FlexGlobals;
  import mx.events.ItemClickEvent;
  import mx.styles.CSSStyleDeclaration;
  
  import spark.components.LabelItemRenderer;
  import spark.components.RadioButton;
  import spark.components.RadioButtonGroup;
  import spark.components.supportClasses.ItemRenderer;
  
  /**
   *  The RadioButtonItemRenderer class defines the radio item renderer
   *  This is a simple item renderer with a single radio button component.
   *
   *  @see com.pialabs.eskimo.components.UniqueChoiceList
   */
  public class RadioButtonItemRenderer extends ItemRenderer
  {
    protected var radioButton:RadioButton;
    
    protected var padding:int = 0;
    
    public function RadioButtonItemRenderer()
    {
      this.showsCaret = false;
      autoDrawBackground = false;
      addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
    }
    
    protected function clickHandler(evt:MouseEvent):void
    {
      var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK, true);
      e.item = data;
      e.index = itemIndex;
      dispatchEvent(e);
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      
      if (radioButton == null)
      {
        radioButton = new RadioButton();
        
        addElement(radioButton);
      }
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      var buttonHeight:int = radioButton.getPreferredBoundsHeight();
      
      radioButton.setLayoutBoundsSize(unscaledWidth - 2 * padding, buttonHeight);
      radioButton.setLayoutBoundsPosition(padding, (unscaledHeight - buttonHeight) / 2);
    }
    
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      radioButton.selected = selected;
      radioButton.label = label;
    }
    
    override public function set data(value:Object):void
    {
      super.data = value;
      
      invalidateProperties();
    }
  
  }
}
