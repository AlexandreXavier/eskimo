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
  import com.pialabs.eskimo.events.DeletableListEvent;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.filesystem.FileMode;
  
  import mx.core.UIComponent;
  import mx.core.mx_internal;
  import mx.events.EffectEvent;
  import mx.states.State;
  
  import spark.components.Button;
  import spark.components.IconItemRenderer;
  import spark.components.Image;
  import spark.components.LabelItemRenderer;
  import spark.core.ContentCache;
  import spark.effects.Animate;
  import spark.effects.animation.MotionPath;
  import spark.effects.animation.SimpleMotionPath;
  import spark.effects.easing.EasingFraction;
  import spark.filters.DropShadowFilter;
  
  use namespace mx_internal;
  
  /**
   * Style name of the delete button.
   * @default deletetableItemRendererDeleteButtonStyle
   */
  [Style(name = "deleteButtonStyle", inherit = "yes", type = "String")]
  /**
   * height of the delete button.
   * @default 0xCC2A27
   */
  [Style(name = "editIcon", inherit = "yes", type = "Class")]
  /**
   * Edit button icon width
   * @default 27 px
   */
  [Style(name = "editIconWidth", inherit = "yes", type = "Number")]
  /**
   * Width of the edit icon.
   * @default 27 px
   */
  [Style(name = "editIconHeight", inherit = "yes", type = "Number")]
  /**
   * Padding of the edit icon.
   * @default 5 px
   */
  [Style(name = "editIconPadding", inherit = "yes", type = "Number")]
  
  /**
   * Default itemRenderer of the DeletableList.
   * the component has two states : "normal" and "edition"
   *
   * In "edition" state, DeletableItemrenderer use DeletableItemRendererOverlay component to show the edit and delete button.
   * @see com.pialabs.eskimo.components.DeletableList
   * @see com.pialabs.eskimo.components.DeletableItemRendererOverlay
   */
  public class DeletableItemRenderer extends IconItemRenderer
  {
    protected var _editionIcon:Image;
    /**
     * @private
     *  Delete button.
     */
    protected var _deleteButton:Button;
    /**
     * @private
     * Label of the delete buttons.
     */
    protected static var _deleteLabel:String = "Delete";
    
    /**
     * @private
     */
    protected var _confirmationMode:Boolean;
    /**
     * @private
     */
    protected var editIconSprite:UIComponent;
    /**
     * @private
     */
    protected var deleteButtonMask:UIComponent;
    
    /**
     * @private
     */
    protected var _confirmationModeChange:Boolean;
    
    /**
     * @private
     */
    protected var _animateEdition:Animate = new Animate();
    protected var _animateConfirmation:Animate = new Animate();
    protected var _animateDelete:Animate = new Animate();
    
    protected var _editionAnimationDuration:Number = 300;
    protected var _animateConfirmationDuration:Number = 200;
    
    protected var _itemRecycled:Boolean = true;
    
    /**
     *  @private
     *  Static icon image cache.  This is the default for iconContentLoader.
     */
    mx_internal static var _imageCache:ContentCache;
    
    
    
    /**
     * @Constructor
     */
    public function DeletableItemRenderer()
    {
      super();
      
      states = [new State({name: "normal"}), new State({name: "edition"}), new State({name: "confirmation"})];
      
      if (_imageCache == null)
      {
        _imageCache = new ContentCache();
        _imageCache.enableCaching = true;
        _imageCache.maxCacheEntries = 100;
      }
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedTostage);
    }
    
    /**
     * @private
     */
    protected function onAddedTostage(event:Event):void
    {
      removeEventListener(Event.ADDED_TO_STAGE, onAddedTostage);
      addEventListener(Event.REMOVED_FROM_STAGE, onAddedTostage);
    }
    
    /**
     * @private
     */
    protected function onRemovedTostage(event:Event):void
    {
      _itemRecycled = true;
      
      removeEventListener(Event.REMOVED_FROM_STAGE, onAddedTostage);
      addEventListener(Event.ADDED_TO_STAGE, onAddedTostage);
    }
    
    /**
     * @private
     */
    protected function createEditionIconDisplay():void
    {
      _editionIcon = new Image();
      
      _editionIcon.smooth = true;
      
      _editionIcon.contentLoader = _imageCache;
    }
    
    /**
     * @private
     */
    override protected function createChildren():void
    {
      if (!_deleteButton)
      {
        _deleteButton = new Button();
        
        _deleteButton.visible = false;
        
        _deleteButton.addEventListener(MouseEvent.CLICK, onDelete);
        
        addChild(_deleteButton);
      }
      if (!_editionIcon)
      {
        createEditionIconDisplay();
        
        _editionIcon.source = getStyle("editIcon");
        _editionIcon.addEventListener(MouseEvent.CLICK, onEditionIconClick, false, 0, true);
        
        var filter:DropShadowFilter = new DropShadowFilter(1, 45, 0, 0.6, 3, 3);
        _editionIcon.filters = [filter];
        
        editIconSprite = new UIComponent();
        
        editIconSprite.includeInLayout = false;
        
        editIconSprite.addChild(_editionIcon);
        addChild(editIconSprite);
      }
      
      super.createChildren();
    }
    
    /**
     * @private
     */
    protected function onDelete(event:Event):void
    {
      stage.removeEventListener(MouseEvent.MOUSE_DOWN, onRemoveConfirmation);
      
      var parentList:DeletableList = owner as DeletableList;
      
      var e:DeletableListEvent = new DeletableListEvent(DeletableListEvent.ITEM_DELETED, false, false, mouseX, mouseY, this, false, false, false, true, 0, itemIndex, data, this);
      parentList.dispatchEvent(e);
      
      var itemIndex:int = parentList.dataProvider.getItemIndex(data);
      
      if (itemIndex != -1)
      {
        parentList.dataProvider.removeItemAt(itemIndex);
      }
    }
    
    /**
     * @private
     */
    override protected function commitProperties():void
    {
      super.commitProperties();
      
      _deleteButton.label = _deleteLabel;
      
      if (_confirmationModeChange)
      {
        if (_confirmationMode)
        {
          stage.addEventListener(MouseEvent.MOUSE_DOWN, onRemoveConfirmation, false, 0, true);
        }
        
        applyEditIconEffect();
        applyDeleteButtonEffect()
        
        _editionIcon.mouseEnabled = _editionIcon.mouseChildren = !_confirmationMode;
        
        _confirmationModeChange = false;
      }
      
      _deleteButton.styleName = getStyle("deleteButtonStyle");
    }
    
    /**
     * @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
      //super.layoutContents(unscaledWidth, unscaledHeight);
      
      if (!labelDisplay)
      {
        return;
      }
      
      var paddingLeft:Number = getStyle("paddingLeft");
      var paddingRight:Number = getStyle("paddingRight");
      var paddingTop:Number = getStyle("paddingTop");
      var paddingBottom:Number = getStyle("paddingBottom");
      var verticalAlign:String = getStyle("verticalAlign");
      var editIconPadding:Number = getStyle("editIconPadding");
      
      var viewWidth:Number = unscaledWidth - paddingLeft - paddingRight;
      var viewHeight:Number = unscaledHeight - paddingTop - paddingBottom;
      
      var vAlign:Number;
      if (verticalAlign == "top")
      {
        vAlign = 0;
      }
      else if (verticalAlign == "bottom")
      {
        vAlign = 1;
      }
      else // if (verticalAlign == "middle")
      {
        vAlign = 0.5;
      }
      
      // _deleteButton
      var deleteButtonWidth:Number = getElementPreferredWidth(_deleteButton);
      var deleteButtonHeight:Number = getElementPreferredHeight(_deleteButton);
      
      deleteButtonHeight = Math.min(deleteButtonHeight, viewHeight);
      var deleteButtonX:Number = unscaledWidth - paddingRight - deleteButtonWidth;
      var deleteButtonY:Number = paddingTop + (viewHeight - deleteButtonHeight) / 2
      
      setElementSize(_deleteButton, deleteButtonWidth, deleteButtonHeight);
      setElementPosition(_deleteButton, deleteButtonX, deleteButtonY);
      
      // _editionIcon
      var editionWidth:Number = getStyle("editIconWidth");
      var editionHeight:Number = getStyle("editIconHeight");
      var editionX:Number = currentState == "edition" ? editIconPadding : -editionWidth;
      var editionY:Number = paddingTop + viewHeight / 2;
      
      setElementPosition(editIconSprite, editionX + editionWidth / 2, editionY);
      setElementSize(_editionIcon, editionWidth, editionHeight);
      _editionIcon.x = -editionWidth / 2;
      _editionIcon.y = -editionHeight / 2;
      
      _editionIcon.visible = currentState == "edition";
      
      var horizontalGap:Number = getStyle("horizontalGap");
      
      // labelDisplay
      var offsetLeft:Number = Math.max(0, editionX + editionWidth) + horizontalGap - paddingLeft;
      offsetLeft = Math.max(offsetLeft, 0);
      var offsetRight:Number = _confirmationMode ? deleteButtonWidth + horizontalGap : 0;
      
      layoutIconItemRendererContents(unscaledWidth, unscaledHeight, offsetLeft, offsetRight);
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      if (!_animateConfirmation.isPlaying)
      {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
      }
    }
    
    /**
     * @private
     */
    protected function layoutIconItemRendererContents(unscaledWidth:Number, unscaledHeight:Number, leftOffset:Number, rightOffset:Number):void
    {
      super.layoutContents(unscaledWidth - leftOffset - rightOffset, unscaledHeight);
      
      var newX:Number;
      var newY:Number;
      if (iconDisplay)
      {
        newX = iconDisplay.getLayoutBoundsX() + leftOffset;
        newY = iconDisplay.getLayoutBoundsY();
        setElementPosition(iconDisplay, newX, newY);
      }
      if (decoratorDisplay)
      {
        newX = decoratorDisplay.getLayoutBoundsX() + leftOffset;
        newY = decoratorDisplay.getLayoutBoundsY();
        setElementPosition(decoratorDisplay, newX, newY);
      }
      if (labelDisplay)
      {
        newX = labelDisplay.getLayoutBoundsX() + leftOffset;
        newY = labelDisplay.getLayoutBoundsY();
        setElementPosition(labelDisplay, newX, newY);
      }
      if (messageDisplay)
      {
        newX = messageDisplay.getLayoutBoundsX() + leftOffset;
        newY = messageDisplay.getLayoutBoundsY();
        setElementPosition(messageDisplay, newX, newY);
      }
    }
    
    /**
     * @private
     */
    protected function showEditionIcon():void
    {
      _animateEdition.stop();
      
      _editionIcon.visible = true;
      
      var iconWidth:Number = getStyle("editIconWidth");
      var editIconPadding:Number = getStyle("editIconPadding");
      
      var smp:SimpleMotionPath = new SimpleMotionPath("x");
      smp.valueFrom = editIconSprite.x;
      smp.valueTo = editIconPadding + iconWidth / 2;
      
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animateEdition.addEventListener(EffectEvent.EFFECT_END, onEditionAnimationFinish);
      _animateEdition.addEventListener(EffectEvent.EFFECT_UPDATE, onEditionAnimationUpdate);
      
      //set the SimpleMotionPath to the Animate Object
      _animateEdition.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateEdition.motionPaths = smps;
      _animateEdition.duration = _editionAnimationDuration;
      _animateEdition.play([editIconSprite]); //run the animation
    }
    
    /**
    * @private
    */
    protected function hideEditionIcon():void
    {
      if (_animateEdition.isPlaying)
      {
        _animateEdition.stop();
      }
      
      var iconWidth:Number = getStyle("editIconWidth");
      var paddingLeft:Number = getStyle("paddingLeft");
      
      var smp:SimpleMotionPath = new SimpleMotionPath("x");
      smp.valueFrom = editIconSprite.x;
      smp.valueTo = -iconWidth / 2;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animateEdition.addEventListener(EffectEvent.EFFECT_END, onEditionAnimationFinish, false, 0, true);
      _animateEdition.addEventListener(EffectEvent.EFFECT_UPDATE, onEditionAnimationUpdate, false, 0, true);
      
      //set the SimpleMotionPath to the Animate Object
      _animateEdition.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateEdition.motionPaths = smps;
      _animateEdition.duration = _editionAnimationDuration;
      _animateEdition.play([editIconSprite]); //run the animation
    }
    
    /**
     * @private
     */
    protected function onEditionAnimationUpdate(event:EffectEvent):void
    {
      var paddingLeft:Number = getStyle("paddingLeft");
      
      var editionWidth:Number = getStyle("editIconWidth");
      var editionX:Number = editIconSprite.getLayoutBoundsX() - editionWidth / 2;
      
      var horizontalGap:Number = getStyle("horizontalGap");
      
      var offsetLeft:Number = Math.max(0, editionX + editionWidth) + horizontalGap - paddingLeft;
      offsetLeft = Math.max(offsetLeft, 0);
      var offsetRight:Number = 0;
      
      layoutIconItemRendererContents(unscaledWidth, unscaledHeight, offsetLeft, offsetRight);
    }
    
    /**
     * @private
     */
    protected function onEditionAnimationFinish(event:EffectEvent):void
    {
      if (currentState == "normal")
      {
        _editionIcon.visible = false;
      }
      
      invalidateDisplayList();
    }
    
    /**
     * @private
     */
    protected function applyEditIconEffect():void
    {
      var smp:SimpleMotionPath = new SimpleMotionPath("rotation");
      smp.valueFrom = editIconSprite.rotation;
      smp.valueTo = _confirmationMode ? 90 : 0;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      //set the SimpleMotionPath to the Animate Object
      _animateConfirmation.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateConfirmation.motionPaths = smps;
      _animateConfirmation.duration = _animateConfirmationDuration;
      _animateConfirmation.play([editIconSprite]); //run the animation
    }
    
    /**
     * @private
     */
    protected function applyDeleteButtonEffect():void
    {
      if (!deleteButtonMask)
      {
        deleteButtonMask = new UIComponent();
      }
      
      if (_animateDelete.isPlaying)
      {
        _animateDelete.stop()
      }
      
      addChild(deleteButtonMask);
      
      _deleteButton.visible = true;
      
      _deleteButton.mask = deleteButtonMask;
      
      var smp:SimpleMotionPath = new SimpleMotionPath("width");
      smp.valueFrom = deleteButtonMask.width;
      smp.valueTo = _confirmationMode ? getElementPreferredWidth(_deleteButton) : 0;
      
      var smps:Vector.<MotionPath> = new Vector.<MotionPath>();
      smps[0] = smp;
      
      _animateDelete.addEventListener(EffectEvent.EFFECT_END, onConfirmationAnimationFinish, false, 0, true);
      _animateDelete.addEventListener(EffectEvent.EFFECT_UPDATE, onConfirmationAnimationUpdate, false, 0, true);
      
      //set the SimpleMotionPath to the Animate Object
      _animateDelete.easer = new spark.effects.easing.Sine(EasingFraction.OUT);
      _animateDelete.motionPaths = smps;
      _animateDelete.duration = _animateConfirmationDuration;
      _animateDelete.play([deleteButtonMask]); //run the animation
    }
    
    /**
     * @private
     */
    protected function onConfirmationAnimationUpdate(event:EffectEvent):void
    {
      setElementPosition(deleteButtonMask, _deleteButton.getLayoutBoundsX() + _deleteButton.width - deleteButtonMask.width, 0);
      
      deleteButtonMask.graphics.clear();
      deleteButtonMask.graphics.beginFill(0);
      deleteButtonMask.graphics.drawRect(-2, 0, deleteButtonMask.width + 4, this.height);
      deleteButtonMask.graphics.endFill();
    }
    
    /**
     * @private
     */
    protected function onConfirmationAnimationFinish(event:EffectEvent):void
    {
      deleteButtonMask.mask = null;
      
      removeChild(deleteButtonMask);
      
      _deleteButton.visible = _confirmationMode;
      
      if (!_animateEdition.isPlaying)
      {
        invalidateDisplayList();
      }
    }
    
    /**
     * @private
     */
    override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
    {
      super.stateChanged(oldState, newState, recursive);
      
      if (!_itemRecycled)
      {
        if (newState == "edition")
        {
          showEditionIcon();
        }
        else if (newState == "normal")
        {
          hideEditionIcon();
        }
      }
      else
      {
        _itemRecycled = false;
        invalidateDisplayList();
      }
    }
    
    /**
     * @private
     */
    protected function onRemoveConfirmation(event:Event):void
    {
      if (_confirmationMode && event.target != _deleteButton && event.target != _editionIcon)
      {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onRemoveConfirmation);
        _confirmationMode = false;
        
        
        _confirmationModeChange = true;
        invalidateProperties();
      }
    }
    
    /**
     * @private
     */
    protected function onEditionIconClick(event:MouseEvent):void
    {
      if (!_confirmationMode)
      {
        _confirmationMode = true;
        
        _confirmationModeChange = true;
        
        invalidateProperties();
      }
    }
    
    
    /**
     * Label of the delete buttons.
     */
    public static function set deleteLabel(value:String):void
    {
      _deleteLabel = value;
    }
  
  }
}
