package pvz.genius.tips
{
   import core.ui.tips.BaseHelpTips;
   import manager.LangManager;
   
   public class GeniusSystemHelpTips extends BaseHelpTips
   {
      
      public function GeniusSystemHelpTips()
      {
         super(8);
         this.initUI();
      }
      
      private function initUI() : void
      {
         _row = int(LangManager.getInstance().getLanguage("geniusHelpTipsNum"));
         if(_row <= 0)
         {
            return;
         }
         _frefixName = LangManager.getInstance().getLanguage("geniusHelpTipsStr");
         createTips();
      }
   }
}

