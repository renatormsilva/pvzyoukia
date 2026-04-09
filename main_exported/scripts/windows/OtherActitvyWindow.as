package windows
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.res.IDestroy;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import manager.JSManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class OtherActitvyWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      public static const GET_ACTITVY:int = 1;
      
      private var _img_url:String;
      
      private var _web_url:String;
      
      private var _window:MovieClip = null;
      
      public function OtherActitvyWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("OtherActivtyWindow");
         this._window = new _loc1_();
         showBG(PlantsVsZombies._node);
         this.setLoction();
         PlantsVsZombies._node.addChild(this._window);
         this._window.visible = false;
         this.addEvent();
         this.initData();
      }
      
      override public function destroy() : void
      {
         this._window["close"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._window["joinActitvy"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         PlantsVsZombies._node.removeChild(this._window);
         this._window = null;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == GET_ACTITVY)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param1 == GET_ACTITVY)
         {
            this._img_url = param2.img;
            this._web_url = param2.url;
            this.showBanner();
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
      
      public function showBanner() : void
      {
         var loader:Loader = null;
         var onCompleter:Function = null;
         var onError:Function = null;
         onCompleter = function(param1:Event):void
         {
            _window["pic"].addChild(loader);
            show();
         };
         onError = function(param1:IOErrorEvent):void
         {
            PlantsVsZombies.showSystemErrorInfo("加载活动banner出错");
         };
         loader = new Loader();
         loader.load(new URLRequest(this._img_url + "?" + FuncKit.currentTimeMillis()));
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleter);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
      }
      
      private function addEvent() : void
      {
         this._window["close"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         this._window["joinActitvy"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
      }
      
      private function hide() : void
      {
         onHiddenEffect(this._window,this.destroy);
      }
      
      private function initData() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_OTHER_ACTITVY,GET_ACTITVY);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         switch(param1.target.name)
         {
            case "close":
               this.hide();
               break;
            case "joinActitvy":
               JSManager.goToActivity(this._web_url);
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function show() : void
      {
         PlantsVsZombies.showDataLoading(false);
         this._window.visible = true;
         onShowEffect(this._window);
      }
   }
}

