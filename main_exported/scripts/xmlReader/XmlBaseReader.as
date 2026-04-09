package xmlReader
{
   public class XmlBaseReader
   {
      
      public static const GARDEN_ERROR1:String = "Scene_Exception_Garden_Add";
      
      public static const GARDNE_ERROR2:String = "Scene_Exception_Garden_RemoveState";
      
      public static const GARDEN_ERROR3:String = "Scene_Exception_Garden_NotOrganism";
      
      public static const GARDEN_ERROR4:String = "Scene_Exception_Garden_PickUpBoxWarehouse";
      
      public static const CONNECT_ERROR1:String = "LoginError";
      
      public var _xml:XML = null;
      
      public function XmlBaseReader()
      {
         super();
      }
      
      public function getXml() : XML
      {
         return this._xml;
      }
      
      public function init(param1:String, param2:String) : void
      {
         this._xml = new XML(param1);
      }
      
      public function reader(param1:String) : void
      {
         this._xml = new XML(param1);
      }
      
      public function error() : String
      {
         return this._xml.response.error.@message;
      }
      
      public function errorType() : String
      {
         return this._xml.response.error.@class_name;
      }
      
      public function isSuccess() : Boolean
      {
         if(this._xml.response.status == "success")
         {
            return true;
         }
         return false;
      }
   }
}

