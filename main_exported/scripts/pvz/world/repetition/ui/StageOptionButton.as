package pvz.world.repetition.ui
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import manager.SoundManager;
   import pvz.world.repetition.events.StageClickEvent;
   import utils.ReBuidBitmap;
   
   public class StageOptionButton extends Sprite
   {
      
      private var stageName:TextField;
      
      private var backDefault:ReBuidBitmap;
      
      private var backOver:ReBuidBitmap;
      
      private var backClicked:ReBuidBitmap;
      
      private var _data:Object;
      
      public var id:int;
      
      private var bitmapDisData:BitmapData;
      
      public function StageOptionButton()
      {
         super();
         this.stageName = new TextField();
         this.stageName.x = 68;
         this.stageName.y = 7;
         this.stageName.mouseEnabled = false;
         this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.StageOptionDefault");
         this.backOver = new ReBuidBitmap("pvz.ectype.ranking.StageOptionOver");
         this.backClicked = new ReBuidBitmap("pvz.ectype.ranking.StageOptionClicked");
         this.addChild(this.backOver);
         this.addChild(this.backDefault);
         this.addChild(this.backClicked);
         this.addChild(this.stageName);
         this.backOver.visible = false;
         this.backClicked.visible = false;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.onBtnClickHandle);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onBtnOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onBtnOut);
      }
      
      public function setName(param1:String) : void
      {
         this.stageName.htmlText = "<font size=\'20\'><b>" + param1 + "</b></font>";
         this.stageName.width = 40;
         this.stageName.height = this.stageName.textHeight + 2;
         this.stageName.autoSize = TextFieldAutoSize.CENTER;
      }
      
      public function setData(param1:Object) : void
      {
         this._data = param1;
      }
      
      private function onBtnClickHandle(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.dispatchEvent(new StageClickEvent(StageClickEvent.RANKING_DATA,this._data));
      }
      
      public function setBackClick(param1:Boolean) : void
      {
         if(param1 == true)
         {
            this.backClicked.visible = param1;
            this.backOver.visible = !param1;
            this.backDefault.visible = !param1;
            this.mouseEnabled = false;
         }
         else
         {
            this.backDefault.visible = !param1;
            this.backClicked.visible = param1;
            this.backOver.visible = param1;
            this.mouseEnabled = true;
         }
      }
      
      private function onBtnOver(param1:MouseEvent) : void
      {
         this.backOver.visible = true;
         this.backDefault.visible = false;
      }
      
      private function onBtnOut(param1:MouseEvent) : void
      {
         this.backOver.visible = false;
         this.backDefault.visible = true;
      }
      
      public function distroy() : void
      {
         this.buttonMode = false;
         this.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandle);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onBtnOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onBtnOut);
         this.backDefault.dispose();
         this.backOver.dispose();
         this.backClicked.dispose();
         this.parent.removeChild(this);
      }
   }
}

