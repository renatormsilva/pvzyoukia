package pvz
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.LangManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class EveryDayPrize extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _back:Function = null;
      
      public function EveryDayPrize(param1:Function)
      {
         var temp:Class;
         var onClick:Function = null;
         var back:Function = param1;
         super();
         onClick = function(param1:MouseEvent):void
         {
            _window._ok.removeEventListener(MouseEvent.CLICK,onClick);
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
            {
               _back();
               onHiddenEffect(_window,showInvite);
            }
            else
            {
               onHiddenEffect(_window,back);
            }
         };
         temp = DomainAccess.getClass("everydayPrize");
         this._window = new temp();
         this._window.gotoAndStop(1);
         this._window._ok.addEventListener(MouseEvent.CLICK,onClick);
         this._window.visible = false;
         this._back = back;
      }
      
      private function showInvite() : void
      {
         var showShare:Function = null;
         showShare = function():void
         {
            if(_back != null)
            {
               _back();
            }
            JSManager.showShare("share008");
         };
         PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("window083"),showShare);
      }
      
      public function show(param1:int) : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window._num.addChild(FuncKit.getNumEffect(param1 + "","Small"));
         this._window.visible = true;
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

