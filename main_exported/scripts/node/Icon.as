package node
{
   import constants.GlobalConstants;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import zlib.utils.DomainAccess;
   
   public class Icon
   {
      
      private static var loadContent:LoaderContext;
      
      public static var SYSTEM:int = 0;
      
      public static var ORGANISM:int = 1;
      
      public static var TOOL:int = 2;
      
      public static var MONEY:int = 3;
      
      public static const IHANDBOOK:int = 2;
      
      public static const EMPIRISM:int = 3;
      
      public static var TOOL_1:String = "IconRes/IconTool/";
      
      public static var ORGANISM_1:String = "IconRes/IconOrg/";
      
      public static var SYSTEM_1:String = "IconRes/IconSystem/";
      
      public static var MONEY_1:String = "IconRes/IconSystem/";
      
      private static var PicClass:Class = null;
      
      public function Icon()
      {
         super();
      }
      
      public static function getIcon(param1:int, param2:int) : MovieClip
      {
         var _loc3_:Class = null;
         if(param2 == SYSTEM)
         {
            _loc3_ = DomainAccess.getClass("icon_sys_" + param1);
         }
         return new _loc3_();
      }
      
      public static function setJewelIcon(param1:DisplayObjectContainer, param2:int, param3:Number = 1) : void
      {
         var _loc4_:String = "jewel_" + param2;
         var _loc5_:Bitmap = GetDomainRes.getBitmap(_loc4_);
         _loc5_.scaleX = param3;
         _loc5_.scaleY = param3;
         param1.addChild(_loc5_);
      }
      
      public static function setUrlIcon(param1:DisplayObjectContainer, param2:int, param3:String, param4:Number = 1, param5:Function = null) : void
      {
         var edition:String = null;
         var PicLoading:Class = null;
         var picLoad:MovieClip = null;
         var mc:MovieClip = null;
         var disObject:DisplayObjectContainer = param1;
         var iconid:int = param2;
         var icontype:String = param3;
         var scale:Number = param4;
         var _backfuc:Function = param5;
         var doLoad:Function = function():void
         {
            var _loader:Loader = null;
            var onPicComplete:Function = null;
            var ioError:Function = null;
            onPicComplete = function(param1:Event):void
            {
               FuncKit.clearAllChildrens(disObject);
               _loader.removeEventListener(Event.COMPLETE,onPicComplete);
               _loader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
               _loader.unload();
               PicClass = DomainAccess.getClass(edition + iconid);
               var _loc2_:MovieClip = new PicClass();
               _loc2_.scaleX = scale;
               _loc2_.scaleY = scale;
               disObject.addChild(_loc2_);
               if(_backfuc != null)
               {
                  _backfuc();
               }
            };
            ioError = function(param1:IOErrorEvent):void
            {
            };
            var icon_url:String = GlobalConstants.PVZ_RES_BASE_URL + icontype + iconid + ".swf?" + FuncKit.currentTimeMillis();
            _loader = new Loader();
            if(loadContent == null)
            {
               loadContent = new LoaderContext(true);
            }
            loadContent.applicationDomain = ApplicationDomain.currentDomain;
            _loader.load(new URLRequest(icon_url),loadContent);
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPicComplete);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
         };
         if(icontype == TOOL_1)
         {
            edition = "icon_tool_";
         }
         else if(icontype == ORGANISM_1)
         {
            edition = "icon_org_";
         }
         else if(icontype == SYSTEM_1)
         {
            edition = "icon_sys_";
         }
         else if(icontype == MONEY_1)
         {
            edition = "icon_money";
         }
         PicClass = DomainAccess.getClass(edition + iconid);
         if(PicClass == null)
         {
            PicLoading = DomainAccess.getClass("PicLoading");
            picLoad = new PicLoading();
            disObject.addChildAt(picLoad,0);
            picLoad.x = 14;
            picLoad.y = 16;
            picLoad.scaleX = scale;
            picLoad.scaleY = scale;
            doLoad();
         }
         else
         {
            mc = new PicClass();
            mc.scaleX = scale;
            mc.scaleY = scale;
            disObject.addChild(mc);
            if(_backfuc != null)
            {
               _backfuc();
            }
         }
      }
   }
}

