package entity
{
   public class LevelUpInfo
   {
      
      private var _max_cave:int;
      
      private var _currentLevel:int;
      
      private var _money:Number;
      
      private var _tools:Array;
      
      public function LevelUpInfo()
      {
         super();
      }
      
      public function readData(param1:Object) : void
      {
         this._max_cave = param1.max_cave;
         this._currentLevel = param1.id;
         this._money = param1.money;
         this.setTools(param1.tools);
      }
      
      private function setTools(param1:Array) : void
      {
         var _loc2_:Tool = null;
         var _loc3_:Object = null;
         this._tools = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_ = new Tool(_loc3_.id);
            _loc2_.setNum(_loc3_.amount);
            this._tools.push(_loc2_);
         }
      }
      
      public function getTools() : Array
      {
         return this._tools;
      }
      
      public function getMoney() : Number
      {
         return this._money;
      }
      
      public function getCurrentLevel() : int
      {
         return this._currentLevel;
      }
      
      public function getMaxCave() : int
      {
         return this._max_cave;
      }
   }
}

