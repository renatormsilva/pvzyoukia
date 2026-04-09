package windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.LangManager;
   import zlib.utils.DomainAccess;
   
   public class AvertWallowWindow extends BaseWindow
   {
      
      internal var _backFun:Function;
      
      internal var _isSelect:Boolean = true;
      
      internal var _window:MovieClip;
      
      public function AvertWallowWindow(param1:Function)
      {
         super();
         this._backFun = param1;
         var _loc2_:Class = DomainAccess.getClass("avertWallowWindow");
         this._window = new _loc2_();
         this._window.visible = false;
         this.initButton();
      }
      
      public function show() : void
      {
         this._window.visible = true;
         PlantsVsZombies._node.addChild(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function hidden() : void
      {
         this._window.visible = false;
         this.removeButtonEvent();
         PlantsVsZombies._node.removeChild(this._window);
         if(this._backFun != null)
         {
            this._backFun();
         }
      }
      
      private function initButton() : void
      {
         this._window["_select"].gotoAndStop(2);
         this._window["_select"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_read"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_select")
         {
            if(this._isSelect)
            {
               this._isSelect = false;
               this._window["_select"].gotoAndStop(1);
            }
            else
            {
               this._isSelect = true;
               this._window["_select"].gotoAndStop(2);
            }
         }
         else if(param1.currentTarget.name == "_read")
         {
            JSManager.gotoService();
         }
         else if(param1.currentTarget.name == "_ok")
         {
            if(!this._isSelect)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window085"));
               return;
            }
            this.hidden();
         }
      }
      
      private function removeButtonEvent() : void
      {
         this._window["_select"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_read"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}

