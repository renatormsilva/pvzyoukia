package entity
{
   import core.interfaces.IVo;
   
   public class GeniusSkill implements IVo
   {
      
      private var _attack:String = "";
      
      private var _attacktype:int = 1;
      
      private var _genius_name:String = "";
      
      private var _genius_Level:int;
      
      private var _genius_launch_id:int;
      
      private var _genius_accept_id:int;
      
      private var _skill_id:String;
      
      public function GeniusSkill()
      {
         super();
      }
      
      public function get attackNum() : String
      {
         return this._attack;
      }
      
      public function get attackedOrNot() : Boolean
      {
         if(this._attacktype == 1)
         {
            return true;
         }
         return false;
      }
      
      public function get gname() : String
      {
         return this._genius_name;
      }
      
      public function get gLaunchId() : Number
      {
         return this._genius_launch_id;
      }
      
      public function get gAcceptId() : Number
      {
         return this._genius_accept_id;
      }
      
      public function get geniusSkillId() : String
      {
         return this._skill_id;
      }
      
      public function decode(param1:Object) : void
      {
         this._genius_launch_id = param1.user;
         this._genius_accept_id = param1.recipient;
         this._attack = param1.skill_attack;
         this._genius_Level = param1.skill_grade;
         this._skill_id = param1.id;
         this._genius_name = param1.name;
         this._attacktype = param1.active;
      }
   }
}

