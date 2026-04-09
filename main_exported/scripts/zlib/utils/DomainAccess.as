package zlib.utils
{
   import flash.display.LoaderInfo;
   import flash.system.ApplicationDomain;
   import zlib.log.LogFactory;
   import zlib.log.Logger;
   
   public class DomainAccess
   {
      
      private static var log:Logger = LogFactory.getLoggerClass(DomainAccess);
      
      public function DomainAccess()
      {
         super();
      }
      
      public static function getClass(param1:String, param2:LoaderInfo = null) : Class
      {
         var cName:String = param1;
         var loaderInfo:LoaderInfo = param2;
         try
         {
            if(loaderInfo == null)
            {
               return ApplicationDomain.currentDomain.getDefinition(cName) as Class;
            }
            return loaderInfo.applicationDomain.getDefinition(cName) as Class;
         }
         catch(e:ReferenceError)
         {
            log.error("定义 " + cName + " 不存在",e);
            return null;
         }
      }
   }
}

