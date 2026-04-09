package pvz.world.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.world.CheckpointReadyWindow;
   
   public class CheckpointReadyWindowFPort implements IConnection
   {
      
      private static const BATTLE:int = 1;
      
      private var _checkpointReadyWindow:CheckpointReadyWindow = null;
      
      public function CheckpointReadyWindowFPort(param1:CheckpointReadyWindow)
      {
         super();
         this._checkpointReadyWindow = param1;
      }
      
      public function battle(param1:int, param2:Array) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_CHECKPOINT_BATTLE,BATTLE,param1,param2);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == BATTLE)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:BattlefieldControlManager = null;
         if(param1 == BATTLE)
         {
            _loc3_ = new BattlefieldControlManager();
            _loc3_.doBattleInfosRPC(param2,BattlefieldControlManager.WORLD);
            _loc3_.setBattletype(BattlefieldControlManager.WORLD);
            this._checkpointReadyWindow.portBattle(_loc3_,_loc3_.getEnemyOrgs(param2));
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

