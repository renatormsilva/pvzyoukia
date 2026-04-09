package manager
{
   import flash.external.ExternalInterface;
   
   public class JSManager
   {
      
      public function JSManager()
      {
         super();
      }
      
      public static function addHP() : void
      {
         ExternalInterface.call("shareEvent","cure");
      }
      
      public static function battle() : void
      {
         ExternalInterface.call("shareEvent","battle");
      }
      
      public static function everyDay() : void
      {
         ExternalInterface.call("shareEvent","dailylogin");
      }
      
      public static function evolution() : void
      {
         ExternalInterface.call("shareEvent","evolution");
      }
      
      public static function fatigue() : String
      {
         return ExternalInterface.call("fatigue");
      }
      
      public static function gotoCardNo() : void
      {
         ExternalInterface.call("gotoCardNo");
      }
      
      public static function gotoFriendPage() : void
      {
         ExternalInterface.call("gotoFriendPage");
      }
      
      public static function gotoJsTask() : void
      {
         ExternalInterface.call("executeJsTask");
      }
      
      public static function gotoOtherHome(param1:int) : void
      {
         ExternalInterface.call("goToOtherHome",param1);
      }
      
      public static function gotoService() : void
      {
         ExternalInterface.call("gotoService");
      }
      
      public static function invite() : void
      {
         ExternalInterface.call("inviteFriend","_self");
      }
      
      public static function learnSkill() : void
      {
         ExternalInterface.call("shareEvent","learnskill");
      }
      
      public static function manor() : void
      {
         ExternalInterface.call("shareEvent","Manor");
      }
      
      public static function openCave() : void
      {
         ExternalInterface.call("shareEvent","openhole");
      }
      
      public static function orgComp() : void
      {
         ExternalInterface.call("shareEvent","Enhance");
      }
      
      public static function orgUp() : void
      {
         ExternalInterface.call("shareEvent","plantupgrade");
      }
      
      public static function playerUp() : void
      {
         ExternalInterface.call("shareEvent","upgrade");
      }
      
      public static function prizes() : void
      {
         ExternalInterface.call("shareEvent","openbox");
      }
      
      public static function pullulationUp() : void
      {
         ExternalInterface.call("shareEvent","growth");
      }
      
      public static function qualityUp() : void
      {
         ExternalInterface.call("shareEvent","grade");
      }
      
      public static function rush() : void
      {
         ExternalInterface.call("resetPage","_self");
      }
      
      public static function showShare(param1:String) : void
      {
         ExternalInterface.call("shareEvent",LangManager.getInstance().getLanguage(param1));
      }
      
      public static function share(param1:String) : void
      {
      }
      
      public static function signTo() : void
      {
         ExternalInterface.call("gomedal");
      }
      
      public static function toRecharge() : void
      {
         ExternalInterface.call("gotoUrl");
      }
      
      public static function goToActivity(param1:String) : void
      {
         ExternalInterface.call("goToActivity",param1);
      }
   }
}

