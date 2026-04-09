package pvz.registration.data
{
   public class MissionVo
   {
      
      public var id:int;
      
      public var dis:String;
      
      public var countmax:int;
      
      public var count:int;
      
      public var active:int;
      
      public var gotoId:int;
      
      public function MissionVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.id = param1.id;
         this.dis = param1.dis;
         this.countmax = param1.countmax;
         this.count = param1.count;
         this.active = param1.active;
         this.gotoId = param1.gotoId;
      }
   }
}

