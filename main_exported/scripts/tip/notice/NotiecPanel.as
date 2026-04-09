package tip.notice
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import utils.TextFilter;
   
   public class NotiecPanel extends Sprite
   {
      
      private static const WIDTH:int = 760;
      
      private static const HEIGTH:int = 24;
      
      private static const ALPHA:Number = 0.2;
      
      private var _width:int = 0;
      
      private var _heigth:int = 0;
      
      private var _text:TextField = null;
      
      public function NotiecPanel(param1:int = 0, param2:int = 0)
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._width = param1 == 0 ? WIDTH : param1;
         this._heigth = param2 == 0 ? HEIGTH : param2;
      }
      
      public function setText(param1:TextField) : void
      {
         if(this._text != null)
         {
            this.clear();
         }
         this._text = param1;
         TextFilter.removeFilter(this._text);
         this._text.x = (WIDTH - param1.width) / 2;
         this.addChild(this._text);
         if(this._text.height > 21)
         {
            this._heigth = HEIGTH * 2;
         }
         else
         {
            this._heigth = HEIGTH;
         }
         this.drawBG();
         TextFilter.MiaoBian(this._text,8288);
      }
      
      public function clear() : void
      {
         this.removeChild(this._text);
      }
      
      private function drawBG() : void
      {
         this.graphics.clear();
         this.graphics.beginFill(0,ALPHA);
         this.graphics.drawRect(0,0,this._width,this._heigth);
         this.graphics.endFill();
      }
   }
}

