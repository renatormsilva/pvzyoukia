package pvz.invitePrizes.data
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import pvz.invitePrizes.InvitePrizeWindow;
   
   public class ActiveData implements IConnection
   {
      
      private static const INIT:int = 2;
      
      private static const GET:int = 3;
      
      public static const PRIZE_A:int = 0;
      
      public static const PRIZE_B:int = 1;
      
      public static const PRIZE_C:int = 2;
      
      private var _window:InvitePrizeWindow = null;
      
      private var _currentPrize:int;
      
      public function ActiveData(param1:InvitePrizeWindow)
      {
         super();
         this._window = param1;
      }
      
      public function initActiveData(param1:int) : void
      {
         if(param1 == PRIZE_A)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVE_INIT,INIT);
         }
         else if(param1 == PRIZE_B)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVE_BIG_INIT,INIT);
         }
         else if(param1 == PRIZE_C)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVE_LIMIT_INIT,INIT);
         }
      }
      
      public function getPrizeData(param1:int) : void
      {
         this._currentPrize = param1;
         if(param1 == PRIZE_A)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVE_GET_PRIZE,GET);
         }
         else if(param1 == PRIZE_B)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVE_BIG_GET_PRIZE,GET);
         }
         else if(param1 == PRIZE_C)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVE_LIMIT_GET,GET);
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == GET)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param1 == INIT)
         {
            this._window.layoutActiveCard(param2);
         }
         else if(param1 == GET)
         {
            if(this._currentPrize == PRIZE_C)
            {
               this._window.showActiveToolsPrizes(param2,1);
            }
            else
            {
               this._window.showActiveToolsPrizes(param2);
            }
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
   }
}

