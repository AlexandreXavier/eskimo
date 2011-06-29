package com.piaction.components
{
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    
    import mx.events.FlexEvent;
    import mx.graphics.GradientEntry;
    import mx.graphics.LinearGradient;
    
    import spark.components.LabelItemRenderer;
    import spark.components.RadioButton;
    import spark.primitives.Rect;

    public class RightRadioButtonRenderer extends LabelItemRenderer
    {
        public function RightRadioButtonRenderer()
        {
            super();
        }
        
        protected var radioButton : RadioButton;
        
        override protected function createChildren():void{
            super.createChildren();
            this.radioButton = new RadioButton();
            this.addChild(this.radioButton);
        }
        
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
            
            var radioButtonWidth : Number = this.getElementPreferredWidth(this.radioButton);
            var radioButtonHeight : Number = this.getElementPreferredHeight(this.radioButton);
            radioButtonHeight = Math.max(unscaledHeight, radioButtonHeight);
            setElementSize(this.radioButton, radioButtonWidth, radioButtonHeight);    
            
            var labelWidth:Number = unscaledWidth-radioButtonWidth;
            var labelHeight:Number = getElementPreferredHeight(labelDisplay);            
            setElementSize(this.labelDisplay, labelWidth, labelHeight);
            
            var padding:int = 10;
            this.setElementPosition(this.labelDisplay, padding, (radioButtonHeight - labelHeight) / 2);
            var labelAndGap:Number = this.labelDisplay.x + this.labelDisplay.width;
            this.setElementPosition(this.radioButton,labelAndGap - 2 * padding, 0);
            
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            radioButton.selected = selected;
        }
        
        /**
         *  Renders a background for the item renderer.
         */
        override protected function drawBackground(unscaledWidth:Number, 
                                          unscaledHeight:Number):void
        {
            //Colors of our gradient in the form of an array
            var colors:Array = [ 0xFFFFFF, 0x000000, 0xFFFFFF];
            //Store the Alpha Values in the form of an array
            var alphas:Array = [ 1, 1, 1];
            //Array of color distribution ratios.
            //The value defines percentage of the width where the color is sampled at 100%
            var ratios:Array = [ 0, 128, 255 ];
            
            var matrix:Matrix = new Matrix();
            // gradient overlay
            var linePadding:int = 2;
            matrix.createGradientBox(unscaledWidth - 2 * linePadding, unscaledHeight, 0, 0, 0 );
            
            graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
            graphics.drawRect(linePadding, unscaledHeight, unscaledWidth - 2 * linePadding, 1);
            graphics.endFill();
            
            // Selected and down states have a gradient overlay as well
            // as different separators colors/alphas
            if (down)
            {
                var colors_down:Array = [0x000000, 0x000000 ];
                var alphas_down:Array = [.2, .1];
                var ratios_down:Array = [ 0, 255 ];
                var matrix_down:Matrix = new Matrix();
                
                // gradient overlay
                matrix_down.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0 );
                graphics.beginGradientFill(GradientType.LINEAR, colors_down, alphas_down, ratios_down, matrix_down);
                graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
                graphics.endFill();
            }
        }
    }
}