package pvz.copy.models.limit
{
   import com.res.IDestroy;
   
   public class LimitCheckPointProxy implements IDestroy
   {
      
      private var _allCheckPoints:Vector.<LimitCheckPointVo>;
      
      private var _data:Object;
      
      public function LimitCheckPointProxy()
      {
         super();
      }
      
      public function setData(param1:Object) : void
      {
         this._data = param1;
         this._allCheckPoints = null;
      }
      
      public function getAllCheckPoints() : Vector.<LimitCheckPointVo>
      {
         var _loc1_:LimitCheckPointVo = null;
         var _loc2_:Object = null;
         if(this._allCheckPoints == null)
         {
            this._allCheckPoints = new Vector.<LimitCheckPointVo>();
            for each(_loc2_ in this._data)
            {
               _loc1_ = new LimitCheckPointVo();
               _loc1_.decode(_loc2_);
               this._allCheckPoints.push(_loc1_);
            }
         }
         return this._allCheckPoints;
      }
      
      public function getIndeedCheckPoint(param1:int) : LimitCheckPointVo
      {
         return null;
      }
      
      public function destroy() : void
      {
         this._allCheckPoints = null;
         this._data = null;
      }
   }
}

