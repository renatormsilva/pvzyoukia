package utils
{
   import core.managers.GameManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.ConvolutionFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class FuncKit
   {
      
      public static const WAN:Number = 10000;
      
      public static const WAN_YI:Number = 10000 * 10000 * 10000;
      
      public static const YI:Number = 10000 * 10000;
      
      public function FuncKit()
      {
         super();
         throw new Error("不能被实例化");
      }
      
      public static function PlayFlashAnimation(param1:MovieClip, param2:DisplayObjectContainer = null, param3:Function = null, param4:Point = null) : void
      {
         var mask:MovieClip = null;
         var onEnterFame:Function = null;
         var mc:MovieClip = param1;
         var fatherRoot:DisplayObjectContainer = param2;
         var playEnd:Function = param3;
         var loaction:Point = param4;
         onEnterFame = function(param1:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.stop();
               mc.removeEventListener(Event.ENTER_FRAME,onEnterFame);
               if(fatherRoot)
               {
                  fatherRoot.removeChild(mc);
                  fatherRoot.removeChild(mask);
               }
               else
               {
                  PlantsVsZombies._node.removeChild(mc);
                  PlantsVsZombies._node.removeChild(mask);
               }
               if(playEnd != null)
               {
                  playEnd();
               }
            }
         };
         mask = GetDomainRes.getMoveClip("showbg");
         mask.alpha = 0;
         if(fatherRoot)
         {
            fatherRoot.addChild(mask);
            fatherRoot.addChild(mc);
         }
         else
         {
            PlantsVsZombies._node.addChild(mask);
            PlantsVsZombies._node.addChild(mc);
         }
         if(loaction)
         {
            mc.x = loaction.x;
            mc.y = loaction.y;
         }
         else
         {
            mc.x = GameManager.pvzStage.stageWidth / 2;
            mc.y = GameManager.pvzStage.stageHeight / 2;
         }
         mc.addEventListener(Event.ENTER_FRAME,onEnterFame);
         mc.gotoAndPlay(2);
      }
      
      public static function sharpenDisplay(param1:DisplayObject) : void
      {
         var _loc2_:ConvolutionFilter = new ConvolutionFilter();
         var _loc3_:Array = new Array(_loc2_);
         param1.filters = _loc3_;
      }
      
      public static function getFullYearAndTime(param1:Number) : String
      {
         var sec:Number = param1;
         var cover:Function = function(param1:Number):String
         {
            if(param1 >= 10)
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
      
      public static function getDataBySec(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return _loc2_.fullYear + "." + (_loc2_.month + 1) + "." + _loc2_.date;
      }
      
      public static function getDay(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return _loc2_.month + 1 + "月" + _loc2_.date + "日";
      }
      
      public static function getTime(param1:Number) : String
      {
         var sec:Number = param1;
         var cover:Function = function(param1:Number):String
         {
            if(param1 >= 10)
            {
               return param1 + "";
            }
            return "0" + param1;
         };
         var date:Date = new Date(sec * 1000);
         var hour:String = cover(date.hours) + ":" + cover(date.minutes) + ":" + cover(date.seconds);
         return hour;
      }
      
      public static function setGreenColor(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0,0,0,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         var _loc4_:Array = new Array(_loc3_);
         param1.filters = _loc4_;
      }
      
      public static function showSystermInfo(param1:String, param2:Function = null) : void
      {
         PlantsVsZombies.showSystemErrorInfo(param1,param2);
      }
      
      public static function getArtWordsTime(param1:Number) : DisplayObject
      {
         var _loc2_:DisplayObject = StringMovieClip.getStringImage(getTimeString(Math.floor(param1 / 3600)),"Exp");
         var _loc3_:DisplayObject = StringMovieClip.getStringImage(getTimeString(Math.floor(param1 % 3600 / 60)),"Exp");
         var _loc4_:DisplayObject = StringMovieClip.getStringImage(getTimeString(param1 % 3600 % 60),"Exp");
         var _loc5_:DisplayObject = StringMovieClip.getStringImage("w","Exp");
         var _loc6_:DisplayObject = StringMovieClip.getStringImage("w","Exp");
         var _loc7_:Sprite = new Sprite();
         _loc7_.addChild(_loc2_);
         _loc7_.addChild(_loc5_);
         _loc5_.x = _loc7_.width + 5;
         _loc7_.addChild(_loc3_);
         _loc3_.x = _loc7_.width;
         _loc7_.addChild(_loc6_);
         _loc6_.x = _loc7_.width + 5;
         _loc7_.addChild(_loc4_);
         _loc4_.x = _loc7_.width;
         return _loc7_;
      }
      
      public static function getTimeBySec(param1:Number) : String
      {
         var _loc2_:int = Math.floor(param1 / 3600);
         if(_loc2_ >= 24)
         {
            return Math.round(_loc2_ / 24) + "天";
         }
         return _loc2_ + ":" + getTimeString(Math.floor(param1 % 3600 / 60));
      }
      
      public static function getArtTimeBySec(param1:Number) : DisplayObject
      {
         var _loc3_:Sprite = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:int = Math.floor(param1 / 3600);
         if(_loc2_ >= 24)
         {
            _loc3_ = new Sprite();
            _loc4_ = getNumEffect(Math.round(_loc2_ / 24) + "");
            _loc5_ = GetDomainRes.getDisplayObject("tian");
            _loc3_.addChild(_loc4_);
            _loc3_.addChild(_loc5_);
            _loc5_.x = _loc4_.width;
            return _loc3_;
         }
         return getArtWordsTime(param1);
      }
      
      private static function getTimeString(param1:int) : String
      {
         return param1 < 10 ? "0" + param1 : String(param1);
      }
      
      public static function transformNum(param1:Number, param2:int = 0) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 < WAN)
         {
            return param1 + "";
         }
         if(param1 < YI)
         {
            _loc3_ = "";
            if(param2 == -1)
            {
               _loc3_ = Math.floor(param1 / WAN) + "万";
            }
            else if(param2 == 1)
            {
               _loc3_ = Math.ceil(param1 / WAN) + "万";
            }
            else
            {
               _loc3_ = int(param1 / WAN) + "万";
            }
            return _loc3_;
         }
         _loc4_ = "";
         if(param2 == -1)
         {
            _loc4_ = Math.floor(param1 / YI) + "亿";
         }
         else if(param2 == 1)
         {
            _loc4_ = Math.ceil(param1 / YI) + "亿";
         }
         else
         {
            _loc4_ = int(param1 / YI) + "亿";
         }
         return _loc4_;
      }
      
      public static function getMoneyArtDisplay(param1:Number) : DisplayObject
      {
         var _loc2_:Number = NaN;
         var _loc3_:Sprite = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         if(param1 >= WAN)
         {
            _loc2_ = Math.floor(param1 / WAN);
            _loc3_ = new Sprite();
            _loc4_ = _loc3_.addChild(getNumEffect(_loc2_ + ""));
            _loc5_ = _loc3_.addChild(GetDomainRes.getMoveClip("wan"));
            _loc5_.x = _loc4_.width;
            _loc4_.y = 5;
            _loc5_.y = -5;
            return _loc3_;
         }
         return getNumEffect(param1 + "");
      }
      
      public static function getStarDisBySoulLevel(param1:int) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:DisplayObject = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc2_:Sprite = new Sprite();
         if(param1 < 5)
         {
            _loc3_ = getNumEffect("star","SoulYel");
            _loc4_ = getNumEffect("x","SoulYel");
            _loc5_ = getNumEffect(param1 + "","SoulYel");
            _loc2_.addChild(_loc3_);
            _loc2_.addChild(_loc4_);
            _loc2_.addChild(_loc5_);
            _loc3_.y = 3;
            _loc4_.x = _loc3_.width - 5;
            _loc4_.y = _loc3_.height / 2 - _loc4_.height / 2 + 4;
            _loc5_.x = _loc4_.x + _loc4_.width - 10;
            _loc5_.y = _loc3_.height / 2 - _loc5_.height / 2 + 5;
         }
         else if(param1 >= 5 && param1 <= 8)
         {
            _loc6_ = getNumEffect("star","SoulPurple");
            _loc7_ = getNumEffect("x","SoulPurple");
            _loc8_ = getNumEffect(param1 + "","SoulPurple");
            _loc2_.addChild(_loc6_);
            _loc2_.addChild(_loc7_);
            _loc2_.addChild(_loc8_);
            _loc6_.x = -5;
            _loc7_.x = _loc6_.width - 20;
            _loc7_.y = _loc6_.height / 2 - _loc7_.height / 2;
            _loc8_.x = _loc7_.x + _loc7_.width - 10;
            _loc8_.y = _loc6_.height / 2 - _loc8_.height / 2 + 1;
         }
         else if(param1 >= 9)
         {
            _loc9_ = getNumEffect("star","SoulRed");
            _loc10_ = getNumEffect("x","SoulRed");
            _loc11_ = getNumEffect(param1 + "","SoulRed",-13);
            _loc2_.addChild(_loc9_);
            _loc2_.addChild(_loc10_);
            _loc2_.addChild(_loc11_);
            _loc9_.x = -5;
            _loc10_.x = _loc9_.width - 15;
            _loc10_.y = _loc9_.height / 2 - _loc10_.height / 2;
            _loc11_.x = _loc10_.x + _loc10_.width - 10;
            _loc11_.y = _loc9_.height / 2 - _loc11_.height / 2 - 1;
         }
         return _loc2_;
      }
      
      public static function getAttackNumDis(param1:Number = 0, param2:String = "Huge", param3:int = 0) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         return getKexuejishufa(param1,param2,0);
      }
      
      public static function getNumDisplayObject(param1:Number, param2:String = "Exp", param3:Number = 0, param4:Boolean = false) : DisplayObject
      {
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:DisplayObject = null;
         var _loc14_:Sprite = null;
         var _loc5_:DisplayObject = null;
         if(param1 < YI)
         {
            _loc6_ = String(param1);
            if(param4)
            {
               _loc6_ = "Plus" + _loc6_;
            }
            _loc5_ = getNumEffect(_loc6_ + "",param2,param3);
         }
         else if(param1 < WAN_YI && param1 >= YI)
         {
            _loc7_ = Math.floor(param1 / 1000000);
            _loc8_ = Math.floor(_loc7_ / 100);
            _loc9_ = Math.floor((_loc7_ - _loc8_ * 100) / 10);
            _loc10_ = _loc7_ - _loc8_ * 100 - _loc9_ * 10;
            _loc11_ = _loc8_.toString() + "d" + _loc9_.toString() + _loc10_.toString();
            if(param4)
            {
               _loc11_ = "Plus" + _loc11_;
            }
            _loc12_ = getNumEffect(_loc11_,param2,param3);
            _loc13_ = getNumEffect("y",param2);
            _loc14_ = new Sprite();
            _loc14_.addChild(_loc12_);
            _loc14_.addChild(_loc13_);
            _loc13_.x = _loc12_.width;
            _loc5_ = _loc14_;
         }
         else
         {
            _loc5_ = getKexuejishufa(param1,param2,param3,param4);
         }
         return _loc5_;
      }
      
      public static function getNumEffect(param1:String, param2:String = "Exp", param3:Number = 0) : DisplayObject
      {
         return StringMovieClip.getStringImage(param1 + "",param2,param3);
      }
      
      public static function getKexuejishufa(param1:Number, param2:String = "Exp", param3:Number = 0, param4:Boolean = false) : DisplayObject
      {
         if(param1 < WAN_YI)
         {
            return null;
         }
         var _loc5_:String = param1.toExponential(2);
         var _loc6_:String = _loc5_.substr(0,_loc5_.indexOf("e+"));
         var _loc7_:String = _loc6_.replace(".","d");
         var _loc8_:String = _loc7_ + "x10";
         var _loc9_:String = int(_loc5_.slice(_loc5_.indexOf("e+") + 2)) - 8 + "";
         if(param4)
         {
            _loc8_ = "Plus" + _loc8_;
         }
         var _loc10_:DisplayObject = getNumEffect(_loc8_,param2,param3);
         var _loc11_:DisplayObject = getNumEffect(_loc9_,param2,param3);
         if(param2 == "Huge" || param2 == "Fear" || param2 == "Feared" || param2 == "NewBattle")
         {
            _loc11_.scaleX = 0.7;
            _loc11_.scaleY = 0.7;
         }
         if(param2 == "NewBattle")
         {
            _loc11_.x = _loc10_.width - 7;
         }
         else
         {
            _loc11_.x = _loc10_.width;
         }
         _loc11_.y = -6;
         var _loc12_:DisplayObject = getNumEffect("y",param2);
         if(param2 == "NewBattle")
         {
            _loc12_.x = _loc10_.width + _loc11_.width - 10;
         }
         else
         {
            _loc12_.x = _loc10_.width + _loc11_.width;
         }
         (_loc10_ as DisplayObjectContainer).addChild(_loc11_);
         (_loc10_ as DisplayObjectContainer).addChild(_loc12_);
         return _loc10_;
      }
      
      public static function getColorHtmlStr(param1:String, param2:String = "#ff0000") : String
      {
         return "<font color=\'" + param2 + "\' size=\'15\'><center>" + param1 + "</center></font>";
      }
      
      public static function clearAllChildrens(param1:DisplayObjectContainer, param2:int = 0) : void
      {
         if(param1 == null || param2 > param1.numChildren - 1)
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
      
      public static function getRandom(param1:int, param2:int) : int
      {
         var _loc3_:int = int(Math.random() * (param2 - param1 + 1));
         return _loc3_ + param1;
      }
      
      public static function currentTimeMillis() : Number
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime();
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
         param1.filters = null;
      }
      
      public static function changeTextFieldColor(param1:TextField, param2:uint) : void
      {
         param1.textColor = param2;
      }
      
      public static function clearNode(param1:*) : void
      {
         var _loc3_:* = undefined;
         if(!(param1 is DisplayObjectContainer))
         {
            return;
         }
         var _loc2_:Sprite = param1 as Sprite;
         while(_loc2_.numChildren > 0)
         {
            _loc3_ = _loc2_.getChildAt(0);
            _loc2_.removeChild(_loc3_);
            if(Object(_loc3_).clear != null)
            {
               Object(_loc3_).clear();
            }
         }
      }
   }
}

