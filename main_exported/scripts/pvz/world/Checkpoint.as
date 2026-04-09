package pvz.world
{
   import utils.FuncKit;
   
   public class Checkpoint
   {
      
      public static const NOT_ARRIVE:int = 0;
      
      public static const NOT_ENOUGH_LV:int = 1;
      
      public static const NOT_ENOUGH_TOOL:int = 2;
      
      public static const NOT_OPEN:int = 3;
      
      public static const UNFINISHED:int = 4;
      
      public static const FINISHED:int = 5;
      
      public static const NOT_ENOUGH_PATH:int = 6;
      
      private static const PRIZES:int = 6;
      
      private var _battleTimes:int = 0;
      
      private var _downlinks:Array = null;
      
      private var _id:int = 0;
      
      private var _maxBattleTimes:int = 0;
      
      private var _maxOrgNum:int = 0;
      
      private var _name:String = "";
      
      private var _nextMapId:int = 0;
      
      private var _openLv:int = 0;
      
      private var _openTools:Array = null;
      
      private var _type:int = 0;
      
      private var _uplinks:Array = null;
      
      private var _cost:int = 0;
      
      private var _importantPrizes:Array = null;
      
      private var _prizes:Array = null;
      
      private var _isBoss:Boolean = false;
      
      private var _point:int = 0;
      
      private var _isMap:Boolean = false;
      
      private var _showId:int = 0;
      
      public function Checkpoint()
      {
         super();
      }
      
      public function setShowId(param1:int) : void
      {
         this._showId = param1;
      }
      
      public function getShowId() : int
      {
         return this._showId;
      }
      
      public function setIsMap(param1:Boolean) : void
      {
         this._isMap = param1;
      }
      
      public function getIsMap() : Boolean
      {
         return this._isMap;
      }
      
      public function setPoint(param1:int) : void
      {
         this._point = param1;
      }
      
      public function getPoint() : int
      {
         return this._point;
      }
      
      public function setIsBoss(param1:Boolean) : void
      {
         this._isBoss = param1;
      }
      
      public function getIsBoss() : Boolean
      {
         return this._isBoss;
      }
      
      public function setPrizes(param1:Array) : void
      {
         this._prizes = param1;
      }
      
      public function getPrizes() : Array
      {
         var _loc2_:int = 0;
         if(this._prizes == null || this._prizes.length < 1)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         if(this._prizes.length > PRIZES)
         {
            _loc2_ = FuncKit.getRandom(0,this._prizes.length - PRIZES);
         }
         else
         {
            _loc2_ = 0;
         }
         return this._prizes.slice(_loc2_,_loc2_ + PRIZES);
      }
      
      public function getIsOpen() : Boolean
      {
         if(this._type == UNFINISHED || this._type == FINISHED)
         {
            return true;
         }
         return false;
      }
      
      public function getIsPass() : Boolean
      {
         if(this._type == FINISHED)
         {
            return true;
         }
         return false;
      }
      
      public function setImportantPrizes(param1:Array) : void
      {
         this._importantPrizes = param1;
      }
      
      public function getImportantPrizes() : Array
      {
         return this._importantPrizes;
      }
      
      public function setCost(param1:int) : void
      {
         this._cost = param1;
      }
      
      public function getCost() : int
      {
         return this._cost;
      }
      
      public function getBattleTimes() : int
      {
         return this._battleTimes;
      }
      
      public function getDownlinks() : Array
      {
         return this._downlinks;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getMaxBattleTimes() : int
      {
         return this._maxBattleTimes;
      }
      
      public function getMaxOrgNum() : int
      {
         return this._maxOrgNum;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getNextMapId() : int
      {
         return this._nextMapId;
      }
      
      public function getOpenLv() : int
      {
         return this._openLv;
      }
      
      public function getOpenTools() : Array
      {
         return this._openTools;
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function getUplinks() : Array
      {
         return this._uplinks;
      }
      
      public function setBattleTimes(param1:int) : void
      {
         this._battleTimes = param1;
      }
      
      public function setDownlinks(param1:Array) : void
      {
         this._downlinks = param1;
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function setMaxBattleTimes(param1:int) : void
      {
         this._maxBattleTimes = param1;
      }
      
      public function setMaxOrgNum(param1:int) : void
      {
         this._maxOrgNum = param1;
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      public function setNextMapId(param1:int) : void
      {
         this._nextMapId = param1;
      }
      
      public function setOpenLv(param1:int) : void
      {
         this._openLv = param1;
      }
      
      public function setOpenTools(param1:Array) : void
      {
         this._openTools = param1;
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
      }
      
      public function setUplinks(param1:Array) : void
      {
         this._uplinks = param1;
      }
   }
}

