package pvz.world.repetition.ui
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.ReBuidBitmap;
   
   public class RankingSimpleButton extends Sprite
   {
      
      private var backDefault:ReBuidBitmap;
      
      private var backClicked:ReBuidBitmap;
      
      private var backOver:ReBuidBitmap;
      
      public function RankingSimpleButton(param1:int)
      {
         super();
         switch(param1)
         {
            case 1:
               this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.firtAttackBtnDefault");
               this.backClicked = new ReBuidBitmap("pvz.ectype.ranking.firtAttackBtnClicked");
               this.backOver = new ReBuidBitmap("pvz.ectype.ranking.firtAttackBtnOver");
               break;
            case 2:
               this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.completeDegreeBtnDefault");
               this.backClicked = new ReBuidBitmap("pvz.ectype.ranking.completeDegreeBtnClicked");
               this.backOver = new ReBuidBitmap("pvz.ectype.ranking.completeDegreeBtnOver");
               break;
            case 3:
               this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.honorRankBtnDefault");
               this.backClicked = new ReBuidBitmap("pvz.ectype.ranking.honorRankBtnClicked");
               this.backOver = new ReBuidBitmap("pvz.ectype.ranking.honorRankBtnOver");
         }
         this.buttonMode = true;
         this.addChild(this.backDefault);
         this.addChild(this.backClicked);
         this.addChild(this.backOver);
         this.addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
      }
      
      public function distroy() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
         this.backDefault.dispose();
         this.backOver.dispose();
         this.backClicked.dispose();
         this.removeChild(this.backOver);
         this.removeChild(this.backClicked);
         this.removeChild(this.backDefault);
         this.parent.removeChild(this);
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         this.backOver.visible = true;
         this.backDefault.visible = false;
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         this.backOver.visible = false;
         this.backDefault.visible = true;
      }
      
      public function setBtnType(param1:Boolean) : void
      {
         if(param1)
         {
            this.backDefault.visible = false;
            this.backClicked.visible = true;
            this.backOver.visible = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
         }
         else
         {
            this.backDefault.visible = true;
            this.backClicked.visible = false;
            this.backOver.visible = false;
            this.mouseEnabled = true;
            this.mouseChildren = true;
         }
      }
   }
}

