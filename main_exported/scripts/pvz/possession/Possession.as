package pvz.possession
{
   public class Possession
   {
      
      internal var cdTime:int = 0;
      
      internal var costMoney:int = 0;
      
      internal var face:String = "";
      
      internal var honor:int = 0;
      
      internal var income:int = 0;
      
      internal var isHelp:Boolean = false;
      
      internal var lastAwardTime:int = 0;
      
      internal var master:String = "";
      
      internal var masterLv:int = 0;
      
      internal var occupyGrade:int = 0;
      
      internal var occupyId:Number = 0;
      
      internal var occupyName:String = "";
      
      internal var occupyOrgs:Array = null;
      
      internal var occupyTime:int = 0;
      
      internal var possessionId:Number = 0;
      
      internal var _vipLevel:int = 0;
      
      internal var _vipTime:int = 0;
      
      public function Possession()
      {
         super();
      }
      
      public function setVipTime(param1:int) : void
      {
         this._vipTime = param1;
      }
      
      public function getVipTime() : int
      {
         return this._vipTime;
      }
      
      public function setVipLevel(param1:int) : void
      {
         this._vipLevel = param1;
      }
      
      public function getVipLevel() : int
      {
         return this._vipLevel;
      }
      
      public function getCDTime() : int
      {
         return this.cdTime;
      }
      
      public function getCostMoney() : int
      {
         return this.costMoney;
      }
      
      public function getFace() : String
      {
         return this.face;
      }
      
      public function getHonor() : int
      {
         return this.honor;
      }
      
      public function getIncome() : int
      {
         return this.income;
      }
      
      public function getIsHelp() : Boolean
      {
         return this.isHelp;
      }
      
      public function getLastAwardTime() : int
      {
         return this.lastAwardTime;
      }
      
      public function getMaster() : String
      {
         return this.master;
      }
      
      public function getMasterLv() : int
      {
         return this.masterLv;
      }
      
      public function getOccupyGrade() : int
      {
         return this.occupyGrade;
      }
      
      public function getOccupyId() : Number
      {
         return this.occupyId;
      }
      
      public function getOccupyName() : String
      {
         return this.occupyName;
      }
      
      public function getOccupyOrgs() : Array
      {
         return this.occupyOrgs;
      }
      
      public function getOccupyTime() : int
      {
         return this.occupyTime;
      }
      
      public function getPossessionId() : Number
      {
         return this.possessionId;
      }
      
      public function setCDTime(param1:int) : void
      {
         this.cdTime = param1;
      }
      
      public function setCostMoney(param1:int) : void
      {
         this.costMoney = param1;
      }
      
      public function setFace(param1:String) : void
      {
         this.face = param1;
      }
      
      public function setHonor(param1:int) : void
      {
         this.honor = param1;
      }
      
      public function setIncome(param1:int) : void
      {
         this.income = param1;
      }
      
      public function setIsHelp(param1:Boolean) : void
      {
         this.isHelp = param1;
      }
      
      public function setLastAwardTime(param1:int) : void
      {
         this.lastAwardTime = param1;
      }
      
      public function setMaster(param1:String) : void
      {
         this.master = param1;
      }
      
      public function setMasterLv(param1:int) : void
      {
         this.masterLv = param1;
      }
      
      public function setOccupyId(param1:Number) : void
      {
         this.occupyId = param1;
      }
      
      public function setOccupyName(param1:String) : void
      {
         this.occupyName = param1;
      }
      
      public function setOccupyOrgs(param1:Array) : void
      {
         this.occupyOrgs = param1;
      }
      
      public function setOccupyTime(param1:int) : void
      {
         this.occupyTime = param1;
      }
      
      public function setOccuypGrade(param1:int) : void
      {
         this.occupyGrade = param1;
      }
      
      public function setPossessionId(param1:Number) : void
      {
         this.possessionId = param1;
      }
   }
}

