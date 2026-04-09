package pvz.world.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import pvz.world.Checkpoint;
   import pvz.world.OpenWindow;
   
   public class OpenWindowFPort implements IConnection
   {
      
      private static const OPEN:int = 1;
      
      private var _openWindow:OpenWindow = null;
      
      public function OpenWindowFPort(param1:OpenWindow)
      {
         super();
         this._openWindow = param1;
      }
      
      public function toOpenWindow(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_CHECKPOINT_OPEN,OPEN,param1);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == OPEN)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param1 == OPEN)
         {
            this._openWindow.portOpenCheckpoint(this.readCheckpoint(param2));
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
      
      private function readCheckpoint(param1:Object) : Checkpoint
      {
         var _loc2_:Checkpoint = new Checkpoint();
         _loc2_.setMaxOrgNum(param1.open_cave_grid);
         _loc2_.setType(param1.status);
         _loc2_.setMaxBattleTimes(param1.challenge_count);
         _loc2_.setBattleTimes(param1.lcc);
         return _loc2_;
      }
   }
}

