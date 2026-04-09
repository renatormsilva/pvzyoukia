package com.motion.change.move
{
   import com.motion.Change;
   import com.motion.ChangeManager;
   import flash.display.DisplayObject;
   
   public class MoveChange extends Change
   {
      
      public var _base_x:int = 0;
      
      public var _base_y:int = 0;
      
      public var _compFun:Function = null;
      
      public var _dis:DisplayObject = null;
      
      public var _moveTimes:int = 0;
      
      public var _num:int = 0;
      
      public var _to_x:int = 0;
      
      public var _to_y:int = 0;
      
      public function MoveChange(param1:DisplayObject, param2:int, param3:int, param4:Number, param5:Function)
      {
         super();
         this._dis = param1;
         this._to_x = param2;
         this._to_y = param3;
         this._base_x = this._dis.x;
         this._base_y = this._dis.y;
         this._num = this.getChangeTimes(param4,ChangeManager.RATE);
         this._compFun = param5;
      }
      
      override public function change() : Boolean
      {
         ++this._moveTimes;
         if(this._moveTimes == this._num)
         {
            this._dis.x = this._to_x;
            this._dis.y = this._to_y;
            if(this._compFun != null)
            {
               this._compFun();
            }
            return true;
         }
         this.changeLocation();
         return false;
      }
      
      public function changeLocation() : void
      {
         throw new Error("Change---------changeLocation()-----需要子类覆盖");
      }
      
      public function getChangeTimes(param1:Number, param2:int) : int
      {
         if(param1 == 0)
         {
            throw new Error(" Change--------运动时间不能为0");
         }
         return int(param1 * 1000 / param2);
      }
   }
}

