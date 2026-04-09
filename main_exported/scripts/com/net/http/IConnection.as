package com.net.http
{
   public interface IConnection
   {
      
      function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void;
      
      function onResult(param1:int, param2:Object) : void;
      
      function onStatus(param1:int, param2:Object) : void;
   }
}

