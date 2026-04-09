package pvz.vip
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.PlayerUpInfo;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.vip.rpc.Vip_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ChallengePropWindow;
   import windows.PlayerUpGradeWindow;
   import zlib.utils.DomainAccess;
   
   public class AutoGainWindow extends BaseWindow
   {
      
      private static var m_insCreating:Boolean;
      
      private static var m_instance:AutoGainWindow;
      
      private static const START:int = 1;
      
      private static const KEEP:int = 2;
      
      private static const STOP:int = 3;
      
      private static const ADDED_COIN:Number = 1.96;
      
      private static const ADDED_EXP:int = 5;
      
      private static const alter:int = 60000;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _panel:Sprite;
      
      private var _text:TextField;
      
      private var addedBackTime:int = 0;
      
      private var timer:Timer;
      
      private var exp:int = 0;
      
      private var coin:int = 0;
      
      private var begin_time:int = 0;
      
      private var currentTime:int = 0;
      
      private var lastTime:int = 0;
      
      private var viprpc:Vip_rpc;
      
      private var infos:Array = null;
      
      private var user_exp:int;
      
      private var user_getMoney:int;
      
      private var index:int = -1;
      
      private var dayMaxExp:int;
      
      private var playerGetedExp:int;
      
      private var autoRegister:AutoRegister;
      
      public var _func:Function;
      
      private var contruing:Boolean = false;
      
      public function AutoGainWindow()
      {
         super();
      }
      
      public static function get getAutoGainInstance() : AutoGainWindow
      {
         if(m_instance == null)
         {
            m_insCreating = true;
            m_instance = new AutoGainWindow();
            m_insCreating = false;
         }
         return m_instance;
      }
      
      public function initUI() : void
      {
         var _loc1_:Class = null;
         var _loc2_:Class = null;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) == null && !this.playerManager.getPlayer().getVipAutoGain())
         {
            _loc1_ = DomainAccess.getClass("vip.autoNotGain");
            this._panel = new _loc1_() as Sprite;
            showBG(PlantsVsZombies._node as DisplayObjectContainer);
            PlantsVsZombies._node.addChild(this._panel);
            onShowEffect(this._panel);
            this.initNonVipPanel();
         }
         else
         {
            _loc2_ = DomainAccess.getClass("vip.autoGain");
            this._panel = new _loc2_() as Sprite;
            this._panel.visible = false;
            this._panel.name = "autoGain";
            showBG(PlantsVsZombies._node as DisplayObjectContainer,1);
            PlantsVsZombies._node.addChild(this._panel);
            onShowEffect(this._panel);
            PlantsVsZombies._node.setChildIndex(PlantsVsZombies._node["back"],PlantsVsZombies._node.numChildren - 1);
            if(PlantsVsZombies._node["player_other_back"].visible)
            {
               PlantsVsZombies._node.setChildIndex(PlantsVsZombies._node["player_other_back"],PlantsVsZombies._node.numChildren - 1);
            }
            this.initVipPanel();
            this.setArrasMc(3);
            this._panel["gain"].addEventListener(MouseEvent.CLICK,this.gotoGainHandle);
         }
         this.setLoction();
      }
      
      private function setArrasMc(param1:int) : void
      {
         if(this._panel["arrasMc"].hasEventListener(Event.ENTER_FRAME))
         {
            this._panel["arrasMc"].stop();
            this._panel["arrasMc"].removeEventListener(Event.ENTER_FRAME,this.onArrasEnter);
         }
         if(param1 == 1)
         {
            this._panel["arrasMc"].visible = true;
            this._panel["arrasMc"].play();
            this._panel["arrasMc"].addEventListener(Event.ENTER_FRAME,this.onArrasEnter);
         }
         else if(param1 == 2)
         {
            this._panel["arrasMc"].visible = true;
            this._panel["arrasMc"].gotoAndStop(17);
         }
         else if(param1 == 3)
         {
            this._panel["arrasMc"].visible = false;
            this._panel["arrasMc"].stop();
         }
      }
      
      private function onArrasEnter(param1:Event) : void
      {
         if(this._panel["arrasMc"].currentFrame == this._panel["arrasMc"].totalFrames - 1)
         {
            this._panel["arrasMc"].gotoAndPlay(1);
         }
      }
      
      private function initNonVipPanel() : void
      {
         var openVip:Function = null;
         var close:Function = null;
         openVip = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            new ChallengePropWindow(ChallengePropWindow.TYPE_VIP,null,true);
            _panel["openVip"].removeEventListener(MouseEvent.CLICK,openVip);
            _panel["close"].removeEventListener(MouseEvent.CLICK,close);
            dispose();
         };
         close = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _panel["openVip"].removeEventListener(MouseEvent.CLICK,openVip);
            _panel["close"].removeEventListener(MouseEvent.CLICK,close);
            dispose();
         };
         this._panel["openVip"].addEventListener(MouseEvent.CLICK,openVip);
         this._panel["close"].addEventListener(MouseEvent.CLICK,close);
      }
      
      private function setLoction() : void
      {
         this._panel.x = PlantsVsZombies.WIDTH - this._panel.width >> 1;
         this._panel.y = PlantsVsZombies.HEIGHT - this._panel.height >> 1;
      }
      
      private function initVipPanel() : void
      {
         this.creatInitConnection();
         this.timer = new Timer(alter);
         this.timer.addEventListener(TimerEvent.TIMER,this.onCountTimer);
      }
      
      private function creatInitConnection() : void
      {
         if(!this.playerManager.getPlayer().getVipAutoGain())
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_VIP_AUTO_GAIN_START,START);
         }
         else
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_VIP_AUTO_GAIN_ING,KEEP);
         }
      }
      
      private function gotoGainHandle(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_VIP_AUTO_GAIN_STOP,STOP);
      }
      
      private function updateContext() : void
      {
         FuncKit.clearAllChildrens(this._panel["exp"]);
         FuncKit.clearAllChildrens(this._panel["coin"]);
         FuncKit.clearAllChildrens(this._panel["time"]);
         FuncKit.clearAllChildrens(this._panel["num"]);
         this._panel["exp"].addChild(FuncKit.getNumEffect(this.exp.toString()));
         this._panel["coin"].addChild(FuncKit.getNumEffect(this.coin.toString()));
         this._panel["time"].addChild(FuncKit.getNumEffect(this.getCurrentTime(this.currentTime)));
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.dayMaxExp + "");
         this._panel["num"].addChild(_loc1_);
         _loc1_.x = -_loc1_.width / 2;
      }
      
      private function getCurrentTime(param1:int) : String
      {
         var _loc2_:int = int(param1 / 60 / 60);
         var _loc3_:int = param1 / 60 % 60;
         return (_loc2_ < 10 ? "0" + _loc2_ : _loc2_) + "w" + (_loc3_ < 10 ? "0" + _loc3_ : _loc3_);
      }
      
      private function onCountTimer(param1:TimerEvent) : void
      {
         this.currentTime = (getTimer() - this.begin_time) / 1000 + this.addedBackTime;
         if(this.playerGetedExp < this.playerManager.getPlayer().getTodayMaxExp())
         {
            this.exp += ADDED_EXP;
            this.playerGetedExp += ADDED_EXP;
            if(this.playerGetedExp >= this.playerManager.getPlayer().getTodayMaxExp())
            {
               this.contruing = true;
               this.exp = this.dayMaxExp;
            }
         }
         else if(this.contruing)
         {
            this.exp = this.dayMaxExp;
         }
         else
         {
            this.exp = 0;
         }
         this.coin = this.getMinMoney(this.currentTime,this.playerManager.getPlayer().getGrade());
         this.updateContext();
         if(this.currentTime >= this.lastTime)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onCountTimer);
         }
      }
      
      private function getMinMoney(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = param1 / 60 % 60;
         if(this.playerManager.getPlayer().getGrade() <= 40)
         {
            _loc3_ = (1600 * (param2 - 5) + 8521) * (_loc4_ / 1440);
         }
         else
         {
            _loc3_ = (166 * (param2 - 2) * (param2 - 2) - 5985 * (param2 - 2) + 59133) * (_loc4_ / 1440);
         }
         return _loc3_;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == START || param3 == KEEP || param3 == STOP)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.reset();
         if(param1 == START)
         {
            this.setArrasMc(1);
            this.playerManager.getPlayer().setVipAutoGain(1);
            this._panel.visible = true;
            this.lastTime = param2.etime;
            this.playerGetedExp = param2.day_get_exp;
            this.dayMaxExp = int(param2.day_max_exp);
            this.begin_time = getTimer();
            this.updateContext();
            this.timer.start();
            PlantsVsZombies._node.stage.addEventListener(Event.DEACTIVATE,this.onDeactivateHandle);
         }
         else if(param1 == KEEP)
         {
            this.setArrasMc(1);
            this._panel.visible = true;
            this.lastTime = param2.auto_etime;
            this.playerGetedExp = param2.day_get_exp;
            this.dayMaxExp = int(param2.day_max_exp);
            this.addedBackTime = param2.auto_sec;
            this.currentTime = this.addedBackTime;
            this.exp = param2.user_exp;
            this.coin = param2.money;
            this.updateContext();
            this.begin_time = getTimer();
            this.timer.start();
            PlantsVsZombies._node.stage.addEventListener(Event.DEACTIVATE,this.onDeactivateHandle);
         }
         else if(param1 == STOP)
         {
            this.setArrasMc(2);
            this.playerManager.getPlayer().setVipAutoGain(0);
            this.viprpc = new Vip_rpc();
            this.infos = this.viprpc.getGradeUpInfos(param2);
            this.user_exp = this.viprpc.getEXP(param2);
            this.user_getMoney = this.viprpc.getMoney(param2);
            this.viprpc.upDateExp(this.user_exp,this.playerManager.getPlayer());
            PlantsVsZombies.changeMoneyOrExp(this.user_getMoney);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("vip014",this.user_getMoney,this.user_exp),this.showPlayerUpInfo);
            this.dispose();
         }
      }
      
      private function showPlayerUpInfo() : void
      {
         var _loc1_:PlayerUpGradeWindow = null;
         if(this.infos == null || this.infos.length < 1)
         {
            PlantsVsZombies.setUserInfos();
            return;
         }
         ++this.index;
         if(this.index >= this.infos.length)
         {
            return;
         }
         (this.infos[this.index] as PlayerUpInfo).upDatePlayer(this.playerManager.getPlayer());
         (this.infos[this.index] as PlayerUpInfo).upDataExp(this.playerManager.getPlayer());
         PlantsVsZombies.setUserInfos();
         if(this.index == this.infos.length - 1)
         {
            _loc1_ = new PlayerUpGradeWindow(null);
         }
         else
         {
            _loc1_ = new PlayerUpGradeWindow(this.showPlayerUpInfo);
         }
         _loc1_.show((this.infos[this.index] as PlayerUpInfo).getTools(),(this.infos[this.index] as PlayerUpInfo).getMoney());
      }
      
      private function onDeactivateHandle(param1:Event) : void
      {
         if(this.autoRegister == null)
         {
            this.autoRegister = new AutoRegister(this.comeBackFunc);
         }
      }
      
      private function comeBackFunc() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_USER_VIP_AUTO_GAIN_ING,KEEP);
         this.autoRegister = null;
      }
      
      private function reset() : void
      {
         this.coin = 0;
         this.exp = 0;
         this.currentTime = 0;
         this.begin_time = 0;
         this.lastTime = 0;
         this.addedBackTime = 0;
         this.user_exp = 0;
         this.user_getMoney = 0;
         this.index = -1;
         this.contruing = false;
         this.playerGetedExp = 0;
      }
      
      public function dispose() : void
      {
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()))
         {
            PlantsVsZombies._node.stage.removeEventListener(Event.DEACTIVATE,this.onDeactivateHandle);
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onCountTimer);
            this._panel["gain"].removeEventListener(MouseEvent.CLICK,this.gotoGainHandle);
            if(this._func != null)
            {
               this._func();
            }
         }
         super.removeBG();
         this._panel.visible = false;
         this._panel.parent.removeChild(this._panel);
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
   }
}

