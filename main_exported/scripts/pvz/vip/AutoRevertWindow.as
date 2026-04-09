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
   
   public class AutoRevertWindow extends BaseWindow
   {
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _window:Sprite;
      
      private var _func:Function;
      
      public function AutoRevertWindow(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("vip.autoRevert");
         this._window = new _loc2_();
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._window);
         this._window["recharge"].visible = false;
         this._window["openVip"].visible = false;
         this._window["continueVip"].visible = false;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            if(this.playerManager.getPlayer().getVipLevel() == 4)
            {
               this._window["continueVip"].visible = true;
            }
            else
            {
               this._window["recharge"].visible = true;
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
         this._window["close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["recharge"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["openVip"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["continueVip"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeBtEvent() : void
      {
         this._window["close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["recharge"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["openVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["continueVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(param1.currentTarget.name == "recharge")
         {
            JSManager.toRecharge();
         }
         else if(param1.currentTarget.name == "openVip" || param1.currentTarget.name == "continueVip")
         {
            new ChallengePropWindow(ChallengePropWindow.TYPE_VIP,this._func,true);
         }
         onHiddenEffect(this._window,this.hidden);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      private function hidden() : void
      {
         super.removeBG();
         this.removeBtEvent();
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

