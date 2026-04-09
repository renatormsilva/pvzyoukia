package pvz.registration.data
{
   public class RegistrationVo
   {
      
      public var time:Number;
      
      public var signs:Array;
      
      public var signcount:int;
      
      public var signreward:Array;
      
      public var activemax:int;
      
      public var active:int;
      
      public var missions:Array;
      
      public var activereward:Array;
      
      public function RegistrationVo()
      {
         super();
      }
      
      public function decodeInfo(param1:Object) : void
      {
         this.time = param1.time;
         this.signs = this.decodeSigns(param1.signs);
         this.signcount = param1.signcount;
         this.signreward = this.decodeSignreward(param1.signreward);
         this.activemax = param1.activemax;
         this.active = param1.active;
         this.missions = this.decodeMissions(param1.missions);
         this.activereward = this.decodeSignreward(param1.activereward);
      }
      
      private function decodeSigns(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:SignDataVo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new SignDataVo();
            _loc4_.decode(_loc3_);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function decodeSignreward(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:PrizeNeedInfoVo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new PrizeNeedInfoVo();
            _loc4_.decode(_loc3_);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function decodeMissions(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:MissionVo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new MissionVo();
            _loc4_.decode(_loc3_);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      public function get isVisibleEff() : Boolean
      {
         var _loc2_:PrizeNeedInfoVo = null;
         var _loc1_:Array = this.signreward.concat(this.activereward);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.state == 1)
            {
               return true;
            }
         }
         return false;
      }
   }
}

