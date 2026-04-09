package com.display
{
   import com.res.IDestroy;
   import flash.geom.Transform;
   
   public class BitmapFrameInfos implements IDestroy
   {
      
      private var arr:Array = null;
      
      private var instanceNum:int = 0;
      
      private var transform:Transform = null;
      
      public function BitmapFrameInfos(param1:Array, param2:Transform)
      {
         super();
         this.arr = param1;
         this.transform = param2;
      }
      
      public function destroy() : void
      {
         this.transform = null;
         if(this.arr == null)
         {
            return;
         }
         var _loc1_:* = int(this.arr.length - 1);
         while(_loc1_ > -1)
         {
            (this.arr[_loc1_] as BitmapFrameInfo).destroy();
            _loc1_--;
         }
         this.arr = null;
      }
      
      public function addInstanceNum() : void
      {
         ++this.instanceNum;
      }
      
      public function decInstanceNum() : void
      {
         --this.instanceNum;
      }
      
      public function getBaseMcTransform() : Transform
      {
         return this.transform;
      }
      
      public function getBitmapFrames() : Array
      {
         return this.arr;
      }
      
      public function getInstanceNum() : int
      {
         return this.instanceNum;
      }
   }
}

