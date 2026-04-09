package pvz.invitePrizes
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.VersionManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class InvitePrizeActionWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _backFun:Function;
      
      public function InvitePrizeActionWindow(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("invitePrizeActionWindow");
         this._window = new _loc2_();
         this._backFun = param1;
         this.setLoction();
         this.addEvent();
         this._window.visible = false;
      }
      
      public function show(param1:int) : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChildAt(this._window,PlantsVsZombies._node.numChildren);
         this._window.visible = true;
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
            this._window._cancel.visible = false;
         }
         else
         {
            this._window._cancel.visible = true;
         }
         this.showNum(param1);
         onShowEffect(this._window);
      }
      
      private function showNum(param1:int) : void
      {
         if(this._window._pic != null && this._window._pic.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window._pic);
         }
         var _loc2_:DisplayObject = FuncKit.getNumEffect(param1 + "","Small");
         _loc2_.x = -_loc2_.width / 2;
         this._window._pic.addChild(_loc2_);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function addEvent() : void
      {
         this._window._ok.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this._window._cancel.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_ok")
         {
            if(this._backFun != null)
            {
               this._backFun();
            }
            this.hidden();
         }
         else if(param1.currentTarget.name == "_cancel")
         {
            this.hidden();
         }
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window,this.destroy);
      }
      
      override public function destroy() : void
      {
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

