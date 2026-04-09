package manager
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import utils.TextFilter;
   
   public class ArtWordsManager
   {
      
      private static var _instance:ArtWordsManager;
      
      private var _text:TextField;
      
      private var _textFormat:TextFormat;
      
      private const YI:Number = 100000000;
      
      private const WAN_YI:Number = 1000000000000;
      
      private var _rect:Rectangle;
      
      public function ArtWordsManager()
      {
         super();
         var _loc1_:Class = ApplicationDomain.currentDomain.getDefinition("ArtWord") as Class;
         var _loc2_:MovieClip = new _loc1_() as MovieClip;
         this._text = _loc2_._txt;
         this._textFormat = this._text.defaultTextFormat;
      }
      
      public static function get instance() : ArtWordsManager
      {
         if(_instance == null)
         {
            _instance = new ArtWordsManager();
         }
         return _instance;
      }
      
      public static function getAttackNumDis(param1:Number) : DisplayObject
      {
         return null;
      }
      
      public function artWordsDisplay(param1:Number, param2:uint, param3:Number, param4:Boolean) : DisplayObject
      {
         var _loc5_:Bitmap = null;
         var _loc6_:BitmapData = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Bitmap = null;
         var _loc13_:Bitmap = null;
         var _loc14_:Bitmap = null;
         var _loc15_:BitmapData = null;
         var _loc16_:BitmapData = null;
         var _loc17_:BitmapData = null;
         var _loc18_:Sprite = null;
         this._textFormat.color = param2;
         this._textFormat.size = param3;
         this._text.defaultTextFormat = this._textFormat;
         if(param1 < this.YI)
         {
            _loc7_ = param1.toString();
            this._text.text = _loc7_;
            _loc6_ = new BitmapData(this._text.textWidth + 1,this._text.textHeight + 1,true,0);
            _loc6_.draw(this._text);
            _loc5_ = new Bitmap(_loc6_);
            if(param4)
            {
               TextFilter.MiaoBian(_loc5_,1118481);
            }
            return _loc5_;
         }
         if(param1 >= this.YI && param1 < this.WAN_YI)
         {
            _loc7_ = Math.floor(param1 / this.YI * 100) / 100 + "亿";
            this._text.text = _loc7_;
            _loc6_ = new BitmapData(this._text.textWidth + 1,this._text.textHeight + 1,true,0);
            _loc6_.draw(this._text);
            _loc5_ = new Bitmap(_loc6_);
            if(param4)
            {
               TextFilter.MiaoBian(_loc5_,1118481);
            }
            return _loc5_;
         }
         if(param1 >= this.WAN_YI)
         {
            _loc8_ = param1.toExponential(2).toString();
            _loc9_ = _loc8_.substr(0,_loc8_.indexOf("e+"));
            _loc10_ = _loc9_ + "×10";
            _loc11_ = int(_loc8_.slice(_loc8_.indexOf("e+") + 2)) - 8 + "";
            _loc12_ = new Bitmap();
            _loc13_ = new Bitmap();
            _loc14_ = new Bitmap();
            _loc7_ = _loc10_;
            this._text.text = _loc7_;
            _loc15_ = new BitmapData(this._text.textWidth + 1,this._text.textHeight + 1,true,0);
            _loc15_.draw(this._text);
            _loc7_ = _loc11_ + "";
            this._text.text = _loc7_;
            _loc16_ = new BitmapData(this._text.textWidth + 1,this._text.textHeight + 1,true,0);
            _loc16_.draw(this._text);
            _loc7_ = "亿";
            this._text.text = _loc7_;
            _loc17_ = new BitmapData(this._text.textWidth + 1,this._text.textHeight + 1,true,0);
            _loc17_.draw(this._text);
            _loc12_.bitmapData = _loc15_;
            _loc13_.bitmapData = _loc16_;
            _loc14_.bitmapData = _loc17_;
            _loc18_ = new Sprite();
            _loc18_.addChild(_loc12_);
            _loc18_.addChild(_loc13_);
            _loc13_.y = -param3 * 3 / 5;
            _loc18_.addChild(_loc14_);
            _loc13_.x = _loc12_.width;
            _loc14_.x = _loc13_.x + _loc13_.width;
            if(param4)
            {
               TextFilter.MiaoBian(_loc18_,1118481);
            }
            return _loc18_;
         }
         return null;
      }
      
      public function getArtWordByTwoNumber(param1:Number, param2:Number, param3:uint, param4:uint, param5:Number, param6:int, param7:Boolean) : DisplayObject
      {
         var _loc8_:Sprite = new Sprite();
         var _loc9_:DisplayObject = this.artWordsDisplay(param1,param3,param5,param7);
         var _loc10_:DisplayObject = this.artWordsDisplay(param2,param4,param5,param7);
         if(param6 == 1)
         {
            this._text.text = "→";
         }
         else
         {
            this._text.text = "/";
         }
         var _loc11_:BitmapData = new BitmapData(this._text.textWidth + 1,this._text.textHeight,true,0);
         _loc11_.draw(this._text);
         var _loc12_:Bitmap = new Bitmap();
         _loc12_.bitmapData = _loc11_;
         if(param7)
         {
            TextFilter.MiaoBian(_loc12_,1118481);
         }
         _loc8_.addChild(_loc9_);
         _loc8_.addChild(_loc12_);
         _loc8_.addChild(_loc10_);
         _loc12_.x = _loc9_.width;
         _loc10_.x = _loc9_.width + _loc12_.width;
         return _loc8_;
      }
      
      public function getSigleSpecilArtWord(param1:String, param2:uint, param3:Number, param4:Boolean) : DisplayObject
      {
         var _loc5_:Sprite = new Sprite();
         this._text.text = param1;
         var _loc6_:BitmapData = new BitmapData(this._text.textWidth + 1,this._text.textHeight,true,0);
         _loc6_.draw(this._text);
         var _loc7_:Bitmap = new Bitmap();
         _loc7_.bitmapData = _loc6_;
         if(param4)
         {
            TextFilter.MiaoBian(_loc7_,1118481);
         }
         _loc5_.addChild(_loc7_);
         return _loc5_;
      }
   }
}

