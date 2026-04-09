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
   import pvz.possession.fport.PossessionUseFPort;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionChangeWindow;
   import windows.RechargeWindow;
   import zlib.utils.DomainAccess;
   
   public class PossessionUseAddWindow extends BaseWindow
   {
      
      private var _backFun:Function = null;
      
      private var _fport:PossessionUseFPort = null;
      
      private var _ids:Array = null;
      
      private var _t:Tool = null;
      
      private var _window:MovieClip = null;
      
      private var goods:Goods = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PossessionUseAddWindow(param1:Function)
      {
         super();
         if(this.getToolUseNum(1) == 0)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession018"));
            return;
         }
         this._t = new Tool(ToolManager.TOOL_POSSESSION_BATTLE);
         var _loc2_:Tool = this.playerManager.getPlayer().getTool(this._t.getOrderId());
         if(_loc2_ != null)
         {
            this._t.setNum(_loc2_.getNum());
         }
         this._backFun = param1;
         this._fport = new PossessionUseFPort(this);
         this.init();
         this.show();
      }
      
      public function portBuyTool(param1:int, param2:int) : void
      {
         this.playerManager.getPlayer().updateTool(param1,param2);
         this.playerManager.getPlayer().setRMB(this.playerManager.getPlayer().getRMB() - this.goods.getPurchasePrice() * param2);
         this.toUseAddTool(param2);
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
         new ActionChangeWindow().init(this._t.getPicId(),Icon.TOOL,this.buyToolInfo,this.toBuyAndUseTool,true,this.getToolUseNum(param1.getChangeNum()));
      }
      
      public function portToolUse(param1:int, param2:int, param3:int = 0) : void
      {
         this.playerManager.getPlayer().setOccupyNum(this.playerManager.getPlayer().getOccupyNum() + param2);
         this.playerManager.getPlayer().useTools(ToolManager.TOOL_POSSESSION_BATTLE,param2);
         if(this._backFun != null)
         {
            this._backFun();
         }
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession021",param2));
      }
      
      private function addEvent() : void
      {
         this._window["_close"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function buyAndUseTool() : void
      {
         this.initToolNumByShop();
      }
      
      private function buyToolInfo(param1:int) : String
      {
         return LangManager.getInstance().getLanguage("possession022",this.goods.getPurchasePrice() * param1,param1);
      }
      
      override public function destroy() : void
      {
         PlantsVsZombies._node.removeChild(this._window);
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
            hidden();
            if(_t.getNum() > 0)
            {
               useTool();
            }
            else
            {
               buyAndUseTool();
            }
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
         if(this._t.getNum() > 0)
         {
            num = FuncKit.getNumEffect(this._t.getNum() + "");
            dis["font"].addChild(num);
         }
         dis["text"].text = this._t.getName();
         dis.addEventListener(MouseEvent.MOUSE_OVER,onOver);
         dis.addEventListener(MouseEvent.MOUSE_OUT,onOut);
         dis.addEventListener(MouseEvent.CLICK,onBtClick);
         dis.x = -40;
         dis.y = -25;
         return dis;
      }
      
      private function getToolNumMax() : int
      {
         var _loc1_:Tool = this.playerManager.getPlayer().getTool(ToolManager.TOOL_POSSESSION_BATTLE);
         return _loc1_.getNum();
      }
      
      private function getToolUseNum(param1:int) : int
      {
         var _loc2_:int = this.playerManager.getPlayer().getOccupyMaxNum() - this.playerManager.getPlayer().getOccupyNum();
         return param1 < _loc2_ ? param1 : _loc2_;
      }
      
      private function hidden() : void
      {
         removeBG();
         this.removeEvent();
         this._window.visible = false;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_possession_use_add");
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
      
      private function toBuyAndUseTool(param1:int) : void
      {
         if(this.playerManager.getPlayer().getRMB() >= this.goods.getPurchasePrice() * param1)
         {
            this._fport.toBuyAndUseTool(param1,this.goods.getGoodsId());
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
      
      private function toUseAddTool(param1:int) : void
      {
         this._fport.toUseTool(param1,ToolManager.TOOL_POSSESSION_BATTLE);
      }
      
      private function useTool() : void
      {
         new ActionChangeWindow().init(this._t.getPicId(),Icon.TOOL,this.useToolInfo,this.toUseAddTool,true,this.getToolUseNum(this.getToolNumMax()));
      }
      
      private function useToolInfo(param1:int) : String
      {
         return LangManager.getInstance().getLanguage("possession023",param1);
      }
   }
}

