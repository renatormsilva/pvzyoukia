package pvz.registration.view.panel.module
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Scale9Image extends Shape
   {
      
      public static var imgCount:int = 0;
      
      protected var _texture:BitmapData;
      
      protected var _textureAtalas:Vector.<BitmapData>;
      
      protected var _scaleGrid:Rectangle;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _minWidth:Number;
      
      protected var _minHeight:Number;
      
      protected var _imageData:BitmapData;
      
      protected var _repeatFillTop:Boolean;
      
      protected var _repeatFillRight:Boolean;
      
      protected var _repeatFillBottom:Boolean;
      
      protected var _repeatFillLeft:Boolean;
      
      protected var _repeatFillCenter:Boolean;
      
      protected var _disposed:Boolean;
      
      protected var _willDraw:Boolean;
      
      public function Scale9Image(param1:BitmapData = null, param2:Rectangle = null)
      {
         super();
         if(!param1 || !param2)
         {
            this.createDefaultTexture();
         }
         else
         {
            if(param2.x + param2.width > param1.width || param2.y + param2.height > param1.height)
            {
               throw "Can not create Scale9Image: grid is invalid.";
            }
            this._texture = param1;
            this._scaleGrid = param2;
         }
         ++imgCount;
         this._minWidth = this._scaleGrid.x + this._texture.width - this._scaleGrid.x - this._scaleGrid.width;
         this._minHeight = this._scaleGrid.y + this._texture.height - this._scaleGrid.y - this._scaleGrid.height;
         this._width = this._texture.width;
         this._height = this._texture.height;
         this._repeatFillTop = this._repeatFillRight = this._repeatFillBottom = this._repeatFillLeft = this._repeatFillCenter = true;
         this._disposed = false;
         this.createTextureAtalas();
         this.validate();
      }
      
      public static function fromBitmap(param1:Bitmap) : Scale9Image
      {
         return null;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this._width = int(param1);
         this._height = int(param2);
         this.validate();
      }
      
      public function dispose() : void
      {
         var _loc1_:BitmapData = null;
         if(this._disposed)
         {
            return;
         }
         --imgCount;
         this._disposed = true;
         for each(_loc1_ in this._textureAtalas)
         {
            _loc1_.dispose();
         }
         this._textureAtalas = null;
         if(this._imageData)
         {
            this._imageData.dispose();
         }
         if(this._texture)
         {
            this._texture.dispose();
         }
         this._imageData = this._texture = null;
      }
      
      protected function createDefaultTexture() : void
      {
         this._scaleGrid = new Rectangle(10,10,5,5);
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0,0.8);
         _loc1_.graphics.drawRoundRect(0,0,25,25,10,10);
         _loc1_.graphics.endFill();
         _loc1_.graphics.lineStyle(1,16776960);
         _loc1_.graphics.drawRoundRect(0,0,25,25,10,10);
         this._texture = new BitmapData(26,26,true,0);
         this._texture.draw(_loc1_);
      }
      
      protected function createTextureAtalas() : void
      {
         if(!this._texture)
         {
            return;
         }
         var _loc1_:Point = new Point(this._scaleGrid.x,this._scaleGrid.y);
         var _loc2_:Point = new Point(this._scaleGrid.x + this._scaleGrid.width,this._scaleGrid.y);
         var _loc3_:Point = new Point(this._scaleGrid.x + this._scaleGrid.width,this._scaleGrid.y + this._scaleGrid.height);
         var _loc4_:Point = new Point(this._scaleGrid.x,this._scaleGrid.y + this._scaleGrid.height);
         var _loc5_:Number = this._texture.width;
         var _loc6_:Number = this._texture.height;
         var _loc7_:Rectangle = null;
         var _loc8_:BitmapData = null;
         this._textureAtalas = new Vector.<BitmapData>();
         _loc7_ = new Rectangle(0,0,_loc1_.x,_loc1_.y);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(_loc2_.x,0,_loc5_ - _loc2_.x,_loc2_.y);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(_loc3_.x,_loc3_.y,_loc5_ - _loc3_.x,_loc6_ - _loc3_.y);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(0,_loc4_.y,_loc4_.x,_loc6_ - _loc4_.y);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(_loc1_.x,0,this._scaleGrid.width,this._scaleGrid.y);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(_loc2_.x,_loc2_.y,_loc5_ - _loc2_.x,this._scaleGrid.height);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(_loc4_.x,_loc4_.y,this._scaleGrid.width,_loc6_ - _loc4_.y);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc7_ = new Rectangle(0,_loc1_.y,_loc1_.x,this._scaleGrid.height);
         _loc8_ = new BitmapData(_loc7_.width,_loc7_.height);
         _loc8_.copyPixels(this._texture,_loc7_,new Point(0,0));
         this._textureAtalas.push(_loc8_);
         _loc8_ = new BitmapData(this._scaleGrid.width,this._scaleGrid.height);
         _loc8_.copyPixels(this._texture,this._scaleGrid,new Point(0,0));
         this._textureAtalas.push(_loc8_);
      }
      
      protected function validate() : void
      {
         if(this._willDraw)
         {
            return;
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._willDraw = true;
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._willDraw = false;
         this.draw();
      }
      
      protected function draw() : void
      {
         if(this._disposed)
         {
            return;
         }
         var _loc1_:Point = new Point(this._textureAtalas[0].width,this._textureAtalas[0].height);
         var _loc2_:Point = new Point(this._width - this._textureAtalas[1].width,this._textureAtalas[1].height);
         var _loc3_:Point = new Point(this._width - this._textureAtalas[2].width,this._height - this._textureAtalas[2].height);
         var _loc4_:Point = new Point(this._textureAtalas[3].width,this._height - this._textureAtalas[3].height);
         graphics.clear();
         this.fillRectWithBitmapData(this._textureAtalas[0],new Rectangle(0,0,_loc1_.x,_loc1_.y));
         this.fillRectWithBitmapData(this._textureAtalas[1],new Rectangle(_loc2_.x,0,this._width - _loc2_.x,_loc2_.y));
         this.fillRectWithBitmapData(this._textureAtalas[2],new Rectangle(_loc3_.x,_loc3_.y,this._width - _loc3_.x,this._height - _loc3_.y));
         this.fillRectWithBitmapData(this._textureAtalas[3],new Rectangle(0,_loc4_.y,_loc4_.x,this._height - _loc4_.y));
         this.fillRectWithBitmapData(this._textureAtalas[4],new Rectangle(_loc1_.x,0,_loc2_.x - _loc1_.x,this._scaleGrid.y),this._repeatFillTop);
         this.fillRectWithBitmapData(this._textureAtalas[5],new Rectangle(_loc2_.x,_loc2_.y,this._width - _loc2_.x,_loc3_.y - _loc2_.y),this._repeatFillRight);
         this.fillRectWithBitmapData(this._textureAtalas[6],new Rectangle(_loc4_.x,_loc4_.y,_loc3_.x - _loc4_.x,this._height - _loc4_.y),this._repeatFillBottom);
         this.fillRectWithBitmapData(this._textureAtalas[7],new Rectangle(0,_loc1_.y,_loc1_.x,_loc4_.y - _loc1_.y),this._repeatFillLeft);
         this.fillRectWithBitmapData(this._textureAtalas[8],new Rectangle(_loc1_.x,_loc1_.y,_loc2_.x - _loc1_.x,_loc3_.y - _loc2_.y),this._repeatFillCenter);
         if(this._imageData)
         {
            this._imageData.dispose();
         }
         this._imageData = new BitmapData(this._width,this._height,true,0);
         this._imageData.draw(this);
         graphics.clear();
         this.fillRectWithBitmapData(this._imageData,new Rectangle(0,0,this._width,this._height));
      }
      
      protected function fillRectWithBitmapData(param1:BitmapData, param2:Rectangle, param3:Boolean = false) : void
      {
         if(!param1 || !param2)
         {
            return;
         }
         graphics.beginBitmapFill(param1,new Matrix(1,0,0,1,param2.x,param2.y),param3);
         graphics.drawRect(param2.x,param2.y,param2.width,param2.height);
         graphics.endFill();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function get repeatFillTop() : Boolean
      {
         return this._repeatFillTop;
      }
      
      public function set repeatFillTop(param1:Boolean) : void
      {
         if(this._repeatFillTop == param1)
         {
            return;
         }
         this._repeatFillTop = param1;
         this.validate();
      }
      
      public function get repeatFillRight() : Boolean
      {
         return this._repeatFillRight;
      }
      
      public function set repeatFillRight(param1:Boolean) : void
      {
         if(this._repeatFillRight == param1)
         {
            return;
         }
         this._repeatFillRight = param1;
         this.validate();
      }
      
      public function get repeatFillBottom() : Boolean
      {
         return this._repeatFillBottom;
      }
      
      public function set repeatFillBottom(param1:Boolean) : void
      {
         if(this._repeatFillBottom == param1)
         {
            return;
         }
         this._repeatFillBottom = param1;
         this.validate();
      }
      
      public function get repeatFillLeft() : Boolean
      {
         return this._repeatFillLeft;
      }
      
      public function set repeatFillLeft(param1:Boolean) : void
      {
         if(this._repeatFillLeft == param1)
         {
            return;
         }
         this._repeatFillLeft = param1;
         this.validate();
      }
      
      public function get repeatFillCenter() : Boolean
      {
         return this._repeatFillCenter;
      }
      
      public function set repeatFillCenter(param1:Boolean) : void
      {
         if(this._repeatFillCenter == param1)
         {
            return;
         }
         this._repeatFillCenter = param1;
         this.validate();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this._width = param1 < this._minWidth ? this._minWidth : param1;
         this._width = int(this._width);
         this.validate();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         this._height = param1 < this._minHeight ? this._minHeight : param1;
         this._height = int(this._height);
         this.validate();
      }
   }
}

