package pvz.invitePrizes
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import constants.URLConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.FriendPrizeInfo;
   import entity.InvitePrize;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import labels.InvitePrizeKindsArenaLabel;
   import labels.InvitePrizeKindsFriendLabel;
   import labels.InvitePrizeKindsInviteLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import pvz.EveryDayPrize;
   import pvz.arena.entity.ArenaPrize;
   import pvz.arena.rpc.Arena_rpc;
   import pvz.invitePrizes.data.ActiveData;
   import pvz.invitePrizes.data.ConsumeData;
   import pvz.invitePrizes.events.LimitPrizeEvent;
   import pvz.invitePrizes.events.PrizeEvent;
   import pvz.invitePrizes.labels.ActivityLabel;
   import pvz.invitePrizes.labels.ConsumeLabel;
   import pvz.invitePrizes.labels.LimitPrizeLabel;
   import pvz.invitePrizes.labels.PrizeLabel;
   import pvz.vip.AutoRegister;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import xmlReader.XmlBaseReader;
   import xmlReader.firstPage.XmlInvitePrizeInvite;
   import zlib.utils.DomainAccess;
   
   public class InvitePrizeWindow extends BaseWindow implements IURLConnection, IConnection
   {
      
      private static var INFO_ACTIVE:int;
      
      public static const ARENA:int = 3;
      
      public static const ARENA_NUM:int = 4;
      
      public static const FRIEND:int = 2;
      
      public static const FRIEND_NUM:int = 5;
      
      public static const INVITE:int = 1;
      
      public static const INVITE_MAXNUM:int = 20;
      
      public static const INVITE_NUM:int = 4;
      
      private static const ACTIVATE_CODE_EXCHANGE:int = 8;
      
      private static const CONSUME_NUM:int = 4;
      
      private static const INFO_ARENA:int = 3;
      
      private static var INFO_CONSUME:int = 4;
      
      private static const INFO_FRIENDS:int = 1;
      
      private static const INFO_INVITE:int = 2;
      
      internal var _arenaPrizes:Array = null;
      
      internal var _friendPrizes:Array = null;
      
      internal var _invitePirzes:Array = null;
      
      internal var _isGetArenaPrize:Boolean = false;
      
      internal var _maxPage:int = 1;
      
      internal var _nowArray:Array;
      
      internal var _nowPage:int = 1;
      
      internal var _type:int = 0;
      
      internal var _window:MovieClip;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var EVERYDAY_PRIZE:int = 4;
      
      private var _activePrizeArr:Array;
      
      private var _arrStore:Array = [];
      
      private var _consumePrizeCurPage:int;
      
      private var _consumePrizeData:Object;
      
      private var _consumePrizeMaxPage:int;
      
      private var activeData:ActiveData;
      
      private var activeType:int;
      
      private var active_txt:TextField;
      
      private var consumeData:ConsumeData;
      
      private var consumeText:TextField;
      
      private var getPrizeType:String;
      
      private var isActivityContinueText:TextField;
      
      private var isFristEnter:Boolean;
      
      private var judeActiveA:Boolean;
      
      private var judeActiveB:Boolean;
      
      private var maxNum:int;
      
      private var time:String;
      
      private var _limitPrizeMaxPage:int;
      
      private var _currentLimitPrizePage:int = 1;
      
      private var _limitPrizeData:Object;
      
      public function InvitePrizeWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("invitePrizeWindow");
         this._window = new _loc1_();
         this._window.visible = false;
      }
      
      private function getBoxId(param1:int) : int
      {
         if(param1 % 4 == 0)
         {
            return 577;
         }
         if(param1 % 4 == 1)
         {
            return 578;
         }
         if(param1 % 4 == 2)
         {
            return 579;
         }
         if(param1 % 4 == 3)
         {
            return 580;
         }
         return 577;
      }
      
      private function layoutLimitPrize(param1:Object) : void
      {
         this.setLeftButtonVisible(false);
         this.setRightButtonVisible(false);
         this._limitPrizeData = param1;
         if(this.active_txt == null)
         {
            this.active_txt = new TextField();
         }
         if(this.isActivityContinueText == null)
         {
            this.isActivityContinueText = new TextField();
         }
         this._window.activeKind.addChild(this.isActivityContinueText);
         this._window.activeKind.addChild(this.active_txt);
         this._window.activeKind["time"].text = FuncKit.getFullYearAndTime(param1["start"]) + "-" + FuncKit.getFullYearAndTime(param1["end"]);
         this.makeupActivityContinueText(param1["actived"]);
         this._window["getPrizeBtn"].gotoAndStop(param1["has_reward"] + 1);
         if(param1["has_reward"] == 0)
         {
            this._window["getPrizeBtn"].buttonMode = false;
            this._window["getPrizeBtn"].mouseEnabled = false;
         }
         else
         {
            this._window["getPrizeBtn"].buttonMode = true;
            this._window["getPrizeBtn"].mouseEnabled = true;
         }
         var _loc2_:int = int(param1["reward"].length);
         this._limitPrizeMaxPage = _loc2_ % CONSUME_NUM > 0 ? int(_loc2_ / CONSUME_NUM + 1) : int(_loc2_ / CONSUME_NUM);
         this._currentLimitPrizePage = 1;
         if(this._limitPrizeMaxPage > 1 && this._currentLimitPrizePage != this._limitPrizeMaxPage)
         {
            this.setRightButtonVisible(true);
         }
         if(this._currentLimitPrizePage > 1)
         {
            this.setLeftButtonVisible(true);
         }
         this.updateLimitBox();
      }
      
      private function updateLimitBox() : void
      {
         var _loc1_:LimitPrizeLabel = null;
         var _loc2_:int = 0;
         this._arrStore = [];
         while(this._window.activeKind["labelcon"].numChildren > 0)
         {
            this._window.activeKind["labelcon"].removeChildAt(0);
         }
         while(this._window.activeKind["con"].numChildren > 0)
         {
            this._window.activeKind["con"].removeChildAt(0);
         }
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = (this._currentLimitPrizePage - 1) * 4 + _loc3_;
            if(!this._limitPrizeData["reward"][_loc2_])
            {
               break;
            }
            _loc1_ = new LimitPrizeLabel(this.getBoxId(_loc2_));
            _loc1_.setNum(this._limitPrizeData["reward"][_loc2_]["money"]);
            _loc1_.setData(this._limitPrizeData["reward"][_loc2_]["content"]);
            _loc1_.setLabelStats(this._limitPrizeData["reward"][_loc2_]);
            this._arrStore.push(_loc1_);
            _loc1_.x = _loc3_ * (_loc1_.x + 160) + 20;
            _loc1_.y = 50;
            this._window.activeKind["labelcon"].addChild(_loc1_);
            _loc1_.addEventListener(LimitPrizeEvent.PRIZE_EVENT,this.onLimitPrizeHandler);
            _loc3_++;
         }
      }
      
      public function layoutActiveCard(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:ActivityLabel = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.getPrizeType == "active_c")
         {
            this.layoutLimitPrize(param1);
         }
         else
         {
            this._arrStore = [];
            this.judgeLightEffect(param1["getType"]);
            _loc2_ = param1["type"];
            _loc4_ = [];
            if(this.active_txt == null)
            {
               this.active_txt = new TextField();
            }
            if(this.isActivityContinueText == null)
            {
               this.isActivityContinueText = new TextField();
            }
            this._window.activeKind.addChild(this.isActivityContinueText);
            this._window.activeKind.addChild(this.active_txt);
            this.makeupActivityContinueText(param1["actived"]);
            if(_loc2_ == "a")
            {
               this.doWithClue(_loc2_,param1["money"]);
            }
            else if(_loc2_ == "b")
            {
               this.doWithClue(_loc2_,param1["money"],param1["curMoney"]);
            }
            this._window.activeKind["time"].text = param1["start"] + "-" + param1["end"];
            this._window["getPrizeBtn"].gotoAndStop(param1["getType"] + 1);
            if(param1["getType"] == 0)
            {
               this._window["getPrizeBtn"].buttonMode = false;
               this._window["getPrizeBtn"].mouseEnabled = false;
            }
            else
            {
               this._window["getPrizeBtn"].buttonMode = true;
               this._window["getPrizeBtn"].mouseEnabled = true;
            }
            _loc5_ = int(param1["storeObject"].length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ = new ActivityLabel(param1["storeObject"][_loc6_]["id"]);
               _loc3_.setNum(param1["storeObject"][_loc6_]["money"]);
               _loc3_.setData(param1["storeObject"][_loc6_]["content"]);
               this._arrStore.push(_loc3_);
               if(_loc6_ == 0)
               {
                  _loc3_.setType(2);
                  this.showFristPrize(param1["storeObject"][_loc6_]["content"]);
               }
               if(_loc2_ == "a")
               {
                  _loc3_.x = 200 + _loc6_ * (_loc3_.x + 180);
               }
               else if(_loc2_ == "b")
               {
                  _loc3_.x = _loc6_ * (_loc3_.x + 160) + 20;
               }
               _loc3_.y = 50;
               this._window.activeKind["labelcon"].addChild(_loc3_);
               _loc3_.addEventListener(PrizeEvent.PRIZE_EVENT,this.onActiveChange);
               _loc6_++;
            }
         }
      }
      
      protected function onLimitPrizeHandler(param1:LimitPrizeEvent) : void
      {
         var _loc2_:Tool = null;
         var _loc3_:PrizeLabel = null;
         while(this._window.activeKind["con"].numChildren > 0)
         {
            this._window.activeKind["con"].removeChildAt(0);
         }
         var _loc4_:int = int(this._arrStore.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this._arrStore[_loc5_].getId() == param1.boxid)
            {
               if(this._arrStore[_loc5_].isGet)
               {
                  this._arrStore[_loc5_].setType(4);
               }
               else
               {
                  this._arrStore[_loc5_].setType(3);
               }
            }
            else if(!this._arrStore[_loc5_].isGetton())
            {
               if(this._arrStore[_loc5_].isGet)
               {
                  this._arrStore[_loc5_].setType(2);
               }
               else
               {
                  this._arrStore[_loc5_].setType(1);
               }
            }
            _loc5_++;
         }
         var _loc6_:int = int(param1.prizeObject["data"].length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = new Tool(param1.prizeObject["data"][_loc7_]["id"]);
            _loc2_.setNum(param1.prizeObject["data"][_loc7_]["num"]);
            _loc3_ = new PrizeLabel(_loc2_);
            _loc3_.x = _loc7_ * (_loc3_.x + 140) + 20;
            this._window.activeKind["con"].addChild(_loc3_);
            _loc7_++;
         }
      }
      
      private function onConsumeChange(param1:PrizeEvent) : void
      {
         var _loc2_:Tool = null;
         var _loc3_:PrizeLabel = null;
         while(this._window.consumeKind["con"].numChildren > 0)
         {
            this._window.consumeKind["con"].removeChildAt(0);
         }
         var _loc4_:int = int(this._arrStore.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this._arrStore[_loc5_].getId() == param1.prizeObject["id"])
            {
               if(this._arrStore[_loc5_].isCanGet)
               {
                  this._arrStore[_loc5_].changeThisState(4);
               }
               else
               {
                  this._arrStore[_loc5_].changeThisState(3);
               }
            }
            else
            {
               this._arrStore[_loc5_].changeThisState(this._arrStore[_loc5_].preType);
            }
            _loc5_++;
         }
         var _loc6_:int = int(param1.prizeObject["data"].length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = new Tool(param1.prizeObject["data"][_loc7_]["id"]);
            _loc2_.setNum(param1.prizeObject["data"][_loc7_]["num"]);
            _loc3_ = new PrizeLabel(_loc2_);
            _loc3_.x = _loc7_ * (_loc3_.width + 8);
            this._window.consumeKind["con"].addChild(_loc3_);
            _loc7_++;
         }
      }
      
      public function layoutConsumeLabel(param1:Object) : void
      {
         var _loc2_:ConsumeLabel = null;
         this._consumePrizeData = param1;
         this._window["getPrizeBtn"].gotoAndStop(param1["getType"] + 1);
         if(param1["getType"] == 0)
         {
            this._window["getPrizeBtn"].buttonMode = false;
            this._window["getPrizeBtn"].mouseEnabled = false;
         }
         else
         {
            this._window["getPrizeBtn"].buttonMode = true;
            this._window["getPrizeBtn"].mouseEnabled = true;
         }
         while(this._window.consumeKind["con"].numChildren > 0)
         {
            this._window.consumeKind["con"].removeChildAt(0);
         }
         while(this._window.consumeKind["labelcon"].numChildren > 0)
         {
            this._window.consumeKind["labelcon"].removeChildAt(0);
         }
         var _loc3_:int = int(param1["storeObject"].length);
         this._consumePrizeMaxPage = _loc3_ % CONSUME_NUM > 0 ? int(_loc3_ / CONSUME_NUM + 1) : int(_loc3_ / CONSUME_NUM);
         if(this._consumePrizeMaxPage > 1 && this._consumePrizeCurPage != this._consumePrizeMaxPage)
         {
            this.setRightButtonVisible(true);
         }
         this.updateConsumeBox();
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INFO_ARENA)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == this.EVERYDAY_PRIZE)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == ACTIVATE_CODE_EXCHANGE)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var back:Function;
         var a_rpc:Arena_rpc = null;
         var everyDayWindow:EveryDayPrize = null;
         var alert:AutoRegister = null;
         var type:int = param1;
         var re:Object = param2;
         PlantsVsZombies.showDataLoading(false);
         if(type == INFO_ARENA)
         {
            a_rpc = new Arena_rpc();
            this._arenaPrizes = a_rpc.getWeekPrize(re);
            this._nowPage = 1;
            if(this._arenaPrizes.length > 0)
            {
               this._maxPage = (this._arenaPrizes.length - 1) / ARENA_NUM + 1;
            }
            else
            {
               this._maxPage = 1;
            }
            if(re.rank.is_reward == "1")
            {
               this._isGetArenaPrize = true;
            }
            this.addArenaGrade(re.rank.grade);
            if(this._window._kinds_arena["_pic_rank"].numChildren > 1)
            {
               FuncKit.clearAllChildrens(this._window._kinds_arena["_pic_rank"]);
            }
            if(re.rank.rank == 0)
            {
               this._window._kinds_arena["_mc_no"].visible = true;
            }
            else
            {
               this._window._kinds_arena["_pic_rank"].addChild(FuncKit.getNumEffect(re.rank.rank + "","Red"));
               this._window._kinds_arena["_mc_no"].visible = false;
            }
            this._window._kinds_arena["_txt_lastdate"].text = this.playerManager.getPlayer().getLastArenaDate();
            this.setPage();
            this.doArenaLoyout();
         }
         else if(type == this.EVERYDAY_PRIZE)
         {
            back = function():void
            {
               playerManager.getPlayer().setMoney(int(re) + playerManager.getPlayer().getMoney());
               PlantsVsZombies.setUserInfos();
               PlantsVsZombies.firstpage.setPrizeLightEffect();
            };
            everyDayWindow = new EveryDayPrize(back);
            this.playerManager.getPlayer().setEveryDayPrize(int(re));
            everyDayWindow.show(int(re));
         }
         else if(type == ACTIVATE_CODE_EXCHANGE)
         {
            alert = new AutoRegister(null);
            alert.showStr(re.msg);
            if(this._window._activate_panel.change_btn.currentFrame == 2)
            {
               this._window._activate_panel.change_btn.addEventListener(MouseEvent.CLICK,this.onExchange);
            }
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param1 == ACTIVATE_CODE_EXCHANGE)
         {
            if(this._window._activate_panel.change_btn.currentFrame == 2)
            {
               this._window._activate_panel.change_btn.addEventListener(MouseEvent.CLICK,this.onExchange);
            }
         }
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var _loc3_:XmlInvitePrizeInvite = null;
         if(param1 == INFO_FRIENDS)
         {
            PlantsVsZombies.showDataLoading(false);
            _loc3_ = new XmlInvitePrizeInvite(param2 as String);
            if(_loc3_.isSuccess())
            {
               this._friendPrizes = this.sortFriends(_loc3_.getFriendPrizeFriends());
               this._nowPage = 1;
               if(this._friendPrizes.length > 0)
               {
                  this._maxPage = (this._friendPrizes.length - 1) / FRIEND_NUM + 1;
               }
               else
               {
                  this._window._kinds_friend._t.visible = true;
                  this._maxPage = 1;
               }
               this.setPage();
               this.doFriendLoyout();
            }
            else
            {
               if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  PlantsVsZombies.showRushLoading();
                  return;
               }
               this.hidden();
               PlantsVsZombies.showSystemErrorInfo(_loc3_.error());
            }
         }
         else if(param1 == INFO_INVITE)
         {
            PlantsVsZombies.showDataLoading(false);
            _loc3_ = new XmlInvitePrizeInvite(param2 as String);
            if(_loc3_.isSuccess())
            {
               this._invitePirzes = _loc3_.getInviteRule();
               this.setLoction();
               this.toInvite();
            }
            else
            {
               if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  PlantsVsZombies.showRushLoading();
                  return;
               }
               this.hidden();
               PlantsVsZombies.showSystemErrorInfo(_loc3_.error());
            }
         }
      }
      
      public function show(param1:int = 1) : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._window);
         this._window.visible = true;
         onShowEffect(this._window);
         this.setLoction();
         this.addButtonEvent();
         this.setLeftButtonVisible(false);
         this.setRightButtonVisible(false);
         this.initWindow(param1);
      }
      
      public function showActiveToolsPrizes(param1:Object = null, param2:int = 0) : void
      {
         var str:String = null;
         var back:Function = null;
         var prize:Object = param1;
         var type:int = param2;
         back = function():void
         {
            PlantsVsZombies.firstpage.setPrizeLightEffect();
            _window["getPrizeBtn"].gotoAndStop(1);
            _window["getPrizeBtn"].buttonMode = false;
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("invitePrize003",str));
            if(getPrizeType == "active_a")
            {
               activeData.initActiveData(ActiveData.PRIZE_A);
            }
            else if(getPrizeType == "active_b")
            {
               activeData.initActiveData(ActiveData.PRIZE_B);
            }
            else if(getPrizeType == "active_c")
            {
               activeData.initActiveData(ActiveData.PRIZE_C);
            }
         };
         var toolsWindow:PrizeWindow = new PrizeWindow(PlantsVsZombies._node as MovieClip);
         if(type == 1)
         {
            toolsWindow.show(this.getToolsByPrezes(prize["content"]),back);
         }
         else
         {
            toolsWindow.show(this.getToolsByPrezes(prize["tools"]),back);
         }
         if(type == 1)
         {
            str = FuncKit.getDay(prize["start"]) + "-" + FuncKit.getDay(prize["end"]);
         }
         else
         {
            str = prize["start"] + "-" + prize["end"];
         }
      }
      
      public function showConsumeToolsPrizes(param1:Array) : void
      {
         var back:Function = null;
         var prize:Array = param1;
         back = function():void
         {
            PlantsVsZombies.firstpage.setPrizeLightEffect();
            consumeData.initConsumeData();
         };
         var toolsWindow:PrizeWindow = new PrizeWindow(PlantsVsZombies._node as MovieClip);
         toolsWindow.show(this.getToolsByPrezes(prize),back);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addArenaGrade(param1:int) : void
      {
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         var _loc4_:MovieClip = new _loc2_();
         if(param1 >= 100)
         {
            this._window._kinds_arena["uplevel"].x = 440;
            this._window._kinds_arena["uplevel"].y = 20;
            this._window._kinds_arena["uplevel"].gotoAndStop(2);
            if(this._window._kinds_arena["uplevel"].numChildren > 1)
            {
               FuncKit.clearAllChildrens(this._window._kinds_arena["uplevel"]);
            }
            this._window._kinds_arena["uplevel"].addChild(GetDomainRes.get100levelUpsp(100));
            return;
         }
         this._window._kinds_arena["uplevel"].gotoAndStop(1);
         var _loc5_:int = int(param1 / 10) * 10;
         if(_loc5_ == 0)
         {
            _loc5_ = 1;
         }
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + _loc5_));
         _loc4_["num"].addChild(FuncKit.getNumEffect("" + (int(param1 / 10) * 10 + 9)));
         if(this._window._kinds_arena["uplevel"]["_pic_lv_1"].numChildren > 1)
         {
            FuncKit.clearAllChildrens(this._window._kinds_arena["uplevel"]["_pic_lv_1"]);
         }
         _loc3_.x = -_loc3_.width;
         this._window._kinds_arena["uplevel"]["_pic_lv_1"].addChild(_loc3_);
         if(this._window._kinds_arena["uplevel"]["_pic_lv_2"].numChildren > 1)
         {
            FuncKit.clearAllChildrens(this._window._kinds_arena["uplevel"]["_pic_lv_2"]);
         }
         this._window._kinds_arena["uplevel"]["_pic_lv_2"].addChild(_loc4_);
      }
      
      private function addButtonEvent() : void
      {
         this._window._button_1.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_2.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_3.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_4.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_5.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_6.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._cancel.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["recharge"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["getPrizeBtn"].addEventListener(MouseEvent.CLICK,this.onGetPrizeClick);
         this._window["getPrizeBtn"].addEventListener(MouseEvent.MOUSE_OVER,this.onGetPrizeOver);
         this._window["getPrizeBtn"].addEventListener(MouseEvent.MOUSE_OUT,this.onGetPrizeOut);
         this._window["prenext"]._add.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["prenext"]._dec.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addInviteAmountNum() : void
      {
         if(this._window._kinds_invite._invite_amount_num != null && this._window._kinds_invite._invite_amount_num.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window._kinds_invite._invite_amount_num);
         }
         this._window._kinds_invite._invite_amount_num.addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getInviteAmount() + ""));
         if(this._window._kinds_invite._num != null && this._window._kinds_invite._num.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window._kinds_invite._num);
         }
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.playerManager.getPlayer().getUseInviteNum() + "","Middle");
         _loc1_.x = -_loc1_.width / 2;
         this._window._kinds_invite._num.addChild(_loc1_);
      }
      
      private function clearPrizeNode() : void
      {
         while(this._window.activeKind["con"].numChildren > 0)
         {
            this._window.activeKind["con"].removeChildAt(0);
         }
         while(this._window.activeKind["labelcon"].numChildren > 0)
         {
            this._window.activeKind["labelcon"].removeChildAt(0);
         }
         while(this._window.consumeKind["con"].numChildren > 0)
         {
            this._window.consumeKind["con"].removeChildAt(0);
         }
         while(this._window.consumeKind["labelcon"].numChildren > 0)
         {
            this._window.consumeKind["labelcon"].removeChildAt(0);
         }
      }
      
      private function clickEvenryDayPrize(param1:MouseEvent) : void
      {
         this.setBtnFlase();
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_EVERYDAY_PRIZE,this.EVERYDAY_PRIZE);
      }
      
      private function doArenaLoyout() : void
      {
         if(this._window._kinds_arena._infos != null)
         {
            FuncKit.clearAllChildrens(this._window._kinds_arena._infos);
         }
         this.initArray(this._arenaPrizes.slice((this._nowPage - 1) * ARENA_NUM,this._nowPage * ARENA_NUM));
         if(this._nowArray == null || this._nowArray.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._nowArray.length)
         {
            this._window._kinds_arena._infos.addChild(this._nowArray[_loc1_]);
            this._nowArray[_loc1_].x = _loc1_ * (this._nowArray[_loc1_].width + 6) + 14;
            this._nowArray[_loc1_].y = 65;
            _loc1_++;
         }
      }
      
      private function doFriendLoyout() : void
      {
         if(this._window._kinds_friend._infos != null)
         {
            FuncKit.clearAllChildrens(this._window._kinds_friend._infos);
         }
         this.initArray(this._friendPrizes.slice((this._nowPage - 1) * FRIEND_NUM,this._nowPage * FRIEND_NUM));
         if(this._nowArray == null || this._nowArray.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._nowArray.length)
         {
            this._window._kinds_friend._infos.addChild(this._nowArray[_loc1_]);
            this._nowArray[_loc1_].y = _loc1_ * this._nowArray[_loc1_].height + 12 + 50;
            this._nowArray[_loc1_].x = 11;
            _loc1_++;
         }
      }
      
      private function doInviteLoyout() : void
      {
         if(this._window._kinds_invite._infos != null)
         {
            FuncKit.clearAllChildrens(this._window._kinds_invite._infos);
         }
         this.initArray(this._invitePirzes.slice((this._nowPage - 1) * INVITE_NUM,this._nowPage * INVITE_NUM));
         if(this._nowArray == null || this._nowArray.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._nowArray.length)
         {
            this._window._kinds_invite._infos.addChild(this._nowArray[_loc1_]);
            this._nowArray[_loc1_].x = _loc1_ * (this._nowArray[_loc1_].width + 6) + 14;
            this._nowArray[_loc1_].y = 65;
            _loc1_++;
         }
      }
      
      private function doLayout() : void
      {
         if(this._type == INVITE)
         {
            this.doInviteLoyout();
         }
         else if(this._type == FRIEND)
         {
            this.doFriendLoyout();
         }
         else if(this._type == ARENA)
         {
            this.doArenaLoyout();
         }
      }
      
      private function doWithClue(param1:String, param2:int, param3:int = 0) : void
      {
         if(param1 == "a")
         {
            if(param2 == 0)
            {
               this.active_txt.htmlText = "";
            }
            else
            {
               this.active_txt.htmlText = "<font color=\'#cc0000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize005",param2) + "</b></font>";
            }
         }
         else if(param1 == "b")
         {
            if(param2 == 0)
            {
               if(param3 == 0)
               {
                  this.active_txt.htmlText = "";
                  return;
               }
               this.active_txt.htmlText = "<font color=\'#cc0000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize006",param3) + "</b></font>";
            }
            else
            {
               this.active_txt.htmlText = "<font color=\'#cc0000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize005",param2) + "</b></font>";
            }
         }
         this.active_txt.width = this.active_txt.textWidth + 10;
         this.active_txt.height = this.active_txt.textHeight + 4;
         this.active_txt.x = this.isActivityContinueText.x + this.isActivityContinueText.width;
         this.active_txt.y = this.isActivityContinueText.y;
      }
      
      private function everyDayMouseOut(param1:MouseEvent) : void
      {
         if(this.playerManager.getPlayer().getRewardDaily() == 1)
         {
            this._window.activeKind["evrDay"].gotoAndStop(2);
         }
      }
      
      private function everyDayMouseOver(param1:MouseEvent) : void
      {
         if(this.playerManager.getPlayer().getRewardDaily() == 1)
         {
            this._window.activeKind["evrDay"].gotoAndStop(3);
         }
      }
      
      private function getToolsByPrezes(param1:Array) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Tool(param1[_loc3_].id);
            _loc4_.setNum(param1[_loc3_].num);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function hidden() : void
      {
         this.removeEvent();
         onHiddenEffect(this._window);
      }
      
      private function initArray(param1:Array) : void
      {
         var _loc3_:InvitePrizeKindsInviteLabel = null;
         var _loc4_:InvitePrizeKindsFriendLabel = null;
         var _loc5_:InvitePrizeKindsArenaLabel = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         this._nowArray = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(this._type == INVITE)
            {
               _loc3_ = new InvitePrizeKindsInviteLabel();
               _loc3_.setInfo(param1[_loc2_] as InvitePrize,this.addInviteAmountNum);
               this._nowArray.push(_loc3_);
            }
            else if(this._type == FRIEND)
            {
               _loc4_ = new InvitePrizeKindsFriendLabel();
               _loc4_.setInfo(param1[_loc2_] as FriendPrizeInfo,this.doFriendLoyout,_loc2_ + 1);
               this._nowArray.push(_loc4_);
            }
            else
            {
               _loc5_ = new InvitePrizeKindsArenaLabel();
               _loc5_.setInfo(param1[_loc2_] as ArenaPrize,this._isGetArenaPrize);
               this._nowArray.push(_loc5_);
            }
            _loc2_++;
         }
      }
      
      private function initKindsButton() : void
      {
         this._window._button_1.buttonMode = true;
         this._window._button_2.buttonMode = true;
         this._window._button_6.buttonMode = true;
         this._window["getPrizeBtn"].buttonMode = true;
         if(GlobalConstants.PVZ_VERSION == VersionManager.WEB_VERSION)
         {
            this._window._button_5.buttonMode = true;
            this._window._button_5.x = this._window._button_3.x;
            this._window._button_6.x = this._window._button_4.x;
            this._window._button_3.visible = false;
            this._window._button_4.visible = false;
            this.setKindsSelectFalse();
         }
         else
         {
            this._window._button_3.buttonMode = true;
            this._window._button_4.buttonMode = true;
            this._window._button_5.buttonMode = true;
            this.setKindsSelectFalse();
         }
      }
      
      private function initWindow(param1:int) : void
      {
         if(this.consumeData == null)
         {
            this.consumeData = new ConsumeData(this);
         }
         if(this.activeData == null)
         {
            this.activeData = new ActiveData(this);
         }
         this.initKindsButton();
         if(param1 == 1)
         {
            this.toActiveKind();
         }
         else if(param1 == 2)
         {
            this.toConsumeKind();
         }
         this.setActiveChildKind();
      }
      
      private function judgeLightEffect(param1:int) : void
      {
         if(this.getPrizeType == "active_a")
         {
            if(param1 == 1)
            {
               this.judeActiveA = true;
            }
            else
            {
               this.judeActiveA = false;
            }
         }
         else if(this.getPrizeType == "active_b")
         {
            if(param1 == 1)
            {
               this.judeActiveB = true;
            }
            else
            {
               this.judeActiveB = false;
            }
         }
      }
      
      private function judgeStratBtnLightEffect() : void
      {
         if(this.playerManager.getPlayer().getHasActiveAreward() == 1)
         {
            this._window.activeKind["active_a"].gotoAndStop(2);
            this.judeActiveA = true;
         }
         if(this.playerManager.getPlayer().getHasActiveBreward() == 1)
         {
            this._window.activeKind["active_b"].gotoAndStop(6);
            this.judeActiveB = true;
         }
         this.isFristEnter = true;
      }
      
      private function loadArenaInfo() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_PRIZE,INFO_ARENA);
      }
      
      private function loadFriendInfo() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_INVITE_FRIENDS_INFO),INFO_FRIENDS);
      }
      
      private function loadInviteInfo() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_INVITE_AMOUNT_INFO),INFO_INVITE);
      }
      
      private function makeupActivityContinueText(param1:int) : void
      {
         this.isActivityContinueText.x = 355;
         this.isActivityContinueText.y = 42;
         if(param1 == 0)
         {
            this.isActivityContinueText.htmlText = "<font color=\'#cc0000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize008") + "</b></font>";
         }
         else if(param1 == 1)
         {
            this.isActivityContinueText.htmlText = "<font color=\'#cc0000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize007") + "</b></font>";
         }
         else if(param1 == 2)
         {
            this.isActivityContinueText.htmlText = "<font color=\'#cc0000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize009") + "</b></font>";
         }
         this.isActivityContinueText.width = this.isActivityContinueText.textWidth + 20;
         this.isActivityContinueText.height = this.isActivityContinueText.textHeight + 4;
      }
      
      private function onActiveChange(param1:PrizeEvent) : void
      {
         var _loc2_:Tool = null;
         var _loc3_:PrizeLabel = null;
         while(this._window.activeKind["con"].numChildren > 0)
         {
            this._window.activeKind["con"].removeChildAt(0);
         }
         var _loc4_:int = int(this._arrStore.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this._arrStore[_loc5_].getId() == param1.prizeObject["id"])
            {
               this._arrStore[_loc5_].setType(2);
            }
            else
            {
               this._arrStore[_loc5_].setType(1);
            }
            _loc5_++;
         }
         var _loc6_:int = int(param1.prizeObject["data"].length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = new Tool(param1.prizeObject["data"][_loc7_]["id"]);
            _loc2_.setNum(param1.prizeObject["data"][_loc7_]["num"]);
            _loc3_ = new PrizeLabel(_loc2_);
            _loc3_.x = _loc7_ * (_loc3_.x + 140) + 20;
            this._window.activeKind["con"].addChild(_loc3_);
            _loc7_++;
         }
      }
      
      private function onActiveClick(param1:MouseEvent) : void
      {
         this.setRightButtonVisible(false);
         this.setLeftButtonVisible(false);
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "active_a")
         {
            if(param1.currentTarget.currentFrame == 2)
            {
               return;
            }
            this.active_txt.htmlText = "";
            this.toActiveKind(1);
         }
         else if(param1.currentTarget.name == "active_b")
         {
            if(param1.currentTarget.currentFrame == 4)
            {
               return;
            }
            this.active_txt.htmlText = "";
            this.toActiveKind(2);
         }
         else if(param1.currentTarget.name == "active_c")
         {
            if(param1.currentTarget.currentFrame == 8)
            {
               return;
            }
            this.active_txt.htmlText = "";
            this.toActiveKind(3);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name != "_button_2")
         {
            this.setLeftButtonVisible(false);
            this.setRightButtonVisible(false);
         }
         if(param1.currentTarget.name == "_button_1")
         {
            if(this._window._button_1.currentFrame == 8)
            {
               return;
            }
            this.setKindsSelectFalse();
            this.toActiveKind();
         }
         else if(param1.currentTarget.name == "_button_2")
         {
            if(this._window._button_2.currentFrame == 10)
            {
               return;
            }
            this.setKindsSelectFalse();
            this._consumePrizeCurPage = 1;
            this.toConsumeKind();
         }
         else if(param1.currentTarget.name == "_button_3")
         {
            if(this._window._button_3.currentFrame == 2)
            {
               return;
            }
            this._nowArray = new Array();
            this._type = INVITE;
            this.loadInviteInfo();
            this.addInviteAmountNum();
            this.setKindsSelectFalse();
            this._window._button_3.gotoAndStop(2);
         }
         else if(param1.currentTarget.name == "_button_4")
         {
            if(this._window._button_4.currentFrame == 4)
            {
               return;
            }
            this._nowArray = new Array();
            this._type = FRIEND;
            this.setKindsSelectFalse();
            this._window._button_4.gotoAndStop(4);
            this.toFriend();
         }
         else if(param1.currentTarget.name == "_button_5")
         {
            if(this.playerManager.getPlayer().getGrade() < 10)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window149"));
               return;
            }
            if(this._window._button_5.currentFrame == 6)
            {
               return;
            }
            this._nowArray = new Array();
            this._type = ARENA;
            this.setKindsSelectFalse();
            this._window._button_5.gotoAndStop(6);
            this.toArena();
         }
         else if(param1.currentTarget.name == "_button_6")
         {
            if(this._window._button_6.currentFrame == 12)
            {
               return;
            }
            this.setKindsSelectFalse();
            this._window._button_6.gotoAndStop(12);
            this.setBtnVisible(false);
            this._window["prenext"].visible = false;
            this.toActivatePanel();
         }
         else if(param1.currentTarget.name == "_cancel")
         {
            this.hidden();
         }
         else if(param1.currentTarget.name == "recharge")
         {
            PlantsVsZombies.toRecharge();
         }
         else if(param1.currentTarget.name == "_add")
         {
            if(this._nowPage == this._maxPage)
            {
               return;
            }
            ++this._nowPage;
            this.setPage();
            this.doLayout();
         }
         else if(param1.currentTarget.name == "_dec")
         {
            if(this._nowPage == 1)
            {
               return;
            }
            --this._nowPage;
            this.setPage();
            this.doLayout();
         }
      }
      
      private function onConsumePageButtonClick(param1:MouseEvent) : void
      {
         if(this.getPrizeType == "active_c")
         {
            if(param1.currentTarget.name == "_left")
            {
               --this._currentLimitPrizePage;
               if(this._currentLimitPrizePage <= 1)
               {
                  this._consumePrizeCurPage = 1;
                  this.setLeftButtonVisible(false);
               }
               if(this._currentLimitPrizePage < this._limitPrizeMaxPage)
               {
                  if(!this._window["_right"].visible)
                  {
                     this.setRightButtonVisible(true);
                  }
               }
            }
            else if(param1.currentTarget.name == "_right")
            {
               ++this._currentLimitPrizePage;
               if(this._currentLimitPrizePage >= this._limitPrizeMaxPage)
               {
                  this._currentLimitPrizePage = this._limitPrizeMaxPage;
                  this.setRightButtonVisible(false);
               }
               if(this._currentLimitPrizePage > 1)
               {
                  if(!this._window["_left"].visible)
                  {
                     this.setLeftButtonVisible(true);
                  }
               }
            }
            this.updateLimitBox();
         }
         else
         {
            if(param1.currentTarget.name == "_left")
            {
               --this._consumePrizeCurPage;
               if(this._consumePrizeCurPage <= 1)
               {
                  this._consumePrizeCurPage = 1;
                  this.setLeftButtonVisible(false);
               }
               if(this._consumePrizeCurPage < this._consumePrizeMaxPage)
               {
                  if(!this._window["_right"].visible)
                  {
                     this.setRightButtonVisible(true);
                  }
               }
            }
            else if(param1.currentTarget.name == "_right")
            {
               ++this._consumePrizeCurPage;
               if(this._consumePrizeCurPage >= this._consumePrizeMaxPage)
               {
                  this._consumePrizeCurPage = this._consumePrizeMaxPage;
                  this.setRightButtonVisible(false);
               }
               if(this._consumePrizeCurPage > 1)
               {
                  if(!this._window["_left"].visible)
                  {
                     this.setLeftButtonVisible(true);
                  }
               }
            }
            this.updateConsumeBox();
         }
      }
      
      private function onExchange(param1:MouseEvent) : void
      {
         this._window._activate_panel.change_btn.removeEventListener(MouseEvent.CLICK,this.onExchange);
         var _loc2_:String = this._window._activate_panel._input_txt.text;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVATE_CODE_FUNC,ACTIVATE_CODE_EXCHANGE,_loc2_);
      }
      
      private function onGetPrizeClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.currentFrame == 2 || param1.currentTarget.currentFrame == 3)
         {
            switch(this.getPrizeType)
            {
               case "active_a":
                  this.playerManager.getPlayer().setHasActiveAreward(0);
                  this.activeData.getPrizeData(ActiveData.PRIZE_A);
                  break;
               case "active_b":
                  this.playerManager.getPlayer().setHasActiveBreward(0);
                  this.activeData.getPrizeData(ActiveData.PRIZE_B);
                  break;
               case "consume":
                  this.playerManager.getPlayer().setHasConsumeBreward(0);
                  this.consumeData.getPrizeData();
                  break;
               case "active_c":
                  this.activeData.getPrizeData(ActiveData.PRIZE_C);
            }
            return;
         }
      }
      
      private function onGetPrizeOut(param1:MouseEvent) : void
      {
         this._window["getPrizeBtn"].gotoAndStop(2);
      }
      
      private function onGetPrizeOver(param1:MouseEvent) : void
      {
         this._window["getPrizeBtn"].gotoAndStop(3);
      }
      
      private function onChange(param1:Event) : void
      {
         if(this._window._activate_panel._input_txt.text != "")
         {
            this._window._activate_panel.change_btn.buttonMode = true;
            this._window._activate_panel.change_btn.gotoAndStop(2);
            this._window._activate_panel.change_btn.addEventListener(MouseEvent.CLICK,this.onExchange);
         }
         else
         {
            this._window._activate_panel.change_btn.buttonMode = false;
            this._window._activate_panel.change_btn.gotoAndStop(1);
            this._window._activate_panel.change_btn.removeEventListener(MouseEvent.CLICK,this.onExchange);
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(this._window._activate_panel._input_txt.text != "")
         {
            this._window._activate_panel.change_btn.buttonMode = true;
            this._window._activate_panel.change_btn.gotoAndStop(2);
            this._window._activate_panel.change_btn.addEventListener(MouseEvent.CLICK,this.onExchange);
         }
         else
         {
            this._window._activate_panel.change_btn.buttonMode = false;
            this._window._activate_panel.change_btn.gotoAndStop(1);
            this._window._activate_panel.change_btn.removeEventListener(MouseEvent.CLICK,this.onExchange);
         }
      }
      
      private function removeEvent() : void
      {
         this._window._button_1.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_2.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_3.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_4.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._button_5.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._cancel.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["recharge"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["prenext"]._add.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["prenext"]._dec.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["getPrizeBtn"].removeEventListener(MouseEvent.CLICK,this.onGetPrizeClick);
         this._window["getPrizeBtn"].removeEventListener(MouseEvent.MOUSE_OVER,this.onGetPrizeOver);
         this._window["getPrizeBtn"].removeEventListener(MouseEvent.MOUSE_OUT,this.onGetPrizeOut);
         this._window.activeKind["evrDay"].removeEventListener(MouseEvent.CLICK,this.clickEvenryDayPrize);
         this._window.activeKind["evrDay"].removeEventListener(MouseEvent.ROLL_OVER,this.everyDayMouseOver);
         this._window.activeKind["evrDay"].removeEventListener(MouseEvent.ROLL_OUT,this.everyDayMouseOut);
         this._window.activeKind["active_a"].removeEventListener(MouseEvent.CLICK,this.onActiveClick);
         this._window.activeKind["active_b"].removeEventListener(MouseEvent.CLICK,this.onActiveClick);
         PlantsVsZombies._node.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._window._activate_panel.change_btn.removeEventListener(MouseEvent.CLICK,this.onExchange);
         this._window["_left"].removeEventListener(MouseEvent.CLICK,this.onConsumePageButtonClick);
         this._window["_right"].removeEventListener(MouseEvent.CLICK,this.onConsumePageButtonClick);
         this._window._activate_panel._input_txt.removeEventListener(Event.CHANGE,this.onChange);
      }
      
      private function setActiveChildKind() : void
      {
         this._window.activeKind["active_a"].buttonMode = true;
         this._window.activeKind["active_b"].buttonMode = true;
         this._window.activeKind["active_c"].buttonMode = true;
         this._window.activeKind["evrDay"].buttonMode = true;
         this._window.activeKind["evrDay"].addEventListener(MouseEvent.CLICK,this.clickEvenryDayPrize);
         this._window.activeKind["evrDay"].addEventListener(MouseEvent.ROLL_OVER,this.everyDayMouseOver);
         this._window.activeKind["evrDay"].addEventListener(MouseEvent.ROLL_OUT,this.everyDayMouseOut);
         this._window.activeKind["active_a"].addEventListener(MouseEvent.CLICK,this.onActiveClick);
         this._window.activeKind["active_b"].addEventListener(MouseEvent.CLICK,this.onActiveClick);
         this._window.activeKind["active_c"].addEventListener(MouseEvent.CLICK,this.onActiveClick);
      }
      
      private function setAllVisibleFalse() : void
      {
         this._window.activeKind.visible = false;
         this._window.consumeKind.visible = false;
         this._window._kinds_invite.visible = false;
         this._window._kinds_friend.visible = false;
         this._window._kinds_arena.visible = false;
         this._window._activate_panel.visible = false;
         this.clearPrizeNode();
      }
      
      private function setBtnFlase() : void
      {
         this.playerManager.getPlayer().setRewardDaily(0);
         this._window.activeKind["evrDay"].gotoAndStop(1);
         this._window.activeKind["evrDay"].mouseEnabled = false;
      }
      
      private function setBtnVisible(param1:Boolean) : void
      {
         this._window["recharge"].visible = param1;
         this._window["getPrizeBtn"].visible = param1;
      }
      
      private function setConsumePanelElement(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(this.consumeText == null)
         {
            this.consumeText = new TextField();
         }
         if(param3 <= 0 || param3 > this._consumePrizeData["storeObject"].length)
         {
            if(param1 >= this.maxNum)
            {
               if(param4 == 1)
               {
                  this._window.consumeKind["text_tip"].gotoAndStop(1);
               }
               else
               {
                  this._window.consumeKind["text_tip"].gotoAndStop(2);
               }
               this.consumeText.htmlText = "<font color=\'#000000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize002") + "</b></font>";
               this.consumeText.x = 180;
            }
         }
         else
         {
            this._window.consumeKind["text_tip"].gotoAndStop(1);
            _loc5_ = "</b></font><font color=\'#990000\' size=\'15\'><b>" + param1 + "</b></font><font color=\'#000000\' size=\'15\'><b>";
            _loc6_ = "</b></font><font color=\'#990000\' size=\'15\'><b>" + param2 + "</b></font><font color=\'#000000\' size=\'15\'><b>";
            _loc7_ = "</b></font><font color=\'#990000\' size=\'15\'><b>" + param3 + "</b></font><font color=\'#000000\' size=\'15\'><b>";
            this.consumeText.htmlText = "<font color=\'#000000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("invitePrize001",_loc5_,_loc6_,_loc7_) + "</b></font>";
            this.consumeText.x = 125;
         }
         this.consumeText.y = 16;
         this.consumeText.width = this.consumeText.textWidth + 15;
         this.consumeText.height = this.consumeText.textHeight + 4;
         this._window.consumeKind.addChild(this.consumeText);
      }
      
      private function setEveryDayBtn() : void
      {
         if(this.playerManager.getPlayer().getRewardDaily() == 1)
         {
            this._window.activeKind["evrDay"].gotoAndStop(2);
            return;
         }
         this._window.activeKind["evrDay"].gotoAndStop(1);
         this._window.activeKind["evrDay"].mouseEnabled = false;
      }
      
      private function setKindsSelectFalse() : void
      {
         if(GlobalConstants.PVZ_VERSION == VersionManager.WEB_VERSION)
         {
            this._window._button_1.gotoAndStop(7);
            this._window._button_2.gotoAndStop(9);
            this._window._button_5.gotoAndStop(5);
            this._window._button_6.gotoAndStop(11);
         }
         else
         {
            this._window._button_1.gotoAndStop(7);
            this._window._button_2.gotoAndStop(9);
            this._window._button_3.gotoAndStop(1);
            this._window._button_4.gotoAndStop(3);
            this._window._button_5.gotoAndStop(5);
            this._window._button_6.gotoAndStop(11);
         }
      }
      
      private function setLeftButtonVisible(param1:Boolean) : void
      {
         this._window["_left"].visible = param1;
         if(param1)
         {
            this._window["_left"].addEventListener(MouseEvent.CLICK,this.onConsumePageButtonClick);
         }
         else
         {
            this._window["_left"].removeEventListener(MouseEvent.CLICK,this.onConsumePageButtonClick);
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      private function setPage() : void
      {
         this.setBtnVisible(false);
         this._window["prenext"].visible = true;
         this._window["prenext"]._page_num.text = this._nowPage + "/" + this._maxPage;
      }
      
      private function setRightButtonVisible(param1:Boolean) : void
      {
         this._window["_right"].visible = param1;
         if(param1)
         {
            this._window["_right"].addEventListener(MouseEvent.CLICK,this.onConsumePageButtonClick);
         }
         else
         {
            this._window["_right"].removeEventListener(MouseEvent.CLICK,this.onConsumePageButtonClick);
         }
      }
      
      private function showFristPrize(param1:Array) : void
      {
         var _loc2_:Tool = null;
         var _loc3_:PrizeLabel = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new Tool(param1[_loc5_]["id"]);
            _loc2_.setNum(param1[_loc5_]["num"]);
            _loc3_ = new PrizeLabel(_loc2_);
            _loc3_.x = _loc5_ * (_loc3_.x + 140) + 20;
            this._window.activeKind["con"].addChild(_loc3_);
            _loc5_++;
         }
      }
      
      private function sortByGrade(param1:Array) : void
      {
         var _loc3_:FriendPrizeInfo = null;
         var _loc4_:* = 0;
         if(param1 == null || param1.length < 2)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getGrade() < _loc3_.getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
      }
      
      private function sortFriends(param1:Array) : Array
      {
         if(param1 == null || param1.length < 2)
         {
            return param1;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if((param1[_loc5_] as FriendPrizeInfo).getStarts() == -1)
            {
               _loc3_.push(param1[_loc5_]);
            }
            else if((param1[_loc5_] as FriendPrizeInfo).getStarts() == 0)
            {
               _loc2_.push(param1[_loc5_]);
            }
            else
            {
               _loc4_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         this.sortByGrade(_loc4_);
         this.sortByGrade(_loc2_);
         this.sortByGrade(_loc3_);
         _loc4_ = _loc4_.concat(_loc3_);
         return _loc4_.concat(_loc2_);
      }
      
      private function toActivatePanel() : void
      {
         this.setAllVisibleFalse();
         this._window._activate_panel.change_btn.buttonMode = false;
         this._window._activate_panel._input_txt.text = "";
         this._window._activate_panel.change_btn.gotoAndStop(1);
         this._window._activate_panel.visible = true;
         PlantsVsZombies._node.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyDown);
         this._window._activate_panel._input_txt.addEventListener(Event.CHANGE,this.onChange);
      }
      
      private function toActiveKind(param1:int = 1) : void
      {
         this.setAllVisibleFalse();
         this._window.activeKind.visible = true;
         this._window._button_1.gotoAndStop(8);
         this._window["prenext"].visible = false;
         this.setEveryDayBtn();
         this.setBtnVisible(true);
         if(param1 == 1)
         {
            this.getPrizeType = "active_a";
            this._window.activeKind["active_a"].gotoAndStop(2);
            this._window.activeKind["active_c"].gotoAndStop(7);
            this._window.activeKind["txt_mc"].gotoAndStop(1);
            if(this.judeActiveB)
            {
               this._window.activeKind["active_b"].gotoAndStop(6);
            }
            else
            {
               this._window.activeKind["active_b"].gotoAndStop(3);
            }
            this.activeData.initActiveData(ActiveData.PRIZE_A);
         }
         else if(param1 == 2)
         {
            this.getPrizeType = "active_b";
            this._window.activeKind["active_b"].gotoAndStop(4);
            this._window.activeKind["active_c"].gotoAndStop(7);
            this._window.activeKind["txt_mc"].gotoAndStop(2);
            if(this.judeActiveA)
            {
               this._window.activeKind["active_a"].gotoAndStop(5);
            }
            else
            {
               this._window.activeKind["active_a"].gotoAndStop(1);
            }
            this.activeData.initActiveData(ActiveData.PRIZE_B);
         }
         else if(param1 == 3)
         {
            this.getPrizeType = "active_c";
            this._window.activeKind["active_c"].gotoAndStop(8);
            this._window.activeKind["txt_mc"].gotoAndStop(3);
            if(this.judeActiveA)
            {
               this._window.activeKind["active_a"].gotoAndStop(5);
            }
            else
            {
               this._window.activeKind["active_a"].gotoAndStop(1);
            }
            if(this.judeActiveB)
            {
               this._window.activeKind["active_b"].gotoAndStop(6);
            }
            else
            {
               this._window.activeKind["active_b"].gotoAndStop(3);
            }
            this.activeData.initActiveData(ActiveData.PRIZE_C);
         }
         if(!this.isFristEnter)
         {
            this.judgeStratBtnLightEffect();
         }
      }
      
      private function toArena() : void
      {
         this.setAllVisibleFalse();
         this._window._kinds_arena.visible = true;
         this.loadArenaInfo();
      }
      
      private function toConsumeKind() : void
      {
         this.setAllVisibleFalse();
         this.setBtnVisible(true);
         this.getPrizeType = "consume";
         this._window._button_2.gotoAndStop(10);
         this._window.consumeKind.visible = true;
         this._window["prenext"].visible = false;
         this.consumeData.initConsumeData();
      }
      
      private function toFriend() : void
      {
         this.setAllVisibleFalse();
         this._window._kinds_friend.visible = true;
         this._window._kinds_friend._t.visible = false;
         this.loadFriendInfo();
      }
      
      private function toInvite() : void
      {
         this.setAllVisibleFalse();
         this._window._kinds_invite.visible = true;
         this._nowPage = 1;
         this._maxPage = (this._invitePirzes.length - 1) / INVITE_NUM + 1;
         this.setPage();
         this.doInviteLoyout();
      }
      
      private function updateConsumeBox() : void
      {
         var _loc2_:ConsumeLabel = null;
         var _loc1_:int = this.maxNum;
         this._arrStore = [];
         while(this._window.consumeKind["labelcon"].numChildren > 0)
         {
            this._window.consumeKind["labelcon"].removeChildAt(0);
         }
         while(this._window.consumeKind["con"].numChildren > 0)
         {
            this._window.consumeKind["con"].removeChildAt(0);
         }
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(!this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4])
            {
               break;
            }
            _loc2_ = new ConsumeLabel(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["pic"]);
            _loc2_.setNum(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["num"]);
            _loc2_.setData(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["content"]);
            if(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["type"] == 0)
            {
               _loc2_.preType = 2;
               _loc2_.changeThisState(2);
            }
            else if(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["type"] == 1)
            {
               _loc2_.preType = 5;
               _loc2_.changeThisState(5);
            }
            else if(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["type"] == 2)
            {
               _loc2_.preType = 1;
               _loc2_.changeThisState(1);
            }
            if(this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["num"] > this.maxNum)
            {
               this.maxNum = this._consumePrizeData["storeObject"][_loc3_ + (this._consumePrizeCurPage - 1) * 4]["num"];
            }
            _loc2_.x = _loc3_ * (_loc2_.x + 150) + 10;
            _loc2_.y = 50;
            this._arrStore.push(_loc2_);
            this._window.consumeKind["labelcon"].addChild(_loc2_);
            _loc2_.addEventListener(PrizeEvent.PRIZE_EVENT,this.onConsumeChange);
            _loc3_++;
         }
         this.setConsumePanelElement(this._consumePrizeData["num"],this._consumePrizeData["pre"],this._consumePrizeData["next"],this._consumePrizeData["getType"]);
      }
   }
}

