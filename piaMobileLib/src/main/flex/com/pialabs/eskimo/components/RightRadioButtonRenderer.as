package com.pialabs.eskimo.components
{
  import flash.display.GradientType;
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  
  import mx.events.ItemClickEvent;
  
  import spark.components.LabelItemRenderer;
  import spark.components.RadioButton;
  
  /**
   *  The RightRadioButtonRenderer class defines the radio item renderer
   *  This contains a text component and a right-align radio button.
   */
  public class RightRadioButtonRenderer extends LabelItemRenderer
  {
    public function RightRadioButtonRenderer()
    {
      super();
      addEventListener(MouseEvent.CLICK, clickHandler);
    }
    
    protected var radioButton:RadioButton;
    
    override protected function createChildren():void
    {
      super.createChildren();
      this.radioButton = new RadioButton();
      this.addChild(this.radioButton);
    }
    
    protected function clickHandler(evt:MouseEvent):void
    {
      var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK, true);
      e.item = data;
      e.index = itemIndex;
      dispatchEvent(e);
    }
    
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      
      var radioButtonWidth:Number = this.getElementPreferredWidth(this.radioButton);
      var radioButtonHeight:Number = this.getElementPreferredHeight(this.radioButton);
      radioButtonHeight = Math.max(unscaledHeight, radioButtonHeight);
      setElementSize(this.radioButton, radioButtonWidth, radioButtonHeight);
      
      var labelWidth:Number = unscaledWidth - radioButtonWidth;
      var labelHeight:Number = getElementPreferredHeight(labelDisplay);
      setElementSize(this.labelDisplay, labelWidth, labelHeight);
      
      var padding:int = 10;
      this.setElementPosition(this.labelDisplay, padding, (radioButtonHeight - labelHeight) / 2);
      var labelAndGap:Number = this.labelDisplay.x + this.labelDisplay.width;
      this.setElementPosition(this.radioButton, labelAndGap - 2 * padding, 0);
    
    }
    
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      radioButton.selected = selected;
    }
    
    /**
     *  Renders a background for the item renderer.
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      var colors:Array = [0x000000, 0x000000, 0x000000];
      
      var alphas:Array = [0, 0.7, 0];
      
      //Array of color distribution ratios.
      //The value defines percentage of the width where the color is sampled at 100%
      var ratios:Array = [0, 128, 255];
      
      var matrix:Matrix = new Matrix();
      // gradient overlay
      var linePadding:int = 2;
      matrix.createGradientBox(unscaledWidth - 2 * linePadding, unscaledHeight, 0, 0, 0);
      
      graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
      graphics.drawRect(linePadding, unscaledHeight, unscaledWidth - 2 * linePadding, 1);
      graphics.endFill();
      
      // Down state have a gradient overlay
      if (down)
      {
        var colors_down:Array = [0x000000, 0x000000];
        var alphas_down:Array = [.2, .1];
        var ratios_down:Array = [0, 255];
        var matrix_down:Matrix = new Matrix();
        
        // gradient overlay
        matrix_down.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
        graphics.beginGradientFill(GradientType.LINEAR, colors_down, alphas_down, ratios_down, matrix_down);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
      }
    }
  }
}
