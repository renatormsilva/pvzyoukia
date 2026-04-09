package com.util
{
   import core.managers.GameManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   
   public final class CTimer extends EventDispatcher
   {
      
      private var delay:Number = 0;
      
      private var enabled:Boolean = false;
      
      private var last:Number = 0;
      
      private var max:Number = 0;
      
      private var count:Number = 0;
      
      private var sTime:Number = 0;
      
      private var timer:Timer = null;
      
      public function CTimer(param1:Number, param2:Number = 0)
      {
         super();
         if(param1 < 10)
         {
            throw new Error("CTimer--error---时间间隔太短没的意义的!");
         }
         this.delay = param1;
         this.max = param2;
      }
      
      public function onTimer(param1:Event) : void
      {
         this.count = Number(this.getTimerCount());
         if(this.enabled && this.count > this.last)
         {
            if(this.max == 0)
            {
               this.dispatchTimerEvent(1);
               return;
            }
            if(this.count != 0)
            {
               if(this.count >= this.max)
               {
                  this.dispatchTimerEvent(this.max - this.last);
               }
               else
               {
                  this.dispatchTimerEvent(this.count - this.last);
               }
            }
         }
         if(this.max > 0 && this.count >= this.max)
         {
            this.stop();
            dispatchEvent(new CTimerEvent(this.count,this.getRealityCount(),CTimerEvent.TIMER_COMPLETE));
         }
      }
      
      public function start() : void
      {
         if(!this.enabled)
         {
            GameManager.pvzStage.addEventListener(Event.ENTER_FRAME,this.onTimer);
            this.sTime = SystemTimer.currentTimeMillis() + this.delay;
         }
         this.enabled = true;
      }
      
      public function stop() : void
      {
         if(this.enabled)
         {
            GameManager.pvzStage.removeEventListener(Event.ENTER_FRAME,this.onTimer);
         }
         this.enabled = false;
      }
      
      private function dispatchTimerEvent(param1:uint) : void
      {
         if(param1 == 0)
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1)
         {
            dispatchEvent(new CTimerEvent(this.count,this.getRealityCount(),CTimerEvent.TIMER));
            ++this.last;
            _loc2_++;
         }
      }
      
      private function getRealityCount() : Number
      {
         return SystemTimer.currentTimeMillis() - this.sTime;
      }
      
      private function getTimerCount() : Number
      {
         return (SystemTimer.currentTimeMillis() - this.sTime) / this.delay;
      }
   }
}

