package effect.flip
{
   import fl.motion.easing.Quartic;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EffectFlipGroup extends Sprite
   {
      
      public static const NEXT:int = 1;
      
      public static const PRE:int = 2;
      
      public static const UPDATE:int = 3;
      
      private var _containers:Array;
      
      private var _timer:Timer;
      
      public var _status:Boolean;
      
      private var _initPosx:Number;
      
      private var _callback:Function;
      
      private var _tween:Tween;
      
      private var _gap:Number;
      
      public function EffectFlipGroup(param1:Array, param2:Number, param3:int, param4:Number, param5:Function)
      {
         super();
         this._initPosx = param4;
         this._callback = param5;
         this._gap = param2;
         this._containers = param1;
         this._timer = new Timer(param3);
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            this.addChildAt(param1[_loc6_],0);
            param1[_loc6_].x = param4;
            param1[_loc6_].visible = false;
            _loc6_++;
         }
         this.visible = false;
      }
      
      public function show(param1:Array, param2:int) : void
      {
         var index:int = 0;
         var onTimer:Function = null;
         var re:Array = param1;
         var direction:int = param2;
         onTimer = function(param1:TimerEvent):void
         {
            if(index >= _containers.length)
            {
               _status = true;
               _timer.stop();
               _timer.removeEventListener(TimerEvent.TIMER,onTimer);
               _callback();
               return;
            }
            if(direction == NEXT)
            {
               _tween = new Tween(_containers[index],"x",null,_containers[index].x,index * _gap,(_containers.length - index) * 0.15,true);
            }
            else if(direction == PRE)
            {
               _tween = new Tween(_containers[_containers.length - 1 - index],"x",null,_containers[_containers.length - 1 - index].x,(_containers.length - 1 - index) * _gap,(_containers.length - index) * 0.15,true);
            }
            ++index;
         };
         this.update(re);
         this.x = 0;
         this.visible = true;
         if(direction == UPDATE)
         {
            return;
         }
         this.changePostion(direction);
         this._timer.addEventListener(TimerEvent.TIMER,onTimer);
         this._timer.start();
         index = 0;
      }
      
      private function test() : void
      {
      }
      
      public function hide(param1:int) : void
      {
         var end:Function = null;
         var direction:int = param1;
         end = function(param1:TweenEvent):void
         {
            var _loc2_:DisplayObject = null;
            _containers[0].parent.x = 0;
            _containers[0].parent.visible = false;
            for each(_loc2_ in _containers)
            {
               _loc2_.visible = false;
            }
            _status = false;
         };
         if(direction == NEXT)
         {
            this._tween = new Tween(this,"x",Quartic.easeOut,this.x,-this._gap * this._containers.length,0.5,true);
            this._tween.addEventListener(TweenEvent.MOTION_FINISH,end);
         }
         else if(direction == PRE)
         {
            this._tween = new Tween(this,"x",Quartic.easeOut,this.x,this._initPosx,0.5,true);
            this._tween.addEventListener(TweenEvent.MOTION_FINISH,end);
         }
      }
      
      private function update(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               (this._containers[_loc2_] as DisplayObject).visible = true;
               (this._containers[_loc2_] as IEffectFlipDisplayObject).update(param1[_loc2_]);
               _loc2_++;
            }
         }
         else
         {
            for each(_loc3_ in this._containers)
            {
               _loc3_.visible = true;
            }
         }
      }
      
      private function changePostion(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._containers.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._containers)
         {
            if(param1 == PRE)
            {
               _loc2_.x = -this._containers[0].width;
            }
            else if(param1 == NEXT)
            {
               _loc2_.x = this._initPosx;
            }
         }
      }
      
      public function destory() : void
      {
         var _loc1_:IEffectFlipDisplayObject = null;
         for each(_loc1_ in this._containers)
         {
            _loc1_.destory();
         }
      }
   }
}

