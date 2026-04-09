package core.ui.panel
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class BaseActionWindow extends BaseWindow
   {
      
      protected var _window:MovieClip;
      
      protected var _currentTimes:int = 1;
      
      private var _callback:Function;
      
      protected var _useTool:Tool;
      
      private var _maxBuy:int = 10;
      
      public function BaseActionWindow(param1:Function = null, param2:int = 10, param3:Tool = null)
      {
         this._callback = param1;
         this._useTool = param3;
         this._maxBuy = param2;
         super();
         this.showType = PANEL_TYPE_2;
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:DisplayObject = null;
         this._window = GetDomainRes.getMoveClip("actionWindow");
         addChild(this._window);
         this._window.text0.visible = false;
         this.setLoction();
         this.addEvent();
         if(this._useTool)
         {
            Icon.setUrlIcon(this._window.pic,this._useTool.getPicId(),Icon.TOOL_1);
            _loc1_ = FuncKit.getNumEffect(this._useTool.getNum() + "");
            this._window.addChild(_loc1_);
            _loc1_.x = -120;
            _loc1_.y = -10;
         }
         else
         {
            Icon.setUrlIcon(this._window.pic,1,Icon.SYSTEM_1);
         }
         this.updatePage();
         onShow();
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
         if(this._currentTimes >= this._maxBuy)
         {
            this._currentTimes = this._maxBuy;
         }
         this.updatePage();
      }
      
      private function onDecTimes(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._currentTimes <= 1)
         {
            return;
         }
         --this._currentTimes;
         this.updatePage();
      }
      
      private function onAddTimes(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._currentTimes >= this._maxBuy)
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
      
      protected function updateTipConent() : void
      {
      }
      
      private function onBuyTimes(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._window.ok.removeEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
         this.destory();
         onHide();
         if(this._callback != null)
         {
            this._callback(this._currentTimes);
         }
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._window.cancel.removeEventListener(MouseEvent.MOUSE_UP,this.onClose);
         this.destory();
         onHide();
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
      }
   }
}

