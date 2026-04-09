package pvz.possession
{
   import core.ui.panel.BaseWindow;
   import entity.Goods;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.possession.fport.PossessionBuyQuitFPort;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionChangeWindow;
   import windows.RechargeWindow;
   import zlib.utils.DomainAccess;
   
   public class PossessionUseQuitWindow extends BaseWindow
   {
      
      private var _backFun:Function = null;
      
      private var _fport:PossessionBuyQuitFPort = null;
      
      private var _ids:Array = null;
      
      private var _p:Possession = null;
      
      private var _t:Tool = null;
      
      private var _window:MovieClip = null;
      
      private var goods:Goods = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PossessionUseQuitWindow(param1:Function, param2:Possession)
      {
         super();
         this._t = new Tool(ToolManager.TOOL_POSSESSION_QUIT);
         this._fport = new PossessionBuyQuitFPort(this);
         var _loc3_:Tool = this.playerManager.getPlayer().getTool(this._t.getOrderId());
         if(_loc3_ != null)
         {
            this._t.setNum(_loc3_.getNum());
         }
         this._backFun = param1;
         this._p = param2;
         this.init();
         this.show();
      }
      
      public function portBuyTool(param1:int, param2:int) : void
      {
         this.playerManager.getPlayer().updateTool(param2,param1);
         this.playerManager.getPlayer().setRMB(this.playerManager.getPlayer().getRMB() - this.goods.getPurchasePrice() * param1);
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession024",param1,this.goods.getName()));
         this.hidden();
      }
      
      public function portShopInit(param1:Goods) : void
      {
         if(param1 == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession019"));
            this.hidden();
            return;
         }
         this.goods = param1;
         new ActionChangeWindow().init(this._t.getPicId(),Icon.TOOL,this.buyToolInfo,this.toBuyTool,true,param1.getChangeNum());
      }
      
      private function addEvent() : void
      {
         this._window["_close"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function buyToolInfo(param1:int) : String
      {
         return LangManager.getInstance().getLanguage("possession025",this.goods.getPurchasePrice() * param1,param1);
      }
      
      private function getToolNode() : DisplayObject
      {
         var dis:MovieClip = null;
         var onBtClick:Function = null;
         var onOver:Function = null;
         var onOut:Function = null;
         var num:DisplayObject = null;
         onBtClick = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            toQuit();
         };
         onOver = function(param1:MouseEvent):void
         {
            dis["back"].visible = true;
            dis.buttonMode = true;
         };
         onOut = function(param1:MouseEvent):void
         {
            dis["back"].visible = false;
            dis.buttonMode = false;
         };
         var temp:Class = DomainAccess.getClass("BackPanel");
         dis = new temp();
         Icon.setUrlIcon(dis["book"],this._t.getPicId(),Icon.TOOL_1);
         dis["text"].text = this._t.getName();
         if(this._t.getNum() != 0)
         {
            num = FuncKit.getNumEffect(this._t.getNum() + "");
            dis["font"].addChild(num);
         }
         dis.addEventListener(MouseEvent.MOUSE_OVER,onOver);
         dis.addEventListener(MouseEvent.MOUSE_OUT,onOut);
         dis.addEventListener(MouseEvent.CLICK,onBtClick);
         dis.x = -40;
         dis.y = -25;
         return dis;
      }
      
      private function hidden() : void
      {
         removeBG();
         this.removeEvent();
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_possession_use_quit");
         this._window = new _loc1_();
         this._window.visible = false;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.addEvent();
      }
      
      private function initToolNumByShop() : void
      {
         this._fport.toInitShop();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(param1.currentTarget.name == "_close")
         {
            this.hidden();
         }
      }
      
      private function removeEvent() : void
      {
         this._window["_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      private function show() : void
      {
         this.setLoction();
         this._window.visible = true;
         this._window.addChild(this.getToolNode());
      }
      
      private function toBuyTool(param1:int) : void
      {
         if(this.playerManager.getPlayer().getRMB() >= this.goods.getPurchasePrice() * param1)
         {
            this._fport.toBuyTool(param1,this.goods.getGoodsId());
         }
         else
         {
            this.gotoRechargeWindow();
         }
      }
      
      private function gotoRechargeWindow() : void
      {
         var callBack:Function = null;
         callBack = function():void
         {
            JSManager.toRecharge();
         };
         var recharge:RechargeWindow = new RechargeWindow();
         recharge.init(LangManager.getInstance().getLanguage("possession038"),callBack);
      }
      
      private function toQuit() : void
      {
         if(this._t.getNum() > 0)
         {
            this.hidden();
            new PossessionReadyWindow(this._backFun,this._p,false,ToolManager.TOOL_POSSESSION_QUIT,this._p.getCostMoney()).show();
         }
         else
         {
            this.initToolNumByShop();
         }
      }
   }
}

