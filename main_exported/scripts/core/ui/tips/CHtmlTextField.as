package core.ui.tips
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import utils.TextFilter;
   
   public class CHtmlTextField extends Sprite
   {
      
      private var _bg:TipBg;
      
      private var _tf:TextField;
      
      private var _gap:Number;
      
      public function CHtmlTextField(param1:Number, param2:Number = 10)
      {
         super();
         this._gap = param2;
         this._bg = new TipBg();
         this._tf = new TextField();
         this._tf.width = param1;
         this._tf.autoSize = TextFieldAutoSize.LEFT;
         this._tf.multiline = true;
         this._tf.wordWrap = true;
         var _loc3_:TextFormat = this._tf.defaultTextFormat;
         _loc3_.color = 16777215;
         this._tf.defaultTextFormat = _loc3_;
         addChild(this._bg);
         addChild(this._tf);
         this._tf.x = param2;
         this._tf.y = param2;
      }
      
      public function setText(param1:String) : void
      {
         this._tf.htmlText = param1;
         TextFilter.MiaoBian(this._tf,0);
         this._bg.draw(this._tf.width + this._gap * 2,this._tf.height + this._gap * 2);
      }
      
      public function destory() : void
      {
         TextFilter.removeFilter(this._tf);
      }
   }
}

import flash.display.Sprite;

class TipBg extends Sprite
{
   
   public function TipBg()
   {
      super();
   }
   
   public function draw(param1:Number = 0, param2:Number = 0, param3:uint = 15722382) : void
   {
      this.graphics.clear();
      this.graphics.lineStyle(2,param3);
      this.graphics.beginFill(922887,0.85);
      this.graphics.drawRoundRect(0,0,param1,param2,10,10);
      this.graphics.endFill();
   }
}
