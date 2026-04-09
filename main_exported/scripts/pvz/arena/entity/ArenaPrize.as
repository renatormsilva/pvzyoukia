package pvz.arena.entity
{
   public class ArenaPrize
   {
      
      internal var isGet:Boolean = false;
      
      internal var rankMax:int = 0;
      
      internal var rankMin:int = 0;
      
      internal var tools:Array = null;
      
      public function ArenaPrize()
      {
         super();
      }
      
      public function setIsGet(param1:Boolean) : void
      {
         this.isGet = param1;
      }
      
      public function getIsGet() : Boolean
      {
         return this.isGet;
      }
      
      public function setRankMax(param1:int) : void
      {
         this.rankMax = param1;
      }
      
      public function getRankMax() : int
      {
         return this.rankMax;
      }
      
      public function setRankMin(param1:int) : void
      {
         this.rankMin = param1;
      }
      
      public function getRankMin() : int
      {
         return this.rankMin;
      }
      
      public function setTools(param1:Array) : void
      {
         this.tools = param1;
      }
      
      public function getTools() : Array
      {
         return this.tools;
      }
   }
}

