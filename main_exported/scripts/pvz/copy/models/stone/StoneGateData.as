package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   
   public class StoneGateData implements IVo
   {
      
      private var m_id:int;
      
      private var m_name:String;
      
      private var actived:int;
      
      private var m_star:int;
      
      private var m_pre_star:int;
      
      private var m_monsters:Object;
      
      private var m_boss:int;
      
      private var m_grids:int;
      
      private var m_reward_must:Array;
      
      private var m_reward_post:Array;
      
      private var m_reward_through:Array;
      
      private var m_has_reward:int;
      
      private var m_imgId:int;
      
      public function StoneGateData()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.m_id = param1.id;
         this.m_name = param1.name;
         this.actived = param1.actived;
         this.m_star = param1.star;
         this.m_boss = param1.boss;
         this.m_grids = param1.open_cave_grid;
         this.m_monsters = param1.monsters;
         this.m_pre_star = param1.pre_star;
         this.m_has_reward = param1.through_reward;
         this.m_imgId = param1.img_id;
         this.readRewards(param1.reward);
      }
      
      private function readRewards(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Tool = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Tool = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Tool = null;
         var _loc2_:Array = param1["must"];
         var _loc3_:Array = param1["poss"];
         var _loc4_:Array = param1["through"];
         this.m_reward_must = [];
         this.m_reward_post = [];
         this.m_reward_through = [];
         for each(_loc5_ in _loc2_)
         {
            _loc8_ = int(_loc5_.id);
            _loc9_ = int(_loc5_.num);
            _loc10_ = new Tool(_loc8_);
            _loc10_.setNum(_loc9_);
            this.m_reward_must.push(_loc10_);
         }
         for each(_loc6_ in _loc3_)
         {
            _loc11_ = int(_loc6_.id);
            _loc12_ = int(_loc6_.num);
            _loc13_ = new Tool(_loc11_);
            _loc13_.setNum(_loc12_);
            this.m_reward_post.push(_loc13_);
         }
         for each(_loc7_ in _loc4_)
         {
            _loc14_ = int(_loc7_.id);
            _loc15_ = int(_loc7_.num);
            _loc16_ = new Tool(_loc14_);
            _loc16_.setNum(_loc15_);
            this.m_reward_through.push(_loc16_);
         }
      }
      
      public function clearThroughPrizes() : void
      {
         this.m_reward_through = null;
      }
      
      public function getId() : int
      {
         return this.m_id;
      }
      
      public function getImgId() : int
      {
         return this.m_imgId;
      }
      
      public function getName() : String
      {
         return this.m_name;
      }
      
      public function getThroughPrize() : int
      {
         return this.m_has_reward;
      }
      
      public function getBoss() : Boolean
      {
         return this.m_boss == 1 ? true : false;
      }
      
      public function getStar() : int
      {
         return this.m_star;
      }
      
      public function getMustReward() : Array
      {
         return this.m_reward_must;
      }
      
      public function getPostReward() : Array
      {
         return this.m_reward_post;
      }
      
      public function getThroughReward() : Array
      {
         return this.m_reward_through;
      }
      
      public function getActive() : int
      {
         return this.actived;
      }
      
      public function getCaveGrid() : int
      {
         return this.m_grids;
      }
      
      public function getPreStar() : int
      {
         return this.m_pre_star;
      }
      
      public function getNormalZombies() : Array
      {
         var _loc3_:Organism = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Skill = null;
         var _loc1_:Array = this.m_monsters["star_1"];
         if(_loc1_ == null || _loc1_.length == 0)
         {
            throw new Error("一星僵尸数据不存在");
         }
         var _loc2_:Array = [];
         for each(_loc4_ in _loc1_)
         {
            _loc3_ = new Organism();
            _loc3_.setId(_loc4_.id);
            _loc3_.setOrderId(_loc4_.pi);
            _loc3_.setAttack(_loc4_.ak);
            _loc3_.setGrade(_loc4_.gd);
            _loc3_.setMiss(_loc4_.mi);
            _loc3_.setHp(_loc4_.hp);
            _loc3_.setHp_max(_loc4_.hp);
            _loc3_.setPrecision(_loc4_.ps);
            _loc3_.setIsCopyBoss(_loc4_.boss);
            _loc3_.setSpeed(_loc4_.sp);
            _loc3_.setNewMiss(_loc4_.new_miss);
            _loc3_.setNewPrecision(_loc4_.new_precision);
            _loc3_.setSize(_loc4_.size);
            _loc3_.setQuality_name(_loc4_.quality_name);
            _loc3_.setBlood(3);
            _loc3_.setDifficulty(1);
            _loc5_ = _loc4_.talent;
            _loc3_.setFadeGeinus(_loc5_);
            for each(_loc6_ in _loc4_.skill)
            {
               _loc7_ = new Skill();
               _loc7_.setId(_loc6_.id);
               _loc7_.setGrade(_loc6_.grade);
               _loc7_.setName(_loc6_.name);
               _loc3_.addSkill(_loc7_);
            }
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public function getMiddleZombies() : Array
      {
         var _loc3_:Organism = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Skill = null;
         var _loc1_:Array = this.m_monsters["star_2"];
         if(_loc1_ == null || _loc1_.length == 0)
         {
            throw new Error("二星僵尸数据不存在");
         }
         var _loc2_:Array = [];
         for each(_loc4_ in _loc1_)
         {
            _loc3_ = new Organism();
            _loc3_.setId(_loc4_.id);
            _loc3_.setOrderId(_loc4_.pi);
            _loc3_.setAttack(_loc4_.ak);
            _loc3_.setGrade(_loc4_.gd);
            _loc3_.setMiss(_loc4_.mi);
            _loc3_.setNewMiss(_loc4_.new_miss);
            _loc3_.setNewPrecision(_loc4_.new_precision);
            _loc3_.setHp(_loc4_.hp);
            _loc3_.setHp_max(_loc4_.hp);
            _loc3_.setPrecision(_loc4_.ps);
            _loc3_.setIsCopyBoss(_loc4_.boss);
            _loc3_.setSpeed(_loc4_.sp);
            _loc3_.setSize(_loc4_.size);
            _loc3_.setQuality_name(_loc4_.quality_name);
            _loc3_.setBlood(3);
            _loc3_.setDifficulty(2);
            _loc5_ = _loc4_.talent;
            _loc3_.setFadeGeinus(_loc5_);
            for each(_loc6_ in _loc4_.skill)
            {
               _loc7_ = new Skill();
               _loc7_.setId(_loc6_.id);
               _loc7_.setGrade(_loc6_.grade);
               _loc7_.setName(_loc6_.name);
               _loc3_.addSkill(_loc7_);
            }
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public function getHardZombies() : Array
      {
         var _loc3_:Organism = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Skill = null;
         var _loc1_:Array = this.m_monsters["star_3"];
         if(_loc1_ == null || _loc1_.length == 0)
         {
            throw new Error("三星僵尸数据不存在");
         }
         var _loc2_:Array = [];
         for each(_loc4_ in _loc1_)
         {
            _loc3_ = new Organism();
            _loc3_.setId(_loc4_.id);
            _loc3_.setOrderId(_loc4_.pi);
            _loc3_.setAttack(_loc4_.ak);
            _loc3_.setGrade(_loc4_.gd);
            _loc3_.setMiss(_loc4_.mi);
            _loc3_.setNewMiss(_loc4_.new_miss);
            _loc3_.setNewPrecision(_loc4_.new_precision);
            _loc3_.setPrecision(_loc4_.ps);
            _loc3_.setIsCopyBoss(_loc4_.boss);
            _loc3_.setSize(_loc4_.size);
            _loc3_.setSpeed(_loc4_.sp);
            _loc3_.setQuality_name(_loc4_.quality_name);
            _loc3_.setBlood(3);
            _loc3_.setDifficulty(3);
            _loc5_ = _loc4_.talent;
            _loc3_.setFadeGeinus(_loc5_);
            for each(_loc6_ in _loc4_.skill)
            {
               _loc7_ = new Skill();
               _loc7_.setId(_loc6_.id);
               _loc7_.setGrade(_loc6_.grade);
               _loc7_.setName(_loc6_.name);
               _loc3_.addSkill(_loc7_);
            }
            _loc3_.setHp(_loc4_.hp);
            _loc3_.setHp_max(_loc4_.hp);
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
   }
}

