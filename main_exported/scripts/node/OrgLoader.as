package node
{
   import com.display.BitmapDateSourseManager;
   import com.display.BitmapFrameInfo;
   import com.display.BitmapFrameInfos;
   import com.display.CMovieClip;
   import com.res.IDestroy;
   import constants.GlobalConstants;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class OrgLoader extends Sprite implements IDestroy
   {
      
      private static const OVERTIME:int = 20;
      
      private var OrgClass:Class = null;
      
      private var _loader:Loader = null;
      
      private var _oid:int = 0;
      
      private var _loc:int = 0;
      
      private var _timer:Timer = null;
      
      private var _backFun:Function = null;
      
      private var _scale:Number = 1;
      
      private var _useBitmap:Boolean = true;
      
      public function OrgLoader(param1:int, param2:int = 0, param3:Function = null, param4:Number = 1, param5:Boolean = true)
      {
         super();
         this._oid = param1;
         this._loc = param2;
         this._useBitmap = param5;
         this._backFun = param3;
         this._scale = param4;
         if(this._useBitmap)
         {
            this.OrgClass = DomainAccess.getClass("org_" + param1 + "_" + 0);
         }
         else
         {
            this.OrgClass = DomainAccess.getClass("org_" + param1 + "_" + this._loc);
         }
         if(this.OrgClass == null)
         {
            this.doLoad();
         }
         else
         {
            this.addOrg();
         }
      }
      
      public static function getORGLoaderUrl(param1:int) : String
      {
         return GlobalConstants.PVZ_RES_BASE_URL + "ORGLibs/org_" + param1 + ".swf?" + GlobalConstants.ORG_RES_VERSION;
      }
      
      public function getWidth() : Number
      {
         if(this.numChildren < 1)
         {
            return 0;
         }
         if(this._useBitmap)
         {
            return ((getChildAt(0) as CMovieClip).getBitmapdateInfos().getBitmapFrames()[0] as BitmapFrameInfo).date.width;
         }
         return this.width;
      }
      
      public function getHeight() : Number
      {
         if(this.numChildren < 1)
         {
            return 0;
         }
         if(this._useBitmap)
         {
            return ((getChildAt(0) as CMovieClip).getBitmapdateInfos().getBitmapFrames()[0] as BitmapFrameInfo).date.height;
         }
         return this.height;
      }
      
      public function destroy() : void
      {
         FuncKit.clearAllChildrens(this);
      }
      
      private function addOrg() : void
      {
         var _loc1_:MovieClip = null;
         if(!this._useBitmap)
         {
            _loc1_ = new this.OrgClass();
            addChild(_loc1_);
            return;
         }
         var _loc2_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,"org_" + this._oid + "_" + 0,this._scale);
         if(_loc2_ == null)
         {
            _loc1_ = new this.OrgClass();
            _loc2_ = BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc1_["org"],"org_" + this._oid + "_" + 0,this._scale);
         }
         var _loc3_:CMovieClip = new CMovieClip(_loc2_,12);
         if(this._loc == 1)
         {
            _loc3_.bitmap.y = _loc2_.getBaseMcTransform().matrix.ty * this._scale;
            if(_loc2_.getBaseMcTransform().matrix.a < 0)
            {
               _loc3_.bitmap.x -= _loc2_.getBaseMcTransform().matrix.tx * this._scale;
            }
            else
            {
               BitmapDateSourseManager.flipHorizontal(_loc3_);
               _loc3_.bitmap.x -= _loc2_.getBaseMcTransform().matrix.tx * this._scale;
            }
         }
         else
         {
            _loc3_.bitmap.x = _loc2_.getBaseMcTransform().matrix.tx * this._scale;
            _loc3_.bitmap.y = _loc2_.getBaseMcTransform().matrix.ty * this._scale;
            if(_loc2_.getBaseMcTransform().matrix.a < 0)
            {
               BitmapDateSourseManager.flipHorizontal(_loc3_);
            }
         }
         addChild(_loc3_);
      }
      
      private function onOverTime(param1:TimerEvent) : void
      {
         this._loader.close();
         this.closeLoader();
         this.closeTimer();
      }
      
      private function closeLoader() : void
      {
         if(this._loader == null)
         {
            return;
         }
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComp);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this._loader = null;
      }
      
      private function closeTimer() : void
      {
         if(this._timer == null)
         {
            return;
         }
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onOverTime);
         this._timer = null;
      }
      
      private function doLoad() : void
      {
         this.addDefault();
         this._loader = new Loader();
         var _loc1_:LoaderContext = new LoaderContext(true);
         _loc1_.applicationDomain = ApplicationDomain.currentDomain;
         this._loader.load(new URLRequest(getORGLoaderUrl(this._oid)),_loc1_);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComp);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
      }
      
      private function onComp(param1:Event) : void
      {
         this.closeLoader();
         this.closeTimer();
         if(this._useBitmap)
         {
            this.OrgClass = DomainAccess.getClass("org_" + this._oid + "_" + 0);
         }
         else
         {
            this.OrgClass = DomainAccess.getClass("org_" + this._oid + "_" + this._loc);
         }
         this.removeDefault();
         this.addOrg();
         if(this._backFun != null)
         {
            this._backFun();
         }
      }
      
      private function ioError(param1:IOErrorEvent) : void
      {
         this.closeLoader();
         this.closeTimer();
      }
      
      private function addDefault() : void
      {
         if(numChildren > 0)
         {
            return;
         }
         var _loc1_:Class = DomainAccess.getClass("org_default_" + this._loc);
         var _loc2_:MovieClip = new _loc1_();
         addChild(_loc2_);
      }
      
      private function removeDefault() : void
      {
         if(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
   }
}

