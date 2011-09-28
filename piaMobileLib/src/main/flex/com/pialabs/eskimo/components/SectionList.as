package com.pialabs.eskimo.components
{
  import com.pialabs.eskimo.data.SectionTitleLabel;
  
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import mx.core.ClassFactory;
  import mx.core.IFactory;
  import mx.core.IVisualElement;
  import mx.core.UIComponent;
  import mx.core.mx_internal;
  import mx.events.PropertyChangeEvent;
  
  import spark.components.Group;
  import spark.components.IItemRenderer;
  import spark.components.IconItemRenderer;
  import spark.components.List;
  import spark.layouts.VerticalLayout;
  import spark.utils.LabelUtil;
  
  use namespace mx_internal;
  
  /**
   *  Dispatched after the selection has changed.
   *  This event is dispatched when the user interacts with the control.
   */
  [Event(name = "change", type = "spark.events.IndexChangeEvent")]
  
  /**
   * Defines the section style
   *
   * @default .sectionRendererStyle
   */
  [Style(name = "sectionRendererStyleName", inherit = "no", type = "String")]
  
  
  /**
   * List that contains some section to order item.
   *
   * SectionList renderers must implements com.pialabs.eskimo.components.ISectionRenderer.
   *
   * @see com.pialabs.eskimo.components.SectionItemRenderer
   * @see com.pialabs.eskimo.components.ISectionRenderer
   * @see com.pialabs.eskimo.data.SectionTitleLabel
   */
  public class SectionList extends List
  {
    /**
     * @private
     */
    private var _sectionHeight:Number = 27;
    /**
     * @private
     */
    private var _isSectionTitleFunction:Function = defaultIsSectionTitleFunction;
    /**
     * @private
     */
    private var _sectionLabelField:String = "label";
    /**
     * @private
     */
    private var _maintainSectionOnTop:Boolean = false;
    
    [SkinPart(required = "false")]
    public var currentSectionRendererLayer:Group;
    
    /**
     * @private
     */
    protected var currentSectionRenderer:IVisualElement;
    
    /**
     * @private
     */
    protected var previousSectionIndex:int;
    /**
     * @private
     */
    protected var nextSectionIndex:int;
    
    /**
     * @private
     */
    private var _itemRendererChange:Boolean = true;
    
    /**
     * @private
     */
    public function SectionList()
    {
      super();
      itemRenderer = new ClassFactory(SectionItemRenderer);
      var sectionLayout:VerticalLayout = new VerticalLayout();
      sectionLayout.variableRowHeight = true;
      sectionLayout.gap = 0;
      sectionLayout.horizontalAlign = "contentJustify";
      this.layout = sectionLayout;
    }
    
    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == scroller)
      {
        scroller.viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
      }
    
    }
    
    /**
     * @private
     */
    protected function propertyChangeHandler(event:PropertyChangeEvent):void
    {
      if (event.property == "verticalScrollPosition" && _maintainSectionOnTop && currentSectionRenderer != null)
      {
        updateCurrentSectionTitleRendererPosition()
      }
    }
    
    /**
     * @private
     */
    protected function updateCurrentSectionTitleRendererPosition():void
    {
      var indicesInView:Vector.<int> = dataGroup.getItemIndicesInView();
      var firstVisibleIndice:int = indicesInView.length > 0 ? indicesInView[0] : -1;
      var found:Boolean;
      
      previousSectionIndex = getPreviousSectionTitleIndex(firstVisibleIndice);
      
      if (previousSectionIndex == -1)
      {
        currentSectionRenderer.visible = false;
        return;
      }
      
      var visu:IVisualElement = dataGroup.getVirtualElementAt(previousSectionIndex);
      
      if (visu)
      {
        point = (visu as UIComponent).localToGlobal(new Point());
        point = globalToLocal(point);
        
        if (point.y >= 0)
        {
          currentSectionRenderer.visible = false;
          return;
        }
      }
      
      nextSectionIndex = getNextSectionTitleIndex(firstVisibleIndice + 1);
      
      currentSectionRenderer.visible = true;
      
      var previousItem:Object = dataProvider.getItemAt(previousSectionIndex);
      (currentSectionRenderer as IItemRenderer).label = itemToLabel(previousItem);
      
      
      
      visu = dataGroup.getVirtualElementAt(nextSectionIndex);
      var currectionSectionY:Number = 0;
      var point:Point;
      
      if (visu)
      {
        point = (visu as UIComponent).localToGlobal(new Point());
        point = globalToLocal(point);
        
        currectionSectionY = Math.min(point.y - currentSectionRenderer.height, 0);
      }
      
      currentSectionRenderer.setLayoutBoundsPosition(0, currectionSectionY);
    
    }
    
    /**
     * @private
     */
    protected function getPreviousSectionTitleIndex(index:int):int
    {
      if (dataProvider == null)
      {
        return -1;
      }
      
      while (index >= 0)
      {
        var item:Object = dataProvider.getItemAt(index);
        var isTitle:Boolean = _isSectionTitleFunction(item);
        if (isTitle)
        {
          break;
        }
        index--;
      }
      return index;
    }
    
    /**
     * @private
     */
    protected function getNextSectionTitleIndex(index:int):int
    {
      if (dataProvider == null)
      {
        return -1;
      }
      
      while (index <= dataProvider.length - 1)
      {
        var item:Object = dataProvider.getItemAt(index);
        var isTitle:Boolean = _isSectionTitleFunction(item);
        if (isTitle)
        {
          break;
        }
        index++;
      }
      return index;
    }
    
    /**
     * @private
     */
    override protected function item_mouseDownHandler(event:MouseEvent):void
    {
      var data:Object;
      if (event.currentTarget is IItemRenderer)
      {
        data = IItemRenderer(event.currentTarget).data;
      }
      
      var isTitle:Boolean = _isSectionTitleFunction(data);
      if (isTitle)
      {
        event.preventDefault();
      }
      super.item_mouseDownHandler(event);
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      if (_itemRendererChange)
      {
        if (currentSectionRendererLayer)
        {
          currentSectionRendererLayer.removeAllElements()
          
          if (itemRenderer)
          {
            currentSectionRenderer = itemRenderer.newInstance();
            currentSectionRenderer.percentWidth = 100;
            
            if (currentSectionRenderer is ISectionRenderer)
            {
              (currentSectionRenderer as ISectionRenderer).isSectionTitle = true;
            }
            
            currentSectionRendererLayer.addElement(currentSectionRenderer);
          }
        }
      }
    }
    
    /**
    * @private
    */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      var sectionRendererStyleName:String = getStyle("sectionRendererStyleName");
      
      if (currentSectionRenderer)
      {
        (currentSectionRenderer as UIComponent).styleName = sectionRendererStyleName;
        (currentSectionRenderer as UIComponent).height = sectionHeight;
        
        if (_maintainSectionOnTop)
        {
          updateCurrentSectionTitleRendererPosition()
        }
        else
        {
          currentSectionRenderer.visible = false;
        }
      }
    
    }
    
    /**
     * @private
     */
    override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
    {
      var sectionRendererStyleName:String = getStyle("sectionRendererStyleName");
      //enderer.height = sectionHeight;
      
      if (renderer is ISectionRenderer)
      {
        var isTitle:Boolean = _isSectionTitleFunction(data);
        var rendererStyleName:String = (renderer as UIComponent).styleName as String;
        if (isTitle)
        {
          (renderer as ISectionRenderer).isSectionTitle = true;
          
          if (renderer is IItemRenderer)
          {
            (renderer as IItemRenderer).label = LabelUtil.itemToLabel(data, sectionLabelField);
          }
          
          (renderer as UIComponent).height = sectionHeight;
          if (rendererStyleName == null || rendererStyleName.lastIndexOf(sectionRendererStyleName) == -1)
          {
            (renderer as UIComponent).styleName += " " + sectionRendererStyleName;
          }
          
          return;
        }
        else
        {
          (renderer as ISectionRenderer).isSectionTitle = false;
          (renderer as UIComponent).height = NaN;
          
          
          if (rendererStyleName)
          {
            rendererStyleName.split(sectionRendererStyleName).join("");
          }
          (renderer as UIComponent).styleName = "";
        }
      }
      
      super.updateRenderer(renderer, itemIndex, data);
    }
    
    /**
     * Height of section titles renderers
     */
    public function get sectionHeight():Number
    {
      return _sectionHeight;
    }
    
    /**
     * @private
     */
    public function set sectionHeight(value:Number):void
    {
      _sectionHeight = value;
      
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    private function defaultIsSectionTitleFunction(item:Object):Boolean
    {
      return (item is SectionTitleLabel);
    }
    
    /**
     * Label field for the section title item
     */
    public function get sectionLabelField():String
    {
      return _sectionLabelField;
    }
    
    /**
     * @private
     */
    public function set sectionLabelField(value:String):void
    {
      _sectionLabelField = value;
    }
    
    /**
    * Function defined to tell to the sectionList if the item is a section title or a normal item.
    * By default, the SectionList look for com.pialabs.eskimo.data.SectionTitleLabel in the dataProvider.
    */
    public function get isSectionTitleFunction():Function
    {
      return _isSectionTitleFunction;
    }
    
    
    /**
    * @private
    */
    public function set isSectionTitleFunction(value:Function):void
    {
      _isSectionTitleFunction = value;
    }
    
    override public function set itemRenderer(value:IFactory):void
    {
      super.itemRenderer = value;
      
      _itemRendererChange = true;
      
      invalidateProperties();
    }
    
    /**
     * Display the current section title on top of the list
     */
    public function get maintainSectionOnTop():Boolean
    {
      return _maintainSectionOnTop;
    }
    
    /**
     * @private
     */
    public function set maintainSectionOnTop(value:Boolean):void
    {
      _maintainSectionOnTop = value;
      
      invalidateDisplayList();
    }
  
  
  }
}
