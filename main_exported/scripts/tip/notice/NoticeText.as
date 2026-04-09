package tip.notice
{
   import flash.text.TextField;
   
   public class NoticeText extends TextField
   {
      
      public function NoticeText(param1:Array)
      {
         super();
         if(param1 == null || param1.length == 0)
         {
            throw new Error("NoticeText  Notice base array is null");
         }
         var _loc2_:String = "<p align = \'center\'>";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += this.getHtmlText(param1[_loc3_].sub,param1[_loc3_].c,14,true);
            if(_loc2_.length > 400)
            {
               _loc2_ += "<br>";
            }
            _loc3_++;
         }
         _loc2_ += "</p>";
         this.wordWrap = true;
         this.multiline = true;
         this.selectable = false;
         this.htmlText = _loc2_;
         this.width = 600;
         this.height = this.textHeight + 4;
      }
      
      public function getHtmlText(param1:String, param2:String, param3:int, param4:Boolean) : String
      {
         if(param4)
         {
            return "<font size=\'" + param3 + "\' color=\'" + param2 + "\'><b> " + param1 + "</b></font>";
         }
         return "<font size=\'" + param3 + "\' color=\'" + param2 + "\'> " + param1 + "</font>";
      }
   }
}

