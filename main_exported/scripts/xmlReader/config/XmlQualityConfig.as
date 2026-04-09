package xmlReader.config
{
   import constants.GlobalConstants;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import utils.FuncKit;
   
   public class XmlQualityConfig
   {
      
      private static var _instance:XmlQualityConfig;
      
      private static const CONFIG_FILE:String = GlobalConstants.PVZ_RES_BASE_URL + "config/quality.xml?";
      
      private static var _singleton:Boolean = true;
      
      private static var colors:Array = ["0x999999","0xFFFFFF","0x99FE02","0x34CCFE","0x7950D2","0xFF01FF","0xF58529","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000","0xFE0000"];
      
      private static var words_colors:Array = ["Gray","WhiteB","AppleGreen","AcidBlue","DeepPurple","RoseRed","OrgB","RedB","RedB","RedB","RedB","RedB","RedB","RedB","RedB"];
      
      private var _xml:XML;
      
      private var loader:URLLoader;
      
      public function XmlQualityConfig()
      {
         super();
         if(_singleton)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
         this.loader = new URLLoader(new URLRequest(CONFIG_FILE + FuncKit.currentTimeMillis()));
         this.loader.addEventListener(Event.COMPLETE,this.onComplete);
      }
      
      public static function getInstance() : XmlQualityConfig
      {
         if(_instance == null)
         {
            _singleton = false;
            _instance = new XmlQualityConfig();
            _singleton = true;
         }
         return _instance;
      }
      
      public function error() : String
      {
         return this._xml.response.error;
      }
      
      public function getColor(param1:String) : uint
      {
         var str:String = param1;
         return colors[this._xml.qualitys.item.(@name == str).@id - 1];
      }
      
      public function getWordsColor(param1:String) : String
      {
         var str:String = param1;
         return words_colors[this._xml.qualitys.item.(@name == str).@id - 1];
      }
      
      public function getID(param1:String) : int
      {
         var str:String = param1;
         return this._xml.qualitys.item.(@name == str).@id;
      }
      
      public function getCardQualityId(param1:String) : uint
      {
         var qid:uint = 0;
         var str:String = param1;
         qid = uint(this._xml.qualitys.item.(@name == str).@id);
         return qid > 12 ? 13 : qid;
      }
      
      public function getName(param1:int) : String
      {
         var id:int = param1;
         return this._xml.qualitys.item.(@id == id).@name;
      }
      
      public function getSkillNum(param1:String) : int
      {
         var str:String = param1;
         if(this._xml == null)
         {
            return 0;
         }
         if(str == null || str == "")
         {
            return 0;
         }
         return this._xml.qualitys.item.(@name == str).@skill_num;
      }
      
      public function getUpRatio(param1:String) : int
      {
         var str:String = param1;
         return this._xml.qualitys.item.(@name == str).@up_ratio;
      }
      
      public function isSuccess() : Boolean
      {
         if(this._xml.response.status == "success")
         {
            return true;
         }
         return false;
      }
      
      public function onComplete(param1:Event) : void
      {
         this._xml = new XML(this.loader.data);
         this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
      }
   }
}

