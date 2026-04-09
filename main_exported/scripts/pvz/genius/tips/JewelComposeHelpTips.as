package pvz.genius.tips
{
   import core.ui.tips.BaseHelpTips;
   import manager.LangManager;
   
   public class JewelComposeHelpTips extends BaseHelpTips
   {
      
      public function JewelComposeHelpTips()
      {
         super(8);
         this.initUI();
      }
      
      private function initUI() : void
      {
         _row = int(LangManager.getInstance().getLanguage("jewelHelpTipsNum"));
         if(_row <= 0)
         {
            return;
         }
         _frefixName = LangManager.getInstance().getLanguage("jewelHelpTipsStr");
         createTips();
      }
   }
}

