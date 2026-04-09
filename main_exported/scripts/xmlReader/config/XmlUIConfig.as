package xmlReader.config
{
   import constants.GlobalConstants;
   import utils.ConfigLoadEvent;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   
   public class XmlUIConfig
   {
      
      private static var _instance:XmlUIConfig;
      
      private static const CONFIG_FILE:String = GlobalConstants.PVZ_RES_BASE_URL + "config/ui_config.xml?" + FuncKit.currentTimeMillis();
      
      private var _xml:XML;
      
      private var configLoader:ConfigURLLoader;
      
      public function XmlUIConfig(param1:PrivateClass)
      {
         super();
         this.init();
      }
      
      public static function getInstance() : XmlUIConfig
      {
         if(_instance == null)
         {
            _instance = new XmlUIConfig(new PrivateClass());
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.configLoader = PlantsVsZombies.configLoader;
         this.configLoader.load(CONFIG_FILE);
         this.configLoader.addEventListener(CONFIG_FILE,this.onComp);
      }
      
      private function onComp(param1:ConfigLoadEvent) : void
      {
         this.configLoader.removeEventListener(CONFIG_FILE,this.onComp);
         this._xml = param1.getXml();
      }
      
      public function getUiURlsByFunctionType(param1:String) : Array
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         for(_loc4_ in this._xml.ui.@mark)
         {
            if(this._xml.ui[_loc4_].@mark == param1)
            {
               _loc3_ = this._xml.ui[_loc4_];
               break;
            }
         }
         if(_loc3_)
         {
            for(_loc6_ in _loc3_.item)
            {
               _loc5_ = GlobalConstants.PVZ_RES_BASE_URL + _loc3_.item[_loc6_].@folder + _loc3_.item[_loc6_].@swfname + _loc3_.item[_loc6_].@version + ".swf";
               _loc2_.push(_loc5_);
            }
         }
         return _loc2_;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
