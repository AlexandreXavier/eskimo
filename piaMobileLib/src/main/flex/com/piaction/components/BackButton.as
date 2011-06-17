package com.piaction.components
{
    import flash.system.Capabilities;
    
    import spark.components.Button;
    
    public class BackButton extends Button
    {
        public function BackButton()
        {
            visible = super.visible;
        }
        
        override public function set visible(value:Boolean):void
        {
            if (Capabilities.version.substr(0, 3) == "AND")
            {
                super.visible = false;
            }
            else
            {
                super.visible = value;
            }
        }
    }
}
