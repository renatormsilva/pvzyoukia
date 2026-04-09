package pvz.copy.ui.windows
{
   import core.managers.GameManager;
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.copy.events.StoneRewardEvent;
   import pvz.copy.models.stone.StoneRewardCData;
   import pvz.copy.ui.panels.StoneRewardPanel;
   import pvz.invitePrizes.PrizeWindow;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class StoneRewardWindow extends BaseWindow implements IDestroy
   {
      
      private var _panel:StoneRewardPanel = null;
      
      private var _window:MovieClip = null;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _backFun:Function = null;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var m_data:StoneRewardCData;
      
      public var onGetPrizeCall:Function = null;
      
      public var onUpdataRewardCall:Function = null;
      
      public function StoneRewardWindow()
      {
         super();
         this.showType = PANEL_TYPE_2;
         this.initUI();
         this.initEvent();
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("copy.stone.rewardWindow");
         this._window = new _loc1_();
         this._window.x = GameManager.m_gameWidth - this._window.width / 2 - 10;
         this._window.y = GameManager.m_gameHeight - this._window.height / 2 - 30;
         this._window["_mc_panel"]["_mc_progress"]["_mc_color"].scaleX = 0;
         this.addChild(this._window);
      }
      
      private function initEvent() : void
      {
         this._window["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._window["_bt_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setMapName() : void
      {
         FuncKit.clearAllChildrens(this._window["chapter_name"]);
         var _loc1_:DisplayObject = GetDomainRes.getDisplayObject("copy.stone.chapter_name_s_" + this.m_data.getChapterId());
         this._window["chapter_name"].addChild(_loc1_);
         _loc1_.x = -_loc1_.width / 2;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.onHide();
      }
      
      public function updata(param1:StoneRewardCData) : void
      {
         this.m_data = param1 as StoneRewardCData;
         this.showPanel();
      }
      
      private function showPanel() : void
      {
         if(this._panel == null)
         {
            this._panel = new StoneRewardPanel(this._window["_mc_panel"]);
            this._panel.addEventListener(StoneRewardEvent.GET_REWARDS,this.onGetPrizes);
         }
         this.setMapName();
         this._panel.show(this.m_data);
         if(!this.parent)
         {
            this.onShow();
         }
      }
      
      private function onGetPrizes(param1:StoneRewardEvent) : void
      {
         this.onGetPrizeCall();
      }
      
      public function portGetPrizes(param1:Array) : void
      {
         var _loc3_:Tool = null;
         var _loc4_:Tool = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = this.playerManager.getPlayer().getTool(_loc3_.getOrderId());
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getNum();
            }
            else
            {
               _loc5_ = 0;
            }
            this.playerManager.getPlayer().updateTool(_loc3_.getOrderId(),_loc5_ + _loc3_.getNum());
            _loc2_++;
         }
         this.showTools(param1);
      }
      
      private function showTools(param1:Array) : void
      {
         var _loc2_:PrizeWindow = new PrizeWindow(this);
         _loc2_.show(param1,this.onUpdataRewardCall);
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         this.m_data = null;
         this._window.parent.removeChild(this._window);
         this._panel.destroy();
      }
   }
}

