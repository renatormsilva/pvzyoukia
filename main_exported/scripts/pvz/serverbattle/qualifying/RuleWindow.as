package pvz.serverbattle.qualifying
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import zlib.utils.DomainAccess;
   
   public class RuleWindow extends BaseWindow
   {
      
      public static const QUALIFYING_RULE:int = 1;
      
      public static const KNOCKOUT_RULE:int = 2;
      
      private var _window:MovieClip;
      
      public function RuleWindow(param1:int = 1)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("severbattle_ruleWindow");
         this._window = new _loc2_();
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._window["content_mc"].gotoAndStop(param1);
         this._window["title_mc"].gotoAndStop(param1);
         this._window.visible = false;
         this.setLoction();
         this.show();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         var onCloseWindow:Function = null;
         onCloseWindow = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window["close_btn"].removeEventListener(MouseEvent.MOUSE_UP,onCloseWindow);
            onHiddenEffect(_window,destory);
         };
         this._window["close_btn"].addEventListener(MouseEvent.MOUSE_UP,onCloseWindow);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function destory() : void
      {
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

