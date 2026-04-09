package pvz.possession.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import manager.APLManager;
   import pvz.possession.PossessionNode;
   
   public class PossessionNodeFPort implements IConnection
   {
      
      public static const QUIT:int = 5;
      
      public static const REWARDS:int = 6;
      
      private var _node:PossessionNode = null;
      
      public function PossessionNodeFPort(param1:PossessionNode)
      {
         super();
         this._node = param1;
      }
      
      public function toQuit(param1:Number) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_QUIT,QUIT,param1);
      }
      
      public function toIncome(param1:Number) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_AWARDS,REWARDS,param1);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == QUIT)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == REWARDS)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param1 == QUIT)
         {
            this._node.portToRelease(param2.money,param2.honor);
         }
         else if(param1 == REWARDS)
         {
            this._node.portToIncome(param2.money,param2.honor);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
   }
}

