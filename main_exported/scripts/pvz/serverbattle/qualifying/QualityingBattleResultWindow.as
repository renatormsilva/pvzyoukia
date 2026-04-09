package pvz.serverbattle.qualifying
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class QualityingBattleResultWindow extends BaseWindow
   {
      
      private var _intergral:int;
      
      private var _win:Boolean;
      
      private var _backfun:Function = null;
      
      private var _mc:MovieClip = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function QualityingBattleResultWindow(param1:Boolean, param2:int, param3:Function)
      {
         super();
         var _loc4_:Class = DomainAccess.getClass("_arena_result_window");
         this._mc = new _loc4_();
         this._mc.visible = false;
         this._backfun = param3;
         this._intergral = param2;
         this._win = param1;
         this.setVersionButton();
         this.addEvent();
         this.setLoction();
         this.show();
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
      
      private function show() : void
      {
         this.showWin();
         this.showRank();
         this._mc.visible = true;
         onShowEffect(this._mc);
      }
      
      private function showRank() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._win)
         {
            this._mc["_mc_rank"].gotoAndStop(3);
            _loc1_ = FuncKit.getNumEffect(this._intergral + "","Red");
            _loc1_.x = -_loc1_.width / 2;
            this._mc["_pic_rank"].addChild(_loc1_);
         }
         else
         {
            this._mc["_mc_rank"].gotoAndStop(4);
         }
      }
      
      private function showWin() : void
      {
         if(this._win)
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

