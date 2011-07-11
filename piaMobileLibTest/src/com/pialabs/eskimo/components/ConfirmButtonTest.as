package com.pialabs.eskimo.components
{
    import com.pialabs.eskimo.tool.PropertyData;
    import com.pialabs.eskimo.tool.TestHelper;
    import com.pialabs.eskimo.events.ConfirmEvent;
    
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    
    import org.fluint.sequence.SequenceCaller;
    import org.fluint.sequence.SequenceRunner;
    import org.fluint.sequence.SequenceWaiter;
    import org.fluint.uiImpersonation.UIImpersonator;
    
    public class ConfirmButtonTest
    {
        private var _confirmButton:ConfirmButton;
        
        [Before(ui)]
        public function setUp():void
        {
            _confirmButton = new ConfirmButton();
            UIImpersonator.addChild(_confirmButton);
        }
        
        [After(ui)]
        public function tearDown():void
        {
            UIImpersonator.removeChild(_confirmButton);
            _confirmButton = null;
        }
        
        [Test(async)]
        public function stateTest():void
        {
            var sequence:SequenceRunner = new SequenceRunner(this);
            
            // initial state
            var normalState:PropertyData = new PropertyData('currentState', ConfirmButton.NORMAL_STATE);
            
            sequence.addStep(new SequenceWaiter(_confirmButton, FlexEvent.UPDATE_COMPLETE, 1500));
            sequence.addStep(new SequenceCaller(_confirmButton, TestHelper.handleVerifyProperty, [normalState
                                                                                                  , _confirmButton]));
            
            // confirmation state
            var confirmationState:PropertyData = new PropertyData('currentState', ConfirmButton.CONFIRMATION_STATE);
            
            sequence.addStep(new SequenceCaller(_confirmButton, dispatchMouseClickOnButton));
            sequence.addStep(new SequenceWaiter(_confirmButton, ConfirmEvent.ENTER_CONFIRMATION, 1500));
            sequence.addStep(new SequenceCaller(_confirmButton, TestHelper.handleVerifyProperty, [confirmationState
                                                                                                  , _confirmButton]));
            
            // Cancel
            sequence.addStep(new SequenceWaiter(_confirmButton, FlexEvent.UPDATE_COMPLETE, 1500));
            sequence.addStep(new SequenceCaller(_confirmButton, dispatchMouseClickOnCancelButton));
            sequence.addStep(new SequenceWaiter(_confirmButton, ConfirmEvent.CANCEL, 1500));
            sequence.addStep(new SequenceCaller(_confirmButton, TestHelper.handleVerifyProperty, [normalState
                                                                                                  , _confirmButton]));
            sequence.run();
        }
        
        protected function dispatchMouseClickOnButton():void
        {
            _confirmButton.button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        
        protected function dispatchMouseClickOnCancelButton():void
        {
            _confirmButton.cancelButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
    
    }
}
