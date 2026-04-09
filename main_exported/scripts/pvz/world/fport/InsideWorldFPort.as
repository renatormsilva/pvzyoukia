package pvz.world.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Tool;
   import pvz.world.Checkpoint;
   import pvz.world.InsideWorldFore;
   
   public class InsideWorldFPort implements IConnection
   {
      
      private static const INSIDEWORLD_INIT:int = 1;
      
      private static const INSIDEWORLD_UPDATE:int = 2;
      
      private var _insideWorldFore:InsideWorldFore = null;
      
      public function InsideWorldFPort(param1:InsideWorldFore)
      {
         super();
         this._insideWorldFore = param1;
      }
      
      public function initInsideWorld(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INSIDEWORLD_INIT,INSIDEWORLD_INIT,param1);
      }
      
      public function updateInsideWorld(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INSIDEWORLD_INIT,INSIDEWORLD_UPDATE,param1);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INSIDEWORLD_INIT || param3 == INSIDEWORLD_UPDATE)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         if(param1 == INSIDEWORLD_INIT)
         {
            _loc3_ = this.readInsideWorldInfo(param2);
            this._insideWorldFore.portDateInit(_loc3_,param2._ycc,param2._open_scenes,param2._last_challenge_cave,param2._integral,this.getIsRewards(param2._reward));
         }
         else if(param1 == INSIDEWORLD_UPDATE)
         {
            _loc3_ = this.readInsideWorldInfo(param2);
            this._insideWorldFore.portDateUpdate(_loc3_,param2._integral,this.getIsRewards(param2._reward));
         }
      }
      
      private function getIsRewards(param1:int) : Boolean
      {
         if(param1 == 1)
         {
            return true;
         }
         return false;
      }
      
      private function readInsideWorldInfo(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc4_:Checkpoint = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in param1._caves)
         {
            _loc4_ = new Checkpoint();
            _loc4_.setName(param1._caves[_loc3_].name);
            _loc4_.setId(param1._caves[_loc3_].cave_id);
            _loc4_.setMaxOrgNum(param1._caves[_loc3_].open_cave_grid);
            _loc4_.setCost(param1._caves[_loc3_].money);
            _loc4_.setShowId(param1._caves[_loc3_].vid);
            if(param1._caves[_loc3_].reward != "")
            {
               _loc4_.setImportantPrizes((param1._caves[_loc3_].reward as String).split(","));
            }
            _loc4_.setIsBoss(this.isBoss(param1._caves[_loc3_].boss));
            _loc4_.setType(param1._caves[_loc3_].status);
            _loc4_.setMaxBattleTimes(param1._caves[_loc3_].challenge_count);
            _loc4_.setBattleTimes(param1._caves[_loc3_].lcc);
            _loc4_.setOpenTools(this.getOpenTools(param1._caves[_loc3_].open_tools));
            _loc4_.setOpenLv(param1._caves[_loc3_].min_grade);
            this.setLink(param1._caves[_loc3_].t,(param1._caves[_loc3_].child as String).split(","),(param1._caves[_loc3_].parent as String).split(","),_loc4_);
            _loc4_.setPoint(param1._caves[_loc3_].point);
            _loc4_.setIsMap(this.isMap(param1._caves[_loc3_].t));
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function isMap(param1:String) : Boolean
      {
         if(param1 == "0")
         {
            return false;
         }
         return true;
      }
      
      private function isBoss(param1:String) : Boolean
      {
         if(param1 == "0")
         {
            return false;
         }
         return true;
      }
      
      private function setLink(param1:int, param2:Array, param3:Array, param4:Checkpoint) : void
      {
         if(param1 == 0)
         {
            param4.setUplinks(param3);
            param4.setDownlinks(param2);
         }
         else
         {
            param4.setNextMapId(param1);
            param4.setUplinks(param3);
         }
      }
      
      private function getOpenTools(param1:String) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Tool = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = param1.split(",");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = int((_loc3_[_loc4_] as String).split("|")[0]);
            _loc6_ = int((_loc3_[_loc4_] as String).split("|")[1]);
            _loc7_ = new Tool(_loc5_);
            _loc7_.setNum(_loc6_);
            _loc2_.push(_loc7_);
            _loc4_++;
         }
         return _loc2_;
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

