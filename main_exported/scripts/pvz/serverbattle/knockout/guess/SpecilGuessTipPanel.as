package pvz.serverbattle.knockout.guess
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import utils.GetDomainRes;
   import utils.Singleton;
   import windows.ChallengePropWindow;
   import zlib.utils.DomainAccess;
   
   public class SpecilGuessTipPanel extends BaseWindow
   {
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _window:Sprite;
      
      private var _func:Function;
      
      private var closeBtn:SimpleButton;
      
      public function SpecilGuessTipPanel(param1:Function = null)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("serverbattle.knockout.guess.specilguess");
         this._window = new _loc2_();
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         if(this.closeBtn == null)
         {
            this.closeBtn = GetDomainRes.getSimpleButton("pvz.button.close");
         }
         this.closeBtn.x = 150;
         this.closeBtn.y = -115;
         this._window.addChild(this.closeBtn);
         PlantsVsZombies._node.addChild(this._window);
         this._window["openVip"].visible = false;
         this._window["upVip"].visible = false;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            if(this.playerManager.getPlayer().getVipLevel() < 2)
            {
               this._window["upVip"].visible = true;
            }
         }
         else
         {
            this._window["openVip"].visible = true;
         }
         this._func = param1;
         this.setLoction();
         this.addEvent();
         onShowEffect(this._window);
      }
      
      private function addEvent() : void
      {
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["openVip"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["upVip"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeBtEvent() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["openVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["upVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(param1.currentTarget.name == "upVip")
         {
            JSManager.toRecharge();
         }
         else if(param1.currentTarget.name == "openVip")
         {
            new ChallengePropWindow(ChallengePropWindow.TYPE_VIP,this._func,true);
         }
         onHiddenEffect(this._window,this.hidden);
      }
      
      private function setLoction() : void
      {
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      private function hidden() : void
      {
         super.removeBG();
         this.removeBtEvent();
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

