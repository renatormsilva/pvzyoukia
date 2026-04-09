package pvz.shaketree.view.windows
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.shaketree.view.PassPrizeLabel;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import utils.GetDomainRes;
   
   public class PassLevelWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _callback:Function;
      
      public function PassLevelWindow(param1:Function)
      {
         this._callback = param1;
         super();
      }
      
      override protected function initWindowUI() : void
      {
         this._window = GetDomainRes.getMoveClip("pvz.shaketree.passlevelwindow");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
         this._window.visible = false;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function():void
         {
            _window._close.removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffect(_window,destory);
         };
         this._window._close.addEventListener(MouseEvent.MOUSE_UP,onClose);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      public function show(param1:Array) : void
      {
         var _loc2_:int = ShakeTreeSystermData.I.currentPassData().getPassLevel();
         var _loc3_:int = Math.ceil(_loc2_ / 4);
         var _loc4_:String = _loc3_ + "-" + (_loc2_ - (_loc3_ - 1) * 4);
         this._window.txt1.htmlText = LangManager.getInstance().getLanguage("shakeTree005") + "<font color=\'#ff0000\' size=\'15\'><center>" + _loc4_ + "</center></font>";
         this.layoutPrizesTools(param1);
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function layoutPrizesTools(param1:Array) : void
      {
         var _loc2_:PassPrizeLabel = null;
         var _loc4_:Tool = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            _loc2_ = new PassPrizeLabel(_loc4_);
            this._window._prizesNode.addChild(_loc2_);
            _loc2_.x = 10 + _loc3_ * 110;
            _loc3_++;
         }
      }
      
      private function destory() : void
      {
         if(this._callback != null)
         {
            this._callback();
         }
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

