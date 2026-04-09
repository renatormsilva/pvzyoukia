package pvz.invitePrizes.events
{
   import flash.events.Event;
   
   public class PrizeEvent extends Event
   {
      
      public static const PRIZE_EVENT:String = "PRIZE_EVENT";
      
      private var _prizeObject:Object;
      
      public function PrizeEvent(param1:String, param2:Object)
      {
         this._prizeObject = param2;
         super(param1);
      }
      
      public function get prizeObject() : Object
      {
         return this._prizeObject;
      }
   }
}

