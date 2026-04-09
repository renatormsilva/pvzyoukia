package core.ui.components
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class VGroupLayout
   {
      
      private var _disArr:Array;
      
      private var _initPoint:Point;
      
      private var _gap:Number;
      
      public function VGroupLayout(param1:Point, param2:Number)
      {
         super();
         this._initPoint = param1;
         this._gap = param2;
         this._disArr = [];
      }
      
      public function addDisToGroup(param1:DisplayObject) : void
      {
         if(this._disArr.indexOf(param1) == -1)
         {
            this._disArr.push(param1);
         }
      }
      
      public function clearGroup() : void
      {
         this._disArr = [];
      }
      
      public function layout() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Number = this._initPoint.y + this._gap;
         for each(_loc2_ in this._disArr)
         {
            if(_loc2_.visible == true)
            {
               _loc2_.x = this._initPoint.x;
               _loc2_.y = _loc1_ + _loc2_.height / 2;
               _loc1_ += _loc2_.height + this._gap;
            }
         }
      }
      
      public function getLayoutHeight() : Number
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Number = 0;
         for each(_loc2_ in this._disArr)
         {
            if(_loc2_.visible == true)
            {
               _loc1_ += _loc2_.height + this._gap;
            }
         }
         return _loc1_;
      }
      
      public function getLayoutWidth() : Number
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Number = 0;
         for each(_loc2_ in this._disArr)
         {
            if(_loc2_.width > _loc1_)
            {
               _loc1_ = _loc2_.width;
            }
         }
         return _loc1_;
      }
      
      public function tipsLayout() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Number = 0;
         for each(_loc2_ in this._disArr)
         {
            if(_loc2_.visible == true)
            {
               _loc2_.x = this._initPoint.x;
               _loc2_.y = _loc1_;
               _loc1_ += _loc2_.height + this._gap;
            }
         }
      }
   }
}

