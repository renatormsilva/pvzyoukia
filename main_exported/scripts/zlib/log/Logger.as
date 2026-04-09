package zlib.log
{
   public class Logger
   {
      
      public static var isDebug:Boolean;
      
      public static var allowTrace:Boolean;
      
      public function Logger()
      {
         super();
      }
      
      public function isTraceEnabled() : Boolean
      {
         return false;
      }
      
      public function traceLog(param1:Object, param2:Error = null) : void
      {
      }
      
      public function get isDebugEnabled() : Boolean
      {
         return false;
      }
      
      public function debug(param1:Object, param2:Error = null) : void
      {
      }
      
      public function get isInfoEnabled() : Boolean
      {
         return false;
      }
      
      public function info(param1:Object, param2:Error = null) : void
      {
      }
      
      public function get isWarnEnabled() : Boolean
      {
         return false;
      }
      
      public function warn(param1:Object, param2:Error = null) : void
      {
      }
      
      public function get isErrorEnabled() : Boolean
      {
         return false;
      }
      
      public function error(param1:Object, param2:Error = null) : void
      {
      }
      
      public function get isFatalEnabled() : Boolean
      {
         return false;
      }
      
      public function fatal(param1:Object, param2:Error = null) : void
      {
      }
   }
}

