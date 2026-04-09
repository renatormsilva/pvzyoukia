package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   import entity.Tool;
   
   public class StoneRewardData implements IVo
   {
      
      private var m_awardTools:Array = null;
      
      private var m_needStar:int;
      
      private var m_is_rewarded:int;
      
      public function StoneRewardData()
      {
         super();
      }
      
      public function setAwards(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Tool = null;
         this.m_awardTools = [];
         for each(_loc2_ in param1)
         {
            _loc3_ = new Tool(_loc2_.id);
            _loc3_.setNum(_loc2_.num);
            this.m_awardTools.push(_loc3_);
         }
      }
      
      public function getAwardTools() : Array
      {
         return this.m_awardTools;
      }
      
      public function getNeedStar() : int
      {
         return this.m_needStar;
      }
      
      public function getRewardType() : int
      {
         return this.m_is_rewarded;
      }
      
      public function decode(param1:Object) : void
      {
         this.m_needStar = param1.cuurent;
         this.m_is_rewarded = param1.is_rewarded;
         this.setAwards(param1.tools);
      }
   }
}

