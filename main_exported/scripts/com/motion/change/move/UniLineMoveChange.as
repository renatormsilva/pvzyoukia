package com.motion.change.move
{
   import flash.display.DisplayObject;
   
   public class UniLineMoveChange extends MoveChange
   {
      
      public function UniLineMoveChange(param1:DisplayObject, param2:int, param3:int, param4:Number, param5:Function)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function changeLocation() : void
      {
         _dis.x = _base_x + (_to_x - _base_x) * _moveTimes / _num;
         _dis.y = _base_y + (_to_y - _base_y) * _moveTimes / _num;
      }
   }
}

