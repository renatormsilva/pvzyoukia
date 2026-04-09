package pvz.garden.rpc
{
   import entity.GardenDoworkEntity;
   import entity.Organism;
   import entity.Player;
   import entity.PlayerUpInfo;
   import entity.Tool;
   
   public class Garden_rpc
   {
      
      public function Garden_rpc()
      {
         super();
      }
      
      public function getOrgsWorks(param1:Array, param2:Array, param3:int, param4:int) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:GardenDoworkEntity = null;
         var _loc9_:int = 0;
         var _loc10_:GardenDoworkEntity = null;
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc7_ = 0;
            while(_loc7_ < param1.length)
            {
               _loc6_++;
               _loc8_ = new GardenDoworkEntity();
               _loc8_.setIsSuccess(true);
               _loc8_.setId(param1[_loc7_].id);
               _loc8_.setReExp(this.getWorkExp(param3,_loc6_));
               _loc8_.setReMoney(param4 / param1.length);
               _loc8_.setNextTime(param1[_loc7_].time);
               _loc8_.setNextType(param1[_loc7_].type);
               _loc8_.setHp(param1[_loc7_].hp);
               _loc5_.push(_loc8_);
               _loc7_++;
            }
         }
         if(param2 != null && param2.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < param2.length)
            {
               _loc10_ = new GardenDoworkEntity();
               _loc10_.setIsSuccess(false);
               _loc10_.setId(param2[_loc9_].id);
               _loc10_.setErrorType(param2[_loc9_].error);
               _loc10_.setErrorInfo(param2[_loc9_].message);
               _loc5_.push(_loc10_);
               _loc9_++;
            }
         }
         return _loc5_;
      }
      
      private function getWorkExp(param1:int, param2:int) : int
      {
         if(param1 - param2 < 0)
         {
            return 0;
         }
         return 1;
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
      
      public function updatePlayer(param1:Player, param2:Object) : void
      {
         param1.setMoney(int(param2.money) + param1.getMoney());
         param1.setGrade(param2.id);
         var _loc3_:int = param2.max_cave - param1.getHunts();
         param1.setNowHunts(param1.getNowHunts() + _loc3_);
         param1.setHunts(param2.max_cave);
         param1.setFlowerpotNum(param2.garden_organism_amount);
         param1.setFriendLands(param2.garden_amount);
         param1.setExp_max(param2.max_exp);
         param1.setExp_min(param2.min_exp);
         param1.setToadyMaxExp(param2.one_day_max_exp);
      }
      
      public function getPlayerUpMoney(param1:Object) : int
      {
         return param1.money;
      }
      
      public function getPlayerUpTools(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         if(param1.tools == null || param1.tools.length < 1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.tools.length)
         {
            _loc4_ = new Tool(param1.tools[_loc3_].id);
            _loc4_.setNum(param1.tools[_loc3_].amount);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addOrgException(param1:Array) : Array
      {
         var _loc4_:Organism = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Organism();
            _loc4_.setId(param1[_loc3_].id);
            _loc4_.setOrderId(param1[_loc3_].prototype_id);
            _loc4_.setGrade(param1[_loc3_].grade);
            _loc4_.setQuality_name(param1[_loc3_].quality);
            _loc4_.setOwner(param1[_loc3_].owner);
            _loc4_.setGainTime(param1[_loc3_].ripe_time);
            _loc4_.setTypeTime(param1[_loc3_].state.time);
            _loc4_.setNextType(param1[_loc3_].state.type);
            _loc4_.setHp(param1[_loc3_].hp);
            _loc4_.setHp_max(param1[_loc3_].hp_max);
            _loc4_.setX(param1[_loc3_].position.left_x);
            _loc4_.setY(param1[_loc3_].position.left_y);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getOrgsWorksGainAndSteal(param1:Array, param2:Array, param3:Array, param4:Array, param5:int) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:GardenDoworkEntity = null;
         var _loc10_:GardenDoworkEntity = null;
         var _loc11_:GardenDoworkEntity = null;
         var _loc12_:GardenDoworkEntity = null;
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         if(param1 != null || param1.length < 1)
         {
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               _loc7_++;
               _loc9_ = new GardenDoworkEntity();
               _loc9_.setIsSuccess(true);
               _loc9_.setId(param1[_loc8_].id);
               _loc9_.setReMoney(param1[_loc8_].money);
               _loc9_.setReExp(this.getWorkExp(param5,_loc7_));
               _loc6_.push(_loc9_);
               _loc8_++;
            }
         }
         if(param2 != null || param2.length < 1)
         {
            _loc8_ = 0;
            while(_loc8_ < param2.length)
            {
               _loc10_ = new GardenDoworkEntity();
               _loc10_.setIsSuccess(false);
               _loc10_.setId(param2[_loc8_].id);
               _loc10_.setErrorType(param2[_loc8_].error);
               _loc10_.setErrorInfo(param2[_loc8_].message);
               _loc6_.push(_loc10_);
               _loc8_++;
            }
         }
         if(param3 != null || param3.length < 1)
         {
            _loc8_ = 0;
            while(_loc8_ < param3.length)
            {
               _loc7_++;
               _loc11_ = new GardenDoworkEntity();
               _loc11_.setIsSuccess(true);
               _loc11_.setId(param3[_loc8_].id);
               _loc11_.setReMoney(param3[_loc8_].money);
               _loc11_.setReExp(this.getWorkExp(param5,_loc7_));
               _loc6_.push(_loc11_);
               _loc8_++;
            }
         }
         if(param4 != null || param4.length < 1)
         {
            _loc8_ = 0;
            while(_loc8_ < param4.length)
            {
               _loc12_ = new GardenDoworkEntity();
               _loc12_.setIsSuccess(false);
               _loc12_.setId(param4[_loc8_].id);
               _loc12_.setErrorType(param4[_loc8_].error);
               _loc12_.setErrorInfo(param4[_loc8_].message);
               _loc6_.push(_loc12_);
               _loc8_++;
            }
         }
         return _loc6_;
      }
   }
}

