package entity
{
   public class GardenDoworkEntity
   {
      
      internal var errorInfo:String;
      
      internal var errorType:String;
      
      internal var hp:String;
      
      internal var id:int;
      
      internal var isSuccess:Boolean;
      
      internal var nextTime:int;
      
      internal var nextType:int;
      
      internal var reExp:int;
      
      internal var reMoney:int;
      
      internal var type:String = "";
      
      public function GardenDoworkEntity()
      {
         super();
      }
      
      public function getErrorInfo() : String
      {
         return this.errorInfo;
      }
      
      public function getErrorType() : String
      {
         return this.errorType;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getIsSuccess() : Boolean
      {
         return this.isSuccess;
      }
      
      public function getReExp() : int
      {
         return this.reExp;
      }
      
      public function getReMoney() : int
      {
         return this.reMoney;
      }
      
      public function getType() : String
      {
         return this.type;
      }
      
      public function setErrorInfo(param1:String) : void
      {
         this.errorInfo = param1;
      }
      
      public function setErrorType(param1:String) : void
      {
         this.errorType = param1;
      }
      
      public function setHp(param1:String) : void
      {
         this.hp = param1;
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function setIsSuccess(param1:Boolean) : void
      {
         this.isSuccess = param1;
      }
      
      public function setNextTime(param1:int) : void
      {
         this.nextTime = param1;
      }
      
      public function setNextType(param1:int) : void
      {
         this.nextType = param1;
      }
      
      public function setReExp(param1:int) : void
      {
         this.reExp = param1;
      }
      
      public function setReMoney(param1:int) : void
      {
         this.reMoney = param1;
      }
      
      public function setType(param1:String) : void
      {
         this.type = param1;
      }
      
      public function updateOrg(param1:Organism) : void
      {
         param1.setHp(this.hp);
         param1.setTypeTime(this.nextTime);
         param1.setNextType(this.nextType);
      }
   }
}

