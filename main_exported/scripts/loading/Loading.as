package loading
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.fore.Forelet;
   import zmyth.load.UILoader;
   
   public class Loading extends Forelet
   {
      
      private var _node:Object;
      
      public var _loading:MovieClip;
      
      public function Loading(param1:DisplayObjectContainer, param2:String = "", param3:String = "")
      {
         var loadloader:UILoader;
         var onLoadLoading:Function = null;
         var container:DisplayObjectContainer = param1;
         var url:String = param2;
         var version:String = param3;
         super();
         onLoadLoading = function(param1:ForeletEvent):void
         {
            this.subObject = param1.parameter;
            this.subObject.x = 0;
            this.subObject.y = 0;
            _node = this.subObject;
            container.addChild(this.subObject as DisplayObject);
            show();
         };
         loadloader = new UILoader(container,url + "UILibs/loading" + version + ".swf",false,false);
         loadloader.addEventListener(ForeletEvent.COMPLETE,onLoadLoading);
         loadloader.doLoad();
      }
      
      override public function show() : void
      {
         var _loc1_:Class = DomainAccess.getClass("loading");
         this._loading = new _loc1_();
         this._node.addChild(this._loading);
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
      
      override public function hidden() : void
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

