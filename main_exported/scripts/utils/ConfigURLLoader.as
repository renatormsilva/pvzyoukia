package utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ConfigURLLoader extends EventDispatcher
   {
      
      public var loader:URLLoader;
      
      private var _xml:XML;
      
      private var loadedURL:Array;
      
      private var loadingURl:Array;
      
      public function ConfigURLLoader()
      {
         super();
      }
      
      public function load(param1:String) : void
      {
         var onComplete:Function = null;
         var url:String = param1;
         onComplete = function(param1:Event):void
         {
            _xml = new XML(loader.data);
            loader.removeEventListener(Event.COMPLETE,onComplete);
            loadOver();
         };
         var loadOver:Function = function():void
         {
            var _loc2_:int = 0;
            var _loc1_:int = 0;
            while(_loc2_ < loadingURl.length)
            {
               if(url == loadedURL[_loc2_])
               {
                  _loc1_ = _loc2_;
               }
               _loc2_++;
            }
            var _loc3_:String = loadedURL[0];
            loadingURl[0] = url;
            loadingURl[_loc1_] = _loc3_;
            loadingURl.shift();
            loadedURL.push(url);
            dispatchEvent(new ConfigLoadEvent(url,_xml));
            if(loadingURl.length < 1)
            {
               dispatchEvent(new Event("AllLoadOver"));
               loader = null;
            }
            else
            {
               loader = null;
               load(loadingURl[0]);
            }
         };
         if(this.checkLoadURL(url))
         {
            return;
         }
         if(!this.checkLoadingURL(url))
         {
            this.loadingURl.push(url);
         }
         if(this.loader != null)
         {
            return;
         }
         this.loader = new URLLoader(new URLRequest(url));
         this.loader.addEventListener(Event.COMPLETE,onComplete);
      }
      
      private function checkLoadURL(param1:String) : Boolean
      {
         if(this.loadedURL == null)
         {
            this.loadedURL = new Array();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.loadedURL.length)
         {
            if(this.loadedURL[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function checkLoadingURL(param1:String) : Boolean
      {
         if(this.loadingURl == null)
         {
            this.loadingURl = new Array();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.loadingURl.length)
         {
            if(this.loadingURl[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

