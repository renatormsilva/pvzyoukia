package xmlReader.config
{
   import constants.GlobalConstants;
   import entity.BaseOrganism;
   import entity.Organism;
   import flash.events.EventDispatcher;
   import utils.ConfigLoadEvent;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   
   public class XmlOrganismConfig extends EventDispatcher
   {
      
      private static var _instance:XmlOrganismConfig;
      
      private static const CONFIG_FILE:String = (GlobalConstants.PVZ_WEB_URL + "php_xml/organism.xml?" + FuncKit.currentTimeMillis()).replace("index.php/","");
      
      private static var PLANTS_NUM:int = 2000;
      
      private static var _singleton:Boolean = true;
      
      private var _baseArr:Array = null;
      
      private var _xml:XML;
      
      private var dateObject:Object = null;
      
      private var loader:ConfigURLLoader;
      
      private var orgBaseDate:Object = {};
      
      private var public_org:Organism = new Organism();
      
      public function XmlOrganismConfig()
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
      
      public static function getInstance(param1:Boolean = false) : XmlOrganismConfig
      {
         if(_instance == null || param1)
         {
            _singleton = false;
            _instance = new XmlOrganismConfig();
            _singleton = true;
         }
         return _instance;
      }
      
      public function error() : String
      {
         return this._xml.response.error;
      }
      
      public function getAllPlants() : Array
      {
         if(this._baseArr == null)
         {
            this.setAllPlantIds();
         }
         return this._baseArr;
      }
      
      public function getBaseOrganismAttribute(param1:int, param2:String) : BaseOrganism
      {
         var _loc3_:BaseOrganism = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(this.orgBaseDate[param1] != null && this.orgBaseDate[param1][param2] != null && this.orgBaseDate[param1][param2] != "" && this.orgBaseDate[param1][param2] != 0)
         {
            return this.orgBaseDate[param1];
         }
         if(this.orgBaseDate[param1] == null)
         {
            _loc3_ = new BaseOrganism();
            this.orgBaseDate[param1] = _loc3_;
         }
         if(param2 == "expl")
         {
            this.orgBaseDate[param1].expl = this.dateObject[param1].info.@expl;
         }
         else if(param2 == "picId")
         {
            this.orgBaseDate[param1].picId = this.dateObject[param1].info.@img_id;
         }
         else if(param2 == "orgname")
         {
            this.orgBaseDate[param1].orgname = this.dateObject[param1].info.@name;
         }
         else if(param2 == "sell_price")
         {
            this.orgBaseDate[param1].sell_price = this.dateObject[param1].info.@sell_price;
         }
         else if(param2 == "type")
         {
            this.orgBaseDate[param1].type = this.dateObject[param1].info.@type;
         }
         else if(param2 == "use_condition")
         {
            this.orgBaseDate[param1].use_condition = this.dateObject[param1].info.@use_condition;
         }
         else if(param2 == "use_result")
         {
            this.orgBaseDate[param1].use_result = this.dateObject[param1].info.@use_result;
         }
         else if(param2 == "height")
         {
            this.orgBaseDate[param1].height = this.dateObject[param1].info.@height;
         }
         else if(param2 == "width")
         {
            this.orgBaseDate[param1].width = this.dateObject[param1].info.@width;
         }
         else if(param2 == "attackTimes")
         {
            this.orgBaseDate[param1].attackTimes = this.dateObject[param1].info.@attack_amount;
         }
         else if(param2 == "attackType")
         {
            this.orgBaseDate[param1].attackType = this.dateObject[param1].info.@attack_type;
         }
         else if(param2 == "attribute_name")
         {
            this.orgBaseDate[param1].attribute_name = this.dateObject[param1].info.@attribute;
         }
         else if(param2 == "purse_amount")
         {
            this.orgBaseDate[param1].purse_amount = this.dateObject[param1].info.@output;
         }
         else if(param2 == "photosynthesis_time")
         {
            this.orgBaseDate[param1].photosynthesis_time = int(this.dateObject[param1].info.@photosynthesis_time);
         }
         else if(param2 == "evolution")
         {
            _loc4_ = new Array();
            for(_loc5_ in this.dateObject[param1].info.evolutions.item)
            {
               _loc6_ = new Object();
               _loc6_.id = this.dateObject[param1].info.evolutions.item[_loc5_].@id;
               _loc6_.grade = this.dateObject[param1].info.evolutions.item[_loc5_].@grade;
               _loc6_.toolid = this.dateObject[param1].info.evolutions.item[_loc5_].@tool_id;
               _loc6_.evoId = this.dateObject[param1].info.evolutions.item[_loc5_].@target;
               _loc6_.money = this.dateObject[param1].info.evolutions.item[_loc5_].@money;
               _loc4_.push(_loc6_);
            }
            this.orgBaseDate[param1].evolution = _loc4_;
         }
         return this.orgBaseDate[param1];
      }
      
      public function getOrganismAttribute(param1:int) : Organism
      {
         this.public_org.setOrderId(param1);
         return this.public_org;
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
         this.saveAllPlants();
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
      
      private function saveAllPlants() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.dateObject = new Object();
         for(_loc1_ in this._xml.organisms.item)
         {
            _loc2_ = new Object();
            _loc2_.id = this._xml.organisms.item[_loc1_].@id;
            _loc2_.info = this._xml.organisms.item[_loc1_];
            this.dateObject[_loc2_.id] = _loc2_;
         }
         this._xml = null;
      }
      
      private function setAllPlantIds() : void
      {
         var _loc1_:String = null;
         this._baseArr = new Array();
         for(_loc1_ in this.dateObject)
         {
            if(int(_loc1_) <= PLANTS_NUM)
            {
               this._baseArr.push(int(_loc1_));
            }
         }
         this._baseArr = this.orderids(this._baseArr);
      }
   }
}

