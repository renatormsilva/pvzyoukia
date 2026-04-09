package pvz.copy.ui.panels
{
   import core.interfaces.IVo;
   import core.ui.components.PagesButton;
   import core.ui.components.SelectButtonsGroup;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.copy.models.stone.StoneRankingCData;
   import pvz.copy.ui.sprites.StoneRankBar;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import zlib.utils.DomainAccess;
   
   public class StoneRankingPanel extends BaseWindow
   {
      
      private static const MAX:int = 8;
      
      private var _window:MovieClip;
      
      private var _selectBtnGroup:SelectButtonsGroup;
      
      private var m_rankInfo:StoneRankingCData;
      
      private var _allInfoBars:Array;
      
      private var _pageButton:PagesButton;
      
      private var m_myStar:Sprite;
      
      public function StoneRankingPanel()
      {
         super();
         this.showType = PANEL_TYPE_1;
         this.initUI();
         this.addEvent();
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("stone.panel.rank");
         this._window = new _loc1_();
         this.addChild(this._window);
         this._pageButton = new PagesButton(this._window["_pages_btn"],this.showContentByPage);
         this.m_myStar = GetDomainRes.getSprite("stone.ui.mystar");
         this.m_myStar.x = 45;
         this.m_myStar.y = 50;
         this.addChild(this.m_myStar);
         this.hideAllbars();
      }
      
      private function showContentByPage(param1:int = 1) : void
      {
         this.hideAllbars();
         var _loc2_:Array = [];
         var _loc3_:Array = this.m_rankInfo.getRankData();
         _loc2_ = _loc3_.slice((param1 - 1) * MAX,Math.min(param1 * MAX,_loc3_.length));
         this.hideAllbars();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            (this._allInfoBars[_loc4_] as StoneRankBar).updateBar(_loc2_[_loc4_]);
            this._allInfoBars[_loc4_].visible = true;
            _loc4_++;
         }
      }
      
      private function hideAllbars() : void
      {
         var _loc1_:StoneRankBar = null;
         var _loc2_:int = 0;
         FuncKit.clearAllChildrens(this._window["_barpoint"]);
         this._allInfoBars = [];
         while(_loc2_ < MAX)
         {
            _loc1_ = new StoneRankBar();
            this._window["_barpoint"].addChild(_loc1_);
            _loc1_.y = 47 * _loc2_;
            this._allInfoBars.push(_loc1_);
            _loc1_.visible = false;
            _loc2_++;
         }
      }
      
      public function addChapterNameAndStars() : void
      {
         FuncKit.clearAllChildrens(this._window["chapter_name"]);
         FuncKit.clearAllChildrens(this.m_myStar["num"]);
         var _loc1_:DisplayObject = GetDomainRes.getDisplayObject("copy.stone.chapter_name_s_" + this.m_rankInfo.getChapterId());
         this._window["chapter_name"].addChild(_loc1_);
         _loc1_.x = -_loc1_.width / 2;
         var _loc2_:String = this.m_rankInfo.getHasStar().toString();
         var _loc3_:DisplayObject = FuncKit.getNumEffect(("x" + _loc2_).toString(),"Exp",-2);
         this.m_myStar["num"].addChild(_loc3_);
         _loc3_.x = -_loc3_.width / 2;
      }
      
      public function updata(param1:IVo) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.m_rankInfo = param1 as StoneRankingCData;
         this.addChapterNameAndStars();
         this.setMaxPage();
         this.showContentByPage();
         this.onShow();
      }
      
      public function showUserServerSection(param1:String) : void
      {
         this._window["section_txt"].text = param1;
      }
      
      private function addEvent() : void
      {
         this._window["close_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onClose);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.onHide();
      }
      
      private function setMaxPage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = this.m_rankInfo.getRankData();
         var _loc3_:int = int(_loc2_.length);
         _loc1_ = _loc3_ % MAX > 0 ? int(Math.floor(_loc3_ / MAX) + 1) : int(Math.floor(_loc3_ / MAX));
         _loc1_ = _loc1_ > 0 ? _loc1_ : 1;
         this._pageButton.initMaxPage(_loc1_);
      }
      
      public function destory() : void
      {
         var _loc1_:StoneRankBar = null;
         this._window["close_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClose);
         for each(_loc1_ in this._allInfoBars)
         {
            _loc1_.destory();
         }
         this._pageButton = null;
         this._window = null;
         this.m_rankInfo = null;
      }
   }
}

