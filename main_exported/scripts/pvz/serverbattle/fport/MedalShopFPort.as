package pvz.serverbattle.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import pvz.serverbattle.rpc.MedelShop_rpc;
   import pvz.serverbattle.shop.BuyMedalGoodsWindow;
   import pvz.serverbattle.shop.MedalShopWindow;
   
   public class MedalShopFPort
   {
      
      public static const INIT:int = 1;
      
      public static const BUY:int = 2;
      
      public static const SELL:int = 3;
      
      public static const INIT_DATA:int = 8;
      
      private var _disFore:*;
      
      public function MedalShopFPort(param1:* = null)
      {
         super();
         this._disFore = param1;
      }
      
      public function requestSever(param1:int, ... rest) : void
      {
         if(param1 == INIT)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_MEDAL_SHOP_INIT,INIT,INIT_DATA);
         }
         else if(param1 == BUY)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_MEDAL_SHOP_BUY,BUY,rest[0],rest[1]);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == BUY)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:MedelShop_rpc = null;
         var _loc4_:Array = null;
         if(param1 == INIT)
         {
            _loc3_ = new MedelShop_rpc();
            _loc4_ = _loc3_.getAllMedalGoods(param2);
            (this._disFore as MedalShopWindow).initShop(_loc4_);
         }
         else if(param1 == BUY)
         {
            (this._disFore as BuyMedalGoodsWindow).buySucess();
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
      }
   }
}

