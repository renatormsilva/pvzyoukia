package manager
{
   import flash.display.DisplayObjectContainer;
   import zlib.event.ForeletEvent;
   import zmyth.load.UILoader;
   
   public class UILoaderManager
   {
      
      public static const ISNEW:int = 1;
      
      internal var isNew:Boolean = false;
      
      internal var container:DisplayObjectContainer = null;
      
      internal var uiloader:UILoader = null;
      
      internal var urls:Array = [];
      
      internal var loadnames:Array = [];
      
      internal var urlhead:String = "";
      
      public function UILoaderManager()
      {
         super();
      }
      
      public function setIsNew(param1:Boolean) : void
      {
         this.isNew = param1;
      }
      
      public function start(param1:DisplayObjectContainer, param2:XML, param3:String = "") : void
      {
         if(param2 == null)
         {
            throw new Error("配置文件无法找到!");
         }
         this.urlhead = param3;
         this.readXml(param2);
         this.container = param1;
         this.load();
      }
      
      public function startOrg(param1:DisplayObjectContainer, param2:Array, param3:Array) : void
      {
         this.urls = param2;
         this.loadnames = param3;
         this.container = param1;
         this.load();
      }
      
      private function readXml(param1:XML) : void
      {
         var _loc2_:String = null;
         this.urls = new Array();
         this.loadnames = new Array();
         if(this.isNew)
         {
            for(_loc2_ in param1.ui.item)
            {
               if(param1.ui.item[_loc2_].@isnew == ISNEW)
               {
                  this.urls.push(this.urlhead + param1.ui.item[_loc2_].@type + "/" + param1.ui.item[_loc2_].@name + param1.ui.item[_loc2_].@version + ".swf");
                  this.loadnames.push(param1.ui.item[_loc2_]);
               }
            }
         }
         else
         {
            for(_loc2_ in param1.ui.item)
            {
               this.urls.push(this.urlhead + param1.ui.item[_loc2_].@type + "/" + param1.ui.item[_loc2_].@name + param1.ui.item[_loc2_].@version + ".swf");
               this.loadnames.push(param1.ui.item[_loc2_]);
            }
         }
      }
      
      private function load() : void
      {
         if(this.urls == null || this.urls.length < 1)
         {
            this.loadover();
            return;
         }
         this.uiloader = new UILoader(this.container,this.urls[0],true,false,this.loadnames[0]);
         this.uiloader.addEventListener(ForeletEvent.COMPLETE,this.onLoader);
         this.uiloader.doLoad();
      }
      
      private function onLoader(param1:ForeletEvent) : void
      {
         this.urls.shift();
         this.loadnames.shift();
         this.uiloader.removeEventListener(ForeletEvent.COMPLETE,this.onLoader);
         this.load();
      }
      
      private function loadover() : void
      {
      }
   }
}

