package pvz.battle.window
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class ArenaResultWindow extends BaseWindow
   {
      
      internal var _backfun:Function = null;
      
      internal var _mc:MovieClip = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function ArenaResultWindow(param1:Boolean, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("_arena_result_window");
         this._mc = new _loc3_();
         this._mc.visible = false;
         this._backfun = param2;
         this.setVersionButton();
         this.addEvent();
         this.setLoction();
         this.show(param1);
         PlantsVsZombies._node.addChild(this._mc);
      }
      
      private function addEvent() : void
      {
         this._mc["_bt_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function clear() : void
      {
         PlantsVsZombies._node.removeChild(this._mc);
         if(this._backfun != null)
         {
            this._backfun();
         }
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._mc,this.clear);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.removeEvent();
         if(param1.currentTarget.name == "_bt_ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.hidden();
         }
      }
      
      private function removeEvent() : void
      {
         this._mc["_bt_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._mc.x = PlantsVsZombies.WIDTH - this._mc.width + 40;
         this._mc.y = PlantsVsZombies.HEIGHT - this._mc.height + 110;
      }
      
      private function setVersionButton() : void
      {
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
         }
      }
      
      private function show(param1:Boolean) : void
      {
         this.showWin(param1);
         this.showRank();
         this._mc.visible = true;
         onShowEffect(this._mc);
      }
      
      private function showRank() : void
      {
         if(this.playerManager.getPlayer().getArenaRank() < this.playerManager.getPlayer().getArenaLastRank())
         {
            this._mc["_mc_rank"].gotoAndStop(1);
         }
         else
         {
            this._mc["_mc_rank"].gotoAndStop(2);
         }
         this._mc["_pic_rank"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getArenaRank() + "","Red"));
      }
      
      private function showWin(param1:Boolean) : void
      {
         if(param1)
         {
            this._mc["_mc_win"].gotoAndStop(1);
         }
         else
         {
            this._mc["_mc_win"].gotoAndStop(2);
         }
      }
   }
}

