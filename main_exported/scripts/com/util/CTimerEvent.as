package com.util
{
   import flash.events.Event;
   
   public class CTimerEvent extends Event
   {
      
      public static const TIMER:String = "Ctimer";
      
      public static const TIMER_COMPLETE:String = "Ctimer_complete";
      
      public var count:Number = 0;
      
      public var rcount:Number = 0;
      
      public function CTimerEvent(param1:Number, param2:Number, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         this.count = param1;
         this.rcount = param2;
         super(param3,param4,param5);
      }
   }
}

