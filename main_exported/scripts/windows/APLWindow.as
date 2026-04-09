package windows
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.SoundManager;
   import zlib.utils.DomainAccess;
   
   public class APLWindow extends BaseWindow implements IConnection
   {
      
      private static const LOCK:int = 1;
      
      internal var _window:MovieClip;
      
      internal var fun:Function;
      
      internal var type:int = 0;
      
      public function APLWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("everydayPrize");
         this._window = new _loc1_();
         this._window.visible = false;
         this._window._ok.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function setBackFun(param1:Function) : void
      {
         this.fun = param1;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.type == 1)
         {
            this.lock();
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         onHiddenEffect(this._window,this.fun);
      }
      
      public function show(param1:int) : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this.type = param1;
         this._window.gotoAndStop(this.type + 1);
         this._window.visible = true;
         PlantsVsZombies._node.addChild(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
         this.setLoction();
         onShowEffect(this._window);
      }
      
      public function hidden() : void
      {
         this._window.visible = false;
         removeBG();
      }
      
      private function setLoction() : void
      {
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      public function lock() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_LOCK,0,APLManager.TIME);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callO(param2,param3,rest[0]);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
      }
   }
}

