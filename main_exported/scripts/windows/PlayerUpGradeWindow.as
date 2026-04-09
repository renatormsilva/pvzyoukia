package windows
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import labels.PlayerUpGradeToolLabel;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.StringMovieClip;
   import zlib.utils.DomainAccess;
   
   public class PlayerUpGradeWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _back:Function = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PlayerUpGradeWindow(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("playerUpGradeWindow");
         this._window = new _loc2_();
         this._window.visible = false;
         this._window["close"].visible = true;
         this._back = param1;
         PlantsVsZombies._node.addChild(this._window);
         this._window["close"].addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.hidden();
      }
      
      public function show(param1:Array, param2:int) : void
      {
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         this.setInfo(param1,param2);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
         PlantsVsZombies.playFireworks(15);
      }
      
      private function setInfo(param1:Array, param2:int) : void
      {
         var _loc4_:PlayerUpGradeToolLabel = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new PlayerUpGradeToolLabel(param1[_loc3_]);
            _loc4_.x = (_loc4_.width + 10) * _loc3_ + 215;
            _loc4_.y = 110;
            this._window.addChild(_loc4_);
            _loc3_++;
         }
         this._window._money.text = LangManager.getInstance().getLanguage("window086") + param2;
         this._window._hunts.text = LangManager.getInstance().getLanguage("window087") + this.playerManager.getPlayer().getHunts();
         this._window._flowerpots.text = LangManager.getInstance().getLanguage("window088") + this.playerManager.getPlayer().getFlowerpotNum();
         this._window._friendlands.text = LangManager.getInstance().getLanguage("window089") + this.playerManager.getPlayer().getFriendLands();
         this._window._title.text = this.playerManager.getPlayer().getGrade() + "";
         this.showGrade();
      }
      
      private function showGrade() : void
      {
         if(this._window._pic != null)
         {
            FuncKit.clearAllChildrens(this._window._pic);
         }
         var _loc1_:DisplayObject = StringMovieClip.getStringImage(this.playerManager.getPlayer().getGrade() + "","Level");
         if(this.playerManager.getPlayer().getGrade() < 10)
         {
            _loc1_.x = _loc1_.width / 2;
         }
         this._window._pic.addChild(_loc1_);
      }
      
      private function hidden() : void
      {
         if(this._back == null)
         {
            onHiddenEffect(this._window,this.showInvite);
         }
         else
         {
            onHiddenEffect(this._window,this._back);
         }
      }
      
      private function showInvite() : void
      {
         var share:Function = null;
         share = function():void
         {
            JSManager.showShare("share001");
         };
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
            PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("invite001"),share);
         }
         else if(GlobalConstants.PVZ_VERSION == VersionManager.YOUKIA_VERSION)
         {
            PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("invite001"),null);
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
   }
}

