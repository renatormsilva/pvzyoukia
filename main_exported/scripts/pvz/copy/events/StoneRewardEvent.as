package pvz.copy.events
{
   import flash.events.Event;
   
   public class StoneRewardEvent extends Event
   {
      
      public static const GET_REWARDS:String = "GET_REWARDS";
      
      public static const SHOW_REWARDS:String = "SHOW_REWARDS";
      
      public var index:int = 0;
      
      public function StoneRewardEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         this.index = param2;
         super(param1,param3,param4);
      }
   }
}

