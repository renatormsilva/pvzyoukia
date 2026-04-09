package entity
{
   public class PlayerUpInfo
   {
      
      private var expMax:int = 0;
      
      private var expMin:int = 0;
      
      private var exp:int = 0;
      
      private var flowerpotNum:int = 0;
      
      private var friendlandsNum:int = 0;
      
      private var huntings:int = 0;
      
      private var currenthuntings:int = 0;
      
      private var money:int = 0;
      
      private var todayExpMax:int = 0;
      
      private var todayExpGeted:int = 0;
      
      private var tools:Array = null;
      
      private var upGrade:int = 0;
      
      private var worldTimes:int;
      
      private var occupynum:int;
      
      private var occupynumMax:int;
      
      public function PlayerUpInfo(param1:Object)
      {
         super();
         this.read(param1);
      }
      
      public function getExpMax() : int
      {
         return this.expMax;
      }
      
      public function getExpMin() : int
      {
         return this.expMin;
      }
      
      public function getFriendladns() : int
      {
         return this.friendlandsNum;
      }
      
      public function getHuntings() : int
      {
         return this.huntings;
      }
      
      public function getMoney() : int
      {
         return this.money;
      }
      
      public function getTodayExp() : int
      {
         return this.todayExpMax;
      }
      
      public function getTools() : Array
      {
         return this.tools;
      }
      
      public function getUpGrade() : int
      {
         return this.upGrade;
      }
      
      public function getflowerpotNum() : int
      {
         return this.flowerpotNum;
      }
      
      public function upDatePlayer(param1:Player, param2:int = 0) : void
      {
         param1.setGrade(this.upGrade);
         param1.setMoney(param1.getMoney() + this.money);
         param1.setExp_max(this.expMax);
         param1.setExp_min(this.expMin);
         if(param2 == 0)
         {
            param1.setTodayExp(this.todayExpGeted);
         }
         param1.setToadyMaxExp(this.todayExpMax);
         if(param2 == 0)
         {
            param1.setExp(this.exp);
         }
         param1.setFlowerpotNum(this.flowerpotNum);
         param1.setFriendLands(this.friendlandsNum);
         param1.setNowHunts(this.currenthuntings);
         param1.setHunts(this.huntings);
         if(param1.getGrade() == 9)
         {
            param1.setWorldTimes(this.worldTimes);
         }
         if(param1.getGrade() == 7)
         {
            param1.setOccupyNum(this.occupynum);
            param1.setOccupyMaxNum(this.occupynumMax);
         }
         this.upDateTools(param1);
      }
      
      public function upDataExp(param1:Player) : void
      {
         param1.setExp(this.exp);
      }
      
      private function read(param1:Object) : void
      {
         this.upGrade = param1.id;
         this.expMax = param1.max_exp;
         this.expMin = param1.min_exp;
         this.exp = param1.exp;
         this.money = param1.money;
         this.todayExpGeted = param1.today_exp;
         this.todayExpMax = param1.today_exp_max;
         this.flowerpotNum = param1.garden_organism_amount;
         this.friendlandsNum = param1.garden_amount;
         this.huntings = param1.max_cave;
         this.currenthuntings = param1.cave_amount;
         this.occupynum = param1.ter_ch_count;
         this.occupynumMax = param1.ter_ch_co_max;
         this.worldTimes = param1.fuben_lcc;
         this.readTools(param1);
      }
      
      private function readTools(param1:Object) : void
      {
         var _loc3_:Tool = null;
         this.tools = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.tools.length)
         {
            _loc3_ = new Tool(param1.tools[_loc2_].id);
            _loc3_.setNum(param1.tools[_loc2_].amount);
            this.tools.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function upDateTools(param1:Player) : void
      {
         if(this.tools == null || this.tools.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.tools.length)
         {
            param1.updateTool((this.tools[_loc2_] as Tool).getOrderId(),(this.tools[_loc2_] as Tool).getNum());
            _loc2_++;
         }
      }
   }
}

