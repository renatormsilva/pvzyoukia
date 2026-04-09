package pvz.serverbattle.tip
{
   import entity.Organism;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import tip.Tips;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlQualityConfig;
   
   public class GuessPlantsTip extends Tips
   {
      
      private var _textA:TextField;
      
      private var _textB:TextField;
      
      public function GuessPlantsTip(param1:Number, param2:Number)
      {
         super();
         this.graphics.beginFill(0,0.7);
         this.graphics.drawRoundRect(0,0,param1,param2,20,20);
         this.graphics.endFill();
         this._textA = new TextField();
         this._textA.width = param1 - 10;
         this._textA.height = this._textA.textHeight + 4;
         this._textA.x = 5;
         this._textA.y = 5;
         this._textA.autoSize = TextFieldAutoSize.CENTER;
         TextFilter.MiaoBian(this._textA,0);
         this._textB = new TextField();
         this._textB.width = param1 - 10;
         this._textB.height = this._textB.textHeight + 4;
         this._textB.x = 5;
         this._textB.y = 20;
         this._textB.autoSize = TextFieldAutoSize.CENTER;
         TextFilter.MiaoBian(this._textB,0);
         this.addChild(this._textA);
         this.addChild(this._textB);
      }
      
      public function setInfo(param1:Organism) : void
      {
         var changeColor:Function;
         var color:uint = 0;
         var org:Organism = param1;
         this._textA.htmlText = "<font color=\'#ffffff\' size=\'12\'>" + org.getName() + "</font>";
         this._textB.htmlText = "<font color=\'#ffffff\' size=\'12\'>" + org.getUse_condition() + "</font>";
         if(org.getQuality_name() != "")
         {
            changeColor = function(param1:uint):void
            {
               _textA.textColor = param1;
            };
            color = XmlQualityConfig.getInstance().getColor(org.getQuality_name());
            changeColor(color);
         }
      }
      
      override public function destroy() : void
      {
         this.graphics.clear();
         FuncKit.clearAllChildrens(this);
         this.parent.removeChild(this);
      }
   }
}

