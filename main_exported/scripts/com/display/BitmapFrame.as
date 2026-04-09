package com.display
{
   import com.util.CTimer;
   import com.util.CTimerEvent;
   
   public class BitmapFrame
   {
      
      private static var _instance:BitmapFrame;
      
      private static const TIME:int = 30 * 1000;
      
      private static var _singleton:Boolean = true;
      
      private var dates:Object = null;
      
      private var timer:CTimer = null;
      
      public function BitmapFrame()
      {
         super();
         if(_singleton)
         {
            throw new Error("只能用getInstance()来获取实例");
         }
         this.dates = {};
         this.timer = new CTimer(TIME);
         this.timer.addEventListener(CTimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      public static function getInstance() : BitmapFrame
      {
         if(_instance == null)
         {
            _singleton = false;
            _instance = new BitmapFrame();
            _singleton = true;
         }
         return _instance;
      }
      
      public function getBitmapFrameInfo(param1:String) : BitmapFrameInfos
      {
         return this.dates[param1];
      }
      
      public function storeBitmapFrameInfo(param1:String, param2:BitmapFrameInfos) : void
      {
         this.dates[param1] = param2;
      }
      
      private function onTimer(param1:CTimerEvent) : void
      {
         this.recycle();
      }
      
      private function recycle() : void
      {
         var _loc1_:String = null;
         var _loc2_:BitmapFrameInfos = null;
         for(_loc1_ in this.dates)
         {
            _loc2_ = this.dates[_loc1_];
            if(_loc2_.getInstanceNum() <= 0)
            {
               _loc2_.destroy();
               this.dates[_loc1_] = null;
               delete this.dates[_loc1_];
            }
         }
      }
   }
}

