package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.entity.BoxRewarsInfo;
   import pvz.serverbattle.knockout.rankingRewards.RankingRewardsWindow;
   
   public class RankingRewarsFPort
   {
      
      public static const INIT:int = 1;
      
      public static const GET_PRIZE:int = 2;
      
      private var _fore:RankingRewardsWindow;
      
      public function RankingRewarsFPort(param1:RankingRewardsWindow)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         if(param1 == INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_KNOCKOUT_PRIZE_INIT,INIT);
         }
         else if(param1 == GET_PRIZE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_KNOCKOUT_GET,GET_PRIZE);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == GET_PRIZE)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:BoxRewarsInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         if(param1 == INIT)
         {
            (this._fore as RankingRewardsWindow).showMyRankAndEtime(param2.myRank,param2.etime,param2.status);
            _loc3_ = [];
            _loc3_ = param2.reward as Array;
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc4_ = new BoxRewarsInfo();
               _loc4_.decodeData(_loc3_[_loc6_]);
               _loc5_.push(_loc4_);
               _loc6_++;
            }
            (this._fore as RankingRewardsWindow).getBoxInfos(_loc5_);
         }
         else if(param1 == GET_PRIZE)
         {
            (this._fore as RankingRewardsWindow).showPrizes(param2 as int);
         }
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

