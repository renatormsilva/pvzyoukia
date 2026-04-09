package entity
{
   import core.interfaces.IVo;
   
   public class Honor implements IVo
   {
      
      private var _value:uint;
      
      public function Honor()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._value = uint(param1);
      }
      
      public function setHonor(param1:int) : void
      {
         this._value = param1;
      }
      
      public function getHonorValue() : int
      {
         return this._value;
      }
      
      public function getPicId() : int
      {
         return 266;
      }
      
      public function getName() : String
      {
         return "荣誉值";
      }
   }
}

