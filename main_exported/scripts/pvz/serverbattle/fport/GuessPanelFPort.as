package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import flash.events.EventDispatcher;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.entity.PlayerInfo;
   import pvz.serverbattle.knockout.guess.GuessPanel;
   import xmlReader.config.XmlQualityConfig;
   
   public class GuessPanelFPort extends EventDispatcher
   {
      
      public static const COMPETE_GUESS_CAN:String = "COMPETE_GUESS_CAN";
      
      private var _fore:GuessPanel;
      
      private var _type:String;
      
      public function GuessPanelFPort(param1:GuessPanel)
      {
         super();
         this._fore = param1;
      }
      
      public function initPanelData(param1:String, param2:int = 0) : void
      {
         this._type = param1;
         if(param1 == COMPETE_GUESS_CAN)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_KNOCKOUT_GUESS_CAN,param1,param2);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:String, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == COMPETE_GUESS_CAN)
         {
            _loc5_.callO(param2,0,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         if(this._type == COMPETE_GUESS_CAN)
         {
            this.suitGuessPlayersData(param2);
         }
      }
      
      private function suitGuessPlayersData(param1:Object) : void
      {
         var _loc2_:PlayerInfo = new PlayerInfo();
         var _loc3_:Object = param1.user_a;
         var _loc4_:Contestant = new Contestant();
         _loc4_.setId(_loc3_.new_id);
         _loc4_.setName(_loc3_.nickname);
         _loc4_.setfaceUrl(_loc3_.face_url);
         _loc4_.setGrade(_loc3_.grade);
         _loc4_.setServerName(_loc3_.server_name);
         _loc4_.setVipTime(_loc3_.vip_etime);
         _loc4_.setVipGrade(_loc3_.vip_grade);
         _loc4_.setRunPlants(this.getOrganisms(_loc3_.organisms));
         var _loc5_:Contestant = new Contestant();
         var _loc6_:Object = param1.user_b;
         _loc5_.setId(_loc6_.new_id);
         _loc5_.setName(_loc6_.nickname);
         _loc5_.setfaceUrl(_loc6_.face_url);
         _loc5_.setGrade(_loc6_.grade);
         _loc5_.setServerName(_loc6_.server_name);
         _loc5_.setVipTime(_loc6_.vip_etime);
         _loc5_.setVipGrade(_loc6_.vip_grade);
         _loc5_.setRunPlants(this.getOrganisms(_loc6_.organisms));
         _loc2_.firstPlayer = _loc4_;
         _loc2_.secondPlayer = _loc5_;
         _loc2_.prizeId = param1.reward;
         _loc2_.prizeCost4 = param1.cost1;
         _loc2_.prizeCost8 = param1.cost2;
         this._fore.doWithData(_loc2_);
      }
      
      private function getOrganisms(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Organism = null;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Organism();
            _loc4_.setId(param1[_loc3_].new_id);
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

