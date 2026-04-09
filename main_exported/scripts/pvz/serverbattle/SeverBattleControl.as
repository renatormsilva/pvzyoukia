package pvz.serverbattle
{
   import constants.GlobalConstants;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import loading.UILoading;
   import manager.LangManager;
   import pvz.serverbattle.knockout.KnockoutForelet;
   import pvz.serverbattle.qualifying.QualityingPanel;
   import utils.FuncKit;
   import zlib.event.ForeletEvent;
   import zmyth.res.IDestroy;
   
   public class SeverBattleControl
   {
      
      private static var m_instance:SeverBattleControl;
      
      private static var m_isCreating:Boolean = false;
      
      public static const QUALIFYING:int = 1;
      
      public static const KNOCKOUT:int = 2;
      
      private var loadurl:String = "config/load/serverbattle/";
      
      private var _uiLoad:UILoading = null;
      
      private var domainUrl:String;
      
      private var mainNode:MovieClip;
      
      private var panel:IDestroy;
      
      private var backtofirstpage:SimpleButton;
      
      private var nowState:int = 0;
      
      public function SeverBattleControl()
      {
         super();
         if(!m_isCreating)
         {
            throw Error("can\'t new this object!!");
         }
      }
      
      public static function getInstance() : SeverBattleControl
      {
         if(m_instance == null)
         {
            m_isCreating = true;
            m_instance = new SeverBattleControl();
            m_isCreating = false;
         }
         return m_instance;
      }
      
      public function initUI(param1:int, param2:MovieClip) : void
      {
         var _loc3_:String = null;
         this.mainNode = param2;
         this.nowState = param1;
         switch(param1)
         {
            case QUALIFYING:
               _loc3_ = "qualifying.xml";
               this.domainUrl = "";
               break;
            case KNOCKOUT:
               _loc3_ = "knockout.xml";
               this.domainUrl = "";
         }
         _loc3_ = this.loadurl + _loc3_ + "?";
         this.loadGameUi(_loc3_);
      }
      
      private function loadGameUi(param1:String) : void
      {
         this._uiLoad = new UILoading(this.mainNode,GlobalConstants.PVZ_RES_BASE_URL,param1 + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         this.initLanaguage();
         this.createObject();
      }
      
      private function initLanaguage() : void
      {
         LangManager.getInstance().doLoad(LangManager.MODE_SEVERBATTLE);
      }
      
      private function createObject() : void
      {
         if(this.nowState == QUALIFYING)
         {
            this.panel = new QualityingPanel(this.mainNode);
         }
         else if(this.nowState == KNOCKOUT)
         {
            this.panel = new KnockoutForelet(this.mainNode);
         }
      }
      
      public function distroy() : void
      {
         if(this.panel == null)
         {
            return;
         }
         this.panel.destroy();
         this.panel = null;
      }
   }
}

