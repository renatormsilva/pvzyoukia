package pvz.garden.manager
{
   import entity.Organism;
   import flash.geom.Point;
   
   public class MapManager
   {
      
      internal var _x_num:int;
      
      internal var _y_num:int;
      
      internal var _x_length:int;
      
      internal var _y_length:int;
      
      internal var orgs:Array;
      
      internal var linage:int;
      
      internal var lastLinageNum:int;
      
      public var _num:int = 0;
      
      public var _monsters:Array;
      
      public function MapManager(param1:int, param2:int, param3:int, param4:Array)
      {
         super();
         this._x_num = param1;
         this._y_num = param2;
         this._num = param3;
         this.linage = this._num / this._x_num + 1;
         this.lastLinageNum = this._num % this._x_num;
         this._x_length = this._x_length;
         this._y_length = this._y_length;
         this.orgs = param4;
         this._monsters = [];
      }
      
      public function addOrg(param1:Organism) : void
      {
         if(this.orgs == null)
         {
            this.orgs = new Array();
         }
         this.orgs.push(param1);
      }
      
      private function isHaveOrgInOrgs(param1:Organism) : Boolean
      {
         if(this.orgs == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.orgs.length)
         {
            if(param1 == this.orgs[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function getGridPoint(param1:int) : Point
      {
         var _loc2_:Point = new Point();
         var _loc3_:int = (param1 - 1) % this._x_num;
         var _loc4_:int = (param1 - 1) / this._x_num;
         _loc2_.x = _loc3_;
         _loc2_.y = _loc4_;
         return _loc2_;
      }
      
      public function isInMap(param1:int, param2:Organism) : Boolean
      {
         if(param2 == null)
         {
            return false;
         }
         var _loc3_:int = this.getGridPoint(param1).x;
         var _loc4_:int = this.getGridPoint(param1).y;
         var _loc5_:int = param2.getWidth();
         var _loc6_:int = param2.getHeight();
         if(_loc4_ + 1 == this.linage)
         {
            if(_loc3_ + _loc5_ > this.lastLinageNum || _loc4_ > this._y_num - 1 || _loc4_ - _loc6_ < -1)
            {
               return false;
            }
         }
         else
         {
            if(_loc4_ + 1 >= this.linage)
            {
               return false;
            }
            if(_loc3_ + _loc5_ > this._x_num || _loc4_ > this._y_num - 1 || _loc4_ - _loc6_ < -1)
            {
               return false;
            }
         }
         return !this.isHaveOrg(_loc3_,_loc4_,param2);
      }
      
      private function isHaveOrg(param1:int, param2:int, param3:Organism) : Boolean
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc4_:Array = this.orgs ? this.orgs.concat(this._monsters) : this._monsters;
         if(_loc4_ == null || param3 == null)
         {
            return false;
         }
         var _loc5_:int = param3.getWidth();
         var _loc6_:int = param3.getHeight();
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc8_ = (_loc4_[_loc7_] as Organism).getWidth();
            _loc9_ = (_loc4_[_loc7_] as Organism).getHeight();
            _loc10_ = (_loc4_[_loc7_] as Organism).getX();
            _loc11_ = (_loc4_[_loc7_] as Organism).getY();
            if(param1 >= _loc10_ && param1 < _loc10_ + _loc8_ || param1 + _loc5_ > _loc10_ && param1 + _loc5_ <= _loc10_ + _loc8_)
            {
               if(param2 >= _loc11_ && param2 < _loc11_ + _loc9_ || param2 + _loc6_ > _loc11_ && param2 + _loc6_ <= _loc11_ + _loc9_)
               {
                  return true;
               }
            }
            _loc7_++;
         }
         return false;
      }
   }
}

