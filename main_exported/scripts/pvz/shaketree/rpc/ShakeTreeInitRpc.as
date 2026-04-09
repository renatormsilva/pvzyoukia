package pvz.shaketree.rpc
{
   import entity.Tool;
   import pvz.shaketree.vo.PassData;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import pvz.shaketree.vo.ZombiesVo;
   
   public class ShakeTreeInitRpc
   {
      
      public function ShakeTreeInitRpc()
      {
         super();
      }
      
      public function parseInitData(param1:Object) : void
      {
         var _loc4_:Tool = null;
         var _loc5_:String = null;
         var _loc6_:ZombiesVo = null;
         var _loc7_:String = null;
         ShakeTreeSystermData.I.setChanllgeTime(param1.count);
         var _loc2_:PassData = new PassData();
         _loc2_.setPassLevel(param1.level);
         _loc2_.setBaojiOdds(param1.probability);
         _loc2_.setBaojiMult(param1.max_multiple);
         _loc2_.setMessage(param1.messages);
         _loc2_.setRate(param1.rate);
         var _loc3_:Array = [];
         for(_loc5_ in param1.level_reward)
         {
            _loc4_ = new Tool(param1.level_reward[_loc5_].id);
            _loc4_.setNum(param1.level_reward[_loc5_].amount);
            _loc3_.push(_loc4_);
         }
         _loc2_.setPassLevelPrizes(_loc3_);
         for(_loc7_ in param1.zombies)
         {
            _loc6_ = new ZombiesVo();
            _loc6_.decode(param1.zombies[_loc7_]);
            _loc2_.addZomies(_loc6_);
         }
         ShakeTreeSystermData.I.setCurrentPassData(_loc2_);
         ShakeTreeSystermData.I.setCanBuyChanllageTimes(param1.can_buy_count);
         ShakeTreeSystermData.I.setHelpStaus(param1.helper);
      }
   }
}

