package entity
{
   import manager.OrganismManager;
   import manager.SkillManager;
   import pvz.genius.vo.Genius;
   import pvz.hunting.window.BattleReadyWindow;
   import utils.BigInt;
   import xmlReader.config.XmlOrganismConfig;
   
   public class Organism
   {
      
      private var _size:Number = 1;
      
      internal var _attack:Number = 0;
      
      internal var _battleEffectiveness:Number = 0;
      
      internal var _blood:int = OrganismManager.PLANT;
      
      internal var _buy_price:int = 0;
      
      internal var _comp_att:Number = 0;
      
      internal var _comp_hp:Number = 0;
      
      internal var _comp_miss:Number = 0;
      
      internal var _comp_pre:Number = 0;
      
      internal var _comp_speed:Number = 0;
      
      internal var _comp_new_miss:Number = 0;
      
      internal var _comp_new_pre:Number = 0;
      
      internal var _genius_att:Number = 0;
      
      internal var _genius_hp:Number = 0;
      
      internal var _genius_miss:Number = 0;
      
      internal var _genius_pre:Number = 0;
      
      internal var _genius_speed:Number = 0;
      
      internal var _genius_new_miss:Number = 0;
      
      internal var _genius_new_pre:Number = 0;
      
      internal var _soul_att:Number = 0;
      
      internal var _soul_hp:Number = 0;
      
      internal var _soul_miss:Number = 0;
      
      internal var _soul_pre:Number = 0;
      
      internal var _soul_speed:Number = 0;
      
      internal var _soul_new_miss:Number = 0;
      
      internal var _soul_new_pre:Number = 0;
      
      internal var _morph_att:Number = 0;
      
      internal var _morph_hp:Number = 0;
      
      internal var _morph_miss:Number = 0;
      
      internal var _morph_pre:Number = 0;
      
      internal var _morph_speed:Number = 0;
      
      internal var _morph_new_miss:Number = 0;
      
      internal var _morph_new_pre:Number = 0;
      
      internal var _difficulty:int = BattleReadyWindow.GENERAL;
      
      internal var _exp:Number = 0;
      
      internal var _exp_max:Number = 1;
      
      internal var _exp_min:Number = 0;
      
      internal var _gainTime:int = 0;
      
      internal var _gardenId:Number = 0;
      
      internal var _gardenType:int = 0;
      
      internal var _grade:int = 0;
      
      internal var _hp:BigInt;
      
      internal var _hp_max:BigInt;
      
      internal var _id:int = 0;
      
      internal var _isArena:Boolean = false;
      
      internal var _isSteal:int = 0;
      
      internal var _miss:Number = 0;
      
      internal var _nextType:int = 0;
      
      internal var _orderId:int = 0;
      
      internal var _owner:String;
      
      internal var _precision:Number = 0;
      
      internal var _new_miss:Number = 0;
      
      internal var _new_precision:Number = 0;
      
      internal var _pullulation:int = 0;
      
      internal var _quality_name:String = "";
      
      internal var _skills:Array;
      
      internal var _exSkills:Array;
      
      internal var _speed:Number = 0;
      
      internal var _typeTime:int = 0;
      
      internal var _x:int = -1;
      
      internal var _y:int = -1;
      
      internal var ihandbook:int = 0;
      
      internal var isPossession:Boolean = false;
      
      internal var _isBoss:int = 0;
      
      internal var _isSeverBattle:Boolean;
      
      internal var _soulLevel:int;
      
      internal var _gift:Genius;
      
      private var _isCopyBoss:int = 0;
      
      private var _fadeGeinus:Array;
      
      private var _isAcceptInherited:Boolean;
      
      private var _pic:int = 0;
      
      public function Organism()
      {
         super();
      }
      
      public function setIsAcceptInherited(param1:int) : void
      {
         this._isAcceptInherited = Boolean(param1);
      }
      
      public function getIsAcceptInherited() : Boolean
      {
         return this._isAcceptInherited;
      }
      
      public function setFadeGeinus(param1:Array) : void
      {
         this._fadeGeinus = param1;
      }
      
      public function setPic(param1:int) : void
      {
         this._pic = param1;
      }
      
      public function getFadeGeinus() : Array
      {
         return this._fadeGeinus;
      }
      
      public function setIsCopyBoss(param1:int) : void
      {
         this._isCopyBoss = param1;
      }
      
      public function getIsCopyBoss() : Boolean
      {
         return this._isCopyBoss > 0;
      }
      
      public function getHp() : BigInt
      {
         return this._hp;
      }
      
      public function setHp(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         var _loc2_:BigInt = new BigInt(param1);
         this._hp = _loc2_;
      }
      
      public function getHp_max() : BigInt
      {
         return this._hp_max;
      }
      
      public function setHp_max(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         var _loc2_:BigInt = new BigInt(param1);
         this._hp_max = _loc2_;
      }
      
      public function setSize(param1:Number) : void
      {
         this._size = param1;
      }
      
      public function getSize() : Number
      {
         return this._size;
      }
      
      public function setGiftData(param1:Object, param2:String = "xml") : void
      {
         if(this._gift == null)
         {
            this._gift = new Genius();
         }
         if(param2 == "xml")
         {
            this._gift.decodeXml(param1);
         }
         else if(param2 == "array")
         {
            this._gift.decodeByArr(param1 as Array);
         }
         else
         {
            this._gift.decode(param1);
         }
      }
      
      public function getGiftData() : Genius
      {
         if(this._gift == null)
         {
            this._gift = new Genius();
         }
         return this._gift;
      }
      
      public function setSoulLevel(param1:int) : void
      {
         this._soulLevel = param1;
      }
      
      public function getSoulLevel() : int
      {
         return this._soulLevel;
      }
      
      public function setIsSeverBattle(param1:Boolean) : void
      {
         this._isSeverBattle = param1;
      }
      
      public function getIsSeverBattle() : Boolean
      {
         return this._isSeverBattle;
      }
      
      public function setIsBoss(param1:int) : void
      {
         this._isBoss = param1;
      }
      
      public function getIsBoss() : int
      {
         return this._isBoss;
      }
      
      public function addSkill(param1:Skill) : void
      {
         if(this._skills == null)
         {
            this._skills = new Array();
         }
         this._skills.push(param1);
      }
      
      public function getAllSkills() : Array
      {
         if(this._skills == null)
         {
            this._skills = new Array();
         }
         return this._skills;
      }
      
      public function addExSkill(param1:ExSkill) : void
      {
         if(this._exSkills == null)
         {
            this._exSkills = [];
         }
         this._exSkills.push(param1);
      }
      
      public function getAllExSkills() : Array
      {
         if(!this._exSkills)
         {
            this._exSkills = [];
         }
         return this._exSkills;
      }
      
      public function getAttack() : Number
      {
         return this._attack;
      }
      
      public function getAttackTimes() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"attackTimes").attackTimes;
      }
      
      public function getAttackType() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"attackType").attackType;
      }
      
      public function getAttribute_name() : String
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"attribute_name").attribute_name;
      }
      
      public function getBattleE() : Number
      {
         if(this._battleEffectiveness == 0)
         {
            return this.statBattleE();
         }
         return this._battleEffectiveness;
      }
      
      public function getBlood() : int
      {
         return this._blood;
      }
      
      public function getBuyPrice() : int
      {
         return this._buy_price;
      }
      
      public function getCompAtt() : Number
      {
         return this._comp_att;
      }
      
      public function getCompHp() : Number
      {
         return this._comp_hp;
      }
      
      public function getCompMiss() : Number
      {
         return this._comp_miss;
      }
      
      public function getCompPre() : Number
      {
         return this._comp_pre;
      }
      
      public function getCompNewMiss() : Number
      {
         return this._comp_new_miss;
      }
      
      public function getCompNewPre() : Number
      {
         return this._comp_new_pre;
      }
      
      public function getCompSpeed() : Number
      {
         return this._comp_speed;
      }
      
      public function getGeniusAtt() : Number
      {
         return this._genius_att;
      }
      
      public function getGeniusHp() : Number
      {
         return this._genius_hp;
      }
      
      public function getGeniusMiss() : Number
      {
         return this._genius_miss;
      }
      
      public function getGeniusNewMiss() : Number
      {
         return this._genius_new_miss;
      }
      
      public function getGeniusNewPre() : Number
      {
         return this._genius_new_pre;
      }
      
      public function getGeniusPre() : Number
      {
         return this._genius_pre;
      }
      
      public function getGeniusSpeed() : Number
      {
         return this._genius_speed;
      }
      
      public function getSoulAtt() : Number
      {
         return this._soul_att;
      }
      
      public function getSoulHp() : Number
      {
         return this._soul_hp;
      }
      
      public function getSoulMiss() : Number
      {
         return this._soul_miss;
      }
      
      public function getSoulPre() : Number
      {
         return this._soul_pre;
      }
      
      public function getSoulSpeed() : Number
      {
         return this._soul_speed;
      }
      
      public function getSoulNewMiss() : Number
      {
         return this._soul_new_miss;
      }
      
      public function getSoulNewPre() : Number
      {
         return this._soul_new_pre;
      }
      
      public function getMorphAtt() : Number
      {
         return this._morph_att;
      }
      
      public function getMorphHp() : Number
      {
         return this._morph_hp;
      }
      
      public function getMorphMiss() : Number
      {
         return this._morph_miss;
      }
      
      public function getMorphPre() : Number
      {
         return this._morph_pre;
      }
      
      public function getMorphSpeed() : Number
      {
         return this._morph_speed;
      }
      
      public function getMorphNewMiss() : Number
      {
         return this._morph_new_miss;
      }
      
      public function getMorphNewPre() : Number
      {
         return this._morph_new_pre;
      }
      
      public function getDifficulty() : int
      {
         return this._difficulty;
      }
      
      public function getEvolution() : Array
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"evolution").evolution;
      }
      
      public function getExp() : Number
      {
         return this._exp;
      }
      
      public function getExp_max() : Number
      {
         return this._exp_max;
      }
      
      public function getExp_min() : Number
      {
         return this._exp_min;
      }
      
      public function getExpl() : String
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"expl").expl;
      }
      
      public function getGainTime() : int
      {
         return this._gainTime;
      }
      
      public function getGardenId() : Number
      {
         return this._gardenId;
      }
      
      public function getGardenType() : int
      {
         return this._gardenType;
      }
      
      public function getGrade() : int
      {
         return this._grade;
      }
      
      public function getHeight() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"height").height;
      }
      
      public function getIHandbook() : int
      {
         return this.ihandbook;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getInitiativeSkill(param1:SkillManager) : Skill
      {
         if(this._skills == null || this._skills.length < 1)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._skills.length)
         {
            if(param1.getSkillById((this._skills[_loc2_] as Skill).getId()).getTouchOff() == Skill.INITIATIVE)
            {
               return this._skills[_loc2_] as Skill;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getIsArena() : Boolean
      {
         return this._isArena;
      }
      
      public function getIsPossession() : Boolean
      {
         return this.isPossession;
      }
      
      public function getIsSteal() : int
      {
         return this._isSteal;
      }
      
      public function getMiss() : Number
      {
         return this._miss;
      }
      
      public function getName() : String
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"orgname").orgname;
      }
      
      public function getNextType() : int
      {
         return this._nextType;
      }
      
      public function getOrderId() : int
      {
         return this._orderId;
      }
      
      public function getOwner() : String
      {
         return this._owner;
      }
      
      public function getPhotosynthesisTime() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"photosynthesis_time").photosynthesis_time;
      }
      
      public function getPicId() : int
      {
         if(this._pic)
         {
            return this._pic;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"picId").picId;
      }
      
      public function getPrecision() : Number
      {
         return this._precision;
      }
      
      public function getNewPrecision() : Number
      {
         return this._new_precision;
      }
      
      public function getNewMiss() : Number
      {
         return this._new_miss;
      }
      
      public function getPullulation() : int
      {
         return this._pullulation;
      }
      
      public function getPurse_amount() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"purse_amount").purse_amount;
      }
      
      public function getQuality_name() : String
      {
         return this._quality_name;
      }
      
      public function getSell_price() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"sell_price").sell_price;
      }
      
      public function getSkill(param1:int) : Skill
      {
         if(this._skills == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._skills.length)
         {
            if(_loc2_ == param1)
            {
               return this._skills[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getExSkill(param1:int) : ExSkill
      {
         if(this._exSkills == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._exSkills.length)
         {
            if(_loc2_ == param1)
            {
               return this._exSkills[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getSpeed() : Number
      {
         return this._speed;
      }
      
      public function getType() : String
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"type").type;
      }
      
      public function getTypeTime() : int
      {
         return this._typeTime;
      }
      
      public function getUpSkill(param1:Tool, param2:SkillManager) : Array
      {
         if(this._skills == null || this._skills.length < 1)
         {
            return null;
         }
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < this._skills.length)
         {
            if(param2.getNextSkillById(this._skills[_loc4_].getId()).getLearnTool() == param1.getOrderId())
            {
               _loc3_.push(this._skills[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getUse_condition() : String
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"use_condition").use_condition;
      }
      
      public function getUse_result() : String
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"use_result").use_result;
      }
      
      public function getWidth() : int
      {
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"width").width;
      }
      
      public function getX() : int
      {
         return this._x;
      }
      
      public function getY() : int
      {
         return this._y;
      }
      
      public function isLearnSkillRepetition(param1:Skill, param2:SkillManager) : Boolean
      {
         if(this._skills == null || this._skills.length < 1)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._skills.length)
         {
            if(param2.getSkillById((this._skills[_loc3_] as Skill).getId()).getGroup() == param1.getGroup())
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function isLearnExSkillRepetition(param1:ExSkill, param2:SkillManager) : Boolean
      {
         if(this._exSkills == null || this._exSkills.length < 1)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._exSkills.length)
         {
            if(param2.getExSkillById((this._exSkills[_loc3_] as ExSkill).getId()).getName() == param1.getName())
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function readOrg(param1:Object) : void
      {
         if(param1.attack != null)
         {
            this.setAttack(param1.attack);
         }
         if(param1.exp != null)
         {
            this.setExp(param1.exp);
         }
         if(param1.exp_min != null)
         {
            this.setExp_min(param1.exp_min);
         }
         if(param1.exp_max != null)
         {
            this.setExp_max(param1.exp_max);
         }
         if(param1.gainTime != null)
         {
            this.setGainTime(param1.gainTime);
         }
         if(param1.grade != null)
         {
            this.setGrade(param1.grade);
         }
         if(param1.gardenType != null)
         {
            this.setGardenType(param1.gardenType);
         }
         if(param1.hp != null)
         {
            this.setHp(param1.hp);
         }
         if(param1.hp_max != null)
         {
            this.setHp_max(param1.hp_max);
         }
         if(param1.id != null)
         {
            this.setId(int(param1.id));
         }
         if(param1.isSteal != null)
         {
            this.setIsSteal(param1.isSteal);
         }
         if(param1.miss != null)
         {
            this.setMiss(param1.miss);
         }
         if(param1.nextType != null)
         {
            this.setNextType(param1.nextType);
         }
         if(param1.orderId != null)
         {
            this.setOrderId(int(param1.orderId));
         }
         if(param1.owner != null)
         {
            this.setOwner(param1.owner);
         }
         if(param1.precision != null)
         {
            this.setPrecision(param1.precision);
         }
         if(param1.pullulation != null)
         {
            this.setPullulation(param1.pullulation);
         }
         if(param1.quality_name != null)
         {
            this.setQuality_name(param1.quality_name);
         }
         if(param1.typeTime != null)
         {
            this.setTypeTime(param1.typeTime);
         }
         if(param1.x != null)
         {
            this.setX(param1.x);
         }
         if(param1.typeTime != null)
         {
            this.setY(param1.y);
         }
         if(param1.speed != null)
         {
            this.setSpeed(param1.speed);
         }
         if(param1.fighting != null)
         {
            this.setBattleE(param1.fighting);
         }
         if(param1.new_precision != null)
         {
            this.setNewPrecision(param1.new_precision);
         }
         if(param1.new_miss != null)
         {
            this.setNewMiss(param1.new_miss);
         }
         if(param1.ec != null)
         {
            this.setIsAcceptInherited(param1.ec);
         }
         if(param1.tal_add != null)
         {
            this.setGeniusAtt(param1.tal_add.attack);
            this.setGeniusHp(param1.tal_add.hp);
            this.setGeniusMiss(param1.tal_add.miss);
            this.setGeniusPre(param1.tal_add.precision);
            this.setGeniusSpeed(param1.tal_add.speed);
         }
         if(param1.soul_add != null)
         {
            this.setSoulAtt(param1.soul_add.attack);
            this.setSoulHp(param1.soul_add.hp);
            this.setSoulMiss(param1.soul_add.miss);
            this.setSoulPre(param1.soul_add.precision);
            this.setSoulSpeed(param1.soul_add.speed);
         }
         if(param1.tal_add != null)
         {
            this.setMorphAtt(param1.tal_add.attack);
            this.setMorphHp(param1.tal_add.hp);
            this.setMorphMiss(param1.tal_add.miss);
            this.setMorphPre(param1.tal_add.precision);
            this.setMorphSpeed(param1.tal_add.speed);
         }
         this.updateSkills(param1.skills);
         this.updateExSkills(param1.ssk);
      }
      
      private function updateExSkills(param1:Array) : void
      {
         var _loc3_:ExSkill = null;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         this._exSkills = [];
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new ExSkill();
            _loc3_.setId(param1[_loc2_].id);
            _loc3_.setGrade(param1[_loc2_].grade);
            _loc3_.setName(param1[_loc2_].name);
            _loc3_.setType(param1[_loc2_].type);
            this.addExSkill(_loc3_);
            _loc2_++;
         }
      }
      
      public function removeSkill(param1:Skill) : void
      {
         if(this._skills == null || this._skills.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._skills.length)
         {
            if((this._skills[_loc2_] as Skill).getId() == param1.getId())
            {
               this._skills.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function setAttack(param1:Number) : void
      {
         this._attack = param1;
      }
      
      public function setBattleE(param1:Number) : void
      {
         this._battleEffectiveness = param1;
      }
      
      public function setBlood(param1:int) : void
      {
         this._blood = param1;
      }
      
      public function setBuyPrice(param1:int) : void
      {
         this._buy_price = param1;
      }
      
      public function setCompAtt(param1:Number) : void
      {
         this._comp_att = param1;
      }
      
      public function setCompHp(param1:Number) : void
      {
         this._comp_hp = param1;
      }
      
      public function setCompMiss(param1:Number) : void
      {
         this._comp_miss = param1;
      }
      
      public function setCompPre(param1:Number) : void
      {
         this._comp_pre = param1;
      }
      
      public function setCompNewMiss(param1:Number) : void
      {
         this._comp_new_miss = param1;
      }
      
      public function setCompNewPre(param1:Number) : void
      {
         this._comp_new_pre = param1;
      }
      
      public function setCompSpeed(param1:Number) : void
      {
         this._comp_speed = param1;
      }
      
      public function setGeniusAtt(param1:Number) : void
      {
         this._genius_att = param1;
      }
      
      public function setGeniusHp(param1:Number) : void
      {
         this._genius_hp = param1;
      }
      
      public function setGeniusMiss(param1:Number) : void
      {
         this._genius_miss = param1;
      }
      
      public function setGeniusNewMiss(param1:Number) : void
      {
         this._genius_new_miss = param1;
      }
      
      public function setGeniusNewPre(param1:Number) : void
      {
         this._genius_new_pre = param1;
      }
      
      public function setGeniusPre(param1:Number) : void
      {
         this._genius_pre = param1;
      }
      
      public function setGeniusSpeed(param1:Number) : void
      {
         this._genius_speed = param1;
      }
      
      public function setSoulAtt(param1:Number) : void
      {
         this._soul_att = param1;
      }
      
      public function setSoulHp(param1:Number) : void
      {
         this._soul_hp = param1;
      }
      
      public function setSoulMiss(param1:Number) : void
      {
         this._soul_miss = param1;
      }
      
      public function setSoulPre(param1:Number) : void
      {
         this._soul_pre = param1;
      }
      
      public function setSoulSpeed(param1:Number) : void
      {
         this._soul_speed = param1;
      }
      
      public function setSoulNewMiss(param1:Number) : void
      {
         this._soul_new_miss = param1;
      }
      
      public function setSoulNewPre(param1:Number) : void
      {
         this._soul_new_pre = param1;
      }
      
      public function setMorphAtt(param1:Number) : void
      {
         this._morph_att = param1;
      }
      
      public function setMorphHp(param1:Number) : void
      {
         this._morph_hp = param1;
      }
      
      public function setMorphMiss(param1:Number) : void
      {
         this._morph_miss = param1;
      }
      
      public function setMorphPre(param1:Number) : void
      {
         this._morph_pre = param1;
      }
      
      public function setMorphSpeed(param1:Number) : void
      {
         this._morph_speed = param1;
      }
      
      public function setMorphNewMiss(param1:Number) : void
      {
         this._morph_new_miss = param1;
      }
      
      public function setMorphNewPre(param1:Number) : void
      {
         this._morph_new_pre = param1;
      }
      
      public function setDifficulty(param1:int) : void
      {
         if(this._blood == OrganismManager.ZOMBIE)
         {
            OrganismManager.changeZombie(this._difficulty,param1,this);
         }
         this._difficulty = param1;
      }
      
      public function setExp(param1:Number) : void
      {
         this._exp = param1;
      }
      
      public function setExp_max(param1:Number) : void
      {
         this._exp_max = param1;
      }
      
      public function setExp_min(param1:Number) : void
      {
         this._exp_min = param1;
      }
      
      public function setGainTime(param1:int) : void
      {
         this._gainTime = param1;
      }
      
      public function setGardenId(param1:Number) : void
      {
         this._gardenId = param1;
      }
      
      public function setGardenType(param1:int) : void
      {
         this._gardenType = param1;
      }
      
      public function setGrade(param1:int) : void
      {
         this._grade = param1;
      }
      
      public function setIHandbook(param1:int) : void
      {
         this.ihandbook = param1;
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function setIsArena(param1:Boolean) : void
      {
         this._isArena = param1;
      }
      
      public function setIsPossession(param1:Boolean) : void
      {
         this.isPossession = param1;
      }
      
      public function setIsSteal(param1:int) : void
      {
         this._isSteal = param1;
      }
      
      public function setMiss(param1:Number) : void
      {
         this._miss = param1;
      }
      
      public function setNextType(param1:int) : void
      {
         this._nextType = param1;
      }
      
      public function setOrderId(param1:int) : void
      {
         this._orderId = param1;
      }
      
      public function setOwner(param1:String) : void
      {
         this._owner = param1;
      }
      
      public function setPrecision(param1:Number) : void
      {
         this._precision = param1;
      }
      
      public function setNewPrecision(param1:Number) : void
      {
         this._new_precision = param1;
      }
      
      public function setNewMiss(param1:Number) : void
      {
         this._new_miss = param1;
      }
      
      public function setPullulation(param1:int) : void
      {
         this._pullulation = param1;
      }
      
      public function setQuality_name(param1:String) : void
      {
         this._quality_name = param1;
      }
      
      public function setSpeed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function setTypeTime(param1:int) : void
      {
         this._typeTime = param1;
      }
      
      public function getAllAddHpValue() : Number
      {
         return this._comp_hp + this._genius_hp + this._soul_hp + this._morph_hp;
      }
      
      public function getAllAddAttackValue() : Number
      {
         return this._comp_att + this._genius_att + this._soul_att + this._morph_att;
      }
      
      public function getAllAddSpeedValue() : Number
      {
         return this._comp_speed + this._genius_speed + this._soul_speed + this._morph_speed;
      }
      
      public function getAllAddMissValue() : Number
      {
         return this._comp_miss + this._genius_miss + this._soul_miss + this._morph_miss;
      }
      
      public function getAllAddPreValue() : Number
      {
         return this._comp_pre + this._genius_pre + this._soul_pre + this._morph_pre;
      }
      
      public function getAllAddNewMissValue() : Number
      {
         return this._comp_new_miss + this._genius_new_miss + this._soul_new_miss + this._morph_new_miss;
      }
      
      public function getAllAddNewPreValue() : Number
      {
         return this._comp_new_pre + this._genius_new_pre + this._soul_new_pre + this._morph_new_pre;
      }
      
      public function setX(param1:int) : void
      {
         this._x = param1;
      }
      
      public function setY(param1:int) : void
      {
         this._y = param1;
      }
      
      public function upSkill(param1:Skill, param2:Skill) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._skills.length)
         {
            if((this._skills[_loc3_] as Skill).getId() == param1.getId())
            {
               this._skills[_loc3_] = param2;
               return;
            }
            _loc3_++;
         }
      }
      
      public function upExSkill(param1:ExSkill, param2:ExSkill) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._exSkills.length)
         {
            if((this._exSkills[_loc3_] as ExSkill).getId() == param1.getId())
            {
               this._exSkills[_loc3_] = param2;
               return;
            }
            _loc3_++;
         }
      }
      
      private function statBattleE() : Number
      {
         var skillsE:Function = function():Number
         {
            var _loc1_:Number = 0;
            if(_skills == null || _skills.length == 0)
            {
               return 0;
            }
            var _loc2_:int = 0;
            while(_loc2_ < _skills.length)
            {
               _loc1_ += Math.pow((_skills[_loc2_] as Skill).getGrade(),2.3) * 2;
               _loc2_++;
            }
            return _loc1_;
         };
         return Math.ceil(Number(this._attack / 12 + this._hp_max.toNumber() / 48 + this._precision / 16 + this._miss / 16 + skillsE()));
      }
      
      private function updateSkills(param1:Array) : void
      {
         var _loc3_:Skill = null;
         if(param1 == null)
         {
            return;
         }
         this._skills = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Skill();
            _loc3_.setId(int(param1[_loc2_].id));
            _loc3_.setName(param1[_loc2_].name);
            _loc3_.setGrade(param1[_loc2_].grade);
            this.addSkill(_loc3_);
            _loc2_++;
         }
      }
   }
}

