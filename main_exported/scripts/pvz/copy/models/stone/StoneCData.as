package pvz.copy.models.stone
{
   public class StoneCData
   {
      
      public static var openned:int = 1;
      
      public static var openning:int = 2;
      
      public static var closing:int = 3;
      
      public static var refresh_chapter_1:int = 1;
      
      public static var refresh_chapter_2:int = 2;
      
      private var m_scenedata:StoneSceneData;
      
      private var m_chapterdata:StoneGatesCData;
      
      private var m_rewarddata:StoneRewardCData;
      
      private var m_rankdata:StoneRankingCData;
      
      public function StoneCData()
      {
         super();
      }
      
      public function getScenedata() : StoneSceneData
      {
         if(this.m_scenedata == null)
         {
            this.m_scenedata = new StoneSceneData();
         }
         return this.m_scenedata;
      }
      
      public function getGatesCData() : StoneGatesCData
      {
         if(this.m_chapterdata == null)
         {
            this.m_chapterdata = new StoneGatesCData();
         }
         return this.m_chapterdata;
      }
      
      public function getRewardCData() : StoneRewardCData
      {
         if(this.m_rewarddata == null)
         {
            this.m_rewarddata = new StoneRewardCData();
         }
         return this.m_rewarddata;
      }
      
      public function getRankingData() : StoneRankingCData
      {
         if(this.m_rankdata == null)
         {
            this.m_rankdata = new StoneRankingCData();
         }
         return this.m_rankdata;
      }
   }
}

