package manager
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.GlobalConstants;
   import utils.FuncKit;
   
   public class LangManager implements IURLConnection
   {
      
      private static var _singleton:Boolean = true;
      
      private static var _instance:LangManager = null;
      
      public static const MODE_LANGUAGE:String = "language_";
      
      public static const MODE_POSSESSION:String = "possession_";
      
      public static const MODE_WORLD:String = "world_";
      
      public static const MODE_SEVERBATTLE:String = "severBattle_";
      
      public static const MODE_GENIUS:String = "genius_";
      
      public static const MODE_COPY:String = "copy_";
      
      public static const SHAKE_TREE:String = "shakeTree_";
      
      internal var lanaguage:Object;
      
      public function LangManager()
      {
         super();
         if(_singleton)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
         this.lanaguage = new Object();
      }
      
      public static function getInstance(param1:Boolean = false) : LangManager
      {
         if(_instance == null || param1)
         {
            _singleton = false;
            _instance = new LangManager();
            _singleton = true;
         }
         return _instance;
      }
      
      public function doLoad(param1:String) : void
      {
         this.urlloaderSend(param1,0);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(this.getURL(GlobalConstants.LANGUAGE_VERSION,param1),param2,this.onURLResult);
      }
      
      private function getURL(param1:String, param2:String) : String
      {
         return GlobalConstants.PVZ_RES_BASE_URL + "config/lang/" + param2 + param1 + ".xml?" + FuncKit.currentTimeMillis();
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         this.init(new XML(param2 as String));
      }
      
      private function init(param1:XML) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1.item)
         {
            this.lanaguage[param1.item[_loc2_].@name] = param1.item[_loc2_];
         }
      }
      
      public function getLanguage(param1:String, ... rest) : String
      {
         var _loc5_:String = null;
         var _loc3_:String = this.lanaguage[param1];
         if(_loc3_ == null || _loc3_ == "")
         {
            return param1;
         }
         var _loc4_:int = 0;
         while(_loc4_ < rest.length)
         {
            _loc5_ = "%" + (_loc4_ + 1).toString();
            _loc3_ = _loc3_.replace(_loc5_,rest[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

