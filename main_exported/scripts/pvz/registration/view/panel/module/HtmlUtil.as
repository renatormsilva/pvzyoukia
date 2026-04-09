package pvz.registration.view.panel.module
{
   public class HtmlUtil
   {
      
      public function HtmlUtil()
      {
         super();
      }
      
      public static function wapper(param1:String, param2:Object, param3:String = "#ffffff", param4:String = "#ffffff", param5:String = "") : String
      {
         return font(param1,param3) + fontBr(param5 + param2.toString(),param4);
      }
      
      public static function fontSize(param1:String, param2:int = 14) : String
      {
         return "<font size=\'" + param2 + "\'>" + param1 + "</font>";
      }
      
      public static function fontBr(param1:String, param2:String, param3:int = 14) : String
      {
         return font(param1,param2,param3) + "\n";
      }
      
      public static function font(param1:String, param2:String = "#ffffff", param3:int = 14) : String
      {
         return "<font color=\'" + param2 + "\' size=\'" + param3 + "\'>" + param1 + "</font>";
      }
      
      public static function fontFamily(param1:String, param2:String = "宋体") : String
      {
         return "<font font-family=\'" + param2 + "\' white-space=\'pre\'>" + param1 + "</font>";
      }
      
      public static function font2(param1:String, param2:uint, param3:int = 12) : String
      {
         return font(param1,"#" + param2.toString(16),param3);
      }
      
      public static function font3(param1:String, param2:String) : String
      {
         return "<font color=\'" + param2 + "\'>" + param1 + "</font>";
      }
      
      public static function br(param1:String) : String
      {
         return "<br>" + param1 + "</br>";
      }
      
      public static function bold(param1:String) : String
      {
         return "<b>" + param1 + "</b>";
      }
      
      public static function link(param1:String, param2:* = null, param3:Boolean = false) : String
      {
         if(param3)
         {
            return "<u><a href=\'event:" + param2 + "\'>" + param1 + "</a></u>";
         }
         return "<a href=\'event:" + param2 + "\'>" + param1 + "</a>";
      }
      
      public static function getColor(param1:String) : uint
      {
         var _loc3_:Number = NaN;
         var _loc2_:uint = 0;
         if(param1)
         {
            if(param1.charAt(0) == "#")
            {
               _loc3_ = Number("0x" + param1.slice(1));
            }
            else if(param1.charAt(1) == "x" && param1.charAt(0) == "0")
            {
               _loc3_ = Number(param1);
            }
            if(!isNaN(_loc3_))
            {
               _loc2_ = uint(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getColorString(param1:uint) : String
      {
         return "#" + param1.toString(16);
      }
      
      public static function filterHtml(param1:String) : String
      {
         return param1.replace(/\<\/?[^\<\>]+\>/gmi,"");
      }
   }
}

