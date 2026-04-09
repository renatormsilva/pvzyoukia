package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   import entity.Tool;
   
   public class StoneGatesCData implements IVo
   {
      
      private var challege_count:int;
      
      private var sIcons:Vector.<StoneGateData> = null;
      
      private var m_star:int;
      
      private var m_starAll:int;
      
      private var m_GetRawards:Array;
      
      public function StoneGatesCData()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:StoneGateData = null;
         var _loc2_:Object = param1.caves;
         this.challege_count = param1.cha_count;
         this.m_star = param1.has_star;
         this.m_starAll = param1.tol_star;
         PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(this.challege_count);
         this.sIcons = new Vector.<StoneGateData>();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new StoneGateData();
            _loc4_.decode(_loc3_);
            this.sIcons.push(_loc4_);
         }
      }
      
      public function decodePrizes(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Tool = null;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         this.m_GetRawards = [];
         for each(_loc2_ in param1)
         {
            _loc3_ = new Tool(_loc2_["id"]);
            _loc3_.setNum(_loc2_["num"]);
            this.m_GetRawards.push(_loc3_);
         }
      }
      
      public function getPrizes() : Array
      {
         return this.m_GetRawards;
      }
      
      public function getChallegeCount() : int
      {
         return this.challege_count;
      }
      
      public function getCurrentStar() : int
      {
         return this.m_star;
      }
      
      public function getAllStar() : int
      {
         return this.m_starAll;
      }
      
      public function getChaptersIconData() : Vector.<StoneGateData>
      {
         return this.sIcons;
      }
   }
}

