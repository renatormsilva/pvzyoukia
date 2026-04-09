package pvz.battle.entity
{
   import utils.BigInt;
   
   public class BattleNaturalVo
   {
      
      public var actionId:String;
      
      public var camp:int;
      
      public var attackNum:BigInt = null;
      
      public var old_hp:int;
      
      public var movieType:uint = 1;
      
      public var skill_type:int;
      
      public var dead:Boolean = false;
      
      public function BattleNaturalVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.actionId = param1.actionId;
         this.camp = param1.camp;
         this.old_hp = param1.old_hp;
         this.attackNum = new BigInt(param1.attackNum);
         this.movieType = param1.movieType;
         this.dead = param1.is_die == 1;
         this.skill_type = param1.skill_type;
         param1 = null;
      }
      
      public function destroy() : void
      {
      }
   }
}

