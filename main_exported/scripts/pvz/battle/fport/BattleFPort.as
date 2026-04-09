package pvz.battle.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Player;
   import entity.PlayerUpInfo;
   import manager.APLManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import node.Icon;
   import pvz.battle.fore.Battlefield;
   import pvz.storage.rpc.GetPrizes_rpc;
   import utils.Singleton;
   import windows.ActionWindow;
   
   public class BattleFPort implements IConnection
   {
      
      private static const GET_PRIZES:int = 1;
      
      private var _battlefield:Battlefield = null;
      
      public function BattleFPort(param1:Battlefield)
      {
         super();
         this._battlefield = param1;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == GET_PRIZES)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:GetPrizes_rpc = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:PlayerManager = null;
         var _loc7_:Player = null;
         var _loc8_:Array = null;
         var _loc9_:PlayerUpInfo = null;
         if(param1 == GET_PRIZES)
         {
            _loc3_ = new GetPrizes_rpc();
            _loc4_ = _loc3_.getAllAwards(param2);
            _loc5_ = _loc3_.getUpInfos(param2);
            _loc6_ = Singleton.getInstance(PlayerManager);
            _loc7_ = _loc6_.getPlayer();
            if(Boolean(_loc5_) && _loc5_.length > 0)
            {
               _loc8_ = this.getGradeUpInfos(param2);
               for each(_loc9_ in _loc8_)
               {
                  _loc9_.upDatePlayer(_loc7_);
               }
            }
            this._battlefield.portShowPrizes(_loc4_,_loc3_.getGameMoneyAwards(param2),_loc3_.getExpAwards(param2),_loc5_);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("battle001"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
         if(param1 == GET_PRIZES)
         {
            this._battlefield.portShowPrizesError(param2.description);
         }
      }
      
      public function toGetPrizes(param1:String) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_BATTLE_GETPRIZES,GET_PRIZES,param1);
      }
      
      public function getGradeUpInfos(param1:Object) : Array
      {
         var _loc4_:PlayerUpInfo = null;
         if(!param1.up_grade)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.up_grade.length)
         {
            _loc4_ = new PlayerUpInfo(param1.up_grade[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

