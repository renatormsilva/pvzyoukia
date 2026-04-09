package pvz.copy.models
{
   import core.interfaces.IVo;
   
   public class CopyInfoVo implements IVo
   {
      
      private var _copyId:int;
      
      private var _status:int;
      
      private var _startTime:Number;
      
      private var _endTime:Number;
      
      private var _challgetimes:int;
      
      private var _descript:String;
      
      private var _copyname:String;
      
      private var _nowtime:Number;
      
      public function CopyInfoVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._copyId = param1.id;
         this._challgetimes = param1.count;
         this._status = param1.state;
         this._endTime = param1.et;
         this._startTime = param1.st;
         this._descript = param1.ds;
         this._copyname = param1.copy_name;
         this._nowtime = param1.now;
      }
      
      public function getCopyName() : String
      {
         return this._copyname;
      }
      
      public function get copyId() : int
      {
         return this._copyId;
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function get descript() : String
      {
         return this._descript;
      }
      
      public function get sTime() : Number
      {
         return this._startTime;
      }
      
      public function get nowTime() : Number
      {
         return this._nowtime;
      }
      
      public function get eTime() : int
      {
         return this._endTime;
      }
      
      public function get challageTimes() : int
      {
         return this._challgetimes;
      }
   }
}

