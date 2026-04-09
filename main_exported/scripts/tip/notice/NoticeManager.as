package tip.notice
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import zmyth.res.IDestroy;
   
   public class NoticeManager implements IDestroy
   {
      
      private static var m_instance:NoticeManager;
      
      public static const DYNAMIC_MESSAGES_MAIN:String = "DYNAMIC_MESSAGES_MAIN";
      
      public static const DYNAMIC_MESSAGES_SERVERBATTLE:String = "DYNAMIC_MESSAGES_SERVERBATTLE";
      
      private var _noticeArr:Array = null;
      
      private var _panel:NotiecPanel = null;
      
      private var _index:int = 0;
      
      private var _parent:DisplayObjectContainer;
      
      private var _x:int = 0;
      
      private var _y:int = 90;
      
      private var _timer:Timer = null;
      
      private var _alter:int = 40;
      
      private var _time:int = 60;
      
      public function NoticeManager()
      {
         super();
         this._panel = new NotiecPanel();
         this._parent = PlantsVsZombies._node;
         this._parent.addChild(this._panel);
         this._panel.visible = false;
      }
      
      public static function get getInstance() : NoticeManager
      {
         if(m_instance == null)
         {
            m_instance = new NoticeManager();
         }
         return m_instance;
      }
      
      public function initNotice(param1:*, param2:int = 40, param3:int = 60) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1 is String)
         {
            _loc5_ = PlantsVsZombies.getRPCUrl();
            this.netConnectionSend(_loc5_,AMFConnectionConstants.RPC_PLAYERS_DYNAMIC_MESSAGES,0);
         }
         else if(param1 is Array)
         {
            this.readNotice(param1);
         }
         this._time = param3;
         this._alter = param2;
      }
      
      private function readNotice(param1:Array) : void
      {
         var _loc4_:NoticeText = null;
         this._noticeArr = [];
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new NoticeText(param1[_loc3_]);
            this._noticeArr.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = param2 as Array;
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return;
         }
         this.readNotice(_loc3_);
         this.start();
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         }
      }
      
      public function start() : void
      {
         if(this._noticeArr == null || this._noticeArr.length < 1)
         {
            this._panel.visible = false;
            return;
         }
         if(this._timer == null)
         {
            this._timer = new Timer(this._time,this._alter);
            this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onComp);
         }
         if(this._timer.running)
         {
            return;
         }
         if(this._index == this._noticeArr.length)
         {
            this._index = 0;
         }
         this._panel.setText(this._noticeArr[this._index]);
         this.resetPanel();
         this._parent.setChildIndex(this._panel,this._parent.numChildren - 1);
         this._timer.start();
      }
      
      public function stop() : void
      {
         this._panel.visible = false;
         if(this._timer != null)
         {
            this._timer.stop();
         }
      }
      
      private function resetPanel() : void
      {
         this._panel.x = this._x;
         this._panel.y = this._y;
         this._panel.alpha = 1;
         this._panel.visible = true;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         --this._panel.y;
         if(this._timer.currentCount > 25)
         {
            this._panel.alpha -= 0.03;
         }
      }
      
      private function onComp(param1:TimerEvent) : void
      {
         this._panel.visible = false;
         this._timer.reset();
         ++this._index;
         this.start();
      }
      
      public function destroy() : void
      {
         if(this._timer != null)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onComp);
            this._timer = null;
         }
         if(this._panel != null && this._panel.parent != null)
         {
            this._panel.parent.removeChild(this._panel);
         }
         this._noticeArr = null;
         if(this._panel != null)
         {
            this._panel.clear();
         }
         this._parent = null;
      }
   }
}

