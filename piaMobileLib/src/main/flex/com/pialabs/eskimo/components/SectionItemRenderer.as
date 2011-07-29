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
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.drawBackground(unscaledWidth, unscaledHeight);
      
      if (data is SectionTitleLabel)
      {
        var listOwner:List = (this.owner as List);
        
        var sectionBackgroundColor:uint = listOwner.getStyle("sectionBackgroundColor");
        if(sectionBackgroundColor == 0)
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
        
        var sectionTitleColor:int = listOwner.getStyle("sectionTitleColor");
        if(sectionTitleColor > 0)
        {
          labelDisplay.setStyle("color", sectionTitleColor);
        }
      }
      else
      {
        labelDisplay.setStyle("color", 0x000000);
      }
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      if (data is SectionTitleLabel) {
        var listOwner:List = (this.owner as List);
        var sectionTitleAlign:String = listOwner.getStyle("sectionTitleAlign");
        if(sectionTitleAlign)
        {
          labelDisplay.setStyle("textAlign", sectionTitleAlign);
        }
        var sectionHeight:int = listOwner.getStyle("sectionHeight");
        if(sectionHeight > 0)
        {
          this.height = sectionHeight;
        }
      }
      else
      {
        this.height = unscaledHeight;
      }
      
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
  }
}