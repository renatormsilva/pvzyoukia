package core.managers
{
   import core.ui.loaders.UILoader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.utils.Dictionary;
   import pvz.shaketree.utils.Rect;
   import utils.GetDomainRes;
   import xmlReader.config.XmlUIConfig;
   
   public class DistributionLoaderManager
   {
      
      private static var _I:DistributionLoaderManager;
      
      private static const CONCURRENT:int = 1;
      
      private var assetsLoaded:Dictionary;
      
      private var swfsLoaded:Dictionary;
      
      private var currentUIUrls:Array;
      
      private var _loadedFunc:Function;
      
      private var _currentLoadedNum:int;
      
      private var _currentLoadingTotal:int;
      
      private var _loadingMc:MovieClip;
      
      private var _loaderMask:Rect;
      
      public function DistributionLoaderManager(param1:PrivateClass)
      {
         super();
         this.assetsLoaded = new Dictionary();
         this.swfsLoaded = new Dictionary();
         this._loadingMc = GetDomainRes.getMoveClip("pvz.windowLoading");
      }
      
      public static function get I() : DistributionLoaderManager
      {
         if(_I == null)
         {
            _I = new DistributionLoaderManager(new PrivateClass());
         }
         return _I;
      }
      
      public function loadUIByFunctionType(param1:String, param2:Function) : void
      {
         this._loadedFunc = param2;
         if(this.assetsLoaded[param1])
         {
            if(this._loadedFunc != null)
            {
               this._loadedFunc.call();
            }
            return;
         }
         this.assetsLoaded[param1] = param1;
         this.currentUIUrls = this.deletedLoadUrls(XmlUIConfig.getInstance().getUiURlsByFunctionType(param1));
         if(this.currentUIUrls.length <= 0)
         {
            if(this._loadedFunc != null)
            {
               this._loadedFunc.call();
            }
            return;
         }
         this._currentLoadingTotal = this.currentUIUrls.length;
         this.startLoading();
      }
      
      private function deletedLoadUrls(param1:Array) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(!this.swfsLoaded[_loc3_])
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function startLoading() : void
      {
         if(this._loaderMask == null)
         {
            this._loaderMask = new Rect(PlantsVsZombies._node.stage.stageWidth,PlantsVsZombies._node.stage.stageHeight,0,0.7);
         }
         PlantsVsZombies._node.addChild(this._loaderMask);
         PlantsVsZombies._node.addChild(this._loadingMc);
         this._loadingMc.bar.scaleX = 0;
         var _loc1_:int = 0;
         while(_loc1_ < CONCURRENT)
         {
            this.loadingSingle();
            _loc1_++;
         }
      }
      
      private function loadingSingle() : void
      {
         var _loc1_:String = null;
         var _loc2_:UILoader = null;
         if(this.currentUIUrls.length > 0)
         {
            _loc1_ = this.currentUIUrls.shift();
            _loc2_ = new UILoader();
            _loc2_.url = _loc1_;
            _loc2_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
            _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompeleHandler);
            _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            _loc2_.starLoad();
         }
      }
      
      protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:UILoader = (param1.currentTarget as LoaderInfo).loader as UILoader;
         throw new Error("加载资源出错,资源路径:" + _loc2_.url);
      }
      
      protected function onCompeleHandler(param1:Event) : void
      {
         ++this._currentLoadedNum;
         var _loc2_:UILoader = (param1.currentTarget as LoaderInfo).loader as UILoader;
         this.swfsLoaded[_loc2_.url] = _loc2_.url;
         _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompeleHandler);
         _loc2_.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
         if(this._currentLoadedNum < this._currentLoadingTotal)
         {
            this.loadingSingle();
         }
         else if(this._loadedFunc != null)
         {
            this._currentLoadedNum = 0;
            this._currentLoadingTotal = 0;
            this.currentUIUrls = null;
            PlantsVsZombies._node.removeChild(this._loaderMask);
            PlantsVsZombies._node.removeChild(this._loadingMc);
            this._loadedFunc.call();
         }
      }
      
      protected function onProgressHandler(param1:ProgressEvent) : void
      {
         this._loadingMc.bar.scaleX = param1.bytesLoaded / param1.bytesTotal;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
