package pvz.vip
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import zlib.utils.DomainAccess;
   
   public class AutoRegister extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _func:Function;
      
      public function AutoRegister(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("rechargeWindow");
         this._window = new _loc2_();
         this._window.gotoAndPlay(1);
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._window);
         onShowEffect(this._window);
         this._func = param1;
         this._window["text1"].text = LangManager.getInstance().getLanguage("vip011");
         this._window["ok1"].visible = false;
         this._window["ok2"].visible = false;
         this._window["cancel"].visible = false;
         this._window["sure"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.setLoction();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this._window["sure"].removeEventListener(MouseEvent.CLICK,this.onClick);
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(this._func != null)
         {
            this._func();
         }
         onHiddenEffect(this._window,this.hidden);
      }
      
      private function hidden() : void
      {
         if(this._window)
         {
            PlantsVsZombies._node.removeChild(this._window);
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      public function showStr(param1:String) : void
      {
         this._window["text1"].text = param1;
      }
   }
}

