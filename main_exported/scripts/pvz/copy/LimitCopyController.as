package pvz.copy
{
   import constants.GlobalConstants;
   import core.managers.GameManager;
   import loading.UILoading;
   import manager.LangManager;
   import pvz.copy.mediators.limitcopy.LimitCopyMediator;
   import utils.FuncKit;
   import zlib.event.ForeletEvent;
   
   public class LimitCopyController
   {
      
      private var m_uiLoad:UILoading = null;
      
      public function LimitCopyController()
      {
         super();
         this.loadRes();
      }
      
      private function loadRes() : void
      {
         LangManager.getInstance().doLoad(LangManager.MODE_COPY);
         this.m_uiLoad = new UILoading(GameManager.getInstance().toplayer,GlobalConstants.PVZ_RES_BASE_URL,"config/load/copy/limit.xml?" + FuncKit.currentTimeMillis());
         this.m_uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent = null) : void
      {
         this.m_uiLoad.remove();
         this.m_uiLoad = null;
         new LimitCopyMediator();
      }
   }
}

