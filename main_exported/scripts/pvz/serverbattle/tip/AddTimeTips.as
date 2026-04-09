package pvz.serverbattle.tip
{
   import flash.text.TextField;
   import manager.LangManager;
   import tip.Tips;
   import utils.TextFilter;
   
   public class AddTimeTips extends Tips
   {
      
      private var _text:TextField;
      
      public function AddTimeTips(param1:Number, param2:Number)
      {
         super();
         this.graphics.beginFill(0,0.7);
         this.graphics.drawRoundRect(0,0,param1,param2,20,20);
         this.graphics.endFill();
         this._text = new TextField();
         this._text.width = 400;
         TextFilter.MiaoBian(this._text,0);
         this.addChild(this._text);
         this._text.y = 5;
         this._text.x = 10;
         this._text.x = 10;
      }
      
      public function crateHtmlTxt(param1:int, param2:int) : void
      {
         this._text.htmlText = "";
         var _loc3_:String = LangManager.getInstance().getLanguage("node013");
         var _loc4_:String = "</font><font color=\'#00ff00\' size=\'15\'>" + param1 + _loc3_ + "</font><font color=\'#ffffff\' size=\'15\'>";
         this._text.htmlText = "<font color=\'#ffffff\' size=\'15\'>" + LangManager.getInstance().getLanguage("severBattle001",_loc4_,param2) + "</font>";
      }
      
      public function getHtmlText(param1:String, param2:String, param3:int, param4:Boolean) : String
      {
         if(param4)
         {
            return "<font size=\'" + param3 + "\' color=\'" + param2 + "\'><b> " + param1 + " </b></font>";
         }
         return "<font size=\'" + param3 + "\' color=\'" + param2 + "\'> " + param1 + " </font>";
      }
   }
}

