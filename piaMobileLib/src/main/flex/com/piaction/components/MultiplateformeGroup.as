package com.piaction.components
{
    import flash.system.Capabilities;
    
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    
    import spark.components.Group;
    
    /**
     * Group container that render children for a specfic plateforme (ios, android, qnx).
     */
    public class MultiplateformeGroup extends Group
    {
        /**
         * IOS plateforme
         */
        public static const IOS:String = "IOS";
        /**
         * Android plateforme
         */
        public static const ANDROID:String = "AND";
        /**
         * QNX plateforme
         */
        public static const QNX:String = "QNX";
        
        /**
         * @private
         */
        protected var _type:String = ANDROID;
        
        /**
         * @private
         */
        protected var _typeChanged:Boolean = true;
        
        /**
         * @private
         */
        protected var _systemType:String;
        
        /**
         * @private
         */
        protected var _switchable:Boolean;
        
        /**
         * @private
         */
        protected var _childrens:Vector.<UIComponent> = new Vector.<UIComponent>();
        
        /**
         * @private
         */
        public function MultiplateformeGroup()
        {
            super();
            
            _systemType = Capabilities.version.substr(0, 3).toLocaleUpperCase();
        }
        
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (_typeChanged)
            {
                if (_systemType != _type)
                {
                    saveChildrens();
                    includeInLayout = visible = false;
                }
                else if (_systemType == _type)
                {
                    while (_childrens.length > 0)
                    {
                        addElement(_childrens.shift());
                    }
                    includeInLayout = visible = true;
                }
                
                _typeChanged = false;
            }
        }
        
        /**
         * @private
         */
        protected function saveChildrens():void
        {
            while (numChildren > 0)
            {
                var visualElement:IVisualElement = removeElementAt(0);
                
                if (_switchable)
                {
                    _childrens.push(visualElement);
                }
            }
        }
        
        [Inspectable(category = "General", enumeration = "IOS,AND,QNX", defaultValue = "AND")]
        /**
         * Select the plateforme
         */
        public function set type(value:String):void
        {
            if (value != _type)
            {
                _type = value;
                
                _typeChanged = true;
                
                invalidateProperties();
            }
        }
        
        /**
         * @private
         */
        public function get type():String
        {
            return _type;
        }
        
        /**
         * @private
         */
        override public function addElementAt(element:IVisualElement, index:int):IVisualElement
        {
            if (_systemType == _type)
            {
                return super.addElementAt(element, index);
            }
            else
            {
                _childrens.splice(index, 0, element);
            }
            return element;
        }
        
        /**
         * @private
         */
        public function set switchable(value:Boolean):void
        {
            _switchable = value;
        }
        
        /**
         * @private
         */
        public function get switchable():Boolean
        {
            return _switchable;
        }
    
    
    }
}
