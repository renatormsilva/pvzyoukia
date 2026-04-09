package pvz.serverbattle.rpc
{
   import pvz.serverbattle.entity.MedalGoods;
   
   public class MedelShop_rpc
   {
      
      public function MedelShop_rpc()
      {
         super();
      }
      
      public function getAllMedalGoods(param1:Object) : Array
      {
         var _loc2_:MedalGoods = null;
         var _loc3_:Array = new Array();
         var _loc4_:* = int(param1.length - 1);
         while(_loc4_ >= 0)
         {
            _loc2_ = new MedalGoods();
            _loc2_.decode(param1[_loc4_]);
            _loc3_.push(_loc2_);
            _loc4_--;
         }
         return _loc3_;
      }
      
      public function getMedalGoods(param1:Object) : MedalGoods
      {
         var _loc2_:MedalGoods = new MedalGoods();
         return null;
      }
      
      public function getMedalGoodsById(param1:int, param2:Object) : MedalGoods
      {
         var _loc3_:MedalGoods = new MedalGoods();
         return null;
      }
   }
}

