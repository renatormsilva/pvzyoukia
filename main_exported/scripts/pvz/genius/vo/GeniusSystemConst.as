package pvz.genius.vo
{
   import manager.LangManager;
   
   public class GeniusSystemConst
   {
      
      public static const JEWEL_ALL:int = 0;
      
      public static const JEWEL_RED:int = 36;
      
      public static const JEWEL_GREEN:int = 37;
      
      public static const JEWEL_SMOKYQUARTZ:int = 38;
      
      public static const JEWEL_BLUE:int = 39;
      
      public static const JEWEL_WITHE:int = 40;
      
      public static const JEWEL_SUN:int = 41;
      
      public static const JEWEL_BLACK:int = 42;
      
      public static const JEWEL_PURPLE:int = 43;
      
      public static const JEWEL_REVIER:int = 44;
      
      public static const DROP_DOWN_LIST:Array = [JEWEL_ALL,JEWEL_RED,JEWEL_GREEN,JEWEL_SMOKYQUARTZ,JEWEL_BLUE,JEWEL_WITHE,JEWEL_SUN,JEWEL_BLACK,JEWEL_PURPLE,JEWEL_REVIER];
      
      public static const GENIUS_MAX_LEVEL:int = 10;
      
      public static const SOUL_MAX_LEVEL:int = 10;
      
      public function GeniusSystemConst()
      {
         super();
      }
      
      public static function GetLabelByType(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case JEWEL_ALL:
               _loc2_ = LangManager.getInstance().getLanguage("genius017");
               break;
            case JEWEL_RED:
               _loc2_ = LangManager.getInstance().getLanguage("genius018");
               break;
            case JEWEL_GREEN:
               _loc2_ = LangManager.getInstance().getLanguage("genius019");
               break;
            case JEWEL_SMOKYQUARTZ:
               _loc2_ = LangManager.getInstance().getLanguage("genius020");
               break;
            case JEWEL_BLUE:
               _loc2_ = LangManager.getInstance().getLanguage("genius021");
               break;
            case JEWEL_WITHE:
               _loc2_ = LangManager.getInstance().getLanguage("genius022");
               break;
            case JEWEL_SUN:
               _loc2_ = LangManager.getInstance().getLanguage("genius023");
               break;
            case JEWEL_BLACK:
               _loc2_ = LangManager.getInstance().getLanguage("genius024");
               break;
            case JEWEL_PURPLE:
               _loc2_ = LangManager.getInstance().getLanguage("genius025");
               break;
            case JEWEL_REVIER:
               _loc2_ = LangManager.getInstance().getLanguage("genius026");
         }
         return _loc2_;
      }
      
      public static function checkSoulValid(param1:int) : Boolean
      {
         if(param1 > 0 && param1 <= SOUL_MAX_LEVEL)
         {
            return true;
         }
         return false;
      }
      
      public static function checkGeniusValid(param1:int) : Boolean
      {
         if(param1 > 0 && param1 <= GENIUS_MAX_LEVEL)
         {
            return true;
         }
         return false;
      }
   }
}

