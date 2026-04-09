package pvz.world
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import manager.SoundManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldTitlePanel extends Sprite implements IDestroy
   {
      
      private var _mapId:int = 0;
      
      private var _c:int = 0;
      
      private var _panel:MovieClip = null;
      
      private var _id:int = 0;
      
      public function InsideWorldTitlePanel(param1:int)
      {
         super();
         this._mapId = param1;
         this.init();
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getComp() : int
      {
         return this._c;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.insideWorldTitle");
         this._panel = new _loc1_();
         this.show();
         this._panel.x = 14;
         this._panel.y = 0;
         this.addChild(this._panel);
      }
      
      private function show() : void
      {
         this._panel["title"].gotoAndStop(this._mapId);
         this.showComplete(this._c);
      }
      
      public function initComp(param1:int) : void
      {
         this._c = param1;
         this.showComplete(this._c);
      }
      
      private function showComplete(param1:int) : void
      {
         this.clearComplete();
         var _loc2_:DisplayObject = FuncKit.getNumEffect(param1 + "");
         this._panel["comp"].addChild(_loc2_);
      }
      
      private function clearComplete() : void
      {
         FuncKit.clearAllChildrens(this._panel["comp"]);
      }
      
      public function addComplete(param1:Boolean) : void
      {
         PlantsVsZombies.playSounds(SoundManager.MONEY);
         ++this._c;
         this.showComplete(this._c);
         if(param1)
         {
            dispatchEvent(new InsideWorldEvent(InsideWorldEvent.TO_CHECKPOINT,this._id));
         }
      }
      
      public function destroy() : void
      {
         this.clearComplete();
      }
      
      public function getCompPoint() : Point
      {
         return new Point(this._panel.x + this._panel["comp"].x,this._panel.y + this._panel["comp"].y);
      }
   }
}

