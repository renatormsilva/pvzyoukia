package com.net.http
{
   public interface IURLConnection
   {
      
      function urlloaderSend(param1:String, param2:int) : void;
      
      function onURLResult(param1:int, param2:Object) : void;
   }
}

