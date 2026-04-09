package com.display
{
   import com.res.IDestroy;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class BitmapFrameInfo implements IDestroy
   {
      
      public var date:BitmapData = null;
      
      public var point:Point = null;
      
      public function BitmapFrameInfo(param1:BitmapData, param2:Point)
      {
         super();
         this.date = param1;
         this.point = param2;
      }
      
      public function destroy() : void
      {
         this.point = null;
         this.date.dispose();
         this.date = null;
      }
   }
}

