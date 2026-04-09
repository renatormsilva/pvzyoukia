package xmlReader.config
{
   import constants.GlobalConstants;
   import entity.BaseTool;
   import entity.Tool;
   import utils.ConfigLoadEvent;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   
   public class XmlToolsConfig
   {
      
      private static var _instance:XmlToolsConfig;
      
      private static const CONFIG_FILE:String = (GlobalConstants.PVZ_WEB_URL + "php_xml/tool.xml?" + FuncKit.currentTimeMillis()).replace("index.php/","");
      
      private static var _baseArr:Array = null;
      
      private static var _singleton:Boolean = true;
      
      private var _xml:XML;
      
      private var loader:ConfigURLLoader;
      
      private var dateObject:Object = null;
      
      private var public_tool:Tool = null;
      
      private var toolBaseDate:Object = {};
      
      public function XmlToolsConfig()
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
      
      public static function getInstance(param1:Boolean = false) : XmlToolsConfig
      {
         if(_instance == null || param1)
         {
            _singleton = false;
            _instance = new XmlToolsConfig();
            _singleton = true;
         }
         return _instance;
      }
      
      public function error() : String
      {
         return this._xml.response.error;
      }
      
      public function getAllTools() : Array
      {
         if(_baseArr == null)
         {
            this.setAllToolIds();
         }
         return _baseArr;
      }
      
      public function getBaseToolAttribute(param1:int, param2:String) : BaseTool
      {
         var _loc3_:BaseTool = null;
         if(this.toolBaseDate[param1] != null && this.toolBaseDate[param1][param2] != null && this.toolBaseDate[param1][param2] != "" && this.toolBaseDate[param1][param2] != 0)
         {
            return this.toolBaseDate[param1];
         }
         if(this.toolBaseDate[param1] == null)
         {
            _loc3_ = new BaseTool();
            this.toolBaseDate[param1] = _loc3_;
         }
         if(param2 == "expl")
         {
            this.toolBaseDate[param1].expl = this.dateObject[param1].info.@describe;
         }
         else if(param2 == "picId")
         {
            this.toolBaseDate[param1].picId = this.dateObject[param1].info.@img_id;
         }
         else if(param2 == "name")
         {
            this.toolBaseDate[param1].name = this.dateObject[param1].info.@name;
         }
         else if(param2 == "quality")
         {
            this.toolBaseDate[param1].quality = this.dateObject[param1].info.@rare;
         }
         else if(param2 == "type")
         {
            this.toolBaseDate[param1].type = this.dateObject[param1].info.@type;
         }
         else if(param2 == "typeName")
         {
            this.toolBaseDate[param1].typeName = this.dateObject[param1].info.@type_name;
         }
         else if(param2 == "use_condition")
         {
            this.toolBaseDate[param1].use_condition = this.dateObject[param1].info.@use_condition;
         }
         else if(param2 == "use_result")
         {
            this.toolBaseDate[param1].use_result = this.dateObject[param1].info.@use_result;
         }
         else if(param2 == "lottery_name")
         {
            this.toolBaseDate[param1].lottery_name = this.dateObject[param1].info.@lottery_name;
         }
         else if(param2 == "sell_price")
         {
            this.toolBaseDate[param1].sell_price = this.dateObject[param1].info.@sell_price;
         }
         else if(param2 == "use_level")
         {
            this.toolBaseDate[param1].use_level = this.dateObject[param1].info.@use_level;
         }
         return this.toolBaseDate[param1];
      }
      
      public function getToolAttribute(param1:int) : Tool
      {
         if(this.public_tool == null)
         {
            this.public_tool = new Tool(param1);
         }
         else
         {
            this.public_tool.setOrderId(param1);
         }
         return this.public_tool;
      }
      
      public function isSuccess() : Boolean
      {
         if(this._xml.response.status == "success")
         {
            return true;
         }
         return false;
      }
      
      internal function onComp(param1:ConfigLoadEvent) : void
      {
         this.loader.removeEventListener(CONFIG_FILE,this.onComp);
         this._xml = param1.getXml();
         this.saveAllTools();
      }
      
      private function orderids(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1] > _loc3_)
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function saveAllTools() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.dateObject = new Object();
         for(_loc1_ in this._xml.tools.item)
         {
            _loc2_ = new Object();
            _loc2_.id = this._xml.tools.item[_loc1_].@id;
            _loc2_.info = this._xml.tools.item[_loc1_];
            this.dateObject[_loc2_.id] = _loc2_;
         }
         this._xml = null;
      }
      
      private function setAllToolIds() : void
      {
         var _loc1_:String = null;
         _baseArr = new Array();
         for(_loc1_ in this.dateObject)
         {
            _baseArr.push(int(_loc1_));
         }
         _baseArr = this.orderids(_baseArr);
      }
   }
}

