package effect.flap
{
   import com.motion.ChangeManager;
   import com.motion.change.alpha.UniAlphaChange;
   import com.motion.change.move.UniLineMoveChange;
   import com.motion.change.scale.UniScaleChange;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FlapManager
   {
      
      public function FlapManager()
      {
         super();
      }
      
      public static function newflapInfos(param1:int, param2:int, param3:MovieClip, param4:DisplayObject, param5:Number, param6:ChangeManager, param7:Function = null) : void
      {
         var toTop:Function = null;
         var toSmaller:Function = null;
         var toAlphaChange:Function = null;
         var onClear:Function = null;
         var x:int = param1;
         var y:int = param2;
         var baseMc:MovieClip = param3;
         var flapMc:DisplayObject = param4;
         var times:Number = param5;
         var cm:ChangeManager = param6;
         var backFun:Function = param7;
         toTop = function():void
         {
            cm.add(new UniLineMoveChange(flapMc,flapMc.x,flapMc.y - 20,0.8,toAlphaChange));
         };
         var toBigger:Function = function():void
         {
            cm.add(new UniScaleChange(flapMc,1.4,1.4,0.2,toSmaller));
         };
         toSmaller = function():void
         {
            cm.add(new UniScaleChange(flapMc,1,1,0.1,toTop));
         };
         toAlphaChange = function():void
         {
            cm.add(new UniAlphaChange(flapMc,0,0.4,onClear));
         };
         onClear = function():void
         {
            if(flapMc.parent != null)
            {
               baseMc.removeChild(flapMc);
            }
            if(backFun != null)
            {
               backFun();
            }
         };
         flapMc.x = x;
         flapMc.y = y;
         baseMc.addChildAt(flapMc,baseMc.numChildren);
         toBigger();
      }
      
      public static function flapInfos(param1:int, param2:int, param3:DisplayObjectContainer, param4:DisplayObject, param5:Number, param6:Function = null, param7:int = 0) : void
      {
         var t:Timer = null;
         var t2:Timer = null;
         var t3:Timer = null;
         var t4:Timer = null;
         var delayT:Timer = null;
         var onDelay:Function = null;
         var onChangeBig:Function = null;
         var onChangeBigComp:Function = null;
         var onTop:Function = null;
         var onTopComp:Function = null;
         var onSmall:Function = null;
         var onSmallComp:Function = null;
         var onChange:Function = null;
         var onChangeComp:Function = null;
         var x:int = param1;
         var y:int = param2;
         var baseMc:DisplayObjectContainer = param3;
         var flapMc:DisplayObject = param4;
         var times:Number = param5;
         var backFun:Function = param6;
         var delay:int = param7;
         onDelay = function(param1:TimerEvent):void
         {
            delayT.stop();
            delayT.removeEventListener(TimerEvent.TIMER,onDelay);
            delayT = null;
            t2.start();
            baseMc.addChildAt(flapMc,baseMc.numChildren);
         };
         onChangeBig = function(param1:TimerEvent):void
         {
            flapMc.scaleX += 0.2;
            flapMc.scaleY += 0.2;
         };
         onChangeBigComp = function(param1:TimerEvent):void
         {
            t3.start();
            t2.removeEventListener(TimerEvent.TIMER_COMPLETE,onChangeBigComp);
            t2.removeEventListener(TimerEvent.TIMER,onChangeBig);
            t2.stop();
         };
         onTop = function(param1:TimerEvent):void
         {
            flapMc.y -= 2;
         };
         onTopComp = function(param1:TimerEvent):void
         {
            t.stop();
            t.removeEventListener(TimerEvent.TIMER,onTop);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,onTopComp);
            t4.start();
         };
         onSmall = function(param1:TimerEvent):void
         {
            flapMc.scaleX -= 0.2;
            flapMc.scaleY -= 0.2;
         };
         onSmallComp = function(param1:TimerEvent):void
         {
            t.start();
            t3.removeEventListener(TimerEvent.TIMER_COMPLETE,onSmall);
            t3.removeEventListener(TimerEvent.TIMER_COMPLETE,onSmallComp);
            t3.stop();
         };
         onChange = function(param1:TimerEvent):void
         {
            flapMc.alpha -= 0.1;
            flapMc.y -= 2;
         };
         onChangeComp = function(param1:TimerEvent):void
         {
            t4.stop();
            t4.removeEventListener(TimerEvent.TIMER,onChange);
            t4.removeEventListener(TimerEvent.TIMER_COMPLETE,onChangeComp);
            if(flapMc.parent != null)
            {
               baseMc.removeChild(flapMc);
            }
            if(backFun != null)
            {
               backFun();
            }
         };
         flapMc.x = x;
         flapMc.y = y;
         t = new Timer(20,10 * times);
         t.addEventListener(TimerEvent.TIMER,onTop);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,onTopComp);
         t2 = new Timer(10,5);
         t2.addEventListener(TimerEvent.TIMER_COMPLETE,onChangeBigComp);
         t2.addEventListener(TimerEvent.TIMER,onChangeBig);
         t3 = new Timer(10,5);
         t3.addEventListener(TimerEvent.TIMER,onSmall);
         t3.addEventListener(TimerEvent.TIMER_COMPLETE,onSmallComp);
         t4 = new Timer(20,10 * times);
         t4.addEventListener(TimerEvent.TIMER,onChange);
         t4.addEventListener(TimerEvent.TIMER_COMPLETE,onChangeComp);
         delayT = null;
         if(delay < 1)
         {
            t2.start();
            baseMc.addChildAt(flapMc,baseMc.numChildren);
         }
         else
         {
            delayT = new Timer(delay);
            delayT.addEventListener(TimerEvent.TIMER,onDelay);
            delayT.start();
         }
      }
      
      public static function flapInfos2(param1:int, param2:int, param3:MovieClip, param4:DisplayObject, param5:DisplayObject) : void
      {
         var t:Timer = null;
         var t2:Timer = null;
         var goTop:Function = null;
         var goTopComp:Function = null;
         var goDown:Function = null;
         var goDownComp:Function = null;
         var x:int = param1;
         var y:int = param2;
         var baseMc:MovieClip = param3;
         var flapMc:DisplayObject = param4;
         var effectMc:DisplayObject = param5;
         goTop = function(param1:TimerEvent):void
         {
            flapMc.y -= 5;
         };
         goTopComp = function(param1:TimerEvent):void
         {
            t.removeEventListener(TimerEvent.TIMER,goTop);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,goTopComp);
            t.stop();
            t2.start();
         };
         goDown = function(param1:TimerEvent):void
         {
            flapMc.y += 5;
         };
         goDownComp = function(param1:TimerEvent):void
         {
            t2.removeEventListener(TimerEvent.TIMER,goDown);
            t2.removeEventListener(TimerEvent.TIMER_COMPLETE,goDownComp);
            t2.stop();
         };
         flapMc.x = x;
         flapMc.y = y;
         baseMc.addChild(flapMc);
         t = new Timer(20,10);
         t.addEventListener(TimerEvent.TIMER,goTop);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,goTopComp);
         t2 = new Timer(10,10);
         t2.addEventListener(TimerEvent.TIMER,goDown);
         t2.addEventListener(TimerEvent.TIMER_COMPLETE,goDownComp);
         t.start();
      }
      
      public static function flapInfos3(param1:int, param2:int, param3:DisplayObject) : void
      {
         var t:Timer = null;
         var t2:Timer = null;
         var goTop:Function = null;
         var goTopComp:Function = null;
         var goDown:Function = null;
         var goDownComp:Function = null;
         var x:int = param1;
         var y:int = param2;
         var flapMc:DisplayObject = param3;
         goTop = function(param1:TimerEvent):void
         {
            flapMc.y -= 5;
         };
         goTopComp = function(param1:TimerEvent):void
         {
            t.removeEventListener(TimerEvent.TIMER,goTop);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,goTopComp);
            t.stop();
            t2.start();
         };
         goDown = function(param1:TimerEvent):void
         {
            flapMc.y += 5;
         };
         goDownComp = function(param1:TimerEvent):void
         {
            t2.removeEventListener(TimerEvent.TIMER,goDown);
            t2.removeEventListener(TimerEvent.TIMER_COMPLETE,goDownComp);
            t2.stop();
         };
         flapMc.x = x;
         flapMc.y = y;
         t = new Timer(20,10);
         t.addEventListener(TimerEvent.TIMER,goTop);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,goTopComp);
         t2 = new Timer(10,10);
         t2.addEventListener(TimerEvent.TIMER,goDown);
         t2.addEventListener(TimerEvent.TIMER_COMPLETE,goDownComp);
         t.start();
      }
   }
}

