package com.motion.change.alpha
{
   import com.motion.Change;
   import com.motion.ChangeManager;
   import flash.display.DisplayObject;
   
   public class AlphaChange extends Change
   {
      
      public var _base_alpha:Number = 0;
      
      public var _compFun:Function = null;
      
      public var _dis:DisplayObject = null;
      
      public var _moveTimes:int = 0;
      
      public var _time:Number = 0;
      
      public var _to_alpha:Number = 0;
      
      public function AlphaChange(param1:DisplayObject, param2:Number, param3:Number, param4:Function)
      {
         super();
         this._dis = param1;
         this._to_alpha = param2;
         this._base_alpha = this._dis.alpha;
         this._time = param3;
         this._compFun = param4;
      }
      
      override public function change() : Boolean
      {
         ++this._moveTimes;
         this.changeAlpha();
         if(this._moveTimes == this.getChangeTimes())
         {
            this._dis.alpha = this._to_alpha;
            if(this._compFun != null)
            {
               this._compFun();
            }
            return true;
         }
         return false;
      }
      
      public function changeAlpha() : void
      {
         throw new Error("AlphaChange---------changeAlpha()-----需要子类覆盖");
      }
      
      public function getChangeTimes() : int
      {
         if(this._time == 0)
         {
            throw new Error("AlphaChange--------运动时间不能为0");
         }
         return int(this._time * 1000 / ChangeManager.RATE);
      }
   }
}

