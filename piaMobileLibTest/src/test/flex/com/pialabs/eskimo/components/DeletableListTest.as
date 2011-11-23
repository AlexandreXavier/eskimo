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
