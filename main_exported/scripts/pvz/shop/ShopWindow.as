package pvz.shop
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.ui.panel.BaseWindow;
   import entity.Goods;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import labels.ShopLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.invitePrizes.InvitePrizeWindow;
   import pvz.shop.rpc.Shop_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.ChallengePropWindow;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ShopWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      public static const SHOP_GRADE:int = 0;
      
      public static const PAGE_NUM:int = 8;
      
      public static const SHOP_EXCHANGE:int = 2;
      
      public static const SHOP_GENERAL:int = 1;
      
      public static const SHOP_RMB:int = 3;
      
      public static const SHOP_HONOUR:int = 5;
      
      public static const SHOP_TOOLCHANGE:int = 4;
      
      public static const SHOP_VIP_SHOP:int = 6;
      
      public static const SHOP_HOT_SHOP:int = 7;
      
      public static var ORG:String = "organisms";
      
      public static var TOOL:String = "tool";
      
      private static const CHANGE:int = 1;
      
      public static const INIT:int = 0;
      
      private static const RESET:int = 2;
      
      private static const HOT_SHOP:int = 3;
      
      private var _taskFun:Function = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _back:Function;
      
      private var _baseArray:Array = null;
      
      private var _label:Class;
      
      private var _hot_label:Class;
      
      private var _maxCommenPage:int = 1;
      
      private var _nowCommenPage:int = 1;
      
      private var _maxHotPage:int = 1;
      
      private var _nowHotPage:int = 1;
      
      private var _shop:MovieClip = null;
      
      private var _shopType:int = 0;
      
      private var _showArray:Array = null;
      
      private var nowSec:int = 0;
      
      private var timer:Timer;
      
      private var reset_cost:int = 0;
      
      private var shop_exchange:int = 0;
      
      private var shop_general:int = 0;
      
      private var shop_rmb:int = 0;
      
      private var shop_hot_sell:int = 0;
      
      private var shop_vip:int = 0;
      
      private var _invitePrizeWindow:InvitePrizeWindow = null;
      
      private var hotShopArray:Array;
      
      private var _specfigPage:int;
      
      public function ShopWindow(param1:Function, param2:int = 1)
      {
         this._specfigPage = param2;
         this._taskFun = param1;
         super(UINameConst.UI_SHOP);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_shopWindow");
         this._shop = new _loc1_();
         this._shop.visible = false;
         this._label = DomainAccess.getClass("goodscard");
         this._hot_label = DomainAccess.getClass("hotgoodscard");
         PlantsVsZombies._node.addChild(this._shop);
         this.show();
      }
      
      public function initDate() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,INIT);
      }
      
      override public function destroy() : void
      {
         this.removeButtonEvent();
         FuncKit.clearAllChildrens(this._shop["_items"]);
         FuncKit.clearAllChildrens(this._shop["hot_items"]);
         PlantsVsZombies._node.removeChild(this._shop);
         if(this._taskFun != null)
         {
            this._taskFun();
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc6_:int = 0;
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == CHANGE)
         {
            _loc6_ = 0;
            if(this._shopType == SHOP_EXCHANGE)
            {
               _loc6_ = this.shop_exchange;
            }
            else if(this._shopType == SHOP_GENERAL)
            {
               _loc6_ = this.shop_general;
            }
            else if(this._shopType == SHOP_RMB)
            {
               _loc6_ = this.shop_rmb;
            }
            else if(this._shopType == SHOP_HONOUR)
            {
               _loc6_ = SHOP_HONOUR;
            }
            else
            {
               if(this._shopType != SHOP_VIP_SHOP)
               {
                  PlantsVsZombies.showDataLoading(false);
                  return;
               }
               _loc6_ = this.shop_vip;
            }
            _loc5_.call(param2,param3,_loc6_);
         }
         else if(param3 == HOT_SHOP)
         {
            _loc5_.call(param2,param3,this.shop_hot_sell);
         }
         else if(param3 == RESET)
         {
            _loc5_.call(param2,param3);
         }
         else
         {
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      public function hidden() : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         }
         onHiddenEffect(this._shop,this.destroy);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Shop_rpc = new Shop_rpc();
         if(param1 == INIT)
         {
            this.shop_exchange = param2.type_all.exchange;
            this.shop_general = param2.type_all.game_coin;
            this.shop_rmb = param2.type_all.rmb;
            this.shop_hot_sell = param2.type_all.hot;
            this.shop_vip = param2.type_all.vip;
            this.reset_cost = param2.money;
            this.nowSec = param2.time;
            this._baseArray = this.order(_loc3_.getShopArray(param2.goods));
            if(this.playerManager.getPlayer().getGrade() < SHOP_GRADE)
            {
               this._baseArray = null;
            }
            if(this._baseArray != null)
            {
               this._maxCommenPage = (this._baseArray.length - 1) / PAGE_NUM + 1;
            }
            this.setTimer();
            this._nowCommenPage = this._specfigPage;
            this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
            this.showPage();
            if(this.playerManager.getPlayer().getGrade() < SHOP_GRADE)
            {
               this._shopType = SHOP_GENERAL;
               this.changeShop();
               this._shop["recharge"].visible = false;
               this._shop["_shop_rmb1"].visible = false;
               this._shop["_shop_rmb2"].visible = false;
               this._shop["_shop_panel"].visible = false;
            }
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_GETMERCHANDISES,HOT_SHOP);
         }
         else if(param1 == CHANGE)
         {
            PlantsVsZombies.showDataLoading(false);
            this._baseArray = this.order(_loc3_.getShopArray(param2));
            this._maxCommenPage = (this._baseArray.length - 1) / PAGE_NUM + 1;
            this._nowCommenPage = 1;
            this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
            this.showPage();
         }
         else if(param1 == HOT_SHOP)
         {
            PlantsVsZombies.showDataLoading(false);
            this.hotShopArray = this.order(_loc3_.getShopArray(param2));
            this._maxHotPage = (this.hotShopArray.length - 1) / 4 + 1;
            this._nowHotPage = 1;
            this.showPageNum(1,this._nowHotPage,this._maxHotPage);
            this.showHotPage(this._shop["hot_items"]);
            this.setLoction();
            onShowEffect(this._shop);
         }
         else if(param1 == RESET)
         {
            PlantsVsZombies.showDataLoading(false);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window078",this.reset_cost));
            PlantsVsZombies.changeMoneyOrExp(-this.reset_cost);
            this.nowSec = param2.time;
            this.setTimer();
            this._baseArray = _loc3_.getShopArray(param2.goods);
            this._maxCommenPage = (this._baseArray.length - 1) / PAGE_NUM + 1;
            this._nowCommenPage = 1;
            this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
            this.showPage();
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
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window079"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      private function show(param1:Function = null) : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._back = param1;
         this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
         this.initDate();
         this.initUi();
      }
      
      private function addButtonEvent() : void
      {
         this._shop["turnpage1"]["pre"].addEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["turnpage1"]["next"].addEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["turnpage2"]["pre"].addEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["turnpage2"]["next"].addEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["_shop_ganeral1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_exchange1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_honour"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_rmb1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_vip1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["recharge"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["openVip"].addEventListener(MouseEvent.CLICK,this.onVipClick);
      }
      
      private function removeButtonEvent() : void
      {
         this._shop["turnpage1"]["pre"].removeEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["turnpage1"]["next"].removeEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["turnpage2"]["pre"].removeEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["turnpage2"]["next"].removeEventListener(MouseEvent.CLICK,this.onClickTurnPage);
         this._shop["_shop_ganeral1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_exchange1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_honour"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_rmb1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["_shop_vip1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["recharge"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._shop["openVip"].removeEventListener(MouseEvent.CLICK,this.onVipClick);
      }
      
      private function onClickTurnPage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.parent.name == "turnpage2")
         {
            if(param1.currentTarget.name == "next")
            {
               if(this._nowCommenPage >= this._maxCommenPage)
               {
                  return;
               }
               ++this._nowCommenPage;
               this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
               this.showPage();
            }
            else if(param1.currentTarget.name == "pre")
            {
               if(this._nowCommenPage < 2)
               {
                  return;
               }
               --this._nowCommenPage;
               this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
               this.showPage();
            }
         }
         else if(param1.currentTarget.parent.name == "turnpage1")
         {
            if(param1.currentTarget.name == "next")
            {
               if(this._nowHotPage >= this._maxHotPage)
               {
                  return;
               }
               ++this._nowHotPage;
               this.showPageNum(1,this._nowHotPage,this._maxHotPage);
               this.showHotPage(this._shop["hot_items"]);
            }
            else if(param1.currentTarget.name == "pre")
            {
               if(this._nowHotPage < 2)
               {
                  return;
               }
               --this._nowHotPage;
               this.showPageNum(1,this._nowHotPage,this._maxHotPage);
               this.showHotPage(this._shop["hot_items"]);
            }
         }
      }
      
      private function changeShop() : void
      {
         this.changeShopType();
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_GETMERCHANDISES,CHANGE);
      }
      
      private function changeShopType() : void
      {
         this._shop["_shop_ganeral1"].visible = true;
         this._shop["_shop_exchange1"].visible = true;
         this._shop["_shop_rmb1"].visible = true;
         this._shop["_shop_honour"].visible = true;
         this._shop["_shop_vip1"].visible = true;
         this._shop["_shop_ganeral2"].visible = false;
         this._shop["_shop_rmb2"].visible = false;
         this._shop["_shop_exchange2"].visible = false;
         this._shop["_shop_honour_select"].visible = false;
         this._shop["_shop_vip2"].visible = false;
         if(this.playerManager.getPlayer().getGrade() < SHOP_GRADE)
         {
            this._shop["_shop_rmb1"].visible = false;
            this._shop["_shop_rmb2"].visible = false;
            this._shop["_shop_panel"].visible = false;
         }
         if(this._shopType == SHOP_GENERAL)
         {
            this._shop["_shop_ganeral1"].visible = false;
            this._shop["_shop_ganeral2"].visible = true;
            this.setText(this.playerManager.getPlayer().getMoney(),SHOP_GENERAL);
         }
         else if(this._shopType == SHOP_EXCHANGE)
         {
            this._shop["_shop_exchange1"].visible = false;
            this._shop["_shop_exchange2"].visible = true;
            if(this.playerManager.getPlayer().getTool(ToolManager.CHANGE) == null)
            {
               this.setText(0,SHOP_EXCHANGE);
            }
            else
            {
               this.setText(this.playerManager.getPlayer().getTool(ToolManager.CHANGE).getNum(),SHOP_EXCHANGE);
            }
         }
         else if(this._shopType == SHOP_RMB)
         {
            this._shop["_shop_rmb1"].visible = false;
            this._shop["_shop_rmb2"].visible = true;
            this.setText(this.playerManager.getPlayer().getRMB(),SHOP_RMB);
         }
         else if(this._shopType == SHOP_HONOUR)
         {
            this._shop["_shop_honour"].visible = false;
            this._shop["_shop_honour_select"].visible = true;
            this.setText(this.playerManager.getPlayer().getHonour(),SHOP_HONOUR);
         }
         else if(this._shopType == SHOP_VIP_SHOP)
         {
            this._shop["_shop_vip1"].visible = false;
            this._shop["_shop_vip2"].visible = true;
            this.setText(this.playerManager.getPlayer().getRMB(),SHOP_RMB);
         }
      }
      
      private function initUi() : void
      {
         this._shopType = SHOP_RMB;
         this.changeShopType();
         this.addButtonEvent();
         this.addVipButtonEvent();
         this.setButtonMode();
      }
      
      private function setButtonMode() : void
      {
         this._shop["_shop_ganeral1"].buttonMode = true;
         this._shop["_shop_rmb1"].buttonMode = true;
         this._shop["_shop_exchange1"].buttonMode = true;
         this._shop["_shop_honour"].buttonMode = true;
         this._shop["_shop_vip1"].buttonMode = true;
         this._shop["turnpage1"]["pre"].buttonMode = true;
         this._shop["turnpage1"]["next"].buttonMode = true;
         this._shop["turnpage2"]["pre"].buttonMode = true;
         this._shop["turnpage2"]["next"].buttonMode = true;
      }
      
      private function addVipButtonEvent() : void
      {
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            this._shop["openVip"].visible = false;
         }
         else
         {
            this._shop["openVip"].visible = true;
         }
      }
      
      private function onVipClick(param1:MouseEvent = null) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         new ChallengePropWindow(ChallengePropWindow.TYPE_VIP,null,true);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var end:Function;
         var e:MouseEvent = param1;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(e.currentTarget.name == "_shop_ganeral1")
         {
            this._shopType = SHOP_GENERAL;
            this.changeShop();
         }
         else if(e.currentTarget.name == "_shop_exchange1")
         {
            this._shopType = SHOP_EXCHANGE;
            this.changeShop();
         }
         else if(e.currentTarget.name == "_shop_rmb1")
         {
            this._shopType = SHOP_RMB;
            this.changeShop();
         }
         else if(e.currentTarget.name == "_shop_honour")
         {
            this._shopType = SHOP_HONOUR;
            this.changeShop();
         }
         else if(e.currentTarget.name == "_shop_vip1")
         {
            this._shopType = SHOP_VIP_SHOP;
            this.changeShop();
         }
         else if(e.currentTarget.name == "recharge")
         {
            PlantsVsZombies.toRecharge();
         }
         else if(e.currentTarget.name == "storeBox")
         {
            end = function():void
            {
               if(_invitePrizeWindow == null)
               {
                  _invitePrizeWindow = new InvitePrizeWindow();
               }
               _invitePrizeWindow.show(2);
            };
            DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_PRIZES_WINDOW,end);
         }
         else if(e.currentTarget.name == "cancel")
         {
            this.hidden();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         --this.nowSec;
         if(this.nowSec < 0)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,INIT);
            return;
         }
      }
      
      private function order(param1:Array) : Array
      {
         var _loc3_:Goods = null;
         var _loc4_:* = 0;
         if(param1 == null || param1.length <= 1)
         {
            return param1;
         }
         var _loc2_:int = 1;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as Goods).getSeqId() > (_loc3_ as Goods).getSeqId())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function removeGood(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:Goods = null;
         var _loc6_:Tool = null;
         if(this._baseArray == null)
         {
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._baseArray.length)
         {
            if((this._baseArray[_loc4_] as Goods).getGoodsId() == param1)
            {
               _loc5_ = this._baseArray[_loc4_];
               _loc5_.setMaxNum(_loc5_.getMaxNum() - param2);
               if(_loc5_.getMaxNum() != 0)
               {
                  break;
               }
               this._baseArray.splice(_loc4_,1);
               this._maxCommenPage = (this._baseArray.length - 1) / PAGE_NUM + 1;
               break;
            }
            _loc4_++;
         }
         if(param3 == SHOP_RMB || param3 == SHOP_VIP_SHOP)
         {
            this.setText(this.playerManager.getPlayer().getRMB(),SHOP_RMB);
         }
         if(param3 == SHOP_EXCHANGE)
         {
            _loc6_ = this.playerManager.getPlayer().getTool(ToolManager.CHANGE);
            if(_loc6_ == null)
            {
               this.setText(0,SHOP_EXCHANGE);
            }
            else
            {
               this.setText(_loc6_.getNum(),SHOP_EXCHANGE);
            }
         }
         if(param3 == SHOP_HONOUR)
         {
            this.setText(this.playerManager.getPlayer().getHonour(),SHOP_HONOUR);
         }
         if(param3 == SHOP_GENERAL)
         {
            this.setText(this.playerManager.getPlayer().getMoney(),SHOP_GENERAL);
         }
         this.showPageNum(2,this._nowCommenPage,this._maxCommenPage);
         this.showPage();
      }
      
      private function removeHotSellGoods(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:Goods = null;
         if(this.hotShopArray == null)
         {
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.hotShopArray.length)
         {
            if((this.hotShopArray[_loc4_] as Goods).getGoodsId() == param1)
            {
               _loc5_ = this.hotShopArray[_loc4_];
               _loc5_.setMaxNum(_loc5_.getMaxNum() - param2);
               if(_loc5_.getMaxNum() != 0)
               {
                  break;
               }
               this.hotShopArray.splice(_loc4_,1);
               this._maxHotPage = (this.hotShopArray.length - 1) / 4 + 1;
               break;
            }
            _loc4_++;
         }
         if(this._shopType == SHOP_RMB || this._shopType == SHOP_VIP_SHOP)
         {
            this.setText(this.playerManager.getPlayer().getRMB(),SHOP_RMB);
         }
         this.showPageNum(1,this._nowHotPage,this._maxHotPage);
         this.showHotPage(this._shop["hot_items"]);
      }
      
      private function resetDate() : void
      {
      }
      
      private function setLoction() : void
      {
         this._shop.visible = true;
         this._shop.x = 380 + 10;
         this._shop.y = 265;
         PlantsVsZombies._node.setChildIndex(this._shop,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function setText(param1:Number, param2:int) : void
      {
         if(param2 == SHOP_GENERAL && this._shopType == SHOP_GENERAL)
         {
            this._shop.num.htmlText = "<font color=\'#000000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("window166") + "</b><font>" + param1 + "</font>";
         }
         else if(param2 == SHOP_EXCHANGE && this._shopType == SHOP_EXCHANGE)
         {
            this._shop.num.htmlText = "<font color=\'#000000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("window163") + "</b><font>" + param1 + "</font>";
         }
         else if(param2 == SHOP_RMB)
         {
            this._shop.num.htmlText = "<font color=\'#000000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("window164") + "</b><font>" + param1 + "</font>";
         }
         else
         {
            if(!(param2 == SHOP_HONOUR && this._shopType == SHOP_HONOUR))
            {
               return;
            }
            this._shop.num.htmlText = "<font color=\'#000000\' size=\'15\'><b>" + LangManager.getInstance().getLanguage("window165") + "</b><font>" + param1 + "</font>";
         }
      }
      
      private function setTimer() : void
      {
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         }
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function showPage() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:ShopLabel = null;
         var _loc1_:Sprite = this._shop["_items"];
         if(_loc1_ != null && _loc1_.numChildren > 1)
         {
            FuncKit.clearAllChildrens(_loc1_);
         }
         if(this._baseArray == null || this._baseArray.length < 1)
         {
            return;
         }
         this._showArray = [];
         this._showArray = this._baseArray.slice((this._nowCommenPage - 1) * PAGE_NUM,this._nowCommenPage * PAGE_NUM);
         var _loc4_:int = 0;
         while(_loc4_ < this._showArray.length)
         {
            _loc2_ = new this._label();
            _loc3_ = new ShopLabel(_loc1_,_loc2_,this.removeGood,this._back);
            _loc3_.init(this._showArray[_loc4_],this._shopType,this.onVipClick);
            _loc3_.setToolDiscount((this._showArray[_loc4_] as Goods).getGoodsDiscount());
            _loc3_.setLoction(_loc4_,4);
            _loc4_++;
         }
      }
      
      private function showHotPage(param1:Sprite, param2:int = 4, param3:int = 2) : void
      {
         var _loc4_:MovieClip = null;
         var _loc6_:ShopLabel = null;
         if(param1 != null && param1.numChildren > 1)
         {
            FuncKit.clearAllChildrens(param1);
         }
         if(this.hotShopArray == null || this.hotShopArray.length < 1)
         {
            return;
         }
         this._showArray = [];
         this._showArray = this.hotShopArray.slice((this._nowHotPage - 1) * param2,this._nowHotPage * param2);
         var _loc5_:int = 0;
         while(_loc5_ < this._showArray.length)
         {
            _loc4_ = new this._hot_label();
            _loc6_ = new ShopLabel(param1,_loc4_,this.removeHotSellGoods,this._back);
            _loc6_.init(this._showArray[_loc5_],SHOP_HOT_SHOP);
            _loc6_.setLoction(_loc5_,param3);
            _loc5_++;
         }
      }
      
      private function showPageNum(param1:int, param2:int, param3:int) : void
      {
         this._shop["turnpage" + param1]["_num"].text = param2 + "/" + param3;
      }
      
      private function useChange(param1:int) : void
      {
         var _loc2_:Tool = this.playerManager.getPlayer().getTool(ToolManager.CHANGE);
         _loc2_.setNum(_loc2_.getNum() - param1);
         this.setText(_loc2_.getNum(),SHOP_EXCHANGE);
      }
   }
}

