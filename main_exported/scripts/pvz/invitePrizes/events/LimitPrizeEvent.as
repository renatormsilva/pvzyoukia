package pvz.invitePrizes.events
{
   import flash.events.Event;
   
   public class LimitPrizeEvent extends Event
   {
      
      public static const PRIZE_EVENT:String = "PRIZE_EVENT";
      
      private var _prizeObject:Object;
      
      private var _boxid:int;
      
      public function LimitPrizeEvent(param1:String, param2:Object, param3:int)
      {
         this._prizeObject = param2;
         this._boxid = param3;
         super(param1);
      }
      
      public function get prizeObject() : Object
      {
         return this._prizeObject;
      }
      
      public function get boxid() : int
      {
         return this._boxid;
      }
   }
}

