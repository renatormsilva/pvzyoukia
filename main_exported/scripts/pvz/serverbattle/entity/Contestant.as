package pvz.serverbattle.entity
{
   public class Contestant
   {
      
      private var _faceurl:String;
      
      private var _grade:int;
      
      private var _id:int;
      
      private var _integral:int;
      
      private var _name:String;
      
      private var _servername:String;
      
      private var _viptime:int;
      
      private var _vipgrade:int;
      
      private var _plants:Array;
      
      public function Contestant()
      {
         super();
      }
      
      public function setRunPlants(param1:Array) : void
      {
         this._plants = param1;
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      public function setServerName(param1:String) : void
      {
         this._servername = param1;
      }
      
      public function setVipGrade(param1:int) : void
      {
         this._vipgrade = param1;
      }
      
      public function setVipTime(param1:int) : void
      {
         this._viptime = param1;
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function setIntegral(param1:int) : void
      {
         this._integral = param1;
      }
      
      public function setGrade(param1:int) : void
      {
         this._grade = param1;
      }
      
      public function setfaceUrl(param1:String) : void
      {
         this._faceurl = param1;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getServerName() : String
      {
         return this._servername;
      }
      
      public function getVipTime() : int
      {
         return this._viptime;
      }
      
      public function getIntegral() : int
      {
         return this._integral;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getGrade() : int
      {
         return this._grade;
      }
      
      public function getfaceUrl() : String
      {
         return this._faceurl;
      }
      
      public function getVipGrade() : int
      {
         return this._vipgrade;
      }
      
      public function getRunPlants() : Array
      {
         return this._plants;
      }
   }
}

