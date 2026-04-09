package pvz.possession
{
   import effect.flap.FlapManager;
   import entity.Organism;
   import entity.Player;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.possession.fport.PossessionNodeFPort;
   import pvz.possession.tip.PossessionOrgTip;
   import pvz.possession.tip.PossessionTip;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.StringMovieClip;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class PossessionNode extends Sprite
   {
      
      public static const CD_TIME:int = 4 * 60 * 60;
      
      public static const GUEST:int = 2;
      
      public static const HOST:int = 1;
      
      public static const INCOME_TIME:int = 12 * 60 * 60;
      
      public static const LV:int = 20;
      
      public static const MAX_TIME:int = 48 * 60 * 60;
      
      private var _backShowJiantou:Function = null;
      
      private var _btAgainst:SimpleButton = null;
      
      private var _btHelp:SimpleButton = null;
      
      private var _btIncome:SimpleButton = null;
      
      private var _btInto:SimpleButton = null;
      
      private var _btOccupation:SimpleButton = null;
      
      private var _btQuit:SimpleButton = null;
      
      private var _btReleas:SimpleButton = null;
      
      private var _buttons:Array = null;
      
      private var _cdTime:MovieClip = null;
      
      private var _changeFun:Function = null;
      
      private var _clearAll:Function = null;
      
      private var _fore:DisplayObjectContainer = null;
      
      private var _fport:PossessionNodeFPort = null;
      
      private var _income_gold:MovieClip = null;
      
      private var _income_gold_play:MovieClip = null;
      
      private var _index:int = 0;
      
      private var _loc:Point = null;
      
      private var _node:MovieClip = null;
      
      private var _p:Possession = null;
      
      private var _tip:PossessionTip = null;
      
      private var _type:int = 1;
      
      private var _upDateFun:Function = null;
      
      private var _updatePlayer:Function = null;
      
      private var orgsTipsArr:Array = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var recommenWindow:RecommenWindow = null;
      
      public function PossessionNode(param1:Possession, param2:DisplayObjectContainer, param3:Point, param4:Function, param5:Function, param6:int, param7:Function, param8:Function, param9:Function, param10:int)
      {
         super();
         this._loc = param3;
         this._p = param1;
         this._fore = param2;
         this._backShowJiantou = param7;
         this._clearAll = param9;
         this._updatePlayer = param8;
         this._upDateFun = param4;
         this._changeFun = param5;
         this._buttons = new Array();
         this._fport = new PossessionNodeFPort(this);
         this._type = param10;
         this._index = param6;
         this.init();
      }
      
      public function clearButtons(param1:String = "") : void
      {
         if(param1 == this._node.name)
         {
            return;
         }
         if(this._buttons == null || this._buttons.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._buttons.length)
         {
            this.parent.parent.removeChild(this._buttons[_loc2_]);
            _loc2_++;
         }
         this._buttons = new Array();
      }
      
      public function destory() : void
      {
         if(this._tip != null)
         {
            this._tip.destroy();
         }
         this.clear();
         this.removeEvent();
      }
      
      public function onButtonShow(param1:DisplayObject) : void
      {
         var max:int = 0;
         var times:int = 0;
         var onPlay:Function = null;
         var _dis:DisplayObject = param1;
         onPlay = function(param1:Event):void
         {
            ++times;
            if(times < 3)
            {
               _dis.y -= 2;
            }
            else
            {
               _dis.y += 6;
            }
            if(max == times)
            {
               stage.removeEventListener(Event.ENTER_FRAME,onPlay);
            }
         };
         stage.addEventListener(Event.ENTER_FRAME,onPlay);
         max = 4;
         times = 0;
      }
      
      public function portToIncome(param1:int, param2:int) : void
      {
         this._income_gold_play.visible = true;
         this._income_gold_play.gotoAndPlay(1);
         this._income_gold.visible = false;
         this._income_gold.gotoAndStop(1);
         this._income_gold._mc_gold.gotoAndStop(1);
         this._income_gold_play.addEventListener(Event.ENTER_FRAME,this.onPlay);
         this.playerManager.getPlayer().setMoney(param1 + this.playerManager.getPlayer().getMoney());
         this.playerManager.getPlayer().setHonour(param2 + this.playerManager.getPlayer().getHonour());
         this.flyMoney(param1);
         this.flyHonor(param2);
         PlantsVsZombies.playSounds(SoundManager.MONEY);
         this._p.setHonor(0);
         this._p.setIncome(0);
         this._p.setLastAwardTime(FuncKit.currentTimeMillis() / 10 + INCOME_TIME);
      }
      
      public function portToRelease(param1:int, param2:int) : void
      {
         if(param2 > 0)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession014",this._p.getMaster(),param2,param1));
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession042",this._p.getMaster(),param1));
         }
         this.playerManager.getPlayer().setMoney(param1 + this.playerManager.getPlayer().getMoney());
         this.playerManager.getPlayer().setHonour(param2 + this.playerManager.getPlayer().getHonour());
         if(!(this._type == HOST && this._p.getPossessionId() == this.playerManager.getPlayer().getId()))
         {
            this.playerManager.getPlayer().setLastOccupy(this.playerManager.getPlayer().getLastOccupy() + 1);
         }
         this._updatePlayer();
         this.clear();
      }
      
      public function update(param1:Possession) : Boolean
      {
         if(this._p != null && this._p.getPossessionId() != param1.getPossessionId())
         {
            return false;
         }
         if(this._index == 0)
         {
            this._p.setOccupyId(0);
            this._p.setOccupyName("");
            this._p.setOccupyOrgs(null);
            this._p.setOccuypGrade(0);
            this._p.setOccupyTime(0);
         }
         else
         {
            this._p = null;
         }
         this.show();
         return true;
      }
      
      private function addAgainst() : void
      {
         this._buttons.push(this._btAgainst);
      }
      
      private function addCDTime() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_possession_stop");
         this._cdTime = new _loc1_();
         this._cdTime.visible = false;
         this._cdTime.gotoAndStop(1);
         this._cdTime.x = this._node["_mc_cd"].x;
         this._cdTime.y = this._node["_mc_cd"].y;
         this._cdTime.mouseChildren = false;
         this._cdTime.mouseEnabled = false;
         addChild(this._cdTime);
      }
      
      private function addEvent() : void
      {
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function addHelp() : void
      {
         this._buttons.push(this._btHelp);
      }
      
      private function addIncome() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_possession_gold");
         this._income_gold = new _loc1_();
         this._income_gold.addEventListener(MouseEvent.CLICK,this.onGoldClick);
         this._income_gold.gotoAndStop(1);
         this._income_gold._mc_gold.gotoAndStop(1);
         this._income_gold.visible = false;
         this._income_gold.x = this._node.width / 2 - 30 + this.x;
         this._income_gold.y = 10 + this.y;
         this._income_gold.buttonMode = true;
         var _loc2_:Class = DomainAccess.getClass("_possession_gold_play");
         this._income_gold_play = new _loc2_();
         this._income_gold_play.gotoAndStop(1);
         this._income_gold_play.visible = false;
         this._income_gold_play.x = this._node.width / 2 - 30 + this.x;
         this._income_gold_play.y = 10 + this.y;
         this._income_gold_play.visible = false;
         this._income_gold.addEventListener(MouseEvent.ROLL_OUT,this.onGoldOut);
         this._income_gold.addEventListener(MouseEvent.ROLL_OVER,this.onGoldOver);
         this.parent.parent.addChild(this._income_gold_play);
         this.parent.parent.addChild(this._income_gold);
      }
      
      private function addInto() : void
      {
         if(this._type != HOST)
         {
            this._buttons.push(this._btInto);
         }
      }
      
      private function addOccupation() : void
      {
         this._buttons.push(this._btOccupation);
      }
      
      private function addQuit() : void
      {
         this._buttons.push(this._btQuit);
      }
      
      private function addReleas() : void
      {
         this._buttons.push(this._btReleas);
      }
      
      private function chooseButton() : void
      {
         this.clearButtons();
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            if(this._p.getOccupyId() == 0)
            {
               this.addOccupation();
            }
            else if(this._p.getOccupyId() == this.playerManager.getPlayer().getId())
            {
               this.addReleas();
               this.addInto();
            }
            else
            {
               this.addAgainst();
               this.addQuit();
            }
         }
         else if(this._p.getOccupyId() == 0)
         {
            this.addOccupation();
         }
         else if(this._p.getOccupyId() == this.playerManager.getPlayer().getId())
         {
            this.addReleas();
            this.addInto();
         }
         else
         {
            this.addOccupation();
            this.addInto();
            if(this._p.getOccupyId() != this._p.getPossessionId() && this._p.isHelp && this._type == HOST)
            {
               this.addHelp();
            }
         }
         this.showButtons();
      }
      
      private function clear() : void
      {
         this.clearHeadPic();
         this.clearOrgs();
         this.clearIncome();
         if(this._type != HOST)
         {
            this._p = null;
         }
         else
         {
            this._p.setOccupyId(0);
            this._p.setOccupyName("");
            this._p.setOccupyOrgs(null);
            this._p.setOccuypGrade(0);
            this._p.setOccupyTime(0);
         }
      }
      
      private function clearHeadPic() : void
      {
         if(this._type == HOST)
         {
            this._node["_pic_name"].visible = false;
         }
         if(this._index != 0)
         {
            return;
         }
         if(this._node["_dis_headpic"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._node["_dis_headpic"]);
         }
      }
      
      private function clearIncome() : void
      {
         var _loc1_:* = int(this.parent.parent.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this.parent.parent.getChildAt(_loc1_) == this._income_gold || this.parent.parent.getChildAt(_loc1_) == this._income_gold_play)
            {
               this.parent.parent.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function clearOrgs() : void
      {
         var _loc2_:Organism = null;
         if(this._fore["_layer_org"].numChildren < 1)
         {
            return;
         }
         if(this._p == null || this._p.getOccupyOrgs() == null || this._p.getOccupyOrgs().length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._p.getOccupyOrgs().length)
         {
            _loc2_ = this._p.getOccupyOrgs()[_loc1_] as Organism;
            this.clearOrg(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearOrg(param1:Organism) : void
      {
         var _loc2_:* = int(this._fore["_layer_org"].numChildren - 1);
         while(_loc2_ > -1)
         {
            if(this._fore["_layer_org"].getChildAt(_loc2_) is PossessionOrgNode)
            {
               if((this._fore["_layer_org"].getChildAt(_loc2_) as PossessionOrgNode)._org == param1)
               {
                  (this._fore["_layer_org"].getChildAt(_loc2_) as PossessionOrgNode).destroy();
                  this._fore["_layer_org"].removeChildAt(_loc2_);
               }
            }
            _loc2_--;
         }
      }
      
      private function flyHonor(param1:int) : void
      {
         if(param1 < 1)
         {
            return;
         }
         var _loc2_:Class = DomainAccess.getClass("_possession_icon_honor");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].visible = true;
         _loc3_["num"].addChild(StringMovieClip.getStringImage(param1 + "","Small"));
         FlapManager.flapInfos(this._income_gold_play.x,this._income_gold_play.y,this.parent.parent,_loc3_,2,null,400);
      }
      
      private function flyMoney(param1:int) : void
      {
         var _loc2_:Class = DomainAccess.getClass("money_1");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].visible = true;
         _loc3_["num"].addChild(StringMovieClip.getStringImage(param1 + "","Small"));
         FlapManager.flapInfos(this._income_gold_play.x,this._income_gold_play.y,this.parent.parent,_loc3_,2);
      }
      
      private function getBtLoction(param1:DisplayObject, param2:int) : Point
      {
         var _loc3_:Point = new Point();
         if(this._index == 0)
         {
            if(this._buttons.length == 1)
            {
               _loc3_.x = 100;
               _loc3_.y = 80;
            }
            else if(this._buttons.length == 2)
            {
               _loc3_.x = param2 * param1.width + 80;
               _loc3_.y = 60;
            }
         }
         else if(this._buttons.length == 1)
         {
            _loc3_.x = 100;
            _loc3_.y = -10;
         }
         else if(this._buttons.length == 2)
         {
            _loc3_.x = param2 * param1.width + 20;
            _loc3_.y = 10;
         }
         else if(param2 == 2)
         {
            _loc3_.x = param1.width * 0.5 + 30;
            _loc3_.y = -40;
         }
         else
         {
            _loc3_.x = param2 * param1.width + 10;
            _loc3_.y = 10;
         }
         return _loc3_;
      }
      
      private function getCDTime() : String
      {
         var _loc2_:int = 0;
         if(this._p == null)
         {
            return "";
         }
         var _loc1_:int = this._p.getCDTime() - FuncKit.currentTimeMillis() / 1000;
         if(_loc1_ > 0)
         {
            _loc2_ = int(_loc1_ / 60);
            if(_loc2_ == 0)
            {
               _loc2_ = 1;
            }
            return LangManager.getInstance().getLanguage("possession037",_loc2_);
         }
         return "";
      }
      
      private function getGird(param1:Organism) : int
      {
         return param1.getWidth() * param1.getHeight();
      }
      
      private function getJiantouLoc() : Point
      {
         var _loc1_:Point = new Point();
         if(this._index == 0)
         {
            _loc1_.x = this._loc.x + this._node.width / 2 - 22;
            _loc1_.y = this._loc.y - 30;
         }
         else
         {
            _loc1_.x = this._loc.x + this._node.width / 2 - 20;
            _loc1_.y = this._loc.y - 25;
         }
         return _loc1_;
      }
      
      private function getOrgLoction(param1:int, param2:int) : Point
      {
         var _loc3_:Point = new Point();
         if(this._type == HOST)
         {
            if(param2 >= 2)
            {
               _loc3_.x = 140;
               _loc3_.y = 220;
            }
            else if(param1 == 1)
            {
               _loc3_.x = 190;
               _loc3_.y = 200;
            }
            else
            {
               _loc3_.x = 100;
               _loc3_.y = 240;
            }
         }
         else if(param2 >= 2)
         {
            _loc3_.x = 160;
            _loc3_.y = 240;
         }
         else if(param1 == 1)
         {
            _loc3_.x = 180;
            _loc3_.y = 240;
         }
         else
         {
            _loc3_.x = 100;
            _loc3_.y = 240;
         }
         if(this._index == 1)
         {
            _loc3_.y += 55;
         }
         else if(this._index == 2)
         {
            _loc3_.y += 25;
         }
         return _loc3_;
      }
      
      private function getTipLoc() : Point
      {
         var _loc1_:Point = new Point();
         switch(this._index)
         {
            case 0:
               _loc1_.x = 445;
               _loc1_.y = 260;
               break;
            case 1:
               _loc1_.x = 500;
               _loc1_.y = 200;
               break;
            case 2:
               _loc1_.x = 520;
               _loc1_.y = 350;
               break;
            case 3:
               _loc1_.x = 335;
               _loc1_.y = 350;
               break;
            case 4:
               _loc1_.x = 185;
               _loc1_.y = 340;
               break;
            case 5:
               _loc1_.x = 240;
               _loc1_.y = 160;
               break;
            case 6:
               _loc1_.x = 510;
               _loc1_.y = 170;
         }
         return _loc1_;
      }
      
      private function init() : void
      {
         var _loc1_:Class = null;
         if(this._type == HOST)
         {
            _loc1_ = DomainAccess.getClass("_mc_host");
         }
         else
         {
            if(this._type != GUEST)
            {
               throw new Error(LangManager.getInstance().getLanguage("possession007") + this._type);
            }
            _loc1_ = DomainAccess.getClass("_mc_guest" + this._index);
         }
         this._node = new _loc1_();
         this._node.gotoAndStop(1);
         if(this._type == HOST)
         {
            TextFilter.MiaoBian(this._node["_pic_name"]["_txt_name"],1118481);
         }
         this.addEvent();
         this.initButtons();
         addChild(this._node);
         this.addCDTime();
         this.x = this._loc.x;
         this.y = this._loc.y;
         this._fore["_layer_possession"].addChild(this);
         this.show();
      }
      
      private function initButtons() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_bt_releas");
         this._btReleas = new _loc1_();
         this._btReleas.name = "_bt_releas";
         this._btReleas.addEventListener(MouseEvent.CLICK,this.onBtClick);
         var _loc2_:Class = DomainAccess.getClass("_bt_occupation");
         this._btOccupation = new _loc2_();
         this._btOccupation.name = "_bt_occupation";
         this._btOccupation.addEventListener(MouseEvent.CLICK,this.onBtClick);
         var _loc3_:Class = DomainAccess.getClass("_bt_help");
         this._btHelp = new _loc3_();
         this._btHelp.name = "_bt_help";
         this._btHelp.addEventListener(MouseEvent.CLICK,this.onBtClick);
         var _loc4_:Class = DomainAccess.getClass("_bt_quit");
         this._btQuit = new _loc4_();
         this._btQuit.name = "_bt_quit";
         this._btQuit.addEventListener(MouseEvent.CLICK,this.onBtClick);
         var _loc5_:Class = DomainAccess.getClass("_bt_against");
         this._btAgainst = new _loc5_();
         this._btAgainst.name = "_bt_against";
         this._btAgainst.addEventListener(MouseEvent.CLICK,this.onBtClick);
         var _loc6_:Class = DomainAccess.getClass("_bt_into");
         this._btInto = new _loc6_();
         this._btInto.name = "_bt_into";
         this._btInto.addEventListener(MouseEvent.CLICK,this.onBtClick);
      }
      
      private function onBtClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(param1.currentTarget.name == "_bt_releas")
         {
            this.toRelease();
         }
         else if(param1.currentTarget.name == "_bt_quit")
         {
            this.toQuit();
         }
         else if(param1.currentTarget.name == "_bt_help")
         {
            this.toHelp();
         }
         else if(param1.currentTarget.name == "_bt_occupation" || param1.currentTarget.name == "_bt_against")
         {
            this.toOccupation();
         }
         else if(param1.currentTarget.name == "_bt_into")
         {
            this.toInto();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.showCDTime();
         if(this.getCDTime() != "")
         {
            PlantsVsZombies.showSystemErrorInfo(this.getCDTime());
            return;
         }
         if(this._p == null)
         {
            this.recommen();
            return;
         }
         this.chooseButton();
      }
      
      private function onGoldClick(param1:MouseEvent) : void
      {
         this.toIncome();
      }
      
      private function onGoldOut(param1:MouseEvent) : void
      {
         if(this._income_gold == null)
         {
            return;
         }
         this._income_gold._mc_gold.gotoAndStop(1);
      }
      
      private function onGoldOver(param1:MouseEvent) : void
      {
         if(this._income_gold == null)
         {
            return;
         }
         this._income_gold._mc_gold.gotoAndStop(2);
      }
      
      private function onOut(param1:Event) : void
      {
         this._node.gotoAndStop(1);
         this.buttonMode = false;
      }
      
      private function onOver(param1:Event) : void
      {
         this.buttonMode = true;
         this._node.gotoAndStop(2);
         if(this._p == null)
         {
            return;
         }
         if(this._p.getOccupyId() == 0)
         {
            return;
         }
         this.showTips();
      }
      
      private function onPlay(param1:Event) : void
      {
         if(this._income_gold_play.totalFrames == this._income_gold_play.currentFrame)
         {
            this._income_gold_play.gotoAndStop(1);
            this._income_gold_play.visible = false;
            this._income_gold_play.removeEventListener(Event.ENTER_FRAME,this.onPlay);
            this._p.setLastAwardTime(FuncKit.currentTimeMillis() / 1000);
            this._p.setIncome(0);
            this._updatePlayer();
         }
      }
      
      private function recommen() : void
      {
         if(this.recommenWindow == null)
         {
            this.recommenWindow = new RecommenWindow(this._changeFun);
         }
         this.recommenWindow.show();
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function show() : void
      {
         this.addIncome();
         this.showOrg();
         this.showIncome();
         this.showHeadPic();
         this.showCDTime();
         if(this._backShowJiantou != null)
         {
            if(this._p == null || this._p.getOccupyId() == 0)
            {
               this._backShowJiantou(this._index,this.getJiantouLoc());
            }
         }
      }
      
      private function showButtons() : void
      {
         if(this._buttons == null || this._buttons.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._buttons.length)
         {
            this._buttons[_loc1_].x = this.getBtLoction(this._buttons[_loc1_],_loc1_).x + this.x;
            this._buttons[_loc1_].y = this.getBtLoction(this._buttons[_loc1_],_loc1_).y + this.y;
            this.parent.parent.addChild(this._buttons[_loc1_]);
            this.onButtonShow(this._buttons[_loc1_]);
            _loc1_++;
         }
      }
      
      private function showCDTime() : void
      {
         this._cdTime.visible = false;
         if(this.getCDTime() == "")
         {
            return;
         }
         setChildIndex(this._cdTime,numChildren - 1);
         this._cdTime.visible = true;
      }
      
      private function showHeadPic() : void
      {
         this.clearHeadPic();
         if(this._index != 0 || this._p == null)
         {
            return;
         }
         if(this._p.occupyId == 0)
         {
            return;
         }
         if(this._p.getPossessionId() == this._p.getOccupyId() && this._p.getPossessionId() == this.playerManager.getPlayer().getId())
         {
            return;
         }
         this._node["_pic_name"]["_txt_name"].text = this._p.getOccupyName();
         this._node["_pic_name"].visible = true;
         PlantsVsZombies.setHeadPic(this._node["_dis_headpic"],PlantsVsZombies.getHeadPicUrl(this._p.getFace()),PlantsVsZombies.HEADPIC_MIDDLE,this._p.getVipTime(),this._p.getVipLevel());
      }
      
      private function showIncome() : void
      {
         var isIncome:Function = function():Boolean
         {
            var _loc1_:int = int(FuncKit.currentTimeMillis() / 1000) - _p.getLastAwardTime();
            if(_loc1_ > PossessionNode.CD_TIME)
            {
               return true;
            }
            return false;
         };
         this._income_gold.gotoAndStop(1);
         this._income_gold.visible = false;
         if(Boolean(this._p != null && this._p.getIncome() != 0) && Boolean(isIncome()) && this._p.getOccupyId() == this.playerManager.getPlayer().getId())
         {
            this._income_gold.gotoAndPlay(1);
            this._income_gold.visible = true;
         }
      }
      
      private function showOrg() : void
      {
         var _loc2_:Organism = null;
         var _loc3_:PossessionOrgNode = null;
         if(this._p == null || this._p.getOccupyOrgs() == null || this._p.getOccupyOrgs().length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._p.getOccupyOrgs().length)
         {
            _loc2_ = this._p.getOccupyOrgs()[_loc1_] as Organism;
            _loc3_ = new PossessionOrgNode(_loc2_,this._type,this._index);
            _loc3_.setLoction(this.getOrgLoction(_loc1_,this.getGird(_loc2_)),new Point(this.x,this.y));
            this._fore["_layer_org"].addChild(_loc3_);
            _loc1_++;
         }
      }
      
      private function showOrgTips() : void
      {
         if(this.orgsTipsArr == null)
         {
            this.orgsTipsArr = new Array(2);
         }
         if(!this._p.getOccupyOrgs())
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._p.getOccupyOrgs().length)
         {
            if(this.orgsTipsArr[_loc1_] == null)
            {
               this.orgsTipsArr[_loc1_] = new PossessionOrgTip();
            }
            this.orgsTipsArr[_loc1_].setTip(this._node,this._p.getOccupyOrgs()[_loc1_],PlantsVsZombies._node);
            this.orgsTipsArr[_loc1_].setLoction(this.getTipLoc().x + _loc1_ * 118,this.getTipLoc().y + 52);
            _loc1_++;
         }
      }
      
      private function showTips() : void
      {
         if(this._tip == null)
         {
            this._tip = new PossessionTip();
         }
         this._tip.setTip(this._node,this._p,PlantsVsZombies._node,this._index,this._type);
         this._tip.setLoction(this.getTipLoc().x,this.getTipLoc().y);
         this.showOrgTips();
      }
      
      private function toHelp() : void
      {
         if(this.playerManager.getPlayer().getGrade() <= this._p.getMasterLv() - LV)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession039",LV));
            return;
         }
         if(this.playerManager.getPlayer().getOccupyNum() < 1)
         {
            new PossessionUseAddWindow(this._updatePlayer);
            return;
         }
         new PossessionReadyWindow(this._upDateFun,this._p,true,0,this._p.getCostMoney()).show();
         this._clearAll();
      }
      
      private function toIncome() : void
      {
         this._fport.toIncome(this._p.getPossessionId());
      }
      
      private function toInto() : void
      {
         var _loc1_:Player = new Player();
         _loc1_.setId(this._p.getPossessionId());
         _loc1_.setGrade(this._p.getMasterLv());
         this._changeFun(_loc1_);
      }
      
      private function toOccupation() : void
      {
         if(this.playerManager.getPlayer().getGrade() <= this._p.getMasterLv() - LV)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession016",LV));
            return;
         }
         if(this.playerManager.getPlayer().getLastOccupy() < 1 && this._p.getPossessionId() != this.playerManager.getPlayer().getId())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession017"));
            return;
         }
         if(this.playerManager.getPlayer().getOccupyNum() < 1)
         {
            new PossessionUseAddWindow(this._updatePlayer);
            return;
         }
         new PossessionReadyWindow(this._upDateFun,this._p,false,0,this._p.getCostMoney()).show();
         this._clearAll();
      }
      
      private function toQuit() : void
      {
         if(this.playerManager.getPlayer().getOccupyNum() < 1)
         {
            new PossessionUseAddWindow(this._updatePlayer);
            return;
         }
         new PossessionUseQuitWindow(this._upDateFun,this._p);
      }
      
      private function toRelease() : void
      {
         this._fport.toQuit(this._p.getPossessionId());
      }
   }
}

