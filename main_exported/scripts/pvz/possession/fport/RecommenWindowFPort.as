package pvz.possession.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Player;
   import manager.APLManager;
   import pvz.possession.RecommenWindow;
   
   public class RecommenWindowFPort implements IConnection
   {
      
      private static const RECOMMEN:int = 1;
      
      private var _recommenWindow:RecommenWindow = null;
      
      public function RecommenWindowFPort(param1:RecommenWindow)
      {
         super();
         this._recommenWindow = param1;
      }
      
      public function toRecommen() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_POSSESSION_RECOMMEN,RECOMMEN);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == RECOMMEN)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      private function readPlayers(param1:Object) : Array
      {
         var _loc4_:Player = null;
         var _loc2_:Array = new Array();
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Player();
            _loc4_.setNickname(param1[_loc3_].nickname);
            _loc4_.setId(param1[_loc3_].user_id);
            _loc4_.setGrade(param1[_loc3_].grade);
            _loc4_.setFaceUrl2(param1[_loc3_].face);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(param1 == RECOMMEN)
         {
            this._recommenWindow.portShow(this.readPlayers(param2));
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

