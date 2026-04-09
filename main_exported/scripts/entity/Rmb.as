package entity
{
   public class Rmb
   {
      
      private var _value:uint;
      
      public function Rmb(param1:int = 0)
      {
         super();
         this.setValue(param1);
      }
      
      public function setValue(param1:int) : void
      {
         this._value = param1;
      }
      
      public function getValue() : int
      {
         return this._value;
      }
      
      public function getPicid() : int
      {
         return 295;
      }
      
      public function getName() : String
      {
         return "金券";
      }
      
      public function getUseCondition() : String
      {
         return "钱币";
      }
      
      public function getUseResult() : String
      {
         return "可获得" + this.getValue() + "金券";
      }
   }
}

