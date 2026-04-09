package pvz.serverbattle.knockout.scene
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.entity.PlayerInfo;
   import zlib.utils.DomainAccess;
   import zmyth.ui.TextFilter;
   
   public class KnockoutBattleResultWindow extends BaseWindow
   {
      
      private var _win:Boolean;
      
      private var _backfun:Function = null;
      
      private var _mc:MovieClip = null;
      
      private var playerfirst:Contestant;
      
      private var playersecond:Contestant;
      
      public function KnockoutBattleResultWindow(param1:Boolean, param2:PlayerInfo, param3:Function)
      {
         super();
         var _loc4_:Class = DomainAccess.getClass("serverBattle.knockout.battleresult");
         this._mc = new _loc4_();
         this._backfun = param3;
         this._win = param1;
         this.playerfirst = param2.firstPlayer;
         this.playersecond = param2.secondPlayer;
         this.addEvent();
         this.setLoction();
         this.show();
         TextFilter.MiaoBian(this._mc["names"],0);
         TextFilter.MiaoBian(this._mc["servername"],0);
         PlantsVsZombies._node.addChild(this._mc);
      }
      
      private function addEvent() : void
      {
         this._mc["_bt_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function clear() : void
      {
         this.removeEvent();
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
         this._mc.x = PlantsVsZombies.WIDTH / 2;
         this._mc.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      private function show() : void
      {
         this._mc["names"].selectable = false;
         this._mc["servername"].selectable = false;
         if(this._win)
         {
            PlantsVsZombies.setHeadPic(this._mc["pic"],PlantsVsZombies.getHeadPicUrl(this.playerfirst.getfaceUrl()),PlantsVsZombies.HEADPIC_BIG,this.playerfirst.getVipTime(),this.playerfirst.getVipGrade());
            this._mc["names"].text = this.playerfirst.getName();
            this._mc["servername"].text = this.playerfirst.getServerName();
         }
         else
         {
            PlantsVsZombies.setHeadPic(this._mc["pic"],PlantsVsZombies.getHeadPicUrl(this.playersecond.getfaceUrl()),PlantsVsZombies.HEADPIC_BIG,this.playersecond.getVipTime(),this.playersecond.getVipGrade());
            this._mc["names"].text = this.playersecond.getName();
            this._mc["servername"].text = this.playersecond.getServerName();
         }
         onShowEffect(this._mc);
      }
   }
}

