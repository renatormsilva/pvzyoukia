package com.display
{
   import com.res.IDestroy;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import com.util.SystemTimer;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class CMovieClip extends Sprite implements IDestroy
   {
      
      public var bitmap:Bitmap = null;
      
      public var totalFrames:uint = 1;
      
      private var count:uint = 0;
      
      public var currentFrameIndex:uint = 0;
      
      private var enabled:Boolean = false;
      
      private var frameInfos:BitmapFrameInfos = null;
      
      private var frameRate:uint = 0;
      
      private var lastRCount:uint = 0;
      
      private var timer:CTimer = null;
      
      public function CMovieClip(param1:BitmapFrameInfos, param2:uint = 24)
      {
         super();
         if(param1 == null)
         {
            throw new Error("CMovieClicp bitmapFrameInfos is null!");
         }
         this.frameInfos = param1;
         this.frameInfos.addInstanceNum();
         this.frameRate = param2;
         this.timer = new CTimer(1000 / param2);
         this.timer.addEventListener(CTimerEvent.TIMER,this.onTimer);
         this.timer.start();
         this.totalFrames = this.frameInfos.getBitmapFrames().length;
         this.bitmap = new Bitmap((this.frameInfos.getBitmapFrames()[0] as BitmapFrameInfo).date);
         addChild(this.bitmap);
         this.play();
         CMovieClipRecycleBin.put(this);
      }
      
      public function destroy() : void
      {
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(CTimerEvent.TIMER,this.onTimer);
         }
         this.timer = null;
         if(this.bitmap != null)
         {
            removeChild(this.bitmap);
         }
         this.bitmap = null;
         if(this.frameInfos != null)
         {
            this.frameInfos.decInstanceNum();
         }
         this.frameInfos = null;
         this.filters = null;
      }
      
      public function getBitmapdateInfos() : BitmapFrameInfos
      {
         return this.frameInfos;
      }
      
      public function gotoAndPlay(param1:uint) : void
      {
         this.play();
         this.currentFrameIndex = param1 - 1;
         this.showBitmapDate();
      }
      
      public function gotoAndStop(param1:uint) : void
      {
         if(param1 > this.totalFrames)
         {
            param1 = this.totalFrames;
         }
         this.stop();
         this.currentFrameIndex = param1 - 1;
         this.showBitmapDate();
      }
      
      public function play() : void
      {
         this.enabled = true;
      }
      
      public function stop() : void
      {
         this.enabled = false;
      }
      
      private function onTimer(param1:CTimerEvent) : void
      {
         this.showBitmapDate();
         if(this.currentFrameIndex + 1 == this.totalFrames)
         {
            dispatchEvent(new CMovieClipEvent(CMovieClipEvent.COMPLETE));
         }
         this.count += param1.rcount - this.lastRCount;
         this.lastRCount = param1.rcount;
         if(this.count > SystemTimer.MILLI_SECONDS / this.frameRate)
         {
            ++this.currentFrameIndex;
            if(this.currentFrameIndex >= this.totalFrames)
            {
               this.currentFrameIndex = 0;
            }
            this.count %= SystemTimer.MILLI_SECONDS / this.frameRate;
         }
      }
      
      private function showBitmapDate() : void
      {
         if(this.enabled)
         {
            this.bitmap.bitmapData = (this.frameInfos.getBitmapFrames()[this.currentFrameIndex] as BitmapFrameInfo).date;
         }
      }
   }
}

