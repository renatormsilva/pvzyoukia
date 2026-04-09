package pvz.newTask.data
{
   public class NewTaskVo
   {
      
      private var _mainTask:Array;
      
      private var _sideTask:Array;
      
      private var _dailyTask:Array;
      
      private var _activeTask:Array;
      
      public function NewTaskVo()
      {
         super();
      }
      
      public function mainTaskDecode(param1:Object) : void
      {
         this._mainTask = this.decodeTask(param1);
      }
      
      public function sideTaskDecode(param1:Object) : void
      {
         this._sideTask = this.decodeTask(param1);
      }
      
      public function dailyTaskDecode(param1:Object) : void
      {
         this._dailyTask = this.decodeTask(param1);
      }
      
      public function activeTaskDecode(param1:Object) : void
      {
         this._activeTask = this.decodeTask(param1);
      }
      
      public function getMainTask() : Array
      {
         if(!this._mainTask)
         {
            this._mainTask = [];
         }
         return this._mainTask;
      }
      
      public function getSideTask() : Array
      {
         if(!this._sideTask)
         {
            this._sideTask = [];
         }
         return this._sideTask;
      }
      
      public function getDailyTask() : Array
      {
         if(!this._dailyTask)
         {
            this._dailyTask = [];
         }
         return this._dailyTask;
      }
      
      public function getActiveTask() : Array
      {
         if(!this._activeTask)
         {
            this._activeTask = [];
         }
         return this._activeTask;
      }
      
      private function decodeTask(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:TaskVo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc5_ = new TaskVo();
            _loc5_.decode(_loc3_);
            _loc2_.push(_loc5_);
         }
         return this.sort(_loc2_);
      }
      
      private function sort(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:TaskVo = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(Boolean(param1[_loc3_]) && Boolean(param1[_loc3_ + 1]) && TaskVo(param1[_loc3_]).state < TaskVo(param1[_loc3_ + 1]).state)
               {
                  _loc4_ = param1[_loc3_];
                  param1[_loc3_] = param1[_loc3_ + 1];
                  param1[_loc3_ + 1] = _loc4_;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return param1;
      }
      
      public function getIsOver(param1:int = 1) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:TaskVo = null;
         switch(param1)
         {
            case 1:
               _loc2_ = this.getMainTask();
               break;
            case 2:
               _loc2_ = this.getSideTask();
               break;
            case 3:
               _loc2_ = this.getDailyTask();
               break;
            case 4:
               _loc2_ = this.getActiveTask();
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.state == 1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getIsTasks() : Boolean
      {
         if(Boolean(this._mainTask) && Boolean(this._mainTask.length > 0) || Boolean(this._sideTask) && Boolean(this._sideTask.length > 0) || Boolean(this._dailyTask) && Boolean(this._dailyTask.length > 0) || Boolean(this._activeTask) && Boolean(this._activeTask.length > 0))
         {
            return true;
         }
         return false;
      }
   }
}

