package pvz.storage.rpc
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.LevelUpInfo;
   import entity.Organism;
   import entity.Tool;
   
   public class GetPrizes_rpc
   {
      
      public function GetPrizes_rpc()
      {
         super();
      }
      
      public static function getAllBackTools(param1:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Tool = null;
         var _loc2_:Array = param1;
         var _loc3_:int = int(_loc2_.length);
         param1 = [];
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = int(_loc4_["tool_id"]);
            _loc6_ = int(_loc4_["amount"]);
            _loc7_ = new Tool(_loc5_);
            _loc7_.setNum(_loc6_);
            param1.push(_loc7_);
         }
         return param1;
      }
      
      public function getAwards(param1:Object) : Array
      {
         var _loc4_:Array = null;
         if(param1.list == null || param1.list.length < 1)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.list.length)
         {
            _loc4_ = new Array(2);
            _loc4_[0] = param1.list[_loc3_].type;
            _loc4_[1] = param1.list[_loc3_].value;
            _loc4_[2] = param1.list[_loc3_].quality;
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getAllAwards(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         var _loc2_:Array = new Array();
         _loc2_ = this.getOrganisms(param1);
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
      
      public function getGameMoneyAwards(param1:Object) : GameMoney
      {
         var _loc2_:GameMoney = null;
         if(param1.prize_money > 0)
         {
            _loc2_ = new GameMoney();
            _loc2_.decode(Number(param1.prize_money));
            return _loc2_;
         }
         return null;
      }
      
      public function getExpAwards(param1:Object) : Exp
      {
         var _loc2_:Exp = null;
         if(param1.prize_exp > 0)
         {
            _loc2_ = new Exp();
            _loc2_.setExp(param1.prize_exp);
            return _loc2_;
         }
         return null;
      }
      
      public function getTools(param1:Object) : Array
      {
         var _loc4_:Tool = null;
         if(param1.tools == null)
         {
            return null;
         }
         var _loc2_:Array = new Array();
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
      
      public function getOrganisms(param1:Object) : Array
      {
         var _loc4_:Organism = null;
         if(param1.organisms == null)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.organisms.length)
         {
            _loc4_ = new Organism();
            _loc4_.readOrg(param1.organisms[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getUpInfos(param1:Object) : Array
      {
         var _loc4_:LevelUpInfo = null;
         var _loc5_:Object = null;
         var _loc2_:Array = param1.up_grade;
         var _loc3_:Array = new Array();
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = new LevelUpInfo();
            _loc4_.readData(_loc5_);
            _loc3_.push(_loc4_);
         }
         return _loc3_;
      }
   }
}

