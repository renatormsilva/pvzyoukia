package pvz.possession
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class PossessionResultWindow extends BaseWindow
   {
      
      internal var _backfun:Function = null;
      
      private var _honor:int = 0;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _mc:MovieClip = null;
      
      public function PossessionResultWindow(param1:Boolean, param2:Function, param3:int)
      {
         super();
         var _loc4_:Class = DomainAccess.getClass("_possession_result_window");
         this._mc = new _loc4_();
         this._mc.visible = false;
         this._backfun = param2;
         this._honor = param3;
         this.addEvent();
         this.setLoction();
         this.show(param1);
         PlantsVsZombies._node.addChild(this._mc);
      }
      
      private function setLoction() : void
      {
         this._mc.x = PlantsVsZombies.WIDTH - this._mc.width + 40;
         this._mc.y = PlantsVsZombies.HEIGHT - this._mc.height + 110;
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
         this._mc["_pic_honor"].addChild(FuncKit.getNumEffect(this._honor - this.playerManager.getPlayer().getHonour() + "","Red"));
         this.playerManager.getPlayer().setHonour(this._honor);
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
      
      private function addEvent() : void
      {
         this._mc["_bt_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._mc["_bt_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
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
      
      private function hidden() : void
      {
         onHiddenEffect(this._mc,this.clear);
      }
      
      private function clear() : void
      {
         PlantsVsZombies._node.removeChild(this._mc);
         if(this._backfun != null)
         {
            this._backfun();
         }
      }
   }
}

