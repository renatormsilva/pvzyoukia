package pvz.registration.control
{
   import constants.AMFConnectionConstants;
   import entity.GameMoney;
   import entity.Rmb;
   import entity.Tool;
   import manager.PlayerManager;
   import pvz.registration.data.SignDataVo;
   import pvz.registration.view.RegistrationView;
   import utils.Singleton;
   
   public class RegistrationMgr
   {
      
      private static var _instance:RegistrationMgr;
      
      private var _ctrl:RegistrationCtrl;
      
      private var _view:RegistrationView;
      
      private var _isOpen:Boolean = false;
      
      private var playerManager:PlayerManager;
      
      public function RegistrationMgr(param1:InstanceCode)
      {
         super();
         if(!InstanceCode || Boolean(_instance))
         {
            throw new Error("Please use getInstance().");
         }
      }
      
      public static function getInstance() : RegistrationMgr
      {
         if(_instance == null)
         {
            _instance = new RegistrationMgr(new InstanceCode());
         }
         return _instance;
      }
      
      public function openSystem() : void
      {
         if(!this._ctrl)
         {
            this._ctrl = new RegistrationCtrl();
         }
         if(this._isOpen == false)
         {
            this._isOpen = true;
            this.playerManager = Singleton.getInstance(PlayerManager);
            this._ctrl._mgr = this;
            this.reqGetInfo(this.onLoadCom);
         }
      }
      
      private function onLoadCom() : void
      {
         this._view = new RegistrationView(this);
      }
      
      public function upData() : void
      {
         this.reqGetInfo(this._view.upData);
      }
      
      public function closeSystem() : void
      {
         this._isOpen = false;
         this._view.onHide();
         this._view = null;
         PlantsVsZombies.firstpage.checkActive_BtnEff();
      }
      
      public function get ctrl() : RegistrationCtrl
      {
         return this._ctrl;
      }
      
      public function reqGetInfo(param1:Function = null) : void
      {
         this._ctrl.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_REGISTRATION_GETINFO,this._ctrl.GETINFO,param1);
      }
      
      public function reqSetSign(param1:Function = null) : void
      {
         this._ctrl.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_REGISTRATION_SETSIGN,this._ctrl.SETREG,param1);
      }
      
      public function reqGetReward(param1:Function, param2:int, param3:int) : void
      {
         if(param3 == 1)
         {
            this._ctrl.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_REGISTRATION_GETREWARD,this._ctrl.GETREWARD,param1,param2);
         }
         else
         {
            this._ctrl.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_REGISTRATION_GETREWARD1,this._ctrl.GETREWARD1,param1,param2);
         }
      }
      
      public function getSignPz(param1:int) : SignDataVo
      {
         var _loc2_:SignDataVo = null;
         for each(_loc2_ in this.ctrl.vo.signs)
         {
            if(_loc2_.day == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getCurrentDaySign() : SignDataVo
      {
         var _loc1_:Number = this.ctrl.vo.time;
         var _loc2_:Date = new Date(_loc1_ * 1000);
         return this.getSignPz(_loc2_.date);
      }
      
      public function isSignCurrent() : Boolean
      {
         var _loc1_:SignDataVo = this.getCurrentDaySign();
         if(_loc1_.state == 0 || _loc1_.state == 2)
         {
            return true;
         }
         return false;
      }
      
      public function addPrize(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_ is GameMoney)
            {
               PlantsVsZombies.changeMoneyOrExp(_loc3_.getMoneyValue(),0,true,true);
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
         this.playerManager = Singleton.getInstance(PlayerManager);
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

class InstanceCode
{
   
   public function InstanceCode()
   {
      super();
   }
}
