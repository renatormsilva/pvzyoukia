package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.entity.PlayerInfo;
   import pvz.serverbattle.knockout.KnockoutForelet;
   import pvz.serverbattle.knockout.scene.GuessButton;
   import pvz.serverbattle.knockout.scene.Pothunter;
   
   public class KnockoutFPort
   {
      
      public static const CAN_GUESS:int = 1;
      
      public static const ALREADY_GUESSED:int = 2;
      
      public static const EXAMAINE_BATTLE:int = 3;
      
      public static const INIT:String = "INIT";
      
      public static const COMPETE_GUESS_CAN:String = "COMPETE_GUESS_CAN";
      
      public static const COMPETE_GUESS_ALREADY:String = "COMPETE_GUESS_ALREADY";
      
      public static const FIGHT_EXAMINE:String = "FIGHT_EXAMINE";
      
      private var _fore:KnockoutForelet;
      
      private var _type:String;
      
      public function KnockoutFPort(param1:KnockoutForelet)
      {
         super();
         this._fore = param1;
      }
      
      public function initPanelData(param1:String, param2:int = 0) : void
      {
         this._type = param1;
         if(param1 == INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_KNOCKOUT_INIT,param1,param2);
         }
         else if(param1 == COMPETE_GUESS_CAN)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_KNOCKOUT_INIT,param1,param2);
         }
         else if(param1 == COMPETE_GUESS_ALREADY)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_KNOCKOUT_INIT,param1,param2);
         }
         else if(param1 == FIGHT_EXAMINE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_KNOCKOUT_FIGHT_EXAMINE,param1,param2);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:String, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,0);
         }
         else
         {
            _loc5_.callO(param2,0,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         if(this._type == INIT)
         {
            this._fore.initData(param2);
         }
         else
         {
            this._fore.exmineFight(param2);
         }
      }
      
      public function getPlayersInfo(param1:Object) : PlayerInfo
      {
         var _loc2_:PlayerInfo = new PlayerInfo();
         var _loc3_:Object = param1.assailant;
         var _loc4_:Contestant = new Contestant();
         _loc4_.setId(_loc3_.new_id);
         _loc4_.setName(_loc3_.nickname);
         _loc4_.setfaceUrl(_loc3_.face_url);
         _loc4_.setGrade(_loc3_.grade);
         _loc4_.setServerName(_loc3_.server_name);
         _loc4_.setVipTime(_loc3_.vip_etime);
         _loc4_.setVipGrade(_loc3_.vip_grade);
         var _loc5_:Contestant = new Contestant();
         var _loc6_:Object = param1.defender;
         _loc5_.setId(_loc6_.new_id);
         _loc5_.setName(_loc6_.nickname);
         _loc5_.setfaceUrl(_loc6_.face_url);
         _loc5_.setGrade(_loc6_.grade);
         _loc5_.setServerName(_loc6_.server_name);
         _loc5_.setVipTime(_loc6_.vip_etime);
         _loc5_.setVipGrade(_loc6_.vip_grade);
         _loc2_.firstPlayer = _loc4_;
         _loc2_.secondPlayer = _loc5_;
         _loc2_.type = PlayerInfo.KNOCKOUT;
         return _loc2_;
      }
      
      public function getGroupsData(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:GuessButton = null;
         var _loc2_:Array = param1.groups;
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            _loc6_ = new GuessButton();
            _loc6_.id = _loc4_.id;
            _loc6_.status = _loc4_.status;
            _loc6_.index = _loc4_.index;
            _loc3_.push(_loc6_);
         }
         return this.order(_loc3_);
      }
      
      private function order(param1:Array) : Array
      {
         var _loc3_:GuessButton = null;
         var _loc4_:* = 0;
         if(param1 == null || param1.length <= 1)
         {
            return param1;
         }
         var _loc2_:int = 1;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as GuessButton).index > (_loc3_ as GuessButton).index)
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function getUsersPretendData(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Pothunter = null;
         var _loc2_:Array = param1.users;
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = new Pothunter();
            _loc5_.setfaceurl(_loc4_.face_url);
            _loc5_.setservername(_loc4_.serverName);
            _loc5_.setnickName(_loc4_.nickname);
            _loc5_.setwin1(_loc4_.win1);
            _loc5_.setwin2(_loc4_.win2);
            _loc5_.setwin3(_loc4_.win3);
            _loc5_.setwin4(_loc4_.win4);
            _loc5_.setviptime(_loc4_.vip_etime);
            _loc5_.setvipgrade(_loc4_.vip_grade);
            _loc3_.push(_loc5_);
         }
         return _loc3_;
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

