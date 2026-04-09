package pvz.world
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.invitePrizes.PrizeWindow;
   import pvz.world.fport.InsideWorldRewardFPort;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldRewardWindow extends BaseWindow implements IDestroy
   {
      
      private var _fport:InsideWorldRewardFPort = null;
      
      private var _panel:InsideWorldRewardPanel = null;
      
      private var _window:MovieClip = null;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _mapId:int = 0;
      
      private var _compRewards:Array = null;
      
      private var _medalRewards:Array = null;
      
      private var _comp:int = 0;
      
      private var _medal:int = 0;
      
      private var _allcomp:int = 0;
      
      private var _allmedal:int = 0;
      
      private var _type:String = "";
      
      private var _backFun:Function = null;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function InsideWorldRewardWindow(param1:DisplayObjectContainer, param2:int, param3:Function)
      {
         super();
         this._root = param1;
         this._mapId = param2;
         this._backFun = param3;
         this.initUI();
         this._fport = new InsideWorldRewardFPort(this);
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.rewardWindow");
         this._window = new _loc1_();
         this._window.x = PlantsVsZombies.WIDTH - this._window.width / 2 - 10;
         this._window.y = PlantsVsZombies.HEIGHT - this._window.height / 2 - 30;
         this.initEvent();
         this.setSelectedVisibleFalse();
         this._window["_bt_selected1"].visible = true;
         this.setMapName(this._mapId);
         this._window["_mc_panel"]["_mc_progress"]["_mc_color"].scaleX = 0;
         PlantsVsZombies.setToFirstPageButtonVisible(false);
         showBG(this._root);
         this._root.addChild(this._window);
         onShowEffect(this._window,this.initDate);
      }
      
      private function initEvent() : void
      {
         this._window["_bt1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._window["_bt1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setMapName(param1:int) : void
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
               _loc2_ = LangManager.getInstance().getLanguage("world019");
               break;
            case 2:
               _loc2_ = LangManager.getInstance().getLanguage("world020");
               break;
            case 3:
               _loc2_ = LangManager.getInstance().getLanguage("world021");
               break;
            case 4:
               _loc2_ = LangManager.getInstance().getLanguage("world022");
               break;
            case 5:
               _loc2_ = LangManager.getInstance().getLanguage("world033");
         }
         this._window["_txt_mapname"].text = _loc2_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.setSelectedVisibleFalse();
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt1")
         {
            this._window["_bt_selected1"].visible = true;
            this._type = InsideWorldReward.COMPLETE;
            this.showPanel();
         }
         else if(param1.currentTarget.name == "_bt2")
         {
            this._window["_bt_selected2"].visible = true;
            this._type = InsideWorldReward.MEDAL;
            this.showPanel();
         }
         else if(param1.currentTarget.name == "_bt_close")
         {
            this.clear();
            onHiddenEffect(this._window,this.destroy);
         }
      }
      
      private function setSelectedVisibleFalse() : void
      {
         this._window["_bt_selected1"].visible = false;
         this._window["_bt_selected2"].visible = false;
      }
      
      private function initDate() : void
      {
         this._fport.initRewardDate(this._mapId);
      }
      
      public function portInitDate(param1:Array, param2:Array, param3:int, param4:int, param5:int, param6:int) : void
      {
         this._compRewards = param1;
         this._medalRewards = param2;
         this._comp = param3;
         this._medal = param4;
         this._allcomp = param5;
         this._allmedal = param6;
         this._type = InsideWorldReward.COMPLETE;
         this.showPanel();
      }
      
      private function showPanel() : void
      {
         if(this._panel == null)
         {
            this._panel = new InsideWorldRewardPanel(this._window["_mc_panel"]);
            this._panel.addEventListener(InsideWorldRewardEvent.GET_REWARDS,this.onGetPrizes);
         }
         if(this._type == InsideWorldReward.COMPLETE)
         {
            this._panel.show(this._type,this._compRewards,this._comp,this._allcomp,this.getMax(this._compRewards));
         }
         else if(this._type == InsideWorldReward.MEDAL)
         {
            this._panel.show(this._type,this._medalRewards,this._medal,this._allmedal,this.getMax(this._medalRewards));
         }
      }
      
      private function getMax(param1:Array) : int
      {
         if(param1 == null || param1.length < 1)
         {
            return 0;
         }
         return (param1[param1.length - 1] as InsideWorldReward).getValue();
      }
      
      private function onGetPrizes(param1:InsideWorldRewardEvent) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.getRewards(this._type,this._mapId);
      }
      
      public function portGetPrizes(param1:Array, param2:int, param3:String) : void
      {
         var _loc5_:Tool = null;
         var _loc6_:Tool = null;
         var _loc7_:int = 0;
         PlantsVsZombies.showDataLoading(false);
         if(param3 == InsideWorldReward.COMPLETE)
         {
            this._comp = param2;
         }
         else if(param3 == InsideWorldReward.MEDAL)
         {
            this._medal = param2;
         }
         this._backFun(this.getOtherPrizes());
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = this.playerManager.getPlayer().getTool(_loc5_.getOrderId());
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_.getNum();
            }
            else
            {
               _loc7_ = 0;
            }
            this.playerManager.getPlayer().updateTool(_loc5_.getOrderId(),_loc7_ + _loc5_.getNum());
            _loc4_++;
         }
         this.showTools(param1);
      }
      
      private function getOtherPrizes() : Boolean
      {
         if(this._allcomp >= this._comp && this._comp != 0)
         {
            return true;
         }
         if(this._allmedal >= this._medal && this._medal != 0)
         {
            return true;
         }
         return false;
      }
      
      private function showTools(param1:Array) : void
      {
         var _loc2_:PrizeWindow = new PrizeWindow(this._root);
         _loc2_.show(param1,this.showPanel);
      }
      
      private function clear() : void
      {
         this.removeEvent();
      }
      
      override public function destroy() : void
      {
         this.clear();
         this._panel.destroy();
         this._root.removeChild(this._window);
      }
   }
}

