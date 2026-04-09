package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.qualifying.GetQualifyingRewardsWindow;
   
   public class GetRewardsFPort
   {
      
      public static const QUALIFYING_INIT:int = 1;
      
      public static const QUALIFYING_GET:int = 2;
      
      private var _fore:*;
      
      public function GetRewardsFPort(param1:*)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         if(param1 == QUALIFYING_INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.PRC_QUALIFYING_REWARDS,QUALIFYING_INIT);
         }
         else if(param1 == QUALIFYING_GET)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_QUALIFYING_GET_AWARD,QUALIFYING_GET);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == QUALIFYING_INIT || param3 == QUALIFYING_GET)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         if(param1 == QUALIFYING_INIT)
         {
            (this._fore as GetQualifyingRewardsWindow).initUI(param2);
         }
         else if(param1 == QUALIFYING_GET)
         {
            (this._fore as GetQualifyingRewardsWindow).showToolsPrizes(param2);
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

