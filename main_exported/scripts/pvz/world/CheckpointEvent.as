package pvz.world
{
   import flash.events.Event;
   
   public class CheckpointEvent extends Event
   {
      
      public static const CHANGE:String = "CHECKPOINT_CHANGE";
      
      public static const UPDATE:String = "INSIDEWORLD_UPDATE";
      
      public static const INSIDEWORLD_CHANGE:String = "INSIDEWORLD_CHANGE";
      
      public static const SHOW_BOX_TIPS:String = "SHOW_BOX_TIPS";
      
      public static const CLEAR_BOX_TIPS:String = "CLEAR_BOX_TIPS";
      
      public static const SHOW_TIPS:String = "SHOW_TIPS";
      
      public static const CLEAR_TIPS:String = "CLEAR_TIPS";
      
      public var checkpoint:Checkpoint = null;
      
      public function CheckpointEvent(param1:String, param2:Checkpoint, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.checkpoint = param2;
      }
   }
}

