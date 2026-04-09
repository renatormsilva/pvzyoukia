package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.entity.Message;
   import pvz.serverbattle.qualifying.MessageWindow;
   
   public class MessageFPort
   {
      
      public static const INIT:int = 1;
      
      private var _fore:MessageWindow;
      
      public function MessageFPort(param1:MessageWindow)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_BATTLE_MESSAGE,INIT);
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Message = null;
         var _loc6_:int = 0;
         if(param1 == INIT)
         {
            _loc3_ = new Array();
            _loc3_ = param2 as Array;
            _loc4_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc5_ = new Message();
               _loc5_.decodeData(_loc3_[_loc6_]);
               _loc4_.push(_loc5_);
               _loc6_++;
            }
            (this._fore as MessageWindow).showMessage(_loc4_);
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

