package pvz.world
{
   import entity.Goods;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.shop.BuyGoodsWindow;
   import pvz.shop.ShopWindow;
   import pvz.world.fport.WorldNumPanelFPort;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionChangeWindow;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldNumPanel extends Sprite implements IDestroy
   {
      
      public static const ADD_WORLD_COST:int = 10;
      
      private var _panel:MovieClip = null;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _fport:WorldNumPanelFPort = null;
      
      private var _goods:Goods = null;
      
      public function InsideWorldNumPanel()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.initUI();
         this.addEvent();
         this._fport = new WorldNumPanelFPort(this);
         this.initData();
      }
      
      public function portBuyInsideWorld(param1:Goods) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this._goods = param1;
         this.clearNum();
         this._panel["_node_battle"].addChild(FuncKit.getNumEffect("" + this.playerManager.getPlayer().getWorldTimes()));
         if(this._goods == null || this._goods.getMaxNum() < 1)
         {
            this._panel["_bt_buy"].visible = false;
         }
         else
         {
            this._panel["_bt_buy"].visible = true;
         }
      }
      
      private function initData() : void
      {
         this._fport.initInsideWorldBook();
      }
      
      public function destroy() : void
      {
         this.clearNum();
         this.removeEvent();
      }
      
      public function showNum() : void
      {
         this.initData();
      }
      
      private function clearNum() : void
      {
         if(this._panel["_node_battle"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._panel["_node_battle"]);
         }
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.WorldNumPanel");
         this._panel = new _loc1_();
         addChild(this._panel);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_addBattle")
         {
            this.addWorldNum();
         }
         else if(param1.currentTarget.name == "_bt_buy")
         {
            this.buyInsideWorldBook();
         }
      }
      
      private function buyInsideWorldBook() : void
      {
         var _loc1_:BuyGoodsWindow = new BuyGoodsWindow();
         _loc1_.init(this._goods,null,ShopWindow.SHOP_RMB,this.initData,false);
         _loc1_.show();
      }
      
      private function addEvent() : void
      {
         this._panel["_bt_addBattle"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_buy"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._panel["_bt_addBattle"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_buy"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addWorldNum() : void
      {
         var _loc1_:Tool = this.playerManager.getPlayer().getTool(ToolManager.TOOL_WORLD_ADDWORLD);
         if(_loc1_ != null && _loc1_.getNum() > 0)
         {
            this.addWorldNumByTool(_loc1_);
         }
         else
         {
            this.addWorldNumByRMB();
         }
      }
      
      private function addWorldNumByTool(param1:Tool) : void
      {
         var toUseTool:Function = null;
         var t:Tool = param1;
         toUseTool = function(param1:int):String
         {
            return LangManager.getInstance().getLanguage("world010",param1,param1);
         };
         new ActionChangeWindow().init(t.getPicId(),Icon.TOOL,toUseTool,this.useToolAddWorld,true,t.getNum());
      }
      
      private function useToolAddWorld(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.useToolAddWorld(param1);
      }
      
      public function portUseToolAddWorld(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.playerManager.getPlayer().setWorldTimes(this.playerManager.getPlayer().getWorldTimes() + param1);
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world012",param1));
         this.playerManager.getPlayer().useTools(ToolManager.TOOL_WORLD_ADDWORLD,param1);
         this.showNum();
      }
      
      private function addWorldNumByRMB() : void
      {
         var toUseRMB:Function = function(param1:int):String
         {
            return LangManager.getInstance().getLanguage("world011",param1 * ADD_WORLD_COST,param1);
         };
         var getMaxNum:Function = function():int
         {
            return playerManager.getPlayer().getWorldBuyNum();
         };
         if(this._goods == null || this._goods.getMaxNum() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world024"));
         }
         else
         {
            this.buyInsideWorldBook();
         }
      }
      
      private function useRMBAddWorld(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.costMoneyAddWorld(param1);
      }
      
      public function portAddWorldByRMB(param1:int) : void
      {
         var _loc2_:int = param1 - this.playerManager.getPlayer().getWorldTimes();
         PlantsVsZombies.showDataLoading(false);
         this.playerManager.getPlayer().setRMB(this.playerManager.getPlayer().getRMB() - _loc2_ * ADD_WORLD_COST);
         this.playerManager.getPlayer().setWorldTimes(param1);
         this.playerManager.getPlayer().setWorldBuyNum(this.playerManager.getPlayer().getWorldBuyNum() - _loc2_);
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world012",_loc2_));
         this.showNum();
      }
   }
}

