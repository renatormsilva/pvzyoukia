package pvz.world.repetition.events
{
   import flash.events.Event;
   
   public class StageClickEvent extends Event
   {
      
      public static const RANKING_DATA:String = "RANKING_DATA";
      
      private var _data:Object;
      
      public function StageClickEvent(param1:String, param2:Object)
      {
         this._data = param2;
         super(param1);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

