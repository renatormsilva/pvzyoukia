package com.net.http
{
   import flash.events.NetStatusEvent;
   import flash.net.NetConnection;
   import flash.net.Responder;
   
   public class Connection
   {
      
      public var isTrace:Boolean = false;
      
      private var _conType:int = 0;
      
      private var _onResult:Function = null;
      
      private var _onStatus:Function = null;
      
      private var con:NetConnection = null;
      
      public function Connection(param1:String, param2:Function, param3:Function)
      {
         super();
         this.con = new NetConnection();
         this.con.addEventListener(NetStatusEvent.NET_STATUS,this.statusHandler);
         this.con.connect(param1);
         this._onResult = param2;
         this._onStatus = param3;
      }
      
      public function call(param1:String, param2:int, ... rest) : void
      {
         this._conType = param2;
         var _loc4_:int = int(rest.length);
         switch(_loc4_)
         {
            case 0:
               this.con.call(param1,new Responder(this.onResult,this.onStatus),rest);
               break;
            case 1:
               this.con.call(param1,new Responder(this.onResult,this.onStatus),rest[0]);
               break;
            case 2:
               this.con.call(param1,new Responder(this.onResult,this.onStatus),rest[0],rest[1]);
               break;
            case 3:
               this.con.call(param1,new Responder(this.onResult,this.onStatus),rest[0],rest[1],rest[2]);
               break;
            case 4:
               this.con.call(param1,new Responder(this.onResult,this.onStatus),rest[0],rest[1],rest[2],rest[3]);
         }
      }
      
      public function callO(param1:String, param2:int, param3:Object) : void
      {
         this._conType = param2;
         this.con.call(param1,new Responder(this.onResult,this.onStatus),param3);
      }
      
      public function callOO(param1:String, param2:int, param3:Object, param4:Object) : void
      {
         this._conType = param2;
         this.con.call(param1,new Responder(this.onResult,this.onStatus),param3,param4);
      }
      
      public function callOOO(param1:String, param2:int, param3:Object, param4:Object, param5:Object) : void
      {
         this._conType = param2;
         this.con.call(param1,new Responder(this.onResult,this.onStatus),param3,param4,param5);
      }
      
      public function callOOOO(param1:String, param2:int, param3:Object, param4:Object, param5:Object, param6:Object) : void
      {
         this._conType = param2;
         this.con.call(param1,new Responder(this.onResult,this.onStatus),param3,param4,param5,param6);
      }
      
      public function onResult(param1:Object) : void
      {
         if(this.isTrace)
         {
            this.showRe(param1);
         }
         if(this._onResult != null)
         {
            this._onResult(this._conType,param1);
         }
         this.close();
      }
      
      public function onStatus(param1:Object) : void
      {
         if(this.isTrace)
         {
            this.showRe(param1);
         }
         if(this._onStatus != null)
         {
            this._onStatus(this._conType,param1);
         }
         this.close();
      }
      
      public function statusHandler(param1:NetStatusEvent) : void
      {
      }
      
      private function close() : void
      {
         if(this.con == null)
         {
            return;
         }
         this.con.removeEventListener(NetStatusEvent.NET_STATUS,this.statusHandler);
         this.con.close();
         this.con = null;
      }
      
      private function showRe(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
         }
      }
   }
}

