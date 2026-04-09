package zlib.sets
{
   public class ArrayList
   {
      
      protected var array:Array;
      
      public function ArrayList(param1:int = 0)
      {
         super();
         this.array = new Array(param1);
      }
      
      public function get length() : int
      {
         return this.array.length;
      }
      
      public function getItemAt(param1:int) : Object
      {
         return this.array[param1];
      }
      
      public function toArray() : Array
      {
         return this.array;
      }
      
      protected function getIndex(param1:*) : int
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.length)
         {
            if(this.getItemAt(_loc3_).name == param1.name)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function add(param1:*) : void
      {
         this.array.push(param1);
      }
      
      public function insert(param1:*, param2:int) : void
      {
         if(param2 >= 0 && param2 <= this.length)
         {
            this.array.splice(param2,0,param1);
         }
      }
      
      public function remove(param1:*) : void
      {
         var _loc2_:int = this.getIndex(param1);
         if(_loc2_ >= 0)
         {
            this.array.splice(_loc2_,1);
         }
      }
      
      public function removeAt(param1:int, param2:int = 1) : void
      {
         if(param1 >= 0 && param1 + param2 <= this.length)
         {
            this.array.splice(param1,param2);
         }
      }
      
      public function clear() : void
      {
         this.removeAt(0,this.length);
      }
   }
}

