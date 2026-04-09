package tip
{
   import core.ui.tips.BaseTips;
   import manager.LangManager;
   import utils.TextFilter;
   
   public class XueZhanTip extends BaseTips
   {
      
      public function XueZhanTip()
      {
         super("battle.xuezhanTip");
         var _loc1_:String = "<font color=\'#ffffff\' size=\'13\'>" + LangManager.getInstance().getLanguage("hunting025") + "</font>";
         var _loc2_:String = "<font color=\'#ff0000\' size=\'17\'><b>" + LangManager.getInstance().getLanguage("hunting026") + "</b></font>";
         _ui["title"].htmlText = _loc2_;
         _ui["info"].htmlText = _loc1_;
         TextFilter.MiaoBian(_ui["info"],0);
         TextFilter.MiaoBian(_ui["title"],0);
      }
   }
}

