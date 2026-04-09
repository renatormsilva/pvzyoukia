package pvz.shaketree.view.tips
{
   import core.ui.tips.BaseHelpTips;
   import manager.LangManager;
   
   public class ShakeTreeHelpTips extends BaseHelpTips
   {
      
      public function ShakeTreeHelpTips()
      {
         super(8);
         this.initUI();
      }
      
      private function initUI() : void
      {
         _row = int(LangManager.getInstance().getLanguage("shakeTreeHelpNum"));
         if(_row <= 0)
         {
            return;
         }
         _frefixName = LangManager.getInstance().getLanguage("shakeTreeHelpTipsStr");
         createTips();
      }
   }
}

