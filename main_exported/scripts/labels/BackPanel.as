package labels
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import entity.Goods;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.arena.fore.ArenaForelet;
   import pvz.shop.ShopWindow;
   import pvz.shop.rpc.Shop_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.DoActionWindow;
   import windows.RechargeWindow;
   import zlib.utils.DomainAccess;
   
   public class BackPanel extends Sprite
   {
      
      private static var _func:Function;
      
      private static const INIT:int = 0;
      
      private static const ORG_CHALLEGE_BUY:int = 1;
      
      private static const ORG_CHALLEGE_USER:int = 4;
      
      private static var _backFunc:Function = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _baseArray:Array = null;
      
      private var _getUserNum:int = 1;
      
      private var _hasVip:Boolean;
      
      private var _nowNum:int = 1;
      
      private var _panel:MovieClip;
      
      private var _tool:Tool;
      
      private var _type:int;
      
      private var actionWindow:ActionWindow;
      
      private var changeNum:int = 1;
      
      private var doActionWindow:DoActionWindow;
      
      private var getId:int;
      
      private var numUser:int = 1;
      
      private var price:int;
      
      private var userNum:int;
      
      public function BackPanel(param1:Function = null)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("BackPanel");
         this._panel = new _loc2_();
         _backFunc = param1;
         this.addChild(this._panel);
      }
      
      public static function toRecharge() : void
      {
         JSManager.toRecharge();
      }
      
      public function init(param1:Tool, param2:String, param3:int, param4:Function = null, param5:Boolean = false) : void
      {
         this._type = param3;
         _func = param4;
         this._hasVip = param5;
         Icon.setUrlIcon(this._panel["book"],param1.getPicId(),Icon.TOOL_1);
         this._panel["text"].text = param2;
         this._panel["back"].visible = false;
         this._tool = new Tool(param3);
         if(this.playerManager.getPlayer().getTool(param3))
         {
            this._panel["font"].addChild(FuncKit.getNumEffect("" + this.playerManager.getPlayer().getTool(param3).getNum()));
            this._panel["font"].x = this._panel["back"].x + this._panel["back"].width - this._panel["font"].width - 5;
         }
         this._panel["book"].addEventListener(MouseEvent.CLICK,this.onBookClick);
         this._panel["book"].addEventListener(MouseEvent.MOUSE_OVER,this.onBookOver);
         this._panel["book"].addEventListener(MouseEvent.MOUSE_OUT,this.onBookOut);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == ORG_CHALLEGE_BUY)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == ORG_CHALLEGE_USER)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      private function checkShopGood() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,ShopWindow.INIT);
      }
      
      private function getNum(param1:int) : int
      {
         return int(this.playerManager.getPlayer().getTool(param1).getNum());
      }
      
      private function gotoRechargeWindow() : void
      {
         var callBack:Function = null;
         callBack = function():void
         {
            JSManager.toRecharge();
         };
         var recharge:RechargeWindow = new RechargeWindow();
         var str:String = "金券不足，是否充值？";
         recharge.init(str,callBack,1);
      }
      
      private function onBookClick(param1:MouseEvent) : void
      {
         var upDateUserBookOne:Function;
         var num:int = 0;
         var e:MouseEvent = param1;
         this.actionWindow = new ActionWindow();
         this.doActionWindow = new DoActionWindow();
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.playerManager.getPlayer().getTool(this._type))
         {
            upDateUserBookOne = function(param1:int):void
            {
               _getUserNum = param1;
               netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TOOLS_USE,ORG_CHALLEGE_USER,_type,param1);
            };
            num = this.getNum(this._type);
            this.doActionWindow.init(this._tool.getPicId(),num,Icon.TOOL,this._tool.getName(),LangManager.getInstance().getLanguage("window125",this._tool.getName()),upDateUserBookOne,true,true);
         }
         else
         {
            PlantsVsZombies.showDataLoading(true);
            this.checkShopGood();
         }
         BackPanel._func();
      }
      
      private function onBookOut(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = true;
         this._panel["back"].visible = false;
      }
      
      private function onBookOver(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = true;
         this._panel["back"].visible = true;
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var upDataBuyVip:Function;
         var shoprpc:Shop_rpc = null;
         var i:String = null;
         var compTool:Tool = null;
         var str:String = null;
         var type:int = param1;
         var re:Object = param2;
         if(type == INIT)
         {
            PlantsVsZombies.showDataLoading(false);
            shoprpc = new Shop_rpc();
            this._baseArray = shoprpc.getShopArray(re.goods);
            for(i in this._baseArray)
            {
               if((this._baseArray[i] as Goods).getId() == this._type)
               {
                  this.userNum = (this._baseArray[i] as Goods).getChangeNum();
                  this.getId = (this._baseArray[i] as Goods).getGoodsId();
                  this.price = (this._baseArray[i] as Goods).getPurchasePrice();
               }
            }
            if(this._type == ToolManager.CHALL_BOOK_FIVE)
            {
               this.changeNum = 5;
            }
            if(this.userNum != 0)
            {
               compTool = new Tool(this._type);
               if(this._hasVip)
               {
                  upDataBuyVip = function():void
                  {
                     if(playerManager.getPlayer().getRMB() >= price)
                     {
                        netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,ORG_CHALLEGE_BUY,getId,1);
                     }
                     else
                     {
                        gotoRechargeWindow();
                     }
                  };
                  this.actionWindow = new ActionWindow();
                  this.actionWindow.init(compTool.getPicId(),Icon.TOOL,compTool.getName(),LangManager.getInstance().getLanguage("BackPanelWindow132",this.price,compTool.getName()),upDataBuyVip,true);
               }
               else
               {
                  if(compTool.getOrderId() == ToolManager.GARDEN_BOOK)
                  {
                     this.userNum = 5 - this.playerManager.getPlayer().getGardenChaCount();
                  }
                  this.doActionWindow.init(compTool.getPicId(),this.userNum,Icon.TOOL,compTool.getName(),LangManager.getInstance().getLanguage("window123",this.price,this.changeNum),this.upDateUserBookTwo,true,true,this.userNum);
               }
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("BackPanelWindow134",this._tool.getName()));
            }
         }
         else if(type == ORG_CHALLEGE_BUY)
         {
            this.playerManager.getPlayer().updateTool(re.tool.id,re.tool.amount);
            PlantsVsZombies.changeMoneyOrExp(-re.tool.amount * this.price,PlantsVsZombies.RMB);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TOOLS_USE,ORG_CHALLEGE_USER,this._type,this._getUserNum);
         }
         else if(type == ORG_CHALLEGE_USER)
         {
            this.playerManager.getPlayer().useTools(this._tool.getOrderId(),this._getUserNum);
            if(re.name == 1)
            {
               this.playerManager.getPlayer().setNowHunts(this.playerManager.getPlayer().getNowHunts() + re.effect);
               PlantsVsZombies.ChangeUserHuntNum();
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window112",this._getUserNum,this._tool.getName(),re.effect));
            }
            else if(re.name == 2)
            {
               this.playerManager.getPlayer().setArenaNum(this.playerManager.getPlayer().getArenaNum() + re.effect);
               PlantsVsZombies.ChangeUserHuntNum();
               BackPanel._backFunc(ArenaForelet.PUBLIC_CHANGE);
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window113",this._getUserNum,this._tool.getName(),re.effect));
            }
            else if(re.name == 8)
            {
               this.playerManager.getPlayer().setGardenChaCount(this.playerManager.getPlayer().getGardenChaCount() + re.effect);
               PlantsVsZombies.ChangeUserGardenNum();
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window183",this._getUserNum,this._tool.getName(),re.effect));
            }
            else
            {
               if(this.playerManager.getPlayer().getVipTime() != 0)
               {
                  str = this._tool.getName().charAt(3);
                  if(this._tool.getOrderId() == ToolManager.TOOL_VIP_SEASON)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("SellGoodsWindow135",this._getUserNum * 3,str));
                  }
                  else
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("SellGoodsWindow130",this._getUserNum,str));
                  }
               }
               else
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("SellGoodsWindow131"));
               }
               this.playerManager.getPlayer().setVipTime(re.append.vip_etime);
               this.playerManager.getPlayer().setVipLevel(re.append.vip_grade);
               this.playerManager.getPlayer().setToadyMaxExp(re.append.today_exp_max);
               if(_backFunc != null)
               {
                  BackPanel._backFunc();
               }
               PlantsVsZombies.setHeadPic(PlantsVsZombies._node["player"]["pic"],PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
            }
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function upDateUserBookTwo(param1:int) : void
      {
         this._getUserNum = param1;
         if(this.playerManager.getPlayer().getRMB() >= this.price * param1 && param1 <= this.userNum)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,ORG_CHALLEGE_BUY,this.getId,param1);
         }
         else
         {
            this.gotoRechargeWindow();
         }
      }
   }
}

