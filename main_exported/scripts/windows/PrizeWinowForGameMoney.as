package windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class PrizeWinowForGameMoney extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _callback:Function;
      
      public function PrizeWinowForGameMoney(param1:Function = null)
      {
         this._callback = param1;
         this.showType = PANEL_TYPE_2;
         super();
      }
      
      override protected function initWindowUI() : void
      {
         this._window = GetDomainRes.getMoveClip("pvz.prizeWindow.gameMoney");
         addChild(this._window);
         this.setLoction();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function(param1:MouseEvent):void
         {
            _window["_bt_ok"].removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffect(_window,destory);
         };
         var invite:Function = function(param1:MouseEvent):void
         {
            _window["_bt_ok"].removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffect(_window,destory);
         };
         this._window["_bt_ok"].addEventListener(MouseEvent.MOUSE_UP,onClose);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      public function show(param1:Number) : void
      {
         FuncKit.clearAllChildrens(this._window.num_node);
         this._window.num_node.addChild(FuncKit.getNumEffect(param1 + ""));
         onShowEffect(this._window);
         onShow();
      }
      
      private function destory() : void
      {
         if(this._callback != null)
         {
            this._callback();
         }
         onHide();
      }
   }
}

