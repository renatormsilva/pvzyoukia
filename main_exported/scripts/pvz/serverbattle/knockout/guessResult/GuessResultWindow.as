package pvz.serverbattle.knockout.guessResult
{
   import core.ui.components.SelectButton;
   import core.ui.panel.BaseWindow;
   import effect.flip.EffectFlipComponent;
   import effect.flip.EffectFlipGroup;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.serverbattle.entity.Guess;
   import pvz.serverbattle.fport.GuessResultFPort;
   import pvz.serverbattle.ranking.GuessRankWindow;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class GuessResultWindow extends BaseWindow implements IDestroy
   {
      
      public static var updateGuessTimes:Function;
      
      public static var _guesstime:int;
      
      public static var _maxGuessTime:int;
      
      public static const ALL:int = 1;
      
      public static const ALL_GUESSED:int = 2;
      
      private static const MAX:int = 4;
      
      public static var _isCanbeGuess:Boolean = true;
      
      private var _window:MovieClip;
      
      private var _flipCompoent:EffectFlipComponent;
      
      private var _selectButton1:SelectButton;
      
      private var _selectButton2:SelectButton;
      
      private var _fport:GuessResultFPort;
      
      private var _allGuess:Array = [];
      
      private var _allGuessed:Array = [];
      
      private var _nowPage:int = 1;
      
      private var _maxPage:int;
      
      private var _selectType:int;
      
      private var _callback:Function;
      
      private var _hadGuessed:Boolean = false;
      
      public function GuessResultWindow(param1:Function = null, param2:int = 1)
      {
         super();
         this._selectType = param2;
         this._callback = param1;
         var _loc3_:Class = DomainAccess.getClass("guessingPrizeWindow");
         this._window = new _loc3_();
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._window.visible = false;
         this.addEvent();
         this._fport = new GuessResultFPort(this);
         updateGuessTimes = this.updateGuessStaus;
         this.initUI();
         this.initData();
      }
      
      private function initData() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.requestSever(GuessResultFPort.ALL_GUESS);
      }
      
      private function initUI() : void
      {
         var _loc3_:GuessResultNode = null;
         var _loc4_:GuessResultNode = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc5_:* = MAX;
         while(_loc5_ > 0)
         {
            _loc3_ = new GuessResultNode();
            _loc4_ = new GuessResultNode();
            _loc1_.push(_loc3_);
            _loc2_.push(_loc4_);
            _loc5_--;
         }
         this._flipCompoent = new EffectFlipComponent(_loc1_,_loc2_,180,200,800);
         this._window["_pos"].addChild(this._flipCompoent);
         this._selectButton1 = new SelectButton(this._window["_btn1"],this.selectItem);
         this._selectButton2 = new SelectButton(this._window["_btn2"],this.selectItem);
      }
      
      private function selectItem(param1:String) : void
      {
         switch(param1)
         {
            case "_btn1":
               this.toCheckAllGuessResult("click");
               break;
            case "_btn2":
               this.toCheckAllHadGuessedResult("click");
         }
      }
      
      private function toCheckAllGuessResult(param1:String = "default") : void
      {
         if(this._flipCompoent.getIsDoing())
         {
            this._selectButton1.setIsClicked(false);
            this._selectButton2.setIsClicked(true);
            return;
         }
         this._selectType = ALL;
         if(param1 == "default")
         {
            this._selectButton1.setIsClicked(true);
         }
         this._selectButton2.setIsClicked(false);
         var _loc2_:int = int(this._allGuess.length);
         this._maxPage = _loc2_ % MAX > 0 ? int(Math.floor(_loc2_ / MAX) + 1) : int(Math.floor(_loc2_ / MAX));
         this._maxPage = this._maxPage > 0 ? this._maxPage : 1;
         this._nowPage = 1;
         this.showCurrentPageGuess();
      }
      
      private function toCheckAllHadGuessedResult(param1:String = "default") : void
      {
         var _loc2_:Guess = null;
         if(this._flipCompoent.getIsDoing())
         {
            this._selectButton1.setIsClicked(true);
            this._selectButton2.setIsClicked(false);
            return;
         }
         this._selectType = ALL_GUESSED;
         if(this._allGuessed.length > 0)
         {
            this._allGuessed = [];
         }
         for each(_loc2_ in this._allGuess)
         {
            if(_loc2_.getMyGuessId() != 0)
            {
               this._allGuessed.push(_loc2_);
            }
         }
         if(param1 == "default")
         {
            this._selectButton2.setIsClicked(true);
         }
         this._selectButton1.setIsClicked(false);
         var _loc3_:int = int(this._allGuessed.length);
         this._maxPage = _loc3_ % MAX > 0 ? int(Math.floor(_loc3_ / MAX) + 1) : int(Math.floor(_loc3_ / MAX));
         this._maxPage = this._maxPage > 0 ? this._maxPage : 1;
         this._nowPage = 1;
         this.showCurrentPageGuess();
      }
      
      private function addEvent() : void
      {
         var onCloseWindow:Function = null;
         onCloseWindow = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window["_close_btn"].removeEventListener(MouseEvent.MOUSE_UP,onCloseWindow);
            onHiddenEffectBig(_window,destroy);
         };
         this._window["_close_btn"].addEventListener(MouseEvent.MOUSE_UP,onCloseWindow);
         this._window["_toRank"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._window["_pre_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._window["_next_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "_toRank":
               this.toCheckRank();
               break;
            case "_pre_btn":
               this.checkPrePage();
               break;
            case "_next_btn":
               this.checkNextPage();
         }
      }
      
      private function toCheckRank() : void
      {
         new GuessRankWindow();
      }
      
      private function checkNextPage() : void
      {
         if(this._flipCompoent.getIsDoing())
         {
            return;
         }
         if(this._nowPage >= this._maxPage)
         {
            return;
         }
         ++this._nowPage;
         this.showCurrentPageGuess(EffectFlipGroup.NEXT);
      }
      
      private function checkPrePage() : void
      {
         if(this._flipCompoent.getIsDoing())
         {
            return;
         }
         if(this._nowPage <= 1)
         {
            return;
         }
         --this._nowPage;
         this.showCurrentPageGuess(EffectFlipGroup.PRE);
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffectBig(this._window);
      }
      
      private function showCurrentPageGuess(param1:int = 1) : void
      {
         var _loc2_:Array = [];
         if(this._selectType == ALL)
         {
            _loc2_ = this._allGuess.slice((this._nowPage - 1) * MAX,Math.min(this._nowPage * MAX,this._allGuess.length));
         }
         else if(this._selectType == ALL_GUESSED)
         {
            _loc2_ = this._allGuessed.slice((this._nowPage - 1) * MAX,Math.min(this._nowPage * MAX,this._allGuessed.length));
         }
         this.updatePagesTxt();
         this._flipCompoent.show(_loc2_,param1);
      }
      
      public function showGuessInfo(param1:Array) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.show();
         this._allGuess = param1;
         if(this._selectType == ALL)
         {
            this.toCheckAllGuessResult();
         }
         else if(this._selectType == ALL_GUESSED)
         {
            this.toCheckAllHadGuessedResult();
         }
      }
      
      public function updateGuessStaus(param1:String, param2:Boolean) : void
      {
         FuncKit.clearAllChildrens(this._window["_node"]);
         var _loc3_:Array = param1.split("/");
         _guesstime = _loc3_[0];
         _maxGuessTime = _loc3_[1];
         var _loc4_:DisplayObject = StringMovieClip.getStringImage(_loc3_[0],"Exp");
         var _loc5_:DisplayObject = StringMovieClip.getStringImage("c","Exp");
         var _loc6_:DisplayObject = StringMovieClip.getStringImage(_loc3_[1],"Exp");
         this._window["_node"].addChild(_loc4_);
         this._window["_node"].addChild(_loc5_);
         _loc5_.x = this._window["_node"].width;
         this._window["_node"].addChild(_loc6_);
         _loc6_.x = this._window["_node"].width;
         if(_guesstime == _maxGuessTime)
         {
            _isCanbeGuess = false;
            if(!param2)
            {
               this.showCurrentPageGuess(EffectFlipGroup.UPDATE);
            }
         }
         this._hadGuessed = !param2;
      }
      
      private function updatePagesTxt() : void
      {
         this._window["page_txt"].text = this._nowPage + "/" + this._maxPage;
      }
      
      override public function destroy() : void
      {
         if(this._callback != null && this._hadGuessed)
         {
            this._callback();
         }
         this._window["_toRank"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._window["_pre_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._window["_next_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._selectButton1.destory();
         this._selectButton2.destory();
         this._flipCompoent.destory();
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

