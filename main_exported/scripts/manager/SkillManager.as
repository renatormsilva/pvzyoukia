package manager
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Buff;
   import entity.ExSkill;
   import entity.Organism;
   import entity.Skill;
   import xmlReader.config.XmlQualityConfig;
   
   public class SkillManager implements IConnection
   {
      
      private static var m_instance:SkillManager;
      
      private static const GET_SKILL_CONFIG:int = 1;
      
      private static const GET_EXSKILL_CONFIG:int = 2;
      
      private var mapBuff:Vector.<Buff>;
      
      private var mapSkills:Vector.<Skill>;
      
      private var mapExSkills:Vector.<ExSkill>;
      
      public function SkillManager()
      {
         super();
         this.mapBuff = new Vector.<Buff>();
         this.mapSkills = new Vector.<Skill>();
         this.mapExSkills = new Vector.<ExSkill>();
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SKILL_CONFIG,GET_SKILL_CONFIG);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_EXSKILL_CONFIG,GET_EXSKILL_CONFIG);
      }
      
      public static function get getInstance() : SkillManager
      {
         if(m_instance == null)
         {
            m_instance = new SkillManager();
         }
         return m_instance;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == GET_SKILL_CONFIG || param3 == GET_EXSKILL_CONFIG)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         switch(param1)
         {
            case GET_SKILL_CONFIG:
               _loc3_ = int(param2.length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  this.mapSkills.push(this.readSkill(param2[_loc4_]));
                  _loc4_++;
               }
               break;
            case GET_EXSKILL_CONFIG:
               _loc5_ = null;
               for each(_loc5_ in param2)
               {
                  this.mapExSkills.push(this.readExSkill(_loc5_));
               }
         }
      }
      
      public function getSkillById(param1:int) : Skill
      {
         var _loc3_:Skill = null;
         var _loc2_:int = int(this.mapSkills.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this.mapSkills[_loc4_] as Skill;
            if(_loc3_.getId() == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getExSkillById(param1:int) : ExSkill
      {
         var _loc3_:ExSkill = null;
         var _loc2_:int = int(this.mapExSkills.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this.mapExSkills[_loc4_] as ExSkill;
            if(_loc3_.getId() == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getNextSkillById(param1:int) : Skill
      {
         var _loc3_:Skill = null;
         var _loc2_:int = this.getSkillById(param1).getNextId();
         var _loc4_:int = int(this.mapSkills.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mapSkills[_loc5_] as Skill;
            if(_loc3_.getId() == _loc2_)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function getNextExSkillById(param1:int) : ExSkill
      {
         var _loc3_:ExSkill = null;
         var _loc2_:int = this.getExSkillById(param1).getNextId();
         var _loc4_:int = int(this.mapExSkills.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mapExSkills[_loc5_] as ExSkill;
            if(_loc3_.getId() == _loc2_)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function getAllSkills() : Vector.<Skill>
      {
         return this.mapSkills;
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
      }
      
      private function readSkill(param1:Object) : Skill
      {
         var _loc2_:Skill = new Skill();
         _loc2_.setEffect(param1.organism_attr);
         _loc2_.setGrade(param1.grade);
         _loc2_.setId(param1.id);
         _loc2_.setInfo(param1.describe);
         _loc2_.setLearnGrade(param1.learn_grade);
         _loc2_.setLearnProbability(param1.learn_probability);
         _loc2_.setLearnTool(param1.learn_tool);
         _loc2_.setName(param1.name);
         _loc2_.setProbability(param1.probability);
         _loc2_.setTouchOff(param1.touch_off);
         _loc2_.setNextId(param1.next_grade_id);
         _loc2_.setGroup(param1.group);
         return _loc2_;
      }
      
      private function readExSkill(param1:Object) : ExSkill
      {
         var _loc2_:ExSkill = new ExSkill();
         _loc2_.setEffect(param1.organism_attr);
         _loc2_.setGrade(param1.grade);
         _loc2_.setId(param1.id);
         _loc2_.setInfo(param1.describe);
         _loc2_.setLearnGrade(param1.learn_grade);
         _loc2_.setLearnProbability(param1.learn_probablity);
         _loc2_.setLearnTool(param1.learn_tool);
         _loc2_.setName(param1.name);
         _loc2_.setProbability(param1.probability);
         _loc2_.setTouchOff(param1.touch_off);
         _loc2_.setNextId(param1.next_grade_id);
         _loc2_.setOrgImgIdArr(param1.orgImgIdArr);
         _loc2_.setType(param1.type);
         return _loc2_;
      }
      
      public function isLearnSkillFull(param1:Organism) : Boolean
      {
         if(XmlQualityConfig.getInstance().getSkillNum(param1.getQuality_name()) == param1.getAllSkills().length)
         {
            return true;
         }
         return false;
      }
      
      public function isLearnExSkillFull(param1:Organism) : Boolean
      {
         if(param1.getAllExSkills().length >= 1)
         {
            return true;
         }
         return false;
      }
      
      public function isLearnSkillAttr(param1:Organism, param2:Skill) : Boolean
      {
         if(param1.getAttribute_name() == LangManager.getInstance().getLanguage("org017"))
         {
            if(OrganismManager.isOrnotActiveSkill(param2.getEffect()))
            {
               return false;
            }
            return true;
         }
         if(param1.getAttribute_name() == LangManager.getInstance().getLanguage("org007") || param1.getAttribute_name() == LangManager.getInstance().getLanguage("org008") || param1.getAttribute_name() == LangManager.getInstance().getLanguage("org015") || param1.getAttribute_name() == LangManager.getInstance().getLanguage("org016"))
         {
            return true;
         }
         if(param2.getEffect() == 0 || this.judgeAttributeName(param1.getAttribute_name()) == OrganismManager.getOrgAttr(param2.getEffect()))
         {
            return true;
         }
         return false;
      }
      
      private function judgeAttributeName(param1:String) : String
      {
         switch(param1)
         {
            case LangManager.getInstance().getLanguage("org009"):
               param1 = LangManager.getInstance().getLanguage("org001");
               break;
            case LangManager.getInstance().getLanguage("org010"):
               param1 = LangManager.getInstance().getLanguage("org004");
               break;
            case LangManager.getInstance().getLanguage("org011"):
               param1 = LangManager.getInstance().getLanguage("org003");
               break;
            case LangManager.getInstance().getLanguage("org012"):
               param1 = LangManager.getInstance().getLanguage("org006");
               break;
            case LangManager.getInstance().getLanguage("org013"):
               param1 = LangManager.getInstance().getLanguage("org002");
               break;
            case LangManager.getInstance().getLanguage("org014"):
               param1 = LangManager.getInstance().getLanguage("org005");
         }
         return param1;
      }
      
      public function getLearnSkill(param1:String) : Skill
      {
         var _loc2_:Skill = null;
         var _loc3_:Array = new Array();
         _loc3_ = this.getSkills(param1);
         if(_loc3_ == null || _loc3_.length < 1)
         {
            return _loc2_;
         }
         var _loc4_:int = 0;
         if(_loc4_ < _loc3_.length)
         {
            if((_loc3_[_loc4_] as Skill).getGrade() == 1)
            {
               _loc2_ = _loc3_[_loc4_];
            }
         }
         return _loc2_;
      }
      
      public function getExSkillByTool(param1:int) : ExSkill
      {
         var _loc2_:ExSkill = null;
         var _loc3_:Array = new Array();
         _loc3_ = this.getExSkills(param1);
         if(_loc3_ == null || _loc3_.length < 1)
         {
            return null;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc3_[_loc4_] as ExSkill).getGrade() == 1)
            {
               return _loc3_[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public function judgeToolForExSkill(param1:Organism, param2:int) : Boolean
      {
         var _loc3_:Array = this.getCanLearnExSkills(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(int(_loc3_[_loc4_].getType()) + 63 == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function getSkills(param1:String) : Array
      {
         var _loc3_:Skill = null;
         var _loc2_:Array = new Array();
         var _loc4_:int = int(this.mapSkills.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mapSkills[_loc5_] as Skill;
            if(_loc3_.getGroup() == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function getExSkills(param1:int) : Array
      {
         var _loc3_:ExSkill = null;
         var _loc2_:Array = [];
         var _loc4_:int = int(this.mapExSkills.length);
         var _loc5_:int = 0;
         while(_loc5_ < this.mapExSkills.length)
         {
            _loc3_ = this.mapExSkills[_loc5_] as ExSkill;
            if(_loc3_.getType() + 63 == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function isCanLearnExSkill(param1:Organism) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = int(this.mapExSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = 0;
            _loc5_ = int(this.mapExSkills[_loc2_].getOrgImgIdArr().length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(param1.getPicId() == this.mapExSkills[_loc2_].getOrgImgIdArr()[_loc4_])
               {
                  return true;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getCanLearnExSkills(param1:Organism) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:int = int(this.mapExSkills.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = 0;
            _loc8_ = int(this.mapExSkills[_loc3_].getOrgImgIdArr().length);
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               if(param1.getPicId() == this.mapExSkills[_loc3_].getOrgImgIdArr()[_loc7_])
               {
                  _loc2_.push(this.mapExSkills[_loc3_]);
                  break;
               }
               _loc7_++;
            }
            _loc3_++;
         }
         if(_loc2_.length == 0)
         {
            return _loc2_;
         }
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            if((_loc2_[_loc6_] as ExSkill).getGrade() == 1)
            {
               _loc5_.push(_loc2_[_loc6_]);
            }
            _loc6_++;
         }
         return _loc5_;
      }
   }
}

