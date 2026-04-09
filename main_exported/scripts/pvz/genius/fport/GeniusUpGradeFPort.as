package pvz.genius.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import entity.Tool;
   import manager.PlayerManager;
   import pvz.genius.jewelSystem.GetJewelWindow;
   import pvz.genius.scene.ceil.GeniusCeil;
   import utils.Singleton;
   
   public class GeniusUpGradeFPort
   {
      
      public static var UPGRADE_GENIUS:int = 1;
      
      public static var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _fore:GeniusCeil;
      
      private var m_attack_added:Number = 0;
      
      private var _tool:Tool;
      
      public function GeniusUpGradeFPort(param1:GeniusCeil)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, param2:int, param3:String, param4:Tool) : void
      {
         this._tool = param4;
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_UPGRADE_ORGS_GENIUS,UPGRADE_GENIUS,param2,param3);
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callOO(param2,param3,rest[0],rest[1]);
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:Object = param2["talent"];
         var _loc4_:int = int(_loc3_["updated"]);
         var _loc5_:int = int(_loc3_["talent"]);
         var _loc6_:Object = param2["soul"];
         var _loc7_:int = int(_loc6_["updated"]);
         var _loc8_:int = int(_loc6_["soul"]);
         var _loc9_:Object = param2["org"];
         this.updataSingleOrg(_loc9_);
         this._fore.upLevel(_loc5_,_loc4_,_loc8_,_loc7_,this.m_attack_added);
      }
      
      private function updataSingleOrg(param1:Object) : void
      {
         var _loc2_:Organism = playerManager.getOrganism(playerManager.getPlayer(),param1.id);
         this.m_attack_added = param1.fight_add;
         _loc2_.setBattleE(param1.fight);
         _loc2_.setId(param1.id);
         _loc2_.setOrderId(param1.pid);
         _loc2_.setAttack(param1.at);
         _loc2_.setMiss(param1.mi);
         _loc2_.setSpeed(param1.sp);
         _loc2_.setHp(param1.hp);
         _loc2_.setHp_max(param1.hm);
         _loc2_.setGrade(param1.gr);
         _loc2_.setExp(param1.ex);
         _loc2_.setExp_max(param1.ema);
         _loc2_.setExp_min(param1.emi);
         _loc2_.setPrecision(param1.pr);
         _loc2_.setQuality_name(param1.qu);
         _loc2_.setGardenId(param1.gi);
         _loc2_.setPullulation(param1.ma);
         _loc2_.setCompAtt(param1.sa);
         _loc2_.setCompHp(param1.sh);
         _loc2_.setCompMiss(param1.sm);
         _loc2_.setCompPre(param1.spr);
         _loc2_.setCompSpeed(param1.ss);
         _loc2_.setCompNewMiss(param1.new_syn_miss);
         _loc2_.setCompNewPre(param1.new_syn_precision);
         _loc2_.setGiftData(param1.tals,"object");
         _loc2_.setSoulLevel(param1.soul);
         _loc2_.setSoulHp(param1.soul_add.hp);
         _loc2_.setSoulAtt(param1.soul_add.attack);
         _loc2_.setSoulMiss(param1.soul_add.miss);
         _loc2_.setSoulSpeed(param1.soul_add.speed);
         _loc2_.setSoulPre(param1.soul_add.precision);
         _loc2_.setGeniusHp(param1.tal_add.hp);
         _loc2_.setGeniusAtt(param1.tal_add.attack);
         _loc2_.setGeniusMiss(param1.tal_add.miss);
         _loc2_.setGeniusSpeed(param1.tal_add.speed);
         _loc2_.setGeniusPre(param1.tal_add.precision);
         _loc2_.setMorphHp(param1.tal_add.hp);
         _loc2_.setMorphAtt(param1.tal_add.attack);
         _loc2_.setMorphMiss(param1.tal_add.miss);
         _loc2_.setMorphSpeed(param1.tal_add.speed);
         _loc2_.setMorphPre(param1.tal_add.precision);
         playerManager.getPlayer().updateOrg(_loc2_);
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         if(param2.description == "Exception:宝石不够")
         {
            this.showJewelWindow();
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         }
         PlantsVsZombies.showDataLoading(false);
         PlantsVsZombies.lockScreen(true);
      }
      
      private function showJewelWindow() : void
      {
         new GetJewelWindow(this._tool,null,GetJewelWindow.OPEN_IN_SECNE);
      }
   }
}

