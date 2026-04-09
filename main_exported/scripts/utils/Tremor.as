package utils
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Tremor
   {
      
      internal var timer:Timer = null;
      
      internal var backX:int = 0;
      
      internal var backY:int = 0;
      
      internal var dis:DisplayObject = null;
      
      internal var intensity:int = 0;
      
      internal var intensityOffset:int = 0;
      
      public function Tremor(param1:DisplayObject, param2:int = 12, param3:Number = 10, param4:Number = 10)
      {
         super();
         if(param1 == null)
         {
            return;
         }
         this.dis = param1;
         this.intensity = param3;
         this.intensityOffset = param3 / 2;
         this.backX = param1.x;
         this.backY = param1.y;
         this.timer = new Timer(int(1000 / param2),param4);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onComp);
         this.timer.start();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = this.backX + Math.random() * this.intensity - this.intensityOffset;
         var _loc3_:int = this.dis.y + Math.random() * this.intensity - this.intensityOffset;
         this.dis.x = _loc2_;
         this.dis.y = _loc3_;
      }
      
      private function onComp(param1:TimerEvent) : void
      {
         this.clear();
      }
      
      public function clear() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onComp);
         this.dis.x = this.backX;
         this.dis.y = this.backY;
      }
   }
}

