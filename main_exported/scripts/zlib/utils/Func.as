package zlib.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.net.registerClassAlias;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class Func
   {
      
      public function Func()
      {
         super();
      }
      
      public static function clone(param1:Object) : *
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:String = _loc2_.split("::")[0];
         var _loc4_:Class = Class(getDefinitionByName(_loc2_));
         registerClassAlias(_loc3_,_loc4_);
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeObject(param1);
         _loc5_.position = 0;
         return _loc5_.readObject();
      }
      
      public static function byteArrayCopy(param1:ByteArray, param2:int, param3:int, param4:int = 0) : ByteArray
      {
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:ByteArray = new ByteArray();
         param1.readBytes(_loc5_,param2,param4);
         _loc6_.writeBytes(_loc5_,param3,param4);
         return _loc6_;
      }
      
      public static function arrayCopy(param1:Array, param2:int, param3:Array, param4:int, param5:int = 0) : Array
      {
         var _loc6_:int = param2;
         while(_loc6_ < param1.length)
         {
            if(param3.length >= _loc6_)
            {
               var _loc7_:Number;
               param3[_loc7_ = param4++] = param1[_loc6_];
            }
            else
            {
               param3.push(param1[_loc6_]);
            }
            _loc6_++;
         }
         return param3;
      }
      
      public static function hashCode(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = 31 * _loc2_ + param1.charCodeAt(_loc3_++);
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function trim(param1:String) : String
      {
         if(param1.indexOf(" ") == -1 && param1.indexOf("　") == -1)
         {
            return param1;
         }
         var _loc2_:String = param1;
         param1 = replace(param1,"　"," ");
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         while(_loc5_ < param1.length)
         {
            if(param1.charAt(_loc5_) != " ")
            {
               break;
            }
            _loc3_++;
            _loc5_++;
         }
         var _loc6_:Number = param1.length - 1;
         while(_loc6_ > 0)
         {
            if(param1.charAt(_loc6_) != " ")
            {
               break;
            }
            _loc4_++;
            _loc6_--;
         }
         return _loc2_.substring(_loc3_,_loc2_.length - _loc4_);
      }
      
      public static function replace(param1:String, param2:String, param3:String) : String
      {
         return param1.split(param2).join(param3);
      }
      
      public static function currentTimeMillis() : Number
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime();
      }
      
      public static function intToBoolean(param1:int) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         if(param1 == 1)
         {
            return true;
         }
         return false;
      }
      
      public static function defineArray(param1:int, param2:int, param3:int = 0, param4:Object = null) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 == 0)
         {
            param1 = 1;
         }
         var _loc5_:Array = new Array(param1);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc5_[_loc6_] = new Array(param2);
            if(param4 != null)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc5_[_loc6_].length)
               {
                  _loc5_[_loc6_][_loc7_] = param4;
                  _loc7_++;
               }
            }
            if(param3 > 0)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc5_[_loc6_].length)
               {
                  _loc5_[_loc6_][_loc8_] = new Array(param3);
                  if(param4 != null)
                  {
                     _loc9_ = 0;
                     while(_loc9_ < _loc5_[_loc6_][_loc8_].length)
                     {
                        _loc5_[_loc6_][_loc8_][_loc9_] = param4;
                        _loc9_++;
                     }
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function getRandom(param1:int, param2:int) : int
      {
         var _loc3_:int = int(Math.random() * (param2 - param1 + 1));
         return _loc3_ + param1;
      }
      
      public static function setNoColor(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         var _loc4_:Array = new Array(_loc3_);
         param1.filters = _loc4_;
      }
      
      public static function clearNoColorState(param1:DisplayObject) : void
      {
         param1.filters = new Array();
      }
      
      public static function getInterpolate(param1:Point, param2:Point, param3:int, param4:Number = 0.01) : Point
      {
         var _loc5_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc6_:Number = 1;
         while(_loc6_ >= 0)
         {
            _loc7_ = Point.interpolate(param1,param2,_loc6_);
            _loc8_ = int(Point.distance(param1,_loc7_));
            if(_loc8_ >= param3)
            {
               _loc5_ = _loc7_;
               break;
            }
            _loc6_ -= param4;
         }
         return _loc5_;
      }
      
      public static function changeTextFieldColor(param1:TextField, param2:uint) : void
      {
         param1.textColor = param2;
      }
      
      public static function getFullYearAndTime(param1:Number) : String
      {
         var sec:Number = param1;
         var cover:Function = function(param1:Number):String
         {
            if(param1 > 10)
            {
               return param1 + "";
            }
            return "0" + param1;
         };
         var date:Date = new Date(sec * 1000);
         var year:String = date.month + 1 + "月" + date.date + "日";
         var hour:String = cover(date.hours) + ":" + cover(date.minutes) + ":" + cover(date.seconds);
         return year + hour;
      }
      
      public static function clearAllChildrens(param1:DisplayObjectContainer, param2:int = 0) : void
      {
         if(param2 > param1.numChildren - 1)
         {
            return;
         }
         var _loc3_:* = int(param1.numChildren - 1);
         while(_loc3_ >= param2)
         {
            param1.removeChildAt(_loc3_);
            _loc3_--;
         }
      }
   }
}

