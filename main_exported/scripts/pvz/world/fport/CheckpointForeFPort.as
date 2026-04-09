package pvz.world.fport
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import entity.Skill;
   import manager.SkillManager;
   import manager.ToolManager;
   import pvz.shop.rpc.Shop_rpc;
   import pvz.world.CheckpointFore;
   import xmlReader.config.XmlQualityConfig;
   
   public class CheckpointForeFPort implements IConnection
   {
      
      private static const CHECKPOINT_INFO:int = 1;
      
      private static const ADD_CHECKPOINTNUM_TOOL:int = 4;
      
      private static const SHOP_INIT:int = 5;
      
      private static const PRIZES_NUM:int = 6;
      
      private var _fore:CheckpointFore = null;
      
      public function CheckpointForeFPort(param1:CheckpointFore)
      {
         super();
         this._fore = param1;
      }
      
      public function foreInfo(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INSIDEWORLD_CHECKPOINT_INFO,CHECKPOINT_INFO,param1);
      }
      
      public function useToolAddCheckpoint(param1:int, param2:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.PRC_CHECNPOINT_ADDCHENGPOINT_TOOL,ADD_CHECKPOINTNUM_TOOL,param1,param2);
      }
      
      public function buyToolCheckpoint(param1:int) : void
      {
      }
      
      public function initShopDate() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,SHOP_INIT);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == CHECKPOINT_INFO)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == ADD_CHECKPOINTNUM_TOOL)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == SHOP_INIT)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Shop_rpc = null;
         if(param1 == CHECKPOINT_INFO)
         {
            this._fore.portInit(this.getOrganisms(param2._monsters),param2._award);
         }
         else if(param1 == ADD_CHECKPOINTNUM_TOOL)
         {
            this._fore.portUseToolAddCheckpoint(int(param2));
         }
         else if(param1 == SHOP_INIT)
         {
            _loc3_ = new Shop_rpc();
            this._fore.portBuyCheckpoint(_loc3_.getGood(ToolManager.TOOL_WORLD_ADDCHECKPOINT,param2.goods));
         }
      }
      
      private function getOrganisms(param1:Array) : Array
      {
         var _loc4_:Organism = null;
         var _loc5_:int = 0;
         var _loc6_:Skill = null;
         if(param1 == null || param1.length < 1)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Organism();
            _loc4_.setIsBoss(param1[_loc3_].boss);
            _loc4_.setOrderId(param1[_loc3_].id);
            _loc4_.setGrade(param1[_loc3_].grade);
            _loc4_.setAttack(param1[_loc3_].attack);
            _loc4_.setHp(param1[_loc3_].hp);
            _loc4_.setHp_max(param1[_loc3_].hp);
            _loc4_.setMiss(param1[_loc3_].miss);
            _loc4_.setPrecision(param1[_loc3_].precision);
            _loc4_.setNewMiss(param1[_loc3_].new_miss);
            _loc4_.setNewPrecision(param1[_loc3_].new_precision);
            _loc4_.setSpeed(param1[_loc3_].speed);
            _loc4_.setQuality_name(XmlQualityConfig.getInstance().getName(param1[_loc3_].quality_id));
            _loc5_ = 0;
            while(_loc5_ < param1[_loc3_].skills.length)
            {
               _loc6_ = SkillManager.getInstance.getSkillById(param1[_loc3_].skills[_loc5_].id);
               _loc4_.addSkill(_loc6_);
               _loc5_++;
            }
            _loc2_.push(_loc4_);
            _loc3_++;
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

