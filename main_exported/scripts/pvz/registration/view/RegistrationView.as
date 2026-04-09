package pvz.registration.view
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import pvz.registration.control.RegistrationMgr;
   import pvz.registration.view.panel.ActPanel;
   import pvz.registration.view.panel.RegPanel;
   import utils.GetDomainRes;
   
   public class RegistrationView extends BaseWindow
   {
      
      private var _mgr:RegistrationMgr;
      
      private var close:SimpleButton;
      
      private var _regPanel:RegPanel;
      
      private var _actPanel:ActPanel;
      
      public function RegistrationView(param1:RegistrationMgr)
      {
         this._mgr = param1;
         super(UINameConst.UI_REGISTRATUION);
      }
      
      override protected function initWindowUI() : void
      {
         showType = PANEL_TYPE_2;
         this.initUI();
      }
      
      private function initUI() : void
      {
         var _loc1_:MovieClip = GetDomainRes.getMoveClip("pvz.reg.viewBg");
         this.addChild(_loc1_);
         this.x = (PlantsVsZombies.WIDTH - _loc1_.width) * 0.5;
         this.y = 15 + (PlantsVsZombies.HEIGHT - _loc1_.height) * 0.5;
         this.close = GetDomainRes.getSimpleButton("pvz.button.close");
         this.close.x = 617;
         this.close.y = 18;
         this.addChild(this.close);
         this._regPanel = new RegPanel();
         this._regPanel.x = 15;
         this._regPanel.y = 41;
         this.addChild(this._regPanel);
         this._actPanel = new ActPanel();
         this._actPanel.x = 336;
         this._actPanel.y = 41;
         this.addChild(this._actPanel);
         this.addEvent();
         this.onShow();
      }
      
      public function upData() : void
      {
         this._regPanel.upData();
         this._actPanel.upData();
      }
      
      private function addEvent() : void
      {
         this.close.addEventListener(MouseEvent.CLICK,this.closeFun);
      }
      
      private function romEvent() : void
      {
         this.close.removeEventListener(MouseEvent.CLICK,this.closeFun);
      }
      
      private function closeFun(param1:MouseEvent) : void
      {
         this._mgr.closeSystem();
      }
      
      override public function onHide() : void
      {
         super.onHide();
         this.romEvent();
      }
   }
}

