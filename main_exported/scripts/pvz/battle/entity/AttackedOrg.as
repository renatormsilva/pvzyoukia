package pvz.battle.entity
{
   import pvz.battle.node.BattleOrg;
   
   public class AttackedOrg
   {
      
      private var org:BattleOrg = null;
      
      private var attackNum:Number = 0;
      
      private var id:int = 0;
      
      private var fear:int = 0;
      
      private var dodge:Boolean;
      
      private var _VgeniusSkills:Array;
      
      private var _EgeniusSkills:Array;
      
      private var _ExclusiveSkills:Array;
      
      private var _buffs:Array;
      
      private var current_cout:int = 0;
      
      private var attackNormal:String = "";
      
      private var attacked_hp:Number = 0;
      
      public function AttackedOrg()
      {
         super();
      }
      
      public function getVgeniusSkill() : Array
      {
         return this._VgeniusSkills;
      }
      
      public function setVgeniusSkill(param1:Array) : void
      {
         this._VgeniusSkills = param1;
      }
      
      public function getEgeniusSkill() : Array
      {
         return this._EgeniusSkills;
      }
      
      public function setEgeniusSkill(param1:Array) : void
      {
         this._EgeniusSkills = param1;
      }
      
      public function getExclusiveSkills() : Array
      {
         return this._ExclusiveSkills;
      }
      
      public function setExclusiveSkills(param1:Array) : void
      {
         this._ExclusiveSkills = param1;
      }
      
      public function getBuffs() : Array
      {
         return this._buffs;
      }
      
      public function setBuffs(param1:Array) : void
      {
         this._buffs = param1;
      }
      
      public function getBattleOrg() : BattleOrg
      {
         return this.org;
      }
      
      public function setBattleOrg(param1:BattleOrg) : void
      {
         this.org = param1;
      }
      
      public function setAttackNum(param1:Number = 0) : void
      {
         this.attackNum = param1;
      }
      
      public function setCurrentCout(param1:int = 0) : void
      {
         this.current_cout = param1;
      }
      
      public function getCurrentCout() : Number
      {
         return this.current_cout;
      }
      
      public function setAttackNormal(param1:String) : void
      {
         this.attackNormal = param1;
      }
      
      public function getAttackNormal() : String
      {
         return this.attackNormal;
      }
      
      public function setAttackedHp(param1:Number = 0) : void
      {
         this.attacked_hp = param1;
      }
      
      public function getAttackedHp() : Number
      {
         return this.attacked_hp;
      }
      
      public function getAttackNum() : Number
      {
         return this.attackNum;
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function setFear(param1:int) : void
      {
         this.fear = param1;
      }
      
      public function getFear() : int
      {
         return this.fear;
      }
      
      public function setDodge(param1:Boolean) : void
      {
         this.dodge = param1;
      }
      
      public function getDodge() : Boolean
      {
         return this.dodge;
      }
   }
}

