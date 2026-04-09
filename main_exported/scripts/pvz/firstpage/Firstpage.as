package pvz.firstpage
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.ui.components.VGroupLayout;
   import entity.Task;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.TeachHelpManager;
   import pvz.ActivityWindow;
   import pvz.arena.fore.ArenaForelet;
   import pvz.compose.panel.ComposeWindowNew;
   import pvz.copy.CopyWindow;
   import pvz.copy.mediators.StoneMediator;
   import pvz.copy.net.ActivtyCopyFPort;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import pvz.firstpage.otherhelp.ModeConst;
   import pvz.garden.fore.Garden;
   import pvz.hunting.fore.HuntingForelet;
   import pvz.invitePrizes.InvitePrizeWindow;
   import pvz.newTask.ctrl.NewTaskCtrl;
   import pvz.possession.PossessionFore;
   import pvz.rank.RankingWindow;
   import pvz.registration.control.RegistrationMgr;
   import pvz.serverbattle.SeverBattleControl;
   import pvz.serverbattle.qualifying.SignUpWindow;
   import pvz.shaketree.ShakeTreeControl;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import pvz.shop.ShopWindow;
   import pvz.storage.StorageWindow;
   import pvz.task.TaskWindow;
   import pvz.task.rpc.Task_rpc;
   import pvz.tree.Tree;
   import pvz.vip.VIPWindow;
   import pvz.world.WorldFore;
   import tip.VipTip;
   import tip.notice.NoticeManager;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ChallengePropWindow;
   import windows.FirstRechargePanel;
   import windows.FriendsWindow;
   import windows.OtherActitvyWindow;
   import windows.ShortcutComposeWindow;
   import zlib.utils.DomainAccess;
   
   public class Firstpage extends Sprite implements IConnection
   {
      
      public static var controlAcitveUi:Boolean;
      
      public static var setBtnVisible:Boolean = false;
      
      public var _vgroupLayout:VGroupLayout;
      
      private var _activityWindow:ActivityWindow = null;
      
      private var _arena_fore:ArenaForelet = null;
      
      private var _bgheight:int;
      
      private var _bgwidth:int;
      
      private var _garden:Garden = null;
      
      private var _huntingfore:HuntingForelet = null;
      
      private var _invitePrizeWindow:InvitePrizeWindow = null;
      
      private var _mc:MovieClip = null;
      
      private var _node:MovieClip = null;
      
      private var _possession:PossessionFore = null;
      
      private var _rankingWindow:RankingWindow = null;
      
      private var _taskWindow:TaskWindow = null;
      
      private var _tree:Tree = null;
      
      private var _world:WorldFore = null;
      
      private var birdContrl:Boolean;
      
      private var isChoose:Boolean = false;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var start_mouseX:int = 0;
      
      private var start_mouseY:int = 0;
      
      private var timer:Timer;
      
      public function Firstpage(param1:MovieClip)
      {
         super();
         this._node = param1;
         var _loc2_:Class = DomainAccess.getClass("firstPage");
         this._mc = new _loc2_();
         this._mc.visible = false;
         this._vgroupLayout = new VGroupLayout(new Point(715,90),5);
         this.addButtonToButtonMag();
         this._vgroupLayout.addDisToGroup(this._mc["activity_btn"] as DisplayObject);
         this._vgroupLayout.addDisToGroup(this._mc["firstRecharge"] as DisplayObject);
         this._vgroupLayout.addDisToGroup(this._mc["signup_btn"] as DisplayObject);
         this.clearTask();
         this.init();
         this.setVipTips();
         this._mc["autoClip"].visible = false;
         this._mc["tree_effect"].visible = false;
         this._mc["tree_effect"].mouseEnabled = false;
         this._mc["shake_effect"].visible = false;
         this._mc["shake_effect"].mouseEnabled = false;
         this._mc["active_btn_effect"].visible = false;
         this._mc["active_btn_effect"].mouseEnabled = false;
      }
      
      public function addDrawEvent() : void
      {
         this._node.addEventListener(MouseEvent.MOUSE_DOWN,this.mousedown);
         this._node.addEventListener(MouseEvent.ROLL_OUT,this.mouseout);
         this._node.addEventListener(MouseEvent.MOUSE_UP,this.mouseup);
         this._node.addEventListener(MouseEvent.MOUSE_MOVE,this.changeDrawLoation);
      }
      
      public function getTaskJianTou() : DisplayObject
      {
         return this._mc["_jiantou"];
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Task_rpc = new Task_rpc();
         PlantsVsZombies._task = _loc3_.getTask(param2);
         this.showTaskType();
         PlantsVsZombies.showDataLoading(false);
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      public function playNameGuide() : void
      {
         var _loc1_:SoundTransform = new SoundTransform();
         if(SoundManager.isMute)
         {
            _loc1_.volume = 0;
         }
         else
         {
            _loc1_.volume = 7;
         }
         this._mc["nameplate"].soundTransform = _loc1_;
         this._mc["nameplate"].play();
         this._mc["nameplate"].addEventListener(Event.ENTER_FRAME,this.onPlayCartoon);
      }
      
      public function removeDraw() : void
      {
         this._node.x = 0;
         this._node.y = 0;
         this._node.removeEventListener(MouseEvent.MOUSE_DOWN,this.mousedown);
         this._node.removeEventListener(MouseEvent.ROLL_OUT,this.mouseout);
         this._node.removeEventListener(MouseEvent.MOUSE_UP,this.mouseup);
         this._node.removeEventListener(MouseEvent.MOUSE_MOVE,this.changeDrawLoation);
         this._bgheight = 0;
         this._bgwidth = 0;
      }
      
      public function removeDrawEvent() : void
      {
         this._node.removeEventListener(MouseEvent.MOUSE_DOWN,this.mousedown);
         this._node.removeEventListener(MouseEvent.ROLL_OUT,this.mouseout);
         this._node.removeEventListener(MouseEvent.MOUSE_UP,this.mouseup);
         this._node.removeEventListener(MouseEvent.MOUSE_MOVE,this.changeDrawLoation);
      }
      
      public function setActivtyBtnStaus(param1:int) : void
      {
         if(!MenuButtonManager.instance.checkBtnUpLimit("activity_btn",this.playerManager.getPlayer().getGrade()))
         {
            return;
         }
         if(param1 == 0)
         {
            this._mc["activity_btn"].visible = false;
         }
         else if(param1 == 1)
         {
            this._mc["activity_btn"].visible = true;
            this._mc["activity_btn"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         }
         this._vgroupLayout.layout();
      }
      
      public function setActvityTipVisible() : void
      {
         if(this.playerManager.getPlayer().getGrade() < 20)
         {
            this._mc["activty_tip"].visible = false;
         }
         else
         {
            this._mc["activty_tip"].visible = this.playerManager.getPlayer().getCopyActiveState() > 1;
         }
      }
      
      public function setAutoClip() : void
      {
         if(this.playerManager.getPlayer().getVipAutoGain() == 1)
         {
            this._mc["autoClip"].visible = true;
            this._mc["autoClip"].play();
         }
         else
         {
            this._mc["autoClip"].stop();
            this._mc["autoClip"].visible = false;
         }
      }
      
      public function setFirstRecharge(param1:int) : void
      {
         if(!MenuButtonManager.instance.checkBtnUpLimit("firstRecharge",this.playerManager.getPlayer().getGrade()))
         {
            return;
         }
         this._mc["firstRecharge"].visible = true;
         this._mc["firstRecharge"].buttonMode = true;
         if(param1 == 1)
         {
            this._mc["firstRecharge"].gotoAndStop(4);
         }
         else if(param1 == 3)
         {
            this._mc["firstRecharge"].gotoAndStop(1);
         }
         else
         {
            this._mc["firstRecharge"].visible = false;
         }
         if(param1 == 1 || param1 == 3)
         {
            this._mc["firstRecharge"].addEventListener(MouseEvent.CLICK,this.firstPageClick,false,0,true);
            this._mc["firstRecharge"].addEventListener(MouseEvent.ROLL_OVER,this.onOverHandler,false,0,true);
            this._mc["firstRecharge"].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
            this._mc["firstRecharge"].addEventListener(MouseEvent.ROLL_OUT,this.onOutHandler,false,0,true);
         }
         this._vgroupLayout.layout();
      }
      
      public function setPrizeLightEffect() : void
      {
         if(this._mc["prizes"]["effect"].numChildren > 0)
         {
            this._mc["prizes"]["effect"].removeChildAt(0);
         }
         if(this.playerManager.getPlayer().getRewardDaily() == 1 || this.playerManager.getPlayer().getHasActiveAreward() == 1 || this.playerManager.getPlayer().getHasActiveBreward() == 1 || this.playerManager.getPlayer().getHasConsumeBreward() == 1)
         {
            this.setPrize();
            return;
         }
         this._mc["prizes"].gotoAndStop(1);
      }
      
      public function setSeverBattleBtnStaus(param1:int) : void
      {
         if(!MenuButtonManager.instance.checkBtnUpLimit("signup_btn",this.playerManager.getPlayer().getGrade()))
         {
            return;
         }
         this._mc["signup_btn"].visible = false;
         this._mc["signup_btn"].buttonMode = true;
         if(param1 == 3 || param1 == 2)
         {
            this._mc["signup_btn"].gotoAndStop(2);
            this._mc["signup_btn"].visible = true;
         }
         else if(param1 == 1)
         {
            this._mc["signup_btn"].gotoAndStop(1);
            this._mc["signup_btn"].visible = true;
         }
         else if(param1 == 4)
         {
            this._mc["signup_btn"].gotoAndStop(3);
            this._mc["signup_btn"].visible = true;
         }
         else if(param1 == 5)
         {
            this._mc["signup_btn"].gotoAndStop(4);
            this._mc["signup_btn"].visible = true;
         }
         this._vgroupLayout.layout();
      }
      
      public function show() : void
      {
         this.clearNode();
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         this._node.addChild(this._mc);
         this.removeButtonEnable();
         this.addDraw(PlantsVsZombies.HEIGHT,PlantsVsZombies.WIDTH);
         this._mc.visible = true;
         this.playBG(true);
         this.setButtonvisible();
         this.updateSignUpAndActivtyButtonEtcStaus();
         this._mc["nameplate"].mouseChildren = false;
         if(setBtnVisible)
         {
            this.playNameGuide();
            Firstpage.setBtnVisible = false;
         }
         if(this.playerManager.getPlayer() != null)
         {
            this.setAutoClip();
            if(PlantsVsZombies.firstLogin == 0)
            {
               if(PlantsVsZombies.firstLogin == 1)
               {
                  this.showActivityWindow(false);
               }
               PlantsVsZombies.firstLogin = 2;
            }
         }
         if(PlantsVsZombies.firstLogin == 2)
         {
            this.upDateTask();
         }
      }
      
      public function showEveryPrizesWindow() : void
      {
         if(PlantsVsZombies.firstLogin == 1)
         {
            this.showActivityWindow(true);
         }
         PlantsVsZombies.firstLogin = 2;
      }
      
      public function showTask() : void
      {
         var end:Function = null;
         end = function():void
         {
            if(playerManager.getPlayer().IsNewTaskSystem)
            {
               NewTaskCtrl.getNewTaskCtrl().Open();
            }
            else
            {
               _taskWindow = new TaskWindow(upDateTask);
               _taskWindow.show(PlantsVsZombies._task);
            }
         };
         DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_TASK_WINDOW,end);
      }
      
      public function showTaskType() : void
      {
         this.clearTask();
         var _loc1_:int = this.playerManager.getPlayer().IsNewTaskSystem ? NewTaskCtrl.getNewTaskCtrl().getTaskStatus() : PlantsVsZombies._task.getStatus();
         if(_loc1_ == NewTaskCtrl.STATUS_2)
         {
            this._mc["_bt_toTask"].visible = true;
            this._mc["_jiantou"].visible = true;
            this._mc["_task_get"].visible = true;
            this._mc["_task_get"].gotoAndPlay(1);
            this._mc["_jiantou"].gotoAndPlay(1);
         }
         else if(_loc1_ == Task.STATUS_3)
         {
            this._mc["_jiantou"].visible = false;
            this._mc["_task_not_comp"].visible = true;
            this._mc["_task_not_comp"].gotoAndPlay(1);
            if(this.playerManager.getPlayer().IsNewTaskSystem)
            {
               TeachHelpManager.I.showArrowByTaskType(NewTaskCtrl.getNewTaskCtrl().getMainTaskTo());
            }
            else
            {
               TeachHelpManager.I.showArrowByTaskType(PlantsVsZombies._task.getTaskGuideType());
            }
         }
         else if(_loc1_ == Task.STATUS_4)
         {
            this._mc["_jiantou"].visible = true;
            this._mc["_task_comp"].visible = true;
            this._mc["_task_comp"].gotoAndPlay(1);
            this._mc["_jiantou"].gotoAndPlay(1);
            TeachHelpManager.I.hideArrow();
         }
         else if(_loc1_ == Task.STATUS_1)
         {
            if(this.playerManager.getPlayer().IsNewTaskSystem == false)
            {
               this._mc["_bt_toTask"].visible = false;
            }
         }
      }
      
      public function toHunting(param1:int = 1) : void
      {
         var onUpHandler:Function = null;
         var type:int = param1;
         onUpHandler = function(param1:MouseEvent):void
         {
            if(_huntingfore.getType() == HuntingForelet.TYPE_PUBLIC2)
            {
               toHuntingPublic(HuntingForelet.TYPE_PUBLIC);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_PUBLIC3)
            {
               toHuntingPublic(HuntingForelet.TYPE_PUBLIC2);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_PUBLIC4)
            {
               toHuntingPublic(HuntingForelet.TYPE_PUBLIC3);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_NIGHT2)
            {
               toHuntingNight(HuntingForelet.TYPE_NIGHT);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_NIGHT3)
            {
               toHuntingNight(HuntingForelet.TYPE_NIGHT2);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_PERSONAL2)
            {
               toHuntingPersonal(HuntingForelet.TYPE_PERSONAL);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_PERSONAL3)
            {
               toHuntingPersonal(HuntingForelet.TYPE_PERSONAL2);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_PERSONAL4)
            {
               toHuntingPersonal(HuntingForelet.TYPE_PERSONAL3);
            }
            if(_huntingfore.getType() == HuntingForelet.TYPE_NIGHT || _huntingfore.getType() == HuntingForelet.TYPE_PUBLIC || _huntingfore.getType() == HuntingForelet.TYPE_PERSONAL)
            {
               PlantsVsZombies.setBackLastFloorButtonVisible(false);
               PlantsVsZombies._node["lastFloor_btn"].removeEventListener(MouseEvent.CLICK,onUpHandler);
            }
         };
         PlantsVsZombies.setBackLastFloorButtonVisible(true);
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         if(this._huntingfore == null)
         {
            this._huntingfore = new HuntingForelet();
         }
         else
         {
            this._huntingfore.destroy();
         }
         if(type == HuntingForelet.TYPE_PUBLIC || type == HuntingForelet.TYPE_PUBLIC2 || type == HuntingForelet.TYPE_PUBLIC3 || type == HuntingForelet.TYPE_PUBLIC4)
         {
            this.toHuntingPublic(type);
         }
         else if(type == HuntingForelet.TYPE_NIGHT || type == HuntingForelet.TYPE_NIGHT2 || type == HuntingForelet.TYPE_NIGHT3)
         {
            this.toHuntingNight(type);
         }
         else if(type == HuntingForelet.TYPE_PERSONAL || type == HuntingForelet.TYPE_PERSONAL2 || type == HuntingForelet.TYPE_PERSONAL3 || type == HuntingForelet.TYPE_PERSONAL4)
         {
            this.toHuntingPersonal(type);
         }
         if(!(PlantsVsZombies._node["lastFloor_btn"] as SimpleButton).hasEventListener(MouseEvent.CLICK))
         {
            PlantsVsZombies._node["lastFloor_btn"].addEventListener(MouseEvent.CLICK,onUpHandler);
         }
      }
      
      public function toHuntingPublic(param1:int = 1) : void
      {
         if(this.playerManager.getPlayer().getGrade() >= 3)
         {
            PlantsVsZombies.setPageButtonVisible(true);
            PlantsVsZombies.setFriendWindowVisible(true);
            PlantsVsZombies.setFriendWindowType(FriendsWindow.HUNTING);
         }
         else
         {
            PlantsVsZombies.setPageButtonVisible(false);
            PlantsVsZombies.setFriendWindowVisible(false);
         }
         PlantsVsZombies.setWindowsButtonsVisible();
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         if(this._huntingfore == null)
         {
            this._huntingfore = new HuntingForelet();
         }
         this._huntingfore.show(this._node,param1,12,this.toHunting);
         PlantsVsZombies.setFirendWindowBackFun(this._huntingfore.changePlayer);
      }
      
      public function updateSignUpAndActivtyButtonEtcStaus() : void
      {
         var layout:Function;
         if(this.playerManager.getPlayer())
         {
            layout = function():void
            {
               _vgroupLayout.layout();
            };
            this.setFirstRecharge(this.playerManager.getPlayer().getFirstRecharge());
            this.setSeverBattleBtnStaus(this.playerManager.getPlayer().getSeverBattleStaus());
            this.setActivtyBtnStaus(this.playerManager.getPlayer().getActivtyBtnStaus());
            MenuButtonManager.instance.updateAllButtonsWhenLevelUP(this.playerManager.getPlayer().getGrade(),layout);
            NoticeManager.getInstance.initNotice(NoticeManager.DYNAMIC_MESSAGES_MAIN,100,80);
         }
      }
      
      private function addButtonDown() : void
      {
         this._mc["toGarden"].addEventListener(MouseEvent.MOUSE_DOWN,this.buttonDown);
         this._mc["toHunting"].addEventListener(MouseEvent.MOUSE_DOWN,this.buttonDown);
         this._mc["toHuntingPersonal"].addEventListener(MouseEvent.MOUSE_DOWN,this.buttonDown);
         this._mc["toHuntingNight"].addEventListener(MouseEvent.MOUSE_DOWN,this.buttonDown);
         this._mc["toTree"].addEventListener(MouseEvent.MOUSE_DOWN,this.buttonDown);
         this._mc["toWorld"].addEventListener(MouseEvent.MOUSE_DOWN,this.buttonDown);
      }
      
      private function addButtonEvent() : void
      {
         this._mc["toGarden"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toPossession"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toHunting"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toHuntingPersonal"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toHuntingNight"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toWorld"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["ranking"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["prizes"].buttonMode = true;
         this._mc["prizes"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["prizes"].addEventListener(MouseEvent.MOUSE_OVER,this.onPrizeOver);
         this._mc["prizes"].addEventListener(MouseEvent.MOUSE_DOWN,this.onPrizeDown);
         this._mc["prizes"].addEventListener(MouseEvent.MOUSE_OUT,this.onPrizeOut);
         this._mc["soundEffect"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["soundEffected"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toPKRoom"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toTree"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_activity"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_quality_open"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_quality_close"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_toTask"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_vip"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["active_btn"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["signup_btn"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["shakeTree_btn"].addEventListener(MouseEvent.CLICK,this.firstPageClick);
      }
      
      private function addButtonToButtonMag() : void
      {
         this._mc["activity_btn"].visible = false;
         this._mc["firstRecharge"].visible = false;
         this._mc["signup_btn"].visible = false;
         this._mc["toPKRoom"].visible = false;
         this._mc["toPossession"].visible = false;
         this._mc["ranking"].visible = false;
         this._mc["toWorld"].visible = false;
         this._mc["prizes"].visible = false;
         this._mc["toTree"].visible = false;
         this._mc["_bt_vip"].visible = false;
         this._mc["active_btn"].visible = false;
         this._mc["toGarden"].visible = false;
         this._mc["shakeTree_btn"].visible = false;
         this._mc["activty_tip"].visible = false;
         MenuButtonManager.instance.addButtonToDic(this._mc["activity_btn"].name,this._mc["activity_btn"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["firstRecharge"].name,this._mc["firstRecharge"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["signup_btn"].name,this._mc["signup_btn"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["toPKRoom"].name,this._mc["toPKRoom"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["toPossession"].name,this._mc["toPossession"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["ranking"].name,this._mc["ranking"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["toWorld"].name,this._mc["toWorld"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["prizes"].name,this._mc["prizes"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["toTree"].name,this._mc["toTree"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["_bt_vip"].name,this._mc["_bt_vip"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["active_btn"].name,this._mc["active_btn"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["toGarden"].name,this._mc["toGarden"]);
         MenuButtonManager.instance.addButtonToDic(this._mc["shakeTree_btn"].name,this._mc["shakeTree_btn"]);
      }
      
      private function addDraw(param1:int, param2:int) : void
      {
         this._bgheight = param1;
         this._bgwidth = param2;
      }
      
      private function addMouseOverEvent() : void
      {
         this._mc["toHunting"].addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         this._mc["_activity"].addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this._mc["toHuntingPersonal"].addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         this._mc["toHuntingNight"].addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         this._mc["toHunting"].addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         this._mc["toHuntingPersonal"].addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         this._mc["toHuntingNight"].addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
      }
      
      private function buttonDown(param1:MouseEvent) : void
      {
         this.playBG();
         if(param1.currentTarget.name == "toGarden")
         {
            (this._mc["toGarden"] as SimpleButton).enabled = false;
         }
         else if(param1.currentTarget.name == "toHunting")
         {
            (this._mc["toHunting"] as SimpleButton).enabled = false;
         }
         else if(param1.currentTarget.name == "toHuntingPersonal")
         {
            (this._mc["toHuntingPersonal"] as SimpleButton).enabled = false;
         }
         else if(param1.currentTarget.name == "toHuntingNight")
         {
            (this._mc["toHuntingNight"] as SimpleButton).enabled = false;
         }
         else if(param1.currentTarget.name == "toTree")
         {
            (this._mc["toTree"] as SimpleButton).enabled = false;
         }
         else if(param1.currentTarget.name == "toWorld")
         {
         }
      }
      
      private function changeDrawLoation(param1:MouseEvent) : void
      {
         if(!this.isChoose)
         {
            return;
         }
         var _loc2_:int = mouseX - this.start_mouseX;
         var _loc3_:int = mouseY - this.start_mouseY;
         if(this._node.x + _loc2_ > 0 || this._node.x + _loc2_ < PlantsVsZombies.WIDTH - this._bgwidth)
         {
            _loc2_ = 0;
         }
         if(this._node.y + _loc3_ > 0 || this._node.y + _loc3_ < PlantsVsZombies.HEIGHT - this._bgheight)
         {
            _loc3_ = 0;
         }
         this._node.x += _loc2_;
         this._node.y += _loc3_;
         this.start_mouseX = mouseX;
         this.start_mouseY = mouseY;
      }
      
      private function clearNode() : void
      {
         if(this._garden != null)
         {
            this._garden.destroy();
            FuncKit.clearAllChildrens(this._garden);
            this._garden = null;
         }
         if(this._tree != null)
         {
            this._tree.destroy();
            FuncKit.clearAllChildrens(this._tree);
            this._tree = null;
         }
         if(this._arena_fore != null)
         {
            this._arena_fore.destroy();
            FuncKit.clearAllChildrens(this._arena_fore);
            this._arena_fore = null;
         }
         if(this._huntingfore != null)
         {
            this._huntingfore.destroy();
            this._huntingfore = null;
         }
         if(this._possession != null)
         {
            this._possession.destroy();
            this._possession = null;
         }
      }
      
      private function clearTask() : void
      {
         this._mc["_task_get"].gotoAndStop(1);
         this._mc["_task_comp"].gotoAndStop(1);
         this._mc["_task_not_comp"].gotoAndStop(1);
         this._mc["_jiantou"].gotoAndStop(1);
         this._mc["_task_get"].mouseEnabled = false;
         this._mc["_task_comp"].mouseEnabled = false;
         this._mc["_task_not_comp"].mouseEnabled = false;
         this._mc["_task_get"].visible = false;
         this._mc["_task_comp"].visible = false;
         this._mc["_task_not_comp"].visible = false;
         this._mc["_jiantou"].visible = false;
      }
      
      private function firstPageClick(param1:MouseEvent) : void
      {
         var endc:Function;
         var end:Function;
         var e:MouseEvent = param1;
         this._mc["_jiantou"].visible = false;
         this.birdContrl = true;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(e.currentTarget.name == "toGarden")
         {
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toGarden();
         }
         else if(e.currentTarget.name == "toWorld")
         {
            if(this.playerManager.getPlayer().getGrade() >= 20)
            {
               NoticeManager.getInstance.stop();
            }
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toWorld();
         }
         if(e.currentTarget.name == "toPossession")
         {
            if(this.playerManager.getPlayer().getArenaOrgs() == null || this.playerManager.getPlayer().getArenaOrgs().length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage005"));
               return;
            }
            if(this.playerManager.getPlayer().getGrade() < 7)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage006"));
               return;
            }
            if(this.playerManager.getPlayer().getGrade() >= 20)
            {
               NoticeManager.getInstance.stop();
            }
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toPossession();
         }
         else if(e.currentTarget.name == "toTree")
         {
            if(this.playerManager.getPlayer().getGrade() < 4)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage001"));
               return;
            }
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toTree();
         }
         else if(e.currentTarget.name == "toHunting")
         {
            if(GlobalConstants.NEW_PLAYER)
            {
               PlantsVsZombies.helpN.clear();
            }
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toHuntingPublic();
         }
         else if(e.currentTarget.name == "toHuntingPersonal")
         {
            if(this.playerManager.getPlayer().getGrade() < 5)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage002"));
               return;
            }
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toHuntingPersonal();
         }
         else if(e.currentTarget.name == "toHuntingNight")
         {
            if(this.playerManager.getPlayer().getGrade() < 8)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage003"));
               return;
            }
            ShortcutComposeWindow.getShortcutComposeInstance.hide();
            this.toHuntingNight();
         }
         else if(e.currentTarget.name == "ranking")
         {
            endc = function():void
            {
               if(_rankingWindow == null)
               {
                  _rankingWindow = new RankingWindow();
               }
               _rankingWindow.show();
            };
            DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_RANKING,endc);
         }
         else if(e.currentTarget.name == "prizes")
         {
            end = function():void
            {
               if(_invitePrizeWindow == null)
               {
                  _invitePrizeWindow = new InvitePrizeWindow();
               }
               _invitePrizeWindow.show();
            };
            DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_PRIZES_WINDOW,end);
         }
         else if(e.currentTarget.name != "sound")
         {
            if(e.currentTarget.name == "soundEffect")
            {
               SoundManager.isMute = true;
               this._mc["soundEffect"].visible = false;
               this._mc["soundEffected"].visible = true;
            }
            else if(e.currentTarget.name == "soundEffected")
            {
               SoundManager.isMute = false;
               this._mc["soundEffect"].visible = true;
               this._mc["soundEffected"].visible = false;
            }
            else if(e.currentTarget.name == "_bt_quality_open")
            {
               PlantsVsZombies._node.parent.stage.quality = StageQuality.LOW;
               this._mc["_bt_quality_open"].visible = false;
               this._mc["_bt_quality_close"].visible = true;
            }
            else if(e.currentTarget.name == "_bt_quality_close")
            {
               PlantsVsZombies._node.parent.stage.quality = StageQuality.HIGH;
               this._mc["_bt_quality_open"].visible = true;
               this._mc["_bt_quality_close"].visible = false;
            }
            else if(e.currentTarget.name == "toPKRoom")
            {
               if(this.playerManager.getPlayer().getGrade() < 6)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage004"));
                  return;
               }
               if(this.playerManager.getPlayer().getGrade() >= 20)
               {
                  NoticeManager.getInstance.stop();
               }
               ShortcutComposeWindow.getShortcutComposeInstance.hide();
               this.toArena();
            }
            else if(e.currentTarget.name == "_activity")
            {
               new ActivityWindow();
            }
            else if(e.currentTarget.name == "_bt_toTask")
            {
               this.showTask();
            }
            else if(e.currentTarget.name == "_bt_vip")
            {
               new VIPWindow();
            }
            else if(e.currentTarget.name == "active_btn")
            {
               RegistrationMgr.getInstance().openSystem();
            }
            else if(e.currentTarget.name == "firstRecharge")
            {
               new FirstRechargePanel(this.setFirstRecharge);
            }
            else if(e.currentTarget.name == "signup_btn")
            {
               if(this.playerManager.getPlayer().getSeverBattleStaus() == 1 || this.playerManager.getPlayer().getSeverBattleStaus() == 2)
               {
                  LangManager.getInstance().doLoad(LangManager.MODE_SEVERBATTLE);
                  new SignUpWindow();
               }
               else if(this.playerManager.getPlayer().getSeverBattleStaus() == 3)
               {
                  PlantsVsZombies.setToFirstPageButtonVisible(false);
                  PlantsVsZombies.setPlayerInfoVisible(false);
                  PlantsVsZombies.setWindowsButtonsVisible();
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  SeverBattleControl.getInstance().initUI(SeverBattleControl.QUALIFYING,this._node);
               }
               else if(this.playerManager.getPlayer().getSeverBattleStaus() == 4 || this.playerManager.getPlayer().getSeverBattleStaus() == 5)
               {
                  if(this.playerManager.getPlayer().getGrade() >= 20)
                  {
                     NoticeManager.getInstance.stop();
                  }
                  PlantsVsZombies.setToFirstPageButtonVisible(false);
                  PlantsVsZombies.setPlayerInfoVisible(false);
                  PlantsVsZombies.setWindowsButtonsVisible();
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  SeverBattleControl.getInstance().initUI(SeverBattleControl.KNOCKOUT,this._node);
               }
            }
            else if(e.currentTarget.name == "activity_btn")
            {
               new OtherActitvyWindow();
            }
            else if(e.currentTarget.name == "shakeTree_btn")
            {
               new ShakeTreeControl();
            }
         }
         TeachHelpManager.I.hideArrow();
      }
      
      private function hideTreeEffect() : void
      {
         this._mc["tree_effect"].gotoAndStop(1);
         this._mc["tree_effect"].visible = false;
      }
      
      private function init() : void
      {
         if(!SoundManager.isMute)
         {
            this._mc["soundEffect"].visible = true;
            this._mc["soundEffected"].visible = false;
         }
         else
         {
            this._mc["soundEffect"].visible = false;
            this._mc["soundEffected"].visible = true;
         }
         this._mc["_bt_quality_open"].visible = true;
         this._mc["_bt_quality_close"].visible = false;
         this.addButtonEvent();
         this.addButtonDown();
         this.addDrawEvent();
      }
      
      private function mousedown(param1:MouseEvent) : void
      {
         this.isChoose = true;
         this.start_mouseX = mouseX;
         this.start_mouseY = mouseY;
      }
      
      private function mouseout(param1:MouseEvent) : void
      {
         this.isChoose = false;
      }
      
      private function mouseup(param1:MouseEvent) : void
      {
         this.isChoose = false;
      }
      
      private function onBirdFly(param1:TimerEvent) : void
      {
         this._mc["bird_fly"].y += (38 - this._mc["bird_fly"].y) * 0.2;
         if(this._mc["bird_fly"].y <= 38)
         {
            this.timer.stop();
         }
      }
      
      private function onBirdFlyBack(param1:TimerEvent) : void
      {
         this._mc["bird_fly"].y += (131.5 - this._mc["bird_fly"].y) * 0.2;
         if(this._mc["bird_fly"].y >= 128)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onBirdFlyBack);
            this._mc["bird_fly"].visible = false;
            this._mc["_activity"].visible = true;
         }
      }
      
      private function onBirdFlyStart(param1:TimerEvent) : void
      {
         this._mc["bird_fly_start"].y += (131.5 - this._mc["bird_fly_start"].y) * 0.6;
         if(this._mc["bird_fly_start"].y >= 120)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onBirdFlyStart);
            this._mc["bird_fly_start"].y = -61.5;
            this._mc["bird_fly_start"].visible = true;
            this._mc["_activity"].visible = true;
            this.addMouseOverEvent();
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(this.playerManager.getPlayer().getFirstRecharge() == 1)
         {
            this._mc["firstRecharge"].gotoAndStop(6);
         }
         else if(this.playerManager.getPlayer().getFirstRecharge() == 3)
         {
            this._mc["firstRecharge"].gotoAndStop(3);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BIRD_SOUND);
      }
      
      private function onOutHandler(param1:MouseEvent) : void
      {
         if(this.playerManager.getPlayer().getFirstRecharge() == 1)
         {
            this._mc["firstRecharge"].gotoAndStop(4);
         }
         else if(this.playerManager.getPlayer().getFirstRecharge() == 3)
         {
            this._mc["firstRecharge"].gotoAndStop(1);
         }
      }
      
      private function onOverHandler(param1:MouseEvent) : void
      {
         if(this.playerManager.getPlayer().getFirstRecharge() == 1)
         {
            this._mc["firstRecharge"].gotoAndStop(5);
         }
         else if(this.playerManager.getPlayer().getFirstRecharge() == 3)
         {
            this._mc["firstRecharge"].gotoAndStop(2);
         }
      }
      
      private function onPlayCartoon(param1:Event) : void
      {
         if(this._mc["nameplate"].currentFrame == this._mc["nameplate"].totalFrames)
         {
            this._mc["nameplate"].removeEventListener(Event.ENTER_FRAME,this.onPlayCartoon);
            this._mc["nameplate"].stop();
            this._mc["toHuntingNight"].visible = true;
            this._mc["toHunting"].visible = true;
            this._mc["toHuntingPersonal"].visible = true;
            this._mc["_activity"].visible = true;
            if(MenuButtonManager.instance.checkBtnUpLimit("toTree",this.playerManager.getPlayer().getGrade()))
            {
               if(this.playerManager.getPlayer().getTreeTimes())
               {
                  this._mc["tree_effect"].visible = true;
               }
            }
            if(MenuButtonManager.instance.checkBtnUpLimit("shakeTree_btn",this.playerManager.getPlayer().getGrade()))
            {
               if(this.playerManager.getPlayer().getShakeDefy())
               {
                  this._mc["shake_effect"].visible = true;
                  this._mc["shake_effect"].gotoAndPlay(1);
               }
               else
               {
                  this._mc["shake_effect"].gotoAndStop(1);
                  this._mc["shake_effect"].visible = false;
               }
            }
            if(MenuButtonManager.instance.checkBtnUpLimit("active_btn",this.playerManager.getPlayer().getGrade()))
            {
               if(this.playerManager.getPlayer().getIsRegistration())
               {
                  this._mc["active_btn_effect"].visible = true;
               }
               else
               {
                  this._mc["active_btn_effect"].visible = false;
               }
            }
            this.addMouseOverEvent();
            ShortcutComposeWindow.getShortcutComposeInstance.connection();
         }
      }
      
      public function checkActive_BtnEff() : void
      {
         if(MenuButtonManager.instance.checkBtnUpLimit("active_btn",this.playerManager.getPlayer().getGrade()))
         {
            if(this.playerManager.getPlayer().getIsRegistration())
            {
               this._mc["active_btn_effect"].visible = true;
            }
            else
            {
               this._mc["active_btn_effect"].visible = false;
            }
         }
      }
      
      private function onPrizeDown(param1:MouseEvent) : void
      {
         this._mc["prizes"].gotoAndStop(3);
      }
      
      private function onPrizeOut(param1:MouseEvent) : void
      {
         this._mc["prizes"].gotoAndStop(1);
      }
      
      private function onPrizeOver(param1:MouseEvent) : void
      {
         this._mc["prizes"].gotoAndStop(2);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onBirdFly);
         if(!this.birdContrl)
         {
            this.timer.addEventListener(TimerEvent.TIMER,this.onBirdFlyBack);
            this.timer.start();
         }
         else
         {
            this._mc["bird_fly"].y = 128;
            this._mc["bird_fly"].stop();
            this._mc["bird_fly"].visible = false;
            this._mc["_activity"].visible = true;
            this.birdContrl = false;
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.WOOD);
         this._mc["_activity"].visible = false;
         this._mc["bird_fly"].visible = true;
         this._mc["bird_fly"].play();
         if(this.timer == null)
         {
            this.timer = new Timer(80);
         }
         this.timer.start();
         this.timer.addEventListener(TimerEvent.TIMER,this.onBirdFly);
      }
      
      private function playBG(param1:Boolean = false) : void
      {
         if(param1)
         {
            this._mc["_bg"].gotoAndPlay(1);
         }
         else
         {
            this._mc["_bg"].gotoAndStop(1);
         }
      }
      
      private function removeButtonEnable() : void
      {
         (this._mc["toGarden"] as SimpleButton).enabled = true;
         (this._mc["toHunting"] as SimpleButton).enabled = true;
         (this._mc["toHuntingPersonal"] as SimpleButton).enabled = true;
         (this._mc["toHuntingNight"] as SimpleButton).enabled = true;
         (this._mc["toTree"] as SimpleButton).enabled = true;
         (this._mc["toWorld"] as SimpleButton).enabled = true;
      }
      
      private function removeButtonEvent() : void
      {
         this._mc["toHunting"].removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this._mc["toHuntingPersonal"].removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this._mc["toHuntingNight"].removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this._mc["toHunting"].removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this._mc["toHuntingPersonal"].removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this._mc["toHuntingNight"].removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this._mc["toGarden"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toPossession"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toHunting"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toHuntingPersonal"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toHuntingNight"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toWorld"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["ranking"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["prizes"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["prizes"].removeEventListener(MouseEvent.MOUSE_OVER,this.onPrizeOver);
         this._mc["prizes"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onPrizeDown);
         this._mc["prizes"].removeEventListener(MouseEvent.MOUSE_OUT,this.onPrizeOut);
         this._mc["soundEffect"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["soundEffected"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toPKRoom"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["toTree"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_activity"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_quality_open"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_quality_close"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_toTask"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["_bt_vip"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["active_btn"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
         this._mc["shakeTree_btn"].removeEventListener(MouseEvent.CLICK,this.firstPageClick);
      }
      
      private function setButtonvisible() : void
      {
         this._mc["toHuntingNight"].visible = false;
         this._mc["toHunting"].visible = false;
         this._mc["toHuntingPersonal"].visible = false;
         this._mc["_activity"].visible = false;
         this._mc["bird_fly"].visible = false;
         this._mc["nameplate"].gotoAndStop(1);
      }
      
      private function setPrize() : void
      {
         var _loc1_:Class = DomainAccess.getClass("prize_effect");
         var _loc2_:MovieClip = new _loc1_();
         this._mc["prizes"]["effect"].addChild(_loc2_);
         _loc2_.x = -50;
         _loc2_.y = -42;
      }
      
      private function setVipTips() : void
      {
         var viptips:VipTip = null;
         var onVipOver:Function = null;
         onVipOver = function(param1:MouseEvent):void
         {
            viptips = new VipTip();
            viptips.setTooltip(_mc["_bt_vip"]);
            viptips.setLoction(30,-10);
         };
         this._mc["_bt_vip"].addEventListener(MouseEvent.MOUSE_OVER,onVipOver);
         viptips = null;
      }
      
      private function showActivityWindow(param1:Boolean = true) : void
      {
         if(param1)
         {
            this._activityWindow = new ActivityWindow(this.showAddFriendsWindow);
         }
         else
         {
            this._activityWindow = new ActivityWindow(this.showVipWindow);
         }
      }
      
      private function showAddFriendsWindow() : void
      {
         PlantsVsZombies.showAddFriends(this.showVipWindow);
         this.upDateTask();
      }
      
      private function showVipWindow() : void
      {
         if(!MenuButtonManager.instance.checkBtnUpLimit("_bt_vip",this.playerManager.getPlayer().getGrade()))
         {
            this.playNameGuide();
         }
         else
         {
            new VIPWindow(this.playNameGuide);
         }
      }
      
      private function toArena() : void
      {
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         PlantsVsZombies.setWindowsButtonsVisible();
         PlantsVsZombies.setPlayerInfoVisible();
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         this._arena_fore = new ArenaForelet(this._node);
      }
      
      private function toGarden() : void
      {
         PlantsVsZombies.setFriendWindowVisible(true);
         PlantsVsZombies.setPageButtonVisible(true);
         PlantsVsZombies.setFriendWindowType(FriendsWindow.GARDEN);
         PlantsVsZombies._node.stage.frameRate = 12;
         PlantsVsZombies.setDoworkVisible(true);
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         if(this._garden == null)
         {
            this._garden = new Garden(this._node);
         }
         PlantsVsZombies.setFirendWindowBackFun(this._garden.init);
         this.addDraw(PlantsVsZombies.HEIGHT,PlantsVsZombies.WIDTH);
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         PlantsVsZombies.setWindowsButtonsVisible();
      }
      
      private function toHuntingNight(param1:int = 3) : void
      {
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         if(this._huntingfore == null)
         {
            this._huntingfore = new HuntingForelet();
         }
         this._huntingfore.show(this._node,param1,9,this.toHunting);
         PlantsVsZombies.setWindowsButtonsVisible();
         PlantsVsZombies.setToFirstPageButtonVisible(true);
      }
      
      private function toHuntingPersonal(param1:int = 2) : void
      {
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         if(this.timer)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onBirdFly);
         }
         if(this._huntingfore == null)
         {
            this._huntingfore = new HuntingForelet();
         }
         this._huntingfore.show(this._node,param1,12,this.toHunting);
         PlantsVsZombies.setWindowsButtonsVisible();
         PlantsVsZombies.setToFirstPageButtonVisible(true);
      }
      
      private function toPossession() : void
      {
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         PlantsVsZombies._node.stage.frameRate = 12;
         PlantsVsZombies.setWindowsButtonsVisible();
         PlantsVsZombies.setPlayerInfoVisible();
         this._possession = new PossessionFore(this._node,this.playerManager.getPlayer());
      }
      
      private function toTree() : void
      {
         if(this._node.numChildren > 0)
         {
            this._node.removeChildAt(0);
         }
         PlantsVsZombies.setToFirstPageButtonVisible(false);
         PlantsVsZombies.setPlayerInfoVisible(false);
         PlantsVsZombies.setWindowsButtonsVisible();
         if(this._tree == null)
         {
            this._tree = new Tree(this._node,this.hideTreeEffect);
         }
      }
      
      private function toWorld() : void
      {
         new CopyWindow();
      }
      
      private function upCopyAcitvtyStaus() : void
      {
         var fport:ActivtyCopyFPort = null;
         var onComplete:Function = null;
         onComplete = function(param1:HandleDataCompleteEvent):void
         {
            fport.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
            PlantsVsZombies.playerManager.getPlayer().setCopyActiveState(int(param1._data));
            setActvityTipVisible();
         };
         fport = new ActivtyCopyFPort();
         fport.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
         fport.requestSever(ActivtyCopyFPort.GET_ACTIVTY_STATE);
      }
      
      private function upDateTask() : void
      {
         this.upCopyAcitvtyStaus();
         if(this.playerManager.getPlayer().IsNewTaskSystem)
         {
            NewTaskCtrl.getNewTaskCtrl().getTaskInfo(this.showTaskType);
         }
         else
         {
            PlantsVsZombies.showDataLoading(true);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_INFO,0);
         }
      }
      
      public function gotoScence(param1:int) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case ModeConst.toGarden:
               if(MenuButtonManager.instance.checkBtnUpLimit("toGarden",this.playerManager.getPlayer().getGrade()))
               {
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  this.toGarden();
               }
               break;
            case ModeConst.toPKRoom:
               if(MenuButtonManager.instance.checkBtnUpLimit("toPKRoom",this.playerManager.getPlayer().getGrade()))
               {
                  if(this.playerManager.getPlayer().getGrade() < 6)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage004"));
                     return;
                  }
                  if(this.playerManager.getPlayer().getGrade() >= 20)
                  {
                     NoticeManager.getInstance.stop();
                  }
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  this.toArena();
               }
               break;
            case ModeConst.toPossession:
               if(MenuButtonManager.instance.checkBtnUpLimit("toPossession",this.playerManager.getPlayer().getGrade()))
               {
                  if(this.playerManager.getPlayer().getArenaOrgs() == null || this.playerManager.getPlayer().getArenaOrgs().length < 1)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage005"));
                     return;
                  }
                  if(this.playerManager.getPlayer().getGrade() < 7)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage006"));
                     return;
                  }
                  if(this.playerManager.getPlayer().getGrade() >= 20)
                  {
                     NoticeManager.getInstance.stop();
                  }
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  this.toPossession();
               }
               break;
            case ModeConst.toWorld1:
               if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 9)
               {
                  return;
               }
               if(PlantsVsZombies._node["draw"].numChildren > 0)
               {
                  PlantsVsZombies._node["draw"].removeChildAt(0);
               }
               PlantsVsZombies._node.stage.frameRate = 12;
               PlantsVsZombies.setWindowsButtonsVisible();
               PlantsVsZombies.setPlayerInfoVisible();
               new WorldFore(PlantsVsZombies._node["draw"]);
               break;
            case ModeConst.toWorld2:
               if(MenuButtonManager.instance.checkBtnUpLimit("toWorld",this.playerManager.getPlayer().getGrade()))
               {
                  if(this.playerManager.getPlayer().getGrade() >= 20)
                  {
                     NoticeManager.getInstance.stop();
                  }
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 20)
                  {
                     _loc2_ = LangManager.getInstance().getLanguage("copy012");
                     PlantsVsZombies.showSystemErrorInfo(_loc2_);
                     return;
                  }
                  new StoneMediator();
               }
               break;
            case ModeConst.toWorld3:
               if(MenuButtonManager.instance.checkBtnUpLimit("toWorld",this.playerManager.getPlayer().getGrade()))
               {
                  if(this.playerManager.getPlayer().getGrade() >= 20)
                  {
                     NoticeManager.getInstance.stop();
                  }
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  this.toWorld();
               }
               break;
            case ModeConst.toTree:
               if(MenuButtonManager.instance.checkBtnUpLimit("toTree",this.playerManager.getPlayer().getGrade()))
               {
                  if(this.playerManager.getPlayer().getGrade() < 4)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage001"));
                     return;
                  }
                  ShortcutComposeWindow.getShortcutComposeInstance.hide();
                  this.toTree();
               }
               break;
            case ModeConst.shakeTree_btn:
               if(MenuButtonManager.instance.checkBtnUpLimit("shakeTree_btn",this.playerManager.getPlayer().getGrade()))
               {
                  new ShakeTreeControl();
               }
               break;
            case ModeConst.Hunting1:
               if(GlobalConstants.NEW_PLAYER)
               {
                  PlantsVsZombies.helpN.clear();
               }
               ShortcutComposeWindow.getShortcutComposeInstance.hide();
               this.toHuntingPublic();
               break;
            case ModeConst.Hunting2:
               if(this.playerManager.getPlayer().getGrade() < 8)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage003"));
                  return;
               }
               ShortcutComposeWindow.getShortcutComposeInstance.hide();
               this.toHuntingNight();
               break;
            case ModeConst.Hunting3:
               if(this.playerManager.getPlayer().getGrade() < 5)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("firstpage002"));
                  return;
               }
               ShortcutComposeWindow.getShortcutComposeInstance.hide();
               this.toHuntingPersonal();
               break;
            case ModeConst.signup_btn:
               if(MenuButtonManager.instance.checkBtnUpLimit("signup_btn",this.playerManager.getPlayer().getGrade()))
               {
                  if(this.playerManager.getPlayer().getSeverBattleStaus() == 1 || this.playerManager.getPlayer().getSeverBattleStaus() == 2)
                  {
                     LangManager.getInstance().doLoad(LangManager.MODE_SEVERBATTLE);
                     new SignUpWindow();
                  }
                  else if(this.playerManager.getPlayer().getSeverBattleStaus() == 3)
                  {
                     PlantsVsZombies.setToFirstPageButtonVisible(false);
                     PlantsVsZombies.setPlayerInfoVisible(false);
                     PlantsVsZombies.setWindowsButtonsVisible();
                     ShortcutComposeWindow.getShortcutComposeInstance.hide();
                     SeverBattleControl.getInstance().initUI(SeverBattleControl.QUALIFYING,this._node);
                  }
                  else if(this.playerManager.getPlayer().getSeverBattleStaus() == 4 || this.playerManager.getPlayer().getSeverBattleStaus() == 5)
                  {
                     if(this.playerManager.getPlayer().getGrade() >= 20)
                     {
                        NoticeManager.getInstance.stop();
                     }
                     PlantsVsZombies.setToFirstPageButtonVisible(false);
                     PlantsVsZombies.setPlayerInfoVisible(false);
                     PlantsVsZombies.setWindowsButtonsVisible();
                     ShortcutComposeWindow.getShortcutComposeInstance.hide();
                     SeverBattleControl.getInstance().initUI(SeverBattleControl.KNOCKOUT,this._node);
                  }
               }
               break;
            case ModeConst._bt_vip:
               if(MenuButtonManager.instance.checkBtnUpLimit("_bt_vip",this.playerManager.getPlayer().getGrade()))
               {
                  new VIPWindow();
               }
               break;
            case ModeConst.toRecharge:
               PlantsVsZombies.toRecharge();
               break;
            case ModeConst.addchallengeNum:
               new ChallengePropWindow(ChallengePropWindow.TYPE_ONE);
               break;
            case ModeConst.storage:
               TeachHelpManager.I.hideArrow();
               new StorageWindow(PlantsVsZombies.functionObj as Function,this.upDateTask);
               break;
            case ModeConst.shop:
               new ShopWindow(this.upDateTask);
               break;
            case ModeConst.compound:
               TeachHelpManager.I.hideArrow();
               new ComposeWindowNew(PlantsVsZombies.functionObj as Function,this.upDateTask,false,false,null);
         }
      }
   }
}

