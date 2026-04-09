package pvz.world.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import manager.ToolManager;
   import pvz.shop.rpc.Shop_rpc;
   import pvz.world.InsideWorldNumPanel;
   
   public class WorldNumPanelFPort implements IConnection
   {
      
      private static const ADD_WORLDNUM_TOOL:int = 2;
      
      private static const ADD_WORLDNUM_MONEY:int = 3;
      
      private static const SHOP_INIT:int = 4;
      
      private var _panel:InsideWorldNumPanel = null;
      
      public function WorldNumPanelFPort(param1:InsideWorldNumPanel)
      {
         super();
         this._panel = param1;
      }
      
      public function useToolAddWorld(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TOOLS_USE,ADD_WORLDNUM_TOOL,ToolManager.TOOL_WORLD_ADDWORLD,param1);
      }
      
      public function costMoneyAddWorld(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_CHECKPOINT_ADDWORLD_RMB,ADD_WORLDNUM_MONEY,param1);
      }
      
      public function initInsideWorldBook() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,SHOP_INIT);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == ADD_WORLDNUM_TOOL)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == ADD_WORLDNUM_MONEY)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == SHOP_INIT)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Shop_rpc = null;
         if(param1 == ADD_WORLDNUM_TOOL)
         {
            if(param2.name == 5)
            {
               this._panel.portUseToolAddWorld(param2.effect);
            }
         }
         else if(param1 == ADD_WORLDNUM_MONEY)
         {
            this._panel.portAddWorldByRMB(int(param2));
         }
         else if(param1 == SHOP_INIT)
         {
            _loc3_ = new Shop_rpc();
            this._panel.portBuyInsideWorld(_loc3_.getGood(ToolManager.TOOL_WORLD_ADDWORLD,param2.goods));
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
   }
}

