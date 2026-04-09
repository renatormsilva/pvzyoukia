package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   
   public class StoneRankingCData implements IVo
   {
      
      private var ranks:Array = null;
      
      private var m_rankid:int = 1;
      
      private var m_has_star:int;
      
      private var m_tol_star:int;
      
      public function StoneRankingCData()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:StoneRankingData = null;
         var _loc2_:Object = param1.ranks;
         this.m_rankid = param1.chap_id;
         this.m_has_star = param1.has_star;
         this.m_tol_star = param1.tol_star;
         this.ranks = [];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new StoneRankingData();
            _loc4_.decode(_loc3_);
            this.ranks.push(_loc4_);
         }
      }
      
      public function getChapterId() : int
      {
         return this.m_rankid;
      }
      
      public function getHasStar() : int
      {
         return this.m_has_star;
      }
      
      public function getAllStar() : int
      {
         return this.m_tol_star;
      }
      
      public function getRankData() : Array
      {
         return this.ranks;
      }
   }
}

