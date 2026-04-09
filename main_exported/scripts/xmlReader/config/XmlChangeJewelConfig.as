package xmlReader.config
{
   import constants.GlobalConstants;
   import utils.ConfigLoadEvent;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   
   public class XmlChangeJewelConfig
   {
      
      private static var _instance:XmlChangeJewelConfig;
      
      private static const CONFIG_FILE:String = (GlobalConstants.PVZ_WEB_URL + "php_xml/gemexchange.xml?" + FuncKit.currentTimeMillis()).replace("index.php/","");
      
      private var _xml:XML;
      
      private var loader:ConfigURLLoader;
      
      public function XmlChangeJewelConfig()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : XmlChangeJewelConfig
      {
         if(_instance == null)
         {
            _instance = new XmlChangeJewelConfig();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.loader = PlantsVsZombies.configLoader;
         this.loader.load(CONFIG_FILE);
         this.loader.addEventListener(CONFIG_FILE,this.onComp);
      }
      
      private function onComp(param1:ConfigLoadEvent) : void
      {
         this.loader.removeEventListener(CONFIG_FILE,this.onComp);
         this._xml = param1.getXml().gemexchanges[0];
      }
      
      public function setConfigData(param1:XML) : void
      {
         this._xml = param1;
      }
      
      public function isUseToExchanged(param1:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:int = this._xml.item.length();
         while(_loc3_ < _loc2_)
         {
            if(this._xml.item[_loc3_].@cost_tool == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function getExchangeRatio(param1:int, param2:int) : int
      {
         var _loc3_:int = param1;
         var _loc4_:int = 1;
         while(_loc3_ < param2)
         {
            _loc4_ *= this.getNextLevelJewelNum(_loc3_);
            _loc3_ = this.getNextLevelJewelId(_loc3_);
         }
         return _loc4_;
      }
      
      public function getCostMoneyByTargetId(param1:int, param2:int) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = param1;
         while(_loc6_ < param2)
         {
            _loc5_ = this.getNextLeveJewelCostMoney(_loc6_) * this.getExchangeRatio(_loc6_,param2) / this.getNextLevelJewelNum(_loc6_);
            _loc4_ += _loc5_;
            _loc6_ = this.getNextLevelJewelId(_loc6_);
         }
         return _loc4_;
      }
      
      public function getNextLevelJewelId(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = this._xml.item.length();
         while(_loc3_ < _loc2_)
         {
            if(this._xml.item[_loc3_].@cost_tool == param1)
            {
               return this._xml.item[_loc3_].@target_tool_id;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getPreLevelJewelId(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = this._xml.item.length();
         while(_loc3_ < _loc2_)
         {
            if(this._xml.item[_loc3_].@target_tool_id == param1)
            {
               return this._xml.item[_loc3_].@cost_tool;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getNextLevelJewelNum(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = this._xml.item.length();
         while(_loc3_ < _loc2_)
         {
            if(this._xml.item[_loc3_].@cost_tool == param1)
            {
               return this._xml.item[_loc3_].@cost_num;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getNextLeveJewelCostMoney(param1:int) : Number
      {
         var _loc3_:int = 0;
         var _loc2_:int = this._xml.item.length();
         while(_loc3_ < _loc2_)
         {
            if(this._xml.item[_loc3_].@cost_tool == param1)
            {
               return this._xml.item[_loc3_].@cost_money;
            }
            _loc3_++;
         }
         return 0;
      }
   }
}

