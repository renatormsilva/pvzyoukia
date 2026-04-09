package pvz.copy.mediators
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.managers.GameManager;
   import core.managers.ResLoaderManager;
   import core.managers.TimerManager;
   import core.ui.panel.BaseMediator;
   import manager.LangManager;
   import pvz.copy.models.stone.StoneCData;
   import pvz.copy.models.stone.StoneCopyData;
   import pvz.copy.models.stone.StoneGateData;
   import pvz.copy.models.stone.StoneGatesCData;
   import pvz.copy.models.stone.StoneRankingCData;
   import pvz.copy.models.stone.StoneRewardCData;
   import pvz.copy.models.stone.StoneSceneData;
   import pvz.copy.ui.panels.StonePanel;
   import pvz.copy.ui.panels.StoneRankingPanel;
   import pvz.copy.ui.scene.StoneScene;
   import pvz.copy.ui.windows.StoneRewardWindow;
   import pvz.hunting.window.BattleReadyWindow;
   
   public class StoneMediator extends BaseMediator
   {
      
      public static var COPY_STONE_SCENE_INIT:int = 0;
      
      public static var COPY_STONE_OPEN_CHAPTER:int = 1;
      
      public static var COPY_STONE_OPEN_PRIZE:int = 2;
      
      public static var COPY_STONE_GET_PRIZE:int = 3;
      
      public static var COPY_STONE_OPEN_RANKING:int = 4;
      
      public static var COPY_STONE_BUY_BATTLE_NUM:int = 5;
      
      public static var COPY_STONE_THROUHG_PRIZES:int = 6;
      
      public static var COPY_STONE_ADD_BATTLE_NUM:int = 7;
      
      public static var COPY_STONE_EXCHANGE_BATTLE_NUM:int = 8;
      
      private var m_stonedata:StoneCData;
      
      private var m_chapterId:int;
      
      private var m_backCall:Function;
      
      public function StoneMediator(param1:Function = null)
      {
         super();
         this.m_stonedata = new StoneCData();
         this.m_backCall = param1;
         this.request();
      }
      
      private function request() : void
      {
         LangManager.getInstance().doLoad(LangManager.MODE_COPY);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_GETCHAPINFO,COPY_STONE_SCENE_INIT);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         switch(param3)
         {
            case COPY_STONE_SCENE_INIT:
               _loc5_.call(param2,param3);
               break;
            case COPY_STONE_OPEN_CHAPTER:
               _loc5_.callO(param2,param3,rest[0]);
               break;
            case COPY_STONE_OPEN_PRIZE:
               _loc5_.callO(param2,param3,rest[0]);
               break;
            case COPY_STONE_GET_PRIZE:
               _loc5_.callO(param2,param3,rest[0]);
               break;
            case COPY_STONE_OPEN_RANKING:
               _loc5_.callO(param2,param3,rest[0]);
               break;
            case COPY_STONE_BUY_BATTLE_NUM:
               _loc5_.callO(param2,param3,rest[0]);
               break;
            case COPY_STONE_THROUHG_PRIZES:
               _loc5_.callO(param2,param3,rest[0]);
               break;
            case COPY_STONE_ADD_BATTLE_NUM:
               _loc5_.call(param2,param3);
               break;
            case COPY_STONE_EXCHANGE_BATTLE_NUM:
               _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var ResLoadedCall:Function;
         var backCall:Function;
         var sdata:StoneSceneData = null;
         var cdata:StoneGatesCData = null;
         var rdata:StoneRewardCData = null;
         var rewardwindow:StoneRewardWindow = null;
         var prizes:Array = null;
         var rankdata:StoneRankingCData = null;
         var rankwindow:StoneRankingPanel = null;
         var chapter:StonePanel = null;
         var scene:StoneScene = null;
         var namestr:String = null;
         var sp:StonePanel = null;
         var scd:StoneGatesCData = null;
         var count:int = 0;
         var namest:String = null;
         var type:int = param1;
         var re:Object = param2;
         PlantsVsZombies.showDataLoading(false);
         switch(type)
         {
            case COPY_STONE_SCENE_INIT:
               ResLoadedCall = function():void
               {
                  var _loc1_:StoneScene = getView(StoneScene) as StoneScene;
                  _loc1_.updata(sdata);
                  _loc1_.onIconClickCall = openChapter;
                  _loc1_.onAllCloseCall = clearView;
                  _loc1_.onBuyBattleNumCall = buyBattleNum;
                  _loc1_.onExchangeBattleNumCall = exchangeBattleNum;
               };
               sdata = this.m_stonedata.getScenedata();
               sdata.decode(re);
               TimerManager.addTimerManager(sdata.getNextTime(),PlantsVsZombies.playerManager.getPlayer().getStoneChaCount());
               ResLoaderManager.LoadSwfResByXml(ResLoadedCall,GameManager.getInstance().toplayer,GlobalConstants.PVZ_RES_BASE_URL,"config/load/copy/stone.xml");
               break;
            case COPY_STONE_OPEN_CHAPTER:
               backCall = function():void
               {
                  var _loc1_:StonePanel = getView(StonePanel) as StonePanel;
                  _loc1_.max_buy_num = m_stonedata.getScenedata().getBuyMaxChallegeCount();
                  _loc1_.changeUI(m_chapterId);
                  _loc1_.updata(cdata);
                  _loc1_.onGetPrizeCall = getThroughPrizes;
                  _loc1_.onCaveClickCall = openGating;
                  _loc1_.onRewardsClickCall = openPrizes;
                  _loc1_.onRankingClickCall = openRanking;
                  _loc1_.onBuyBattleNumCall = buyBattleNum;
                  _loc1_.onExchangeBattleNumCall = exchangeBattleNum;
               };
               cdata = this.m_stonedata.getGatesCData();
               cdata.decode(re);
               ResLoaderManager.LoadSwfResByXml(backCall,GameManager.getInstance().toplayer,GlobalConstants.PVZ_RES_BASE_URL,"config/load/copy/panels/panel_" + this.m_chapterId + ".xml");
               break;
            case COPY_STONE_OPEN_PRIZE:
               rdata = this.m_stonedata.getRewardCData();
               rdata.decodeInfo(re);
               rewardwindow = this.getView(StoneRewardWindow) as StoneRewardWindow;
               rewardwindow.updata(rdata);
               rewardwindow.onGetPrizeCall = this.getPrizes;
               rewardwindow.onUpdataRewardCall = this.openPrizes;
               break;
            case COPY_STONE_GET_PRIZE:
               rdata = this.m_stonedata.getRewardCData();
               rdata.decodeGetPrize(re);
               prizes = rdata.getPrizes();
               rewardwindow = this.getView(StoneRewardWindow) as StoneRewardWindow;
               rewardwindow.portGetPrizes(prizes);
               break;
            case COPY_STONE_OPEN_RANKING:
               rankdata = this.m_stonedata.getRankingData();
               rankdata.decode(re);
               rankwindow = this.getView(StoneRankingPanel) as StoneRankingPanel;
               rankwindow.updata(rankdata);
               break;
            case COPY_STONE_BUY_BATTLE_NUM:
               chapter = this.getView(StonePanel) as StonePanel;
               scene = this.getView(StoneScene) as StoneScene;
               this.m_stonedata.getScenedata().setBuyMaxChallegeCount(re.can_buy_count);
               chapter.updataBattleNum(int(re.cha_count));
               scene.updataBattleNum(int(re.cha_count));
               chapter.max_buy_num = re.can_buy_count;
               scene.max_buy_num = re.can_buy_count;
               PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(re.cha_count);
               PlantsVsZombies.playerManager.getPlayer().setRMB(re.money);
               PlantsVsZombies.setUserInfosNum();
               namestr = LangManager.getInstance().getLanguage("copy011",re.cus_money,re.buy_count);
               PlantsVsZombies.showSystemErrorInfo(namestr);
               break;
            case COPY_STONE_THROUHG_PRIZES:
               sp = this.getView(StonePanel) as StonePanel;
               scd = this.m_stonedata.getGatesCData();
               scd.decodePrizes(re);
               sp.portGetPrizes(scd.getPrizes());
               break;
            case COPY_STONE_ADD_BATTLE_NUM:
               chapter = this.getView(StonePanel) as StonePanel;
               scene = this.getView(StoneScene) as StoneScene;
               chapter.updataBattleNum(int(re.cha_count));
               scene.updataBattleNum(int(re.cha_count));
               PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(re.cha_count);
               TimerManager.addTimerManager(re.next_time,PlantsVsZombies.playerManager.getPlayer().getStoneChaCount());
               break;
            case COPY_STONE_EXCHANGE_BATTLE_NUM:
               chapter = this.getView(StonePanel) as StonePanel;
               scene = this.getView(StoneScene) as StoneScene;
               count = PlantsVsZombies.playerManager.getPlayer().getStoneChaCount() + re.effect;
               PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(count);
               chapter.updataBattleNum(PlantsVsZombies.playerManager.getPlayer().getStoneChaCount());
               scene.updataBattleNum(PlantsVsZombies.playerManager.getPlayer().getStoneChaCount());
               namest = LangManager.getInstance().getLanguage("copy016",re.effect,re.effect);
               PlantsVsZombies.showSystemErrorInfo(namest);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function openChapter(param1:int) : void
      {
         this.m_chapterId = param1;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_GETCAVEINFO,COPY_STONE_OPEN_CHAPTER,this.m_chapterId);
      }
      
      private function openGating(param1:StoneGateData) : void
      {
         var end:Function = null;
         var update:Function = null;
         var enterChapter:Function = null;
         var gatedata:StoneGateData = param1;
         end = function():void
         {
            var _loc1_:BattleReadyWindow = new BattleReadyWindow(BattleReadyWindow.JEWEL_BATTLE);
            _loc1_.show(gatedata.getId(),StoneCopyData.getEmamysByCurrentStarLevel(gatedata.getStar()),update,null,null,0);
         };
         update = function(param1:String):void
         {
            var _loc2_:String = null;
            if(param1 != null)
            {
               _loc2_ = LangManager.getInstance().getLanguage("copy008",param1);
               PlantsVsZombies.showSystemErrorInfo(_loc2_,enterChapter);
               return;
            }
            enterChapter();
         };
         enterChapter = function():void
         {
            var _loc1_:StonePanel = getView(StonePanel) as StonePanel;
            _loc1_.onExchangeHandler();
            openChapter(m_chapterId);
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_GETCHAPINFO,COPY_STONE_SCENE_INIT);
         };
         if(gatedata == null)
         {
            throw new Error("关卡数据有错");
         }
         StoneCopyData.setCurrentaCp(gatedata);
         DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_BATTLE_READY_WINDOW,end);
      }
      
      private function openPrizes() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_PRIZESINFO,COPY_STONE_OPEN_PRIZE,this.m_chapterId);
      }
      
      private function getPrizes() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_PRIZESGET,COPY_STONE_GET_PRIZE,this.m_chapterId);
      }
      
      private function openRanking() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_RANKINGINFO,COPY_STONE_OPEN_RANKING,this.m_chapterId);
      }
      
      private function buyBattleNum(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_ADD_BATTLE_NUM,COPY_STONE_BUY_BATTLE_NUM,param1);
      }
      
      private function getThroughPrizes(param1:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_GET_THROUGH_PRIZES,COPY_STONE_THROUHG_PRIZES,param1);
      }
      
      private function exchangeBattleNum(param1:int, param2:int) : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TOOLS_USE,COPY_STONE_EXCHANGE_BATTLE_NUM,param1,param2);
      }
      
      private function clearView() : void
      {
         this.removeView(StoneScene);
         this.removeView(StonePanel);
         this.removeView(StoneRewardWindow);
         this.removeView(StoneRankingPanel);
         super.clear();
         this.m_stonedata = null;
         if(this.m_backCall != null)
         {
            this.m_backCall();
         }
      }
   }
}

