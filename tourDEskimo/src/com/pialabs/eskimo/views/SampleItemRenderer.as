package com.pialabs.eskimo.views
{
  import spark.components.IconItemRenderer;
  
  public class SampleItemRenderer extends IconItemRenderer
  {
    [Embed(source = "assets/icon/fleche.png")]
    private var _decorator:Class;
    
    public function SampleItemRenderer()
    {
      super();
      decorator = _decorator;
    }
  }
}
