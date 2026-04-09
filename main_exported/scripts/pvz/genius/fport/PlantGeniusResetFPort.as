package pvz.genius.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import entity.Tool;
   import flash.display.MovieClip;
   import manager.LangManager;
   import manager.PlayerManager;
   import pvz.genius.scene.GeniusScene;
   import pvz.storage.rpc.GetPrizes_rpc;
   import utils.Singleton;
   import windows.PrizesWindow;
   
   public class PlantGeniusResetFPort
   {
      
      public static var RESET_GENIUS:int = 1;
      
      public static var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _fore:GeniusScene;
      
      public function PlantGeniusResetFPort(param1:GeniusScene)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, param2:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_RESET_ORGS_GENIUS,RESET_GENIUS,param2);
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callO(param2,param3,rest[0]);
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var showBackPrize:Function = null;
         var type:int = param1;
         var re:Object = param2;
         showBackPrize = function():void
         {
            var _loc1_:Array = GetPrizes_rpc.getAllBackTools(re.tools);
            addPlayerTool(_loc1_);
            var _loc2_:PrizesWindow = new PrizesWindow(null,PlantsVsZombies._node as MovieClip);
            _loc2_.show(_loc1_);
            updataSingleOrg(re.org);
            _fore.PlantGeniusReset();
         };
         PlantsVsZombies.showDataLoading(false);
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("genius003"),showBackPrize);
      }
      
      public function addPlayerTool(param1:Array) : void
      {
         var _loc3_:Tool = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] is Tool)
            {
               _loc3_ = playerManager.getPlayer().getTool((param1[_loc2_] as Tool).getOrderId());
               if(_loc3_ == null)
               {
                  _loc3_ = new Tool((param1[_loc2_] as Tool).getOrderId());
               }
               playerManager.getPlayer().updateTool((param1[_loc2_] as Tool).getOrderId(),_loc3_.getNum() + (param1[_loc2_] as Tool).getNum());
            }
            _loc2_++;
         }
      }
      
      private function updataSingleOrg(param1:Object) : void
      {
         var _loc2_:Organism = playerManager.getOrganism(playerManager.getPlayer(),param1.id);
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
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

