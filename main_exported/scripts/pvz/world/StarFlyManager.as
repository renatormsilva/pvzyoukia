package pvz.world
{
   import com.motion.ChangeManager;
   import com.motion.change.move.UniLineMoveChange;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import zmyth.res.IDestroy;
   
   public class StarFlyManager extends EventDispatcher implements IDestroy
   {
      
      private var _t:Timer = null;
      
      private var StarClass:Class = null;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _cm:ChangeManager = null;
      
      public function StarFlyManager(param1:DisplayObjectContainer, param2:Class)
      {
         super();
         this.StarClass = param2;
         this._root = param1;
         this._cm = new ChangeManager();
         if(this.StarClass == null)
         {
            throw new Error("--StarClass-------is--------null");
         }
      }
      
      public function flyStars(param1:Point, param2:Point, param3:int, param4:Function) : void
      {
         var n:int = 0;
         var onTimer:Function = null;
         var start:Point = param1;
         var end:Point = param2;
         var num:int = param3;
         var backfunc:Function = param4;
         onTimer = function(param1:TimerEvent):void
         {
            ++n;
            if(n == num)
            {
               _t.stop();
               _t.removeEventListener(TimerEvent.TIMER,onTimer);
               _t = null;
            }
            if(n == num)
            {
               flyStar(getRandomPoint(start),getRandomPoint(end),new StarClass(),backfunc,true);
            }
            else
            {
               flyStar(getRandomPoint(start),getRandomPoint(end),new StarClass(),backfunc,false);
            }
         };
         if(num == 0)
         {
            backfunc();
            return;
         }
         this._t = new Timer(100);
         this._t.addEventListener(TimerEvent.TIMER,onTimer);
         this._t.start();
         n = 0;
      }
      
      public function destroy() : void
      {
         this._cm.destroy();
         this.StarClass = null;
      }
      
      private function getRandomPoint(param1:Point, param2:int = 2) : Point
      {
         return param1;
      }
      
      private function flyStar(param1:Point, param2:Point, param3:MovieClip, param4:Function, param5:Boolean) : void
      {
         var down:Function = null;
         var fly:Function = null;
         var back:Function = null;
         var start:Point = param1;
         var end:Point = param2;
         var star:MovieClip = param3;
         var backfunc:Function = param4;
         var isLast:Boolean = param5;
         down = function():void
         {
            _cm.add(new UniLineMoveChange(star,star.x,start.y - 10,0.6,fly));
         };
         fly = function():void
         {
            _cm.add(new UniLineMoveChange(star,end.x,end.y,0.8,back));
         };
         back = function():void
         {
            star.visible = false;
            _root.removeChild(star);
            backfunc(isLast);
         };
         var angle:Number = Math.atan2(end.y - start.y,end.x - start.x) * 180 / Math.PI;
         star.rotation = angle;
         star.x = start.x;
         star.y = start.y;
         this._root.addChild(star);
         this._cm.add(new UniLineMoveChange(star,star.x,start.y - 20,0.2,down));
      }
   }
}

