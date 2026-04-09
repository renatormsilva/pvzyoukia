package pvz.battle.manager
{
   import entity.GeniusSkill;
   import entity.Organism;
   import entity.Skill;
   import manager.PlayerManager;
   import pvz.battle.entity.BPlantAttr;
   import pvz.battle.entity.BattleCommand;
   import pvz.battle.entity.BattleNaturalVo;
   import pvz.battle.entity.BuffVo;
   import utils.Singleton;
   import xmlReader.config.XmlQualityConfig;
   
   public class BattlefieldControlManager
   {
      
      public static const ARENA:int = 2;
      
      public static var ENEMY_ORG:int = 1;
      
      public static const HUNTING:int = 1;
      
      public static var MINE_ORG:int = 0;
      
      public static const POSSESSION:int = 3;
      
      public static const WORLD:int = 4;
      
      public static const SERVERBATTLE:int = 5;
      
      public static const JEWEL_BATTLE:int = 6;
      
      public var dieStatus:int;
      
      public var key:String = "";
      
      public var win:Boolean = false;
      
      private var allBattleCommand:Array;
      
      private var battleRound:Array;
      
      private var battletype:int = -1;
      
      private var camp:int;
      
      private var isOK:Boolean = false;
      
      private var nowRoundNum:int = -1;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public var integralAdd:int;
      
      private var _jewelCopyChpaterName:String;
      
      public function BattlefieldControlManager()
      {
         super();
      }
      
      public function getJewelCopyChpaterName() : String
      {
         return this._jewelCopyChpaterName;
      }
      
      public function addRoundCommand(param1:int) : void
      {
         var _loc2_:int = -1;
         var _loc3_:Array = new Array();
         var _loc4_:int = param1;
         while(_loc4_ < this.allBattleCommand.length)
         {
            if(_loc2_ == -1)
            {
               _loc2_ = int(this.allBattleCommand[_loc4_].getCampType());
            }
            if(this.allBattleCommand[_loc4_].getCampType() != _loc2_)
            {
               break;
            }
            if(_loc3_.length <= 0 || this.allBattleCommand[_loc4_].getCout() == _loc3_[0].getCout())
            {
               param1++;
               _loc3_.push(this.allBattleCommand[_loc4_]);
            }
            _loc4_++;
         }
         if(_loc3_ != null)
         {
            this.battleRound.push(_loc3_);
         }
         if(this.allBattleCommand.length > param1)
         {
            this.addRoundCommand(param1);
         }
      }
      
      public function get allBattleNum() : int
      {
         return this.battleRound.length;
      }
      
      public function doBattleInfos(param1:XML) : void
      {
         var _loc4_:String = null;
         var _loc5_:BattleCommand = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:BPlantAttr = null;
         var _loc13_:Skill = null;
         this.isOK = false;
         this.allBattleCommand = new Array();
         this.nowRoundNum = -1;
         var _loc2_:String = param1.fight.win;
         if(_loc2_ == "assailant")
         {
            this.win = true;
         }
         else
         {
            this.win = false;
         }
         this.key = param1.fight.awards_key;
         var _loc3_:int = 0;
         for(_loc4_ in param1.fight.process.item)
         {
            _loc5_ = new BattleCommand();
            _loc3_++;
            _loc5_.setCommand_id(_loc3_);
            _loc5_.setAttack_id(param1.fight.process.item[_loc4_].assailant.@id);
            _loc6_ = [];
            for(_loc7_ in param1.fight.process.item[_loc4_].defender.item)
            {
               _loc11_ = new Object();
               _loc11_["id"] = param1.fight.process.item[_loc4_].defender.item[_loc7_].@id;
               _loc11_["normal_attack"] = param1.fight.process.item[_loc4_].@attack;
               _loc11_["is_fear"] = param1.fight.process.item[_loc4_].@is_fear;
               _loc12_ = new BPlantAttr();
               _loc12_.decode(_loc11_);
               _loc6_.push(_loc12_);
            }
            _loc5_.setAttackedArr(_loc6_);
            if(param1.fight.process.item[_loc4_].assailant.@type == "assailant")
            {
               _loc5_.setCampType(MINE_ORG);
            }
            else
            {
               _loc5_.setCampType(ENEMY_ORG);
            }
            _loc8_ = new Array();
            _loc9_ = new Array();
            for(_loc10_ in param1.fight.process.item[_loc4_].skills.item)
            {
               _loc13_ = new Skill();
               _loc13_.setName(param1.fight.process.item[_loc4_].skills.item[_loc10_].@name);
               _loc13_.setGrade(param1.fight.process.item[_loc4_].skills.item[_loc10_].@grade);
               _loc13_.setId(param1.fight.process.item[_loc4_].skills.item[_loc10_].@id);
               _loc13_.setEffect(param1.fight.process.item[_loc4_].skills.item[_loc10_].@organism_attr);
               if(param1.fight.process.item[_loc4_].skills.item[_loc10_].@user == param1.fight.process.item[_loc4_].assailant.@type)
               {
                  _loc8_.push(_loc13_);
               }
               else
               {
                  _loc9_.push(_loc13_);
               }
            }
            _loc5_.setSkills(_loc8_);
            _loc5_.setSkillsed(_loc9_);
            this.allBattleCommand.push(_loc5_);
         }
         this.doBattleRound();
      }
      
      public function doBattleInfosRPC(param1:Object, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:BattleCommand = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:BPlantAttr = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Skill = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:Object = null;
         var _loc17_:GeniusSkill = null;
         var _loc18_:Array = null;
         var _loc19_:Object = null;
         var _loc20_:BattleNaturalVo = null;
         var _loc21_:Array = null;
         var _loc22_:Object = null;
         var _loc23_:Array = null;
         var _loc24_:BuffVo = null;
         this.isOK = false;
         this.allBattleCommand = new Array();
         this.nowRoundNum = -1;
         this.win = param1.is_winning;
         this.key = param1.awards_key;
         this.dieStatus = param1.die_status;
         this._jewelCopyChpaterName = param1.through_name;
         if(param2 == ARENA)
         {
            this.playerManager.getPlayer().setArenaLastRank(this.playerManager.getPlayer().getArenaRank());
            this.playerManager.getPlayer().setArenaRank(int(param1.rank));
         }
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.proceses.length);
         if(param1.proceses != null && _loc4_ > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = new BattleCommand();
               _loc3_++;
               _loc6_.setCommand_id(_loc3_);
               _loc6_.setAttack_id(param1.proceses[_loc5_].assailant.id);
               _loc7_ = [];
               for(_loc8_ in param1.proceses[_loc5_].defenders)
               {
                  _loc9_ = new BPlantAttr();
                  _loc9_.decode(param1.proceses[_loc5_].defenders[_loc8_]);
                  _loc7_.push(_loc9_);
               }
               _loc6_.setAttackedArr(_loc7_);
               if(_loc7_[0])
               {
                  _loc6_.setCout(param1.proceses[_loc5_].defenders[0].boutCount);
               }
               if(param1.proceses[_loc5_].assailant.type == "assailant")
               {
                  _loc6_.setCampType(MINE_ORG);
               }
               else
               {
                  _loc6_.setCampType(ENEMY_ORG);
               }
               if(param1.proceses[_loc5_].skills != null && param1.proceses[_loc5_].skills.length > 0)
               {
                  _loc10_ = new Array();
                  _loc11_ = new Array();
                  _loc12_ = 0;
                  while(_loc12_ < param1.proceses[_loc5_].skills.length)
                  {
                     _loc13_ = new Skill();
                     _loc13_.setName(param1.proceses[_loc5_].skills[_loc12_].name);
                     _loc13_.setGrade(param1.proceses[_loc5_].skills[_loc12_].grade);
                     _loc13_.setId(param1.proceses[_loc5_].skills[_loc12_].id);
                     _loc13_.setEffect(param1.proceses[_loc5_].skills[_loc12_].organism_attr);
                     _loc13_.setAllAttack(param1.proceses[_loc5_].skills[_loc12_].attack_num);
                     if(param1.proceses[_loc5_].skills[_loc12_].user == param1.proceses[_loc5_].assailant.type)
                     {
                        _loc10_.push(_loc13_);
                     }
                     else
                     {
                        _loc11_.push(_loc13_);
                     }
                     _loc12_++;
                  }
                  _loc6_.setSkills(_loc10_);
                  _loc6_.setSkillsed(_loc11_);
               }
               if(param1.proceses[_loc5_].talentSkills != null && param1.proceses[_loc5_].talentSkills.length > 0)
               {
                  _loc14_ = new Array();
                  _loc15_ = new Array();
                  for each(_loc16_ in param1.proceses[_loc5_].talentSkills)
                  {
                     _loc17_ = new GeniusSkill();
                     _loc17_.decode(_loc16_);
                     if(_loc16_.active == 1)
                     {
                        _loc14_.push(_loc17_);
                     }
                     else if(_loc16_.active == 2)
                     {
                        _loc15_.push(_loc17_);
                     }
                  }
                  _loc6_.setVgenius(_loc14_);
                  _loc6_.setEgenius(_loc15_);
               }
               if(param1.proceses[_loc5_].exclusiveSkills != null && param1.proceses[_loc5_].exclusiveSkills.length > 0)
               {
                  _loc18_ = [];
                  for each(_loc19_ in param1.proceses[_loc5_].exclusiveSkills)
                  {
                     _loc20_ = new BattleNaturalVo();
                     _loc20_.decode(_loc19_);
                     _loc18_.push(_loc20_);
                  }
                  _loc6_.setExclusive(_loc18_);
               }
               if(param1.proceses[_loc5_].spec_buffs != null && param1.proceses[_loc5_].spec_buffs.length > 0)
               {
                  _loc21_ = [];
                  for each(_loc22_ in param1.proceses[_loc5_].spec_buffs)
                  {
                     _loc23_ = this.getexclusiveSkills(param1.proceses,_loc6_.getCout());
                     _loc22_.isfirst = this.isFirstBuff(param1.proceses[_loc5_].exclusiveSkills,_loc22_);
                     _loc24_ = new BuffVo();
                     _loc24_.decode(_loc22_);
                     _loc21_.push(_loc24_);
                  }
                  _loc6_.buffers = _loc21_;
               }
               this.allBattleCommand.push(_loc6_);
               _loc5_++;
            }
         }
         this.doBattleRound();
      }
      
      private function getexclusiveSkills(param1:Array, param2:int) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            if(_loc4_.defenders[0].boutCount == param2)
            {
               _loc3_ = _loc3_.concat(_loc4_.exclusiveSkills);
            }
         }
         return _loc3_;
      }
      
      private function isFirstBuff(param1:Array, param2:Object) : int
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.actionId == param2.target_id && _loc3_.skill_type == param2.skill_type)
            {
               return 1;
            }
         }
         return 2;
      }
      
      public function getBattletype() : int
      {
         return this.battletype;
      }
      
      public function getEnemyOrgs(param1:Object) : Array
      {
         var _loc4_:Organism = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.defenders.length)
         {
            _loc4_ = new Organism();
            _loc4_.setOrderId(param1.defenders[_loc3_].orid);
            _loc4_.setId(param1.defenders[_loc3_].id);
            _loc4_.setHp(param1.defenders[_loc3_].hp);
            _loc4_.setHp_max(param1.defenders[_loc3_].hp_max);
            _loc4_.setGrade(param1.defenders[_loc3_].grade);
            _loc4_.setQuality_name(XmlQualityConfig.getInstance().getName(param1.defenders[_loc3_].quality_id));
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getMyOrgs(param1:Object) : Array
      {
         var _loc4_:Organism = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.assailants.length)
         {
            _loc4_ = new Organism();
            _loc4_.setOrderId(param1.assailants[_loc3_].orid);
            _loc4_.setId(param1.assailants[_loc3_].id);
            _loc4_.setHp(param1.assailants[_loc3_].hp);
            _loc4_.setHp_max(param1.assailants[_loc3_].hp_max);
            _loc4_.setGrade(param1.assailants[_loc3_].grade);
            _loc4_.setQuality_name(XmlQualityConfig.getInstance().getName(param1.assailants[_loc3_].quality_id));
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getNowRound() : Array
      {
         ++this.nowRoundNum;
         if(this.nowRoundNum == this.battleRound.length)
         {
            return null;
         }
         return this.battleRound[this.nowRoundNum];
      }
      
      public function isLastRound() : Boolean
      {
         if(this.nowRoundNum + 1 == this.battleRound.length)
         {
            return true;
         }
         return false;
      }
      
      public function get nowRoudIndex() : int
      {
         return this.nowRoundNum;
      }
      
      public function setBattletype(param1:int) : void
      {
         this.battletype = param1;
      }
      
      public function writeBattle() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.battleRound.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.battleRound[_loc1_].length)
            {
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function destory() : void
      {
         this.battleRound.length = 0;
         this.allBattleCommand.length = 0;
         this.battleRound = null;
         this.playerManager = null;
         this.allBattleCommand = null;
      }
      
      private function doBattleRound() : void
      {
         var _loc1_:int = MINE_ORG;
         this.battleRound = new Array();
         this.addRoundCommand(0);
         this.writeBattle();
         this.isOK = true;
      }
   }
}

