package com.display
{
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import core.managers.GameManager;
   
   public class CMovieClipRecycleBin
   {
      
      private static const RECYCLE_TIMER:int = 10 * 1000;
      
      private static var arr:Array = null;
      
      private static var timer:CTimer = null;
      
      public function CMovieClipRecycleBin()
      {
         super();
      }
      
      public static function onTimer(param1:CTimerEvent) : void
      {
         if(arr == null || arr.length < 1)
         {
            timer.stop();
            timer.removeEventListener(CTimerEvent.TIMER,onTimer);
            timer = null;
            return;
         }
         var _loc2_:* = int(arr.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ > -1)
         {
            if(!GameManager.pvzStage.contains(arr[_loc3_] as CMovieClip))
            {
               (arr[_loc3_] as CMovieClip).destroy();
               arr[_loc3_] = null;
               arr.splice(_loc3_,1);
               _loc2_--;
            }
            _loc3_--;
         }
         if(arr.length == 0)
         {
            arr = null;
         }
      }
      
      public static function put(param1:CMovieClip) : void
      {
         if(timer == null)
         {
            timer = new CTimer(RECYCLE_TIMER);
            timer.addEventListener(CTimerEvent.TIMER,onTimer);
            timer.start();
         }
         if(arr == null)
         {
            arr = new Array();
         }
         arr.push(param1);
      }
   }
}

