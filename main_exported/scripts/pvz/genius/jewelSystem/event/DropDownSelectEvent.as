package pvz.genius.jewelSystem.event
{
   import flash.events.Event;
   
   public class DropDownSelectEvent extends Event
   {
      
      public static const SELECT:String = "select";
      
      public var _stype:int;
      
      public function DropDownSelectEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super(SELECT,param1,param2);
      }
   }
}

