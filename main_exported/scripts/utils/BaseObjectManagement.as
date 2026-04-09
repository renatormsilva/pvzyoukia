package utils
{
   import flash.display.*;
   import flash.events.EventDispatcher;
   
   public class BaseObjectManagement extends EventDispatcher
   {
      
      public const PREFIX:String = "str";
      
      public var picNames:Array;
      
      public var str:String;
      
      public var outputObject:Object;
      
      protected var projectName:String;
      
      public var direction:int;
      
      public var specialStr:Object;
      
      protected var tempStr:String = "";
      
      public function BaseObjectManagement(param1:Array, param2:String, param3:String = "", param4:int = 0)
      {
         super();
         this.picNames = param1;
         this.direction = param4;
         this.projectName = param2;
         this.str = param3;
         this.specialStr = new Object();
      }
      
      protected function doLayout(param1:Number = 0) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(this.outputObject.numChildren > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < this.outputObject.numChildren)
            {
               if(_loc5_ > 0)
               {
                  _loc2_ = this.outputObject.getChildAt(_loc5_ - 1);
               }
               _loc3_ = this.outputObject.getChildAt(_loc5_);
               if(_loc2_ != null)
               {
                  if(this.direction == 0)
                  {
                     _loc3_.x = _loc2_.x + _loc2_.width + param1;
                     _loc3_.y = _loc2_.y;
                  }
                  else
                  {
                     _loc3_.y = _loc2_.y + _loc2_.height;
                     _loc3_.x = _loc2_.x;
                  }
               }
               else
               {
                  _loc3_.x = 0;
                  _loc3_.y = 0;
               }
               _loc5_++;
            }
         }
      }
      
      public function transfor(param1:Number = 0) : void
      {
         throw new Error("transfor:此类必须实现此方法!");
      }
   }
}

