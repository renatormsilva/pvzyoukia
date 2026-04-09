package zlib.sets
{
   public dynamic class Hashtable
   {
      
      protected var errKeys:String;
      
      public function Hashtable(... rest)
      {
         super();
         this.init();
         this.constructTable(rest);
      }
      
      protected function init() : void
      {
         this.errKeys = ",init,allow,constructTable,fill,add,remove,clear,keys";
      }
      
      protected function allow(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         if(this.errKeys.indexOf("," + param1) >= 0)
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      protected function constructTable(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] is Array)
            {
               _loc3_ = param1[_loc2_] as Array;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_].split(";");
                  _loc6_ = new Object();
                  _loc6_[_loc5_[0]] = _loc5_[1];
                  this.fill(_loc6_);
                  _loc4_++;
               }
            }
            else
            {
               this.fill(param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function fill(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            this.add(_loc2_,param1[_loc2_]);
         }
      }
      
      public function add(param1:String, param2:*) : void
      {
         if(this.allow(param1))
         {
            this[param1] = param2;
         }
      }
      
      public function remove(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(this.allow(param1))
         {
            _loc2_ = this[param1];
            delete this[param1];
            return _loc2_;
         }
         return null;
      }
      
      public function clear() : void
      {
         var _loc1_:ArrayList = this.keys;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.remove(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get keys() : ArrayList
      {
         var _loc2_:String = null;
         var _loc1_:ArrayList = new ArrayList();
         for(_loc2_ in this)
         {
            if(this.allow(_loc2_))
            {
               _loc1_.add(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get values() : ArrayList
      {
         var _loc2_:Object = null;
         var _loc1_:ArrayList = new ArrayList();
         for each(_loc2_ in this)
         {
            _loc1_.add(_loc2_);
         }
         return _loc1_;
      }
      
      public function toString() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.keys.toArray().length)
         {
            trace("[" + this.keys.getItemAt(_loc1_) + "]=","[" + this[this.keys.getItemAt(_loc1_)] + "]:");
            _loc1_++;
         }
      }
   }
}

