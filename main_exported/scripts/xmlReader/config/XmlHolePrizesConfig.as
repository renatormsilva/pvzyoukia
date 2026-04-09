package xmlReader.config
{
   import constants.GlobalConstants;
   import flash.events.EventDispatcher;
   import utils.ConfigLoadEvent;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   
   public class XmlHolePrizesConfig extends EventDispatcher
   {
      
      private static var _instance:XmlHolePrizesConfig;
      
      private static const CONFIG_FILE:String = (GlobalConstants.PVZ_WEB_URL + "php_xml/awards.xml?" + FuncKit.currentTimeMillis()).replace("index.php/","");
      
      private static const MONEY:String = "money";
      
      private static var PLANTS_NUM:int = 1000;
      
      private static var _singleton:Boolean = true;
      
      private var _xml:XML;
      
      private var dateObject:Object = null;
      
      private var holeAwardsDate:Object = {};
      
      private var loader:ConfigURLLoader;
      
      public function XmlHolePrizesConfig()
      {
         super();
         if(_singleton)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
         this.loader = PlantsVsZombies.configLoader;
         this.loader.load(CONFIG_FILE);
         this.loader.addEventListener(CONFIG_FILE,this.onComp);
      }
      
      public static function getInstance(param1:Boolean = false) : XmlHolePrizesConfig
      {
         if(_instance == null || param1)
         {
            _singleton = false;
            _instance = new XmlHolePrizesConfig();
            _singleton = true;
         }
         return _instance;
      }
      
      public function error() : String
      {
         return this._xml.response.error;
      }
      
      public function getHolePrizes(param1:int) : Array
      {
         if(this.holeAwardsDate[param1] != null)
         {
            return this.holeAwardsDate[param1];
         }
         this.holeAwardsDate[param1] = this.readHolePrizes(param1);
         return this.holeAwardsDate[param1];
      }
      
      public function isSuccess() : Boolean
      {
         if(this._xml.response.status == "success")
         {
            return true;
         }
         return false;
      }
      
      private function onComp(param1:ConfigLoadEvent) : void
      {
         this.loader.removeEventListener(CONFIG_FILE,this.onComp);
         this._xml = param1.getXml();
         this.saveAllPrizes();
      }
      
      private function readHolePrizes(param1:int) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Object = this.dateObject[param1].info;
         for(_loc4_ in _loc3_.a.ad)
         {
            if(_loc3_.a.ad.type != MONEY)
            {
               _loc5_ = new Object();
               _loc5_.type = _loc3_.a.ad[_loc4_].t;
               _loc5_.id = _loc3_.a.ad[_loc4_].v;
               _loc2_.push(_loc5_);
            }
         }
         return _loc2_;
      }
      
      private function saveAllPrizes() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.dateObject = new Object();
         for(_loc1_ in this._xml.hunting.h)
         {
            _loc2_ = new Object();
            _loc2_.id = this._xml.hunting.h[_loc1_].@id;
            _loc2_.info = this._xml.hunting.h[_loc1_];
            this.dateObject[_loc2_.id] = _loc2_;
         }
         this._xml = null;
      }
   }
}

