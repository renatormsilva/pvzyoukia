package xmlReader.config
{
   import constants.GlobalConstants;
   import entity.Tool;
   import flash.utils.Dictionary;
   import manager.LangManager;
   import pvz.genius.vo.GeniusData;
   import pvz.genius.vo.SoulData;
   import utils.ConfigLoadEvent;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   
   public class XmlGeniusDataConfig
   {
      
      private static var m_instance:XmlGeniusDataConfig;
      
      public static const STROM_ATTACK:String = "talent_1";
      
      public static const STRONG:String = "talent_2";
      
      public static const FOCUS:String = "talent_3";
      
      public static const PHANTOM:String = "talent_4";
      
      public static const CAZRY_WIND:String = "talent_5";
      
      public static const LIGHT_DEFFENCE:String = "talent_6";
      
      public static const DEFEAT:String = "talent_7";
      
      public static const POISON:String = "talent_8";
      
      public static const CLEAR:String = "talent_9";
      
      public static const GENIUS_MAX_LEVEL:int = 10;
      
      public static const SOUL_MAX_LEVEL:int = 10;
      
      private static const CONFIG_FILE:String = (GlobalConstants.PVZ_WEB_URL + "php_xml/talent.xml?" + FuncKit.currentTimeMillis()).replace("index.php/","");
      
      private static var dict:Object = {};
      
      private var loader:ConfigURLLoader;
      
      private var soulDict:Dictionary = new Dictionary();
      
      public function XmlGeniusDataConfig()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : XmlGeniusDataConfig
      {
         if(m_instance == null)
         {
            m_instance = new XmlGeniusDataConfig();
         }
         return m_instance;
      }
      
      public static function isSpecilGeinius(param1:String) : Boolean
      {
         if(param1 == LIGHT_DEFFENCE || param1 == POISON || param1 == DEFEAT || param1 == CLEAR)
         {
            return true;
         }
         return false;
      }
      
      public static function isLightOrDefent(param1:String) : Boolean
      {
         if(param1 == LIGHT_DEFFENCE || param1 == DEFEAT)
         {
            return true;
         }
         return false;
      }
      
      public static function getTitleByGeniusType(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1 == STRONG)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius008");
         }
         if(param1 == PHANTOM)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius009");
         }
         if(param1 == STROM_ATTACK)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius010");
         }
         if(param1 == FOCUS)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius011");
         }
         if(param1 == CAZRY_WIND)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius012");
         }
         if(param1 == LIGHT_DEFFENCE)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius013");
         }
         if(param1 == DEFEAT)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius013");
         }
         if(param1 == POISON)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius014");
         }
         if(param1 == CLEAR)
         {
            _loc2_ = LangManager.getInstance().getLanguage("genius015");
         }
         return _loc2_;
      }
      
      private function init() : void
      {
         this.loader = PlantsVsZombies.configLoader;
         this.loader.load(CONFIG_FILE);
         this.loader.addEventListener(CONFIG_FILE,this.onComp);
      }
      
      public function getGeniusDataByIdAndLevel(param1:String, param2:int) : GeniusData
      {
         if(dict[param1] == null)
         {
            return null;
         }
         if(dict[param1][param2] == null)
         {
            return null;
         }
         return dict[param1][param2];
      }
      
      public function getSoulDataByLevel(param1:int) : SoulData
      {
         if(this.soulDict[param1] == null)
         {
            throw new Error("没有对应等级灵魂的信息");
         }
         return this.soulDict[param1];
      }
      
      private function readXmlData(param1:XML) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:SoulData = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         for(_loc2_ in param1.talents.talent)
         {
            _loc6_ = {};
            for each(_loc7_ in param1.talents.talent[_loc2_].level)
            {
               _loc6_[_loc7_.@grade] = this.getDataCell(param1.talents.talent[_loc2_],_loc7_);
            }
            dict[param1.talents.talent[_loc2_].@id] = _loc6_;
         }
         _loc3_ = int(param1.souls.soul.length());
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = new SoulData();
            _loc4_.level = _loc5_ + 1;
            _loc4_.decode(param1.souls.soul[_loc5_]);
            this.soulDict[_loc5_ + 1] = _loc4_;
            _loc5_++;
         }
      }
      
      private function onComp(param1:ConfigLoadEvent) : void
      {
         this.loader.removeEventListener(CONFIG_FILE,this.onComp);
         this.readXmlData(param1.getXml());
      }
      
      private function getDataCell(param1:Object, param2:Object) : GeniusData
      {
         var _loc3_:int = int(param2.tools.tool.@id);
         var _loc4_:int = int(param2.tools.tool.@num);
         var _loc5_:Tool = new Tool(_loc3_);
         _loc5_.setNum(_loc4_);
         return new GeniusData(param1.@id,param1.@name,param1.@describe_a,param1.@describe_b,param2.@grade,param2.@possi,param2.@num,param2.@describe,param2.@org_grade,param2.@user_grade,_loc5_);
      }
   }
}

