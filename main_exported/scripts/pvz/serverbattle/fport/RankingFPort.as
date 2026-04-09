package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import manager.LangManager;
   import pvz.serverbattle.entity.GuessRankUserInfo;
   import pvz.serverbattle.entity.ScoreRankUserInfo;
   import pvz.serverbattle.ranking.GuessRankWindow;
   import pvz.serverbattle.ranking.ScoreRankWindow;
   
   public class RankingFPort
   {
      
      public static const GUESS_RANK:int = 1;
      
      public static const SCORE_RANK_TODAY:int = 2;
      
      public static const SCORE_RANK_YESTERDAY:int = 3;
      
      private static const TODAY:int = 1;
      
      private static const YESTERDAY:int = 0;
      
      private var _fore:*;
      
      public function RankingFPort(param1:*)
      {
         super();
         this._fore = param1;
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         if(param1 == SCORE_RANK_TODAY)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SCORE_RANK,SCORE_RANK_TODAY,TODAY);
         }
         else if(param1 == SCORE_RANK_YESTERDAY)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SCORE_RANK,SCORE_RANK_YESTERDAY,YESTERDAY);
         }
         else if(param1 == GUESS_RANK)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GUESS_RANK,GUESS_RANK);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == SCORE_RANK_TODAY || param3 == SCORE_RANK_YESTERDAY)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == GUESS_RANK)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:ScoreRankUserInfo = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:GuessRankUserInfo = null;
         var _loc10_:int = 0;
         if(param1 == SCORE_RANK_TODAY)
         {
            (this._fore as ScoreRankWindow).updateMyRank(param2.my_rank);
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < param2.top.length)
            {
               _loc3_ = new ScoreRankUserInfo();
               _loc3_.decodeData(param2.top[_loc5_]);
               _loc4_.push(_loc3_);
               _loc5_++;
            }
            (this._fore as ScoreRankWindow).showUserServerSection(this.getSectionStr(param2.serverGroup,param2.userGroup));
            (this._fore as ScoreRankWindow).updateTodayRank(_loc4_);
         }
         else if(param1 == SCORE_RANK_YESTERDAY)
         {
            (this._fore as ScoreRankWindow).updateMyRank(param2.my_rank);
            _loc6_ = new Array();
            _loc7_ = 0;
            while(_loc7_ < param2.top.length)
            {
               _loc3_ = new ScoreRankUserInfo();
               _loc3_.decodeData(param2.top[_loc7_]);
               _loc6_.push(_loc3_);
               _loc7_++;
            }
            (this._fore as ScoreRankWindow).showUserServerSection(this.getSectionStr(param2.serverGroup,param2.userGroup));
            (this._fore as ScoreRankWindow).updateYesterdayRank(_loc6_);
         }
         else if(param1 == GUESS_RANK)
         {
            (this._fore as GuessRankWindow).updateMyBox(param2.my_amount);
            _loc8_ = new Array();
            _loc10_ = 0;
            while(_loc10_ < param2.top.length)
            {
               _loc9_ = new GuessRankUserInfo();
               _loc9_.decodeData(param2.top[_loc10_]);
               _loc8_.push(_loc9_);
               _loc10_++;
            }
            (this._fore as GuessRankWindow).getDataAndShowRank(_loc8_);
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function getSectionStr(param1:int, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         switch(param1)
         {
            case 1:
               _loc4_ = LangManager.getInstance().getLanguage("severBattle026");
               break;
            case 2:
               _loc4_ = LangManager.getInstance().getLanguage("severBattle022");
               break;
            case 3:
               _loc4_ = LangManager.getInstance().getLanguage("severBattle023");
               break;
            case 4:
               _loc4_ = LangManager.getInstance().getLanguage("severBattle025");
               break;
            case 5:
               _loc4_ = LangManager.getInstance().getLanguage("severBattle024");
         }
         switch(param2)
         {
            case 1:
               _loc5_ = "A";
               break;
            case 2:
               _loc5_ = "B";
               break;
            case 3:
               _loc5_ = "C";
               break;
            case 4:
               _loc5_ = "D";
         }
         return _loc4_ + _loc5_ + LangManager.getInstance().getLanguage("severBattle005");
      }
   }
}

