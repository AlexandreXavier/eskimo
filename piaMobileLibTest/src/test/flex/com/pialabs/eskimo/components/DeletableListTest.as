package com.pialabs.eskimo.components
{
    import com.pialabs.eskimo.controls.SkinnableAlert;
    
    import flexunit.framework.Assert;
    
    import mx.collections.ArrayCollection;
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    
    import org.fluint.uiImpersonation.UIImpersonator;
    
    public class DeletableListTest
    {
        private var _list:DeletableList;
        
        [Before(ui)]
        public function setUp():void
        {
            _list = new DeletableList();
            UIImpersonator.addChild(_list);
            
            _list.dataProvider = new ArrayCollection([{label: "1"}, {label: "2"}, {label: "3"}, {label: "4"}
                                                       , {label: "5"}]);
        }
        
        [After(ui)]
        public function tearDown():void
        {
            UIImpersonator.removeChild(_list);
            _list = null;
        }
        
        [Test]
        public function changeStateTest():void
        {
            _list.editionMode = true;
            
            _list.validateNow();
            if (_list.dataGroup)
            {
                for (var i:int = 0; i < _list.dataGroup.numElements; i++)
                {
                    var itemRenderer:IVisualElement = _list.dataGroup.getElementAt(i);
                    if (itemRenderer != null)
                    {
                        (itemRenderer as UIComponent).validateNow();
                        Assert.assertEquals((itemRenderer as UIComponent).currentState, "edition");
                    }
                }
            }
        }
    }
}
