package windows
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class PlayerInfoWindow extends BaseWindow
   {
      
      private static var GRADE_WIDTH:int = 50;
      
      internal var _window:MovieClip;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PlayerInfoWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("playinfoWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["close"].addEventListener(MouseEvent.CLICK,this.onClose);
         if(GlobalConstants.PVZ_VERSION == VersionManager.WEB_VERSION)
         {
            this._window["invite_button"].visible = false;
         }
         if(GlobalConstants.PVZ_VERSION != VersionManager.WEB_VERSION)
         {
            this._window["invite_button"].addEventListener(MouseEvent.CLICK,this.onInviteClick);
         }
      }
      
      private function onInviteClick(param1:MouseEvent) : void
      {
         JSManager.invite();
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.hidden();
      }
      
      public function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         this.setInfo();
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function setInfo() : void
      {
         if(this._window == null)
         {
            return;
         }
         PlantsVsZombies.setHeadPic(this._window._pic,PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
         this._window._name.text = this.playerManager.getPlayer().getNickname();
         this.setGrade();
         this._window._flowerpot.text = this.playerManager.getPlayer().getNowflowerpotNum() + "/" + this.playerManager.getPlayer().getFlowerpotNum();
         this._window._hunts.text = this.playerManager.getPlayer().getHunts() - this.playerManager.getPlayer().getNowHunts() + "/" + this.playerManager.getPlayer().getHunts();
         this._window._rmb.text = FuncKit.transformNum(this.playerManager.getPlayer().getRMB(),-1);
         if(this.playerManager.getPlayer().getTodayExp() < this.playerManager.getPlayer().getTodayMaxExp())
         {
            this._window._today_max_exp.text = this.playerManager.getPlayer().getTodayExp() + "/" + this.playerManager.getPlayer().getTodayMaxExp();
         }
         else
         {
            this._window._today_max_exp.text = this.playerManager.getPlayer().getTodayMaxExp() + "/" + this.playerManager.getPlayer().getTodayMaxExp();
         }
         this._window._honour.text = this.playerManager.getPlayer().getHonour();
         this._window._occupy.text = this.playerManager.getPlayer().getOccupyMaxNum() - this.playerManager.getPlayer().getOccupyNum() + "/" + this.playerManager.getPlayer().getOccupyMaxNum();
         if(GlobalConstants.PVZ_VERSION == VersionManager.WEB_VERSION)
         {
            this._window._wins.text = "";
         }
         this._window._charm.text = this.playerManager.getPlayer().getCharm();
         this._window._exp_text.text = this.playerManager.getPlayer().getExp() - this.playerManager.getPlayer().getExp_min() + "/" + (this.playerManager.getPlayer().getExp_max() - this.playerManager.getPlayer().getExp_min());
         var _loc1_:int = this.playerManager.getPlayer().getExp() - this.playerManager.getPlayer().getExp_min();
         var _loc2_:int = this.playerManager.getPlayer().getExp_max() - this.playerManager.getPlayer().getExp_min();
         if(_loc1_ >= _loc2_)
         {
            this._window._exp.scaleX = 1;
            return;
         }
         this._window._exp.scaleX = _loc1_ / _loc2_;
      }
      
      private function setGrade() : void
      {
         if(this._window._grade.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window._grade);
         }
         var _loc1_:Class = DomainAccess.getClass("grade");
         var _loc2_:MovieClip = new _loc1_();
         _loc2_["num"].addChild(FuncKit.getNumEffect("" + this.playerManager.getPlayer().getGrade()));
         this._window._grade.addChild(_loc2_);
         this._window._grade.x = this._window._grade_loc.x + (GRADE_WIDTH - _loc2_.width) / 2;
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
   }
}

