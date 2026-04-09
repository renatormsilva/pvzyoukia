package manager
{
   import constants.GlobalConstants;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class APLManager
   {
      
      public static const TYPE_1:int = 1;
      
      public static const TYPE_2:int = 2;
      
      public static const TYPE_3:int = 3;
      
      private static const APL_TIME_1:int = 3 * 60 * 60 * 1000;
      
      private static const APL_TIME_2:int = 60 * 60 * 1000;
      
      private static const APL_TIME_3:int = 30 * 60 * 1000;
      
      private static const APL_TIME_4:int = 10 * 60 * 1000;
      
      public static const TIME:int = 5 * 60 * 60;
      
      public static var open:Boolean = true;
      
      private static var timer1:Timer = null;
      
      private static var timer2:Timer = null;
      
      private static var timer3:Timer = null;
      
      private static var timer4:Timer = null;
      
      public function APLManager()
      {
         super();
      }
      
      public static function init(param1:Boolean) : void
      {
         open = param1;
         reset(1);
         reset(2);
         reset(3);
         reset(4);
      }
      
      public static function reset(param1:int) : void
      {
         if(!open)
         {
            return;
         }
         if(param1 == 1 || param1 == 3)
         {
            return;
         }
         switch(param1)
         {
            case 1:
               if(timer1 != null)
               {
                  timer1.stop();
                  timer1.removeEventListener(TimerEvent.TIMER,onTimer2);
               }
               timer1 = new Timer(APL_TIME_1,1);
               timer1.addEventListener(TimerEvent.TIMER,onTimer1);
               timer1.start();
               break;
            case 2:
               if(timer2 != null)
               {
                  timer2.stop();
                  timer2.removeEventListener(TimerEvent.TIMER,onTimer2);
               }
               timer2 = new Timer(APL_TIME_2,1);
               timer2.addEventListener(TimerEvent.TIMER,onTimer2);
               timer2.start();
               break;
            case 3:
               if(timer3 != null)
               {
                  timer3.stop();
                  timer3.removeEventListener(TimerEvent.TIMER,onTimer3);
               }
               timer3 = new Timer(APL_TIME_3,1);
               timer3.addEventListener(TimerEvent.TIMER,onTimer3);
               timer3.start();
               break;
            case 4:
               if(timer4 != null)
               {
                  timer4.stop();
                  timer4.removeEventListener(TimerEvent.TIMER,onTimer4);
               }
               timer4 = new Timer(APL_TIME_4,1);
               timer4.addEventListener(TimerEvent.TIMER,onTimer4);
               timer4.start();
         }
      }
      
      private static function onTimer1(param1:TimerEvent) : void
      {
         PlantsVsZombies.showAPLWindow(1);
         stop();
      }
      
      private static function onTimer2(param1:TimerEvent) : void
      {
         PlantsVsZombies.showAPLWindow(2);
         reset(2);
      }
      
      private static function onTimer3(param1:TimerEvent) : void
      {
         PlantsVsZombies.showAPLWindow(3);
         stop();
      }
      
      private static function onTimer4(param1:TimerEvent) : void
      {
         if(!GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.showAddFriends(null);
         }
         reset(4);
      }
      
      private static function stop() : void
      {
         if(timer1 != null)
         {
            timer1.stop();
            timer1.removeEventListener(TimerEvent.TIMER,onTimer2);
         }
         if(timer2 != null)
         {
            timer2.stop();
            timer2.removeEventListener(TimerEvent.TIMER,onTimer2);
         }
         if(timer3 != null)
         {
            timer3.stop();
            timer3.removeEventListener(TimerEvent.TIMER,onTimer3);
         }
         if(timer4 != null)
         {
            timer4.stop();
            timer4.removeEventListener(TimerEvent.TIMER,onTimer4);
         }
      }
   }
}

