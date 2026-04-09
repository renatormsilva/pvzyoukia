package pvz.vip
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import tip.ToolsTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import utils.TextFilter;
   import windows.ChallengePropWindow;
   import zlib.utils.DomainAccess;
   
   public class VIPWindow extends BaseWindow implements IConnection
   {
      
      private static const INIT:int = 1;
      
      private static const GET_PRIZES:int = 2;
      
      private static const vipExpMax:int = 18000;
      
      private var _mc:MovieClip = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _backFunc:Function;
      
      private var user_day_max_exp:int;
      
      private var vip_exp:int;
      
      private var _boxTips:ToolsTip;
      
      private var vipIntroduction:Sprite;
      
      private var viptip:Bitmap;
      
      public function VIPWindow(param1:Function = null)
      {
         super();
         this._backFunc = param1;
         this.initUI();
         this.initVipInfo();
         this.addEvent();
         this.changeBtVisible();
         this.initHouseStoreConnection();
      }
      
      private function initHouseStoreConnection() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_VIPINFO,INIT);
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_window_vip");
         this._mc = new _loc1_();
         this._mc.visible = false;
         this.setLoction();
         this._mc["introl"].buttonMode = true;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._mc);
      }
      
      private function initVipInfo() : void
      {
         PlantsVsZombies.setHeadPic(this._mc["pic"],PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel(),0);
         this._mc["txtinfo"].htmlText = "<font color=\'#000000\'><b>" + LangManager.getInstance().getLanguage("vip017") + "<br>" + LangManager.getInstance().getLanguage("vip018") + "</b></font>";
         this._mc["txtinfo"].selectable = false;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            this._mc["vipLevel"].addChild(GetDomainRes.getBitmap("vip" + this.playerManager.getPlayer().getVipLevel()));
            this.showTime();
         }
         else
         {
            this._mc["vipLevel"].addChild(GetDomainRes.getBitmap("vip0"));
            this._mc["_mc_time_title"].stop();
            this._mc["_mc_time_title"].visible = false;
            this._mc["_mc_time"].visible = false;
         }
      }
      
      private function showVipIntroduction(param1:MouseEvent) : void
      {
         if(this.vipIntroduction != null && !this.vipIntroduction.visible)
         {
            this.vipIntroduction.visible = true;
         }
         else
         {
            this.showVipIntroductionTips();
         }
      }
      
      private function HideVipIntroduction(param1:MouseEvent) : void
      {
         if(this.vipIntroduction != null && this.vipIntroduction.visible)
         {
            this.vipIntroduction.visible = false;
         }
      }
      
      private function showVipIntroductionTips() : void
      {
         this.vipIntroduction = new Sprite();
         this.vipIntroduction.graphics.beginFill(0,0.7);
         this.vipIntroduction.graphics.drawRoundRect(0,0,190,230,20,20);
         this.vipIntroduction.graphics.endFill();
         this.creatInfoText();
      }
      
      private function creatInfoText() : void
      {
         var _loc1_:XML = <xml>
									<info1></info1>
									<info2></info2>
									<info3></info3>
									<info4></info4>
									<info5></info5>
									<info6></info6>
									<info7></info7>
									<info8></info8>
							 </xml>;
         var _loc2_:StyleSheet = new StyleSheet();
         _loc2_.setStyle("info1",{
            "fontSize":"12px",
            "color":"#ff6600",
            "leading":"3px"
         });
         _loc2_.setStyle("info2",{
            "fontSize":"12px",
            "color":"#ffffff",
            "leading":"1px"
         });
         _loc2_.setStyle("info3",{
            "fontSize":"12px",
            "color":"#ffffff",
            "leading":"1px"
         });
         _loc2_.setStyle("info4",{
            "fontSize":"12px",
            "color":"#ffffff",
            "leading":"2px"
         });
         _loc2_.setStyle("info5",{
            "fontSize":"12px",
            "color":"#ff6600",
            "leading":"3px"
         });
         _loc2_.setStyle("info6",{
            "fontSize":"12px",
            "color":"#ffffff",
            "leading":"1px"
         });
         _loc2_.setStyle("info7",{
            "fontSize":"12px",
            "color":"#ffffff",
            "leading":"1px"
         });
         _loc2_.setStyle("info8",{
            "fontSize":"12px",
            "color":"#ffffff",
            "leading":"1px"
         });
         var _loc3_:TextField = new TextField();
         _loc3_.width = 175;
         _loc3_.height = 45;
         _loc3_.condenseWhite = true;
         _loc3_.styleSheet = _loc2_;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.wordWrap = true;
         _loc3_.selectable = false;
         _loc3_.mouseEnabled = false;
         _loc1_.info1 = LangManager.getInstance().getLanguage("vip012");
         _loc1_.info2 = LangManager.getInstance().getLanguage("vip016");
         _loc1_.info3 = LangManager.getInstance().getLanguage("vip002");
         _loc1_.info4 = LangManager.getInstance().getLanguage("vip003");
         _loc1_.info5 = LangManager.getInstance().getLanguage("vip004");
         _loc1_.info6 = LangManager.getInstance().getLanguage("vip005");
         _loc1_.info7 = LangManager.getInstance().getLanguage("vip006");
         _loc1_.info8 = LangManager.getInstance().getLanguage("vip007");
         _loc3_.htmlText = _loc1_;
         _loc3_.x = 8;
         _loc3_.y = 4;
         this.vipIntroduction.addChild(_loc3_);
         TextFilter.MiaoBian(_loc3_,0);
         this._mc.addChild(this.vipIntroduction);
         this.vipIntroduction.x = this._mc["introl"].x - this.vipIntroduction.width;
         this.vipIntroduction.y = this._mc["introl"].y;
      }
      
      private function initBaseActiveInfo() : void
      {
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.user_day_max_exp + "");
         this._mc["active"]["exp"].addChild(_loc1_);
         _loc1_.x = -_loc1_.width / 2;
         if(this.playerManager.getPlayer().getVipLevel() == 1)
         {
            this._mc["active"].gotoAndStop(1);
         }
         else if(this.playerManager.getPlayer().getVipLevel() == 2)
         {
            this._mc["active"].gotoAndStop(2);
         }
         else if(this.playerManager.getPlayer().getVipLevel() == 3 || this.playerManager.getPlayer().getVipLevel() == 4)
         {
            this._mc["active"].gotoAndStop(3);
         }
         else
         {
            this._mc["active"].gotoAndStop(4);
         }
      }
      
      private function getVipBoxLoction(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = 0;
               break;
            case 1:
               _loc2_ = 100;
               break;
            case 2:
               _loc2_ = 250;
               break;
            case 3:
               _loc2_ = 500;
         }
         return _loc2_;
      }
      
      private function onBoxClickHandle(param1:MouseEvent) : void
      {
         if(param1.currentTarget.numChildren == 0)
         {
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:VipStoreBox = param1.target.parent as VipStoreBox;
         if(_loc2_.status == 1)
         {
            _loc2_.status = -2;
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_GET_VIPPRIZES,GET_PRIZES);
         }
      }
      
      private function onBoxOverHandle(param1:MouseEvent) : void
      {
         if(param1.currentTarget.numChildren == 0)
         {
            return;
         }
         var _loc2_:VipStoreBox = param1.target.parent as VipStoreBox;
         if(_loc2_ == null)
         {
            return;
         }
         this.viptip = GetDomainRes.getBitmap("vip_tip" + _loc2_.index);
         this._mc["boxes"].addChild(this.viptip);
         if(_loc2_.index == 1)
         {
            this.viptip.x = _loc2_.x;
            this.viptip.y = _loc2_.y + 61;
         }
         else if(_loc2_.index == 2)
         {
            this.viptip.x = _loc2_.x - 50;
            this.viptip.y = _loc2_.y + 60;
         }
         else if(_loc2_.index == 3)
         {
            this.viptip.x = _loc2_.x - 50;
            this.viptip.y = _loc2_.y + 59;
         }
         else if(_loc2_.index == 4)
         {
            this.viptip.x = _loc2_.x - 120;
            this.viptip.y = _loc2_.y + 60;
         }
      }
      
      private function onBoxOutHandle(param1:MouseEvent) : void
      {
         if(this.viptip == null)
         {
            return;
         }
         if(this._mc["boxes"].getChildIndex(this.viptip))
         {
            this._mc["boxes"].removeChild(this.viptip);
         }
         this.viptip = null;
      }
      
      private function initVipStoreHouse(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:VipStoreBox = null;
         this.user_day_max_exp = param1.user_day_max_exp;
         this.vip_exp = param1.vip_exp;
         this.clearBoxes();
         this.showExp(this.vip_exp);
         this.showNextLimit(param1.next_exp);
         this.initBaseActiveInfo();
         var _loc2_:Array = param1.reward;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = new VipStoreBox(_loc4_,_loc3_ + 1);
            _loc5_.x = this.getVipBoxLoction(_loc3_);
            _loc5_.y = -20;
            this._mc["boxes"].addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function showNextLimit(param1:int) : void
      {
         this._mc["txt"].selectable = false;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) == null)
         {
            this._mc["txt"].htmlText = "<font color=\'#ff0000\'><b>" + LangManager.getInstance().getLanguage("vip010") + "</b></font>";
            return;
         }
         if(this.playerManager.getPlayer().getVipLevel() >= 4)
         {
            this._mc["txt"].htmlText = "<font color=\'#ff0000\'><b>" + LangManager.getInstance().getLanguage("vip009") + "</b></font>";
            return;
         }
         var _loc2_:String = "</b><font color=\'#1941A5\'><b>" + param1 + "</b></font><font color=\'#ff0000\'><b>";
         var _loc3_:int = this.playerManager.getPlayer().getVipLevel() + 1;
         var _loc4_:String = "</b></font><font color=\'#1941A5\'><b>" + _loc3_ + "</b></font><font color=\'#ff0000\'><b>";
         this._mc["txt"].htmlText = "<font color=\'#ff0000\'><b>" + LangManager.getInstance().getLanguage("vip008",_loc2_,_loc4_) + "</b></font>";
      }
      
      private function clearBoxes() : void
      {
         while(this._mc["boxes"].numChilren > 0)
         {
            this._mc["boxes"].removeChildAt(0);
         }
      }
      
      private function showTime() : void
      {
         this._mc["_mc_time_title"].visible = true;
         this._mc["_mc_time"].visible = true;
         var _loc1_:int = int(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()).type);
         var _loc2_:int = int(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()).time);
         this.showVipLastTime(_loc1_,_loc2_);
      }
      
      private function showVipLastTime(param1:uint, param2:uint) : void
      {
         this._mc["_mc_time_title"].gotoAndStop(param1);
         if(this._mc["_mc_time"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_mc_time"]);
         }
         var _loc3_:DisplayObject = FuncKit.getNumEffect(param2 + "");
         _loc3_.x = -_loc3_.width / 2;
         this._mc["_mc_time"].addChild(_loc3_);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT || param3 == GET_PRIZES)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(param1 == INIT)
         {
            this._mc.visible = true;
            onShowEffectBig(this._mc);
            this.initVipStoreHouse(param2);
         }
         else if(param1 == GET_PRIZES)
         {
            PlantsVsZombies.playFireworks(4);
            PlantsVsZombies.playSounds(SoundManager.GRADE);
            this.showPrizes(this.getToolsInfo(param2));
            onHiddenEffectBig(this._mc,this.dispose);
         }
      }
      
      public function getToolsInfo(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Tool(param1[_loc3_]["tool_id"]);
            _loc4_.setNum(param1[_loc3_]["amount"]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function showPrizes(param1:Array) : void
      {
         var _loc2_:VIPPrizesWindow = new VIPPrizesWindow(PlantsVsZombies._node);
         _loc2_.show(param1,0,null);
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function changeBtVisible() : void
      {
         this._mc["continueVip"].visible = false;
         this._mc["openVip"].visible = false;
         this._mc["upgradeVip"].visible = false;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            if(this.playerManager.getPlayer().getVipLevel() == 4)
            {
               this._mc["continueVip"].visible = true;
            }
            else
            {
               this._mc["upgradeVip"].visible = true;
            }
         }
         else
         {
            this._mc["openVip"].visible = true;
         }
      }
      
      private function showExp(param1:int) : void
      {
         this.clearExp();
         if(param1 >= vipExpMax)
         {
            this._mc["bar"].scaleX = 1;
         }
         else
         {
            this._mc["bar"].scaleX = (this.getBarScaleLoction(this.playerManager.getPlayer().getVipLevel()) + this.getPer(param1) * (this.getBarScaleLoction(this.playerManager.getPlayer().getVipLevel() + 1) - this.getBarScaleLoction(this.playerManager.getPlayer().getVipLevel()))) / 500;
         }
         var _loc2_:DisplayObject = FuncKit.getNumEffect(param1 + "");
         _loc2_.x = -_loc2_.width / 2;
         this._mc["vipExp"].addChild(_loc2_);
      }
      
      private function getPer(param1:int) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 < 2000)
         {
            _loc2_ = param1 / 2000;
         }
         else if(param1 < 6000)
         {
            _loc2_ = (param1 - 2000) / 4000;
         }
         else if(param1 <= 18000)
         {
            _loc2_ = (param1 - 6000) / (18000 - 6000);
         }
         return _loc2_;
      }
      
      private function getBarScaleLoction(param1:int) : int
      {
         var _loc2_:int = 0;
         if(param1 == 1)
         {
            _loc2_ = 0;
         }
         else if(param1 == 2)
         {
            _loc2_ = 120;
         }
         else if(param1 == 3)
         {
            _loc2_ = 250;
         }
         else if(param1 == 4)
         {
            _loc2_ = 500;
         }
         return _loc2_;
      }
      
      private function clearExp() : void
      {
         if(this._mc["vipExp"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["vipExp"]);
         }
      }
      
      private function addEvent() : void
      {
         this._mc["introl"].addEventListener(MouseEvent.ROLL_OVER,this.showVipIntroduction);
         this._mc["introl"].addEventListener(MouseEvent.ROLL_OUT,this.HideVipIntroduction);
         this._mc["boxes"].addEventListener(MouseEvent.CLICK,this.onBoxClickHandle);
         this._mc["boxes"].addEventListener(MouseEvent.MOUSE_OVER,this.onBoxOverHandle);
         this._mc["boxes"].addEventListener(MouseEvent.MOUSE_OUT,this.onBoxOutHandle);
         this._mc["close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["continueVip"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["openVip"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["upgradeVip"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeBtEvent() : void
      {
         this._mc["introl"].removeEventListener(MouseEvent.ROLL_OVER,this.showVipIntroduction);
         this._mc["introl"].removeEventListener(MouseEvent.ROLL_OUT,this.HideVipIntroduction);
         this._mc["boxes"].removeEventListener(MouseEvent.CLICK,this.onBoxClickHandle);
         this._mc["boxes"].removeEventListener(MouseEvent.ROLL_OVER,this.onBoxOverHandle);
         this._mc["boxes"].removeEventListener(MouseEvent.MOUSE_OUT,this.onBoxOutHandle);
         this._mc["close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["continueVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["openVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["upgradeVip"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._mc.x = PlantsVsZombies.WIDTH >> 1;
         this._mc.y = PlantsVsZombies.HEIGHT >> 1;
      }
      
      private function dispose() : void
      {
         super.removeBG();
         this.removeBtEvent();
         this.clearExp();
         if(this._backFunc != null)
         {
            this._backFunc();
         }
         this._backFunc = null;
         this._boxTips = null;
         this.vipIntroduction = null;
         PlantsVsZombies._node.removeChild(this._mc);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "upgradeVip")
         {
            JSManager.toRecharge();
         }
         else if(param1.currentTarget.name == "openVip" || param1.currentTarget.name == "continueVip")
         {
            new ChallengePropWindow(ChallengePropWindow.TYPE_VIP,this.changeBtVisible,true);
         }
         onHiddenEffectBig(this._mc,this.dispose);
      }
   }
}

