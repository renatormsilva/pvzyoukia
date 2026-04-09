package zmyth.res
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import zlib.log.LogFactory;
   import zlib.log.Logger;
   import zlib.utils.GarbageCollection;
   
   public dynamic class ResourceRecycle extends EventDispatcher implements IDestroy
   {
      
      public static const ALL_DESTROY:String = "All_Destroy";
      
      private static const log:Logger = LogFactory.getLoggerClass(ResourceRecycle);
      
      public var resList:Array = new Array();
      
      public var auto:int;
      
      public function ResourceRecycle(param1:int = 0)
      {
         super();
         this.auto = param1;
         if(this.auto > 0)
         {
            this.doAuto();
         }
      }
      
      public function add(param1:IDestroy) : void
      {
         this.resList.push(param1);
      }
      
      public function doAuto() : void
      {
         var _loc1_:Timer = new Timer(this.auto,1);
         _loc1_.addEventListener(TimerEvent.TIMER,this.onTimer);
         _loc1_.start();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.target as Timer;
         _loc2_.removeEventListener(TimerEvent.TIMER,this.onTimer);
         _loc2_.stop();
         this.destroy();
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.resList.length)
         {
            (this.resList[_loc1_] as IDestroy).destroy();
            if(log.isInfoEnabled)
            {
               log.info(this.resList[_loc1_] + " name:" + this.resList[_loc1_].name + " Destroy OK!");
            }
            _loc1_++;
         }
         this.resList = new Array();
         GarbageCollection.GC();
         this.dispatchEvent(new Event(ALL_DESTROY));
      }
   }
}

