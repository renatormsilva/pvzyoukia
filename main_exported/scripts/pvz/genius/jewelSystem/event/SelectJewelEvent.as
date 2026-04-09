package pvz.genius.jewelSystem.event
{
   import flash.events.Event;
   
   public class SelectJewelEvent extends Event
   {
      
      public static const SELECT_JEWEL:String = "select_jewel";
      
      public var _jewelId:int;
      
      public function SelectJewelEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super(SELECT_JEWEL,param1,param2);
      }
   }
}

