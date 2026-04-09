package pvz.task
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Exp;
   import entity.GameMoney;
   import entity.PlayerUpInfo;
   import entity.Task;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import labels.TaskToolLabel;
   import manager.APLManager;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import pvz.task.rpc.Task_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.PlayerUpGradeWindow;
   import windows.PrizesWindow;
   import zlib.utils.DomainAccess;
   
   public class TaskWindow extends BaseWindow implements IConnection
   {
      
      private static const COMP:int = 2;
      
      private static const GET:int = 1;
      
      private static var JS_DUTY_CODE:String = "add_favorite";
      
      private static const UPDATE_COMP:int = 4;
      
      private static const UPDATE_GET:int = 3;
      
      private var upIndex:int = -1;
      
      private var playerUpInfos:Array = null;
      
      private var _task:Task = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _backFun:Function = null;
      
      private var _window:MovieClip = null;
      
      public function TaskWindow(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("taskWindow");
         this._window = new _loc2_();
         this._backFun = param1;
         this._window.visible = false;
         this._window["_bt_ok"].visible = false;
         this._window["_bt_get"].visible = false;
         this._window["_mc_notComp"].visible = false;
         this._window["_mc_comp"].gotoAndStop(1);
         this._window["_mc_comp"].visible = false;
         showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Task_rpc = null;
         if(param1 == COMP)
         {
            this._task.setUpGrades(param2.up_grade);
            this._task.setMsg(param2.msg);
            this._task.setExp(param2.exp);
            this.showTaskComp();
         }
         else if(param1 == GET)
         {
            this._window["_bt_get"].visible = false;
            PlantsVsZombies.showDataLoading(false);
            this.hidden(true);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("task002"));
            if(this._task.getDuty_code() == JS_DUTY_CODE)
            {
               this.showCollectionGameJs();
            }
         }
         else if(param1 == UPDATE_COMP)
         {
            _loc3_ = new Task_rpc();
            this._task = _loc3_.getTask(param2);
            PlantsVsZombies._task = this._task;
            PlantsVsZombies.showDataLoading(false);
            if(this._task.getStatus() == Task.STATUS_1)
            {
               this.hidden(true);
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("task003"));
               return;
            }
            this.show(this._task);
         }
         else if(param1 == UPDATE_GET)
         {
            _loc3_ = new Task_rpc();
            this._task = _loc3_.getTask(param2);
            if(this._task.getStatus() == Task.STATUS_3)
            {
               this._window["_mc_notComp"].visible = true;
            }
            else if(this._task.getStatus() == Task.STATUS_4)
            {
               this._window["_bt_ok"].visible = true;
            }
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      public function show(param1:Task) : void
      {
         this._window["task_txt_info"].visible = false;
         if(param1 == null)
         {
            return;
         }
         this._window["_bt_close"].visible = true;
         this._window["_bt_cancel"].visible = true;
         this.addBtEvent();
         this._task = param1;
         if(this._task.getStatus() == Task.STATUS_1)
         {
            removeBG();
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("task003"));
            return;
         }
         onShowEffect(this._window);
         removeBG();
         showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._window);
         this._window.visible = true;
         this.showTask();
         this.showTaskInfo();
      }
      
      private function showTaskInfo() : void
      {
         if(this._task.getChanllengeTimes() <= 0)
         {
            return;
         }
         this._window["task_txt_info"].text = LangManager.getInstance().getLanguage("window174");
         this._window["task_txt_info"].visible = true;
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.playerManager.getPlayer().getHunts() - this.playerManager.getPlayer().getNowHunts() + "c" + this._task.getChanllengeTimes());
         _loc1_.x = -_loc1_.width / 2;
         this._window["_pic_node_num"].addChild(_loc1_);
      }
      
      private function addBtEvent() : void
      {
         this._window["_bt_get"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function clear() : void
      {
         this.removeBtEvent();
      }
      
      private function clearAwards() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(this._window["_pic_node" + _loc1_].numChildren > 0)
            {
               FuncKit.clearAllChildrens(this._window["_pic_node" + _loc1_]);
            }
            this._window["_txt_name" + _loc1_].text = "";
            _loc1_++;
         }
      }
      
      private function clearCost() : void
      {
         if(this._window["_pic_node"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window["_pic_node"]);
         }
         if(this._window["_pic_node_num"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window["_pic_node_num"]);
         }
      }
      
      private function completeTask() : void
      {
         PlantsVsZombies.playFireworks(4);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_COMP,COMP);
      }
      
      private function getPrizes(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < (param1[_loc3_] as Tool).getNum())
            {
               _loc5_ = new Array(2);
               _loc5_[0] = "tool";
               _loc5_[1] = (param1[_loc3_] as Tool).getOrderId();
               _loc2_.push(_loc5_);
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getTask() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_GET,GET);
      }
      
      private function hidden(param1:Boolean) : void
      {
         if(param1)
         {
            removeBG();
         }
         this.clear();
         if(this._backFun != null)
         {
            this._backFun();
         }
         this._window["_mc_comp"].visible = false;
         this._window.visible = false;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_ok")
         {
            this._window["_bt_ok"].visible = false;
            this.completeTask();
         }
         else if(param1.currentTarget.name == "_bt_cancel" || param1.currentTarget.name == "_bt_close")
         {
            this.hidden(true);
         }
         else if(param1.currentTarget.name == "_bt_get")
         {
            this.getTask();
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
      }
      
      private function removeBtEvent() : void
      {
         this._window["_bt_get"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + 40;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 - 15;
      }
      
      private function showAward(param1:Object, param2:int) : void
      {
         var _loc3_:TaskToolLabel = new TaskToolLabel(param1,null,false,0);
         this._window["_pic_node" + param2].addChild(_loc3_);
         if(param1 is Tool)
         {
            this._window["_txt_name" + param2].text = param1.getName();
         }
         else if(param1 is Exp || param1 is GameMoney)
         {
            this._window["_txt_name" + param2].text = param1.getName();
         }
      }
      
      private function showAwards(param1:Array, param2:int) : void
      {
         var _loc3_:int = 0;
         this.clearAwards();
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               this.showAward(param1[_loc3_],_loc3_ + 1);
               _loc3_++;
            }
         }
         else
         {
            this.showMoney(param2);
         }
      }
      
      private function showCollectionGameJs() : void
      {
         JSManager.gotoJsTask();
      }
      
      private function showCompMc() : void
      {
         var onPlay:Function = null;
         onPlay = function(param1:Event):void
         {
            if(_window["_mc_comp"].currentFrame == _window["_mc_comp"].totalFrames)
            {
               _window["_mc_comp"].gotoAndStop(_window["_mc_comp"].totalFrames);
               _window["_mc_comp"].visible = false;
               _window["_mc_comp"].removeEventListener(Event.ENTER_FRAME,onPlay);
            }
         };
         this._window["_mc_comp"].visible = true;
         this._window["_mc_comp"].gotoAndPlay(1);
         this._window["_mc_comp"].addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      private function showCost() : void
      {
         var _loc5_:int = 0;
         this.clearCost();
         if(this._task.getCost() == null || this._task.getCost().length < 1)
         {
            return;
         }
         var _loc1_:Tool = this._task.getCost()[0];
         var _loc2_:TaskToolLabel = new TaskToolLabel(_loc1_,null,false,0,true);
         this._window["_pic_node"].addChild(_loc2_);
         var _loc3_:Tool = this.playerManager.getPlayer().getTool(_loc1_.getOrderId());
         if(_loc3_ != null)
         {
            _loc5_ = _loc3_.getNum();
         }
         else
         {
            _loc5_ = 0;
         }
         if(_loc5_ > _loc1_.getNum())
         {
            _loc5_ = _loc1_.getNum();
         }
         var _loc4_:DisplayObject = FuncKit.getNumEffect(_loc5_ + "c" + _loc1_.getNum());
         _loc4_.x = -_loc4_.width / 2;
         this._window["_pic_node_num"].addChild(_loc4_);
      }
      
      private function showMoney(param1:int) : void
      {
         var _loc2_:Tool = new Tool(ToolManager.RMB);
         _loc2_.setNum(param1);
         this.showAward(_loc2_,1);
      }
      
      private function updataLevelOver() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_INFO,UPDATE_COMP);
      }
      
      private function showPrizesOver() : void
      {
         if(this._task.getMsg() != "")
         {
            PlantsVsZombies.showSystemErrorInfo(this._task.getMsg());
         }
         else
         {
            this.playerManager.getPlayer().setTodayExp(this.playerManager.getPlayer().getTodayExp() + this._task.getExp());
            this.playerManager.getPlayer().setExp(this.playerManager.getPlayer().getExp() + this._task.getExp());
            if(this._task.getExp() > 0)
            {
               PlantsVsZombies.setUserInfos(false,true);
            }
            else
            {
               PlantsVsZombies.setUserInfos();
            }
         }
         if(this._task.getGameMoney() > 0)
         {
            PlantsVsZombies.changeMoneyOrExp(this._task.getGameMoney(),0,true,true);
         }
         PlantsVsZombies.upUserData();
         if(this._task.getDuty_code() !== "user_money100000")
         {
            PlantsVsZombies.showDataLoading(true);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_INFO,UPDATE_COMP);
         }
         else
         {
            this.hidden(true);
         }
      }
      
      private function getGradeUpInfos(param1:Array) : Array
      {
         var _loc4_:PlayerUpInfo = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new PlayerUpInfo(param1[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function showPlayerUpInfo() : void
      {
         var _loc2_:PlayerUpGradeWindow = null;
         ++this.upIndex;
         if(this.upIndex >= this.playerUpInfos.length)
         {
            return;
         }
         var _loc1_:PlayerUpInfo = this.playerUpInfos[this.upIndex] as PlayerUpInfo;
         _loc1_.upDatePlayer(this.playerManager.getPlayer());
         PlantsVsZombies.setUserInfos(false,true);
         if(this.upIndex == this.playerUpInfos.length - 1)
         {
            _loc2_ = new PlayerUpGradeWindow(this.dealBtnTurn);
         }
         else
         {
            _loc2_ = new PlayerUpGradeWindow(this.showPlayerUpInfo);
         }
         _loc2_.show(_loc1_.getTools(),_loc1_.getMoney());
      }
      
      private function dealBtnTurn() : void
      {
         this.updataLevelOver();
         if(MenuButtonManager.instance.checkBtnUpLimit("firstRecharge",this.playerManager.getPlayer().getGrade()) || MenuButtonManager.instance.checkBtnUpLimit("activity_btn",this.playerManager.getPlayer().getGrade()) || MenuButtonManager.instance.checkBtnUpLimit("signup_btn",this.playerManager.getPlayer().getGrade()))
         {
            PlantsVsZombies.firstpage.updateSignUpAndActivtyButtonEtcStaus();
            return;
         }
         MenuButtonManager.instance.updateAllButtonsWhenLevelUP(this.playerManager.getPlayer().getGrade(),null);
      }
      
      private function showTask() : void
      {
         this._window["_bt_ok"].visible = false;
         this._window["_bt_get"].visible = false;
         this._window["_mc_notComp"].visible = false;
         if(this._task.getStatus() == Task.STATUS_2)
         {
            this._window["_bt_get"].visible = true;
         }
         else if(this._task.getStatus() == Task.STATUS_3)
         {
            this._window["_mc_notComp"].visible = true;
         }
         else if(this._task.getStatus() == Task.STATUS_4)
         {
            this.showCompMc();
            this._window["_bt_ok"].visible = true;
         }
         this._window["_txt_task"].text = this._task.getInfo();
         this.showAwards(this._task.getAwards(),this._task.getMoney());
         this.showCost();
      }
      
      private function showUpGradeInfo() : void
      {
         this.upIndex = -1;
         this.playerUpInfos = this.getGradeUpInfos(this._task.getUpGrades());
         this.showPlayerUpInfo();
         PlantsVsZombies.upUserData();
      }
      
      private function showTaskComp() : void
      {
         var _loc1_:PrizesWindow = null;
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         if(this._task.getAwards() != null && this._task.getAwards().length > 0)
         {
            if(this._task.getAwards().length == 1 && !(this._task.getAwards()[0] is Tool))
            {
               if(this._task.getMsg() != "")
               {
                  PlantsVsZombies.showSystemErrorInfo(this._task.getMsg());
               }
               this.hidden(true);
               return;
            }
            this.hidden(true);
            if(this._task.getUpGrades())
            {
               if(this._task.getGameMoney() > 0)
               {
                  PlantsVsZombies.changeMoneyOrExp(this._task.getGameMoney(),0,true,true);
               }
               _loc1_ = new PrizesWindow(this.showUpGradeInfo,PlantsVsZombies._node as MovieClip);
            }
            else
            {
               _loc1_ = new PrizesWindow(this.showPrizesOver,PlantsVsZombies._node as MovieClip);
            }
            _loc1_.show(this._task.getAwards());
            this.updateTool(this._task.getAwards());
         }
         else
         {
            this._window["_bt_close"].visible = false;
            this._window["_bt_cancel"].visible = false;
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("task001",this._task.getMoney()),this.showPrizesOver);
            this.playerManager.getPlayer().setMoney(this.playerManager.getPlayer().getMoney() + this._task.getMoney());
            PlantsVsZombies.changeMoneyOrExp(this._task.getMoney(),2);
         }
      }
      
      private function updateTask(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_INFO,param1);
      }
      
      private function updateTool(param1:Array) : void
      {
         var _loc3_:Tool = null;
         var _loc4_:int = 0;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] is Tool)
            {
               _loc3_ = this.playerManager.getPlayer().getTool((param1[_loc2_] as Tool).getOrderId());
               if(_loc3_ != null)
               {
                  _loc4_ = (param1[_loc2_] as Tool).getNum() + _loc3_.getNum();
               }
               else
               {
                  _loc4_ = (param1[_loc2_] as Tool).getNum();
               }
               this.playerManager.getPlayer().updateTool((param1[_loc2_] as Tool).getOrderId(),_loc4_);
            }
            _loc2_++;
         }
      }
   }
}

