package pvz.world
{
   import flash.events.Event;
   
   public class InsideWorldEvent extends Event
   {
      
      public static const CHANGE:String = "INSIDEWORLD_CHANGE";
      
      public static const LOCTION_CHANGE:String = "LOCTION_CHANGE";
      
      public static const TO_CHECKPOINT:String = "TO_CHECKPOINT";
      
      public var id:int = 0;
      
      public function InsideWorldEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.id = param2;
      }
   }
}

