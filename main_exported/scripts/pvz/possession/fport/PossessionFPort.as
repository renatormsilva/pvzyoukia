package pvz.possession.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import entity.Player;
   import manager.APLManager;
   import pvz.possession.Possession;
   import pvz.possession.PossessionFore;
   import xmlReader.config.XmlQualityConfig;
   
   public class PossessionFPort implements IConnection
   {
      
      public static const INFO:int = 1;
      
      public static const INIT:int = 2;
      
      private var _possession:PossessionFore = null;
      
      public function PossessionFPort(param1:PossessionFore)
      {
         super();
         this._possession = param1;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INFO)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(param1 == INFO)
         {
            this._possession.clearAll();
            this._possession.portChangeNum(this.readOccupyNum(param2),this.readOccupyNumMax(param2));
            this._possession.portShowHost(this.readHostInfo(param2));
            this._possession.portShowGuest(this.readGuestInfos(param2));
            this._possession.portShowOtherPlayer(this.readChangePlayer(param2));
         }
         else if(param1 == INIT)
         {
            this._possession.portInit(param2.challengecount);
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
      
      public function toPossessionInfo(param1:Number) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_INFO,INFO,param1);
      }
      
      public function toInit() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_INIT,INIT);
      }
      
      private function readChangePlayer(param1:Object) : Player
      {
         var _loc4_:int = 0;
         var _loc2_:Player = new Player();
         var _loc3_:Array = null;
         if(param1.teritory != null && param1.teritory.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.teritory.length)
            {
               if(param1.teritory[_loc4_].user_id == this._possession.playerManager.getPlayerOther().getId())
               {
                  _loc2_.setId(param1.teritory[_loc4_].user_id);
                  _loc2_.setNickname(param1.teritory[_loc4_].user_nickname);
                  _loc2_.setFaceUrl2(param1.teritory[_loc4_].user_face);
                  _loc2_.setCharm(param1.teritory[_loc4_].user_charm);
                  _loc2_.setVipTime(param1.teritory[_loc4_].vip_etime);
                  _loc2_.setVipLevel(param1.teritory[_loc4_].vip_grade);
                  _loc2_.setGrade(param1.teritory[_loc4_].user_grade);
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      private function readGuestInfos(param1:Object) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         if(param1.teritory != null && param1.teritory.length > 0)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < param1.teritory.length)
            {
               if(param1.teritory[_loc3_].user_id != this._possession.playerManager.getPlayerOther().getId())
               {
                  _loc2_.push(this.readPossessionInfo(param1.teritory[_loc3_]));
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      private function readHostInfo(param1:Object) : Possession
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         if(param1.teritory != null && param1.teritory.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.teritory.length)
            {
               if(param1.teritory[_loc3_].user_id == this._possession.playerManager.getPlayerOther().getId())
               {
                  return this.readPossessionInfo(param1.teritory[_loc3_]);
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      private function readOccupyNum(param1:Object) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         return param1.territory_other;
      }
      
      private function readOccupyNumMax(param1:Object) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         return param1.territory_max;
      }
      
      private function readPossessionInfo(param1:Object) : Possession
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Organism = null;
         var _loc2_:Possession = null;
         if(param1 == null)
         {
            return null;
         }
         _loc2_ = new Possession();
         _loc2_.setOccupyId(param1.occupied_user_id);
         _loc2_.setOccupyName(param1.occupied_nickname);
         _loc2_.setOccupyTime(param1.occupied_time);
         _loc2_.setOccuypGrade(param1.occupied_grade);
         _loc2_.setPossessionId(param1.user_id);
         _loc2_.setFace(param1.occupied_face);
         _loc2_.setCostMoney(param1.cost_money);
         _loc2_.setIsHelp(param1.help);
         _loc2_.setIncome(param1.income);
         _loc2_.setMaster(param1.user_nickname);
         _loc2_.setMasterLv(param1.user_grade);
         _loc2_.setCDTime(param1.cd_time);
         _loc2_.setLastAwardTime(param1.award_time);
         _loc2_.setHonor(param1.honor);
         _loc2_.setVipLevel(param1.occupied_vip_grade);
         _loc2_.setVipTime(param1.occupied_vip_etime);
         if(param1.organisms != null && param1.organisms.length > 0)
         {
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < param1.organisms.length)
            {
               _loc5_ = new Organism();
               _loc5_.setId(param1.organisms[_loc4_].id);
               _loc5_.setOrderId(param1.organisms[_loc4_].orid);
               _loc5_.setBattleE(param1.organisms[_loc4_].fighting);
               _loc5_.setGrade(param1.organisms[_loc4_].grade);
               _loc5_.setSoulLevel(param1.organisms[_loc4_].soul);
               _loc5_.setQuality_name(XmlQualityConfig.getInstance().getName(param1.organisms[_loc4_].quality));
               _loc3_.push(_loc5_);
               _loc4_++;
            }
            _loc2_.setOccupyOrgs(_loc3_);
         }
         return _loc2_;
      }
   }
}

