package pvz.world
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldNode extends Sprite implements IDestroy
   {
      
      private var _id:int = 0;
      
      private var _nowId:int = 0;
      
      public var endX:int = 0;
      
      public function InsideWorldNode(param1:int, param2:int)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("ui.world.insidenode" + param1);
         var _loc4_:SimpleButton = new _loc3_();
         this._id = param1;
         this._nowId = param2;
         this.addChild(_loc4_);
         this.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.dispatchEvent(new InsideWorldEvent(InsideWorldEvent.CHANGE,this._id));
      }
      
      public function destroy() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}

