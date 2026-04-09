package zmyth.load
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Stage;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   import zlib.event.ForeletEvent;
   import zlib.log.*;
   import zlib.sets.Hashtable;
   import zmyth.ui.CloseOver;
   
   public class UILoader extends EventDispatcher
   {
      
      private static var Loading:Class;
      
      public static var alreadyLoaded:Hashtable = new Hashtable();
      
      public static var unLoaded:Hashtable = new Hashtable();
      
      public static const TARGET_CHILD:String = "child";
      
      public static const TARGET_SAME:String = "same";
      
      public static const TARGET_NEW:String = "new";
      
      private static var logger:Logger = LogFactory.getLoggerClass(UILoader);
      
      private static var stage:Stage = null;
      
      private var closeOver:CloseOver;
      
      private var loader:Loader = new Loader();
      
      private var context:LoaderContext = new LoaderContext(true);
      
      public var url:String;
      
      private var objX:Number;
      
      private var objY:Number;
      
      private var objWidth:int;
      
      private var objHeight:int;
      
      private var isShow:Boolean;
      
      private var isShowProgress:Boolean;
      
      private var loading:Object;
      
      private var loadName:String;
      
      private var waitLoadTimer:Timer;
      
      public var subLoaderInfo:LoaderInfo;
      
      public var displayObjectContainer:DisplayObjectContainer;
      
      private var cfg:Object = Object["parameters"];
      
      private var listener:Object;
      
      public function UILoader(param1:DisplayObjectContainer, param2:String, param3:Boolean = true, param4:Boolean = true, param5:String = " ", param6:int = 888, param7:int = 600, param8:Number = 0, param9:Number = 0, param10:String = "same")
      {
         super();
         this.context.applicationDomain = this.getDomain(param10);
         this.loadName = param5;
         this.objWidth = param6;
         this.objHeight = param7;
         this.isShowProgress = param4;
         if(this.cfg.swfurl != null)
         {
            if(param2.toLowerCase().indexOf("http") < 0)
            {
               this.url = this.cfg.swfurl + param2;
            }
            else
            {
               this.url = param2;
            }
         }
         else
         {
            this.url = param2;
         }
         this.isShow = param3;
         this.objX = param8;
         this.objY = param9;
         this.displayObjectContainer = param1;
      }
      
      public static function init(param1:Stage) : void
      {
         stage = param1;
      }
      
      public function setLoading(param1:Class) : void
      {
         Loading = param1;
      }
      
      public function doLoad() : void
      {
         if(alreadyLoaded.keys.toArray().indexOf(this.url) < 0)
         {
            this.loadObject();
         }
         else
         {
            this.loadExistObject();
         }
      }
      
      private function loadExistObject() : void
      {
         var _loc1_:DisplayObject = alreadyLoaded[this.url];
         if(_loc1_ != null)
         {
            if(this.isShowProgress)
            {
               if(this.loading != null)
               {
                  this.loading.setPercent(100);
               }
            }
            if(logger.isDebugEnabled)
            {
               logger.debug("Load [" + this.url + "] file is Successful with old!");
            }
            this.dispatchEvent(new ForeletEvent(ForeletEvent.COMPLETE,_loc1_));
         }
         else
         {
            this.loadObject();
         }
      }
      
      private function loadObject() : void
      {
         if(unLoaded.keys.toArray().indexOf(this.url) >= 0)
         {
            this.waitLoadTimer = new Timer(100);
            this.waitLoadTimer.addEventListener(TimerEvent.TIMER,this.onWaitLoadTimer);
            this.waitLoadTimer.start();
            return;
         }
         unLoaded.add(this.url,this);
         var _loc1_:String = this.url;
         this.loader.load(new URLRequest(_loc1_),this.context);
         this.initLoadEvent(this.loader.contentLoaderInfo);
         if(this.isShowProgress)
         {
            this.loading = new Loading(this.loadName);
            this.showProcess();
         }
      }
      
      private function onWaitLoadTimer(param1:TimerEvent) : void
      {
         var _loc2_:Timer = null;
         if(unLoaded.keys.toArray().indexOf(this.url) < 0)
         {
            _loc2_ = param1.target as Timer;
            if(_loc2_ != null)
            {
               _loc2_.stop();
               _loc2_.removeEventListener(TimerEvent.TIMER,this.onWaitLoadTimer);
               _loc2_ = null;
            }
            this.loadExistObject();
         }
      }
      
      public function setListener(param1:Object) : void
      {
         this.listener = param1;
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgressListener);
      }
      
      private function onProgressListener(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesLoaded / param1.bytesTotal * 100;
         this.listener.loadName.text = this.loadName;
         if(this.listener._loading_bar != null)
         {
            this.listener._loading_bar.gotoAndStop(_loc2_);
            this.listener._loading_pre.gotoAndStop(_loc2_);
         }
         else
         {
            this.listener._p.text = _loc2_;
         }
      }
      
      private function onResize(param1:Event) : void
      {
         this.toCenter();
      }
      
      private function toCenter() : void
      {
         if(this.loading != null)
         {
            this.loading.x = stage.stageWidth / 2 - this.loading.width / 2;
            this.loading.y = stage.stageHeight / 2 - this.loading.height / 2;
         }
      }
      
      private function initLoadEvent(param1:LoaderInfo) : void
      {
         if(this.isShowProgress)
         {
            param1.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
         param1.addEventListener(Event.COMPLETE,this.onComplete);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
      }
      
      private function removeLoadEvent(param1:LoaderInfo) : void
      {
         if(this.isShowProgress)
         {
            param1.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
         param1.removeEventListener(Event.COMPLETE,this.onComplete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
      }
      
      private function onComplete(param1:Event) : void
      {
         this.subLoaderInfo = param1.target as LoaderInfo;
         this.removeLoadEvent(this.subLoaderInfo);
         if(this.listener != null)
         {
            this.listener = null;
         }
         if(this.isShowProgress)
         {
            if(stage != null)
            {
               this.loading.setPercent(100);
               stage.removeChild(this.loading as DisplayObject);
               this.closeOver.visible = false;
               if(this.closeOver.parent != null)
               {
                  this.closeOver.parent.removeChild(this.closeOver);
               }
            }
         }
         unLoaded.remove(this.url);
         this.setShow();
         alreadyLoaded.add(this.url,this.subLoaderInfo.content);
         this.dispatchEvent(new ForeletEvent(ForeletEvent.COMPLETE,this.subLoaderInfo.content,this.subLoaderInfo));
         if(unLoaded.keys.length <= 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE,null));
         }
         this.loader.unloadAndStop();
      }
      
      private function setShow() : void
      {
         if(this.isShow)
         {
            if(this.displayObjectContainer != null)
            {
               this.displayObjectContainer.addChild(this.subLoaderInfo.content);
            }
            this.subLoaderInfo.content.x = this.objX;
            this.subLoaderInfo.content.y = this.objY;
         }
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         this.dispatchEvent(param1);
         var _loc2_:int = param1.bytesLoaded / param1.bytesTotal * 100;
         this.loading.setPercent(_loc2_);
      }
      
      private function onError(param1:Event) : void
      {
         if(logger.isErrorEnabled)
         {
            logger.error("UILoader:" + (param1 as Object).text + " unLoad:" + unLoaded.keys.length);
         }
         unLoaded.remove(this.url);
         this.dispatchEvent(new ForeletEvent(ForeletEvent.ERROR,param1));
      }
      
      private function getDomain(param1:String) : ApplicationDomain
      {
         switch(param1)
         {
            case UILoader.TARGET_CHILD:
               return new ApplicationDomain(ApplicationDomain.currentDomain);
            case UILoader.TARGET_SAME:
               return ApplicationDomain.currentDomain;
            case UILoader.TARGET_NEW:
               return new ApplicationDomain();
            default:
               return ApplicationDomain.currentDomain;
         }
      }
      
      private function showProcess() : void
      {
         if(stage != null)
         {
            this.closeOver = new CloseOver(stage);
            stage.addChild(this.loading as DisplayObject);
            stage.addEventListener(Event.RESIZE,this.onResize);
            this.loading.visible = true;
            this.toCenter();
         }
      }
   }
}

