package pvz.registration.view.panel.module
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import utils.GetDomainRes;
   
   public class ScrollBar extends Component
   {
      
      public var shortDistance:Number;
      
      public var direction:String = "vertical";
      
      private var _arrowUp:DisplayObject;
      
      private var _arrowDown:DisplayObject;
      
      private var _bg:DisplayObject;
      
      private var _bar:DisplayObject;
      
      private var _progress:Number;
      
      private var _container:IScrollableObject;
      
      private var _hitOffX:Number;
      
      private var _hitOffY:Number;
      
      private var _dragging:Boolean;
      
      public function ScrollBar(param1:Number, param2:Number, param3:DisplayObject, param4:DisplayObject, param5:DisplayObject, param6:DisplayObject, param7:IScrollableObject = null, param8:int = 0)
      {
         super(param1,param2);
         this.shortDistance = 5;
         this._arrowUp = param3 ? param3 : GetDomainRes.getDisplayObject(param8 ? "chatScrollBar_arrowUp" : "scrollBar_btnUp");
         this._arrowDown = param4 ? param4 : GetDomainRes.getDisplayObject(param8 ? "chatScrollBar_arrowDown" : "scrollBar_btnDown");
         this._bar = param6 ? param6 : new BarBar(param8 ? "chatScrollBar_bar" : "scrollBar_bar");
         this._bg = param5 ? param5 : GetDomainRes.getDisplayObject(param8 ? "chatScrollBar_bg" : "scrollBar_bg");
         this._hitOffX = 0;
         this._hitOffY = 0;
         this._dragging = false;
         this._bg.width = this._bar.width = this._arrowDown.width = this._arrowUp.width = _width;
         this._bg.height = _height;
         this._arrowDown.y = param2 - this._arrowDown.height;
         addChild(this._bg);
         addChild(this._arrowUp);
         addChild(this._arrowDown);
         addChild(this._bar);
         this.container = param7;
         this.progress = 0;
      }
      
      public function set progress(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 100)
         {
            param1 = 100;
         }
         this._progress = param1;
         this._bar.y = this._progress * 0.01 * (height / scaleY - this._arrowUp.height - this._arrowDown.height - this._bar.height) + this._arrowUp.height;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set container(param1:IScrollableObject) : void
      {
         if(this._container != param1)
         {
            this._container = param1;
         }
         if(!this._container)
         {
            removeEventListener(MouseEvent.MOUSE_UP,this.onMouseDown);
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.validate();
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         switch(param1.target)
         {
            case this._arrowUp:
               this._container.scrollTo(this._progress - this.shortDistance,true,true,this.direction);
               break;
            case this._arrowDown:
               this._container.scrollTo(this._progress + this.shortDistance,true,true,this.direction);
               break;
            case this._bar:
               this._hitOffX = _loc2_.x - this._bar.x;
               this._hitOffY = _loc2_.y - this._bar.y;
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseDrag);
               stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
               this._dragging = true;
               break;
            case this._bg:
               _loc3_ = _loc2_.y - this._bar.height / 2;
               if(_loc3_ < this._arrowUp.height)
               {
                  _loc3_ = this._arrowUp.height;
               }
               if((_loc3_ + this._bar.height + this._arrowDown.height) * scaleY > height)
               {
                  _loc3_ = height / scaleY - this._arrowDown.height - this._bar.height;
               }
               this._bar.y = _loc3_;
               this._progress = (_loc3_ - this._arrowUp.height) / (height / scaleY - this._arrowUp.height - this._arrowDown.height - this._bar.height) * 100;
               this._container.scrollTo(this._progress,false,true,this.direction);
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._hitOffX = 0;
         this._hitOffY = 0;
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseDrag);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         this._dragging = false;
      }
      
      private function onMouseDrag(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._dragging)
         {
            _loc2_ = globalToLocal(new Point(param1.stageX,param1.stageY)).y - this._hitOffY;
            if(_loc2_ < this._arrowUp.height)
            {
               _loc2_ = this._arrowUp.height;
            }
            if((_loc2_ + this._bar.height + this._arrowDown.height) * scaleY > height)
            {
               _loc2_ = height / scaleY - this._arrowDown.height - this._bar.height;
            }
            this._bar.y = _loc2_;
            this._progress = (this._bar.y - this._arrowUp.height) / (height / scaleY - this._arrowUp.height - this._arrowDown.height - this._bar.height) * 100;
            this._container.scrollTo(this._progress,false,true,this.direction);
         }
      }
      
      override protected function validate(param1:String = "") : void
      {
         if(!this._container)
         {
            return;
         }
         _height = this.direction == UISettings.SCROLL_TYPE_HORIZONTAL ? this._container.scrollWidth : this._container.scrollHeight;
         if(this._container.scrollType == UISettings.SCROLL_TYPE_ALL && this.direction == UISettings.SCROLL_TYPE_HORIZONTAL)
         {
            _height -= this._container.scrollBar.width;
         }
         this._bg.width = this._bar.width = this._arrowDown.width = this._arrowUp.width = _width;
         this._bg.height = _height;
         this._arrowDown.y = _height - this._arrowDown.height;
         var _loc2_:Number = 0;
         if(this.direction == UISettings.SCROLL_TYPE_HORIZONTAL)
         {
            _loc2_ = this._container.contentWidth < height ? 1 : height / this._container.contentWidth;
         }
         else
         {
            _loc2_ = this._container.contentHeight < height ? 1 : height / this._container.contentHeight;
         }
         if(this.checkSmallestBar())
         {
            return;
         }
         this._bar.height = (height / scaleY - this._arrowUp.height - this._arrowDown.height) * _loc2_;
      }
      
      private function checkSmallestBar() : Boolean
      {
         return this._bar is BarBar && Boolean(BarBar(this._bar).minHeight);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._bar is BarBar)
         {
            BarBar(this._bar).dispose();
         }
      }
   }
}

