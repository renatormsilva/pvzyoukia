package pvz.hunting.fore
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import entity.Goods;
   import entity.Hole;
   import entity.Player;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import loading.UILoading;
   import manager.APLManager;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import manager.VersionManager;
   import node.Icon;
   import pvz.help.HelpNovice;
   import pvz.hunting.rpc.Hunting_rpc;
   import pvz.hunting.window.BattleReadyWindow;
   import pvz.hunting.xml.XmlHunting;
   import pvz.shop.BuyGoodsWindow;
   import pvz.shop.ShopWindow;
   import pvz.shop.rpc.Shop_rpc;
   import tip.HuntingHoleTips;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.ChallengePropWindow;
   import windows.RechargeWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlToolsConfig;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class HuntingForelet extends Sprite implements IDestroy, IURLConnection, IConnection
   {
      
      public static const TYPE_NIGHT:int = 3;
      
      public static const TYPE_NIGHT2:int = 6;
      
      public static const TYPE_NIGHT3:int = 11;
      
      public static const TYPE_PERSONAL:int = 2;
      
      public static const TYPE_PERSONAL2:int = 5;
      
      public static const TYPE_PERSONAL3:int = 8;
      
      public static const TYPE_PERSONAL4:int = 10;
      
      public static const TYPE_PUBLIC:int = 1;
      
      public static const TYPE_PUBLIC2:int = 4;
      
      public static const TYPE_PUBLIC3:int = 7;
      
      public static const TYPE_PUBLIC4:int = 9;
      
      private static var CENTER_X:int = 450;
      
      private static var CENTER_Y:int = 350;
      
      private static const INTO_GRADE:int = 54;
      
      private static const INTO_GRADE2:int = 90;
      
      private static const INTO_GRADE3:int = 116;
      
      private static const INTO_NIGHT_GRADE:int = 30;
      
      private static const INTO_NIGHT_GRADE2:int = 80;
      
      private static var RPC_INIT:int = 3;
      
      private static var RPC_OPENCAVE:int = 1;
      
      private static var RPC_TIMERS:int = 4;
      
      private static var RUSHTIME:int = 60;
      
      private static var URL_UPDATEHOLES:int = 2;
      
      private var _buytoolid:int = 0;
      
      private var _dis:DisplayObjectContainer;
      
      private var _holeNum:int = 0;
      
      private var _holeT:Timer = null;
      
      private var _holes:Array = null;
      
      private var _lastId:int = 0;
      
      private var _mc:MovieClip = null;
      
      private var _tonew:Function = null;
      
      private var _type:int = 0;
      
      private var _uiLoad:UILoading;
      
      private var huntingtip:HuntingHoleTips = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var temp:Class;
      
      public function HuntingForelet()
      {
         super();
      }
      
      public function addPageButtonEvent() : void
      {
         PlantsVsZombies._node["_left"].addEventListener(MouseEvent.CLICK,this.onLeft);
         PlantsVsZombies._node["_right"].addEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      public function changePlayer(param1:Player) : void
      {
         this.allHoleVisibleFalse();
         PlantsVsZombies.showDataLoading(true);
         this.playerManager.setPlayerOther(param1);
         this.showLight(param1);
         PlantsVsZombies.changePlayer_other();
         if(this.playerManager.getPlayer() != this.playerManager.getPlayerOther())
         {
            PlantsVsZombies.setGoHomeButtonVisible(true);
            PlantsVsZombies._node["goHome_btn"].addEventListener(MouseEvent.CLICK,this.onGoHome);
         }
         this._mc.visible = true;
         this.updateHoles();
      }
      
      public function destroy() : void
      {
         this.removePageButtonEvent();
         this.allHoleVisibleFalse();
         this.removeToNewEvent();
         this.clearTip();
      }
      
      public function getHole(param1:int) : Hole
      {
         if(this._holes == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._holes.length)
         {
            if(this._holes[_loc3_] as Hole != null && (this._holes[_loc3_] as Hole).getSid() == param1)
            {
               return this._holes[_loc3_] as Hole;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function huntingUpdate() : void
      {
         this._mc["effect"].gotoAndPlay(1);
         this.updateHoles();
      }
      
      public function loadFriends(param1:Player) : void
      {
         if(this.playerManager.isLoadFriend(param1))
         {
            PlantsVsZombies._friendsWindow.readFriends();
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == RPC_INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == RPC_OPENCAVE)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == RPC_TIMERS)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var share:Function = null;
         var num:int = 0;
         var shoprpc:Shop_rpc = null;
         var type:int = param1;
         var re:Object = param2;
         share = function():void
         {
            JSManager.showShare("share003");
         };
         var huntingrpc:Hunting_rpc = new Hunting_rpc();
         if(type == RPC_OPENCAVE)
         {
            PlantsVsZombies.changeMoneyOrExp(-re.open_money);
            this._holes = huntingrpc.updateHole(this._holes,re);
            this._lastId = huntingrpc.getOpenLastId(re);
            if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
            {
               this.playerManager.getPlayer().setLastHoleId(this._lastId);
            }
            this.showHoles();
            this.updateTime();
            if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
            {
               PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("hunting001"),share);
            }
         }
         else if(type == RPC_TIMERS)
         {
            num = this.getTimesNumById(re.id);
            this._holes = huntingrpc.updateHole(this._holes,re);
            this.showHoles();
            this.updateTime();
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting002",num));
         }
         else if(type == RPC_INIT)
         {
            shoprpc = new Shop_rpc();
            this.showGoodsWindow(shoprpc.getGood(this._buytoolid,re.goods));
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("hunting002"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var _loc3_:XmlHunting = null;
         var _loc4_:ActionWindow = null;
         if(param1 == URL_UPDATEHOLES)
         {
            _loc3_ = new XmlHunting(param2 as String);
            if(!_loc3_.isSuccess())
            {
               if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  PlantsVsZombies.showRushLoading();
                  return;
               }
               _loc4_ = new ActionWindow();
               _loc4_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("hunting003"),_loc3_.error(),null,false);
            }
            else
            {
               this._holes = null;
               this._holes = _loc3_.getHoles();
               this._lastId = _loc3_.getLastId();
               this.playerManager.getPlayer().setLastHoleId(_loc3_.getUserLastId());
               this.showHoles();
               this.updateTime();
            }
         }
      }
      
      public function show(param1:DisplayObjectContainer, param2:int, param3:int, param4:Function) : void
      {
         this._tonew = param4;
         this._type = param2;
         this._holeNum = param3;
         this._dis = param1;
         this.temp = this.getHuntingClass(this._type);
         if(this.temp == null)
         {
            this.doLoad();
         }
         else
         {
            this._mc = new this.temp();
            this._mc.visible = false;
            param1.addChild(this._mc);
            this.initWindowUI();
         }
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addHolesEvent() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < this._holeNum + 1)
         {
            if(this._mc["_mc_hole" + _loc1_] != null)
            {
               this._mc["_mc_hole" + _loc1_].addEventListener(MouseEvent.CLICK,this.onClick);
               this._mc["_mc_hole" + _loc1_].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
               this._mc["_mc_hole" + _loc1_].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
               this._mc["_mc_hole" + _loc1_].buttonMode = true;
            }
            _loc1_++;
         }
      }
      
      private function addToNewEvent() : void
      {
         if(this._type != TYPE_PUBLIC && this._type != TYPE_PERSONAL && this._type != TYPE_NIGHT && this._type != TYPE_NIGHT2 && this._type != TYPE_PERSONAL2 && this._type != TYPE_PERSONAL3 && this._type != TYPE_PUBLIC2 && this._type != TYPE_PUBLIC3)
         {
            this._mc._bt_tonew.visible = false;
         }
         this._mc._bt_tonew.addEventListener(MouseEvent.CLICK,this.onTonew);
      }
      
      private function allHoleVisibleFalse() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < this._holeNum + 1)
         {
            this._mc["_mc_hole" + _loc1_].visible = false;
            this._mc["_mc_hole" + _loc1_].gotoAndStop(1);
            this._mc["_mc_hole" + _loc1_]["arrow"].visible = false;
            this._mc["_mc_jiantou" + _loc1_].visible = false;
            this._mc["_mc_jiantou" + _loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function clearTip() : void
      {
         if(this.huntingtip != null)
         {
            this.huntingtip.visible = false;
         }
      }
      
      private function doLoad() : void
      {
         this._uiLoad = new UILoading(PlantsVsZombies._node,GlobalConstants.PVZ_RES_BASE_URL,"config/load/hunting.xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function effectClose() : void
      {
         this._mc["effect"].gotoAndStop(1);
         this._mc["effect"].visible = false;
         this.allHoleVisibleFalse();
      }
      
      private function effectOpen() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._mc["effect"].visible = true;
         this._mc["effect"].gotoAndPlay(1);
         this.showHoles();
      }
      
      private function getHoleById(param1:int) : Hole
      {
         if(this._holes == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._holes.length)
         {
            if(this._holes[_loc3_] as Hole != null && (this._holes[_loc3_] as Hole).getId() == param1)
            {
               return this._holes[_loc3_] as Hole;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function getHuntingClass(param1:int) : Class
      {
         if(param1 == TYPE_PUBLIC)
         {
            return DomainAccess.getClass("fore_hunting1");
         }
         if(param1 == TYPE_NIGHT || this._type == TYPE_NIGHT2 || this._type == TYPE_NIGHT3)
         {
            return DomainAccess.getClass("fore_hunting2");
         }
         if(param1 == TYPE_PERSONAL)
         {
            return DomainAccess.getClass("fore_hunting1");
         }
         if(param1 == TYPE_PUBLIC2 || param1 == TYPE_PERSONAL2 || param1 == TYPE_PERSONAL3 || param1 == TYPE_PERSONAL4 || param1 == TYPE_PUBLIC3 || param1 == TYPE_PUBLIC4)
         {
            return DomainAccess.getClass("fore_hunting3");
         }
         return null;
      }
      
      private function getPositionX(param1:DisplayObject) : int
      {
         if(param1.x > CENTER_X)
         {
            return this._mc.parent.x - 220;
         }
         return this._mc.parent.x + 80;
      }
      
      private function getPositionY(param1:DisplayObject) : int
      {
         if(param1.y > CENTER_Y)
         {
            return this._mc.parent.y - 150;
         }
         return this._mc.parent.y - 120;
      }
      
      private function getTimesNum(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            _loc2_ = 1 + this.getHole(param1).getCome_time() / 3600;
         }
         else
         {
            _loc2_ = 1 + this.getHole(param1).getMasterTime() / 3600;
         }
         return _loc2_;
      }
      
      private function getTimesNumById(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            _loc2_ = 1 + this.getHoleById(param1).getCome_time() / 3600;
         }
         else
         {
            _loc2_ = 1 + this.getHoleById(param1).getMasterTime() / 3600;
         }
         return _loc2_;
      }
      
      private function getUpdateHoleUrl() : String
      {
         switch(this._type)
         {
            case TYPE_PERSONAL:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private";
            case TYPE_PUBLIC:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/public";
            case TYPE_NIGHT:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private_2";
            case TYPE_NIGHT2:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private_4";
            case TYPE_NIGHT3:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private_6";
            case TYPE_PUBLIC2:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/public_2";
            case TYPE_PERSONAL2:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private_3";
            case TYPE_PERSONAL3:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private_5";
            case TYPE_PERSONAL4:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/private_7";
            case TYPE_PUBLIC3:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/public_3";
            case TYPE_PUBLIC4:
               return "cave/index/id/" + this.playerManager.getPlayerOther().getId() + "/type/public_4";
            default:
               return "";
         }
      }
      
      private function initWindowUI() : void
      {
         this.showHoleJiantou();
         this.addHolesEvent();
         this.addPageButtonEvent();
         this.allHoleVisibleFalse();
         this.addToNewEvent();
         this.clearTip();
         this.changePlayer(this.playerManager.getPlayerOther());
      }
      
      private function judgeHoleEnterTerm(param1:int) : Boolean
      {
         if(this.playerManager.getPlayer() != this.playerManager.getPlayerOther())
         {
            if(this.playerManager.getPlayer().getLastHoleId() < param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onAllComp(param1:ForeletEvent = null) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         this.temp = this.getHuntingClass(this._type);
         this._mc = new this.temp();
         this._mc.visible = false;
         this._dis.addChild(this._mc);
         this._dis = null;
         this.temp = null;
         this.initWindowUI();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var h:Hole;
         var end:Function;
         var id:int = 0;
         var e:MouseEvent = param1;
         var getTimeInfo:Function = function():String
         {
            var _loc5_:String = null;
            var _loc6_:String = null;
            var _loc1_:int = getHole(id).getMasterTime();
            var _loc2_:String = "";
            var _loc3_:int = _loc1_ / 3600;
            if(_loc3_ > 0)
            {
               _loc5_ = _loc3_ + LangManager.getInstance().getLanguage("hunting008");
            }
            else
            {
               _loc5_ = "";
            }
            var _loc4_:int = (_loc1_ - _loc3_ * 3600) / 60;
            if(_loc4_ > 0)
            {
               _loc6_ = _loc4_ + LangManager.getInstance().getLanguage("hunting009");
            }
            else
            {
               _loc6_ = 1 + LangManager.getInstance().getLanguage("hunting009");
            }
            return _loc5_ + _loc6_;
         };
         if(this.huntingtip != null)
         {
            this.huntingtip.visible = false;
         }
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.clear();
         }
         id = int((e.currentTarget.name as String).substring(8));
         h = this.getHole(id);
         if(this.judgeHoleEnterTerm(h.getId()))
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting004"));
            return;
         }
         if(this.playerManager.getPlayer().getNowHunts() == 0)
         {
            new ChallengePropWindow(ChallengePropWindow.TYPE_ONE);
            return;
         }
         if(h.getType() == Hole.ARRIVE)
         {
            end = function():void
            {
               var _loc1_:BattleReadyWindow = new BattleReadyWindow();
               _loc1_.show(getHole(id).getOpenId(),getHole(id).getOrganisms(),huntingUpdate,getHole(id).getAwardsInfo(),effectOpen,getHole(id).getPlayMoney());
            };
            if(this.getHole(id).getMasterTime() > 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting006",getTimeInfo()));
               return;
            }
            if(this.playerManager.getPlayer().getMoney() < this.getHole(id).getPlayMoney())
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting007",this.getHole(id).getPlayMoney()));
               return;
            }
            this.effectClose();
            PlantsVsZombies.playSounds(SoundManager.ZOMBIES);
            DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_BATTLE_READY_WINDOW,end);
         }
         else if(h.getType() == Hole.ARRIVE_NO)
         {
            this.useTimes(id);
         }
         else if(h.getType() == 0)
         {
            this.openHole(h);
         }
      }
      
      private function onGoHome(param1:MouseEvent) : void
      {
         PlantsVsZombies.setGoHomeButtonVisible(false);
         PlantsVsZombies._node["goHome_btn"].removeEventListener(MouseEvent.CLICK,this.onGoHome);
         this.changePlayer(this.playerManager.getPlayer());
         PlantsVsZombies.setToFirstPageButtonVisible(true);
      }
      
      private function onLeft(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden013"));
            return;
         }
         var _loc2_:int = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
         if(_loc2_ < 0)
         {
            return;
         }
         if(_loc2_ == 0)
         {
            PlantsVsZombies._node["back"].visible = true;
            this.changePlayer(this.playerManager.getPlayer());
            PlantsVsZombies.setGoHomeButtonVisible(false);
            return;
         }
         var _loc3_:Player = this.playerManager.getFriendByIndex(_loc2_ - 1);
         if(_loc3_ != null)
         {
            this.changePlayer(_loc3_);
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden013"));
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         var _loc2_:int = int((param1.currentTarget.name as String).substring(8));
         if(this.getHole(_loc2_) == null)
         {
            this._mc["_mc_hole" + _loc2_].gotoAndStop(1);
            return;
         }
         if(this.getHole(_loc2_).getMasterTime() > 0 && this.getHole(_loc2_).getType() == Hole.ARRIVE)
         {
            this._mc["_mc_hole" + _loc2_].gotoAndStop(5);
         }
         else if(this.getHole(_loc2_).getType() != 0)
         {
            this._mc["_mc_hole" + _loc2_].gotoAndStop(this.getHole(_loc2_).getType() * 2 - 1);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:int = int((param1.currentTarget.name as String).substring(8));
         if(this.getHole(_loc2_) == null)
         {
            this._mc["_mc_hole" + _loc2_].gotoAndStop(2);
            return;
         }
         if(this.getHole(_loc2_).getMasterTime() > 0 && this.getHole(_loc2_).getType() == Hole.ARRIVE)
         {
            this._mc["_mc_hole" + _loc2_].gotoAndStop(6);
         }
         else if(this.getHole(_loc2_).getType() != 0)
         {
            this._mc["_mc_hole" + _loc2_].gotoAndStop(this.getHole(_loc2_).getType() * 2);
         }
         this.showHoleTip(this.getHole(_loc2_));
      }
      
      private function onRight(param1:MouseEvent) : void
      {
         var _loc2_:Player = null;
         var _loc3_:int = 0;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.loadFriends(this.playerManager.getPlayerOther());
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            _loc2_ = this.playerManager.getFriendByIndex(0);
            PlantsVsZombies.setGoHomeButtonVisible(false);
         }
         else
         {
            _loc3_ = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
            _loc2_ = this.playerManager.getFriendByIndex(_loc3_ + 1);
         }
         if(_loc2_ != null)
         {
            this.changePlayer(_loc2_);
            PlantsVsZombies.setGoHomeButtonVisible(true);
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden015"));
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._holes.length)
         {
            if((this._holes[_loc2_] as Hole).getType() == Hole.ARRIVE_NO)
            {
               if((this._holes[_loc2_] as Hole).getCome_time() < 0)
               {
                  this.updateHoles();
                  break;
               }
               (this._holes[_loc2_] as Hole).setCome_time((this._holes[_loc2_] as Hole).getCome_time() - RUSHTIME);
            }
            if((this._holes[_loc2_] as Hole).getType() == Hole.ARRIVE)
            {
               if((this._holes[_loc2_] as Hole).getMasterTime() == 0)
               {
                  this.showHoles();
               }
               if((this._holes[_loc2_] as Hole).getMasterTime() >= 0)
               {
                  (this._holes[_loc2_] as Hole).setMasterTime((this._holes[_loc2_] as Hole).getMasterTime() - RUSHTIME);
               }
            }
            _loc2_++;
         }
      }
      
      private function onTonew(param1:MouseEvent) : void
      {
         switch(this._type)
         {
            case TYPE_NIGHT:
               if(this.playerManager.getPlayer().getGrade() < INTO_NIGHT_GRADE)
               {
                  PlantsVsZombies.showSystemErrorInfo("你需要达到" + INTO_NIGHT_GRADE + "级才能进入新地图。");
                  return;
               }
               this._tonew(TYPE_NIGHT2);
               return;
               break;
            case TYPE_NIGHT2:
               if(this.playerManager.getPlayer().getGrade() < INTO_NIGHT_GRADE2)
               {
                  PlantsVsZombies.showSystemErrorInfo("你需要达到" + INTO_NIGHT_GRADE2 + "级才能进入新地图。");
                  return;
               }
               this._tonew(TYPE_NIGHT3);
               return;
               break;
            default:
               if(this.playerManager.getPlayer().getGrade() < INTO_GRADE)
               {
                  PlantsVsZombies.showSystemErrorInfo("你需要达到" + INTO_GRADE + "级才能进入新地图。");
                  return;
               }
               switch(this._type)
               {
                  case TYPE_PUBLIC2:
                  case TYPE_PERSONAL2:
                     if(this.playerManager.getPlayer().getGrade() < INTO_GRADE2)
                     {
                        PlantsVsZombies.showSystemErrorInfo("你需要达到" + INTO_GRADE2 + "级才能进入新地图。");
                        return;
                     }
                     break;
                  case TYPE_PUBLIC3:
                  case TYPE_PERSONAL3:
                     if(this.playerManager.getPlayer().getGrade() < INTO_GRADE3)
                     {
                        PlantsVsZombies.showSystemErrorInfo("你需要达到" + INTO_GRADE3 + "级才能进入新地图。");
                        return;
                     }
               }
               if(this._type == TYPE_PUBLIC)
               {
                  this._tonew(TYPE_PUBLIC2);
                  return;
               }
               if(this._type == TYPE_PERSONAL)
               {
                  this._tonew(TYPE_PERSONAL2);
                  return;
               }
               if(this._type == TYPE_PUBLIC2)
               {
                  this._tonew(TYPE_PUBLIC3);
                  return;
               }
               if(this._type == TYPE_PUBLIC3)
               {
                  this._tonew(TYPE_PUBLIC4);
                  return;
               }
               if(this._type == TYPE_PERSONAL2)
               {
                  this._tonew(TYPE_PERSONAL3);
                  return;
               }
               if(this._type == TYPE_PERSONAL3)
               {
                  this._tonew(TYPE_PERSONAL4);
                  return;
               }
               return;
         }
      }
      
      private function openHole(param1:Hole) : void
      {
         var openHoleC:Function = null;
         var actionWindow:ActionWindow = null;
         var h:Hole = param1;
         openHoleC = function():void
         {
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_HUNTING_OPENCAVE,RPC_OPENCAVE,h.getId());
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(h.getType() == Hole.OPEN_NO)
         {
            if(this.playerManager.getPlayer().getGrade() < h.getOpen_level())
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting010",h.getOpen_level()));
               return;
            }
            if(this.playerManager.getPlayer().getMoney() < h.getOpen_money())
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting011",h.getOpen_money()));
               return;
            }
            if(this.playerManager.getPlayer().getId() != this.playerManager.getPlayerOther().getId())
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting012"));
               return;
            }
            actionWindow = new ActionWindow();
            actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("hunting013"),LangManager.getInstance().getLanguage("hunting014",h.getOpen_money()),openHoleC,true);
         }
      }
      
      private function removeHolesEvent() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < this._holeNum + 1)
         {
            if(this._mc["_mc_hole" + _loc1_] != null)
            {
               this._mc["_mc_hole" + _loc1_].removeEventListener(MouseEvent.CLICK,this.onClick);
               this._mc["_mc_hole" + _loc1_].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
               this._mc["_mc_hole" + _loc1_].removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
               this._mc["_mc_hole" + _loc1_].buttonMode = true;
            }
            _loc1_++;
         }
      }
      
      private function removePageButtonEvent() : void
      {
         PlantsVsZombies._node["_left"].removeEventListener(MouseEvent.CLICK,this.onLeft);
         PlantsVsZombies._node["_right"].removeEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      private function removeToNewEvent() : void
      {
         this._mc._bt_tonew.removeEventListener(MouseEvent.CLICK,this.onTonew);
      }
      
      private function showGoodsWindow(param1:Goods) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc2_:BuyGoodsWindow = new BuyGoodsWindow();
         _loc2_.init(param1,null,ShopWindow.SHOP_RMB,null);
         _loc2_.show();
      }
      
      private function showHole(param1:Hole, param2:int) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.setSid(param2);
         this.showJiantou(param1.getSid(),false);
         if(param1.getType() != Hole.OPEN_NO)
         {
            this._mc["_mc_hole" + param1.getSid()].visible = true;
            this._mc["_mc_hole" + param1.getSid()].gotoAndStop(param1.getType() * 2 - 1);
            if(param1.getType() == Hole.ARRIVE)
            {
               if(param1.getMasterTime() > 0)
               {
                  this._mc["_mc_hole" + param1.getSid()].gotoAndStop(5);
               }
               else if(param1.getId() == this._lastId)
               {
                  this.showJiantou(param1.getSid(),true);
               }
            }
            return;
         }
         if(this._lastId == 0)
         {
            this._mc["_mc_hole1"].visible = true;
            this._mc["_mc_hole1"].gotoAndStop(7);
            if(this._type != TYPE_NIGHT && this._type != TYPE_NIGHT2 && this._type != TYPE_NIGHT3 && this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
            {
               this._mc["_mc_hole1"]["arrow"].visible = true;
            }
            return;
         }
         if(param1.getId() == this._lastId + 1)
         {
            this._mc["_mc_hole" + param1.getSid()].visible = true;
            this._mc["_mc_hole" + param1.getSid()].gotoAndStop(7);
            if(this._type != TYPE_NIGHT && this._type != TYPE_NIGHT2 && this._type != TYPE_NIGHT3)
            {
               if(this.playerManager.getPlayer().getGrade() >= param1.getOpen_level() && this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
               {
                  this._mc["_mc_hole" + param1.getSid()]["arrow"].visible = true;
               }
            }
         }
      }
      
      private function showHoleJiantou() : void
      {
         this._mc["_mc_jiantou"].visible = false;
         if(this._type == TYPE_PERSONAL || this._type == TYPE_PUBLIC)
         {
            if(this.playerManager.getPlayer().getGrade() >= INTO_GRADE)
            {
               this._mc["_mc_jiantou"].visible = true;
            }
            return;
         }
         if(this._type == TYPE_PERSONAL2 || this._type == TYPE_PUBLIC2)
         {
            if(this.playerManager.getPlayer().getGrade() >= INTO_GRADE2)
            {
               this._mc["_mc_jiantou"].visible = true;
            }
            return;
         }
         if(this._type == TYPE_PUBLIC3 || this._type == TYPE_PERSONAL3)
         {
            if(this.playerManager.getPlayer().getGrade() >= INTO_GRADE3)
            {
               this._mc["_mc_jiantou"].visible = true;
            }
            return;
         }
      }
      
      private function showHoleTip(param1:Hole) : void
      {
         var _loc2_:int = param1.getSid();
         this.clearTip();
         if(this.playerManager.getPlayerOther() != null && this.playerManager.getPlayer() != this.playerManager.getPlayerOther() && param1.getMasterTime() > 0 && param1.getType() == Hole.ARRIVE)
         {
            this.huntingtip = new HuntingHoleTips(param1,false);
         }
         else
         {
            this.huntingtip = new HuntingHoleTips(param1,true);
         }
         if(param1.getType() == Hole.ARRIVE_NO)
         {
            this.huntingtip.setTooltip(this._mc["_mc_hole" + _loc2_],param1);
            this.huntingtip.setLoction(this.getPositionX(this._mc["_mc_hole" + _loc2_]),this.getPositionY(this._mc["_mc_hole" + _loc2_]) + 50);
         }
         else if(param1.getType() == Hole.ARRIVE)
         {
            this.huntingtip.setTooltip(this._mc["_mc_hole" + _loc2_],param1);
            this.huntingtip.setLoction(this.getPositionX(this._mc["_mc_hole" + _loc2_]),this.getPositionY(this._mc["_mc_hole" + _loc2_]));
         }
         else if(param1.getType() == Hole.OPEN_NO)
         {
            return;
         }
      }
      
      private function showHoles() : void
      {
         if(this._holes == null)
         {
            return;
         }
         this.allHoleVisibleFalse();
         var _loc1_:int = 0;
         while(_loc1_ < this._holes.length)
         {
            this.showHole(this._holes[_loc1_],_loc1_ + 1);
            _loc1_++;
         }
         PlantsVsZombies.showDataLoading(false);
         this.showToOtherHunting();
      }
      
      private function showJiantou(param1:int, param2:Boolean) : void
      {
         if(param2 && !GlobalConstants.NEW_PLAYER)
         {
            this._mc["_mc_jiantou" + param1].gotoAndPlay(1);
         }
         else
         {
            this._mc["_mc_jiantou" + param1].gotoAndStop(1);
         }
         this._mc["_mc_jiantou" + param1].visible = param2;
      }
      
      private function showLight(param1:Player) : void
      {
         PlantsVsZombies._node["_left_light"].visible = false;
         PlantsVsZombies._node["_right_light"].visible = false;
         if(this.playerManager.getPlayer().getGrade() < 3)
         {
            return;
         }
         if(this._type == TYPE_PERSONAL || this._type == TYPE_NIGHT || this._type == TYPE_NIGHT2 || this._type == TYPE_NIGHT3 || this._type == TYPE_PERSONAL2 || this._type == TYPE_PERSONAL3 || this._type == TYPE_PERSONAL4)
         {
            return;
         }
         if(this.playerManager.getPlayer() != this.playerManager.getPlayerOther())
         {
            PlantsVsZombies._node["_left_light"].visible = true;
         }
         var _loc2_:int = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
         var _loc3_:Player = this.playerManager.getFriendByIndex(_loc2_ + 1);
         if(_loc3_ != null)
         {
            PlantsVsZombies._node["_right_light"].visible = true;
         }
      }
      
      private function showToOtherHunting() : void
      {
         PlantsVsZombies._node._toOtherHunting.visible = false;
         var _loc1_:int = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
         var _loc2_:Player = this.playerManager.getFriendByIndex(_loc1_ + 1);
         if(_loc2_ == null)
         {
            return;
         }
         if(this._holes == null || this._type == TYPE_PERSONAL || this._type == TYPE_NIGHT || this._type == TYPE_NIGHT2 || this._type == TYPE_NIGHT3 || this._type == TYPE_PERSONAL2 || this._type == TYPE_PERSONAL3 || this._type == TYPE_PERSONAL4)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._holes.length)
         {
            if((this._holes[_loc3_] as Hole).getType() == Hole.ARRIVE)
            {
               return;
            }
            _loc3_++;
         }
         if(this.playerManager.getPlayer().getGrade() < 3)
         {
            return;
         }
         PlantsVsZombies._node._toOtherHunting.visible = true;
      }
      
      private function updateHoles() : void
      {
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.showDataLoading(false);
            this._holes = null;
            this._holes = PlantsVsZombies.helpN.getHuntingHoles();
            this._lastId = 2;
            this.showHoles();
            this.updateTime();
            PlantsVsZombies.helpN.show(HelpNovice.HUNTING_ENTER_BATTLEREADY,PlantsVsZombies._node as DisplayObjectContainer);
            PlantsVsZombies.helpN.show(HelpNovice.HUNTING_ENTER_FIRST,PlantsVsZombies._node as DisplayObjectContainer);
            return;
         }
         this.urlloaderSend(PlantsVsZombies.getURL(this.getUpdateHoleUrl()),URL_UPDATEHOLES);
      }
      
      private function updateTime() : void
      {
         if(this._holes == null)
         {
            return;
         }
         if(this._holeT != null)
         {
            this._holeT.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._holeT.stop();
            this._holeT = null;
         }
         this._holeT = new Timer(RUSHTIME * 1000);
         this._holeT.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._holeT.start();
      }
      
      private function useTimes(param1:int) : void
      {
         var actionWindow:ActionWindow;
         var hour:int = 0;
         var tool:Tool = null;
         var sendUseTimes:Function = null;
         var buyTool:Function = null;
         var rechargeWindow:RechargeWindow = null;
         var id:int = param1;
         sendUseTimes = function():void
         {
            playerManager.getPlayer().useTools(tool.getOrderId(),hour);
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_HUNTING_TIMES,RPC_TIMERS,getHole(id).getOpenId());
         };
         buyTool = function():void
         {
            PlantsVsZombies.showDataLoading(true);
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,RPC_INIT);
         };
         hour = this.getTimesNum(id);
         tool = new Tool(ToolManager.TIMES);
         if(this.playerManager.getPlayer().getTool(ToolManager.TIMES) == null || this.playerManager.getPlayer().getTool(ToolManager.TIMES).getNum() < hour)
         {
            if(this.playerManager.getPlayer().getGrade() < ShopWindow.SHOP_GRADE)
            {
               return;
            }
            this._buytoolid = tool.getOrderId();
            rechargeWindow = new RechargeWindow();
            rechargeWindow.init(LangManager.getInstance().getLanguage("hunting015",hour,tool.getName()),buyTool,RechargeWindow.BUY);
            return;
         }
         actionWindow = new ActionWindow();
         actionWindow.init(XmlToolsConfig.getInstance().getToolAttribute(ToolManager.TIMES).getPicId(),Icon.TOOL,LangManager.getInstance().getLanguage("hunting003"),LangManager.getInstance().getLanguage("hunting016",hour),sendUseTimes,true);
      }
   }
}

