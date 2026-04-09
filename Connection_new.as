package com.net.http
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   /**
    * Replacement for the original Connection class that used NetConnection (AMF Flash Remoting).
    * NetConnection is not supported by Ruffle. This version uses URLLoader (HTTP POST) instead,
    * which Ruffle supports natively. The AMF0 binary protocol is preserved so the server
    * can still parse the method name and return the correct cached response.
    *
    * The public API is identical to the original — all call/callO/callOO/callOOO/callOOOO
    * methods work the same way and fire onResult(type, result) or onStatus(type, err).
    */
   public class Connection
   {
      public var isTrace:Boolean = false;

      private var _conType:int = 0;
      private var _onResult:Function = null;
      private var _onStatus:Function = null;
      private var _url:String;
      private var _loader:URLLoader = null;

      // ── Constructor ──────────────────────────────────────────────────────────
      public function Connection(url:String, onResultFn:Function, onStatusFn:Function)
      {
         super();
         _url      = url;
         _onResult = onResultFn;
         _onStatus = onStatusFn;
      }

      // ── Public call variants (same signatures as original) ───────────────────
      public function call(method:String, type:int, ... rest) : void
      {
         _conType = type;
         _post(method, rest as Array);
      }

      public function callO(method:String, type:int, a:Object) : void
      {
         _conType = type;
         _post(method, [a]);
      }

      public function callOO(method:String, type:int, a:Object, b:Object) : void
      {
         _conType = type;
         _post(method, [a, b]);
      }

      public function callOOO(method:String, type:int, a:Object, b:Object, c:Object) : void
      {
         _conType = type;
         _post(method, [a, b, c]);
      }

      public function callOOOO(method:String, type:int, a:Object, b:Object, c:Object, d:Object) : void
      {
         _conType = type;
         _post(method, [a, b, c, d]);
      }

      // ── Callback stubs (kept for interface compatibility) ────────────────────
      public function onResult(result:Object) : void { }
      public function onStatus(status:Object) : void { }
      public function statusHandler(e:*) : void { }

      // ── Internal: build AMF0 envelope and POST via URLLoader ─────────────────
      private function _post(method:String, args:Array) : void
      {
         var body:ByteArray = _buildEnvelope(method, args);

         var req:URLRequest = new URLRequest(_url);
         req.method      = URLRequestMethod.POST;
         req.data        = body;
         req.contentType = "application/x-amf";

         _loader = new URLLoader();
         _loader.dataFormat = URLLoaderDataFormat.BINARY;
         _loader.addEventListener(Event.COMPLETE,         _onComplete);
         _loader.addEventListener(IOErrorEvent.IO_ERROR,  _onError);
         _loader.load(req);
      }

      private function _onComplete(e:Event) : void
      {
         _loader.removeEventListener(Event.COMPLETE,        _onComplete);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR, _onError);

         var data:ByteArray = _loader.data as ByteArray;
         _loader = null;

         var result:Object = _parseResponse(data);
         if (_onResult != null) _onResult(_conType, result);
      }

      private function _onError(e:IOErrorEvent) : void
      {
         _loader.removeEventListener(Event.COMPLETE,        _onComplete);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
         _loader = null;

         if (_onStatus != null)
            _onStatus(_conType, {level:"error", code:"NetConnection.Call.Failed", description:e.text});
      }

      // ── AMF0 serialiser ──────────────────────────────────────────────────────
      /**
       * Builds a minimal AMF0 request envelope:
       *   version (2) + headers_count (2) + messages_count (2)
       *   message: target-string + response-uri + length(-1) + body
       * Body is a strict array containing all call arguments.
       */
      private function _buildEnvelope(method:String, args:Array) : ByteArray
      {
         var buf:ByteArray = new ByteArray();
         buf.endian = Endian.BIG_ENDIAN;

         buf.writeShort(0);          // AMF0 version
         buf.writeShort(0);          // headers count
         buf.writeShort(1);          // messages count

         // target string (method name)
         var mBytes:ByteArray = new ByteArray();
         mBytes.writeUTFBytes(method);
         buf.writeShort(mBytes.length);
         buf.writeBytes(mBytes);

         // response URI  ("/1")
         buf.writeShort(2);
         buf.writeUTFBytes("/1");

         // message body length (unknown = -1 / 0xFFFFFFFF)
         buf.writeInt(-1);

         // body: strict array wrapping all args
         buf.writeByte(0x0A);             // AMF0 type: strict array
         buf.writeInt(args.length);
         for (var i:int = 0; i < args.length; i++) _writeValue(buf, args[i]);

         buf.position = 0;
         return buf;
      }

      /** Recursive AMF0 value writer. Handles: null/undefined, Boolean, Number/int/uint, String, Array, Object. */
      private function _writeValue(buf:ByteArray, val:*) : void
      {
         if (val === null || val === undefined)
         {
            buf.writeByte(0x05);  // null
            return;
         }
         if (val is Boolean)
         {
            buf.writeByte(0x01);
            buf.writeByte(val ? 1 : 0);
            return;
         }
         if (val is Number || val is int || val is uint)
         {
            buf.writeByte(0x00);          // number
            buf.writeDouble(Number(val));
            return;
         }
         if (val is String)
         {
            var s:String = val as String;
            var sBytes:ByteArray = new ByteArray();
            sBytes.writeUTFBytes(s);
            if (sBytes.length > 65535)
            {
               buf.writeByte(0x0C);           // long-string
               buf.writeInt(sBytes.length);
            }
            else
            {
               buf.writeByte(0x02);           // string
               buf.writeShort(sBytes.length);
            }
            buf.writeBytes(sBytes);
            return;
         }
         if (val is Array)
         {
            var arr:Array = val as Array;
            buf.writeByte(0x0A);          // strict array
            buf.writeInt(arr.length);
            for (var j:int = 0; j < arr.length; j++) _writeValue(buf, arr[j]);
            return;
         }
         // Generic object (AMF0 anonymous object)
         buf.writeByte(0x03);
         for (var key:String in val)
         {
            var kBytes:ByteArray = new ByteArray();
            kBytes.writeUTFBytes(key);
            buf.writeShort(kBytes.length);
            buf.writeBytes(kBytes);
            _writeValue(buf, val[key]);
         }
         buf.writeShort(0);    // end-of-object marker
         buf.writeByte(0x09);
      }

      // ── AMF0 response parser ─────────────────────────────────────────────────
      /**
       * Parses an AMF0 response envelope and returns the payload value.
       * Handles: number, boolean, string, null, object, ECMA-array, strict-array, date, long-string.
       */
      private function _parseResponse(data:ByteArray) : Object
      {
         if (data == null || data.length < 6) return null;
         data.endian = Endian.BIG_ENDIAN;
         data.position = 0;

         data.position += 2;  // skip version

         // skip headers
         var hCount:int = data.readShort();
         for (var h:int = 0; h < hCount; h++)
         {
            var hNameLen:int = data.readShort();
            data.position += hNameLen + 1;      // name + must-understand byte
            var hValLen:int = data.readInt();
            if (hValLen >= 0) data.position += hValLen;
            else _readValue(data);               // length=-1 → read AMF value
         }

         var mCount:int = data.readShort();
         if (mCount == 0 || data.bytesAvailable < 4) return null;

         // skip target URI  (e.g. "/1/onResult")
         var tLen:int = data.readShort();
         data.position += tLen;

         // skip response URI
         var rLen:int = data.readShort();
         data.position += rLen;

         data.readInt();   // message body length (ignore)

         return _readValue(data);
      }

      private function _readValue(data:ByteArray) : *
      {
         if (data.bytesAvailable < 1) return null;
         var type:int = data.readUnsignedByte();

         switch (type)
         {
            case 0x00:  // Number (IEEE 754 double)
               return data.readDouble();

            case 0x01:  // Boolean
               return (data.readUnsignedByte() != 0);

            case 0x02:  // String
               return data.readUTFBytes(data.readUnsignedShort());

            case 0x03:  // Anonymous object
            {
               var obj:Object = {};
               while (data.bytesAvailable > 2)
               {
                  var kLen:int = data.readUnsignedShort();
                  if (kLen == 0) { data.readUnsignedByte(); break; } // end 0x09
                  var k:String = data.readUTFBytes(kLen);
                  obj[k] = _readValue(data);
               }
               return obj;
            }

            case 0x05:  // Null
            case 0x06:  // Undefined
               return null;

            case 0x07:  // Reference — simplified (return null; very rare)
               data.readUnsignedShort();
               return null;

            case 0x08:  // ECMA Array (associative)
            {
               data.readUnsignedInt();   // count (informational)
               var ecma:Object = {};
               while (data.bytesAvailable > 2)
               {
                  var ekLen:int = data.readUnsignedShort();
                  if (ekLen == 0) { data.readUnsignedByte(); break; }
                  var ek:String = data.readUTFBytes(ekLen);
                  ecma[ek] = _readValue(data);
               }
               return ecma;
            }

            case 0x0A:  // Strict Array
            {
               var aLen:int = data.readInt();
               var sa:Array = [];
               for (var i:int = 0; i < aLen; i++) sa.push(_readValue(data));
               return sa;
            }

            case 0x0B:  // Date
            {
               var d:Number = data.readDouble();
               data.readShort();  // timezone offset (unused)
               return d;
            }

            case 0x0C:  // Long String
               return data.readUTFBytes(data.readInt());

            default:
               return null;
         }
      }
   }
}
