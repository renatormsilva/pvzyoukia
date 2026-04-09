package pvz.firstpage.otherhelp
{
   public class ButtonVo
   {
      
      private var _limitLevel:int;
      
      private var _key:String;
      
      private var _lightType:int;
      
      public function ButtonVo(param1:Object)
      {
         super();
         this._limitLevel = param1.@levellimit;
         this._key = param1.@id;
         this._lightType = param1.@lightType;
      }
      
      public function get lightType() : int
      {
         return this._lightType;
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function get limitLevel() : int
      {
         return this._limitLevel;
      }
   }
}

