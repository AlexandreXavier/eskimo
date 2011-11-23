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
  import spark.components.supportClasses.ViewNavigatorApplicationBase;
  import spark.components.supportClasses.ViewNavigatorBase;
  
  /**
   * The SplitViewApplication class is an application class meant to provide a simple framework for applications that employ a two-view-based navigation model.
   * The component is separated into two different viewNavigator (panelNavigator and contentNavigator).
   * This Class is designed to be used in tablet projects.
   *
   * @see com.pialabs.eskimo.components.SplitView
   */
  public class SplitViewApplication extends ViewNavigatorApplicationBase
  {
    /**
    * The splitView
    */
    public var splitViewNavigator:SplitView;
    
    /**
     * @private
     */
    protected var _panelNavigator:ViewNavigatorBase;
    /**
     * @private
     */
    protected var _contentNavigator:ViewNavigatorBase;
    /**
     * @private
     */
    private var _panelNavigatorChange:Boolean;
    /**
     * @private
     */
    private var _contentNavigatorChange:Boolean;
    
    /**
     * @private
     */
    public function SplitViewApplication()
    {
      super();
    
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      super.createChildren();
      
      splitViewNavigator = new SplitView();
      
      if (_panelNavigator)
      {
        splitViewNavigator.panelNavigator = _panelNavigator;
      }
      if (_contentNavigatorChange)
      {
        splitViewNavigator.contentNavigator = _contentNavigator;
      }
      
      this.addElement(splitViewNavigator);
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_panelNavigatorChange)
      {
        splitViewNavigator.panelNavigator = _panelNavigator;
        _panelNavigatorChange = false;
      }
      if (_contentNavigatorChange)
      {
        splitViewNavigator.contentNavigator = _contentNavigator;
        _contentNavigatorChange = false;
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      splitViewNavigator.width = unscaledWidth;
      splitViewNavigator.height = unscaledHeight;
    }
    
    /**
     * View navigator for content
     */
    public function set panelNavigator(value:ViewNavigatorBase):void
    {
      _panelNavigator = value;
      
      _panelNavigatorChange = true;
      invalidateProperties();
    }
    
    /**
     * @private
     */
    public function get panelNavigator():ViewNavigatorBase
    {
      return _panelNavigator;
    }
    
    /**
     * View navigator for content
     */
    public function set contentNavigator(value:ViewNavigatorBase):void
    {
      _contentNavigator = value;
      
      _contentNavigatorChange = true;
      
      invalidateProperties();
    }
    
    /**
     *  @private
     */
    public function get contentNavigator():ViewNavigatorBase
    {
      return _contentNavigator;
    }
    
    /**
     *  @private
     */
    override protected function saveNavigatorState():void
    {
      super.saveNavigatorState();
      
      if (contentNavigator)
      {
        persistenceManager.setProperty("contentNavigatorState", contentNavigator.saveViewData());
      }
      if (panelNavigator)
      {
        persistenceManager.setProperty("panelNavigatorState", panelNavigator.saveViewData());
      }
    }
    
    /**
     * @private
     */
    override protected function loadNavigatorState():void
    {
      super.loadNavigatorState();
      
      var savedState:Object = persistenceManager.getProperty("contentNavigatorState");
      
      if (savedState)
      {
        contentNavigator.loadViewData(savedState);
      }
      
      savedState = persistenceManager.getProperty("panelNavigatorState");
      
      if (savedState)
      {
        panelNavigator.loadViewData(savedState);
      }
    }
  }
}
