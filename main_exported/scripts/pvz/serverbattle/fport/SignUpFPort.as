package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.SeverBattleReadyWindow;
   import pvz.serverbattle.qualifying.SignUpWindow;
   
   public class SignUpFPort
   {
      
      public static const RULE_DESCRIPTTION:int = 1;
      
      public static const SETTING:int = 2;
      
      private var _fore:*;
      
      public function SignUpFPort(param1:*)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         if(param1 == RULE_DESCRIPTTION)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SIGNUP_RULEDESCRIPTION,RULE_DESCRIPTTION);
         }
         else if(param1 == SETTING)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SIGN_UP,SETTING,rest[0]);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == RULE_DESCRIPTTION)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == SETTING)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         if(param1 == RULE_DESCRIPTTION)
         {
            (this._fore as SignUpWindow).initUI(param2);
         }
         else if(param1 == SETTING)
         {
            (this._fore as SeverBattleReadyWindow).setOrgsSucess(param2);
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

