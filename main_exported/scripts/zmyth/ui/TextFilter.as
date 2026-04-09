package zmyth.ui
{
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextFilter
   {
      
      public function TextFilter()
      {
         super();
      }
      
      public static function MiaoBian(param1:TextField, param2:uint = 16777215, param3:Number = 1, param4:int = 3, param5:int = 3, param6:int = 10, param7:int = 1) : void
      {
         var _loc8_:GlowFilter = new GlowFilter(param2,param3,param4,param5,param6,param7,false,false);
         var _loc9_:Array = new Array();
         _loc9_ = param1.filters;
         _loc9_.push(_loc8_);
         param1.filters = _loc9_;
      }
      
      public static function setFontSize(param1:TextField, param2:int = 12) : void
      {
         var _loc3_:TextFormat = param1.defaultTextFormat;
         _loc3_.size = param2;
         param1.setTextFormat(_loc3_);
      }
      
      public static function removeFilter(param1:TextField) : void
      {
         param1.filters = null;
      }
   }
}

