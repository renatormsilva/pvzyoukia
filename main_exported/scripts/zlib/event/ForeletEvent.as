package zlib.event
{
   import flash.events.Event;
   
   public class ForeletEvent extends Event
   {
      
      public static const CHANGE_FORELET:String = "ChangeForelet";
      
      public static const CLOSE_FORELET:String = "CloseForelet";
      
      public static const SUB_LOADED:String = "SubObjectLoaded";
      
      public static const COMPLETE:String = "Complete";
      
      public static const ALL_COMPLETE:String = "AllComplete";
      
      public static const ALL_COMPLETE_SELF:String = "AllCompleteSelf";
      
      public static const ERROR:String = "Error";
      
      public var parameter:Object;
      
      public var parameter2:Object;
      
      public function ForeletEvent(param1:String, param2:Object = null, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         this.parameter = param2;
         this.parameter2 = param3;
         super(param1,param4,param5);
      }
   }
}

