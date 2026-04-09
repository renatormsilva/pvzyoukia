package pvz.vip.rpc
{
   import entity.Player;
   import entity.PlayerUpInfo;
   import entity.Tool;
   
   public class Vip_rpc
   {
      
      public function Vip_rpc()
      {
         super();
      }
      
      public function getToolsInfo(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         if(param1.tools == null)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.tools.length)
         {
            _loc4_ = new Tool(param1.tools[_loc3_][0]);
            _loc4_.setNum(param1.tools[_loc3_][1]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getIsPrizes(param1:Object) : int
      {
         return param1.vip_get;
      }
      
      public function getGradeUpInfos(param1:Object) : Array
      {
         var _loc4_:PlayerUpInfo = null;
         if(!param1.is_up)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.up_grade.length)
         {
            _loc4_ = new PlayerUpInfo(param1.up_grade[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function upDateExp(param1:int, param2:Player) : void
      {
         param2.setTodayExp(param2.getTodayExp() + param1);
         param2.setExp(param2.getExp() + param1);
      }
      
      public function canUpGrade(param1:Object) : Boolean
      {
         return param1.is_up;
      }
      
      public function getMoney(param1:Object) : int
      {
         return param1.reward.money;
      }
      
      public function getEXP(param1:Object) : int
      {
         return param1.reward.user_exp;
      }
   }
}

