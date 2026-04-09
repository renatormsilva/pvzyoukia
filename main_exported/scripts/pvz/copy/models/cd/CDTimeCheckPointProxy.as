package pvz.copy.models.cd
{
   import com.res.IDestroy;
   
   public class CDTimeCheckPointProxy implements IDestroy
   {
      
      private var _allCheckPoint:Vector.<CDTimeCheckPoint>;
      
      private var _data:Object;
      
      public function CDTimeCheckPointProxy()
      {
         super();
      }
      
      public function setData(param1:Object) : void
      {
         this._allCheckPoint = null;
         this._data = param1;
      }
      
      public function getAllCheckPoint() : Vector.<CDTimeCheckPoint>
      {
         var _loc1_:CDTimeCheckPoint = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         if(this._allCheckPoint == null)
         {
            this._allCheckPoint = new Vector.<CDTimeCheckPoint>();
            _loc2_ = this._data.le;
            for each(_loc3_ in _loc2_)
            {
               _loc1_ = new CDTimeCheckPoint();
               _loc1_.decode(_loc3_);
               this._allCheckPoint.push(_loc1_);
            }
         }
         return this._allCheckPoint;
      }
      
      public function getHelpTips() : String
      {
         return this._data.helptips;
      }
      
      public function getStartTime() : Number
      {
         return this._data.st;
      }
      
      public function getEndTime() : Number
      {
         return this._data.et;
      }
      
      public function getCheckPointById(param1:int) : CDTimeCheckPoint
      {
         var _loc2_:CDTimeCheckPoint = null;
         if(this._allCheckPoint.length <= 0)
         {
            return null;
         }
         for each(_loc2_ in this._allCheckPoint)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function destroy() : void
      {
         this._data = null;
         this._allCheckPoint = null;
      }
   }
}

