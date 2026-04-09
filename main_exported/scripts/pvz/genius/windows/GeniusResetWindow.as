package pvz.genius.windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import utils.GetDomainRes;
   
   public class GeniusResetWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _backfunc:Function;
      
      public function GeniusResetWindow(param1:Function)
      {
         super();
         this._window = GetDomainRes.getMoveClip("GeniusSystem.GeniusReset");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._backfunc = param1;
         this.setLocation();
         onShowEffect(this._window);
         this._window._close.addEventListener(MouseEvent.MOUSE_UP,this.onClose);
         this._window.btn1.addEventListener(MouseEvent.MOUSE_UP,this.toReset);
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         var end:Function = null;
         var e:MouseEvent = param1;
         end = function():void
         {
            destory();
            PlantsVsZombies._node.removeChild(_window);
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._window._close.removeEventListener(MouseEvent.MOUSE_UP,this.onClose);
         onHiddenEffect(this._window,end);
      }
      
      private function setLocation() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function toReset(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         this._backfunc();
         this.onClose();
      }
      
      private function destory() : void
      {
         this._window.btn1.removeEventListener(MouseEvent.MOUSE_UP,this.toReset);
      }
   }
}

