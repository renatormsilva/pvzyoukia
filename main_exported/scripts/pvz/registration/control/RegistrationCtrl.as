package pvz.registration.control
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import manager.APLManager;
   import manager.PlayerManager;
   import pvz.registration.data.RegistrationVo;
   import utils.Singleton;
   
   public class RegistrationCtrl
   {
      
      private var _vo:RegistrationVo;
      
      private var _type:int;
      
      private var _call:Function = null;
      
      public var GETINFO:int = 1;
      
      public var SETREG:int = 2;
      
      public var GETREWARD:int = 3;
      
      public var GETREWARD1:int = 4;
      
      public var _mgr:RegistrationMgr;
      
      public function RegistrationCtrl()
      {
         super();
         this._vo = new RegistrationVo();
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, param4:Function, ... rest) : void
      {
         PlantsVsZombies.showDataLoading(true);
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc6_:Connection = new Connection(param1,this.onResult,this.onStatus);
         this._call = param4;
         switch(param3)
         {
            case this.GETINFO:
               _loc6_.call(param2,param3);
               break;
            case this.SETREG:
               _loc6_.call(param2,param3);
               break;
            case this.GETREWARD:
               _loc6_.callO(param2,param3,rest[0]);
               break;
            case this.GETREWARD1:
               _loc6_.callO(param2,param3,rest[0]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:PlayerManager = null;
         this._type = param1;
         if(param1 == this.GETINFO)
         {
            this._vo.decodeInfo(param2);
            _loc3_ = Singleton.getInstance(PlayerManager);
            _loc3_.getPlayer().setIsRegistration(this._vo.isVisibleEff || this._mgr.isSignCurrent() == false ? true : false);
            if(this._call != null)
            {
               this._call.call();
            }
         }
         else if(param1 == this.SETREG)
         {
            if(this._call != null)
            {
               this._call.call(null,param2);
            }
            _loc3_ = Singleton.getInstance(PlayerManager);
            _loc3_.getPlayer().setIsRegistration(this._vo.isVisibleEff || this._mgr.isSignCurrent() == false ? true : false);
         }
         else if(param1 == this.GETREWARD || param1 == this.GETREWARD1)
         {
            if(this._call != null)
            {
               this._call.call(null,param2);
            }
         }
         else if(this._call != null)
         {
            this._call.call();
         }
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         }
      }
      
      public function get vo() : RegistrationVo
      {
         return this._vo;
      }
   }
}

