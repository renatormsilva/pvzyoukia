package pvz.copy.ui.windows
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.copy.CDTimeCopyController;
   import pvz.copy.LimitCopyController;
   import pvz.copy.models.CopyInfoProxy;
   import pvz.copy.models.CopyInfoVo;
   import pvz.copy.models.limit.ActivtyCopyData;
   import pvz.copy.net.ActivtyCopyFPort;
   import pvz.copy.ui.sprites.CopyInfoSprite;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import utils.GetDomainRes;
   
   public class ActivtyCopyEnteranceWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var _dataProxy:CopyInfoProxy;
      
      public function ActivtyCopyEnteranceWindow()
      {
         super(UINameConst.UI_ACTIVY_COPY_ENTERACNE);
         showType = PANEL_TYPE_2;
      }
      
      override protected function initWindowUI() : void
      {
         this._window = GetDomainRes.getMoveClip("pvz.activeCopy.enterane");
         addChild(this._window);
         this.setLoction();
         this._closeBtn = GetDomainRes.getSimpleButton("pvz.close");
         this._window["close"].addChild(this._closeBtn);
         this.addEvent();
         this.initbg();
         this.initData();
      }
      
      private function initbg() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = GetDomainRes.getBitmap("pvz.activtycopy.locked");
            this._window["_bgnode"].addChild(_loc1_);
            _loc1_.x = (_loc1_.width + 5) * _loc2_;
            _loc2_++;
         }
      }
      
      private function initData() : void
      {
         var port:ActivtyCopyFPort = null;
         var onComplete:Function = null;
         onComplete = function(param1:HandleDataCompleteEvent):void
         {
            port.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
            _dataProxy = new CopyInfoProxy();
            _dataProxy.setdata(param1._data as Array);
            initView();
         };
         port = new ActivtyCopyFPort();
         port.requestSever(ActivtyCopyFPort.ACTIVTY_COPY_INFO);
         port.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
      }
      
      private function initView() : void
      {
         var _loc2_:CopyInfoSprite = null;
         var _loc4_:CopyInfoVo = null;
         var _loc1_:Vector.<CopyInfoVo> = this._dataProxy.getAllCopyInfoVos();
         var _loc3_:int = 0;
         for each(_loc4_ in _loc1_)
         {
            if(_loc4_.status != 1)
            {
               _loc2_ = new CopyInfoSprite(_loc4_,this.toActivtyCopy);
               this._window["_node"].addChild(_loc2_);
               _loc2_.x = (_loc2_.width + 5) * _loc3_;
               _loc3_++;
            }
         }
         onShow();
      }
      
      private function clearAllSprite() : void
      {
         var _loc1_:CopyInfoSprite = null;
         while(this._window["_node"].numChildren)
         {
            _loc1_ = this._window["_node"].getChildAt(0) as CopyInfoSprite;
            _loc1_.destroy();
            this._window["_node"].removeChild(_loc1_);
         }
      }
      
      private function toActivtyCopy(param1:int) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1 == ActivtyCopyData.LIMIT_COPY)
         {
            new LimitCopyController();
         }
         else if(param1 == ActivtyCopyData.CD_TIME_COPY)
         {
            new CDTimeCopyController();
         }
         this.onClose(null);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function addEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.MOUSE_UP,this.onClose);
      }
      
      private function toLimitCopy(param1:MouseEvent) : void
      {
         new LimitCopyController();
         this.onClose(null);
      }
      
      private function toCdTimerCopy(param1:MouseEvent) : void
      {
         new CDTimeCopyController();
         this.onClose(null);
      }
      
      override public function destroy() : void
      {
         this.clearAllSprite();
         this._closeBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onClose);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.destroy();
         onHide();
      }
   }
}

