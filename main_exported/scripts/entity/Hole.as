package entity
{
   import manager.OrganismManager;
   import utils.FuncKit;
   
   public class Hole
   {
      
      public static const ARRIVE:int = 2;
      
      public static const ARRIVE_NO:int = 1;
      
      public static const BATTLE:int = 3;
      
      public static const OPEN_NO:int = 0;
      
      public static const PRIZES:int = 6;
      
      private var awards:Array;
      
      private var awardsInfo:String = "";
      
      private var come_time:int = 0;
      
      private var sid:int = 0;
      
      private var holeName:String = "";
      
      private var id:int = 0;
      
      private var lastAttackName:String;
      
      private var lock_time:int = 0;
      
      private var masterTime:int = 0;
      
      private var openId:int;
      
      private var open_level:int = 0;
      
      private var open_money:int = 0;
      
      private var organisms:Array;
      
      private var playMoney:int = 0;
      
      private var type:int = 0;
      
      public function Hole()
      {
         super();
      }
      
      public function getAwards() : Array
      {
         var _loc2_:int = 0;
         if(this.awardsInfo != "" || this.awards == null)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         if(this.awards.length > PRIZES)
         {
            _loc2_ = FuncKit.getRandom(0,this.awards.length - PRIZES);
         }
         else
         {
            _loc2_ = 0;
         }
         return this.awards.slice(_loc2_,_loc2_ + PRIZES);
      }
      
      public function getAwardsInfo() : String
      {
         return this.awardsInfo;
      }
      
      public function getCome_time() : int
      {
         return this.come_time;
      }
      
      public function getSid() : int
      {
         return this.sid;
      }
      
      public function getHoleName() : String
      {
         return this.holeName;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getLastAttackName() : String
      {
         return this.lastAttackName;
      }
      
      public function getLock_time() : int
      {
         return this.lock_time;
      }
      
      public function getMasterTime() : int
      {
         return this.masterTime;
      }
      
      public function getOpenId() : int
      {
         return this.openId;
      }
      
      public function getOpen_level() : int
      {
         return this.open_level;
      }
      
      public function getOpen_money() : int
      {
         return this.open_money;
      }
      
      public function getOrganisms() : Array
      {
         return this.organisms;
      }
      
      public function getPlayMoney() : int
      {
         return this.playMoney;
      }
      
      public function getType() : int
      {
         return this.type;
      }
      
      public function readHole(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Organism = null;
         this.setType(param1.status);
         this.setCome_time(param1.come_time);
         this.setMasterTime(param1.lock_time);
         var _loc2_:Array = new Array();
         if(param1.monsters != null && param1.monsters.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.monsters.length)
            {
               _loc4_ = new Organism();
               _loc4_.readOrg(param1.monsters[_loc3_]);
               _loc2_.push(_loc4_);
               _loc3_++;
            }
         }
         this.setOrganisms(_loc2_);
      }
      
      public function setAwards(param1:Array) : void
      {
         this.awards = param1;
      }
      
      public function setAwardsInfo(param1:String) : void
      {
         this.awardsInfo = param1;
      }
      
      public function setCome_time(param1:int) : void
      {
         this.come_time = param1;
      }
      
      public function setSid(param1:int) : void
      {
         this.sid = param1;
      }
      
      public function setHoleName(param1:String) : void
      {
         this.holeName = param1;
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function setLastAttackName(param1:String) : void
      {
         if(param1 == null)
         {
            this.lastAttackName = "";
         }
         else
         {
            this.lastAttackName = param1;
         }
      }
      
      public function setLock_time(param1:int) : void
      {
         this.lock_time = param1;
      }
      
      public function setMasterTime(param1:int) : void
      {
         this.masterTime = param1;
      }
      
      public function setOpenId(param1:int) : void
      {
         this.openId = param1;
      }
      
      public function setOpen_level(param1:int) : void
      {
         this.open_level = param1;
      }
      
      public function setOpen_money(param1:int) : void
      {
         this.open_money = param1;
      }
      
      public function setOrganisms(param1:Array) : void
      {
         this.organisms = param1;
      }
      
      public function setPlayMoney(param1:int) : void
      {
         this.playMoney = param1;
      }
      
      public function setType(param1:int) : void
      {
         this.type = param1;
      }
      
      public function updateHole(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Organism = null;
         this.setType(param1.status);
         this.setOpenId(param1.open_id);
         this.setCome_time(param1.come_time);
         this.setMasterTime(param1.lock_time);
         var _loc2_:Array = new Array();
         if(param1.monsters != null && param1.monsters.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.monsters.length)
            {
               _loc4_ = new Organism();
               _loc4_.setBlood(OrganismManager.ZOMBIE);
               _loc4_.readOrg(param1.monsters[_loc3_]);
               _loc4_.setExp(0);
               _loc2_.push(_loc4_);
               _loc3_++;
            }
         }
         this.setOrganisms(_loc2_);
      }
   }
}

