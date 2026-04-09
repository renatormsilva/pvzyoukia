package com.display
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapDateSourseManager
   {
      
      public function BitmapDateSourseManager()
      {
         super();
      }
      
      public static function flipHorizontal(param1:CMovieClip) : void
      {
         param1.bitmap.transform.matrix = new Matrix(param1.bitmap.transform.matrix.a * -1,param1.bitmap.transform.matrix.b,param1.bitmap.transform.matrix.c,param1.bitmap.transform.matrix.d,param1.bitmap.transform.matrix.tx,param1.bitmap.transform.matrix.ty);
      }
      
      public static function getBitmapDatesByMovieClip(param1:MovieClip, param2:String, param3:Number = 1) : BitmapFrameInfos
      {
         var _loc10_:int = 0;
         var _loc11_:BitmapData = null;
         var _loc12_:BitmapFrameInfo = null;
         if(BitmapFrame.getInstance().getBitmapFrameInfo(param2 + "_" + param3) != null)
         {
            return BitmapFrame.getInstance().getBitmapFrameInfo(param2 + "_" + param3);
         }
         if(param1 == null)
         {
            return null;
         }
         var _loc4_:Array = new Array();
         var _loc5_:Rectangle = getMaxRectangleByMovieClip(param1);
         var _loc6_:Matrix = param1.transform.matrix;
         var _loc7_:Matrix = new Matrix(Math.abs(_loc6_.a) * param3,_loc6_.b,_loc6_.c,Math.abs(_loc6_.d) * param3,-_loc5_.x * Math.abs(_loc6_.a * param3),-_loc5_.y * Math.abs(_loc6_.d * param3));
         var _loc8_:int = 1;
         while(_loc8_ <= param1.totalFrames)
         {
            param1.gotoAndStop(_loc8_);
            _loc10_ = 0;
            while(_loc10_ < param1.numChildren)
            {
               if(param1.getChildAt(_loc10_) is MovieClip)
               {
                  (param1.getChildAt(_loc10_) as MovieClip).gotoAndStop(_loc8_ % (param1.getChildAt(_loc10_) as MovieClip).totalFrames);
               }
               _loc10_++;
            }
            _loc11_ = new BitmapData(_loc5_.width * _loc7_.a,_loc5_.height * _loc7_.d,true,0);
            _loc11_.draw(param1,_loc7_,null,null,new Rectangle(_loc5_.x * _loc7_.a,_loc5_.y * _loc7_.b,_loc5_.width * _loc7_.a + _loc7_.tx,_loc5_.height * _loc7_.d + _loc7_.ty),true);
            _loc12_ = new BitmapFrameInfo(_loc11_,new Point(_loc7_.tx,_loc7_.ty));
            _loc4_.push(_loc12_);
            _loc8_++;
         }
         var _loc9_:BitmapFrameInfos = new BitmapFrameInfos(_loc4_,param1.transform);
         BitmapFrame.getInstance().storeBitmapFrameInfo(param2 + "_" + param3,_loc9_);
         return BitmapFrame.getInstance().getBitmapFrameInfo(param2 + "_" + param3);
      }
      
      public static function getDisplayObjectMatrix(param1:DisplayObject) : Matrix
      {
         return new Matrix(param1.transform.matrix.a,0,0,param1.transform.matrix.d,param1.transform.matrix.tx,param1.transform.matrix.ty);
      }
      
      private static function koutu(param1:BitmapData) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Shape = new Shape();
         var _loc3_:int = 0;
         while(_loc3_ < param1.width)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.height)
            {
               if(param1.getPixel32(_loc3_,_loc4_) >>> 24 > 0)
               {
                  _loc2_.graphics.beginBitmapFill(param1);
                  _loc2_.graphics.drawRect(_loc3_,_loc4_,1,1);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         _loc2_.graphics.endFill();
      }
      
      public static function getMaxRectangleByMovieClip(param1:MovieClip) : Rectangle
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(param1 == null)
         {
            throw new Error("BitmapDateSourseManager---------------getBitmapDatesSizeByMovieClip---------mc is null");
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 1;
         while(_loc6_ <= param1.totalFrames)
         {
            param1.gotoAndStop(_loc6_);
            _loc8_ = param1.getBounds(param1).x;
            _loc9_ = param1.getBounds(param1).y;
            _loc2_ = Math.min(_loc8_,_loc2_);
            _loc3_ = Math.min(_loc9_,_loc3_);
            _loc10_ = param1.getBounds(param1).width + param1.getBounds(param1).x;
            _loc11_ = param1.getBounds(param1).height + param1.getBounds(param1).y;
            _loc4_ = Math.max(_loc10_,_loc4_);
            _loc5_ = Math.max(_loc11_,_loc5_);
            _loc6_++;
         }
         return new Rectangle(_loc2_,_loc3_,_loc4_ - _loc2_,_loc5_ - _loc3_);
      }
   }
}

