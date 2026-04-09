package pvz.possession.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Goods;
   import manager.APLManager;
   import manager.ToolManager;
   import pvz.possession.PossessionUseQuitWindow;
   import pvz.shop.rpc.Shop_rpc;
   
   public class PossessionBuyQuitFPort implements IConnection
   {
      
      private static const INIT:int = 2;
      
      private static const BUY:int = 3;
      
      internal var _window:PossessionUseQuitWindow = null;
      
      public function PossessionBuyQuitFPort(param1:PossessionUseQuitWindow)
      {
         super();
         this._window = param1;
      }
      
      public function toInitShop() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,INIT);
      }
      
      public function toBuyTool(param1:int, param2:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,BUY,param2,param1);
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
         else if(param3 == BUY)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Goods = null;
         var _loc4_:Shop_rpc = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         if(param1 == INIT)
         {
            _loc3_ = null;
            _loc4_ = new Shop_rpc();
            _loc5_ = _loc4_.getShopArray(param2.goods);
            for(_loc6_ in _loc5_)
            {
               if((_loc5_[_loc6_] as Goods).getId() == ToolManager.TOOL_POSSESSION_QUIT)
               {
                  _loc3_ = _loc5_[_loc6_];
               }
            }
            this._window.portShopInit(_loc3_);
         }
         else if(param1 == BUY)
         {
            this._window.portBuyTool(param2.tool.amount,param2.tool.id);
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

