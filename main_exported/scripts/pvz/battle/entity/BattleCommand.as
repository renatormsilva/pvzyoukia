package pvz.battle.entity
{
   public class BattleCommand
   {
      
      internal var _attackNum:Number;
      
      internal var _attack_id:int;
      
      internal var _campType:int;
      
      internal var _command_id:int;
      
      internal var _prizes:Array;
      
      internal var _skills:Array;
      
      internal var _skillsed:Array;
      
      internal var _attacked_arr:Array = [];
      
      private var _Vgenius:Array;
      
      private var _Egenius:Array;
      
      private var _Exclusive:Array;
      
      private var _buffers:Array;
      
      private var _cout:int = 0;
      
      public function BattleCommand()
      {
         super();
      }
      
      public function getVgenius() : Array
      {
         return this._Vgenius;
      }
      
      public function setVgenius(param1:Array) : void
      {
         this._Vgenius = param1;
      }
      
      public function getEgenius() : Array
      {
         return this._Egenius;
      }
      
      public function setEgenius(param1:Array) : void
      {
         this._Egenius = param1;
      }
      
      public function getExclusive() : Array
      {
         return this._Exclusive;
      }
      
      public function setExclusive(param1:Array) : void
      {
         this._Exclusive = param1;
      }
      
      public function get buffers() : Array
      {
         return this._buffers;
      }
      
      public function set buffers(param1:Array) : void
      {
         this._buffers = param1;
      }
      
      public function getAttackedArr() : Array
      {
         return this._attacked_arr;
      }
      
      public function setAttackedArr(param1:Array) : void
      {
         this._attacked_arr = param1;
      }
      
      public function getSkillsed() : Array
      {
         return this._skillsed;
      }
      
      public function setSkillsed(param1:Array) : void
      {
         this._skillsed = param1;
      }
      
      public function getAttack_id() : int
      {
         return this._attack_id;
      }
      
      public function getCampType() : int
      {
         return this._campType;
      }
      
      public function getCommand_id() : int
      {
         return this._command_id;
      }
      
      public function getPrizes() : Array
      {
         return this._prizes;
      }
      
      public function getSkills() : Array
      {
         return this._skills;
      }
      
      public function setAttack_id(param1:int) : void
      {
         this._attack_id = param1;
      }
      
      public function setCampType(param1:int) : void
      {
         this._campType = param1;
      }
      
      public function setCommand_id(param1:int) : void
      {
         this._command_id = param1;
      }
      
      public function setPrizes(param1:Array) : void
      {
         this._prizes = param1;
      }
      
      public function setSkills(param1:Array) : void
      {
         this._skills = param1;
      }
      
      public function setCout(param1:int) : void
      {
         this._cout = param1;
      }
      
      public function getCout() : int
      {
         return this._cout;
      }
   }
}

