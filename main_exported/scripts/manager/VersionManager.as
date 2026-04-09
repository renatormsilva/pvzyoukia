package manager
{
   import constants.GlobalConstants;
   
   public class VersionManager
   {
      
      private static var m_insCreating:Boolean;
      
      private static var m_instance:VersionManager;
      
      public static const YOUKIA_VERSION:int = 1;
      
      public static const WEB_VERSION:int = 2;
      
      public static const KAIXIN_VERSION:int = 3;
      
      public static const YOUKIA_VERSION_URL:String = "http://youkia.pvz.yk.com/pvz/index.php/";
      
      public static const WEB_VERSION_URL:String = "http://webbeta.pvz.yk.com/pvz/index.php/";
      
      public static const KAIXIN_VERSION_URL:String = "http://kaixin.pvz.yk.com/pvz/index.php/";
      
      public function VersionManager()
      {
         super();
      }
      
      public static function get getVersionManagerInstance() : VersionManager
      {
         if(m_instance == null)
         {
            m_insCreating = true;
            m_instance = new VersionManager();
            m_insCreating = false;
         }
         return m_instance;
      }
      
      public function setVersionType(param1:int) : void
      {
         switch(param1)
         {
            case YOUKIA_VERSION:
               GlobalConstants.PVZ_WEB_URL = YOUKIA_VERSION_URL;
               break;
            case WEB_VERSION:
               GlobalConstants.PVZ_WEB_URL = WEB_VERSION_URL;
               break;
            case KAIXIN_VERSION:
               GlobalConstants.PVZ_WEB_URL = KAIXIN_VERSION_URL;
         }
         GlobalConstants.PVZ_RES_BASE_URL = "";
      }
   }
}

