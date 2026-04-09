package pvz.serverbattle.entity
{
   public class SubMessage
   {
      
      private var _txt:String;
      
      private var _color:uint;
      
      public function SubMessage()
      {
         super();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
      }
      
      public function get txt() : String
      {
         return this._txt;
      }
      
      public function set txt(param1:String) : void
      {
         this._txt = param1;
      }
   }
}

