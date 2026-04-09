package com.net.http
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class URLConnection
   {
      
      private var request:URLRequest = null;
      
      private var loader:URLLoader = null;
      
      private var backFun:Function = null;
      
      private var type:int = -1;
      
      public var isTrace:Boolean = false;
      
      public function URLConnection(param1:String, param2:int, param3:Function)
      {
         super();
         this.backFun = param3;
         this.type = param2;
         this.loader = new URLLoader();
         this.request = new URLRequest(param1);
         this.loader.load(this.request);
         this.loader.addEventListener(Event.COMPLETE,this.onLoader);
      }
      
      private function onLoader(param1:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onLoader);
         this.backFun(this.type,this.loader.data);
         if(this.isTrace)
         {
         }
         this.loader.close();
         this.loader = null;
      }
   }
}

