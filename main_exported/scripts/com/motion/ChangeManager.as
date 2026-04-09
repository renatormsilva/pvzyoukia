package com.motion
{
   import com.res.IDestroy;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   
   public class ChangeManager implements IDestroy
   {
      
      public static var RATE:int = 50;
      
      private static const PLAY:int = 1;
      
      private static const STOP:int = 2;
      
      private var _type:int = 0;
      
      private var cartoonArray:Array = null;
      
      private var timer:CTimer = null;
      
      public function ChangeManager()
      {
         super();
         this.cartoonArray = new Array();
         this._type = STOP;
         this.timer = new CTimer(20);
         this.timer.addEventListener(CTimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      public function add(param1:Change) : void
      {
         this.cartoonArray.push(param1);
         if(this._type == STOP)
         {
            this._type = PLAY;
         }
      }
      
      public function destroy() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(CTimerEvent.TIMER,this.onTimer);
         this.timer = null;
      }
      
      private function onTimer(param1:CTimerEvent) : void
      {
         if(this.cartoonArray.length < 1)
         {
            this._type = STOP;
         }
         if(this._type == STOP)
         {
            return;
         }
         var _loc2_:* = int(this.cartoonArray.length - 1);
         while(_loc2_ > -1)
         {
            if(this.cartoonArray[_loc2_].change())
            {
               this.cartoonArray.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
   }
}

