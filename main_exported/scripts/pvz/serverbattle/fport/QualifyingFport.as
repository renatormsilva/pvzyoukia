package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import flash.events.EventDispatcher;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.qualifying.QualityingPanel;
   import xmlReader.config.XmlQualityConfig;
   
   public class QualifyingFport extends EventDispatcher
   {
      
      public static const INIT:String = "INIT";
      
      public static const GET_OPPONET:String = "GET_OPPONET";
      
      public static const OVER_ADD_CHANGE_NUM:String = "OVER_ADD_CHANGE_NUM";
      
      public static const BATTLE_CHALLENGE:String = "BATTLE_CHALLENGE";
      
      private var _fore:QualityingPanel;
      
      private var _type:String;
      
      public function QualifyingFport(param1:QualityingPanel)
      {
         super();
         this._fore = param1;
      }
      
      public function initPanelData(param1:String, param2:int = 0) : void
      {
         this._type = param1;
         if(param1 == INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_QULITYING_INIT,param1);
         }
         else if(param1 == GET_OPPONET)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_QULITYING_GET_OPPONENT,param1);
         }
         else if(param1 == OVER_ADD_CHANGE_NUM)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_QULITYING_BUY_CHALLENGECOUNT,param1);
         }
         else if(param1 == BATTLE_CHALLENGE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_QULITYING_CHALLENGE,param1);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:String, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,0);
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         if(this._type == INIT)
         {
            this._fore.initData(param2);
         }
         else if(this._type == GET_OPPONET)
         {
            this.dealWithData(param2);
         }
         else if(this._type == OVER_ADD_CHANGE_NUM)
         {
            this._fore.upDataRemainChallengesMoneyAndNum(param2);
         }
         else if(this._type == BATTLE_CHALLENGE)
         {
            this._fore.startBattle(param2);
         }
      }
      
      private function dealWithData(param1:Object) : void
      {
         var _loc2_:Array = [];
         var _loc3_:Object = param1.my;
         var _loc4_:Contestant = new Contestant();
         _loc4_.setId(_loc3_.id);
         _loc4_.setName(_loc3_.nickname);
         _loc4_.setfaceUrl(_loc3_.face_url);
         _loc4_.setGrade(_loc3_.grade);
         _loc4_.setIntegral(_loc3_.integral);
         _loc4_.setRunPlants(this.getOrganisms(_loc3_.organisms));
         _loc4_.setServerName(_loc3_.server_name);
         _loc4_.setVipTime(_loc3_.vip_etime);
         _loc4_.setVipGrade(_loc3_.vip_grade);
         var _loc5_:Contestant = new Contestant();
         var _loc6_:Object = param1.opponent;
         _loc5_.setId(_loc6_.id);
         _loc5_.setName(_loc6_.nickname);
         _loc5_.setfaceUrl(_loc6_.face_url);
         _loc5_.setGrade(_loc6_.grade);
         _loc5_.setIntegral(_loc6_.integral);
         _loc5_.setRunPlants(this.getOrganisms(_loc6_.organisms));
         _loc5_.setServerName(_loc6_.server_name);
         _loc5_.setVipTime(_loc6_.vip_etime);
         _loc5_.setVipGrade(_loc6_.vip_grade);
         _loc2_.push(_loc4_);
         _loc2_.push(_loc5_);
         this._fore.setSecondPanelData(_loc2_);
      }
      
      private function getOrganisms(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Organism = null;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Organism();
            _loc4_.setId(param1[_loc3_].id);
            _loc4_.setOrderId(param1[_loc3_].organisms_id);
            _loc4_.setQuality_name(XmlQualityConfig.getInstance().getName(param1[_loc3_].quality_id));
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
   }
}

