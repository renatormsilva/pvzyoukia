package pvz.storage
{
   import flash.events.Event;
   
   public class StorageLabelEvent extends Event
   {
      
      public static const STORAGELABEL_CLICK:String = "storageLabel_click";
      
      public var obj:Object = null;
      
      public function StorageLabelEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         this.obj = param2;
         super(param1,param3,param4);
      }
   }
}

