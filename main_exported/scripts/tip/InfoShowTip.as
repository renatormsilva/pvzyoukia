package tip
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import utils.TextFilter;
   
   public class InfoShowTip extends Sprite
   {
      
      private var _backGround:Sprite;
      
      private var _contentSp:Sprite;
      
      private var _infoTxt:TextField;
      
      private var _txtFormat:TextFormat;
      
      private var _o:InteractiveObject;
      
      public function InfoShowTip()
      {
         super();
         this._backGround = new Sprite();
         this._contentSp = new Sprite();
         this.addChild(this._backGround);
         this._contentSp.x = 10;
         this._contentSp.y = 10;
         this.addChild(this._contentSp);
         this._txtFormat = new TextFormat();
         this._txtFormat.size = 14;
         this._infoTxt = new TextField();
         this._infoTxt.width = 120;
         this._infoTxt.height = 100;
         this._infoTxt.wordWrap = true;
         this._infoTxt.textColor = 2293504;
         this._infoTxt.setTextFormat(this._txtFormat);
         TextFilter.MiaoBian(this._infoTxt,0);
         this._contentSp.addChild(this._infoTxt);
         this.drawBg();
      }
      
      public function setTxt(param1:InteractiveObject, param2:String) : void
      {
         this._o = param1;
         this.setInfo(param2);
         this.setLoction(15,5);
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:Number, param2:Number) : void
      {
         this.x = this._o.x + this._o.parent.x - this.width / 2 + param1;
         this.y = this._o.y + this._o.parent.y - this.height + param2;
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         parent.removeChild(this);
      }
      
      private function setInfo(param1:String) : void
      {
         this._infoTxt.htmlText = param1;
         this._backGround.width = this._infoTxt.textWidth + 25;
         this._backGround.height = this._infoTxt.textHeight + 25;
      }
      
      private function drawBg() : void
      {
         this._backGround.graphics.clear();
         this._backGround.graphics.beginFill(0,0.7);
         this._backGround.graphics.drawRoundRect(0,0,this._contentSp.width + 10,this._contentSp.height + 10,30,30);
         this._backGround.graphics.endFill();
      }
   }
}

