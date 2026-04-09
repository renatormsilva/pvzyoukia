package pvz.shaketree.vo
{
   public class ShakeTreeSystermData
   {
      
      private static var _I:ShakeTreeSystermData;
      
      private var _currentPassData:PassData;
      
      private var _chanllgeTimes:int;
      
      private var _helpStaus:int = 0;
      
      private var _canBuyChanllageTimes:int;
      
      public function ShakeTreeSystermData(param1:SamClass)
      {
         super();
      }
      
      public static function get I() : ShakeTreeSystermData
      {
         if(_I == null)
         {
            _I = new ShakeTreeSystermData(new SamClass());
         }
         return _I;
      }
      
      public function currentPassData() : PassData
      {
         return this._currentPassData;
      }
      
      public function setCurrentPassData(param1:PassData) : void
      {
         this._currentPassData = param1;
      }
      
      public function setChanllgeTime(param1:int) : void
      {
         this._chanllgeTimes = param1;
         PlantsVsZombies.playerManager.getPlayer().setShakeDefy(this._chanllgeTimes);
      }
      
      public function getChanllgeTimes() : int
      {
         return this._chanllgeTimes;
      }
      
      public function setHelpStaus(param1:int) : void
      {
         this._helpStaus = param1;
      }
      
      public function getHelpStaus() : int
      {
         return this._helpStaus;
      }
      
      public function setCanBuyChanllageTimes(param1:int) : void
      {
         this._canBuyChanllageTimes = param1;
      }
      
      public function getCanBuyChanllageTimes() : int
      {
         return this._canBuyChanllageTimes;
      }
      
      public function destory() : void
      {
         this._currentPassData = null;
      }
   }
}

class SamClass
{
   
   public function SamClass()
   {
      super();
   }
}
