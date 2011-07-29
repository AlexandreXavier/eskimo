package com.pialabs.eskimo.components
{
  import com.pialabs.eskimo.data.SectionTitleLabel;
  
  import flash.display.GradientType;
  import flash.geom.Matrix;
  
  import spark.components.LabelItemRenderer;
  import spark.components.List;
  import spark.layouts.HorizontalAlign;
  
  public class SectionItemRenderer extends LabelItemRenderer
  {
    public function SectionItemRenderer()
    {
      super();
    }
    
    public var sectionTitleColor:int;
    
    public var sectionHeight:int;
    
    public var sectionTitleAlign:String;
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.drawBackground(unscaledWidth, unscaledHeight);
      
      if (data is SectionTitleLabel)
      {
        var listOwner:List = (this.owner as List);
        
        var sectionBackgroundColor:uint = listOwner.getStyle("sectionBackgroundColor");
        if (sectionBackgroundColor == 0)
        {
          sectionBackgroundColor = 0xC0C0C0;
        }
        
        var colors:Array = [sectionBackgroundColor, sectionBackgroundColor];
        var alphas:Array = [.6, .4];
        var ratios:Array = [0, 255];
        var matrix:Matrix = new Matrix();
        
        // gradient overlay
        matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
        graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
      }
      
      labelDisplay.setStyle("color", sectionTitleColor);
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      labelDisplay.setStyle("textAlign", sectionTitleAlign);
      
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    override protected function measure():void
    {
      super.measure();
      
      height = sectionHeight;
    }
  }
}
