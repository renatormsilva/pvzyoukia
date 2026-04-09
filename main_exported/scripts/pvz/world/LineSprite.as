package pvz.world
{
   import flash.display.LineScaleMode;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class LineSprite extends Sprite
   {
      
      private var _arrow:MovieClip = null;
      
      private var _backFun:Function = null;
      
      private var _pathInfo:PathInfo = null;
      
      private var _shape:Shape = null;
      
      private var _speedX:Number = 0;
      
      private var _speedY:Number = 0;
      
      private var _t:Timer = null;
      
      private var angle:Number = 0;
      
      public function LineSprite(param1:PathInfo, param2:int, param3:Function, param4:Boolean)
      {
         super();
         this._shape = new Shape();
         TextFilter.MiaoBian(this._shape,0,1,2,2,10);
         this._pathInfo = param1;
         this._backFun = param3;
         this.angle = Math.atan2(param1.end.y - param1.start.y,param1.end.x - param1.start.x) * 180 / Math.PI;
         this._arrow = this.getArrow();
         this._arrow.rotation = this.angle;
         this._arrow.visible = false;
         this._arrow.x = param1.start.x;
         this._arrow.y = param1.start.y;
         this.addChild(this._shape);
         this.addChild(this._arrow);
         this._speedX = this.getXDistance(param1.start,param1.end) / param2;
         this._speedY = this.getYDistance(param1.start,param1.end) / param2;
         this._shape.graphics.moveTo(param1.start.x,param1.start.y);
         this._shape.graphics.lineStyle(4,16777215,1,false,LineScaleMode.NONE);
         if(param4)
         {
            this.immediatelyShow();
            return;
         }
         this._t = new Timer(50);
         this._t.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._t.start();
      }
      
      private function getArrow() : MovieClip
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.arrow");
         return new _loc1_();
      }
      
      private function getDistance(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(Math.pow(this.getXDistance(param1,param2),2) + Math.pow(this.getYDistance(param1,param2),2));
      }
      
      private function getXDistance(param1:Point, param2:Point) : Number
      {
         return Math.abs(param2.x - param1.x);
      }
      
      private function getYDistance(param1:Point, param2:Point) : Number
      {
         return Math.abs(param2.y - param1.y);
      }
      
      private function immediatelyShow() : void
      {
         this.showArrow(new Point(this._pathInfo.end.x,this._pathInfo.end.y));
         this._arrow.gotoAndStop(1);
         this._shape.graphics.lineTo(this._pathInfo.end.x - Math.cos(this.angle * Math.PI / 180) * 10,this._pathInfo.end.y - Math.sin(this.angle * Math.PI / 180) * 10);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Point = this.pointToPoint(this._pathInfo.start,this._pathInfo.end,this._pathInfo.now);
         this._shape.graphics.lineTo(_loc2_.x - Math.cos(this.angle * Math.PI / 180) * 10,_loc2_.y - Math.sin(this.angle * Math.PI / 180) * 10);
         if(_loc2_.x == this._pathInfo.end.x && _loc2_.y == this._pathInfo.end.y)
         {
            this._t.stop();
            this._t.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._t = null;
            if(this._backFun != null)
            {
               this._backFun();
            }
         }
      }
      
      private function pointToPoint(param1:Point, param2:Point, param3:Point) : Point
      {
         var _loc4_:Point = new Point();
         if(param1.x > param2.x)
         {
            _loc4_.x = param3.x - this._speedX;
            if(_loc4_.x <= param2.x)
            {
               _loc4_.x = param2.x;
            }
         }
         else
         {
            _loc4_.x = param3.x + this._speedX;
            if(_loc4_.x >= param2.x)
            {
               _loc4_.x = param2.x;
            }
         }
         if(param1.y > param2.y)
         {
            _loc4_.y = param3.y - this._speedY;
            if(_loc4_.y <= param2.y)
            {
               _loc4_.y = param2.y;
            }
         }
         else
         {
            _loc4_.y = param3.y + this._speedY;
            if(_loc4_.y >= param2.y)
            {
               _loc4_.y = param2.y;
            }
         }
         param3.x = _loc4_.x;
         param3.y = _loc4_.y;
         this.showArrow(param3);
         return _loc4_;
      }
      
      private function showArrow(param1:Point) : void
      {
         this._arrow.visible = true;
         this._arrow.x = param1.x;
         this._arrow.y = param1.y;
      }
   }
}

