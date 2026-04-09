package com.motion.change.alpha
{
   import flash.display.DisplayObject;
   
   public class UniAlphaChange extends AlphaChange
   {
      
      public function UniAlphaChange(param1:DisplayObject, param2:Number, param3:Number, param4:Function)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function changeAlpha() : void
      {
         _dis.alpha = int(_base_alpha + (_to_alpha - _base_alpha) * _moveTimes / getChangeTimes());
      }
   }
}

