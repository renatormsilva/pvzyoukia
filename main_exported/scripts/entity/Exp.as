package entity
{
   import core.interfaces.IVo;
   import manager.LangManager;
   
   public class Exp implements IVo
   {
      
      private var _value:uint;
      
      public function Exp()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._value = param1.exp;
      }
      
      public function setExp(param1:int) : void
      {
         this._value = param1;
      }
      
      public function getExpValue() : int
      {
         return this._value;
      }
      
      public function getPicId() : int
      {
         return 3;
      }
      
      public function getName() : String
      {
         return LangManager.getInstance().getLanguage("VIPPrezesNode001");
      }
   }
}

