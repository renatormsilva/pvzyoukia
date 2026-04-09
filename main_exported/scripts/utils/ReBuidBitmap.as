package utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import zlib.utils.DomainAccess;
   
   public class ReBuidBitmap extends Sprite
   {
      
      private var bitmapDisData:BitmapData;
      
      private var bitmap:Bitmap;
      
      public function ReBuidBitmap(param1:String)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass(param1);
         this.bitmapDisData = new _loc2_(0,0);
         this.bitmap = new Bitmap(this.bitmapDisData);
         this.addChild(this.bitmap);
      }
      
      public function dispose() : void
      {
         this.bitmapDisData.dispose();
         this.removeChild(this.bitmap);
      }
   }
}

