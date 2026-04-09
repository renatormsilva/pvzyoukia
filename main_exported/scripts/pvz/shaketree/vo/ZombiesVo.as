package pvz.shaketree.vo
{
   import core.interfaces.IVo;
   import entity.Tool;
   import flash.geom.Point;
   import pvz.shaketree.utils.ShakeTree_Kit;
   
   public class ZombiesVo implements IVo
   {
      
      private var _id:int;
      
      private var _hp:int;
      
      private var _orgId:int;
      
      private var _positionId:int;
      
      private var _direction:int;
      
      private var _maxHp:int;
      
      private var _isBoss:int;
      
      private var _isDeath:int;
      
      private var _name:String;
      
      private var _mustTools:Array = [];
      
      private var _probleTools:Array = [];
      
      public function ZombiesVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._id = param1.id;
         this._orgId = param1.pi;
         this._hp = param1.hp;
         this._maxHp = param1.hm;
         this._positionId = param1.pt;
         this._direction = param1.dt;
         this._isBoss = param1.bs;
         this._name = param1.na;
         this.setProbleTools(param1);
         this.setMustTools(param1);
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      private function setProbleTools(param1:Object) : void
      {
         var _loc3_:Tool = null;
         this._probleTools = [];
         var _loc2_:int = int(param1.rd[1].length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Tool(param1.rd[1][_loc4_][0]);
            _loc3_.setNum(param1.rd[1][_loc4_][1]);
            this._probleTools.push(_loc3_);
            _loc4_++;
         }
      }
      
      public function getProbelTools() : Array
      {
         return this._probleTools;
      }
      
      private function setMustTools(param1:Object) : void
      {
         var _loc3_:Tool = null;
         this._mustTools = [];
         var _loc2_:int = int(param1.rd[0].length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Tool(param1.rd[0][_loc4_][0]);
            _loc3_.setNum(param1.rd[0][_loc4_][1]);
            this._mustTools.push(_loc3_);
            _loc4_++;
         }
      }
      
      public function getMustTools() : Array
      {
         return this._mustTools;
      }
      
      public function setIsDeath(param1:int) : void
      {
         this._isDeath = param1;
      }
      
      public function getIsDeath() : Boolean
      {
         return this._isDeath > 0;
      }
      
      public function getIsBoss() : Boolean
      {
         return this._isBoss > 0;
      }
      
      public function getMaxHp() : int
      {
         return this._maxHp;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getHp() : int
      {
         return this._hp;
      }
      
      public function setHp(param1:int) : void
      {
         this._hp = param1;
      }
      
      public function position() : Point
      {
         return ShakeTree_Kit.getPositionByZomibesPositionId(this._positionId);
      }
      
      public function getDirection() : int
      {
         return this._direction;
      }
      
      public function getOrgId() : int
      {
         return this._orgId;
      }
   }
}

