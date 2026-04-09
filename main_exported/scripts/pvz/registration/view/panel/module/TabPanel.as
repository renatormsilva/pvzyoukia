package pvz.registration.view.panel.module
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Circ;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import manager.SoundManager;
   
   public class TabPanel extends Component
   {
      
      public static const EVENT_TAB_SELECT:String = "tab_select";
      
      public var marginTitle:Number = 2;
      
      private var _transitionDuration:Number;
      
      private var _transitionDelay:Number;
      
      private var _tabs:Vector.<TabPanelItem>;
      
      private var _selectedTab:TabPanelItem;
      
      private var _title:Sprite;
      
      private var _content:Sprite;
      
      private var _hideTitle:Boolean;
      
      private var _titleOffsetX:Number;
      
      private var _titleOffsetY:Number;
      
      private var _contentOffset:Number;
      
      public function TabPanel(param1:Number, param2:Number, param3:Boolean = false)
      {
         super(param1,param2);
         this._transitionDuration = 0.25;
         this._transitionDelay = 0.06;
         this._hideTitle = param3;
         this._titleOffsetX = this._titleOffsetY = this._contentOffset = 0;
         this._tabs = new Vector.<TabPanelItem>();
         this._selectedTab = null;
         this._title = new Sprite();
         this._content = new Sprite();
         this._content.scrollRect = new Rectangle(0,0,_width,_height);
         this._title.x = 0;
         this._title.y = 0;
         this._content.x = 8;
         this._content.y = this._hideTitle ? 0 : 37;
         this._title.addEventListener(MouseEvent.CLICK,this.onSelect,false,0,true);
         this._title.visible = !this._hideTitle;
         addChild(this._title);
         addChild(this._content);
      }
      
      public function addTab(param1:TabPanelItem) : void
      {
         var _loc2_:uint = 0;
         if(!param1 || this._tabs.indexOf(param1) != -1)
         {
            return;
         }
         if(!param1.id || param1.id >= this._tabs.length)
         {
            param1.id = this._tabs.length;
         }
         if(param1.id < this._tabs.length)
         {
            _loc2_ = this._tabs.length - 1;
            while(_loc2_ != param1.id)
            {
               this._tabs[_loc2_ + 1] = this._tabs[_loc2_];
               this._tabs[_loc2_ + 1].id = _loc2_ + 1;
               _loc2_--;
            }
         }
         this._tabs[param1.id] = param1;
         if(!this._selectedTab)
         {
            this._selectedTab = param1;
         }
         validate();
      }
      
      public function removeTabByID(param1:uint) : TabPanelItem
      {
         return this.removeTab(this.getTabByID(param1));
      }
      
      public function removeTabByName(param1:String) : TabPanelItem
      {
         return this.removeTab(this.getTabByName(param1));
      }
      
      public function removeTab(param1:TabPanelItem) : TabPanelItem
      {
         var _loc2_:int = this._tabs.indexOf(param1);
         if(_loc2_ == -1)
         {
            return null;
         }
         this._tabs.splice(_loc2_,1);
         if(this._selectedTab == param1)
         {
            this._selectedTab = this.getTabByID(_loc2_);
         }
         var _loc3_:uint = this._tabs.length;
         while(_loc2_ < _loc3_)
         {
            this._tabs[_loc2_].id = _loc2_;
            _loc2_++;
         }
         validate();
         return param1;
      }
      
      public function getTabByID(param1:uint) : TabPanelItem
      {
         var _loc2_:TabPanelItem = null;
         for each(_loc2_ in this._tabs)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getTabByName(param1:String) : TabPanelItem
      {
         var _loc2_:TabPanelItem = null;
         for each(_loc2_ in this._tabs)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function hasTab(param1:TabPanelItem) : Boolean
      {
         return this._tabs.indexOf(param1) != -1;
      }
      
      public function setSelectedID(param1:uint, param2:Boolean = true, param3:Boolean = true) : void
      {
         var oldTab:TabPanelItem;
         var id:uint = param1;
         var animation:Boolean = param2;
         var flag:Boolean = param3;
         if(!this._tabs.length)
         {
            id = 0;
         }
         else if(id >= this._tabs.length)
         {
            id = this._tabs.length - 1;
         }
         oldTab = this._selectedTab;
         if(this._selectedTab)
         {
            if(this._selectedTab.btnTitle is MovieClip)
            {
               (this._selectedTab.btnTitle as MovieClip).gotoAndStop(1);
            }
         }
         this._selectedTab = this.getTabByID(id);
         if(this._selectedTab)
         {
            this._content.addChildAt(this._selectedTab.content,0);
            this._selectedTab.content.x = oldTab ? (oldTab.id < id ? _width : -this._selectedTab.content.width) : _width;
            if(Boolean(oldTab) && oldTab != this._selectedTab)
            {
               if(animation)
               {
                  TweenLite.to(oldTab.content,this._transitionDuration,{
                     "x":(oldTab.id < id ? -oldTab.content.width : _width),
                     "ease":Circ.easeOut
                  }).eventCallback("onComplete",function(param1:* = null):void
                  {
                     if(_content.numChildren > 1)
                     {
                        _content.removeChildAt(1);
                     }
                  });
                  TweenLite.delayedCall(this._transitionDelay,function():void
                  {
                     TweenLite.to(_selectedTab.content,_transitionDuration,{
                        "x":0,
                        "ease":Circ.easeOut
                     });
                  });
               }
               else
               {
                  if(this._content.numChildren > 1)
                  {
                     this._content.removeChildAt(1);
                  }
                  this._selectedTab.content.x = 0;
               }
            }
            else
            {
               this._selectedTab.content.x = 0;
            }
            if(this._selectedTab.btnTitle is MovieClip)
            {
               (this._selectedTab.btnTitle as MovieClip).gotoAndStop(2);
            }
            if(this._selectedTab != oldTab && flag == true)
            {
               dispatchEvent(new Event(EVENT_TAB_SELECT));
            }
         }
      }
      
      override protected function draw() : void
      {
         var _loc2_:TabPanelItem = null;
         while(this._title.numChildren)
         {
            this._title.removeChildAt(0);
         }
         while(this._content.numChildren)
         {
            this._content.removeChildAt(0);
         }
         var _loc1_:uint = 0;
         for each(_loc2_ in this._tabs)
         {
            if(_loc2_.btnTitle)
            {
               _loc2_.btnTitle.x = _loc1_;
               _loc2_.btnTitle.y = 0;
               this._title.addChild(_loc2_.btnTitle);
               if(_loc2_.btnTitle is MovieClip)
               {
                  MovieClip(_loc2_.btnTitle).gotoAndStop(2);
                  _loc1_ += _loc2_.btnTitle.width + this.marginTitle;
                  MovieClip(_loc2_.btnTitle).gotoAndStop(1);
               }
               else
               {
                  _loc1_ += _loc2_.btnTitle.width + this.marginTitle;
               }
            }
         }
         this.setSelectedID(this._selectedTab ? this._selectedTab.id : 0);
         this._content.y = this._hideTitle ? this._contentOffset : this._title.y + this._title.height - this._titleOffsetY + this._contentOffset;
      }
      
      protected function onSelect(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(!_loc2_ || !this._title.contains(_loc2_))
         {
            return;
         }
         while(_loc2_.parent != this._title)
         {
            _loc2_ = _loc2_.parent;
         }
         this.setSelectedID(this._title.getChildIndex(_loc2_));
      }
      
      override public function dispose() : void
      {
         this._tabs.length = 0;
         this._selectedTab = null;
      }
      
      public function get titleOffsetX() : Number
      {
         return this._titleOffsetX;
      }
      
      public function set titleOffsetX(param1:Number) : void
      {
         if(this._titleOffsetX == param1)
         {
            return;
         }
         this._titleOffsetX = param1;
         this._title.x = this._titleOffsetX;
      }
      
      public function get titleOffsetY() : Number
      {
         return this._titleOffsetY;
      }
      
      public function set titleOffsetY(param1:Number) : void
      {
         if(this._titleOffsetY == param1)
         {
            return;
         }
         this._titleOffsetY = param1;
         this._title.y = this._titleOffsetY;
      }
      
      public function get contentOffset() : Number
      {
         return this._contentOffset;
      }
      
      public function set contentOffset(param1:Number) : void
      {
         if(this._contentOffset == param1)
         {
            return;
         }
         this._contentOffset = param1;
         this._content.y = this._hideTitle ? this._contentOffset : this._title.y + this._title.height + this._contentOffset;
      }
      
      override public function set width(param1:Number) : void
      {
         if(_width == param1)
         {
            return;
         }
         _width = param1;
         var _loc2_:Rectangle = this._content.scrollRect;
         _loc2_.width = _width;
         this._content.scrollRect = _loc2_;
      }
      
      override public function set height(param1:Number) : void
      {
         if(_height == param1)
         {
            return;
         }
         _height = param1;
         var _loc2_:Rectangle = this._content.scrollRect;
         _loc2_.height = _height;
         this._content.scrollRect = _loc2_;
      }
      
      public function get selectedTab() : TabPanelItem
      {
         return this._selectedTab;
      }
      
      public function get tabCount() : uint
      {
         return this._tabs.length;
      }
      
      public function get transitionDuration() : Number
      {
         return this._transitionDuration;
      }
      
      public function set transitionDuration(param1:Number) : void
      {
         if(this._transitionDuration == param1)
         {
            return;
         }
         this._transitionDuration = param1 < 0 ? 0 : param1;
      }
      
      public function get transitionDelay() : Number
      {
         return this._transitionDelay;
      }
      
      public function set transitionDelay(param1:Number) : void
      {
         if(this._transitionDelay == param1)
         {
            return;
         }
         this._transitionDelay = param1 < 0 ? 0 : (param1 > this._transitionDuration ? 0.05 : param1);
      }
   }
}

