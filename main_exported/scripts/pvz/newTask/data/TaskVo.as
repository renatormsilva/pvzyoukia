package pvz.newTask.data
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.Honor;
   import entity.Tool;
   
   public class TaskVo
   {
      
      public var id:int;
      
      public var icon:int;
      
      public var title:String;
      
      public var dis:String;
      
      public var reward:Array;
      
      public var state:int;
      
      public var maxCount:int;
      
      public var curCount:int;
      
      public var gotoId:int;
      
      public function TaskVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.id = param1.id;
         this.icon = param1.icon;
         this.title = param1.title;
         this.dis = param1.dis;
         this.reward = this.decodeReward(param1.reward);
         this.state = param1.state;
         this.maxCount = param1.maxCount;
         this.curCount = param1.curCount;
         this.gotoId = param1.gotoId;
      }
      
      private function decodeReward(param1:Object) : Array
      {
         var _loc3_:GameMoney = null;
         var _loc4_:Exp = null;
         var _loc5_:Honor = null;
         var _loc6_:Object = null;
         var _loc7_:Tool = null;
         var _loc2_:Array = [];
         if(Boolean(param1.money) && param1.money > 0)
         {
            _loc3_ = new GameMoney();
            _loc3_.decode(Number(param1.money));
            _loc2_.push(_loc3_);
         }
         if(Boolean(param1.exp) && param1.exp > 0)
         {
            _loc4_ = new Exp();
            _loc4_.decode(param1);
            _loc2_.push(_loc4_);
         }
         if(Boolean(param1.honor) && param1.honor > 0)
         {
            _loc5_ = new Honor();
            _loc5_.decode(param1.honor);
            _loc2_.push(_loc5_);
         }
         if(param1.tools)
         {
            for each(_loc6_ in param1.tools)
            {
               _loc7_ = new Tool(_loc6_.id);
               _loc7_.setNum(_loc6_.num);
               _loc2_.push(_loc7_);
            }
         }
         return _loc2_;
      }
   }
}

