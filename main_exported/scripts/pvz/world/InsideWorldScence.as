package pvz.world
{
   import entity.Tool;
   import manager.PlayerManager;
   import utils.Singleton;
   
   public class InsideWorldScence
   {
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _checkpoints:Array = null;
      
      public function InsideWorldScence()
      {
         super();
         this._checkpoints = new Array();
      }
      
      public function changeCheckpointType(param1:Checkpoint) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpoints.length)
         {
            if(this._checkpoints[_loc2_].getId() == param1.getId())
            {
               this._checkpoints[_loc2_] = param1;
            }
            _loc2_++;
         }
      }
      
      public function getCheckPoint(param1:int) : Checkpoint
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpoints.length)
         {
            if(this._checkpoints[_loc2_].getId() == param1)
            {
               return this._checkpoints[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function isExistent(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpoints.length)
         {
            if((this._checkpoints[_loc2_] as Checkpoint).getId() == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function isOpenCheckpoint(param1:Checkpoint) : Boolean
      {
         var _loc3_:Tool = null;
         var _loc4_:Tool = null;
         if(param1.getOpenTools() == null || param1.getOpenTools().length < 1)
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.getOpenTools().length)
         {
            _loc3_ = param1.getOpenTools()[_loc2_];
            _loc4_ = this.playerManager.getPlayer().getTool(_loc3_.getOrderId());
            if(_loc4_ == null || _loc4_.getNum() < _loc3_.getNum())
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function passCheckpoint(param1:int) : Array
      {
         var _loc2_:Checkpoint = this.getCheckPoint(param1);
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.getDownlinks().length)
         {
            if(this.isToCheckPoint(_loc2_.getDownlinks()[_loc4_]))
            {
               _loc3_.push(_loc2_.getDownlinks()[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function pushCheckpoint(param1:Checkpoint) : void
      {
         this._checkpoints.push(param1);
      }
      
      private function isToCheckPoint(param1:int) : Boolean
      {
         var _loc2_:Checkpoint = this.getCheckPoint(param1);
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.getUplinks().length)
         {
            if(!this.getCheckPoint(_loc2_.getUplinks()[_loc3_]).getIsPass())
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
   }
}

