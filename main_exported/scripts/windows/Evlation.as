package windows
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Goods;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.compose.panel.ComposeWindowNew;
   import pvz.shop.rpc.Shop_rpc;
   import pvz.storage.StorageWindow;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class Evlation extends BaseWindow
   {
      
      private static const INIT:int = 0;
      
      private var _price:int;
      
      private var _getId:int;
      
      private var _userNum:int;
      
      private var BOOK_BUY:int = 1;
      
      private var _baseArray:Array = null;
      
      private var _window:MovieClip;
      
      private var _getUserNum:int = 1;
      
      private var _callback:Function;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function Evlation(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("evol");
         this._window = new _loc2_();
         this._callback = param1;
         PlantsVsZombies._node.addChild(this._window);
         onShowEffect(this._window);
         this.setLoction();
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["eve"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["evl"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["evlo"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var loadedCall:Function;
         var e:MouseEvent = param1;
         if(e.currentTarget.name == "evl")
         {
            new ComposeWindowNew(null,null,false,false,null);
         }
         else if(e.currentTarget.name == "eve")
         {
            loadedCall = function(param1:ComposeWindowNew):void
            {
               param1.toOrgIntensify();
               param1 = null;
            };
            new ComposeWindowNew(null,null,true,false,loadedCall);
         }
         else if(e.currentTarget.name == "evlo")
         {
            new StorageWindow(null,null);
         }
         this.hidden();
      }
      
      private function upDateUserBookOne(param1:int) : void
      {
         var callBack:Function;
         var recharge:RechargeWindow = null;
         var str:String = null;
         var num:int = param1;
         this._getUserNum = num;
         if(this.playerManager.getPlayer().getRMB() >= this._price * num)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,this.BOOK_BUY,this._getId,num);
         }
         else
         {
            callBack = function():void
            {
               JSManager.toRecharge();
            };
            recharge = new RechargeWindow();
            str = "金券不足，是否充值？";
            recharge.init(str,callBack,1);
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         PlantsVsZombies.showDataLoading(true);
         if(param3 == this.BOOK_BUY)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
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
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Shop_rpc = null;
         var _loc4_:String = null;
         var _loc5_:DoActionWindow = null;
         var _loc6_:Tool = null;
         PlantsVsZombies.showDataLoading(false);
         if(param1 == INIT)
         {
            PlantsVsZombies.showDataLoading(false);
            _loc3_ = new Shop_rpc();
            this._baseArray = _loc3_.getShopArray(param2.goods);
            for(_loc4_ in this._baseArray)
            {
               if((this._baseArray[_loc4_] as Goods).getId() == ToolManager.TOOL_COMP_QUALITY)
               {
                  this._userNum = (this._baseArray[_loc4_] as Goods).getChangeNum();
                  this._getId = (this._baseArray[_loc4_] as Goods).getGoodsId();
                  this._price = (this._baseArray[_loc4_] as Goods).getPurchasePrice();
               }
            }
            _loc5_ = new DoActionWindow();
            _loc6_ = new Tool(ToolManager.TOOL_COMP_QUALITY);
            _loc5_.init(_loc6_.getPicId(),0,Icon.TOOL,_loc6_.getName(),LangManager.getInstance().getLanguage("window128",this._price,_loc6_.getName()),this.upDateUserBookOne,true,true,this._userNum);
         }
         else if(param1 == this.BOOK_BUY)
         {
            this.playerManager.getPlayer().updateTool(param2.tool.id,param2.tool.amount);
            PlantsVsZombies.changeMoneyOrExp(-this._getUserNum * this._price,PlantsVsZombies.RMB);
         }
      }
      
      private function removeEvent() : void
      {
         this._window["ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["evl"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["eve"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["evlo"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function hidden() : void
      {
         if(this._callback != null)
         {
            this._callback();
         }
         this.removeEvent();
         onHiddenEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
   }
}

