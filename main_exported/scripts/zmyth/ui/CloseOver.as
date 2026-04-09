package zmyth.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import zlib.utils.Func;
   
   public class CloseOver extends MovieClip
   {
      
      private static var stageReference:Stage = null;
      
      internal var container:DisplayObjectContainer;
      
      public function CloseOver(param1:DisplayObjectContainer)
      {
         super();
         this.container = param1;
         param1.addChild(this);
         this.render();
      }
      
      public static function init(param1:Stage) : void
      {
         CloseOver.stageReference = param1;
      }
      
      private function render() : void
      {
         this.addChild(this.createBackground(0));
      }
      
      private function createBackground(param1:int) : Sprite
      {
         var _loc2_:BitmapData = new BitmapData(stageReference.fullScreenWidth,stageReference.fullScreenHeight,true,4278190080 + param1);
         var _loc3_:BitmapData = new BitmapData(stageReference.fullScreenWidth,stageReference.fullScreenHeight);
         _loc3_.draw(stageReference);
         var _loc4_:Rectangle = new Rectangle(0,0,stageReference.stageWidth,stageReference.stageHeight);
         var _loc5_:Point = new Point(0,0);
         var _loc6_:uint = 120;
         _loc2_.merge(_loc3_,_loc4_,_loc5_,_loc6_,_loc6_,_loc6_,_loc6_);
         _loc2_.applyFilter(_loc2_,_loc4_,_loc5_,new BlurFilter(5,5));
         var _loc7_:Bitmap = new Bitmap(_loc2_);
         var _loc8_:Sprite = new Sprite();
         _loc8_.addChild(_loc7_);
         return _loc8_;
      }
      
      public function destory() : void
      {
         Func.clearAllChildrens(this);
         this.container.removeChild(this);
      }
   }
}

