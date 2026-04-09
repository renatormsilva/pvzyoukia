package pvz.hunting.rpc
{
   import entity.Hole;
   
   public class Hunting_rpc
   {
      
      public function Hunting_rpc()
      {
         super();
      }
      
      public function getOpenLastId(param1:Object) : int
      {
         return param1.id;
      }
      
      public function updateHole(param1:Array, param2:Object) : Array
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Hole).getId() == int(param2.id))
            {
               (param1[_loc3_] as Hole).updateHole(param2);
            }
            _loc3_++;
         }
         return param1;
      }
   }
}

