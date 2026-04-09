package pvz.shaketree.event
{
   import flash.events.Event;
   
   public class HandleDataCompleteEvent extends Event
   {
      
      public static const HANDLE_DATA_COMPLETE:String = "handle_data_complete";
      
      public var evtype:int;
      
      public var _data:Object;
      
      public function HandleDataCompleteEvent()
      {
         super(HANDLE_DATA_COMPLETE,false,false);
      }
   }
}

