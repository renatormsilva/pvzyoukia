package pvz.serverbattle.knockout.guess
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.entity.PlayerInfo;
   import pvz.serverbattle.fport.GuessPanelFPort;
   import pvz.serverbattle.tip.GuessPlantsTip;
   import tip.ToolsTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import zlib.utils.DomainAccess;
   
   public class GuessPanel extends BaseWindow
   {
      
      private static const MAX:int = 6;
      
      private var mainpanel:Sprite;
      
      private var guessbtnA:SimpleButton;
      
      private var guessbtnB:SimpleButton;
      
      private var guessPanelFPort:GuessPanelFPort;
      
      private var closeBtn:SimpleButton;
      
      private var _maxPage:Array = null;
      
      private var _nowPage:Array = null;
      
      private var orgTip:GuessPlantsTip;
      
      private var playerOneId:int;
      
      private var playerTwoId:int;
      
      private var firstplayerPlants:Array;
      
      private var secondplayerPlants:Array;
      
      private var _groupid:int;
      
      private var prizeboxid:int;
      
      private var prizeTips:ToolsTip;
      
      private var prize4DoubleCost:int;
      
      private var prize8DoubleCost:int;
      
      private var _func:Function;
      
      public function GuessPanel(param1:int, param2:Function = null)
      {
         super();
         this._groupid = param1;
         this._func = param2;
         this.createConnection(param1);
      }
      
      private function createConnection(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         if(this.guessPanelFPort == null)
         {
            this.guessPanelFPort = new GuessPanelFPort(this);
         }
         this.guessPanelFPort.initPanelData(GuessPanelFPort.COMPETE_GUESS_CAN,param1);
      }
      
      public function doWithData(param1:PlayerInfo) : void
      {
         this.initUi();
         this.setLoction();
         this.addMouseEvent();
         PlantsVsZombies.showDataLoading(false);
         onShowEffect(this.mainpanel);
         this.prizeboxid = param1.prizeId;
         this.prize4DoubleCost = param1.prizeCost4;
         this.prize8DoubleCost = param1.prizeCost8;
         var _loc2_:Tool = new Tool(this.prizeboxid);
         this.mainpanel["prize"].addChild(this.getBoxByPicID(_loc2_.getPicId()));
         this.playerOneId = param1.firstPlayer.getId();
         this.playerTwoId = param1.secondPlayer.getId();
         this.firstplayerPlants = param1.firstPlayer.getRunPlants();
         this.secondplayerPlants = param1.secondPlayer.getRunPlants();
         this.showInfo(param1.firstPlayer,"a");
         this.showInfo(param1.secondPlayer,"b");
         this.initPageInfo();
         this.setAllOrgs();
      }
      
      private function addMouseEvent() : void
      {
         this.guessbtnA.addEventListener(MouseEvent.CLICK,this.onClick);
         this.guessbtnB.addEventListener(MouseEvent.CLICK,this.onClick);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["plantsa"].addEventListener(MouseEvent.MOUSE_OVER,this.onPlantsOver);
         this.mainpanel["plantsb"].addEventListener(MouseEvent.MOUSE_OVER,this.onPlantsOver);
         this.mainpanel["plantsa"].addEventListener(MouseEvent.MOUSE_OUT,this.onPlantsOut);
         this.mainpanel["plantsb"].addEventListener(MouseEvent.MOUSE_OUT,this.onPlantsOut);
         this.mainpanel["_bt_right1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["_bt_left1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["_bt_right2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["_bt_left2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["gx"].addEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
      }
      
      private function onPrizeOver(param1:MouseEvent) : void
      {
         if(this.prizeTips == null)
         {
            this.prizeTips = new ToolsTip();
         }
         else
         {
            this.prizeTips.visible = true;
         }
         var _loc2_:Tool = new Tool(this.prizeboxid);
         this.prizeTips.setTooltipText(this.mainpanel["gx"],_loc2_.getName(),_loc2_.getUse_condition(),_loc2_.getUse_result());
         this.prizeTips.setLoction(-30,-70);
      }
      
      private function getBoxByPicID(param1:int) : Sprite
      {
         return GetDomainRes.getSprite("box_" + param1);
      }
      
      private function removeMouseEvent() : void
      {
         this.guessbtnA.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.guessbtnB.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["plantsa"].removeEventListener(MouseEvent.MOUSE_OVER,this.onPlantsOver);
         this.mainpanel["plantsb"].removeEventListener(MouseEvent.MOUSE_OVER,this.onPlantsOver);
         this.mainpanel["plantsa"].removeEventListener(MouseEvent.MOUSE_OUT,this.onPlantsOut);
         this.mainpanel["plantsb"].removeEventListener(MouseEvent.MOUSE_OUT,this.onPlantsOut);
         this.mainpanel["_bt_right1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["_bt_left1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["_bt_right2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["_bt_left2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.mainpanel["gx"].removeEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
      }
      
      private function onPlantsOver(param1:MouseEvent) : void
      {
         var _loc2_:PlantsIcon = param1.target as PlantsIcon;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_._org == null)
         {
            return;
         }
         if(this.orgTip == null)
         {
            this.orgTip = new GuessPlantsTip(90,44);
         }
         this.orgTip.visible = true;
         this.orgTip.setInfo(_loc2_._org);
         this.orgTip.x = _loc2_.parent.x + _loc2_.x - 15;
         this.orgTip.y = _loc2_.parent.y + _loc2_.y - this.orgTip.height;
         this.mainpanel.addChild(this.orgTip);
      }
      
      private function onPlantsOut(param1:MouseEvent) : void
      {
         var _loc2_:PlantsIcon = param1.target as PlantsIcon;
         if(_loc2_ == null || this.orgTip == null)
         {
            return;
         }
         if(_loc2_._org == null)
         {
            return;
         }
         if(this.orgTip.visible)
         {
            this.orgTip.visible = false;
         }
         this.mainpanel.removeChild(this.orgTip);
      }
      
      private function changeBtShow(param1:int) : void
      {
         this.mainpanel["_bt_right" + (param1 + 1)].visible = true;
         this.mainpanel["_bt_left" + (param1 + 1)].visible = true;
         if(this._nowPage[param1] <= 1)
         {
            this.mainpanel["_bt_left" + (param1 + 1)].visible = false;
         }
         if(this._nowPage[param1] >= this._maxPage[param1])
         {
            this.mainpanel["_bt_right" + (param1 + 1)].visible = false;
         }
      }
      
      private function setOrgs(param1:Array, param2:String, param3:int) : void
      {
         var _loc7_:Array = null;
         var _loc8_:PlantsIcon = null;
         this.changeBtShow(param3);
         var _loc4_:int = 0;
         if(this._nowPage[param3] * MAX > param1.length)
         {
            _loc7_ = param1.slice((this._nowPage[param3] - 1) * MAX,param1.length);
         }
         else
         {
            _loc7_ = param1.slice((this._nowPage[param3] - 1) * MAX,MAX);
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc7_.length)
         {
            _loc8_ = new PlantsIcon(_loc7_[_loc5_]);
            _loc8_.x = _loc5_ * 64;
            this.mainpanel["plants" + param2].addChild(_loc8_);
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < MAX - _loc7_.length)
         {
            _loc8_ = new PlantsIcon(null);
            _loc8_.x = (_loc6_ + _loc7_.length) * 64;
            this.mainpanel["plants" + param2].addChild(_loc8_);
            _loc6_++;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "guessA")
         {
            new GuessPatternPanel(this._groupid,this.playerOneId,this.prizeboxid,this.prize4DoubleCost,this.prize8DoubleCost,this.close);
         }
         else if(param1.currentTarget.name == "guessB")
         {
            new GuessPatternPanel(this._groupid,this.playerTwoId,this.prizeboxid,this.prize4DoubleCost,this.prize8DoubleCost,this.close);
         }
         else if(param1.currentTarget.name == "close")
         {
            this.close();
         }
         else if(param1.currentTarget.name == "_bt_left1")
         {
            if(this._nowPage[0] <= 1)
            {
               return;
            }
            --this._nowPage[0];
            this.setAllOrgs();
         }
         else if(param1.currentTarget.name == "_bt_right1")
         {
            if(this._nowPage[0] >= this._maxPage[0])
            {
               return;
            }
            ++this._nowPage[0];
            this.setAllOrgs();
         }
         else if(param1.currentTarget.name == "_bt_left2")
         {
            if(this._nowPage[1] <= 1)
            {
               return;
            }
            --this._nowPage[1];
            this.setAllOrgs();
         }
         else if(param1.currentTarget.name == "_bt_right2")
         {
            if(this._nowPage[1] >= this._maxPage[1])
            {
               return;
            }
            ++this._nowPage[1];
            this.setAllOrgs();
         }
      }
      
      private function close(param1:Boolean = false, param2:int = 0, param3:int = 0) : void
      {
         if(param1)
         {
            if(this._func != null)
            {
               this._func(param2,param3);
            }
         }
         onHiddenEffect(this.mainpanel,this.destroy);
      }
      
      private function initUi() : void
      {
         if(this.mainpanel == null)
         {
            this.mainpanel = GetDomainRes.getSprite("serverbattle.knockout.guess.guesspanel");
         }
         if(this.guessbtnA == null)
         {
            this.guessbtnA = GetDomainRes.getSimpleButton("serverbattle.knockout.guess.guessbtn");
         }
         if(this.guessbtnB == null)
         {
            this.guessbtnB = GetDomainRes.getSimpleButton("serverbattle.knockout.guess.guessbtn");
         }
         if(this.closeBtn == null)
         {
            this.closeBtn = GetDomainRes.getSimpleButton("pvz.button.close");
         }
         this.guessbtnA.name = "guessA";
         this.guessbtnB.name = "guessB";
         this.closeBtn.name = "close";
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this.mainpanel);
         this.mainpanel.addChild(this.guessbtnA);
         this.mainpanel.addChild(this.guessbtnB);
         this.mainpanel.addChild(this.closeBtn);
         this.guessbtnA.x = this.guessbtnB.x = 410;
         this.guessbtnA.y = 165;
         this.guessbtnB.y = 329;
         this.closeBtn.x = 470;
         this.closeBtn.y = 30;
      }
      
      private function setAllOrgs() : void
      {
         this.clearOrgs(this.mainpanel["plantsa"]);
         this.clearOrgs(this.mainpanel["plantsb"]);
         this.setOrgs(this.firstplayerPlants,"a",0);
         this.setOrgs(this.secondplayerPlants,"b",1);
      }
      
      private function initPageInfo() : void
      {
         this._nowPage = new Array(1,1);
         this._maxPage = new Array(int((this.firstplayerPlants.length - 1) / MAX) + 1,int((this.secondplayerPlants.length - 1) / MAX) + 1);
      }
      
      private function showInfo(param1:Contestant, param2:String) : void
      {
         this.mainpanel["txt" + param2].text = param1.getServerName() + "     " + param1.getName();
         this.mainpanel["txt" + param2].selectable = false;
         PlantsVsZombies.setHeadPic(this.mainpanel["pic" + param2],PlantsVsZombies.getHeadPicUrl(param1.getfaceUrl()),PlantsVsZombies.HEADPIC_BIG,param1.getVipTime(),param1.getVipGrade());
         var _loc3_:Class = DomainAccess.getClass("grade");
         var _loc4_:MovieClip = new _loc3_();
         _loc4_["num"].addChild(FuncKit.getNumEffect("" + param1.getGrade()));
         this.mainpanel["level" + param2].addChild(_loc4_);
      }
      
      private function clearOrgs(param1:Sprite) : void
      {
         if(param1.numChildren <= 0)
         {
            return;
         }
         var _loc2_:* = int(param1.numChildren - 1);
         while(_loc2_ > -1)
         {
            if(param1.getChildAt(_loc2_) is PlantsIcon)
            {
               (param1.getChildAt(_loc2_) as PlantsIcon).destroy();
               param1.removeChildAt(_loc2_);
            }
            _loc2_--;
         }
      }
      
      private function setLoction() : void
      {
         this.mainpanel.x = (PlantsVsZombies.WIDTH - this.mainpanel.width) / 2;
         this.mainpanel.y = (PlantsVsZombies.HEIGHT - this.mainpanel.height) / 2;
      }
      
      override public function destroy() : void
      {
         this.mainpanel["gx"].gotoAndStop(1);
         this.clearOrgs(this.mainpanel["plantsa"]);
         this.clearOrgs(this.mainpanel["plantsb"]);
         FuncKit.clearAllChildrens(this.mainpanel["levela"]);
         FuncKit.clearAllChildrens(this.mainpanel["levelb"]);
         FuncKit.clearAllChildrens(this.mainpanel["pica"]);
         FuncKit.clearAllChildrens(this.mainpanel["picb"]);
         FuncKit.clearAllChildrens(this.mainpanel["prize"]);
         this.removeMouseEvent();
         FuncKit.clearAllChildrens(this.mainpanel);
         PlantsVsZombies._node.removeChild(this.mainpanel);
         this.mainpanel = null;
         this.firstplayerPlants = null;
         this.secondplayerPlants = null;
         this.guessbtnA = null;
         this.guessbtnB = null;
         this.closeBtn = null;
         this.orgTip = null;
         this.prizeTips = null;
         this._func = null;
      }
   }
}

