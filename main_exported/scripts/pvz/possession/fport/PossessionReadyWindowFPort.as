package pvz.possession.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import manager.APLManager;
   import manager.PlayerManager;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.possession.PossessionReadyWindow;
   import utils.Singleton;
   
   public class PossessionReadyWindowFPort implements IConnection
   {
      
      public static const HELP:int = 0;
      
      public static const OCCUPY:int = 1;
      
      public static const QUIT:int = 3;
      
      private var _readyWindow:PossessionReadyWindow = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PossessionReadyWindowFPort(param1:PossessionReadyWindow)
      {
         super();
         this._readyWindow = param1;
      }
      
      public function toBattle(param1:Number, param2:Array, param3:int, param4:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_BATTLE,param3 + param4,param1,param2,param3,param4);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callOOOO(param2,param3,rest[0],rest[1],rest[2],rest[3]);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc4_:BattlefieldControlManager = null;
         var _loc3_:int = -1;
         if(param1 > OCCUPY)
         {
            _loc3_ = QUIT;
         }
         else
         {
            _loc3_ = param1;
         }
         this.playerManager.getPlayer().setOccupyNum(this.playerManager.getPlayer().getOccupyNum() - 1);
         if(this.isFight(param2))
         {
            this.playerManager.getPlayer().setMoney(this.playerManager.getPlayer().getMoney() + this.getMoney(param2));
            _loc4_ = new BattlefieldControlManager();
            _loc4_.doBattleInfosRPC(param2.fight,BattlefieldControlManager.POSSESSION);
            _loc4_.setBattletype(_loc3_);
            this._readyWindow.portDoBattle(_loc4_,this.getHonor(param2),this.getCost(param2),_loc4_.getMyOrgs(param2.fight),_loc4_.getEnemyOrgs(param2.fight));
            if(param1 == PossessionReadyWindowFPort.OCCUPY && _loc4_.win)
            {
               this.playerManager.getPlayer().setLastOccupy(this.playerManager.getPlayer().getLastOccupy() - 1);
            }
         }
         else
         {
            if(param1 == PossessionReadyWindowFPort.OCCUPY)
            {
               this.playerManager.getPlayer().setLastOccupy(this.playerManager.getPlayer().getLastOccupy() - 1);
            }
            this._readyWindow.portWithoutBattle(_loc3_,this.getHonor(param2),this.getCost(param2));
         }
      }
      
      private function getCost(param1:Object) : int
      {
         return param1.cost_money;
      }
      
      private function getMoney(param1:Object) : int
      {
         return param1.money;
      }
      
      private function getHonor(param1:Object) : int
      {
         return param1.honor;
      }
      
      private function isFight(param1:Object) : Boolean
      {
         if(param1.is_fight == 1)
         {
            return true;
         }
         return false;
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

