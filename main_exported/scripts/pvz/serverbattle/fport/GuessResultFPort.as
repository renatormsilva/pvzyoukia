package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.entity.Guess;
   import pvz.serverbattle.knockout.guessResult.GuessResultNode;
   import pvz.serverbattle.knockout.guessResult.GuessResultWindow;
   
   public class GuessResultFPort
   {
      
      public static const ALL_GUESS:int = 1;
      
      public static const GUESS_GET:int = 2;
      
      private var _fore:*;
      
      public function GuessResultFPort(param1:*)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         if(param1 == ALL_GUESS)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ALL_GUESS,ALL_GUESS);
         }
         else if(param1 == GUESS_GET)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GET_GUESS_REWARDS,GUESS_GET,rest[0]);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == ALL_GUESS)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == GUESS_GET)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Guess = null;
         if(param1 == ALL_GUESS)
         {
            _loc3_ = new Array();
            _loc3_ = param2.groups;
            _loc4_ = [];
            (this._fore as GuessResultWindow).updateGuessStaus(param2.myGuess,true);
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc6_ = new Guess();
               _loc6_.decodeData(_loc3_[_loc5_]);
               _loc4_.push(_loc6_);
               _loc5_++;
            }
            (this._fore as GuessResultWindow).showGuessInfo(_loc4_);
         }
         else if(param1 == GUESS_GET)
         {
            (this._fore as GuessResultNode).showToolsPrizes(param2);
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

