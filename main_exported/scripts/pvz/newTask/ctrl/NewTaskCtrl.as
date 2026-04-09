package pvz.newTask.ctrl
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Exp;
   import entity.GameMoney;
   import entity.Honor;
   import entity.LevelUpInfo;
   import entity.PlayerUpInfo;
   import entity.Rmb;
   import entity.Tool;
   import manager.PlayerManager;
   import manager.TeachHelpManager;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import pvz.newTask.data.NewTaskVo;
   import pvz.newTask.data.TaskVo;
   import pvz.newTask.view.NewTaskWindow;
   import utils.Singleton;
   import windows.PlayerUpGradeWindow;
   
   public class NewTaskCtrl implements IConnection
   {
      
      private static var _inst:NewTaskCtrl;
      
      public static var getTask:int = 1;
      
      public static var getReward:int = 2;
      
      public static const STATUS_1:int = -2;
      
      public static const STATUS_2:int = -1;
      
      public static const STATUS_3:int = 0;
      
      public static const STATUS_4:int = 1;
      
      public var _vo:NewTaskVo;
      
      private var _window:NewTaskWindow;
      
      private var _call1:Function;
      
      private var _call2:Function;
      
      private var _upInfo:Object;
      
      private var playerManager:PlayerManager;
      
      private var upIndex:int = -1;
      
      private var playerUpInfos:Array = null;
      
      public function NewTaskCtrl()
      {
         super();
         this._vo = new NewTaskVo();
         this._window = new NewTaskWindow();
         this._window._mrg = this;
      }
      
      public static function getNewTaskCtrl() : NewTaskCtrl
      {
         if(!_inst)
         {
            _inst = new NewTaskCtrl();
         }
         return _inst;
      }
      
      public function Open() : void
      {
         this.getTaskInfo(this._window.onShow);
      }
      
      public function Close() : void
      {
         this._window.onHide();
      }
      
      public function getCurTyp() : int
      {
         return this._window.currentType;
      }
      
      public function refTask() : void
      {
         this.getTaskInfo(this.upInfo);
      }
      
      private function upInfo() : void
      {
         this._window.selectTyep(this._window.currentType);
      }
      
      public function getTaskInfo(param1:Function = null) : void
      {
         this._call1 = param1;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_GET_ALL,getTask);
      }
      
      public function getTaskReward(param1:int, param2:int, param3:Function = null) : void
      {
         this._call2 = param3;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TASK_GET_REWARD,getReward,param1,param2);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == getTask)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == getReward)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this._upInfo = null;
         if(param1 == getTask)
         {
            this._vo.mainTaskDecode(param2.mainTask);
            this._vo.sideTaskDecode(param2.sideTask);
            this._vo.dailyTaskDecode(param2.dailyTask);
            this._vo.activeTaskDecode(param2.activeTask);
            if(this._call1 != null)
            {
               this._call1.call();
               this._call1 = null;
            }
         }
         else if(param1 == getReward)
         {
            this._upInfo = param2;
            if(this._call2 != null)
            {
               this._call2.call();
               this._call2 = null;
            }
         }
      }
      
      public function startUp() : void
      {
         if(this._upInfo)
         {
            this.showUpGradeInfo(this._upInfo.up_grade);
         }
      }
      
      public function getUpInfos(param1:Object) : Array
      {
         var _loc4_:LevelUpInfo = null;
         var _loc5_:Object = null;
         var _loc2_:Array = param1.up_grade;
         var _loc3_:Array = new Array();
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = new LevelUpInfo();
            _loc4_.readData(_loc5_);
            _loc3_.push(_loc4_);
         }
         return _loc3_;
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         this._upInfo = null;
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
      
      public function addPrize(param1:Array) : void
      {
         var _loc3_:Object = null;
         this.playerManager = Singleton.getInstance(PlayerManager);
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_ is GameMoney)
            {
               PlantsVsZombies.changeMoneyOrExp(_loc3_.getMoneyValue(),0,true,true);
            }
            else if(_loc3_ is Honor)
            {
               this.playerManager.getPlayer().setHonour(this.playerManager.getPlayer().getHonour() + _loc3_.getHonorValue());
            }
            else if(_loc3_ is Exp)
            {
               PlantsVsZombies.changeMoneyOrExp(_loc3_.getExpValue(),1,true,true);
            }
            else if(_loc3_ is Rmb)
            {
               PlantsVsZombies.changeMoneyOrExp(_loc3_.getValue(),2,true,true);
            }
            else if(_loc3_ is Tool)
            {
               _loc2_.push(_loc3_);
            }
         }
         this.updateTool(_loc2_);
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
      
      public function showUpGradeInfo(param1:Array) : void
      {
         this.upIndex = -1;
         this.playerUpInfos = this.getGradeUpInfos(param1);
         this.showPlayerUpInfo();
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
      
      private function dealBtnTurn() : void
      {
         if(MenuButtonManager.instance.checkBtnUpLimit("firstRecharge",this.playerManager.getPlayer().getGrade()) || MenuButtonManager.instance.checkBtnUpLimit("activity_btn",this.playerManager.getPlayer().getGrade()) || MenuButtonManager.instance.checkBtnUpLimit("signup_btn",this.playerManager.getPlayer().getGrade()))
         {
            PlantsVsZombies.firstpage.updateSignUpAndActivtyButtonEtcStaus();
            return;
         }
         MenuButtonManager.instance.updateAllButtonsWhenLevelUP(this.playerManager.getPlayer().getGrade(),null);
      }
      
      public function getTaskStatus() : int
      {
         if(this._vo.getIsOver(1) || this._vo.getIsOver(2) || this._vo.getIsOver(3) || this._vo.getIsOver(4))
         {
            return STATUS_4;
         }
         if(this._vo.getIsTasks())
         {
            return STATUS_3;
         }
         return STATUS_1;
      }
      
      public function getMainTaskTo() : int
      {
         var _loc1_:Array = this._vo.getMainTask();
         var _loc2_:TaskVo = _loc1_[0] as TaskVo;
         if(_loc2_)
         {
            switch(_loc2_.gotoId)
            {
               case 5:
                  return TeachHelpManager.TASK_TYPE_ARENA;
               case 18:
                  return TeachHelpManager.TASK_TYPE_COMPONSE;
               case 2:
                  return TeachHelpManager.TASK_TYPE_DRAK;
               case 6:
               case 7:
               case 8:
                  return TeachHelpManager.TASK_TYPE_FUBEN;
               case 11:
                  return TeachHelpManager.TASK_TYPE_GAREN;
               case 3:
                  return TeachHelpManager.TASK_TYPE_PERSONAL;
               case 4:
                  return TeachHelpManager.TASK_TYPE_POSSESSION;
               case 1:
                  return TeachHelpManager.TASK_TYPE_PUBLIC;
               case 16:
                  return TeachHelpManager.TASK_TYPE_STORAGE;
               case 10:
                  return TeachHelpManager.TASK_TYPE_TREE;
            }
         }
         return 0;
      }
   }
}

