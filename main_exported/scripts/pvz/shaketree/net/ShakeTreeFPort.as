package pvz.shaketree.net
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import flash.events.EventDispatcher;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import pvz.shaketree.rpc.ShakeTreeInitRpc;
   
   public class ShakeTreeFPort extends EventDispatcher
   {
      
      public static const INIT:int = 0;
      
      public static const ATTACK:int = 1;
      
      public static const ADD_TIMES:int = 2;
      
      public function ShakeTreeFPort()
      {
         super();
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         PlantsVsZombies.showDataLoading(true);
         if(param1 == INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHAKE_TREE_INIT,INIT);
         }
         else if(param1 == ATTACK)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHAKE_TREE_ATTACK,ATTACK,rest[0]);
         }
         else if(param1 == ADD_TIMES)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHAKE_TREE_ADD_TIMES,ATTACK,rest[0]);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == ATTACK || param3 == ADD_TIMES)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:ShakeTreeInitRpc = null;
         var _loc4_:HandleDataCompleteEvent = null;
         PlantsVsZombies.showDataLoading(false);
         if(param1 == INIT)
         {
            _loc3_ = new ShakeTreeInitRpc();
            _loc3_.parseInitData(param2);
            dispatchEvent(new HandleDataCompleteEvent());
         }
         else if(param1 == ATTACK)
         {
            _loc4_ = new HandleDataCompleteEvent();
            _loc4_._data = param2;
            dispatchEvent(_loc4_);
         }
         else if(param1 == ADD_TIMES)
         {
            dispatchEvent(new HandleDataCompleteEvent());
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

