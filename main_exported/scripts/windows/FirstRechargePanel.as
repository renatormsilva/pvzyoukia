package windows
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.VipPicLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.invitePrizes.PrizeWindow;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class FirstRechargePanel extends BaseWindow
   {
      
      private static var getPrizeType:Boolean;
      
      private static var GET:int = 2;
      
      private static var INIT:int = 1;
      
      private var _back:Function;
      
      private var _firstRechargePanel:Sprite;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function FirstRechargePanel(param1:Function)
      {
         this._back = param1;
         super(UINameConst.UI_FIRSTCHARGE);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("firstRecharge");
         this._firstRechargePanel = new _loc1_();
         this.showPanel();
         this.addButtonEvent();
      }
      
      public function getPrizeData() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GET_FIRSTRECHARGE,GET);
      }
      
      public function initData() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INIT_FIRSTRECHARGE,INIT);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param1 == INIT)
         {
            this.setPanelData(param2);
         }
         else if(param1 == GET)
         {
            getPrizeType = true;
            this.disposePanel(true);
            this.showActiveToolsPrizes(param2);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      public function showActiveToolsPrizes(param1:Object) : void
      {
         var toolsWindow:PrizeWindow;
         var back:Function = null;
         var prize:Object = param1;
         back = function():void
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window151"));
         };
         PlantsVsZombies.playFireworks(3);
         toolsWindow = new PrizeWindow(PlantsVsZombies._node as MovieClip);
         toolsWindow.show(this.getToolsByPrezes(prize["reward"]),back);
      }
      
      private function addButtonEvent() : void
      {
         this._firstRechargePanel["close"].addEventListener(MouseEvent.CLICK,this.onClickFunc);
         this._firstRechargePanel["recharge"].addEventListener(MouseEvent.CLICK,this.onClickFunc);
         this._firstRechargePanel["getPrize"].addEventListener(MouseEvent.CLICK,this.onClickFunc);
         this._firstRechargePanel["getPrize"].addEventListener(MouseEvent.MOUSE_OVER,this.onGetPrizeOver);
         this._firstRechargePanel["getPrize"].addEventListener(MouseEvent.MOUSE_OUT,this.onGetPrizeOut);
      }
      
      private function clearTools() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 6)
         {
            if(this._firstRechargePanel["pic_" + _loc1_].numChildren > 0)
            {
               FuncKit.clearAllChildrens(this._firstRechargePanel["pic_" + _loc1_]);
            }
            this._firstRechargePanel["txt_" + _loc1_].text = "";
            this._firstRechargePanel["num_" + _loc1_].text = "";
            _loc1_++;
         }
      }
      
      private function disposePanel(param1:Boolean = false) : void
      {
         if(param1)
         {
            onHiddenEffect(this._firstRechargePanel,this.disposePanel);
         }
         else
         {
            this.removeButtonEvent();
            this._firstRechargePanel.parent.removeChild(this._firstRechargePanel);
            this._firstRechargePanel = null;
            if(this._back != null && getPrizeType)
            {
               this._back(2);
               this.playerManager.getPlayer().setFirstRecharge(2);
            }
            this._back = null;
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
      
      private function onClickFunc(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "close":
               this.disposePanel(true);
               break;
            case "recharge":
               PlantsVsZombies.toRecharge();
               break;
            case "getPrize":
               this.getPrizeData();
         }
      }
      
      private function onGetPrizeOut(param1:MouseEvent) : void
      {
         this._firstRechargePanel["getPrize"].gotoAndStop(2);
      }
      
      private function onGetPrizeOver(param1:MouseEvent) : void
      {
         this._firstRechargePanel["getPrize"].gotoAndStop(3);
      }
      
      private function removeButtonEvent() : void
      {
         this._firstRechargePanel["close"].removeEventListener(MouseEvent.CLICK,this.onClickFunc);
         this._firstRechargePanel["recharge"].removeEventListener(MouseEvent.CLICK,this.onClickFunc);
         this._firstRechargePanel["getPrize"].removeEventListener(MouseEvent.CLICK,this.onClickFunc);
         this._firstRechargePanel["getPrize"].removeEventListener(MouseEvent.MOUSE_OVER,this.onGetPrizeOver);
         this._firstRechargePanel["getPrize"].removeEventListener(MouseEvent.MOUSE_OUT,this.onGetPrizeOut);
      }
      
      private function setLoction() : void
      {
         this._firstRechargePanel.x = PlantsVsZombies.WIDTH >> 1;
         this._firstRechargePanel.y = PlantsVsZombies.HEIGHT >> 1;
      }
      
      private function setPanelData(param1:Object) : void
      {
         var _loc2_:int = int(param1["info"]);
         if(_loc2_ == 1)
         {
            this._firstRechargePanel["clue"].gotoAndStop(2);
            this._firstRechargePanel["getPrize"].gotoAndStop(2);
            this._firstRechargePanel["getPrize"].buttonMode = true;
         }
         else if(_loc2_ == 3)
         {
            this._firstRechargePanel["clue"].gotoAndStop(1);
            this._firstRechargePanel["getPrize"].mouseEnabled = false;
         }
         this.showTools(this.getToolsByPrezes(param1["reward"]));
      }
      
      private function showPanel() : void
      {
         this._firstRechargePanel.visible = false;
         PlantsVsZombies._node.addChild(this._firstRechargePanel);
         super.showBG(PlantsVsZombies._node);
         onShowEffect(this._firstRechargePanel);
         PlantsVsZombies._node.setChildIndex(this._firstRechargePanel,PlantsVsZombies._node.numChildren - 1);
         this._firstRechargePanel["clue"].gotoAndStop(1);
         this._firstRechargePanel["getPrize"].gotoAndStop(1);
         this._firstRechargePanel.visible = true;
         this.setLoction();
         this.initData();
      }
      
      private function showTools(param1:Array) : void
      {
         var _loc3_:VipPicLabel = null;
         this.clearTools();
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new VipPicLabel(param1[_loc2_]);
            this._firstRechargePanel["pic_" + (_loc2_ + 1)].addChild(_loc3_);
            this._firstRechargePanel["txt_" + (_loc2_ + 1)].text = (param1[_loc2_] as Tool).getName();
            this._firstRechargePanel["num_" + (_loc2_ + 1)].text = (param1[_loc2_] as Tool).getNum() + "个";
            _loc2_++;
         }
      }
   }
}

