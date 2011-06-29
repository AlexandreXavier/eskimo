package com.piaction.components
{
    import com.piaction.controls.SkinnableAlert;
    import com.piaction.events.ContextableListEvent;
    
    import flash.display.InteractiveObject;
    import flash.events.MouseEvent;
    
    import flexunit.framework.Assert;
    
    import mx.collections.ArrayCollection;
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    
    import org.fluint.sequence.SequenceCaller;
    import org.fluint.sequence.SequenceRunner;
    import org.fluint.sequence.SequenceWaiter;
    import org.fluint.uiImpersonation.UIImpersonator;
    
    public class ContextableListTest
    {
        private var _list:ContextableList;
        
        [Before(ui)]
        public function setUp():void
        {
            _list = new ContextableList();
            UIImpersonator.addChild(_list);
            
            _list.dataProvider = new ArrayCollection([{label: "1"}, {label: "2"}, {label: "3"}, {label: "4"}
                                                       , {label: "5"}]);
            
            _list.contextMenuItems = ["1", "2", "3", "4"]
        }
        
        [After(ui)]
        public function tearDown():void
        {
            UIImpersonator.removeChild(_list);
            _list = null;
        }
        
        [Test(async)]
        public function openContextMenu():void
        {
            _list.useVirtualLayout = false;
            _list.validateNow();
            
            var sequence:SequenceRunner = new SequenceRunner(this);
            
            sequence.addStep(new SequenceWaiter(_list, ContextableListEvent.ITEM_LONG_PRESS, 1500));
            
            sequence.run();
            
            var firstElement:IVisualElement = _list.dataGroup.getElementAt(0);
            var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN, false, false, 0, 0, firstElement as InteractiveObject, false, false, false, true, 0);
            firstElement.dispatchEvent(mouseEvent);
        }
    
    }
}
