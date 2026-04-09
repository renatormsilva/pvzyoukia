package pvz.battle.entity
{
   public class BuffVo
   {
      
      public var id:int;
      
      public var camp:int;
      
      public var targetId:int;
      
      public var buffId:int;
      
      public var state:int;
      
      public function BuffVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.camp = param1.camp;
         this.targetId = param1.target_id;
         this.buffId = param1.skill_type;
         this.state = param1.isfirst;
      }
   }
}

