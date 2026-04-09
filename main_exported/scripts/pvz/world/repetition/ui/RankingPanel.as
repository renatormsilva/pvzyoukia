package pvz.world.repetition.ui
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.world.repetition.events.StageClickEvent;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.ReBuidBitmap;
   import zmyth.res.IDestroy;
   
   public class RankingPanel extends Sprite implements IDestroy
   {
      
      public static const ATTACK_FIRST_RANKING:int = 1;
      
      public static const COMPLETE_DEGREE_RANKING:int = 2;
      
      public static const HONOR_RANKING:int = 3;
      
      private static const PAGE_NUM:int = 8;
      
      public var firtAttackClickFunc:Function;
      
      public var honorRankClickFunc:Function;
      
      public var completeDegreeClickFunc:Function;
      
      public var closeClickFunc:Function;
      
      private var myAreaing:ReBuidBitmap;
      
      private var firtAttackBackGround:ReBuidBitmap;
      
      private var completeDegreeBackGround:ReBuidBitmap;
      
      private var honorRankingBackGround:ReBuidBitmap;
      
      private var contaner:Sprite;
      
      private var firtAttackBtn:RankingSimpleButton;
      
      private var completeDegreeBtn:RankingSimpleButton;
      
      private var honorRankBtn:RankingSimpleButton;
      
      private var closeBtn:SimpleButton;
      
      private var lastBtn:SimpleButton;
      
      private var nextBtn:SimpleButton;
      
      private var pageTxt:TextField;
      
      private var nowRankingArr:Array = [];
      
      private var rankBarBox:Sprite;
      
      private var barType:int;
      
      private var _nowPage:int = 1;
      
      private var _maxPage:int = 1;
      
      private var nowRankingType:int;
      
      private var stageBtnArr:Array;
      
      private var myRankNum:int;
      
      private var areaNameText:TextField;
      
      private var tollGateBarBox:Sprite;
      
      public function RankingPanel()
      {
         super();
         this.initBackGround();
      }
      
      public function destroy() : void
      {
         this.clearEvent();
         this.clearContainer(this.rankBarBox,"rankBar");
         this.clearContainer(this.tollGateBarBox,"gateBar");
         this.firtAttackBtn.distroy();
         this.completeDegreeBtn.distroy();
         this.honorRankBtn.distroy();
         FuncKit.clearAllChildrens(this);
         this.firtAttackBtn = null;
         this.completeDegreeBtn = null;
         this.honorRankBtn = null;
         this.closeBtn = null;
         this.firtAttackBackGround = null;
         this.completeDegreeBackGround = null;
         this.honorRankingBackGround = null;
         this.nowRankingArr = null;
         this.myAreaing = null;
      }
      
      public function setAllRankingBtnDefault() : void
      {
         this.firtAttackBtn.setBtnType(false);
         this.completeDegreeBtn.setBtnType(false);
         this.honorRankBtn.setBtnType(false);
      }
      
      private function initBackGround() : void
      {
         var _loc1_:ReBuidBitmap = new ReBuidBitmap("pvz.ectype.ranking.RankingBack");
         var _loc2_:ReBuidBitmap = new ReBuidBitmap("pvz.ectype.ranking.RankingBackTitle");
         this.firtAttackBtn = GetDomainRes.getRankSimpleButton(ATTACK_FIRST_RANKING);
         this.completeDegreeBtn = GetDomainRes.getRankSimpleButton(COMPLETE_DEGREE_RANKING);
         this.honorRankBtn = GetDomainRes.getRankSimpleButton(HONOR_RANKING);
         this.closeBtn = GetDomainRes.getSimpleButton("pvz.ectype.ranking.closeBtn");
         this.myAreaing = new ReBuidBitmap("pvz.ectype.ranking.AreaBack");
         this.firtAttackBtn.name = "1";
         this.completeDegreeBtn.name = "2";
         this.honorRankBtn.name = "3";
         var _loc3_:Sprite = GetDomainRes.getSprite("pvz.ectype.ranking.upDownBtn");
         this.lastBtn = _loc3_.getChildByName("_last") as SimpleButton;
         this.nextBtn = _loc3_.getChildByName("_next") as SimpleButton;
         this.pageTxt = _loc3_.getChildByName("_page") as TextField;
         this.contaner = new Sprite();
         this.areaNameText = new TextField();
         _loc2_.x = (_loc1_.width - _loc2_.width) / 2 - 30;
         this.completeDegreeBtn.x = 55;
         this.honorRankBtn.x = this.completeDegreeBtn.x + this.completeDegreeBtn.width + 10;
         this.firtAttackBtn.x = this.honorRankBtn.x + this.honorRankBtn.width + 10;
         this.completeDegreeBtn.y = this.honorRankBtn.y = this.firtAttackBtn.y = 45;
         this.myAreaing.x = this.firtAttackBtn.x + this.firtAttackBtn.width + 50;
         this.myAreaing.y = 45;
         this.areaNameText.x = this.myAreaing.x + 80;
         this.areaNameText.y = this.myAreaing.y + 10;
         this.contaner.x = 31;
         this.contaner.y = 94;
         _loc3_.x = _loc1_.width - _loc3_.width - 60;
         _loc3_.y = _loc1_.height - _loc3_.height * 2 - 12;
         this.closeBtn.x = _loc1_.width - this.closeBtn.width - 10;
         this.closeBtn.y = 10;
         this.setAllRankingBtnDefault();
         this.completeDegreeBtn.setBtnType(true);
         this.addChild(_loc1_);
         this.addChild(_loc2_);
         this.addChild(this.firtAttackBtn);
         this.addChild(this.completeDegreeBtn);
         this.addChild(this.honorRankBtn);
         this.addChild(this.myAreaing);
         this.addChild(this.areaNameText);
         this.addChild(this.contaner);
         this.addChild(_loc3_);
         this.addChild(this.closeBtn);
         this.lastBtn.addEventListener(MouseEvent.CLICK,this.gotoLastPageHandle);
         this.nextBtn.addEventListener(MouseEvent.CLICK,this.gotoNextPageHandle);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindowHandle);
         this.firtAttackBtn.addEventListener(MouseEvent.CLICK,this.firtAttackClickHandle);
         this.honorRankBtn.addEventListener(MouseEvent.CLICK,this.honorRankClickHandle);
         this.completeDegreeBtn.addEventListener(MouseEvent.CLICK,this.completeDegreeClickHandle);
      }
      
      public function clearEvent() : void
      {
         this.lastBtn.removeEventListener(MouseEvent.CLICK,this.gotoLastPageHandle);
         this.nextBtn.removeEventListener(MouseEvent.CLICK,this.gotoNextPageHandle);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeWindowHandle);
         this.firtAttackBtn.removeEventListener(MouseEvent.CLICK,this.firtAttackClickHandle);
         this.honorRankBtn.removeEventListener(MouseEvent.CLICK,this.honorRankClickHandle);
         this.completeDegreeBtn.removeEventListener(MouseEvent.CLICK,this.completeDegreeClickHandle);
      }
      
      private function closeWindowHandle(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.closeClickFunc();
      }
      
      private function firtAttackClickHandle(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == this.nowRankingType)
         {
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.setAllRankingBtnDefault();
         param1.currentTarget.setBtnType(true);
         this.firtAttackClickFunc();
      }
      
      private function honorRankClickHandle(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == this.nowRankingType)
         {
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.setAllRankingBtnDefault();
         param1.currentTarget.setBtnType(true);
         this.honorRankClickFunc();
      }
      
      private function completeDegreeClickHandle(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == this.nowRankingType)
         {
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.setAllRankingBtnDefault();
         param1.currentTarget.setBtnType(true);
         this.completeDegreeClickFunc();
      }
      
      private function gotoLastPageHandle(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._nowPage < 2)
         {
            return;
         }
         --this._nowPage;
         this.showNowPageData();
      }
      
      private function gotoNextPageHandle(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._nowPage == this._maxPage)
         {
            return;
         }
         ++this._nowPage;
         this.showNowPageData();
      }
      
      public function initDisplayScence(param1:int, param2:int, param3:Object) : void
      {
         this.clearContainer(this.rankBarBox,"rankBar");
         this.clearContainer(this.tollGateBarBox,"gateBar");
         this.nowRankingType = param1;
         this.setEnterArea(param2);
         switch(param1)
         {
            case ATTACK_FIRST_RANKING:
               this.barType = RankingBar.FIRST_ATTACK_BAR;
               this.initAttackUi(param3);
               break;
            case COMPLETE_DEGREE_RANKING:
               this.barType = RankingBar.COMPLETE_DEGREE_BAR;
               this.initCompleteDegreeUi(param3);
               break;
            case HONOR_RANKING:
               this.barType = RankingBar.HONOR_RANKING_BAR;
               this.initHonorRankingUi(param3);
         }
      }
      
      private function setEnterArea(param1:int) : void
      {
         var _loc2_:String = null;
         if(this.areaNameText == null)
         {
            this.areaNameText = new TextField();
         }
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
         this.areaNameText.htmlText = "<font size=\'20\'><b>" + _loc2_ + "</b></font>";
         this.areaNameText.selectable = false;
         this.areaNameText.width = this.areaNameText.textWidth + 2;
         this.areaNameText.height = this.areaNameText.textHeight + 2;
      }
      
      private function initAttackUi(param1:Object) : void
      {
         var _loc4_:StageOptionButton = null;
         var _loc5_:int = 0;
         if(this.firtAttackBackGround == null)
         {
            this.firtAttackBackGround = new ReBuidBitmap("pvz.ectype.ranking.FirstAttackBack");
         }
         this.contaner.addChild(this.firtAttackBackGround);
         if(this.tollGateBarBox == null)
         {
            this.tollGateBarBox = new Sprite();
         }
         else
         {
            this.clearContainer(this.tollGateBarBox,"gateBar");
         }
         this.tollGateBarBox.x = 16;
         this.tollGateBarBox.y = 55;
         this.contaner.addChild(this.tollGateBarBox);
         if(this.rankBarBox == null)
         {
            this.rankBarBox = new Sprite();
         }
         this.rankBarBox.x = 225;
         this.rankBarBox.y = 38;
         this.contaner.addChild(this.rankBarBox);
         var _loc2_:Array = param1 as Array;
         var _loc3_:int = int(_loc2_.length);
         this.stageBtnArr = [];
         while(_loc5_ < _loc3_)
         {
            _loc4_ = new StageOptionButton();
            _loc4_.setName(_loc2_[_loc5_]["cave"]["name"]);
            _loc4_.setData(_loc2_[_loc5_]);
            _loc4_.y = _loc4_.height * _loc5_ + 4;
            _loc4_.id = _loc5_;
            this.tollGateBarBox.addChild(_loc4_);
            this.stageBtnArr.push(_loc4_);
            if(_loc5_ == 0)
            {
               this.clickStageRankHandle(null,_loc2_[_loc5_]);
            }
            _loc4_.addEventListener(StageClickEvent.RANKING_DATA,this.clickStageRankHandle,false,0,true);
            _loc5_++;
         }
      }
      
      private function clickStageRankHandle(param1:StageClickEvent, param2:Object = null) : void
      {
         if(param2 != null)
         {
            this.setStageBtnSelected(0);
            this.myRankNum = param2["cave"]["order"];
            this.nowRankingArr = param2["top"];
         }
         else
         {
            this.setStageBtnSelected(param1.currentTarget.id);
            this.myRankNum = param1.data["cave"]["order"];
            this.nowRankingArr = param1.data["top"];
         }
         this.resetRankingArr();
         this.showNowPageData();
      }
      
      private function setStageBtnSelected(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this.stageBtnArr.length);
         while(_loc2_ < _loc3_)
         {
            if(param1 == _loc2_)
            {
               this.stageBtnArr[_loc2_].setBackClick(true);
            }
            else
            {
               this.stageBtnArr[_loc2_].setBackClick(false);
            }
            _loc2_++;
         }
      }
      
      private function initCompleteDegreeUi(param1:Object) : void
      {
         if(this.completeDegreeBackGround == null)
         {
            this.completeDegreeBackGround = new ReBuidBitmap("pvz.ectype.ranking.CompleteDegreeBack");
         }
         this.contaner.addChild(this.completeDegreeBackGround);
         if(this.rankBarBox == null)
         {
            this.rankBarBox = new Sprite();
         }
         this.contaner.addChild(this.rankBarBox);
         this.rankBarBox.x = 16;
         this.rankBarBox.y = 38;
         this.nowRankingArr = param1 as Array;
         this.resetRankingArr();
         this.showNowPageData();
      }
      
      private function showNowPageData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:RankingBar = null;
         var _loc6_:int = 0;
         this.clearContainer(this.rankBarBox,"rankBar");
         if(this.nowRankingArr.length == 0)
         {
            return;
         }
         if(this.nowRankingType == ATTACK_FIRST_RANKING)
         {
            _loc1_ = 6;
            _loc2_ = 0;
         }
         else
         {
            _loc1_ = 0;
            _loc2_ = 2;
         }
         this.pageTxt.text = this._nowPage + "/" + this._maxPage;
         var _loc3_:Array = this.nowRankingArr.slice((this._nowPage - 1) * PAGE_NUM,this._nowPage * PAGE_NUM);
         var _loc4_:int = int(_loc3_.length);
         while(_loc6_ < _loc4_)
         {
            _loc5_ = new RankingBar(this.barType);
            _loc5_.upData(_loc3_[_loc6_]);
            _loc5_.y = (_loc5_.height - _loc2_) * _loc6_ + _loc1_;
            this.rankBarBox.addChild(_loc5_);
            _loc6_++;
         }
      }
      
      private function initHonorRankingUi(param1:Object) : void
      {
         if(this.honorRankingBackGround == null)
         {
            this.honorRankingBackGround = new ReBuidBitmap("pvz.ectype.ranking.HonorRankingBack");
            this.honorRankingBackGround.y = 1;
         }
         this.contaner.addChild(this.honorRankingBackGround);
         if(this.rankBarBox == null)
         {
            this.rankBarBox = new Sprite();
         }
         this.contaner.addChild(this.rankBarBox);
         this.rankBarBox.x = 16;
         this.rankBarBox.y = 38;
         this.nowRankingArr = param1 as Array;
         this.resetRankingArr();
         this.showNowPageData();
      }
      
      private function resetRankingArr() : void
      {
         this._maxPage = 1;
         if(this.nowRankingArr.length == 0)
         {
            this._nowPage = 1;
            this.pageTxt.text = this._nowPage + "/" + this._maxPage;
            return;
         }
         if(this.nowRankingArr.length / PAGE_NUM > 1)
         {
            this._maxPage = this.nowRankingArr.length / PAGE_NUM + 1;
         }
         else
         {
            this._maxPage = Math.ceil(this.nowRankingArr.length / PAGE_NUM);
         }
         this._nowPage = 1;
      }
      
      private function clearContainer(param1:Sprite, param2:String) : void
      {
         var _loc3_:* = undefined;
         if(param1 == null)
         {
            return;
         }
         while(param1.numChildren > 0)
         {
            if(param2 == "gateBar")
            {
               _loc3_ = param1.getChildAt(0) as StageOptionButton;
               _loc3_.distroy();
            }
            else if(param2 == "rankBar")
            {
               _loc3_ = param1.getChildAt(0) as RankingBar;
               _loc3_.distroy();
            }
            else
            {
               param1.removeChildAt(0);
            }
         }
      }
   }
}

