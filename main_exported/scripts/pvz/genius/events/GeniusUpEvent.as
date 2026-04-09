package pvz.genius.events
{
   import flash.events.Event;
   
   public class GeniusUpEvent extends Event
   {
      
      public static var GENIUS_UP_COMMAD:String = "GENIUS_UP_COMMAD";
      
      private var _attackNum:Number = 0;
      
      public function GeniusUpEvent(param1:String, param2:Number)
      {
         this._attackNum = param2;
         super(param1);
      }
      
      public function get attackNum() : Number
      {
         return this._attackNum;
      }
   }
}

