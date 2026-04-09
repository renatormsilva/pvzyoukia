package pvz.copy.models.limit
{
   public class ActivtyCopyData
   {
      
      public static const LIMIT_COPY:int = 1;
      
      public static const CD_TIME_COPY:int = 2;
      
      private static var _limitCopyTotalChallageTimes:int = 0;
      
      private static var _copyid:int = 1;
      
      public function ActivtyCopyData()
      {
         super();
      }
      
      public static function setCopyId(param1:int) : void
      {
         _copyid = param1;
      }
      
      public static function getCopyId() : int
      {
         return _copyid;
      }
      
      public static function setLimitCopyTotalChallageTimes(param1:int) : void
      {
         _limitCopyTotalChallageTimes = param1;
      }
      
      public static function getLimitCopyTotalChallageTimes() : int
      {
         return _limitCopyTotalChallageTimes;
      }
   }
}

