package pvz.shaketree.view.windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import node.Icon;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import utils.GetDomainRes;
   
   public class AddTimesWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _currentTimes:int = 1;
      
      private var _callback:Function;
      
      public function AddTimesWindow(param1:Function = null)
      {
         super();
         this._callback = param1;
      }
      
      override protected function initWindowUI() : void
      {
         this._window = GetDomainRes.getMoveClip("actionWindow");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._window.text0.visible = false;
         this.setLoction();
         this.addEvent();
         Icon.setUrlIcon(this._window.pic,1,Icon.SYSTEM_1);
         this.updatePage();
         onShowEffect(this._window);
      }
      
      private function addEvent() : void
      {
         this._window.ok.addEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
         this._window.cancel.addEventListener(MouseEvent.MOUSE_UP,this.onClose);
         this._window.up_down_mc.down_btn.addEventListener(MouseEvent.MOUSE_UP,this.onDecTimes);
         this._window.up_down_mc.up_btn.addEventListener(MouseEvent.MOUSE_UP,this.onAddTimes);
         this._window["up_down_mc"]["num_text"].addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._window["up_down_mc"]["num_text"].addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         if(this._window["up_down_mc"]["num_text"].text == "")
         {
            this._currentTimes = 1;
         }
         else
         {
            this._currentTimes = int(this._window["up_down_mc"]["num_text"].text);
         }
         if(this._currentTimes <= 1)
         {
            this._currentTimes = 1;
         }
         if(this._currentTimes >= ShakeTreeSystermData.I.getCanBuyChanllageTimes())
         {
            this._currentTimes = ShakeTreeSystermData.I.getCanBuyChanllageTimes();
         }
         this.updatePage();
      }
      
      private function onDecTimes(param1:MouseEvent) : void
      {
         if(this._currentTimes <= 1)
         {
            return;
         }
         --this._currentTimes;
         this.updatePage();
      }
      
      private function onAddTimes(param1:MouseEvent) : void
      {
         if(this._currentTimes >= ShakeTreeSystermData.I.getCanBuyChanllageTimes())
         {
            return;
         }
         ++this._currentTimes;
         this.updatePage();
      }
      
      private function updatePage() : void
      {
         this._window.up_down_mc.num_text.text = this._currentTimes + "";
         this.updateTipConent();
      }
      
      private function updateTipConent() : void
      {
         this._window.text1.htmlText = LangManager.getInstance().getLanguage("shakeTree001") + "<font color=\'#ff0000\' size=\'15\'><center>" + this._currentTimes * 10 + LangManager.getInstance().getLanguage("node013") + "</center></font>" + LangManager.getInstance().getLanguage("shakeTree002") + "<font color=\'#ff0000\' size=\'15\'><center>" + this._currentTimes + LangManager.getInstance().getLanguage("shakeTree004") + "</center></font>" + LangManager.getInstance().getLanguage("shakeTree003");
      }
      
      private function onBuyTimes(param1:MouseEvent) : void
      {
         this._window.ok.removeEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
         onHiddenEffect(this._window,this.destory);
         if(this._callback != null)
         {
            this._callback(this._currentTimes);
         }
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this._window.cancel.removeEventListener(MouseEvent.MOUSE_UP,this.onClose);
         onHiddenEffect(this._window,this.destory);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function destory() : void
      {
         this._window.ok.removeEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
         this._window.cancel.removeEventListener(MouseEvent.MOUSE_UP,this.onClose);
         this._window.up_down_mc.down_btn.removeEventListener(MouseEvent.MOUSE_UP,this.onDecTimes);
         this._window.up_down_mc.up_btn.removeEventListener(MouseEvent.MOUSE_UP,this.onAddTimes);
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

