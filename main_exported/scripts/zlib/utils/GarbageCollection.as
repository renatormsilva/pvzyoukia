package zlib.utils
{
   import flash.net.LocalConnection;
   
   public class GarbageCollection
   {
      
      public function GarbageCollection()
      {
         super();
      }
      
      public static function GC() : void
      {
         var _loc1_:LocalConnection = null;
         var _loc2_:LocalConnection = null;
         try
         {
            _loc1_ = new LocalConnection();
            _loc2_ = new LocalConnection();
            _loc1_.connect("GC");
            _loc2_.connect("GC");
         }
         catch(e:Error)
         {
         }
      }
   }
}

