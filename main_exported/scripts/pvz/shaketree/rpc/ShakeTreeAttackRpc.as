package pvz.shaketree.rpc
{
   import entity.Tool;
   import pvz.shaketree.vo.PassData;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import pvz.shaketree.vo.ZombiesVo;
   
   public class ShakeTreeAttackRpc
   {
      
      private var _data:Object;
      
      public function ShakeTreeAttackRpc()
      {
         super();
      }
      
      public function parseAttackData(param1:Object, param2:int) : void
      {
         this._data = param1;
         var _loc3_:PassData = ShakeTreeSystermData.I.currentPassData();
         _loc3_.setIsPassLevel(param1.is_up);
         _loc3_.setBaojiOdds(param1.probability);
         _loc3_.setRate(param1.rate);
         var _loc4_:ZombiesVo = _loc3_.getZombiesVoByid(param2);
         _loc4_.setIsDeath(param1.is_death);
      }
      
      public function getAttackPrizes() : Array
      {
         var _loc3_:Tool = null;
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = int(this._data.beat_reward.length);
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Tool(this._data.beat_reward[_loc4_].id);
            _loc3_.setNum(this._data.beat_reward[_loc4_].amount);
            _loc1_.push(_loc3_);
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getUpPrizes() : Array
      {
         var _loc3_:Tool = null;
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = int(this._data.up_reward.length);
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Tool(this._data.up_reward[_loc4_].id);
            _loc3_.setNum(this._data.up_reward[_loc4_].amount);
            _loc1_.push(_loc3_);
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function baojiBeishi() : int
      {
         return this._data.multiple;
      }
   }
}

