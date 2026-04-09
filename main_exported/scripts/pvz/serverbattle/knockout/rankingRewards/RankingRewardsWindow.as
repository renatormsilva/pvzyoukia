package pvz.serverbattle.knockout.rankingRewards
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.invitePrizes.PrizeWindow;
   import pvz.invitePrizes.labels.PrizeLabel;
   import pvz.serverbattle.entity.BoxRewarsInfo;
   import pvz.serverbattle.fport.RankingRewarsFPort;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class RankingRewardsWindow extends BaseWindow implements IDestroy
   {
      
      private var _window:MovieClip = null;
      
      private var _fport:RankingRewarsFPort;
      
      private var _myRank:int;
      
      private var _allboxs:Array;
      
      private var _phase:int;
      
      public function RankingRewardsWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("RankingRewardsWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
         this.addEvent();
         this.initUI();
         this.initdata();
      }
      
      private function initUI() : void
      {
         var _loc1_:RewardsBox = null;
         this._allboxs = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = new RewardsBox(this._window["_box_group"]["_box" + _loc2_],this.toCheckPrizesByBoxName,this.setAllBoxdefault);
            this._allboxs.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         this._window["close_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onClick);
         this._window["recharge"].addEventListener(MouseEvent.MOUSE_UP,this.onClick);
         this._window["getPrizeBtn"].addEventListener(MouseEvent.MOUSE_UP,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "close_btn":
               this.hide();
               break;
            case "recharge":
               JSManager.toRecharge();
               break;
            case "getPrizeBtn":
               this.toGetRewards();
         }
      }
      
      private function toCheckPrizesByBoxName(param1:Array) : void
      {
         var _loc2_:PrizeLabel = null;
         var _loc3_:int = 0;
         FuncKit.clearAllChildrens(this._window["_prize_node"]);
         while(_loc3_ < param1.length)
         {
            _loc2_ = new PrizeLabel(param1[_loc3_] as Tool);
            this._window["_prize_node"].addChild(_loc2_);
            _loc2_.x = _loc3_ * (_loc2_.x + 140) + 20;
            _loc3_++;
         }
      }
      
      private function toGetRewards() : void
      {
         if((this._window["getPrizeBtn"] as MovieClip).currentFrame == 2)
         {
            this._fport.requestSever(RankingRewarsFPort.GET_PRIZE);
         }
      }
      
      public function showPrizes(param1:int) : void
      {
         var back:Function = null;
         var index:int = param1;
         back = function():void
         {
            FuncKit.clearAllChildrens(_window["_prize_node"]);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle013"));
            updateGetPrizeButtonStaus();
         };
         var toolsWindow:PrizeWindow = new PrizeWindow(PlantsVsZombies._node as MovieClip);
         var tools:Array = this.getBoxRewarsInfoByRank(index);
         toolsWindow.show(tools,back);
      }
      
      private function getBoxRewarsInfoByRank(param1:int) : Array
      {
         var _loc2_:RewardsBox = null;
         for each(_loc2_ in this._allboxs)
         {
            if(_loc2_.getBoxData().getRank() == param1)
            {
               _loc2_.setIsGotten();
               return _loc2_.getBoxData().getPrizeInfo();
            }
         }
         return null;
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function initdata() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport = new RankingRewarsFPort(this);
         this._fport.requestSever(RankingRewarsFPort.INIT);
      }
      
      public function showMyRankAndEtime(param1:int, param2:String, param3:int) : void
      {
         this._myRank = param1;
         if(param1 == 0)
         {
            this._window["_myrank"].text = LangManager.getInstance().getLanguage("severBattle014");
         }
         else if(param1 == 1)
         {
            this._window["_myrank"].text = LangManager.getInstance().getLanguage("severBattle017");
         }
         else if(param1 == 2)
         {
            this._window["_myrank"].text = LangManager.getInstance().getLanguage("severBattle018");
         }
         else
         {
            this._window["_myrank"].text = param1 + LangManager.getInstance().getLanguage("severBattle015");
         }
         this._window["_etime"].text = param2;
         this._phase = param3;
      }
      
      public function getBoxInfos(param1:Array) : void
      {
         var _loc2_:int = 0;
         PlantsVsZombies.showDataLoading(false);
         while(_loc2_ < param1.length)
         {
            (this._allboxs[_loc2_] as RewardsBox).setData(param1[_loc2_] as BoxRewarsInfo);
            _loc2_++;
         }
         PlantsVsZombies.showDataLoading(false);
         this.updateBoxsState();
         this.updateGetPrizeButtonStaus();
         this.show();
      }
      
      private function updateBoxsState() : void
      {
         var _loc1_:RewardsBox = null;
         for each(_loc1_ in this._allboxs)
         {
            _loc1_.updateBoxStats(this._myRank,this._phase);
         }
      }
      
      private function setAllBoxdefault() : void
      {
         var _loc1_:RewardsBox = null;
         for each(_loc1_ in this._allboxs)
         {
            if(!_loc1_.getIsGotten())
            {
               _loc1_.setDefault();
            }
         }
      }
      
      private function updateGetPrizeButtonStaus() : void
      {
         var _loc1_:RewardsBox = null;
         var _loc2_:RewardsBox = null;
         (this._window["getPrizeBtn"] as MovieClip).gotoAndStop(1);
         for each(_loc1_ in this._allboxs)
         {
            if(_loc1_.getIsCanbeGotten())
            {
               (this._window["getPrizeBtn"] as MovieClip).gotoAndStop(2);
            }
         }
         for each(_loc2_ in this._allboxs)
         {
            if(_loc2_.getIsCanbeGotten())
            {
               _loc2_.setJiantouVisibleisTrue();
               this.toCheckPrizesByBoxName(_loc2_.getBoxData().getPrizeInfo());
               break;
            }
         }
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function hide() : void
      {
         onHiddenEffect(this._window,this.destroy);
      }
      
      override public function destroy() : void
      {
         var _loc1_:RewardsBox = null;
         this._window["close_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClick);
         this._window["recharge"].removeEventListener(MouseEvent.MOUSE_UP,this.onClick);
         this._window["getPrizeBtn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClick);
         for each(_loc1_ in this._allboxs)
         {
            _loc1_.destory();
         }
         this._fport = null;
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

