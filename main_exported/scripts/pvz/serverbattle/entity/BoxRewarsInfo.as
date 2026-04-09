package pvz.serverbattle.entity
{
   import entity.Tool;
   
   public class BoxRewarsInfo
   {
      
      private var _rank:int;
      
      private var _rank_prizes:Array;
      
      public function BoxRewarsInfo()
      {
         super();
      }
      
      public function decodeData(param1:Object) : void
      {
         this._rank = param1.rank;
         this._rank_prizes = this.getTools(param1.tools as Array);
      }
      
      private function getTools(param1:Array) : Array
      {
         var _loc3_:Tool = null;
         var _loc2_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = new Tool(param1[_loc4_].tool_id);
            _loc3_.setNum(param1[_loc4_].amount);
            _loc2_.push(_loc3_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getRank() : int
      {
         return this._rank;
      }
      
      public function getPrizeInfo() : Array
      {
         return this._rank_prizes;
      }
   }
}

