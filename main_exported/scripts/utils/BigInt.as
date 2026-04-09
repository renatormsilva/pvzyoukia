package utils
{
   public class BigInt
   {
      
      private var _sign:Boolean;
      
      private var _len:int;
      
      private var _digits:Array;
      
      public function BigInt(... rest)
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         super();
         if(rest.length == 0)
         {
            this._sign = true;
            this._len = 1;
            this._digits = new Array(1);
            _loc4_ = true;
         }
         else if(rest.length == 1)
         {
            _loc3_ = getBigIntFromAny(rest[0]);
            if(_loc3_ == rest[0])
            {
               _loc3_ = _loc3_.clone();
            }
            this._sign = _loc3_._sign;
            this._len = _loc3_._len;
            this._digits = _loc3_._digits;
            _loc4_ = false;
         }
         else
         {
            this._sign = rest[1] ? true : false;
            this._len = rest[0];
            this._digits = new Array(this._len);
            _loc4_ = true;
         }
         if(_loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ < this._len)
            {
               this._digits[_loc2_] = 0;
               _loc2_++;
            }
         }
      }
      
      public static function plus(param1:*, param2:*) : BigInt
      {
         param1 = getBigIntFromAny(param1);
         param2 = getBigIntFromAny(param2);
         return add(param1,param2,1);
      }
      
      public static function minus(param1:*, param2:*) : BigInt
      {
         param1 = getBigIntFromAny(param1);
         param2 = getBigIntFromAny(param2);
         return add(param1,param2,0);
      }
      
      public static function multiply(param1:*, param2:*) : BigInt
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc5_:* = 0;
         param1 = getBigIntFromAny(param1);
         param2 = getBigIntFromAny(param2);
         _loc4_ = param1._len + param2._len + 1;
         _loc6_ = new BigInt(_loc4_,param1._sign == param2._sign);
         _loc8_ = param1._digits;
         _loc9_ = param2._digits;
         _loc7_ = _loc6_._digits;
         _loc12_ = param2._len;
         while(_loc4_--)
         {
            _loc7_[_loc4_] = 0;
         }
         _loc3_ = 0;
         while(_loc3_ < param1._len)
         {
            _loc10_ = _loc8_[_loc3_];
            if(_loc10_ != 0)
            {
               _loc5_ = 0;
               _loc4_ = 0;
               while(_loc4_ < _loc12_)
               {
                  _loc11_ = _loc5_ + _loc10_ * _loc9_[_loc4_];
                  _loc5_ = _loc7_[_loc3_ + _loc4_] + _loc11_;
                  if(_loc11_)
                  {
                     _loc7_[_loc3_ + _loc4_] = _loc5_ & 0xFFFF;
                  }
                  _loc5_ >>= 16;
                  _loc4_++;
               }
               if(_loc5_)
               {
                  _loc7_[_loc3_ + _loc4_] = _loc5_;
               }
            }
            _loc3_++;
         }
         return normalize(_loc6_);
      }
      
      public static function divide(param1:*, param2:*) : BigInt
      {
         param1 = getBigIntFromAny(param1);
         param2 = getBigIntFromAny(param2);
         return divideAndMod(param1,param2,0);
      }
      
      public static function mod(param1:*, param2:*) : BigInt
      {
         param1 = getBigIntFromAny(param1);
         param2 = getBigIntFromAny(param2);
         return divideAndMod(param1,param2,1);
      }
      
      public static function compare(param1:*, param2:*) : int
      {
         var _loc3_:* = undefined;
         if(param1 == param2)
         {
            return 0;
         }
         param1 = getBigIntFromAny(param1);
         param2 = getBigIntFromAny(param2);
         _loc3_ = param1._len;
         if(param1._sign != param2._sign)
         {
            if(param1._sign)
            {
               return 1;
            }
            return -1;
         }
         if(_loc3_ < param2._len)
         {
            return param1._sign ? -1 : 1;
         }
         if(_loc3_ > param2._len)
         {
            return param1._sign ? 1 : -1;
         }
         while(Boolean(_loc3_--) && param1._digits[_loc3_] == param2._digits[_loc3_])
         {
         }
         if(-1 == _loc3_)
         {
            return 0;
         }
         return param1._digits[_loc3_] > param2._digits[_loc3_] ? (param1._sign ? 1 : -1) : (param1._sign ? -1 : 1);
      }
      
      private static function getBigIntFromAny(param1:*) : BigInt
      {
         var _loc3_:BigInt = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(typeof param1 == "object")
         {
            if(param1 is BigInt)
            {
               return param1;
            }
            return new BigInt(1,1);
         }
         if(typeof param1 == "string")
         {
            return getBigIntFromString(param1);
         }
         if(typeof param1 == "number")
         {
            if(-2147483647 <= param1 && param1 <= 2147483647)
            {
               return getBigIntFromInt(param1);
            }
            param1 += "";
            _loc4_ = param1.indexOf("e",0);
            if(_loc4_ == -1)
            {
               return getBigIntFromString(param1);
            }
            _loc5_ = param1.substr(0,_loc4_);
            _loc6_ = param1.substr(_loc4_ + 2,param1.length - (_loc4_ + 2));
            _loc7_ = _loc5_.indexOf(".",0);
            if(_loc7_ != -1)
            {
               _loc8_ = _loc5_.length - (_loc7_ + 1);
               _loc5_ = _loc5_.substr(0,_loc7_) + _loc5_.substr(_loc7_ + 1,_loc8_);
               _loc6_ = parseInt(_loc6_) - _loc8_;
            }
            else
            {
               _loc6_ = parseInt(_loc6_);
            }
            while(_loc6_-- > 0)
            {
               _loc5_ += "0";
            }
            return getBigIntFromString(_loc5_);
         }
         return new BigInt(1,1);
      }
      
      private static function getBigIntFromInt(param1:Number) : BigInt
      {
         var _loc2_:* = undefined;
         var _loc3_:BigInt = null;
         var _loc4_:* = undefined;
         if(param1 < 0)
         {
            param1 = -param1;
            _loc2_ = false;
         }
         else
         {
            _loc2_ = true;
         }
         param1 &= 2147483647;
         if(param1 <= 65535)
         {
            _loc3_ = new BigInt(1,1);
            _loc3_._digits[0] = param1;
         }
         else
         {
            _loc3_ = new BigInt(2,1);
            _loc3_._digits[0] = param1 & 0xFFFF;
            _loc3_._digits[1] = param1 >> 16 & 0xFFFF;
         }
         return _loc3_;
      }
      
      private static function getBigIntFromString(param1:String, param2:* = null) : BigInt
      {
         var _loc3_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc4_:Boolean = true;
         var _loc11_:* = 1;
         param1 += "@";
         _loc3_ = 0;
         if(param1.charAt(_loc3_) == "+")
         {
            _loc3_++;
         }
         else if(param1.charAt(_loc3_) == "-")
         {
            _loc3_++;
            _loc4_ = false;
         }
         if(param1.charAt(_loc3_) == "@")
         {
            return null;
         }
         if(!param2)
         {
            if(param1.charAt(_loc3_) == "0")
            {
               _loc5_ = param1.charAt(_loc3_ + 1);
               if(_loc5_ == "x" || _loc5_ == "X")
               {
                  param2 = 16;
               }
               else if(_loc5_ == "b" || _loc5_ == "B")
               {
                  param2 = 2;
               }
               else
               {
                  param2 = 8;
               }
            }
            else
            {
               param2 = 10;
            }
         }
         if(param2 == 8)
         {
            while(param1.charAt(_loc3_) == "0")
            {
               _loc3_++;
            }
            _loc6_ = 3 * (param1.length - _loc3_);
         }
         else
         {
            if(param2 == 16 && param1.charAt(_loc3_) == "0" && (param1.charAt(_loc3_ + 1) == "x" || param1.charAt(_loc3_ + 1) == "X"))
            {
               _loc3_ += 2;
            }
            if(param2 == 2 && param1.charAt(_loc3_) == "0" && (param1.charAt(_loc3_ + 1) == "b" || param1.charAt(_loc3_ + 1) == "B"))
            {
               _loc3_ += 2;
            }
            while(param1.charAt(_loc3_) == "0")
            {
               _loc3_++;
            }
            if(param1.charAt(_loc3_) == "@")
            {
               _loc3_--;
            }
            _loc6_ = 4 * (param1.length - _loc3_);
         }
         _loc6_ = (_loc6_ >> 4) + 1;
         _loc7_ = new BigInt(_loc6_,_loc4_);
         _loc8_ = _loc7_._digits;
         while(true)
         {
            _loc5_ = param1.charAt(_loc3_++);
            if(_loc5_ == "@")
            {
               break;
            }
            switch(_loc5_)
            {
               case "0":
                  _loc5_ = 0;
                  break;
               case "1":
                  _loc5_ = 1;
                  break;
               case "2":
                  _loc5_ = 2;
                  break;
               case "3":
                  _loc5_ = 3;
                  break;
               case "4":
                  _loc5_ = 4;
                  break;
               case "5":
                  _loc5_ = 5;
                  break;
               case "6":
                  _loc5_ = 6;
                  break;
               case "7":
                  _loc5_ = 7;
                  break;
               case "8":
                  _loc5_ = 8;
                  break;
               case "9":
                  _loc5_ = 9;
                  break;
               case "a":
               case "A":
                  _loc5_ = 10;
                  break;
               case "b":
               case "B":
                  _loc5_ = 11;
                  break;
               case "c":
               case "C":
                  _loc5_ = 12;
                  break;
               case "d":
               case "D":
                  _loc5_ = 13;
                  break;
               case "e":
               case "E":
                  _loc5_ = 14;
                  break;
               case "f":
               case "F":
                  _loc5_ = 15;
                  break;
               default:
                  _loc5_ = param2;
            }
            if(_loc5_ >= param2)
            {
               break;
            }
            _loc10_ = 0;
            _loc9_ = _loc5_;
            while(true)
            {
               while(_loc10_ < _loc11_)
               {
                  _loc9_ += _loc8_[_loc10_] * param2;
                  var _loc12_:*;
                  _loc8_[_loc12_ = _loc10_++] = _loc9_ & 0xFFFF;
                  _loc9_ >>= 16;
               }
               if(!_loc9_)
               {
                  break;
               }
               _loc11_++;
            }
         }
         return normalize(_loc7_);
      }
      
      private static function add(param1:BigInt, param2:BigInt, param3:*) : BigInt
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         param3 = param3 == param2._sign;
         if(param1._sign != param3)
         {
            if(param3)
            {
               return subtract(param2,param1);
            }
            return subtract(param1,param2);
         }
         if(param1._len > param2._len)
         {
            _loc7_ = param1._len + 1;
            _loc4_ = param1;
            param1 = param2;
            param2 = _loc4_;
         }
         else
         {
            _loc7_ = param2._len + 1;
         }
         _loc4_ = new BigInt(_loc7_,param3);
         _loc7_ = param1._len;
         _loc6_ = 0;
         _loc5_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ += param1._digits[_loc6_] + param2._digits[_loc6_];
            _loc4_._digits[_loc6_] = _loc5_ & 0xFFFF;
            _loc5_ >>= 16;
            _loc6_++;
         }
         _loc7_ = param2._len;
         while(Boolean(_loc5_) && _loc6_ < _loc7_)
         {
            _loc5_ += param2._digits[_loc6_];
            var _loc8_:*;
            _loc4_._digits[_loc8_ = _loc6_++] = _loc5_ & 0xFFFF;
            _loc5_ >>= 16;
         }
         while(_loc6_ < _loc7_)
         {
            _loc4_._digits[_loc6_] = param2._digits[_loc6_];
            _loc6_++;
         }
         _loc4_._digits[_loc6_] = _loc5_ & 0xFFFF;
         return normalize(_loc4_);
      }
      
      private static function subtract(param1:BigInt, param2:BigInt) : BigInt
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:* = 0;
         _loc6_ = param1._len;
         if(param1._len < param2._len)
         {
            _loc3_ = param1;
            param1 = param2;
            param2 = _loc3_;
         }
         else if(param1._len == param2._len)
         {
            while(_loc6_ > 0)
            {
               _loc6_--;
               if(param1._digits[_loc6_] > param2._digits[_loc6_])
               {
                  break;
               }
               if(param1._digits[_loc6_] < param2._digits[_loc6_])
               {
                  _loc3_ = param1;
                  param1 = param2;
                  param2 = _loc3_;
                  break;
               }
            }
         }
         _loc3_ = new BigInt(param1._len,_loc3_ == 0 ? 1 : 0);
         _loc4_ = _loc3_._digits;
         _loc6_ = 0;
         _loc5_ = 0;
         while(_loc6_ < param2._len)
         {
            _loc5_ += param1._digits[_loc6_] - param2._digits[_loc6_];
            _loc4_[_loc6_] = _loc5_ & 0xFFFF;
            _loc5_ >>= 16;
            _loc6_++;
         }
         while(Boolean(_loc5_) && _loc6_ < param1._len)
         {
            _loc5_ += param1._digits[_loc6_];
            var _loc7_:*;
            _loc4_[_loc7_ = _loc6_++] = _loc5_ & 0xFFFF;
            _loc5_ >>= 16;
         }
         while(_loc6_ < param1._len)
         {
            _loc4_[_loc6_] = param1._digits[_loc6_];
            _loc6_++;
         }
         return normalize(_loc3_);
      }
      
      private static function divideAndMod(param1:BigInt, param2:BigInt, param3:*) : BigInt
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:BigInt = null;
         var _loc4_:* = param1._len;
         var _loc5_:* = param2._len;
         _loc11_ = param2._digits;
         if(_loc5_ == 0 && _loc11_[0] == 0)
         {
            return null;
         }
         if(_loc4_ < _loc5_ || _loc4_ == _loc5_ && param1._digits[_loc4_ - 1] < param2._digits[_loc5_ - 1])
         {
            if(param3)
            {
               return normalize(param1);
            }
            return new BigInt(1,1);
         }
         _loc10_ = param1._digits;
         if(_loc5_ == 1)
         {
            _loc16_ = _loc11_[0];
            _loc9_ = param1.clone();
            _loc12_ = _loc9_._digits;
            _loc14_ = 0;
            _loc6_ = _loc4_;
            while(_loc6_--)
            {
               _loc14_ = _loc14_ * 65536 + _loc12_[_loc6_];
               _loc12_[_loc6_] = _loc14_ / _loc16_ & 0xFFFF;
               _loc14_ %= _loc16_;
            }
            _loc9_._sign = param1._sign == param2._sign;
            if(param3)
            {
               if(!param1._sign)
               {
                  _loc14_ = -_loc14_;
               }
               if(param1._sign != param2._sign)
               {
                  _loc14_ += _loc11_[0] * (param2._sign ? 1 : -1);
               }
               return getBigIntFromInt(_loc14_);
            }
            return normalize(_loc9_);
         }
         _loc9_ = new BigInt(_loc4_ == _loc5_ ? _loc4_ + 2 : _loc4_ + 1,param1._sign == param2._sign);
         _loc12_ = _loc9_._digits;
         if(_loc4_ == _loc5_)
         {
            _loc12_[_loc4_ + 1] = 0;
         }
         while(!_loc11_[_loc5_ - 1])
         {
            _loc5_--;
         }
         _loc16_ = 65536 / (_loc11_[_loc5_ - 1] + 1) & 0xFFFF;
         if(_loc16_ != 1)
         {
            _loc8_ = param2.clone();
            _loc13_ = _loc8_._digits;
            _loc7_ = 0;
            _loc15_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc15_ += _loc11_[_loc7_] * _loc16_;
               var _loc22_:*;
               _loc13_[_loc22_ = _loc7_++] = _loc15_ & 0xFFFF;
               _loc15_ >>= 16;
            }
            _loc11_ = _loc13_;
            _loc7_ = 0;
            _loc15_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc15_ += _loc10_[_loc7_] * _loc16_;
               _loc12_[_loc22_ = _loc7_++] = _loc15_ & 0xFFFF;
               _loc15_ >>= 16;
            }
            _loc12_[_loc7_] = _loc15_ & 0xFFFF;
         }
         else
         {
            _loc12_[_loc4_] = 0;
            _loc7_ = _loc4_;
            while(_loc7_--)
            {
               _loc12_[_loc7_] = _loc10_[_loc7_];
            }
         }
         _loc7_ = _loc4_ == _loc5_ ? _loc4_ + 1 : _loc4_;
         do
         {
            if(_loc12_[_loc7_] == _loc11_[_loc5_ - 1])
            {
               _loc17_ = 65535;
            }
            else
            {
               _loc17_ = (_loc12_[_loc7_] * 65536 + _loc12_[_loc7_ - 1]) / _loc11_[_loc5_ - 1] & 0xFFFF;
            }
            if(_loc17_)
            {
               _loc6_ = 0;
               _loc15_ = 0;
               _loc14_ = 0;
               do
               {
                  _loc14_ += _loc11_[_loc6_] * _loc17_;
                  _loc18_ = _loc15_ - (_loc14_ & 0xFFFF);
                  _loc15_ = _loc12_[_loc7_ - _loc5_ + _loc6_] + _loc18_;
                  if(_loc18_)
                  {
                     _loc12_[_loc7_ - _loc5_ + _loc6_] = _loc15_ & 0xFFFF;
                  }
                  _loc15_ >>= 16;
                  _loc14_ >>= 16;
               }
               while(++_loc6_ < _loc5_);
               _loc15_ += _loc12_[_loc7_ - _loc5_ + _loc6_] - _loc14_;
               while(_loc15_)
               {
                  _loc6_ = 0;
                  _loc15_ = 0;
                  _loc17_--;
                  do
                  {
                     _loc18_ = _loc15_ + _loc11_[_loc6_];
                     _loc15_ = _loc12_[_loc7_ - _loc5_ + _loc6_] + _loc18_;
                     if(_loc18_)
                     {
                        _loc12_[_loc7_ - _loc5_ + _loc6_] = _loc15_ & 0xFFFF;
                     }
                     _loc15_ >>= 16;
                  }
                  while(++_loc6_ < _loc5_);
                  _loc15_--;
               }
            }
            _loc12_[_loc7_] = _loc17_;
         }
         while(--_loc7_ >= _loc5_);
         if(param3)
         {
            _loc19_ = _loc9_.clone();
            if(_loc16_)
            {
               _loc12_ = _loc19_._digits;
               _loc14_ = 0;
               _loc6_ = _loc5_;
               while(_loc6_--)
               {
                  _loc14_ = _loc14_ * 65536 + _loc12_[_loc6_];
                  _loc12_[_loc6_] = _loc14_ / _loc16_ & 0xFFFF;
                  _loc14_ %= _loc16_;
               }
            }
            _loc19_._len = _loc5_;
            _loc19_._sign = param1._sign;
            if(param1._sign != param2._sign)
            {
               return add(_loc19_,param2,1);
            }
            return normalize(_loc19_);
         }
         _loc20_ = _loc9_.clone();
         _loc12_ = _loc20_._digits;
         _loc7_ = (_loc4_ == _loc5_ ? _loc4_ + 2 : _loc4_ + 1) - _loc5_;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc12_[_loc6_] = _loc12_[_loc6_ + _loc5_];
            _loc6_++;
         }
         _loc20_._len = _loc6_;
         return normalize(_loc20_);
      }
      
      private static function normalize(param1:BigInt) : BigInt
      {
         var _loc2_:* = param1._len;
         var _loc3_:* = param1._digits;
         while(Boolean(_loc2_--) && !_loc3_[_loc2_])
         {
         }
         param1._len = ++_loc2_;
         return param1;
      }
      
      public function toString() : String
      {
         return this.toStringBase(10);
      }
      
      public function toStringBase(param1:int) : String
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         _loc2_ = this._len;
         if(_loc2_ == 0)
         {
            return "0";
         }
         if(_loc2_ == 1 && !this._digits[0])
         {
            return "0";
         }
         switch(param1)
         {
            default:
            case 10:
               _loc3_ = Math.floor(2 * 8 * _loc2_ * 241 / 800) + 2;
               _loc4_ = 10000;
               break;
            case 16:
               _loc3_ = Math.floor(2 * 8 * _loc2_ / 4) + 2;
               _loc4_ = 65536;
               break;
            case 8:
               _loc3_ = 2 * 8 * _loc2_ + 2;
               _loc4_ = 10000;
               break;
            case 2:
               _loc3_ = 2 * 8 * _loc2_ + 2;
               _loc4_ = 20;
         }
         _loc5_ = this.clone();
         _loc6_ = _loc5_._digits;
         var _loc8_:String = "";
         while(Boolean(_loc2_) && Boolean(_loc3_))
         {
            _loc9_ = _loc2_;
            _loc10_ = 0;
            while(_loc9_--)
            {
               _loc10_ = (_loc10_ << 16) + _loc6_[_loc9_];
               if(_loc10_ < 0)
               {
                  _loc10_ += 4294967296;
               }
               _loc6_[_loc9_] = Math.floor(_loc10_ / _loc4_);
               _loc10_ %= _loc4_;
            }
            if(_loc6_[_loc2_ - 1] == 0)
            {
               _loc2_--;
            }
            _loc9_ = 4;
            while(_loc9_--)
            {
               _loc7_ = _loc10_ % param1;
               _loc8_ = "0123456789abcdef".charAt(_loc7_) + _loc8_;
               _loc3_--;
               _loc10_ = Math.floor(_loc10_ / param1);
               if(_loc2_ == 0 && _loc10_ == 0)
               {
                  break;
               }
            }
         }
         _loc2_ = 0;
         while(_loc2_ < _loc8_.length && _loc8_.charAt(_loc2_) == "0")
         {
            _loc2_++;
         }
         if(_loc2_)
         {
            _loc8_ = _loc8_.substring(_loc2_,_loc8_.length);
         }
         if(!this._sign)
         {
            _loc8_ = "-" + _loc8_;
         }
         return _loc8_;
      }
      
      public function clone() : BigInt
      {
         var _loc1_:BigInt = null;
         var _loc2_:int = 0;
         _loc1_ = new BigInt(this._len,this._sign);
         _loc2_ = 0;
         while(_loc2_ < this._len)
         {
            _loc1_._digits[_loc2_] = this._digits[_loc2_];
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function negative() : BigInt
      {
         var _loc1_:BigInt = this.clone();
         _loc1_._sign = !_loc1_._sign;
         return normalize(_loc1_);
      }
      
      public function toNumber() : Number
      {
         var _loc1_:* = 0;
         var _loc2_:* = this._len;
         var _loc3_:* = this._digits;
         while(_loc2_--)
         {
            _loc1_ = _loc3_[_loc2_] + 65536 * _loc1_;
         }
         if(!this._sign)
         {
            _loc1_ = -_loc1_;
         }
         return _loc1_;
      }
      
      public function get sign() : Boolean
      {
         return this._sign;
      }
      
      public function get length() : int
      {
         return this._len;
      }
      
      public function get digits() : Array
      {
         return this._digits;
      }
   }
}

