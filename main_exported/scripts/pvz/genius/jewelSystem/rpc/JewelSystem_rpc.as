package pvz.genius.jewelSystem.rpc
{
   import entity.Tool;
   
   public class JewelSystem_rpc
   {
      
      private var _allJewels:Array;
      
      public function JewelSystem_rpc(param1:Array)
      {
         super();
         this._allJewels = param1;
      }
      
      public function getAllJewels() : Array
      {
         return [];
      }
      
      public function getSpecilJewelsByType(param1:int = 0) : Array
      {
         var _loc3_:Tool = null;
         var _loc2_:Array = [];
         if(param1 == 0)
         {
            return this.orderToolById(this._allJewels);
         }
         for each(_loc3_ in this._allJewels)
         {
            if(_loc3_.getType() == param1 + "")
            {
               _loc2_.push(_loc3_);
            }
         }
         return this.orderToolById(_loc2_);
      }
      
      private function orderToolById(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as Tool).getOrderId() > _loc3_.getOrderId())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
   }
}

