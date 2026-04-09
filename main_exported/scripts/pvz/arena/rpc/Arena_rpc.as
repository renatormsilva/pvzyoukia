package pvz.arena.rpc
{
   import entity.Organism;
   import entity.Player;
   import entity.Tool;
   import manager.PlayerManager;
   import pvz.arena.entity.ArenaEnemy;
   import pvz.arena.entity.ArenaPrize;
   import utils.Singleton;
   import xmlReader.config.XmlQualityConfig;
   
   public class Arena_rpc
   {
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function Arena_rpc()
      {
         super();
      }
      
      public function getArenaAllRank(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Player = null;
         var _loc2_:Array = new Array();
         if(param1 == null)
         {
            return null;
         }
         for(_loc3_ in param1)
         {
            _loc4_ = new Player();
            _loc4_.setNickname(param1[_loc3_].nickname);
            _loc4_.setVipLevel(param1[_loc3_].vip_grade);
            _loc4_.setVipTime(param1[_loc3_].vip_etime);
            _loc4_.setGrade(param1[_loc3_].grade);
            _loc4_.setArenaRank(param1[_loc3_].rank);
            _loc4_.setFaceUrl2(param1[_loc3_].face);
            _loc2_.push(_loc4_);
         }
         return this.onderRank(_loc2_);
      }
      
      private function onderRank(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as Player).getArenaRank() > _loc3_.getArenaRank())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function orderEnemy(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as ArenaEnemy).getArenaRank() > _loc3_.getArenaRank())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function getInitLog(param1:Object) : Array
      {
         return param1.log;
      }
      
      public function getAttention(param1:Object) : int
      {
         return param1.attention;
      }
      
      private function orderOrgs(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as Organism).getGrade() < _loc3_.getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function getInitEnemy(param1:Object) : Array
      {
         var _loc4_:ArenaEnemy = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Organism = null;
         var _loc2_:Array = new Array();
         if(param1.opponent == null)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.opponent.length)
         {
            if(param1.opponent[_loc3_] != null)
            {
               _loc4_ = new ArenaEnemy();
               _loc4_.setNickName(param1.opponent[_loc3_].nickname);
               _loc4_.setUserId(param1.opponent[_loc3_].userid);
               _loc4_.setArenaRank(param1.opponent[_loc3_].rank);
               _loc4_.setPlatformUserId(int(param1.opponent[_loc3_].platform_user_id));
               _loc4_.setGrade(param1.opponent[_loc3_].grade);
               _loc4_.setFaceUrl(param1.opponent[_loc3_].face);
               _loc4_.setVipLevel(param1.opponent[_loc3_].vip_grade);
               _loc4_.setVipTime(param1.opponent[_loc3_].vip_etime);
               _loc5_ = new Array();
               _loc6_ = 0;
               while(_loc6_ < param1.opponent[_loc3_].organism.length)
               {
                  _loc7_ = new Organism();
                  _loc7_.setOrderId(param1.opponent[_loc3_].organism[_loc6_].orid);
                  _loc7_.setQuality_name(XmlQualityConfig.getInstance().getName(param1.opponent[_loc3_].organism[_loc6_].quality));
                  _loc7_.setGrade(param1.opponent[_loc3_].organism[_loc6_].grade);
                  _loc7_.setHp_max(param1.opponent[_loc3_].organism[_loc6_].hp);
                  _loc7_.setId(param1.opponent[_loc3_].organism[_loc6_].id);
                  _loc7_.setBattleE(param1.opponent[_loc3_].organism[_loc6_].fighting);
                  _loc7_.setSoulLevel(param1.opponent[_loc3_].organism[_loc6_].soul);
                  _loc5_.push(_loc7_);
                  _loc6_++;
               }
               _loc4_.setArenaOrgs(this.orderOrgs(_loc5_));
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return this.orderEnemy(_loc2_);
      }
      
      public function getInitPlayer(param1:Object, param2:Player) : Player
      {
         param2.setArenaNum(param1.owner.num);
         if(param1.owner.rank != null)
         {
            param2.setArenaRank(int(param1.owner.rank));
         }
         if(param1.owner.organisms == null)
         {
            return param2;
         }
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.owner.organisms.length)
         {
            _loc3_.push(this.playerManager.getOrganism(param2,param1.owner.organisms[_loc4_]));
            _loc4_++;
         }
         param2.setArenaOrgs(_loc3_);
         return param2;
      }
      
      public function getWeekPrize(param1:Object) : Array
      {
         var _loc4_:ArenaPrize = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Tool = null;
         var _loc2_:Array = new Array();
         if(param1.award == null)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.award.length)
         {
            _loc4_ = new ArenaPrize();
            if(param1.award[_loc3_].award == "1")
            {
               _loc4_.setIsGet(true);
            }
            _loc4_.setRankMax(param1.award[_loc3_].max_rank);
            _loc4_.setRankMin(param1.award[_loc3_].min_rank);
            if(param1.award[_loc3_].tool != null)
            {
               _loc5_ = new Array();
               _loc6_ = 0;
               while(_loc6_ < param1.award[_loc3_].tool.length)
               {
                  _loc7_ = new Tool(param1.award[_loc3_].tool[_loc6_].id);
                  _loc7_.setNum(param1.award[_loc3_].tool[_loc6_].amount);
                  _loc5_.push(_loc7_);
                  _loc6_++;
               }
               _loc4_.setTools(_loc5_);
            }
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

