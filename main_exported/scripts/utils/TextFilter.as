package utils
{
   import flash.display.DisplayObject;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextFilter
   {
      
      public function TextFilter()
      {
         super();
      }
      
      public static function MiaoBian(param1:DisplayObject, param2:uint = 16777215, param3:Number = 1, param4:int = 2, param5:int = 2, param6:int = 10, param7:int = 1) : void
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
      
      public static function removeFilter(param1:DisplayObject) : void
      {
         param1.filters = null;
      }
      
      public static function getCoulorByQuality(param1:int) : uint
      {
         var _loc2_:uint = 0;
         if(param1 == 1)
         {
            _loc2_ = 12632256;
         }
         else if(param1 == 2)
         {
            _loc2_ = 16777215;
         }
         else if(param1 == 3)
         {
            _loc2_ = 9621584;
         }
         else if(param1 == 4)
         {
            _loc2_ = 3109571;
         }
         else if(param1 == 5)
         {
            _loc2_ = 6684927;
         }
         else if(param1 == 6)
         {
            _loc2_ = 16724940;
         }
         else if(param1 == 7)
         {
            _loc2_ = 16225862;
         }
         else if(param1 >= 8)
         {
            _loc2_ = 16711680;
         }
         return _loc2_;
      }
      
      public static function getCoulorByGeniusLevel(param1:int) : uint
      {
         var _loc2_:uint = 0;
         if(param1 == 0)
         {
            _loc2_ = 12632256;
         }
         else if(param1 == 1)
         {
            _loc2_ = 16777215;
         }
         else if(param1 == 2)
         {
            _loc2_ = 9621584;
         }
         else if(param1 == 3)
         {
            _loc2_ = 1943295;
         }
         else if(param1 == 4)
         {
            _loc2_ = 2646180;
         }
         else if(param1 == 5)
         {
            _loc2_ = 6684927;
         }
         else if(param1 == 6)
         {
            _loc2_ = 16724940;
         }
         else if(param1 == 7)
         {
            _loc2_ = 16776960;
         }
         else if(param1 == 8)
         {
            _loc2_ = 16225862;
         }
         else if(param1 == 9 || param1 == 10)
         {
            _loc2_ = 16711680;
         }
         return _loc2_;
      }
   }
}

