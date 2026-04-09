package pvz.serverbattle.ranking
{
   import core.ui.components.PagesButton;
   import core.ui.components.SelectButtonsGroup;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.serverbattle.fport.RankingFPort;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class ScoreRankWindow extends BaseWindow
   {
      
      private static const TODAY:int = 1;
      
      private static const YESTERDAY:int = 0;
      
      private static const MAX:int = 8;
      
      private var _window:MovieClip;
      
      private var _selectBtnGroup:SelectButtonsGroup;
      
      private var _fport:RankingFPort;
      
      private var _todayRankInfo:Array;
      
      private var _yesterdayRankInfo:Array;
      
      private var _allInfoBars:Array;
      
      private var _pageButton:PagesButton;
      
      private var _selectType:int;
      
      public function ScoreRankWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("severbattle_scoreRank_window");
         this._window = new _loc1_();
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._window.visible = false;
         this.initUI();
         this.addEvent();
         this.initData();
      }
      
      private function initUI() : void
      {
         TextFilter.MiaoBian(this._window["section_txt"],0);
         this._pageButton = new PagesButton(this._window["_pages_btn"],this.showContentByPage);
         this._selectBtnGroup = new SelectButtonsGroup(this._window["_seletBtns"],this.checkItem);
         this._selectBtnGroup.setButtonIsClickByBtnName("_today_btn");
         this.hideAllbars();
      }
      
      private function showContentByPage(param1:int = 1) : void
      {
         this.hideAllbars();
         var _loc2_:Array = [];
         if(this._selectType == TODAY)
         {
            _loc2_ = this._todayRankInfo.slice((param1 - 1) * MAX,Math.min(param1 * MAX,this._todayRankInfo.length));
         }
         else if(this._selectType == YESTERDAY)
         {
            _loc2_ = this._yesterdayRankInfo.slice((param1 - 1) * MAX,Math.min(param1 * MAX,this._yesterdayRankInfo.length));
         }
         this.hideAllbars();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            (this._allInfoBars[_loc3_] as RankBar).updateBar(_loc2_[_loc3_]);
            this._allInfoBars[_loc3_].visible = true;
            _loc3_++;
         }
      }
      
      private function hideAllbars() : void
      {
         var _loc1_:RankBar = null;
         var _loc2_:int = 0;
         FuncKit.clearAllChildrens(this._window["_barpoint"]);
         this._allInfoBars = [];
         while(_loc2_ < MAX)
         {
            _loc1_ = new RankBar();
            this._window["_barpoint"].addChild(_loc1_);
            _loc1_.y = (_loc1_.height + 2) * _loc2_;
            this._allInfoBars.push(_loc1_);
            _loc1_.visible = false;
            _loc2_++;
         }
      }
      
      private function initData() : void
      {
         this._fport = new RankingFPort(this);
         this.checkItem("_today_btn");
      }
      
      private function checkItem(param1:String) : void
      {
         switch(param1)
         {
            case "_today_btn":
               this._selectType = TODAY;
               if(this._todayRankInfo == null)
               {
                  PlantsVsZombies.showDataLoading(true);
                  this._fport.requestSever(RankingFPort.SCORE_RANK_TODAY);
               }
               else
               {
                  this.setMaxPage(this._todayRankInfo);
                  this.showContentByPage();
               }
               break;
            case "_yesterday_btn":
               this._selectType = YESTERDAY;
               if(this._yesterdayRankInfo == null)
               {
                  PlantsVsZombies.showDataLoading(true);
                  this._fport.requestSever(RankingFPort.SCORE_RANK_YESTERDAY);
               }
               else
               {
                  this.setMaxPage(this._yesterdayRankInfo);
                  this.showContentByPage();
               }
         }
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffectBig(this._window);
      }
      
      public function updateMyRank(param1:String) : void
      {
         FuncKit.clearAllChildrens(this._window["_myrank"]);
         var _loc2_:DisplayObject = StringMovieClip.getStringImage(param1,"Red");
         this._window["_myrank"].addChild(_loc2_);
         _loc2_.x = -_loc2_.width / 2;
      }
      
      public function updateTodayRank(param1:Array) : void
      {
         this._selectType = TODAY;
         PlantsVsZombies.showDataLoading(false);
         this._todayRankInfo = param1;
         this.setMaxPage(this._todayRankInfo);
         this.showContentByPage();
         this.show();
      }
      
      public function updateYesterdayRank(param1:Array) : void
      {
         this._selectType = YESTERDAY;
         PlantsVsZombies.showDataLoading(false);
         this._yesterdayRankInfo = param1;
         this.setMaxPage(this._yesterdayRankInfo);
         this.showContentByPage();
      }
      
      public function showUserServerSection(param1:String) : void
      {
         this._window["section_txt"].text = param1;
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window["close_btn"].removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffectBig(_window,destory);
         };
         this._window["close_btn"].addEventListener(MouseEvent.MOUSE_UP,onClose);
      }
      
      private function setMaxPage(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.length % MAX > 0 ? int(Math.floor(param1.length / MAX) + 1) : int(Math.floor(param1.length / MAX));
         _loc2_ = _loc2_ > 0 ? _loc2_ : 1;
         this._pageButton.initMaxPage(_loc2_);
      }
      
      private function destory() : void
      {
         var _loc1_:RankBar = null;
         this._selectBtnGroup.destroy();
         this._selectBtnGroup = null;
         this._pageButton = null;
         for each(_loc1_ in this._allInfoBars)
         {
            _loc1_.destory();
         }
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

