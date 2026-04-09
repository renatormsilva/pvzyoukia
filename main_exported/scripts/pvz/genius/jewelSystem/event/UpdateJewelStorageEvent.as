package pvz.genius.jewelSystem.event
{
   import flash.events.Event;
   
   public class UpdateJewelStorageEvent extends Event
   {
      
      public static const UPDATE:String = "update";
      
      public function UpdateJewelStorageEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super(UPDATE,param1,param2);
      }
   }
}

