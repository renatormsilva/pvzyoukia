package core.managers
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TimerManager
   {
      
      private static var m_timer:Timer;
      
      public function TimerManager()
      {
         super();
      }
      
      public static function addTimerManager(param1:Number, param2:int) : void
      {
         var onTimer:Function = null;
         var time:Number = param1;
         var count:int = param2;
         onTimer = function(param1:TimerEvent):void
         {
            ++count;
            PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(count);
         };
         if(m_timer != null)
         {
            m_timer.reset();
            m_timer.delay = time;
         }
         else
         {
            m_timer = new Timer(time);
         }
         m_timer.repeatCount = 1;
         m_timer.addEventListener(TimerEvent.TIMER,onTimer);
         m_timer.start();
      }
   }
}

