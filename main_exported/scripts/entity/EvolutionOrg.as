package entity
{
   public class EvolutionOrg
   {
      
      private var _id:int;
      
      private var _pid:int;
      
      private var _info:String;
      
      public function EvolutionOrg()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get picid() : int
      {
         return this._pid;
      }
      
      public function set picid(param1:int) : void
      {
         this._pid = param1;
      }
      
      public function get Info() : String
      {
         return this._info;
      }
      
      public function set Info(param1:String) : void
      {
         this._info = param1;
      }
   }
}

