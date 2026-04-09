package pvz.task.rpc
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.Task;
   import entity.Tool;
   
   public class Task_rpc
   {
      
      public function Task_rpc()
      {
         super();
      }
      
      public function getTask(param1:Object) : Task
      {
         var _loc5_:int = 0;
         var _loc6_:Tool = null;
         var _loc7_:Exp = null;
         var _loc8_:GameMoney = null;
         var _loc9_:int = 0;
         var _loc10_:Tool = null;
         var _loc2_:Task = new Task();
         if(param1.text1 != null)
         {
            _loc2_.setInfo(param1.text1);
         }
         if(param1.award_type != null)
         {
            _loc2_.setAwardType(param1.award_type);
         }
         _loc2_.setStatus(param1.status);
         _loc2_.setExp(param1.exp);
         _loc2_.setChanllengeTimes(param1.challengeTimes);
         _loc2_.setTaskGuideType(param1.guide_type);
         _loc2_.setGameMoney(param1.gamemoney);
         _loc2_.setDuty_code(param1.duty_code);
         var _loc3_:Array = new Array();
         if(param1.award != null && param1.award.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.award.length)
            {
               if(_loc2_.getAwardType() != Task.AWARD_TYPE_3)
               {
                  _loc6_ = new Tool(param1.award[_loc5_].id);
                  _loc6_.setNum(param1.award[_loc5_].count);
                  _loc3_.push(_loc6_);
               }
               else
               {
                  _loc2_.setMoney(param1.award[_loc5_].count);
               }
               _loc5_++;
            }
         }
         if(_loc2_.getExp() > 0)
         {
            _loc7_ = new Exp();
            _loc7_.decode(param1);
            _loc3_.push(_loc7_);
         }
         if(_loc2_.getGameMoney() > 0)
         {
            _loc8_ = new GameMoney();
            _loc8_.decode(_loc2_.getGameMoney());
            _loc3_.push(_loc8_);
         }
         _loc2_.setAwards(_loc3_);
         var _loc4_:Array = new Array();
         if(param1.cost != null && param1.cost.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < param1.cost.length)
            {
               _loc10_ = new Tool(param1.cost[_loc9_].id);
               _loc10_.setNum(param1.cost[_loc9_].count);
               _loc4_.push(_loc10_);
               _loc9_++;
            }
         }
         _loc2_.setCost(_loc4_);
         return _loc2_;
      }
   }
}

