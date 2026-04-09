package pvz.world
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.GlowTween;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class CheckpointForeBox extends Sprite implements IDestroy
   {
      
      private var _checkpoint:Checkpoint = null;
      
      private var _box:MovieClip = null;
      
      public function CheckpointForeBox(param1:Checkpoint)
      {
         super();
         this._checkpoint = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.box");
         this._box = new _loc1_();
         new GlowTween(this._box,16777113);
         this.addChild(this._box);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         dispatchEvent(new CheckpointEvent(CheckpointEvent.SHOW_BOX_TIPS,this._checkpoint));
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         dispatchEvent(new CheckpointEvent(CheckpointEvent.CLEAR_BOX_TIPS,this._checkpoint));
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this.removeChild(this._box);
         this._box = null;
      }
   }
}

