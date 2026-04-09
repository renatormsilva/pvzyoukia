package pvz.copy.net
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import flash.events.EventDispatcher;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   
   public class ActivtyCopyFPort extends EventDispatcher
   {
      
      public static const LIMIT_CHPATER_INFO:int = 3;
      
      public static const LIMIT_CHECKPOINT_INFO:int = 4;
      
      public static const BUY_TIMES:int = 5;
      
      public static const CDTIME_INIT:int = 6;
      
      public static const ACTIVTY_COPY_INFO:int = 7;
      
      public static const ADD_TIIME_USE_TOOL:int = 8;
      
      public static const GET_ACTIVTY_STATE:int = 9;
      
      private const LIMIT_COPY_ID:int = 1;
      
      private const CD_COPY_ID:int = 2;
      
      public function ActivtyCopyFPort()
      {
         super();
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         PlantsVsZombies.showDataLoading(true);
         if(param1 == LIMIT_CHPATER_INFO)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_COPY_GETCHPATERS,LIMIT_CHPATER_INFO,this.LIMIT_COPY_ID);
         }
         else if(param1 == LIMIT_CHECKPOINT_INFO)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_COPY_CHECKPOINTS,LIMIT_CHECKPOINT_INFO,this.LIMIT_COPY_ID,rest[0]);
         }
         else if(param1 == BUY_TIMES)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_COPY_BUYTIMES,BUY_TIMES,rest[0],rest[1]);
         }
         else if(param1 == CDTIME_INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_COPY_CHECKPOINTS,CDTIME_INIT,this.CD_COPY_ID);
         }
         else if(param1 == ACTIVTY_COPY_INFO)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_COPY_INFO,ACTIVTY_COPY_INFO);
         }
         else if(param1 == ADD_TIIME_USE_TOOL)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TOOLS_USE,ADD_TIIME_USE_TOOL,rest[0],rest[1]);
         }
         else if(param1 == GET_ACTIVTY_STATE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_STATE,GET_ACTIVTY_STATE);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == LIMIT_CHPATER_INFO)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == LIMIT_CHECKPOINT_INFO || param3 == BUY_TIMES || param3 == ADD_TIIME_USE_TOOL)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == CDTIME_INIT)
         {
            _loc5_.callOO(param2,param3,rest[0],1);
         }
         else if(param3 == ACTIVTY_COPY_INFO || param3 == GET_ACTIVTY_STATE)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:HandleDataCompleteEvent = new HandleDataCompleteEvent();
         _loc3_._data = param2;
         dispatchEvent(_loc3_);
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

