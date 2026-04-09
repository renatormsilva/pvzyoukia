package pvz.serverbattle.qualifying
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.serverbattle.SeverBattleReadyWindow;
   import pvz.serverbattle.fport.SignUpFPort;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import zlib.utils.DomainAccess;
   
   public class SignUpWindow extends BaseWindow
   {
      
      private var _window:MovieClip = null;
      
      private var _fport:SignUpFPort;
      
      private var _limitLevel:int;
      
      private var _readyWindow:SeverBattleReadyWindow;
      
      private var hour:DisplayObject;
      
      private var mintes:DisplayObject;
      
      private var second:DisplayObject;
      
      private var con1:DisplayObject;
      
      private var con2:DisplayObject;
      
      private var _time:int;
      
      private var _timer:Timer;
      
      public function SignUpWindow()
      {
         super(UINameConst.UI_SIGNUI_WINDOW);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("signUpWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         this.setLoction();
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.initData();
      }
      
      private function initData() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport = new SignUpFPort(this);
         this._fport.requestSever(SignUpFPort.RULE_DESCRIPTTION);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function show() : void
      {
         var onClick:Function = null;
         onClick = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window["close_btn"].removeEventListener(MouseEvent.CLICK,onClick);
            hide();
         };
         this._window.visible = true;
         onShowEffect(this._window);
         this._window["close_btn"].addEventListener(MouseEvent.CLICK,onClick);
      }
      
      private function onApplyHandler(param1:MouseEvent) : void
      {
         var callback:Function;
         var e:MouseEvent = param1;
         this._window["singup_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onApplyHandler);
         if(PlantsVsZombies.playerManager.getPlayer().getGrade() < this._limitLevel)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle007",this._limitLevel));
            return;
         }
         if(this._readyWindow == null)
         {
            callback = function():void
            {
               _readyWindow = new SeverBattleReadyWindow();
            };
            onHiddenEffect(this._window,callback);
         }
      }
      
      private function showTime(param1:int) : void
      {
         FuncKit.clearAllChildrens(this._window["time_node"]);
         this.hour = StringMovieClip.getStringImage(this.getTimeString(Math.floor(param1 / 3600)),"Server");
         this.mintes = StringMovieClip.getStringImage(this.getTimeString(Math.floor(param1 % 3600 / 60)),"Server");
         this.second = StringMovieClip.getStringImage(this.getTimeString(param1 % 3600 % 60),"Server");
         this.con1 = StringMovieClip.getStringImage("w","Score");
         this.con2 = StringMovieClip.getStringImage("w","Score");
         this._window["time_node"].addChild(this.hour);
         this.hour.x = -this.hour.width;
         this._window["time_node"].addChild(this.con1);
         this.con1.x = 6;
         this.con1.y = 4;
         this._window["time_node"].addChild(this.mintes);
         this.mintes.x = 20;
         this._window["time_node"].addChild(this.con2);
         this.con2.x = 56;
         this.con2.y = 4;
         this._window["time_node"].addChild(this.second);
         this.second.x = 70;
      }
      
      private function showTimeDisplayObject(param1:TimerEvent) : void
      {
         --this._time;
         if(this._time == 0)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.showTimeDisplayObject);
            return;
         }
         this.showTime(this._time);
      }
      
      private function getTimeString(param1:int) : String
      {
         return param1 < 10 ? "0" + param1 : String(param1);
      }
      
      private function hide() : void
      {
         onHiddenEffect(this._window,this.destory);
      }
      
      private function destory() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.showTimeDisplayObject);
         }
         PlantsVsZombies._node.removeChild(this._window);
         this._window["singup_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onApplyHandler);
         this._fport = null;
      }
      
      public function initUI(param1:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this._limitLevel = param1.registrationLowestLevel;
         this._window["level_txt"].text = param1.registrationLowestLevel;
         this._window["start_time_txt"].text = param1.qualifyingStartTime;
         this._time = param1.registrationTimeRemaining;
         this.showTime(this._time);
         if(this._time > 0)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.showTimeDisplayObject);
            this._timer.start();
         }
         this.show();
         if(param1.isSignUp == 1)
         {
            this._window["singup_btn"].gotoAndStop(2);
            return;
         }
         this._window["singup_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onApplyHandler);
      }
   }
}

