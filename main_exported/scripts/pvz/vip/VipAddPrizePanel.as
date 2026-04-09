package pvz.vip
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import utils.Singleton;
   import windows.ChallengePropWindow;
   import zlib.utils.DomainAccess;
   
   public class VipAddPrizePanel extends BaseWindow
   {
      
      private var _panel:Sprite;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _func:Function;
      
      public function VipAddPrizePanel(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("vipPrize");
         this._panel = new _loc2_();
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._panel);
         this._panel["upgrade"].visible = false;
         this._panel["open"].visible = false;
         this._panel["continueVip"].visible = false;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            if(this.playerManager.getPlayer().getVipLevel() == 4)
            {
               this._panel["continueVip"].visible = true;
            }
            else
            {
               this._panel["upgrade"].visible = true;
            }
         }
         else
         {
            this._panel["open"].visible = true;
         }
         this._func = param1;
         this.setLoction();
         this.addClickEvent();
         onShowEffect(this._panel);
      }
      
      private function addClickEvent() : void
      {
         this._panel["close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["open"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["upgrade"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["continueVip"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeBtEvent() : void
      {
         this._panel["close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["open"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["upgrade"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["continueVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(param1.currentTarget.name == "upgrade")
         {
            JSManager.toRecharge();
         }
         else if(param1.currentTarget.name == "open" || param1.currentTarget.name == "continueVip")
         {
            new ChallengePropWindow(ChallengePropWindow.TYPE_VIP,this._func,true);
         }
         onHiddenEffect(this._panel,this.hidden);
      }
      
      private function hidden() : void
      {
         super.removeBG();
         this.removeBtEvent();
         PlantsVsZombies._node.removeChild(this._panel);
      }
      
      private function setLoction() : void
      {
         this._panel.x = (PlantsVsZombies.WIDTH - this._panel.width) / 2 + this._panel.width / 2;
         this._panel.y = (PlantsVsZombies.HEIGHT - this._panel.height) / 2 + this._panel.height / 2 - 30;
      }
   }
}

