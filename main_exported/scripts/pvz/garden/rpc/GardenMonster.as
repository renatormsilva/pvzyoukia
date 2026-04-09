package pvz.garden.rpc
{
   import entity.Organism;
   import entity.Tool;
   import flash.geom.Point;
   import manager.OrganismManager;
   
   public class GardenMonster
   {
      
      private var _id:int;
      
      private var _monid:int;
      
      private var _pid:String;
      
      private var _owid:Number;
      
      private var _rewardTools:Array;
      
      private var _position:Point;
      
      private var _monsters:Array;
      
      private var _showOrg:Organism;
      
      private var _name:String;
      
      private var _grade_max:int;
      
      private var _grade_min:int;
      
      public function GardenMonster()
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
      
      public function get monid() : int
      {
         return this._monid;
      }
      
      public function set monid(param1:int) : void
      {
         this._monid = param1;
      }
      
      public function get pid() : String
      {
         return this._pid;
      }
      
      public function set pid(param1:String) : void
      {
         this._pid = param1;
      }
      
      public function get owid() : Number
      {
         return this._owid;
      }
      
      public function set owid(param1:Number) : void
      {
         this._owid = param1;
      }
      
      public function get rewardTools() : Array
      {
         return this._rewardTools;
      }
      
      public function set rewardTools(param1:Array) : void
      {
         this._rewardTools = param1;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function set position(param1:Point) : void
      {
         this._position = param1;
      }
      
      public function get monsters() : Array
      {
         return this._monsters;
      }
      
      public function set monsters(param1:Array) : void
      {
         this._monsters = param1;
      }
      
      public function getShowOrg() : Organism
      {
         this._showOrg = new Organism();
         this._showOrg.setBlood(OrganismManager.ZOMBIE);
         this._showOrg.setId(this._id);
         this._showOrg.setOrderId(1);
         this._showOrg.setPic(int(this._pid));
         this._showOrg.setX(this._position.x);
         this._showOrg.setY(this._position.y);
         return this._showOrg;
      }
      
      public function getToolName() : Object
      {
         var _loc3_:Tool = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         for each(_loc3_ in this._rewardTools)
         {
            _loc1_ = _loc1_ + _loc3_.getName() + "|";
         }
         _loc4_ = _loc1_.split("|");
         _loc5_ = "";
         if(_loc4_.length > 6)
         {
            return Math.random() > 0.5 ? _loc4_.slice(6,_loc4_.length) : _loc4_.slice(0,6);
         }
         return _loc4_;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get grade_max() : int
      {
         return this._grade_max;
      }
      
      public function set grade_max(param1:int) : void
      {
         this._grade_max = param1;
      }
      
      public function get grade_min() : int
      {
         return this._grade_min;
      }
      
      public function set grade_min(param1:int) : void
      {
         this._grade_min = param1;
      }
   }
}

