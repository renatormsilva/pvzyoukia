package zlib.log
{
   import flash.utils.getQualifiedClassName;
   
   public class LogFactory
   {
      
      protected static var factory:LogFactory;
      
      public static const NULL:Logger = new Logger();
      
      public function LogFactory()
      {
         super();
      }
      
      public static function get Factory() : LogFactory
      {
         return factory;
      }
      
      public static function getLoggerClass(param1:Class) : Logger
      {
         return getLoggerString(getQualifiedClassName(param1));
      }
      
      public static function getLoggerString(param1:String) : Logger
      {
         if(factory == null)
         {
            return NULL;
         }
         return factory.getInstance(param1);
      }
      
      public function getInstance(param1:String) : Logger
      {
         return NULL;
      }
   }
}

