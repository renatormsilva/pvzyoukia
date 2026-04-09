package pvz.copy.ui.tips
{
   import core.ui.tips.BaseHelpTips;
   import manager.LangManager;
   
   public class StoneHelpTips extends BaseHelpTips
   {
      
      public function StoneHelpTips()
      {
         super(8);
         this.initUI();
      }
      
      private function initUI() : void
      {
         _row = int(LangManager.getInstance().getLanguage("copyHelpNum"));
         if(_row <= 0)
         {
            return;
         }
         _frefixName = LangManager.getInstance().getLanguage("copyHelpTipsStr");
         createTips();
      }
   }
}

