package com.util
{
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   
   public class SystemTimer extends EventDispatcher
   {
      
      public static const MILLI_SECONDS:int = 1000;
      
      private static const RATE:int = 10;
      
      private static var timer:Timer = null;
      
      public function SystemTimer()
      {
         super();
      }
      
      public static function currentTimeMillis() : Number
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime();
      }
      
      public static function getTimer() : Timer
      {
         if(timer == null)
         {
            timer = new Timer(RATE);
            timer.start();
         }
         return timer;
      }
   }
}

