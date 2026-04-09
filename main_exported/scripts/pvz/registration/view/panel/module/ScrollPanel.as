package pvz.registration.view.panel.module
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.res.IDestroy;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import utils.GetDomainRes;
   
   public class ScrollPanel extends Component implements IScrollableObject
   {
      
      public static const VALIDATE_CONTENT:String = "content";
      
      public static const VALIDATE_SCROLLBAR:String = "scrollBar";
      
      public static const SCROLLBAR_TYPE_ARROW:String = "scrollArrow";
      
      public static const SCROLLBAR_TYPE_SCROLL:String = "scrollScroll";
      
      public static const EVENT_SCROLL:String = "scroll";
      
      public var transitionDuration:Number = 1;
      
      public var scrollDistance:Number = 100;
      
      protected var _content:DisplayObject;
      
      protected var _scrollBarV:ScrollBar;
      
      protected var _scrollBarH:ScrollBar;
      
      protected var _background:DisplayObject;
      
      protected var _canAddRemove:Boolean;
      
      protected var _viewRect:Rectangle;
      
      protected var _progressV:Number;
      
      protected var _progressH:Number;
      
      protected var _contentHeight:uint;
      
      protected var _contentWidth:uint;
      
      protected var _scrollType:String;
      
      protected var _scrollBarType:String;
      
      protected var _btnScrollUp:DisplayObject;
      
      protected var _btnScrollDown:DisplayObject;
      
      protected var _btnScrollLeft:DisplayObject;
      
      protected var _btnScrollRight:DisplayObject;
      
      protected var _showScrollBar:Boolean;
      
      protected var _paddingLeft:Number;
      
      protected var _paddingRight:Number;
      
      protected var _paddingTop:Number;
      
      protected var _paddingBottom:Number;
      
      protected var _defaultPadding:Number;
      
      public function ScrollPanel(param1:Number, param2:Number, param3:DisplayObject = null, param4:DisplayObject = null, param5:DisplayObject = null, param6:DisplayObject = null, param7:DisplayObject = null, param8:DisplayObject = null, param9:int = 0)
      {
         var scrollBarW:int;
         var w:Number = param1;
         var h:Number = param2;
         var cont:DisplayObject = param3;
         var bg:DisplayObject = param4;
         var barArrowUp:DisplayObject = param5;
         var barArrowDown:DisplayObject = param6;
         var barBar:DisplayObject = param7;
         var barBg:DisplayObject = param8;
         var scrollResType:int = param9;
         super(w,h);
         this._showScrollBar = true;
         this._canAddRemove = false;
         this._viewRect = new Rectangle(0,0,_width,_height);
         this._progressV = 0;
         this._progressH = 0;
         this._contentHeight = 0;
         this._defaultPadding = this._paddingTop = this._paddingRight = this._paddingBottom = this._paddingLeft = 0;
         scrollBarW = scrollResType ? 14 : 20;
         this._scrollBarV = new ScrollBar(scrollBarW,h,barArrowUp,barArrowDown,barBg,barBar,null,scrollResType);
         this._scrollBarV.x = w - this._scrollBarV.width;
         this._scrollBarV.y = 0;
         this._scrollBarV.visible = false;
         addChild(this._scrollBarV);
         this._scrollBarH = new ScrollBar(20,h,barArrowUp,barArrowDown,barBg,barBar);
         this._scrollBarH.x = 0;
         this._scrollBarH.y = h;
         this._scrollBarH.rotation = -90;
         this._scrollBarH.direction = UISettings.SCROLL_TYPE_HORIZONTAL;
         this._scrollBarH.visible = false;
         addChild(this._scrollBarH);
         this._scrollBarType = SCROLLBAR_TYPE_SCROLL;
         this._scrollType = UISettings.SCROLL_TYPE_VERTICAL;
         if(!cont)
         {
            cont = new Sprite();
         }
         this.content = cont;
         this.setScrollButton();
         addEventListener(MouseEvent.MOUSE_WHEEL,function(param1:MouseEvent):void
         {
            if(_scrollType == UISettings.SCROLL_TYPE_HORIZONTAL && _contentWidth > _viewRect.width)
            {
               scrollTo(_progressH - param1.delta,true,true,_scrollType);
            }
            if(_scrollType == UISettings.SCROLL_TYPE_VERTICAL && _contentHeight > _viewRect.height)
            {
               scrollTo(_progressV - param1.delta,true,true,_scrollType);
            }
         });
      }
      
      public function get scrollHeight() : Number
      {
         return _height - this._paddingTop - this._paddingBottom;
      }
      
      public function get scrollWidth() : Number
      {
         return _width - this._paddingLeft - this._paddingRight;
      }
      
      public function get scrollBar() : ScrollBar
      {
         return this._scrollBarV;
      }
      
      public function get scrollBarH() : ScrollBar
      {
         return this._scrollBarH;
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function set content(param1:DisplayObject) : void
      {
         if(!param1 || !(param1 is DisplayObject))
         {
            throw "Content can not be null or non DisplayObject";
         }
         if(this._content == param1)
         {
            return;
         }
         if(this._content)
         {
            removeChild(this._content);
         }
         this._content = param1;
         this._contentHeight = this._content.height;
         this._contentWidth = this._content.width;
         addChild(this._content);
         addChild(this._scrollBarV);
         addChild(this._scrollBarH);
         this._canAddRemove = Boolean(this._content as DisplayObjectContainer);
         validate(VALIDATE_SCROLLBAR);
      }
      
      public function get background() : DisplayObject
      {
         return this._background;
      }
      
      public function set background(param1:DisplayObject) : void
      {
         if(this._background == param1)
         {
            return;
         }
         if(Boolean(this._background) && this._background.parent == this)
         {
            removeChild(this._background);
         }
         this._background = param1;
         addChildAt(this._background,0);
      }
      
      public function get enableBackground() : Boolean
      {
         return Boolean(this._background) && this._background.visible;
      }
      
      public function set enableBackground(param1:Boolean) : void
      {
         if(this._background)
         {
            this._background.visible = param1;
         }
      }
      
      public function addObject(param1:DisplayObject, param2:Boolean = true, param3:Number = 0, param4:Number = 0) : void
      {
         if(!this._canAddRemove || !param1)
         {
            return;
         }
         var _loc5_:DisplayObjectContainer = this._content as DisplayObjectContainer;
         if(param1.parent == _loc5_)
         {
            this.removeObject(param1,false);
         }
         if(param2)
         {
            param1.x = param3 + (this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL ? this._contentWidth : 0);
            param1.y = param4 + (this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL ? 0 : this._contentHeight);
         }
         _loc5_.addChild(param1);
         if(param1.x + param1.width > this._contentWidth)
         {
            this._contentWidth = param1.x + param1.width;
         }
         if(param1.y + param1.height > this._contentHeight)
         {
            this._contentHeight = param1.y + param1.height;
         }
         this.updateScrollBar();
      }
      
      public function removeObject(param1:DisplayObject, param2:Boolean = true) : void
      {
         if(!this._canAddRemove || !param1 || param1.parent != this._content)
         {
            return;
         }
         this._contentHeight -= param1.height;
         var _loc3_:DisplayObjectContainer = this._content as DisplayObjectContainer;
         var _loc4_:int = _loc3_.getChildIndex(param1);
         _loc3_.removeChildAt(_loc4_);
         var _loc5_:int = _loc3_.numChildren;
         while(_loc4_ < _loc5_)
         {
            _loc3_.getChildAt(_loc4_).y = _loc3_.getChildAt(_loc4_).y - param1.height;
            _loc4_++;
         }
         if(param2)
         {
            this.updateScrollBar();
         }
      }
      
      public function removeObjectAt(param1:uint, param2:Boolean = true) : DisplayObject
      {
         if(!this._canAddRemove)
         {
            return null;
         }
         var _loc3_:DisplayObjectContainer = this._content as DisplayObjectContainer;
         if(!_loc3_.numChildren)
         {
            return null;
         }
         if(param1 >= _loc3_.numChildren)
         {
            param1 = _loc3_.numChildren - 1;
         }
         var _loc4_:DisplayObject = _loc3_.removeChildAt(param1);
         this._contentHeight -= _loc4_.height;
         var _loc5_:int = _loc3_.numChildren;
         while(param1 < _loc5_)
         {
            _loc3_.getChildAt(param1).y = _loc3_.getChildAt(param1).y - _loc4_.height;
            param1++;
         }
         if(param2)
         {
            this.updateScrollBar();
         }
         return _loc4_;
      }
      
      public function removeAllObjects(param1:Function = null, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(!this._canAddRemove)
         {
            return;
         }
         this._contentHeight = 0;
         this._contentWidth = 0;
         var _loc4_:DisplayObjectContainer = this._content as DisplayObjectContainer;
         var _loc5_:DisplayObject = null;
         while(_loc4_.numChildren)
         {
            _loc5_ = _loc4_.removeChildAt(0);
            if(param1 != null)
            {
               param1(_loc5_);
            }
            if(param3)
            {
               if(_loc5_ is IDestroy)
               {
                  IDestroy(_loc5_).destroy();
               }
               else if(_loc5_ is Component)
               {
                  Component(_loc5_).dispose();
               }
            }
         }
         this.scrollTo(0,param2,false,UISettings.SCROLL_TYPE_HORIZONTAL);
         this.scrollTo(0,param2,false,UISettings.SCROLL_TYPE_VERTICAL);
      }
      
      public function scrollTo(param1:Number, param2:Boolean = true, param3:Boolean = true, param4:String = "vertical") : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 100)
         {
            param1 = 100;
         }
         TweenLite.killTweensOf(this._viewRect);
         var _loc5_:Object = {"ease":Cubic.easeOut};
         if(param4 == UISettings.SCROLL_TYPE_HORIZONTAL)
         {
            this._progressH = param1;
            _loc5_.x = this._progressH * (this._contentWidth - this._viewRect.width) * 0.01;
         }
         else
         {
            this._progressV = param1;
            _loc5_.y = this._progressV * (this._contentHeight - this._viewRect.height) * 0.01;
         }
         _validateType.length = 0;
         _validateType.push(VALIDATE_CONTENT);
         if(param2)
         {
            _validateType.push(VALIDATE_SCROLLBAR);
         }
         if(param3)
         {
            TweenLite.to(this._viewRect,this.transitionDuration,_loc5_).eventCallback("onUpdate",this.draw);
         }
         else
         {
            if(param4 == UISettings.SCROLL_TYPE_HORIZONTAL)
            {
               this._viewRect.x = _loc5_.x;
            }
            else
            {
               this._viewRect.y = _loc5_.y;
            }
            validate(VALIDATE_CONTENT);
            if(param2)
            {
               validate(VALIDATE_SCROLLBAR);
            }
            this.draw();
         }
         dispatchEvent(new Event(EVENT_SCROLL));
      }
      
      public function scrollToTarget(param1:DisplayObject, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(!param1 || !this._canAddRemove || param1.parent != this._content)
         {
            return;
         }
         var _loc4_:Number = param1.y / (this._contentHeight - this._viewRect.height) * 100;
         this.scrollTo(_loc4_,param2,param3);
      }
      
      public function setScrollButton(param1:DisplayObject = null, param2:DisplayObject = null, param3:String = "vertical") : void
      {
         var _loc4_:DisplayObject = param3 == UISettings.SCROLL_TYPE_HORIZONTAL ? this._btnScrollLeft : this._btnScrollUp;
         var _loc5_:DisplayObject = param3 == UISettings.SCROLL_TYPE_HORIZONTAL ? this._btnScrollRight : this._btnScrollDown;
         if(_loc4_)
         {
            _loc4_.removeEventListener(MouseEvent.CLICK,this.onMouseDown);
            if(_loc4_.parent == this)
            {
               removeChild(_loc4_);
            }
         }
         if(_loc5_)
         {
            _loc5_.removeEventListener(MouseEvent.CLICK,this.onMouseDown);
            if(_loc5_.parent == this)
            {
               removeChild(_loc5_);
            }
         }
         _loc4_ = param1 ? param1 : GetDomainRes.getDisplayObject(param3 == UISettings.SCROLL_TYPE_VERTICAL ? "scrollBar_btnUp" : "scrollBar_btnLeft");
         _loc5_ = param2 ? param2 : GetDomainRes.getDisplayObject(param3 == UISettings.SCROLL_TYPE_VERTICAL ? "scrollBar_btnDown" : "scrollBar_btnRight");
         if(_loc4_)
         {
            _loc4_.addEventListener(MouseEvent.CLICK,this.onMouseDown);
            addChild(_loc4_);
         }
         if(_loc5_)
         {
            _loc5_.addEventListener(MouseEvent.CLICK,this.onMouseDown);
            addChild(_loc5_);
         }
         if(param3 == UISettings.SCROLL_TYPE_HORIZONTAL)
         {
            this._btnScrollLeft = _loc4_;
            this._btnScrollRight = _loc5_;
         }
         else
         {
            this._btnScrollUp = _loc4_;
            this._btnScrollDown = _loc5_;
         }
         validate(VALIDATE_SCROLLBAR);
      }
      
      private function updateScrollBar() : void
      {
         this._scrollBarV.visible = false;
         this._scrollBarH.visible = false;
         this._scrollBarV.container = this;
         this._scrollBarV.progress = this._progressV;
         this._scrollBarH.container = this;
         this._scrollBarH.progress = this._progressH;
         if(this._btnScrollUp)
         {
            this._btnScrollUp.visible = false;
         }
         if(this._btnScrollDown)
         {
            this._btnScrollDown.visible = false;
         }
         if(this._btnScrollLeft)
         {
            this._btnScrollLeft.visible = false;
         }
         if(this._btnScrollRight)
         {
            this._btnScrollRight.visible = false;
         }
         if(this._scrollBarType == SCROLLBAR_TYPE_SCROLL)
         {
            this._scrollBarV.visible = this._contentHeight > this._viewRect.height && this._showScrollBar && this._scrollType != UISettings.SCROLL_TYPE_HORIZONTAL;
            this._scrollBarH.visible = this._contentWidth > this._viewRect.width && this._showScrollBar && (this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL);
         }
         else
         {
            if(this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL)
            {
               if(this._btnScrollLeft)
               {
                  this._btnScrollLeft.visible = this._progressH > 0 && this._showScrollBar;
               }
               if(this._btnScrollRight)
               {
                  this._btnScrollRight.visible = this._progressH < 100 && this._contentWidth > this._viewRect.width && this._showScrollBar;
               }
            }
            if(this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType != UISettings.SCROLL_TYPE_HORIZONTAL)
            {
               if(this._btnScrollUp)
               {
                  this._btnScrollUp.visible = this._progressV > 0 && this._showScrollBar;
               }
               if(this._btnScrollDown)
               {
                  this._btnScrollDown.visible = this._progressV < 100 && this._contentHeight > this._viewRect.height && this._showScrollBar;
               }
            }
         }
      }
      
      public function upContentHeight() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:int = DisplayObjectContainer(this._content).numChildren;
         if(_loc1_ == 0)
         {
            return;
         }
         this._contentHeight = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = DisplayObjectContainer(this._content).getChildAt(_loc2_);
            this._contentHeight += _loc3_.height;
            _loc2_++;
         }
         validate();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         var _loc3_:Boolean = _loc2_ == this._btnScrollLeft || _loc2_ == this._btnScrollRight;
         var _loc4_:Number = _loc3_ ? this._progressH : this._progressV;
         var _loc5_:Number = _loc3_ ? this._contentWidth - this._viewRect.width : this._contentHeight - this._viewRect.height;
         var _loc6_:Number = this.scrollDistance / _loc5_ * 100;
         if(_loc2_ == this._btnScrollUp || _loc2_ == this._btnScrollLeft)
         {
            _loc4_ -= _loc6_;
         }
         else if(_loc2_ == this._btnScrollDown || _loc2_ == this._btnScrollRight)
         {
            _loc4_ += _loc6_;
         }
         this.scrollTo(_loc4_,true,true,_loc3_ ? UISettings.SCROLL_TYPE_HORIZONTAL : UISettings.SCROLL_TYPE_VERTICAL);
      }
      
      override protected function draw() : void
      {
         this._viewRect.height = _height - this._paddingBottom - this._paddingTop;
         this._viewRect.width = _width - this._paddingLeft - this._paddingRight;
         this._content.x = this._paddingLeft;
         this._content.y = this._paddingTop;
         this._content.scrollRect = this._viewRect;
         graphics.clear();
         graphics.beginFill(0,0.01);
         graphics.drawRect(0,0,this._viewRect.width,this._viewRect.height);
         graphics.endFill();
         if(hasValidateType(VALIDATE_SCROLLBAR))
         {
            this.updateScrollBar();
         }
         this._scrollBarV.x = _width - this._paddingRight - this._scrollBarV.width;
         this._scrollBarV.y = this._paddingTop;
         this._scrollBarH.x = this._paddingLeft;
         this._scrollBarH.y = _height - this._paddingBottom;
         if(this._scrollBarType == SCROLLBAR_TYPE_SCROLL)
         {
            this._content.y = this._paddingTop;
            this._scrollBarV.visible = this._contentHeight > this._viewRect.height && this._showScrollBar && this._scrollType != UISettings.SCROLL_TYPE_HORIZONTAL;
            this._scrollBarH.visible = this._contentWidth > this._viewRect.width && this._showScrollBar && (this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL);
            if(this._btnScrollUp)
            {
               this._btnScrollUp.visible = false;
            }
            if(this._btnScrollDown)
            {
               this._btnScrollDown.visible = false;
            }
            if(this._btnScrollLeft)
            {
               this._btnScrollLeft.visible = false;
            }
            if(this._btnScrollRight)
            {
               this._btnScrollRight.visible = false;
            }
         }
         else
         {
            this._scrollBarV.visible = false;
            this._scrollBarH.visible = false;
            if(this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL)
            {
               if(this._btnScrollLeft)
               {
                  this._btnScrollLeft.y = (_height - this._btnScrollLeft.height) * 0.5;
                  this._btnScrollLeft.visible = this._progressH > 0 && this._showScrollBar;
                  this._content.x = this._showScrollBar ? this._btnScrollLeft.width + this._paddingLeft : this._paddingLeft;
                  this._viewRect.width -= this._showScrollBar ? this._btnScrollLeft.width : 0;
                  this._content.scrollRect = this._viewRect;
               }
               if(this._btnScrollRight)
               {
                  this._btnScrollRight.x = _width - this._btnScrollRight.width;
                  this._btnScrollRight.y = (_height - this._btnScrollRight.height) * 0.5;
                  this._btnScrollRight.visible = this._progressH < 100 && this._contentWidth > _width && this._showScrollBar;
                  this._viewRect.width -= this._showScrollBar ? this._btnScrollRight.width : 0;
                  this._content.scrollRect = this._viewRect;
               }
            }
            if(this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType != UISettings.SCROLL_TYPE_HORIZONTAL)
            {
               if(this._btnScrollUp)
               {
                  this._viewRect.height -= this._showScrollBar ? this._btnScrollUp.height : 0;
                  this._btnScrollUp.x = (_width - this._btnScrollUp.width) * 0.5;
                  this._btnScrollUp.visible = this._progressV > 0 && this._showScrollBar;
                  this._content.y = this._showScrollBar ? this._btnScrollUp.height + this._paddingTop : this._paddingTop;
                  this._content.scrollRect = this._viewRect;
               }
               if(this._btnScrollDown)
               {
                  this._viewRect.height -= this._showScrollBar ? this._btnScrollDown.height : 0;
                  this._btnScrollDown.x = (_width - this._btnScrollDown.width) * 0.5;
                  this._btnScrollDown.y = _height - this._btnScrollDown.height;
                  this._btnScrollDown.visible = this._progressV < 100 && this._contentHeight > this._viewRect.height && this._showScrollBar;
                  this._content.scrollRect = this._viewRect;
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeAllObjects(null,false);
         if(this._scrollBarV)
         {
            this._scrollBarV.dispose();
         }
         if(this._scrollBarH)
         {
            this._scrollBarH.dispose();
         }
      }
      
      public function get showScrollBar() : Boolean
      {
         return this._showScrollBar;
      }
      
      public function set showScrollBar(param1:Boolean) : void
      {
         if(this._showScrollBar == param1)
         {
            return;
         }
         this._showScrollBar = param1;
         this.updateScrollBar();
      }
      
      public function get progress() : Number
      {
         return this._progressV;
      }
      
      public function get objectCount() : uint
      {
         return this._canAddRemove ? uint(DisplayObjectContainer(this._content).numChildren) : 0;
      }
      
      public function get contentHeight() : uint
      {
         return this._contentHeight;
      }
      
      public function get contentWidth() : uint
      {
         return this._contentWidth;
      }
      
      public function get scrollType() : String
      {
         return this._scrollType;
      }
      
      public function set scrollType(param1:String) : void
      {
         if(this._scrollType == param1)
         {
            return;
         }
         this._scrollType = param1;
         this._scrollBarV.visible = this._scrollType != UISettings.SCROLL_TYPE_HORIZONTAL;
         this._scrollBarH.visible = this._scrollType == UISettings.SCROLL_TYPE_ALL || this._scrollType == UISettings.SCROLL_TYPE_HORIZONTAL;
      }
      
      public function get scrollBarType() : String
      {
         return this._scrollBarType;
      }
      
      public function set scrollBarType(param1:String) : void
      {
         if(this._scrollBarType == param1)
         {
            return;
         }
         this._scrollBarType = param1;
         validate(VALIDATE_SCROLLBAR);
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = this._defaultPadding;
         }
         this._paddingTop = this._paddingRight = this._paddingBottom = this._paddingLeft = param1;
         validate();
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = this._defaultPadding;
         }
         this._paddingTop = param1;
         validate();
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = this._defaultPadding;
         }
         this._paddingRight = param1;
         validate();
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = this._defaultPadding;
         }
         this._paddingBottom = param1;
         validate();
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = this._defaultPadding;
         }
         this._paddingLeft = param1;
         validate();
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      override public function set width(param1:Number) : void
      {
         if(_width == param1)
         {
            return;
         }
         _width = param1;
         this._viewRect.width = _width;
         validate();
      }
      
      override public function set height(param1:Number) : void
      {
         if(_height == param1)
         {
            return;
         }
         _height = param1;
         this._viewRect.height = _height;
         validate();
      }
   }
}

