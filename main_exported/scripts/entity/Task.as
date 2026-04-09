package entity
{
   public class Task
   {
      
      public static const STATUS_1:int = -2;
      
      public static const STATUS_2:int = -1;
      
      public static const STATUS_3:int = 0;
      
      public static const STATUS_4:int = 1;
      
      public static const AWARD_TYPE_1:int = 1;
      
      public static const AWARD_TYPE_2:int = 2;
      
      public static const AWARD_TYPE_3:int = 3;
      
      private var _status:int = -3;
      
      private var _cost:Array = null;
      
      private var _awards:Array = null;
      
      private var _info:String = "";
      
      private var _awardType:int = 0;
      
      private var _money:int = 0;
      
      private var duty_code:String;
      
      private var upgrades:Array = null;
      
      private var _exp:int = 0;
      
      private var _gameMoney:Number = 0;
      
      private var _msg:String = "";
      
      private var _taskGuideType:int = 0;
      
      private var _chanllengeTimes:int = 0;
      
      public function Task()
      {
         super();
      }
      
      public function setChanllengeTimes(param1:int) : void
      {
         this._chanllengeTimes = param1;
      }
      
      public function getChanllengeTimes() : int
      {
         return this._chanllengeTimes;
      }
      
      public function setTaskGuideType(param1:int) : void
      {
         this._taskGuideType = param1;
      }
      
      public function getTaskGuideType() : int
      {
         return this._taskGuideType;
      }
      
      public function setExp(param1:int) : void
      {
         this._exp = param1;
      }
      
      public function getExp() : int
      {
         return this._exp;
      }
      
      public function getGameMoney() : Number
      {
         return this._gameMoney;
      }
      
      public function setGameMoney(param1:Number) : void
      {
         this._gameMoney = param1;
      }
      
      public function setMsg(param1:String) : void
      {
         this._msg = param1;
      }
      
      public function getMsg() : String
      {
         return this._msg;
      }
      
      public function setUpGrades(param1:Array) : void
      {
         this.upgrades = param1;
      }
      
      public function getUpGrades() : Array
      {
         return this.upgrades;
      }
      
      public function setMoney(param1:int) : void
      {
         this._money = param1;
      }
      
      public function getMoney() : int
      {
         return this._money;
      }
      
      public function setAwardType(param1:int) : void
      {
         this._awardType = param1;
      }
      
      public function getAwardType() : int
      {
         return this._awardType;
      }
      
      public function setInfo(param1:String) : void
      {
         this._info = param1;
      }
      
      public function getInfo() : String
      {
         return this._info;
      }
      
      public function getAwards() : Array
      {
         return this._awards;
      }
      
      public function setAwards(param1:Array) : void
      {
         this._awards = param1;
      }
      
      public function getCost() : Array
      {
         return this._cost;
      }
      
      public function setCost(param1:Array) : void
      {
         this._cost = param1;
      }
      
      public function getStatus() : int
      {
         return this._status;
      }
      
      public function setStatus(param1:int) : void
      {
         this._status = param1;
      }
      
      public function getDuty_code() : String
      {
         return this.duty_code;
      }
      
      public function setDuty_code(param1:String) : void
      {
         this.duty_code = param1;
      }
   }
}

