package pvz.world.repetition
{
   import core.ui.panel.BaseWindow;
   import flash.events.Event;
   import pvz.world.repetition.repetData.RankingData;
   import pvz.world.repetition.ui.RankingPanel;
   
   public class RankingControl extends BaseWindow
   {
      
      private var ranking:RankingPanel;
      
      private var rankingData:RankingData;
      
      private var areaType:int;
      
      private var rankingType:int = RankingPanel.COMPLETE_DEGREE_RANKING;
      
      public function RankingControl(param1:int)
      {
         super();
         this.areaType = param1;
         this.initView();
      }
      
      public function initView() : void
      {
         if(this.ranking == null)
         {
            this.ranking = new RankingPanel();
         }
         if(this.rankingData == null)
         {
            this.rankingData = new RankingData();
         }
         PlantsVsZombies._node.addChild(this.ranking);
         onShowEffectBig(this.ranking);
         this.ranking.firtAttackClickFunc = this.fristAttackFunc;
         this.ranking.honorRankClickFunc = this.honorRankFunc;
         this.ranking.completeDegreeClickFunc = this.completeDegreeFunc;
         this.ranking.closeClickFunc = this.closeWindowFunc;
         this.rankingData.initPanelData(RankingData.COMPLETE_DEGREE_RANKING,this.areaType);
         this.rankingData.addEventListener(Event.CHANGE,this.changeUiData);
      }
      
      private function changeUiData(param1:Event) : void
      {
         this.ranking.initDisplayScence(this.rankingType,this.areaType,this.rankingData.rankData);
      }
      
      private function fristAttackFunc() : void
      {
         this.rankingType = RankingPanel.ATTACK_FIRST_RANKING;
         this.rankingData.initPanelData(RankingData.ATTACK_FIRST_RANKING,this.areaType);
      }
      
      private function honorRankFunc() : void
      {
         this.rankingType = RankingPanel.HONOR_RANKING;
         this.rankingData.initPanelData(RankingData.HONOR_RANKING,this.areaType);
      }
      
      private function completeDegreeFunc() : void
      {
         this.rankingType = RankingPanel.COMPLETE_DEGREE_RANKING;
         this.rankingData.initPanelData(RankingData.COMPLETE_DEGREE_RANKING,this.areaType);
      }
      
      private function closeWindowFunc() : void
      {
         onHiddenEffectBig(this.ranking,this.clearRankPanel);
      }
      
      private function clearRankPanel() : void
      {
         this.ranking.destroy();
         this.rankingData.removeEventListener(Event.CHANGE,this.changeUiData);
         this.rankingData = null;
         PlantsVsZombies._node.removeChild(this.ranking);
         this.ranking = null;
      }
   }
}

