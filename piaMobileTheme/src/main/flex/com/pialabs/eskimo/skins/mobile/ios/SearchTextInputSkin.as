package com.pialabs.eskimo.skins.mobile.ios
{
    import com.pialabs.eskimo.skins.mobile.ios.assets.TextInput_border;
    
    import flash.display.DisplayObject;
    
    import spark.filters.DropShadowFilter;
    import spark.skins.mobile.TextInputSkin;
    
    [Style(name = "icon", inherit = "no", type = "Class")]
    public class SearchTextInputSkin extends spark.skins.mobile.TextInputSkin
    {
        private var _icon:DisplayObject;
        private var _iconClass:Class;
        
        public function SearchTextInputSkin()
        {
            super();
            layoutCornerEllipseSize = 32;
            borderClass = com.pialabs.eskimo.skins.mobile.ios.assets.TextInput_border;
            
            filters = [new DropShadowFilter(4, 90, 0, 0.5, 4, 4, 1, 1, true)];
        
        }
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            
            _iconClass = getStyle("icon");
        }
        
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            if (!_icon && _iconClass)
            {
                _icon = new _iconClass();
                addChild(_icon);
            }
            
            
            // position & size the text
            var paddingLeft:Number = getStyle("paddingLeft");
            var paddingRight:Number = getStyle("paddingRight");
            var paddingTop:Number = getStyle("paddingTop");
            var paddingBottom:Number = getStyle("paddingBottom");
            
            var iconWidth:int = unscaledHeight - paddingTop - paddingTop;
            var textDisplayWidth:int = unscaledWidth - paddingLeft - paddingRight - iconWidth;
            
            if (_icon)
            {
                setElementSize(_icon, iconWidth, iconWidth);
                setElementPosition(_icon, paddingLeft, (unscaledHeight - iconWidth) / 2);
            }
            
            super.textDisplay.x = paddingLeft + iconWidth;
            super.textDisplay.width = textDisplayWidth;
            
            if (super.promptDisplay)
            {
                super.promptDisplay.x = paddingLeft + iconWidth;
                super.promptDisplay.width = textDisplayWidth;
            }
        }
    }
}
