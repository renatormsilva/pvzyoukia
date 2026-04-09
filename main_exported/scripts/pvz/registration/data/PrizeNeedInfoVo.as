package pvz.registration.data
{
   public class PrizeNeedInfoVo
   {
      
      public var id:int;
      
      public var count:int;
      
      public var rewards:Array;
      
      public var state:int;
      
      public function PrizeNeedInfoVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.id = param1.id;
         this.count = param1.count;
         this.rewards = this.getPrize(param1.rewards);
         this.state = param1.state;
      }
      
      private function getPrize(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:RewardData = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new RewardData();
            _loc4_.setData(_loc3_);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
   }
}

