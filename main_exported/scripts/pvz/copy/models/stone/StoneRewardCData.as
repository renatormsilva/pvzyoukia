package pvz.copy.models.stone
{
   import entity.Tool;
   
   public class StoneRewardCData
   {
      
      private var m_rewards:Array;
      
      private var m_hasreward:int;
      
      private var m_star:int;
      
      private var m_starAll:int;
      
      private var m_starCan:int;
      
      private var m_chapterId:int;
      
      private var m_GetRawards:Array;
      
      private var mrewarded:int;
      
      private var m_starnextan:int;
      
      public function StoneRewardCData()
      {
         super();
      }
      
      private function readPrizes(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.tools.length)
         {
            _loc4_ = new Tool(param1.tools[_loc3_].tool_id);
            _loc4_.setNum(param1.tools[_loc3_].amount);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getHasReward() : Boolean
      {
         return this.m_hasreward == 1 ? true : false;
      }
      
      public function getRewards() : Array
      {
         return this.m_rewards;
      }
      
      public function getCurrentStar() : int
      {
         return this.m_star;
      }
      
      public function getAllStar() : int
      {
         return this.m_starAll;
      }
      
      public function getChapterId() : int
      {
         return this.m_chapterId;
      }
      
      public function getCanGetStar() : int
      {
         return this.m_starCan;
      }
      
      public function decodeInfo(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:StoneRewardData = null;
         var _loc2_:Array = param1.info;
         this.m_rewards = [];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new StoneRewardData();
            _loc4_.decode(_loc3_);
            this.m_rewards.push(_loc4_);
         }
         this.m_hasreward = param1.has_reward;
         this.m_star = param1.star;
         this.m_starAll = param1.star_tol;
         this.m_starCan = param1.star_can;
         this.m_starnextan = param1.next_star;
         this.m_chapterId = param1.chap_id;
         this.mrewarded = param1.all_rewarded;
      }
      
      public function getAllRewarded() : int
      {
         return this.mrewarded;
      }
      
      public function getNextRewardStar() : int
      {
         return this.m_starnextan;
      }
      
      public function decodeGetPrize(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Tool = null;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         this.m_GetRawards = [];
         for each(_loc2_ in param1)
         {
            _loc3_ = new Tool(_loc2_["id"]);
            _loc3_.setNum(_loc2_["num"]);
            this.m_GetRawards.push(_loc3_);
         }
      }
      
      public function getPrizes() : Array
      {
         return this.m_GetRawards;
      }
   }
}

