package pvz.world.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Tool;
   import pvz.world.InsideWorldReward;
   import pvz.world.InsideWorldRewardWindow;
   
   public class InsideWorldRewardFPort implements IConnection
   {
      
      private static const REWARD_INIT:int = 1;
      
      private static const REWARD_GET:int = 2;
      
      private var _window:InsideWorldRewardWindow = null;
      
      public function InsideWorldRewardFPort(param1:InsideWorldRewardWindow)
      {
         super();
         this._window = param1;
      }
      
      public function initRewardDate(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INSIDEWORLD_INIT_REWARD,REWARD_INIT,param1);
      }
      
      public function getRewards(param1:String, param2:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INSIDEWORLD_GET_REWARD,REWARD_GET,param1,param2);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == REWARD_INIT)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == REWARD_GET)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param1 == REWARD_INIT)
         {
            this._window.portInitDate(this.readRewards(param2.rule.integral),this.readRewards(param2.rule.medal),param2.current.integral,param2.current.medal,param2.integral,param2.medal.amount);
         }
         else if(param1 == REWARD_GET)
         {
            this._window.portGetPrizes(this.readPrizes(param2),param2.next,param2.reward_type);
         }
      }
      
      private function readPrizes(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.tools.length)
         {
            _loc4_ = new Tool(param1.tools[_loc3_].tool_id);
            _loc4_.setNum(param1.tools[_loc3_].amount);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function readRewards(param1:Object) : Array
      {
         var _loc4_:InsideWorldReward = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new InsideWorldReward();
            _loc4_.setAwards(param1[_loc3_].tools);
            _loc4_.setType(param1[_loc3_].type);
            _loc4_.setValue(param1[_loc3_].current);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
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

