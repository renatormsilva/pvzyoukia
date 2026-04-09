package pvz.registration.view.panel.module
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import utils.GetDomainRes;
   
   public class ProgressBar extends Sprite
   {
      
      private var offx:int = 4;
      
      private var _progress:Number = 0;
      
      private var _w:Number;
      
      private var bg:Scale9Image;
      
      private var progressImg:Scale9Image;
      
      private var percentage:Number;
      
      public function ProgressBar(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.percentage = param3 / 10;
         this._w = param1;
         this._progress = param2 / this.percentage * (this._w / 10) - this.offx;
         if(this._progress < 0)
         {
            this._progress = 0;
         }
         this.initUi();
      }
      
      private function initUi() : void
      {
         var _loc1_:Rectangle = new Rectangle(9,5,6,10);
         this.bg = new Scale9Image(GetDomainRes.getBitmapData("pvz.ProBg"),_loc1_);
         this.bg.repeatFillLeft = this.bg.repeatFillRight = this.bg.repeatFillCenter = false;
         this.bg.width = this._w;
         this.addChild(this.bg);
         _loc1_ = new Rectangle(9,5,6,10);
         this.progressImg = new Scale9Image(GetDomainRes.getBitmapData("pvz.ProBar"),_loc1_);
         this.progressImg.repeatFillLeft = this.progressImg.repeatFillRight = this.progressImg.repeatFillCenter = false;
         this.progressImg.width = this._progress > this._w - this.offx ? this._w - this.offx : this._progress;
         this.progressImg.height = 17;
         this.progressImg.x = 2;
         this.progressImg.y = 2;
         this.addChild(this.progressImg);
         if(this.progressImg.width < 1)
         {
            this.progressImg.visible = false;
         }
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(param1:Number) : void
      {
         this._progress = param1 / this.percentage * (this._w / 10) - this.offx;
         if(this._progress < 0)
         {
            this._progress = 0;
         }
         this.progressImg.width = this._progress > this._w - this.offx ? this._w - this.offx : this._progress;
         if(param1 < 1)
         {
            this.progressImg.visible = false;
         }
         else
         {
            this.progressImg.visible = true;
         }
      }
   }
}

