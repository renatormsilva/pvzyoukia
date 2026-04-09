package pvz.invitePrizes.data
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import pvz.invitePrizes.InvitePrizeWindow;
   
   public class ConsumeData implements IConnection
   {
      
      private static const INIT:int = 2;
      
      private static const GET:int = 3;
      
      internal var _window:InvitePrizeWindow = null;
      
      public function ConsumeData(param1:InvitePrizeWindow)
      {
         super();
         this._window = param1;
      }
      
      public function initConsumeData() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_CONSUME_INIT,INIT);
      }
      
      public function getPrizeData() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_CONSUME_GET_PRIZE,GET);
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
            this._window.layoutConsumeLabel(param2);
         }
         else if(param1 == GET)
         {
            this._window.showConsumeToolsPrizes(param2 as Array);
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

