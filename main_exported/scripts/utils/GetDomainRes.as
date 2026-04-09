package utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import pvz.world.repetition.ui.RankingSimpleButton;
   import zlib.utils.DomainAccess;
   
   public class GetDomainRes
   {
      
      public function GetDomainRes()
      {
         super();
      }
      
      public static function getSprite(param1:String) : Sprite
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         return new _loc2_();
      }
      
      public static function getDisplayObject(param1:String) : DisplayObject
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         return new _loc2_();
      }
      
      public static function getMoveClip(param1:String) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         return new _loc2_();
      }
      
      public static function getSimpleButton(param1:String) : SimpleButton
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         return new _loc2_();
      }
      
      public static function getBitmap(param1:String) : Bitmap
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         var _loc3_:BitmapData = new _loc2_(0,0);
         return new Bitmap(_loc3_);
      }
      
      public static function getGradeMc(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + param1));
         return _loc3_;
      }
      
      public static function getBitmapData(param1:String) : BitmapData
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         return new _loc2_(0,0);
      }
      
      public static function getNumberSp(param1:Number) : String
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:String = param1.toString();
         if(param1 >= 100000000)
         {
            _loc3_ = Math.floor(param1 / 1000000);
            _loc4_ = Math.floor(_loc3_ / 100);
            _loc5_ = Math.floor((_loc3_ - _loc4_ * 100) / 10);
            _loc6_ = _loc3_ - _loc4_ * 100 - _loc5_ * 10;
            _loc2_ = _loc4_.toString() + "d" + _loc5_.toString() + _loc6_.toString() + "y";
         }
         return _loc2_;
      }
      
      public static function get100levelUpsp(param1:int) : Sprite
      {
         var _loc2_:Sprite = getSprite("level100Up");
         _loc2_["lv"].addChild(getGradeMc(param1));
         return _loc2_;
      }
      
      public static function getRankSimpleButton(param1:int) : RankingSimpleButton
      {
         return new RankingSimpleButton(param1);
      }
   }
}

