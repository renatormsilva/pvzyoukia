package manager
{
   import entity.Organism;
   
   public class OrganismManager
   {
      
      public static var FERTILISER:int = 2;
      
      public static var GAIN:int = 0;
      
      public static var NULL:int = 0;
      
      public static var WATER:int = 1;
      
      private static const _DARK:int = 2;
      
      private static const _FIRE:int = 0;
      
      private static const _LIGHT:int = 1;
      
      private static const _THUNDER:int = 4;
      
      private static const _WATER:int = 5;
      
      private static const _WIND:int = 3;
      
      public static const GOD:String = LangManager.getInstance().getLanguage("org007");
      
      public static const GHOST:String = LangManager.getInstance().getLanguage("org008");
      
      public static const MORTAL:String = LangManager.getInstance().getLanguage("org015");
      
      public static const DARK:String = LangManager.getInstance().getLanguage("org016");
      
      public static const DRAGON:String = LangManager.getInstance().getLanguage("org017");
      
      public static const ATTACK_LINE:int = 1;
      
      public static const ATTACK_PARABOLA:int = 3;
      
      public static const ATTACK_APEAK:int = 4;
      
      public static const ATTACK_CLOSE:int = 2;
      
      public static const COPY_ZOMBIE:int = 3;
      
      public static const ZOMBIE:int = 2;
      
      public static const PLANT:int = 1;
      
      private static const DifficultyAttribute:Array = new Array(0.8,1,1.2);
      
      public function OrganismManager()
      {
         super();
      }
      
      public static function changeZombie(param1:int, param2:int, param3:Organism) : void
      {
         var _loc4_:Number = getAttributePer(param3.getBlood(),param1);
         var _loc5_:Number = getAttributePer(param3.getBlood(),param2);
         param3.setHp(Number(param3.getHp().toNumber() * _loc5_ / _loc4_).toString());
         param3.setHp_max(Number(param3.getHp_max().toNumber() * _loc5_ / _loc4_).toString());
         param3.setAttack(Number(param3.getAttack() * _loc5_ / _loc4_));
      }
      
      private static function getAttributePer(param1:int, param2:int) : Number
      {
         if(param1 == ZOMBIE)
         {
            return Number(DifficultyAttribute[param2 - 1]);
         }
         if(param1 == PLANT)
         {
            throw new Error("OrganismManager---------getAttributePer----------Error---------without PLANT");
         }
         throw new Error("OrganismManager---------getAttributePer----------Error" + param1,param2);
      }
      
      public static function getOrgAttr(param1:int) : String
      {
         if(param1 == 0)
         {
            return "";
         }
         switch(param1 % 6)
         {
            case _LIGHT:
               return LangManager.getInstance().getLanguage("org001");
            case _WATER:
               return LangManager.getInstance().getLanguage("org002");
            case _WIND:
               return LangManager.getInstance().getLanguage("org003");
            case _DARK:
               return LangManager.getInstance().getLanguage("org004");
            case _FIRE:
               return LangManager.getInstance().getLanguage("org005");
            case _THUNDER:
               return LangManager.getInstance().getLanguage("org006");
            default:
               return "";
         }
      }
      
      public static function isOrnotActiveSkill(param1:int) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         switch(param1 % 6)
         {
            case _LIGHT:
               return true;
            case _WATER:
               return true;
            case _WIND:
               return true;
            case _DARK:
               return true;
            case _FIRE:
               return true;
            case _THUNDER:
               return true;
            default:
               return false;
         }
      }
   }
}

