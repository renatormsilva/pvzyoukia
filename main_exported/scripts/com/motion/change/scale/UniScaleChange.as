package com.motion.change.scale
{
   import flash.display.DisplayObject;
   
   public class UniScaleChange extends ScaleChange
   {
      
      public function UniScaleChange(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Function)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function changeScale() : void
      {
         _dis.scaleX = _base_ScaleX + (_to_scaleX - _base_ScaleX) * _moveTimes / getChangeTimes();
         _dis.scaleY = _base_ScaleY + (_to_scaleY - _base_ScaleY) * _moveTimes / getChangeTimes();
      }
   }
}

