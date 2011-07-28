package com.pialabs.eskimo.components
{
  import flash.display.StageOrientation;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.StageOrientationEvent;
  import flash.system.Capabilities;
  
  import mx.core.mx_internal;
  import mx.events.FlexEvent;
  
  import spark.components.Button;
  import spark.components.Group;
  import spark.components.View;
  import spark.components.ViewNavigator;
  import spark.components.supportClasses.SkinnableComponent;
  import spark.components.supportClasses.ViewDescriptor;
  import spark.components.supportClasses.ViewNavigatorBase;
  
  use namespace mx_internal;
  
  /**
  * Style name for panel button.
  * @default "splitViewPanelButtonStyle";
  */
  [Style(name = "panelButtonStyleName", inherit = "no", type = "String")]
  
  [SkinState("portrait")]
  [SkinState("portraitWithPanel")]
  [SkinState("landscape")]
  
  /**
  * Component with two ViewNavgator.
  * @see com.pialabs.eskimo.components.SplitViewNavigatorApplication
  */
  public class SplitView extends SkinnableComponent
  {
    [SkinPart(required = "true")]
    public var panelGroup:Group;
    
    [SkinPart(required = "true")]
    public var contentGroup:Group;
    
    /**
    * @private
    */
    public var panelButton:Button;
    
    /**
     * @private
     */
    private var _panelNavigator:ViewNavigatorBase;
    /**
     * @private
     */
    private var _contentNavigator:ViewNavigatorBase;
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
    private var _panelVisible:Boolean;
    /**
     * @private
     */
    protected var _isLandscape:Boolean;
    /**
     * @private
     */
    private var _panelButtonLabel:String = "Panel";
    /**
     * @private
     */
    protected var _currentContentView:View;
    /**
     * @private
     */
    protected var _panelWidth:Number = 320;
    
    
    
    /**
     * Constructor
     */
    public function SplitView()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      super.createChildren();
      
      panelButton = new Button();
      panelButton.label = _panelButtonLabel;
      panelButton.addEventListener(MouseEvent.CLICK, onPanelClick);
    }
    
    /**
     * @private
     */
    private function onAddedToStage(event:Event):void
    {
      var currentOS:String = Capabilities.version;
      if (currentOS.lastIndexOf("AND") != -1)
      {
        stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange);
      }
      
      else
      {
        stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging);
      }
    }
    
    /**
     * @private
     */
    private function onRemovedToStage(event:Event):void
    {
      var currentOS:String = Capabilities.version;
      if (currentOS.lastIndexOf("AND") != -1)
      {
        stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange);
      }
      
      else
      {
        stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging);
      }
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      if (instance == panelGroup)
      {
        if (_panelNavigator == null)
        {
          _panelNavigator = new ViewNavigator();
        }
        
        _panelNavigatorChange: true;
      }
      else if (instance == contentGroup)
      {
        if (_contentNavigator == null)
        {
          _contentNavigator = new ViewNavigator();
        }
        
        _contentNavigatorChange = true;
      }
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      _panelNavigator.width = _panelWidth;
      
      if (_panelNavigatorChange)
      {
        _panelNavigator.percentWidth = 100;
        _panelNavigator.percentHeight = 100;
        
        panelGroup.removeAllElements();
        panelGroup.addElement(_panelNavigator);
        
        _panelNavigatorChange = false;
      }
      if (_contentNavigatorChange)
      {
        _contentNavigator.percentWidth = 100;
        _contentNavigator.percentHeight = 100;
        
        contentGroup.removeAllElements();
        contentGroup.addElement(_contentNavigator);
        
        // TODO find a way to use "viewChangeStart" event... instead of Event.ADDED
        //_contentNavigator.addEventListener("viewChangeStart", onViewChange);
        
        _contentNavigator.addEventListener(Event.ADDED, onViewChange);
        
        _contentNavigatorChange = false;
      }
      
      panelButton.styleName = getStyle("panelButtonStyleName");
      
      panelButton.visible = panelButton.includeInLayout = !_isLandscape;
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      panelButton.label = _panelButtonLabel;
    }
    
    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
      var skinState:String;
      
      if (_isLandscape)
      {
        skinState = "landscape";
      }
      else
      {
        skinState = _panelVisible ? "portraitWithPanel" : "portrait";
      }
      
      return skinState;
    }
    
    /**
     * @private
     */
    protected function onPanelClick(event:Event):void
    {
      if (_panelVisible)
      {
        hidePanel();
      }
      else
      {
        showPanel();
      }
    }
    
    /**
     * @private
     */
    private function onViewChange(event:Event):void
    {
      var viewDescriptor:ViewDescriptor = _contentNavigator.navigationStack.topView;
      
      if (viewDescriptor && event.target is viewDescriptor.viewClass)
      {
        if (viewDescriptor && viewDescriptor.instance)
        {
          _currentContentView = viewDescriptor.instance;
          
          if (_currentContentView.navigationContent == null)
          {
            _currentContentView.navigationContent = [];
          }
          var navigationContent:Array = _currentContentView.navigationContent;
          navigationContent.unshift(panelButton);
          _currentContentView.navigationContent = navigationContent;
          
        }
        invalidateDisplayList();
      }
    }
    
    /**
     * @private
     */
    private function onOrientationChanging(event:Event):void
    {
      var orientation:String = stage.orientation;
      
      if (getOrientation())
      {
        _panelVisible = false;
        _isLandscape = true;
      }
      else
      {
        _isLandscape = false;
      }
      invalidateSkinState();
      invalidateDisplayList();
    }
    
    /**
     * @private
     * For Android
     */
    private function onOrientationChange(event:Event):void
    {
      var orientation:String = stage.orientation;
      
      if (getOrientation())
      {
        _isLandscape = false;
      }
      else
      {
        _panelVisible = false;
        _isLandscape = true;
      }
      invalidateSkinState();
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function getOrientation():Boolean
    {
      return stage.stageHeight > stage.stageWidth;
    }
    
    /**
     * View navigator for panel
     */
    public function get panelNavigator():ViewNavigatorBase
    {
      return _panelNavigator;
    }
    
    /**
     * @private
     */
    public function set panelNavigator(value:ViewNavigatorBase):void
    {
      _panelNavigator = value;
      
      _panelNavigatorChange = true;
      
      invalidateDisplayList();
    }
    
    /**
     * View navigator for content
     */
    public function get contentNavigator():ViewNavigatorBase
    {
      return _contentNavigator;
    }
    
    /**
     * @private
     */
    public function set contentNavigator(value:ViewNavigatorBase):void
    {
      _contentNavigator = value;
      
      _contentNavigatorChange = true;
      
      invalidateDisplayList();
    }
    
    /**
     * Show the panel in portrait mode
     */
    public function showPanel():void
    {
      _panelVisible = true;
      invalidateSkinState();
    }
    
    /**
     * Hide the panel in portrait mode
     */
    public function hidePanel():void
    {
      _panelVisible = false;
      invalidateSkinState();
    }
    
    [Bindable(event = "panelButtonLabelChange")]
    /**
     * Panel button label
     */
    public function get panelButtonLabel():String
    {
      return _panelButtonLabel;
    }
    
    /**
     * @private
     */
    public function set panelButtonLabel(value:String):void
    {
      _panelButtonLabel = value;
      invalidateProperties();
      
      dispatchEvent(new Event("panelButtonLabelChange"));
    }
    
    [Bindable(event = "panelWidthChange")]
    /**
     * Panel Width
     */
    public function get panelWidth():Number
    {
      return _panelWidth;
    }
    
    /**
     * @private
     */
    public function set panelWidth(value:Number):void
    {
      _panelWidth = value;
      invalidateDisplayList();
      
      dispatchEvent(new Event("panelWidthChange"));
    }
  
  
  }
}
