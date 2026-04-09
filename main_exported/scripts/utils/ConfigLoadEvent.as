package utils
{
   import flash.events.Event;
   
   public class ConfigLoadEvent extends Event
   {
      
      internal var xml:XML;
      
      public function ConfigLoadEvent(param1:String, param2:XML, param3:Boolean = false, param4:Boolean = false)
      {
         this.xml = param2;
         super(param1,param3,param4);
      }
      
      public function getXml() : XML
      {
         return this.xml;
      }
   }
}

