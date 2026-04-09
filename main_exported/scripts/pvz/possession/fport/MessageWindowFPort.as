package pvz.possession.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import manager.APLManager;
   import pvz.possession.MessageWindow;
   
   public class MessageWindowFPort implements IConnection
   {
      
      private static const MESSAGE:int = 1;
      
      private var _messageWindow:MessageWindow = null;
      
      public function MessageWindowFPort(param1:MessageWindow)
      {
         super();
         this._messageWindow = param1;
      }
      
      public function toMessageInfo() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_MSG,MESSAGE);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == MESSAGE)
         {
            _loc5_.call(param2,param3);
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
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(param1 == MESSAGE)
         {
            this._messageWindow.portShow(param2 as Array);
         }
      }
   }
}

