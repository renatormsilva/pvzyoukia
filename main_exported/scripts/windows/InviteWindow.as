package windows
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import zlib.utils.DomainAccess;
   import zmyth.ui.TextFilter;
   
   public class InviteWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _backFunction:Function;
      
      public function InviteWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("inviteWindow");
         this._window = new _loc1_();
         this._window.gotoAndStop(1);
         TextFilter.MiaoBian(this._window.str,0,1,2,2);
         this.addBtEvent();
         PlantsVsZombies._node.addChild(this._window);
      }
      
      private function addBtEvent() : void
      {
         this._window._cancel.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeBtEvent() : void
      {
         this._window._cancel.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
            {
               this._backFunction = null;
            }
            this.hidden();
         }
      }
      
      private function hidden() : void
      {
         this.removeBtEvent();
         onHiddenEffect(this._window,this._backFunction);
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function invite() : void
      {
         this.hidden();
         JSManager.invite();
      }
      
      public function show(param1:String, param2:Function) : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.str.text = "";
         this._window.visible = true;
         this._window.str.text = param1;
         this._backFunction = param2;
         PlantsVsZombies._node.addChild(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
         this.setLoction();
         onShowEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
      }
   }
}

