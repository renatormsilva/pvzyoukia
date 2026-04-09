package entity
{
   import core.interfaces.IVo;
   import manager.LangManager;
   
   public class GameMoney implements IVo
   {
      
      private var _value:Number;
      
      public function GameMoney()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._value = param1 as Number;
      }
      
      public function getMoneyValue() : Number
      {
         return this._value;
      }
      
      public function getPicId() : int
      {
         return 4;
      }
      
      public function getName() : String
      {
         return LangManager.getInstance().getLanguage("金币");
      }
      
      public function getUseCondition() : String
      {
         return "钱币";
      }
      
      public function getUseResult() : String
      {
         return "可获得" + this.getMoneyValue() + "G";
      }
   }
}

