package pvz.world
{
   import flash.events.Event;
   
   public class CheckpointPrizeEvent extends Event
   {
      
      public static const SHOW_PRIZE_TIPS:String = "SHOW_PRIZE_TIPS";
      
      public static const CLEAR_PRIZE_TIPS:String = "CLEAR_PRIZE_TIPS";
      
      public var toolid:int = 0;
      
      public function CheckpointPrizeEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,bubbles,param4);
         this.toolid = param2;
      }
   }
}

