package pvz.world
{
   import entity.Tool;
   
   public class InsideWorldReward
   {
      
      public static const COMPLETE:String = "integral";
      
      public static const MEDAL:String = "medal";
      
      private var _value:int = 0;
      
      private var _awards:String = "";
      
      private var _awardTools:Array = null;
      
      private var _type:String = "";
      
      public function InsideWorldReward()
      {
         super();
      }
      
      public function setValue(param1:int) : void
      {
         this._value = param1;
      }
      
      public function getValue() : int
      {
         return this._value;
      }
      
      public function setAwards(param1:String) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Tool = null;
         this._awards = param1;
         this._awardTools = new Array();
         var _loc2_:Array = this._awards.split(";");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = (_loc2_[_loc3_] as String).split(",");
            _loc5_ = new Tool(_loc4_[0]);
            _loc5_.setNum(_loc4_[1]);
            this._awardTools.push(_loc5_);
            _loc3_++;
         }
      }
      
      public function getAwardTools() : Array
      {
         return this._awardTools;
      }
      
      public function setType(param1:String) : void
      {
         this._type = param1;
      }
      
      public function getType() : String
      {
         return this._type;
      }
      
      public function getRewardType(param1:int, param2:int) : int
      {
         if(param2 < this._value)
         {
            return 2;
         }
         if(param1 == 0)
         {
            return 1;
         }
         if(param1 > this._value)
         {
            return 1;
         }
         if(param1 == this._value)
         {
            return 3;
         }
         return 2;
      }
   }
}

