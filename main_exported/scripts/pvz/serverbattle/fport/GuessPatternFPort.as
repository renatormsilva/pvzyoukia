package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import flash.events.EventDispatcher;
   import manager.LangManager;
   import pvz.serverbattle.knockout.guess.GuessPatternPanel;
   
   public class GuessPatternFPort extends EventDispatcher
   {
      
      public static const COMPETE_GUESS_PATTERN:String = "COMPETE_GUESS_PATTERN";
      
      private var _fore:GuessPatternPanel;
      
      private var _type:String;
      
      private var costgold:int;
      
      private var _patterntype:int;
      
      public function GuessPatternFPort(param1:GuessPatternPanel)
      {
         super();
         this._fore = param1;
      }
      
      public function initPanelData(param1:String, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0) : void
      {
         this.costgold = param5;
         this._patterntype = param4;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SERVERBATTLE_KNOCKOUT_GUESS_PATTERN,param1,param2,param3,param4);
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:String, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callOOO(param2,0,rest[0],rest[1],rest[2]);
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle004"));
         PlantsVsZombies.changeMoneyOrExp(-1 * this.costgold,PlantsVsZombies.RMB,true,false);
         this._fore.close(null,true,this._patterntype);
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

