package loading
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import manager.UILoaderManager;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.load.UILoader;
   
   public class UILoading extends Sprite implements IURLConnection
   {
      
      private var _loading:MovieClip = null;
      
      private var _uiloadmanager:UILoaderManager = null;
      
      private var _container:DisplayObjectContainer = null;
      
      private var _urlhead:String = "";
      
      public function UILoading(param1:DisplayObjectContainer, param2:String, param3:String)
      {
         super();
         this._container = param1;
         this._urlhead = param2;
         var _loc4_:Class = DomainAccess.getClass("loading");
         this._loading = new _loc4_();
         this._container.addChild(this._loading);
         this.urlloaderSend(this._urlhead + param3,0);
         PlantsVsZombies.showDataLoading(true);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,0,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         this._uiloadmanager = new UILoaderManager();
         this._uiloadmanager.start(this._container,new XML(param2 as String),this._urlhead);
         PlantsVsZombies.showDataLoading(false);
         this.show();
      }
      
      public function remove() : void
      {
         this._container.removeChild(this._loading);
      }
      
      public function show() : void
      {
         this.addEventListener(ForeletEvent.ALL_COMPLETE,this.onComplete);
         if(UILoader.unLoaded.keys.length == 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE));
         }
         else
         {
            this.showNextProgress();
         }
      }
      
      public function hidden() : void
      {
         this.visible = false;
      }
      
      private function showNextProgress() : void
      {
         var _loc1_:UILoader = this.getUILoader();
         if(_loc1_ != null)
         {
            _loc1_.addEventListener(ForeletEvent.COMPLETE,this.onOneComplete);
            _loc1_.setListener(this._loading);
         }
      }
      
      private function getUILoader() : UILoader
      {
         if(UILoader.unLoaded.keys.length == 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE));
            return null;
         }
         return UILoader.unLoaded[UILoader.unLoaded.keys.getItemAt(0)];
      }
      
      private function onOneComplete(param1:ForeletEvent) : void
      {
         var _loc2_:UILoader = param1.target as UILoader;
         _loc2_.removeEventListener(ForeletEvent.COMPLETE,this.onOneComplete);
         _loc2_ = null;
         this.showNextProgress();
      }
      
      private function onComplete(param1:Event) : void
      {
         this.removeEventListener(ForeletEvent.ALL_COMPLETE,this.onComplete);
         this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE_SELF));
      }
   }
}

