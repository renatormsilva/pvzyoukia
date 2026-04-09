package pvz.genius.vo
{
   import entity.Tool;
   
   public class GeniusData
   {
      
      private var _name:String;
      
      private var _sgid:String;
      
      private var _describeA:String;
      
      private var _describeB:String;
      
      private var _info:String;
      
      private var _Level:int;
      
      private var _triggerOdds:int;
      
      private var _hurt:Number;
      
      private var _requiredTool:Tool;
      
      private var _requiredOrgGrade:int;
      
      private var _requireUserGrade:int;
      
      public function GeniusData(param1:String, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:String, param9:int, param10:int, param11:Tool)
      {
         super();
         this._sgid = param1;
         this._name = param2;
         this._describeA = param3;
         this._describeB = param4;
         this._Level = param5;
         this._triggerOdds = param6;
         this._hurt = param7;
         this._info = param8;
         this._requiredTool = param11;
         this._requiredOrgGrade = param9;
         this._requireUserGrade = param10;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get sid() : String
      {
         return this._sgid;
      }
      
      public function get describeA() : String
      {
         return this._describeA;
      }
      
      public function get describeB() : String
      {
         return this._describeB;
      }
      
      public function get info() : String
      {
         return this._info;
      }
      
      public function get level() : int
      {
         return this._Level;
      }
      
      public function get triggerOdds() : int
      {
         return this._triggerOdds;
      }
      
      public function get hurt() : Number
      {
         return this._hurt;
      }
      
      public function get requiredTool() : Tool
      {
         return this._requiredTool;
      }
      
      public function get requiredOrgGrade() : int
      {
         return this._requiredOrgGrade;
      }
      
      public function get requiredUserGrade() : int
      {
         return this._requireUserGrade;
      }
      
      public function toString() : void
      {
      }
   }
}

