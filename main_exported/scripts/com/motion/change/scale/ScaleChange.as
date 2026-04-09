package com.motion.change.scale
{
   import com.motion.Change;
   import com.motion.ChangeManager;
   import flash.display.DisplayObject;
   
   public class ScaleChange extends Change
   {
      
      public var _base_ScaleX:Number = 0;
      
      public var _base_ScaleY:Number = 0;
      
      public var _compFun:Function = null;
      
      public var _dis:DisplayObject = null;
      
      public var _moveTimes:int = 0;
      
      public var _time:Number = 0;
      
      public var _to_scaleX:Number = 0;
      
      public var _to_scaleY:Number = 0;
      
      public function ScaleChange(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Function)
      {
         super();
         this._dis = param1;
         this._to_scaleX = param2;
         this._to_scaleY = param3;
         this._base_ScaleY = this._dis.scaleX;
         this._base_ScaleY = this._dis.scaleY;
         this._time = param4;
         this._compFun = param5;
      }
      
      override public function change() : Boolean
      {
         ++this._moveTimes;
         this.changeScale();
         if(this._moveTimes == this.getChangeTimes())
         {
            this._dis.scaleX = this._to_scaleX;
            this._dis.scaleY = this._to_scaleY;
            if(this._compFun != null)
            {
               this._compFun();
            }
            return true;
         }
         return false;
      }
      
      public function changeScale() : void
      {
         throw new Error("ScaleChange---------changeScale()-----需要子类覆盖");
      }
      
      public function getChangeTimes() : int
      {
         if(this._time < ChangeManager.RATE)
         {
            throw new Error("ScaleChange--------运动时间不能为0");
         }
         return int(this._time * 1000 / ChangeManager.RATE);
      }
   }
}

