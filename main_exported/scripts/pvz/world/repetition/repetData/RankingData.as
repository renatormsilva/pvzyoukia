package pvz.world.repetition.repetData
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class RankingData extends EventDispatcher
   {
      
      private static const INIT:int = 2;
      
      private static const GET:int = 3;
      
      public static const ATTACK_FIRST_RANKING:String = "reclaim";
      
      public static const HONOR_RANKING:String = "medal";
      
      public static const COMPLETE_DEGREE_RANKING:String = "integral";
      
      private var _data:Object;
      
      public function RankingData()
      {
         super();
      }
      
      public function initPanelData(param1:String, param2:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STAGE_RANKING,0,param1,param2);
      }
      
      private function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callOO(param2,param3,rest[0],rest[1]);
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         this._data = param2;
         this.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get rankData() : Object
      {
         return this._data;
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
   }
}

