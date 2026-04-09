package pvz.serverbattle.ranking
{
   import core.ui.components.PagesButton;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.serverbattle.fport.RankingFPort;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import zlib.utils.DomainAccess;
   
   public class GuessRankWindow extends BaseWindow
   {
      
      private static const MAX:int = 8;
      
      private var _allInfoBars:Array;
      
      private var _allUserInfo:Array;
      
      private var _window:MovieClip;
      
      private var _pageButton:PagesButton;
      
      private var _port:RankingFPort;
      
      public function GuessRankWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("severbattle_boxRank_window");
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
         this._pageButton = new PagesButton(this._window["_pages_btn"],this.showContentByPage);
         this.hideAllbars();
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
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffectBig(this._window);
      }
      
      private function initData() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._port = new RankingFPort(this);
         this._port.requestSever(RankingFPort.GUESS_RANK);
      }
      
      private function showContentByPage(param1:int = 1) : void
      {
         this.hideAllbars();
         var _loc2_:Array = [];
         _loc2_ = this._allUserInfo.slice((param1 - 1) * MAX,Math.min(param1 * MAX,this._allUserInfo.length));
         this.hideAllbars();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            (this._allInfoBars[_loc3_] as RankBar).updateBar(_loc2_[_loc3_]);
            this._allInfoBars[_loc3_].visible = true;
            _loc3_++;
         }
      }
      
      public function getDataAndShowRank(param1:Array) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.show();
         this._allUserInfo = param1;
         this.setMaxPage(this._allUserInfo);
         this.showContentByPage();
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
      
      private function setMaxPage(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.length % MAX > 0 ? int(Math.floor(param1.length / MAX) + 1) : int(Math.floor(param1.length / MAX));
         _loc2_ = _loc2_ > 0 ? _loc2_ : 1;
         this._pageButton.initMaxPage(_loc2_);
      }
      
      public function updateMyBox(param1:String) : void
      {
         FuncKit.clearAllChildrens(this._window["_mybox"]);
         var _loc2_:DisplayObject = StringMovieClip.getStringImage(param1,"Red");
         this._window["_mybox"].addChild(_loc2_);
         _loc2_.x = -_loc2_.width / 2;
      }
      
      private function destory() : void
      {
         var _loc1_:RankBar = null;
         this._pageButton = null;
         for each(_loc1_ in this._allInfoBars)
         {
            _loc1_.destory();
         }
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

