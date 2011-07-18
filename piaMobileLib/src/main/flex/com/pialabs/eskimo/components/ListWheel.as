package com.pialabs.eskimo.components
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.filters.BlurFilter;
  import flash.geom.Point;
  import flash.utils.getTimer;
  
  import mx.collections.ArrayCollection;
  import mx.collections.IList;
  import mx.core.ClassFactory;
  import mx.core.IVisualElement;
  import mx.core.mx_internal;
  import mx.events.EffectEvent;
  import mx.events.FlexEvent;
  import mx.events.SandboxMouseEvent;
  
  import spark.components.List;
  import spark.effects.Animate;
  import spark.effects.animation.MotionPath;
  import spark.effects.animation.SimpleMotionPath;
  import spark.effects.easing.EasingFraction;
  import spark.effects.easing.Sine;
  import spark.events.IndexChangeEvent;
  
  use namespace mx_internal;
  
  /**
  * Defines the begin color for the gradient of the list selector
  *
  * @default #5555AA
  */
  [Style(name = "gradientColorBegin", inherit = "no", type = "uint")]
  
  
  /**
   * Defines the end color for the gradient of the list selector
   *
   * @default #3333AA
   */
  [Style(name = "gradientColorEnd", inherit = "no", type = "uint")]
  
  /**
  * It is a list with a loop effect.
  * The gradient of the list selector is customizable.
  * Only vertical layout is supported.
  */
  public class ListWheel extends List
  {
    private static const EVENT_HISTORY_LENGTH:int = 5;
    private static const MAX_VELOCITY:Number = 0.4;
    private static const MOTION_BLUR:Number = 20;
    
    /**
    * @private
    * Data provider setted by the user.
    */
    private var _dataProvider:ArrayCollection = new ArrayCollection();
    
    /**
     * @private
     * Used data provider which is 3 times the _dataProvider to simulate a looped data provider.
     */
    private var _customDataprovider:ArrayCollection;
    
    /**
     * @private
     * History of EVENT_HISTORY_LENGTH last mouse positions.
     */
    private var mouseEventCoordinatesHistory:Vector.<Point>;
    
    /**
     * @private
     * History of EVENT_HISTORY_LENGTH last mouse positions.
     */
    private var mouseEventTimeHistory:Vector.<int>;
    
    /**
     * @private
     * Current position on histories arrays.
     */
    private var mouseEventLength:Number = 0;
    
    /**
     * @private
     * StartTime of historisation.
     */
    private var startTime:int;
    
    /**
     * @private
     * Roll animations.
     */
    private var _animate:Animate = new Animate();
    private var _animateThrow:Animate = new Animate();
    
    /**
     * @private
     * Motion blur.
     */
    private var effect:BlurFilter = new BlurFilter(0, 0);
    
    /**
     * @private
     * Scroll velovity (px/ms).
     */
    private var _currentVelocity:Number;
    
    /**
     * @private
     * Boolean to know if we need to animate.
     */
    private var _haveToAnimate:Boolean;
    
    /**
     * @private
     * Vertical scroll position.
     */
    private var _verticalScrollPosition:Number = 0;
    
    /**
     * @private
     */
    private var _dataProviderChange:Boolean;
    private var _selectedItemChanged:Boolean;
    private var _oldY:Number;
    private var _rowHeight:Number = 50;
    
    /**
    * Constructor.
    */
    public function ListWheel()
    {
      super();
      
      mouseEventCoordinatesHistory = new Vector.<Point>(EVENT_HISTORY_LENGTH);
      mouseEventTimeHistory = new Vector.<int>(EVENT_HISTORY_LENGTH);
      
      addEventListener(Event.CHANGE, onChange);
      addEventListener(FlexEvent.CREATION_COMPLETE, onChange);
      
      if (itemRenderer == null)
      {
        itemRenderer = new ClassFactory(ListWheelItemRenderer);
      }
    }
    
    /**
     * DataProvider property (that should be an ArrayCollection).
     */
    override public function get dataProvider():IList
    {
      return _dataProvider;
    }
    
    /**
     * @private
     */
    override public function set dataProvider(value:IList):void
    {
      if (value != _dataProvider)
      {
        _dataProvider = value as ArrayCollection;
        
        _dataProviderChange = true;
        
        invalidateProperties();
        invalidateDisplayList();
      }
    }
    
    /**
     * Specify the selected Item
     */
    override public function set selectedItem(value:*):void
    {
      super.selectedItem = value;
      _selectedItemChanged = true;
      invalidateDisplayList();
    }
    
    /**
     * Specify the selected Index
     */
    override public function set selectedIndex(value:int):void
    {
      super.selectedIndex = value;
      
      _selectedItemChanged = true;
      invalidateDisplayList();
    }
    
    /**
     * Specify the selected Item with an an animation
     */
    public function animateToSelectedItem(value:*):void
    {
      super.selectedItem = value;
      _selectedItemChanged = true;
      _haveToAnimate = true;
      invalidateDisplayList();
    }
    
    /**
     * Specify the selected Index with an animation
     */
    public function animateToSelectedIndex(value:int):void
    {
      super.selectedIndex = value;
      
      _selectedItemChanged = true;
      _haveToAnimate = true;
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      if (_dataProviderChange)
      {
        if (_dataProvider)
        {
          var sourceDP:Array = _dataProvider.source;
          sourceDP = sourceDP.concat(sourceDP);
          sourceDP = sourceDP.concat(sourceDP);
          _customDataprovider = new ArrayCollection(sourceDP);
          
          super.dataProvider = _customDataprovider;
        }
        _dataProviderChange = false;
        _selectedItemChanged = true;
      }
      super.commitProperties();
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      dispatchEvent(new Event("rowHeightChange"));
      
      if (selectedIndex == -1)
      {
        selectedIndex = 0;
        dispatchEvent(new IndexChangeEvent("change"));
      }
      
      if (_selectedItemChanged)
      {
        ensureIndexIsVisible(selectedIndex % _dataProvider.length + dataProvider.length);
        _selectedItemChanged = false;
      }
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance)
      if (instance == dataGroup)
      {
        this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        mouseChildren = false;
      }
    }
    
    /**
     * @private
     * Index change handler
     */
    private function onChange(event:Event):void
    {
      if (dataProvider)
      {
        ensureIndexIsVisible(selectedIndex);
      }
    }
    
    /**
     * @private
     * MouseDown handler.
     */
    private function onMouseDown(event:MouseEvent):void
    {
      clearHistory();
      dataGroup.filters = null;
      _animateThrow.stop();
      _animate.stop();
      
      _oldY = this.mouseY;
      var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
      
      sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onMouseUp);
      sbRoot.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      
      // this is the point from which all deltas are based.
      startTime = getTimer();
    }
    
    /**
     * @private
     * MouseUp handler.
     */
    private function onMouseUp(event:Event):void
    {
      var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
      
      sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onMouseUp);
      sbRoot.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      
      removeEventListener(Event.ENTER_FRAME, onEnterFrame);
      throwScroll();
    }
    
    /**
     * @private
     * Enterframe during mouse pressed.
     */
    private function onEnterFrame(event:Event):void
    {
      verticalScrollPosition += (_oldY - this.mouseY);
      
      var currentIndex:int = (mouseEventLength % EVENT_HISTORY_LENGTH);
      
      // add time history as well
      mouseEventTimeHistory[currentIndex] = getTimer() - startTime;
      mouseEventCoordinatesHistory[currentIndex] = new Point(0, (_oldY - this.mouseY));
      
      // increment current length if appropriate
      mouseEventLength++;
      
      startTime = getTimer();
      _oldY = this.mouseY;
      
      updateBlurFilter();
    }
    
    
    
    /**
     * @private
     */
    public function set verticalScrollPosition(value:Number):void
    {
      _verticalScrollPosition = value;
      
      var animateValue:Number;
      
      var realValue:Number;
      
      if (_dataProvider)
      {
        realValue = (value % (_dataProvider.length * rowHeight)) + (_dataProvider.length * rowHeight);
      }
      else
      {
        realValue = value;
      }
      
      
      dataGroup.verticalScrollPosition = realValue;
    
    }
    
    /**
     * Vertical position in the list.
     */
    public function get verticalScrollPosition():Number
    {
      return _verticalScrollPosition;
    }
    
    /**
     * Throw the list thanks to the move histories to compute the velocity.
     */
    private function throwScroll():void
    {
      var currentIndex:int = (mouseEventLength % EVENT_HISTORY_LENGTH);
      
      mouseEventTimeHistory[currentIndex] = getTimer() - startTime;
      mouseEventCoordinatesHistory[currentIndex] = new Point(0, (_oldY - this.mouseY));
      
      var duration:int = Math.abs(2000 * currentVelocity);
      
      var newScrollPosition:Number = verticalScrollPosition + currentVelocity * duration;
      
      var smp:SimpleMotionPath = new SimpleMotionPath("verticalScrollPosition");
      smp.valueFrom = verticalScrollPosition;
      smp.valueTo = newScrollPosition;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animateThrow.addEventListener(EffectEvent.EFFECT_END, onThowFinish);
      _animateThrow.addEventListener(EffectEvent.EFFECT_UPDATE, onThrowUpdate);
      
      //set the SimpleMotionPath to the Animate Object
      _animateThrow.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateThrow.motionPaths = smps;
      _animateThrow.duration = duration;
      _animateThrow.play([this]); //run the animation
    }
    
    /**
     * @private
     * During throw animation.
     */
    private function onThrowUpdate(event:EffectEvent):void
    {
      var ratio:Number = 1 - (event.effectInstance.playheadTime / event.effectInstance.duration);
      
      updateBlurFilter(ratio);
    }
    
    /**
     * @private
     */
    private function onThowFinish(event:Event):void
    {
      dataGroup.filters = null;
      _haveToAnimate = true;
      scrollToItem();
    }
    
    /**
     * @private
     * Move history cleaning.
     */
    private function clearHistory():void
    {
      for (var i:int = 0; i < EVENT_HISTORY_LENGTH; i++)
      {
        mouseEventCoordinatesHistory[i] = null;
        mouseEventTimeHistory[i] = null;
      }
    }
    
    /**
     * Get the current velovity of the movment.
     */
    public function get currentVelocity():Number
    {
      var dist:Number = 0;
      var time:Number = 0;
      for (var i:int = 0; i < EVENT_HISTORY_LENGTH; i++)
      {
        if (mouseEventCoordinatesHistory[i])
        {
          dist += mouseEventCoordinatesHistory[i].y;
          time += mouseEventTimeHistory[i];
        }
      }
      
      dist /= EVENT_HISTORY_LENGTH;
      time /= EVENT_HISTORY_LENGTH;
      
      _currentVelocity = (dist / time);
      _currentVelocity = Math.max(-MAX_VELOCITY, _currentVelocity);
      _currentVelocity = Math.min(MAX_VELOCITY, _currentVelocity);
      
      return _currentVelocity;
    }
    
    /**
     * @private
     */
    private function updateBlurFilter(ratio:Number = 1):void
    {
      effect.blurY = MOTION_BLUR * ratio * Math.abs(currentVelocity);
      
      dataGroup.filters = [effect];
    }
    
    /**
     * @private
     */
    private function scrollToItem():void
    {
      if (!layout)
      {
        return;
      }
      
      var verticalScrollCenterPosition:Number = dataGroup.verticalScrollPosition + dataGroup.scrollRect.height / 2;
      
      var scrollIndex:int = verticalScrollCenterPosition / rowHeight;
      
      ensureIndexIsVisible(scrollIndex);
    }
    
    /**
    * @private
    */
    override public function ensureIndexIsVisible(index:int):void
    {
      if (dataGroup == null || _dataProvider == null)
      {
        return;
      }
      
      _verticalScrollPosition = (_verticalScrollPosition % (_dataProvider.length * rowHeight)) + (_dataProvider.length * rowHeight);
      
      var newScrollPosition:Number = index * rowHeight - ((dataGroup.scrollRect.height - rowHeight) / 2);
      
      var smp:SimpleMotionPath = new SimpleMotionPath("verticalScrollPosition");
      smp.valueFrom = verticalScrollPosition;
      smp.valueTo = newScrollPosition;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animate.addEventListener(EffectEvent.EFFECT_END, onRollEnd);
      
      //set the SimpleMotionPath to the Animate Object
      _animate.motionPaths = smps;
      
      if (_haveToAnimate)
      {
        _animate.play([this]);
      } //run the animation
      else
      {
        verticalScrollPosition = newScrollPosition;
      }
    }
    
    /**
     * @private
     */
    private function onRollEnd(event:Event):void
    {
      var verticalScrollCenterPosition:Number = dataGroup.verticalScrollPosition + dataGroup.scrollRect.height / 2;
      
      var index:int = (verticalScrollCenterPosition / rowHeight) % _dataProvider.length;
      
      setSelectedIndex(index, true);
      
      _haveToAnimate = false;
    }
    
    /**
     * The row height.
     */
    [Bindable("rowHeightChange")]
    public function get rowHeight():Number
    {
      if (!dataGroup)
      {
        return _rowHeight;
      }
      var lastRow:IVisualElement = useVirtualLayout ? dataGroup.getVirtualElementAt(dataGroup.numChildren - 1) : dataGroup.getElementAt(dataGroup.numChildren - 1);
      
      if (lastRow != null)
      {
        _rowHeight = lastRow.height;
      }
      
      return _rowHeight;
    }
  }
}

