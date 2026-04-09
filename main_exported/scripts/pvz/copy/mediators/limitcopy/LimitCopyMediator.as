package pvz.copy.mediators.limitcopy
{
   import com.greensock.TweenLite;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.ui.panel.BaseMediator;
   import entity.Tool;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.copy.models.limit.ActivtyCopyData;
   import pvz.copy.models.limit.LimitChapterProxy;
   import pvz.copy.models.limit.LimitChapterVo;
   import pvz.copy.models.limit.LimitCheckPointProxy;
   import pvz.copy.models.limit.LimitCheckPointVo;
   import pvz.copy.net.ActivtyCopyFPort;
   import pvz.copy.ui.scene.ActvityCopySence;
   import pvz.copy.ui.sprites.LimitChapterSprite;
   import pvz.copy.ui.sprites.LimitCheckPointSprite;
   import pvz.copy.ui.tips.ActivtyCopyHelpTips;
   import pvz.copy.ui.windows.AddLimitCopyTimesWindow;
   import pvz.copy.ui.windows.AddTimesByUseingTool;
   import pvz.hunting.window.BattleReadyWindow;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import utils.FuncKit;
   
   public class LimitCopyMediator extends BaseMediator
   {
      
      private const CHAPTER:int = 0;
      
      private const CHECKPOINT:int = 1;
      
      private const MAX:int = 5;
      
      private const C_MAX:int = 6;
      
      private var _currentchapterid:int = 0;
      
      private var _currentPanelType:int = 0;
      
      private var _currentPage:int = 1;
      
      private var _view:ActvityCopySence;
      
      private var _chpaterProxy:LimitChapterProxy;
      
      private var _currentCheckPointProxy:LimitCheckPointProxy;
      
      private var _helpTips:ActivtyCopyHelpTips;
      
      public function LimitCopyMediator()
      {
         super();
         this._view = getView(ActvityCopySence) as ActvityCopySence;
         this._view.backBtn.visible = false;
         this.addEvent();
         ActivtyCopyData.setCopyId(ActivtyCopyData.LIMIT_COPY);
         this.initData();
      }
      
      private function initData() : void
      {
         var fport:ActivtyCopyFPort = null;
         var onComplete:Function = null;
         onComplete = function(param1:HandleDataCompleteEvent):void
         {
            if(_chpaterProxy == null)
            {
               _chpaterProxy = new LimitChapterProxy();
            }
            _chpaterProxy.setChapterData(param1._data);
            fport.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
            showChapters();
            _view.updateActivtyTime(_chpaterProxy.getStartTime(),_chpaterProxy.getEndTime());
            _view.updateChallageTimes(_chpaterProxy.getTotalChallageTimes());
         };
         fport = new ActivtyCopyFPort();
         fport.requestSever(ActivtyCopyFPort.LIMIT_CHPATER_INFO);
         fport.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
         this._view.onShow();
      }
      
      private function toBattle(param1:LimitCheckPointVo) : void
      {
         var orgs:Array = null;
         var end:Function = null;
         var cpv:LimitCheckPointVo = param1;
         end = function():void
         {
            var _loc1_:BattleReadyWindow = new BattleReadyWindow(BattleReadyWindow.LIMIT_BATTLE);
            _loc1_.show(cpv.getId(),orgs,update,null,null,0);
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._chpaterProxy.getTotalChallageTimes() <= 0)
         {
            this.onAddTimes(null);
            return;
         }
         orgs = cpv.getEmamys();
         DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_BATTLE_READY_WINDOW,end);
      }
      
      private function update() : void
      {
         this.toAllCheckPoint(this._currentchapterid);
         this._chpaterProxy.setTotalChallageTimes(this._chpaterProxy.getTotalChallageTimes() - 1);
         this._view.updateChallageTimes(this._chpaterProxy.getTotalChallageTimes());
      }
      
      private function showChapterPanel() : void
      {
         this._currentPanelType = this.CHAPTER;
         this._view.backBtn.visible = false;
         this.hideChpater(true);
      }
      
      private function showChapters() : void
      {
         var _loc2_:LimitChapterSprite = null;
         var _loc1_:Vector.<LimitChapterVo> = this._chpaterProxy.getAllChpaters();
         if(_loc1_.length <= 0)
         {
            return;
         }
         var _loc3_:Vector.<LimitChapterVo> = _loc1_.slice((this._currentPage - 1) * this.MAX,Math.min(this._currentPage * this.MAX,_loc1_.length));
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new LimitChapterSprite(_loc1_[_loc5_],this.toAllCheckPoint);
            this._view.chpaterNode.addChild(_loc2_);
            _loc2_.x = 50 + 130 * _loc5_;
            _loc2_.y = 110;
            _loc5_++;
         }
      }
      
      private function toAllCheckPoint(param1:int) : void
      {
         var fport:ActivtyCopyFPort = null;
         var onHandlerDataComplete:Function = null;
         var chapterid:int = param1;
         onHandlerDataComplete = function(param1:HandleDataCompleteEvent):void
         {
            fport.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onHandlerDataComplete);
            if(_currentCheckPointProxy == null)
            {
               _currentCheckPointProxy = new LimitCheckPointProxy();
            }
            _currentCheckPointProxy.setData(param1._data);
            toShowCheckpoint();
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._currentchapterid = chapterid;
         fport = new ActivtyCopyFPort();
         fport.requestSever(ActivtyCopyFPort.LIMIT_CHECKPOINT_INFO,chapterid);
         fport.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onHandlerDataComplete);
      }
      
      private function toShowCheckpoint() : void
      {
         var _loc2_:LimitCheckPointSprite = null;
         var _loc6_:int = 0;
         this.hideChpater(false);
         this.hideCheckPoint(true);
         this.clearCheckPoint();
         var _loc1_:Vector.<LimitCheckPointVo> = this._currentCheckPointProxy.getAllCheckPoints();
         var _loc3_:int = int(_loc1_.length);
         if(_loc3_ <= 0)
         {
            return;
         }
         var _loc4_:int = _loc3_ % this.C_MAX > 0 ? int(_loc3_ / this.C_MAX + 1) : int(_loc3_ / this.C_MAX);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = 0;
            while(_loc6_ < this.C_MAX)
            {
               if(_loc5_ * this.C_MAX + _loc6_ >= _loc3_)
               {
                  break;
               }
               _loc2_ = new LimitCheckPointSprite(_loc1_[_loc5_ * this.C_MAX + _loc6_],this.toBattle);
               this._view.checkPointNode.addChild(_loc2_);
               _loc2_.x = 55 + 110 * _loc6_;
               _loc2_.y = 150 + _loc5_ * 150;
               if(this._currentPanelType == this.CHAPTER)
               {
                  _loc2_.scaleX = 2;
                  _loc2_.scaleY = 2;
                  TweenLite.to(_loc2_,0.5,{
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               _loc6_++;
            }
            _loc5_++;
         }
         this._currentPanelType = this.CHECKPOINT;
      }
      
      private function hideChpater(param1:Boolean) : void
      {
         this._view.chpaterNode.visible = param1;
         if(param1)
         {
            this._currentPanelType = this.CHAPTER;
            this._view.chpaterNode.scaleX = 0.5;
            this._view.chpaterNode.scaleY = 0.5;
            TweenLite.to(this._view.chpaterNode,0.5,{
               "scaleX":1,
               "scaleY":1
            });
         }
      }
      
      private function hideCheckPoint(param1:Boolean) : void
      {
         this._view.backBtn.visible = param1;
         this._view.checkPointNode.visible = param1;
      }
      
      private function clearCheckPoint() : void
      {
         var _loc1_:LimitCheckPointSprite = null;
         while(this._view.checkPointNode.numChildren)
         {
            _loc1_ = this._view.checkPointNode.getChildAt(0) as LimitCheckPointSprite;
            _loc1_.destroy();
            this._view.checkPointNode.removeChild(_loc1_);
         }
      }
      
      private function clearAllChapters() : void
      {
         var _loc1_:LimitChapterSprite = null;
         while(this._view.chpaterNode.numChildren)
         {
            _loc1_ = this._view.chpaterNode.getChildAt(0) as LimitChapterSprite;
            _loc1_.destroy();
            this._view.chpaterNode.removeChild(_loc1_);
         }
      }
      
      private function addEvent() : void
      {
         this._view.closeBtn.addEventListener(MouseEvent.MOUSE_UP,this.closeWindow);
         this._view.backBtn.addEventListener(MouseEvent.CLICK,this.backToChpater);
         this._view.addTimesButton.addEventListener(MouseEvent.MOUSE_UP,this.onAddTimes);
         this._view.buyTimesButton.addEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
         this._view.helpButton.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._view.helpButton.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this._helpTips)
         {
            this._helpTips.hideTips();
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._helpTips == null)
         {
            this._helpTips = new ActivtyCopyHelpTips();
         }
         this._helpTips.showTips(this._chpaterProxy.getHelpText());
      }
      
      private function onBuyTimes(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._chpaterProxy.getMaxAddtimes() == 0)
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy016"));
            return;
         }
         new AddLimitCopyTimesWindow(this.buy,this._chpaterProxy.getMaxAddtimes(),null,this._chpaterProxy.getBuyChallagePrice());
      }
      
      private function buy(param1:int) : void
      {
         var fport:ActivtyCopyFPort = null;
         var onCompelte:Function = null;
         var times:int = param1;
         onCompelte = function(param1:HandleDataCompleteEvent):void
         {
            fport.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onCompelte);
            _chpaterProxy.setTotalChallageTimes(_chpaterProxy.getTotalChallageTimes() + int(param1._data));
            _chpaterProxy.setMaxAddtimes(_chpaterProxy.getMaxAddtimes() - int(param1._data));
            _view.updateChallageTimes(_chpaterProxy.getTotalChallageTimes());
            PlantsVsZombies.changeMoneyOrExp(-int(param1._data) * _chpaterProxy.getBuyChallagePrice(),2,true,false);
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy017",int(param1._data)));
         };
         fport = new ActivtyCopyFPort();
         fport.requestSever(ActivtyCopyFPort.BUY_TIMES,ActivtyCopyData.getCopyId(),times);
         fport.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onCompelte);
      }
      
      private function onAddTimes(param1:MouseEvent) : void
      {
         var toolnum:int;
         var tool:Tool = null;
         var addTimes:Function = null;
         var event:MouseEvent = param1;
         addTimes = function(param1:int):void
         {
            var fport:ActivtyCopyFPort = null;
            var onComplete:Function = null;
            var times:int = param1;
            onComplete = function(param1:HandleDataCompleteEvent):void
            {
               fport.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
               var _loc2_:int = int(param1._data.effect);
               PlantsVsZombies.playerManager.getPlayer().updateTool(tool.getOrderId(),tool.getNum() - _loc2_);
               _chpaterProxy.setTotalChallageTimes(_chpaterProxy.getTotalChallageTimes() + _loc2_);
               _view.updateChallageTimes(_chpaterProxy.getTotalChallageTimes());
               FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy019",_loc2_));
            };
            fport = new ActivtyCopyFPort();
            fport.requestSever(ActivtyCopyFPort.ADD_TIIME_USE_TOOL,tool.getOrderId(),times);
            fport.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         tool = PlantsVsZombies.playerManager.getPlayer().getTool(1000);
         toolnum = 0;
         if(!tool)
         {
            tool = new Tool(1000);
         }
         toolnum = tool.getNum();
         if(toolnum <= 0)
         {
            new AddLimitCopyTimesWindow(this.buy,this._chpaterProxy.getMaxAddtimes() > 1 ? this._chpaterProxy.getMaxAddtimes() : 1,null,this._chpaterProxy.getBuyChallagePrice());
         }
         else
         {
            new AddTimesByUseingTool(addTimes,toolnum,tool);
         }
      }
      
      private function backToChpater(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.hideChpater(true);
         this.hideCheckPoint(false);
      }
      
      private function closeWindow(param1:MouseEvent) : void
      {
         var fport:ActivtyCopyFPort = null;
         var onComplete:Function = null;
         var event:MouseEvent = param1;
         onComplete = function(param1:HandleDataCompleteEvent):void
         {
            fport.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
            PlantsVsZombies.playerManager.getPlayer().setCopyActiveState(int(param1._data));
            PlantsVsZombies.firstpage.setActvityTipVisible();
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         fport = new ActivtyCopyFPort();
         fport.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
         fport.requestSever(ActivtyCopyFPort.GET_ACTIVTY_STATE);
         this._view.closeBtn.removeEventListener(MouseEvent.MOUSE_UP,this.closeWindow);
         this._view.backBtn.removeEventListener(MouseEvent.CLICK,this.backToChpater);
         this._view.addTimesButton.removeEventListener(MouseEvent.MOUSE_UP,this.onAddTimes);
         this._view.buyTimesButton.removeEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
         this.destory();
         this._view.onHide();
      }
      
      private function destory() : void
      {
         if(this._chpaterProxy)
         {
            this._chpaterProxy.destroy();
         }
         if(this._currentCheckPointProxy)
         {
            this._currentCheckPointProxy.destroy();
         }
         this.clearAllChapters();
         this.clearCheckPoint();
      }
   }
}

