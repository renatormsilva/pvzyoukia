package pvz.copy.models
{
   public class CopyInfoProxy
   {
      
      private var _allCopyInfos:Vector.<CopyInfoVo>;
      
      public function CopyInfoProxy()
      {
         super();
      }
      
      public function setdata(param1:Array) : void
      {
         var _loc2_:CopyInfoVo = null;
         var _loc3_:Object = null;
         this._allCopyInfos = new Vector.<CopyInfoVo>();
         for each(_loc3_ in param1)
         {
            _loc2_ = new CopyInfoVo();
            _loc2_.decode(_loc3_);
            this._allCopyInfos.push(_loc2_);
         }
      }
      
      public function getAllCopyInfoVos() : Vector.<CopyInfoVo>
      {
         return this._allCopyInfos;
      }
   }
}

