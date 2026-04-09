package pvz.genius.fport
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   
   public class JewelSystermFPort
   {
      
      public static const COMPONSE:int = 1;
      
      private var _callback:Function;
      
      public function JewelSystermFPort()
      {
         super();
      }
      
      public function requestSever(param1:int, param2:Function, ... rest) : void
      {
         this._callback = param2;
         if(param1 == COMPONSE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.PRC_JEWELSYSTEM_COMPONSE,COMPONSE,rest[0],rest[1],rest[2]);
         }
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == COMPONSE)
         {
            _loc5_.callOOO(param2,param3,rest[0],rest[1],rest[2]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         if(param1 == COMPONSE)
         {
            if(this._callback != null)
            {
               this._callback(param2);
            }
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

