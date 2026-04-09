package com.display
{
   import flash.events.Event;
   
   public class CMovieClipEvent extends Event
   {
      
      public static const COMPLETE:String = "play_complete";
      
      public function CMovieClipEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

