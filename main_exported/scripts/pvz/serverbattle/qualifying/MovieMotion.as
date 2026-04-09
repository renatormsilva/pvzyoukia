package pvz.serverbattle.qualifying
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class MovieMotion
   {
      
      private var _mc:DisplayObject;
      
      private var timer:Timer;
      
      private var quo:Number = 0.3;
      
      private var _end:Number;
      
      private var _endbounce:Number;
      
      private var _dirction:int;
      
      private var type:int;
      
      private var nes:Number = 30;
      
      private var vec:int = 0;
      
      public var _func:Function;
      
      public function MovieMotion()
      {
         super();
      }
      
      public static function goButtonAnimate(param1:DisplayObject, param2:Number) : void
      {
         var myInterval:uint = 0;
         var target_p:Point = null;
         var vy:Number = NaN;
         var move:Function = null;
         var mc:DisplayObject = param1;
         var end:Number = param2;
         move = function():void
         {
            vy = target_p.y - mc.y;
            mc.y += vy * 0.2;
            var _loc1_:Point = new Point(mc.x,mc.y);
            if(Point.distance(_loc1_,target_p) <= 2)
            {
               mc.y = end;
               clearInterval(myInterval);
            }
         };
         myInterval = setInterval(move,40);
         target_p = new Point(mc.x,end);
         var vx:Number = 0;
         vy = 0;
      }
      
      public function goAnimate(param1:DisplayObject, param2:Number, param3:int, param4:Function) : void
      {
         this._mc = param1;
         this._func = param4;
         if(this.timer != null)
         {
            return;
         }
         this._end = param2;
         this._endbounce = param2;
         this.timer = new Timer(20);
         if(param3 == 0)
         {
            if(this._mc.x < this._end)
            {
               this._dirction = 1;
            }
            else
            {
               this._dirction = -1;
            }
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimerX);
         }
         else
         {
            if(this._mc.y < this._end)
            {
               this._dirction = 1;
            }
            else
            {
               this._dirction = -1;
            }
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimerY);
         }
         this.timer.start();
      }
      
      private function onTimerY(param1:TimerEvent) : void
      {
         this._mc.y += (this._endbounce - this._mc.y) * this.quo;
         if(this._dirction > 0)
         {
            if(this._mc.y >= this._end - 2 || this.vec != 0)
            {
               if(this.vec == 0)
               {
                  this._endbounce -= this.nes;
                  this.vec = 1;
                  this.quo = 0.5;
                  return;
               }
               if(this.vec == 1 && this._mc.y <= this._endbounce + 2)
               {
                  this._endbounce = this._end;
                  this.vec = 2;
                  this.quo = 0.1;
                  return;
               }
               if(this._mc.y >= this._end - 3)
               {
                  this._mc.y = this._end;
                  this.timer.stop();
                  this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerY);
                  this.timer = null;
                  if(this._func != null)
                  {
                     this._func();
                  }
               }
            }
            return;
         }
         if(this._mc.y <= this._end + 2 || this.vec != 0)
         {
            if(this.vec == 0)
            {
               this._endbounce += this.nes;
               this.vec = 1;
               this.quo = 0.5;
               return;
            }
            if(this.vec == 1 && this._mc.y >= this._endbounce - 2)
            {
               this._endbounce = this._end;
               this.vec = 2;
               this.quo = 0.1;
               return;
            }
            if(this._mc.y <= this._end + 3)
            {
               this._mc.y = this._end;
               this.timer.stop();
               this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerY);
               this.timer = null;
               if(this._func != null)
               {
                  this._func();
               }
            }
         }
      }
      
      private function onTimerX(param1:TimerEvent) : void
      {
         this._mc.x += (this._endbounce - this._mc.x) * this.quo;
         if(this._dirction > 0)
         {
            if(this._mc.x >= this._end - 2 || this.vec != 0)
            {
               if(this.vec == 0)
               {
                  this._endbounce -= this.nes;
                  this.vec = 1;
                  this.quo = 0.4;
                  return;
               }
               if(this.vec == 1 && this._mc.x <= this._endbounce + 2)
               {
                  this._endbounce = this._end;
                  this.vec = 2;
                  this.quo = 0.6;
                  return;
               }
               if(this._mc.x >= this._end - 50)
               {
                  this._mc.x = this._end;
                  this.timer.stop();
                  this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerX);
                  this.timer = null;
                  if(this._func != null)
                  {
                     this._func();
                  }
               }
            }
            return;
         }
         if(this._mc.x <= this._end + 2 || this.vec != 0)
         {
            if(this.vec == 0)
            {
               this._endbounce += this.nes;
               this.vec = 1;
               this.quo = 0.4;
               return;
            }
            if(this.vec == 1 && this._mc.x >= this._endbounce - 2)
            {
               this._endbounce = this._end;
               this.vec = 2;
               this.quo = 0.6;
               return;
            }
            if(this._mc.x <= this._end + 50)
            {
               this._mc.x = this._end;
               this.timer.stop();
               this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerX);
               this.timer = null;
               if(this._func != null)
               {
                  this._func();
               }
            }
         }
      }
   }
}

