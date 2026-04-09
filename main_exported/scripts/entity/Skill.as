package entity
{
   public class Skill
   {
      
      public static const INITIATIVE:int = 2;
      
      public static const PASSIVE:int = 1;
      
      internal var _effect:int = 0;
      
      internal var _grade:int = 0;
      
      internal var _group:String = "";
      
      internal var _id:int = 0;
      
      internal var _info:String = "";
      
      internal var _learn_grade:int = 0;
      
      internal var _learn_probability:int = 0;
      
      internal var _learn_tool:int = 0;
      
      internal var _name:String = "";
      
      internal var _next_id:int = 0;
      
      internal var _probability:int = 0;
      
      internal var _attack_all:Boolean = false;
      
      internal var _touch_off:int = 0;
      
      public function Skill()
      {
         super();
      }
      
      public function setAllAttack(param1:int) : void
      {
         if(param1 > 1)
         {
            this._attack_all = true;
         }
         else
         {
            this._attack_all = false;
         }
      }
      
      public function getAllAttack() : Boolean
      {
         return this._attack_all;
      }
      
      public function getEffect() : int
      {
         return this._effect;
      }
      
      public function getGrade() : int
      {
         return this._grade;
      }
      
      public function getGroup() : String
      {
         return this._group;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getInfo() : String
      {
         return this._info;
      }
      
      public function getLearnGrade() : int
      {
         return this._learn_grade;
      }
      
      public function getLearnProbability() : int
      {
         return this._learn_probability;
      }
      
      public function getLearnTool() : int
      {
         return this._learn_tool;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getNextId() : int
      {
         return this._next_id;
      }
      
      public function getProbability() : int
      {
         return this._probability;
      }
      
      public function getTouchOff() : int
      {
         return this._touch_off;
      }
      
      public function setEffect(param1:int) : void
      {
         this._effect = param1;
      }
      
      public function setGrade(param1:int) : void
      {
         this._grade = param1;
      }
      
      public function setGroup(param1:String) : void
      {
         this._group = param1;
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function setInfo(param1:String) : void
      {
         this._info = param1;
      }
      
      public function setLearnGrade(param1:int) : void
      {
         this._learn_grade = param1;
      }
      
      public function setLearnProbability(param1:int) : void
      {
         this._learn_probability = param1;
      }
      
      public function setLearnTool(param1:int) : void
      {
         this._learn_tool = param1;
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      public function setNextId(param1:int) : void
      {
         this._next_id = param1;
      }
      
      public function setProbability(param1:int) : void
      {
         this._probability = param1;
      }
      
      public function setTouchOff(param1:int) : void
      {
         this._touch_off = param1;
      }
   }
}

