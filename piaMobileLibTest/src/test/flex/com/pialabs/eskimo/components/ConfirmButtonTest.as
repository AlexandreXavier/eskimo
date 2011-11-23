/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
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
