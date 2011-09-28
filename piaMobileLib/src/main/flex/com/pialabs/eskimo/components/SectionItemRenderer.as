package com.pialabs.eskimo.components
{
  import com.pialabs.eskimo.data.SectionTitleLabel;
  
  import flash.display.GradientType;
  import flash.geom.Matrix;
  
  import spark.components.IconItemRenderer;
  import spark.components.List;
  
  
  /**
   *  The SectionItemRenderer class displays a different background color, height
   *  and text align for SectionTitleLabel. Used in the
   *  list-based control.
   */
  public class SectionItemRenderer extends IconItemRenderer implements ISectionRenderer
  {
    private var _isSectionTitle:Boolean;
    
    public function SectionItemRenderer()
    {
      super();
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
      
      if (_isSectionTitle)
      {
        var listOwner:List = (this.owner as List);
        
        var sectionBackgroundColor:uint = getStyle("backgroundColor");
        
        var colors:Array = [0, 0];
        var alphas:Array = [0.2, 0];
        var ratios:Array = [0, 255];
        var matrix:Matrix = new Matrix();
        
        // opaque background
        graphics.beginFill(sectionBackgroundColor);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
        
        // gradient overlay
        matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
        graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
      }
      else
      {
        super.drawBackground(unscaledWidth, unscaledHeight);
      }
    
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
    
    public function get isSectionTitle():Boolean
    {
      return _isSectionTitle;
    }
    
    public function set isSectionTitle(value:Boolean):void
    {
      _isSectionTitle = value;
    }
  }
}
