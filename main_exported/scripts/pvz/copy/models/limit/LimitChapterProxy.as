package pvz.copy.models.limit
{
   import com.res.IDestroy;
   
   public class LimitChapterProxy implements IDestroy
   {
      
      private var _allChapter:Vector.<LimitChapterVo>;
      
      private var _chpaterData:Object;
      
      private var _totaltimes:int;
      
      private var _maxAddtimes:int;
      
      private var _helpText:String;
      
      private var _buyChallagePrice:Number;
      
      public function LimitChapterProxy()
      {
         super();
      }
      
      public function getMaxAddtimes() : int
      {
         return this._maxAddtimes;
      }
      
      public function setMaxAddtimes(param1:int) : void
      {
         this._maxAddtimes = param1;
      }
      
      public function setChapterData(param1:Object) : void
      {
         this._chpaterData = param1;
         this.setTotalChallageTimes(this._chpaterData.count);
         this.setBuyChallagePrice(this._chpaterData.buyChallagePrice);
         this.setMaxAddtimes(param1.add_max_count);
      }
      
      private function setBuyChallagePrice(param1:Number) : void
      {
         this._buyChallagePrice = param1;
      }
      
      public function getBuyChallagePrice() : Number
      {
         return this._buyChallagePrice;
      }
      
      public function getHelpText() : String
      {
         return this._chpaterData.helptips;
      }
      
      public function getStartTime() : Number
      {
         return this._chpaterData.time.st;
      }
      
      public function getEndTime() : Number
      {
         return this._chpaterData.time.et;
      }
      
      public function getChapterById(param1:int) : LimitChapterVo
      {
         return null;
      }
      
      public function getAllChpaters() : Vector.<LimitChapterVo>
      {
         var _loc1_:LimitChapterVo = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         if(this._allChapter == null)
         {
            this._allChapter = new Vector.<LimitChapterVo>();
            _loc2_ = this._chpaterData.chapters;
            for each(_loc3_ in _loc2_)
            {
               _loc1_ = new LimitChapterVo();
               _loc1_.decode(_loc3_);
               this._allChapter.push(_loc1_);
            }
         }
         return this._allChapter;
      }
      
      public function setTotalChallageTimes(param1:int) : void
      {
         ActivtyCopyData.setLimitCopyTotalChallageTimes(param1);
         this._totaltimes = param1;
      }
      
      public function getTotalChallageTimes() : int
      {
         return this._totaltimes;
      }
      
      public function destroy() : void
      {
         this._allChapter = null;
         this._chpaterData = null;
      }
   }
}

