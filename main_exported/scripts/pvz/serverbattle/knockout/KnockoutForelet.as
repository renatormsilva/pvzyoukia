package pvz.serverbattle.knockout
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.battle.fore.Battlefield;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.serverbattle.entity.PlayerInfo;
   import pvz.serverbattle.fport.KnockoutFPort;
   import pvz.serverbattle.knockout.guess.GuessPanel;
   import pvz.serverbattle.knockout.guessResult.GuessResultWindow;
   import pvz.serverbattle.knockout.rankingRewards.RankingRewardsWindow;
   import pvz.serverbattle.knockout.scene.GuessButton;
   import pvz.serverbattle.knockout.scene.LineAndPlayerNodeManager;
   import pvz.serverbattle.knockout.scene.Pothunter;
   import pvz.serverbattle.qualifying.GetQualifyingRewardsWindow;
   import pvz.serverbattle.qualifying.RuleWindow;
   import pvz.serverbattle.shop.MedalShopWindow;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.ReBuidBitmap;
   import utils.Singleton;
   import zmyth.res.IDestroy;
   import zmyth.ui.TextFilter;
   
   public class KnockoutForelet extends BaseWindow implements IDestroy
   {
      
      private static var _node:MovieClip;
      
      private var knckoutfp:KnockoutFPort;
      
      private var buttonsXY:Array = [[1,1],[1,5],[1,9],[1,13],[2.5,3],[2.5,11],[3.6,7],[6.8,7]];
      
      private var pothunter:Pothunter;
      
      private var pothuntersArr:Array = [];
      
      private var buttonsArr:Array = [];
      
      private var vessel:Sprite;
      
      private var buttons:Sprite;
      
      private var lineManager:LineAndPlayerNodeManager;
      
      private var nextCompeteTime:String;
      
      private var timepanel:MovieClip;
      
      private var ruleButton:SimpleButton;
      
      private var nowdayGuessNum:Sprite;
      
      private var backGround:ReBuidBitmap;
      
      private var servernameid:int;
      
      private var myGuess:String;
      
      private var exploitShopButton:SimpleButton;
      
      private var guessprizeButton:SimpleButton;
      
      private var rankprizesButton:SimpleButton;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var serverNameNode:MovieClip;
      
      private var isEnd:int;
      
      public function KnockoutForelet(param1:MovieClip)
      {
         super();
         _node = param1;
         this.initUi();
         this.createConnect();
      }
      
      private function createConnect() : void
      {
         if(this.knckoutfp == null)
         {
            this.knckoutfp = new KnockoutFPort(this);
         }
         PlantsVsZombies.showDataLoading(true);
         this.knckoutfp.initPanelData(KnockoutFPort.INIT);
      }
      
      public function initData(param1:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.pothuntersArr = this.knckoutfp.getUsersPretendData(param1);
         this.buttonsArr = this.knckoutfp.getGroupsData(param1);
         this.nextCompeteTime = param1.next_stime;
         this.servernameid = param1.serverGroup;
         this.myGuess = param1.myGuess;
         this.isEnd = param1.isEnd;
         this.judgeHasGetedPrize(param1.award_status);
         this.initKnockoutPanel();
      }
      
      private function judgeHasGetedPrize(param1:int) : void
      {
         if(this.rankprizesButton != null)
         {
            if(this.vessel.contains(this.rankprizesButton))
            {
               this.vessel.removeChild(this.rankprizesButton);
            }
         }
         if(param1 == 1)
         {
            this.rankprizesButton = GetDomainRes.getSimpleButton("serverbattle.prizesButton");
            this.rankprizesButton.name = "prizesButton";
            this.vessel.addChild(this.rankprizesButton);
            --this.guessprizeButton.y;
            this.rankprizesButton.x = this.guessprizeButton.x + this.guessprizeButton.width;
         }
         else
         {
            this.rankprizesButton = GetDomainRes.getSimpleButton("serverbattle.rankprizesButton");
            this.rankprizesButton.name = "rankprizesButton";
            this.vessel.addChild(this.rankprizesButton);
            this.rankprizesButton.y = this.guessprizeButton.y - 10;
            this.rankprizesButton.x = this.guessprizeButton.x + this.guessprizeButton.width;
         }
      }
      
      private function initUi() : void
      {
         if(this.vessel == null)
         {
            this.vessel = new Sprite();
         }
         if(this.buttons == null)
         {
            this.buttons = new Sprite();
         }
         if(this.backGround == null)
         {
            this.backGround = new ReBuidBitmap("serverBattle.knockout.bottomPanel");
         }
         if(this.nowdayGuessNum == null)
         {
            this.nowdayGuessNum = GetDomainRes.getSprite("serverBattle.knockout.guessNum");
         }
         if(this.ruleButton == null)
         {
            this.ruleButton = GetDomainRes.getSimpleButton("serverBattle.knockout.ruleButton");
         }
         if(this.guessprizeButton == null)
         {
            this.guessprizeButton = GetDomainRes.getSimpleButton("serverbattle.guessButton");
            this.guessprizeButton.name = "guessprizeButton";
            this.guessprizeButton.x = 260;
            this.guessprizeButton.y = 441;
         }
         if(this.exploitShopButton == null)
         {
            this.exploitShopButton = GetDomainRes.getSimpleButton("serverbattle.exploitshopButton");
            this.exploitShopButton.name = "exploitShopButton";
            this.exploitShopButton.x = 415;
            this.exploitShopButton.y = this.guessprizeButton.y - 2;
         }
         _node.addChild(this.vessel);
         this.vessel.addChildAt(this.backGround,0);
         this.vessel.addChild(this.guessprizeButton);
         this.vessel.addChild(this.exploitShopButton);
         this.vessel.addChild(this.buttons);
         this.vessel.addChild(this.nowdayGuessNum);
         this.vessel.addChild(this.ruleButton);
      }
      
      private function initKnockoutPanel() : void
      {
         if(this.lineManager == null)
         {
            this.lineManager = new LineAndPlayerNodeManager(this.vessel,this.pothuntersArr);
         }
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.getGuessNumFormat());
         _loc1_.x = -_loc1_.width / 2;
         FuncKit.clearAllChildrens(this.nowdayGuessNum["num"]);
         this.nowdayGuessNum["num"].addChild(_loc1_);
         this.nowdayGuessNum.y = this.ruleButton.y = 20;
         this.ruleButton.x = this.nowdayGuessNum.width + 10;
         if(this.serverNameNode == null)
         {
            this.serverNameNode = GetDomainRes.getMoveClip("serverBattle.knockout.seversubarea");
            this.serverNameNode.x = 350;
            this.serverNameNode.y = 100;
            this.vessel.addChild(this.serverNameNode);
         }
         this.serverNameNode.gotoAndStop(this.servernameid);
         this.setStartTime();
         this.initButtonsPut();
         this.addButtonEventHandler();
      }
      
      private function getGuessNumFormat() : String
      {
         var _loc1_:String = "c";
         var _loc2_:RegExp = /\//;
         return this.myGuess.replace(_loc2_,_loc1_);
      }
      
      private function setStartTime() : void
      {
         if(this.timepanel == null)
         {
            this.timepanel = GetDomainRes.getMoveClip("serverBattle.knockout.nextBattleTime");
            TextFilter.MiaoBian(this.timepanel["times"],0);
            this.timepanel["times"].selectable = false;
            this.timepanel.x = 380;
            this.timepanel.y = 355;
         }
         if(this.isEnd)
         {
            this.timepanel.gotoAndStop(2);
         }
         else
         {
            this.timepanel.gotoAndStop(1);
         }
         this.timepanel["times"].text = this.nextCompeteTime;
         this.vessel.addChild(this.timepanel);
      }
      
      private function addButtonEventHandler() : void
      {
         this.buttons.addEventListener(MouseEvent.CLICK,this.onClick);
         this.ruleButton.addEventListener(MouseEvent.CLICK,this.onRuleClick);
         this.exploitShopButton.addEventListener(MouseEvent.CLICK,this.onButtonClickHandler);
         this.guessprizeButton.addEventListener(MouseEvent.CLICK,this.onButtonClickHandler);
         this.rankprizesButton.addEventListener(MouseEvent.CLICK,this.onButtonClickHandler);
      }
      
      private function removeButtonEventHandler() : void
      {
         this.buttons.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.ruleButton.removeEventListener(MouseEvent.CLICK,this.onRuleClick);
         this.exploitShopButton.removeEventListener(MouseEvent.CLICK,this.onButtonClickHandler);
         this.guessprizeButton.removeEventListener(MouseEvent.CLICK,this.onButtonClickHandler);
         this.rankprizesButton.removeEventListener(MouseEvent.CLICK,this.onButtonClickHandler);
      }
      
      private function onButtonClickHandler(param1:MouseEvent) : void
      {
         var upDataMedal:Function;
         var e:MouseEvent = param1;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(e.currentTarget.name == "exploitShopButton")
         {
            new MedalShopWindow(null);
         }
         else if(e.currentTarget.name == "guessprizeButton")
         {
            new GuessResultWindow(this.changeGuessButtonType);
         }
         else if(e.currentTarget.name == "rankprizesButton")
         {
            new RankingRewardsWindow();
         }
         else if(e.currentTarget.name == "prizesButton")
         {
            upDataMedal = function():void
            {
               changeGuessButtonType();
            };
            new GetQualifyingRewardsWindow(upDataMedal);
         }
      }
      
      private function onRuleClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         new RuleWindow(RuleWindow.KNOCKOUT_RULE);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:GuessButton = param1.target.parent.parent as GuessButton;
         if(_loc2_ == null)
         {
            return;
         }
         switch(_loc2_.status)
         {
            case KnockoutFPort.CAN_GUESS:
               new GuessPanel(_loc2_.id,this.changeGuessButtonType);
               break;
            case KnockoutFPort.ALREADY_GUESSED:
               new GuessResultWindow(this.changeGuessButtonType,GuessResultWindow.ALL_GUESSED);
               break;
            case KnockoutFPort.EXAMAINE_BATTLE:
               PlantsVsZombies.showDataLoading(true);
               this.knckoutfp.initPanelData(KnockoutFPort.FIGHT_EXAMINE,_loc2_.id);
         }
      }
      
      private function changeGuessButtonType(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:GuessButton = null;
         while(this.buttons.numChildren > 0)
         {
            _loc3_ = this.buttons.getChildAt(0) as GuessButton;
            _loc3_.destroy();
         }
         this.createConnect();
      }
      
      public function exmineFight(param1:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc2_:BattlefieldControlManager = new BattlefieldControlManager();
         _loc2_.doBattleInfosRPC(param1.fightLog,BattlefieldControlManager.SERVERBATTLE);
         _loc2_.integralAdd = param1.upi;
         var _loc3_:Array = _loc2_.getMyOrgs(param1.fightLog);
         var _loc4_:Array = _loc2_.getEnemyOrgs(param1.fightLog);
         var _loc5_:PlayerInfo = this.knckoutfp.getPlayersInfo(param1);
         new Battlefield(_loc3_,_loc4_,_loc2_,null,BattlefieldControlManager.SERVERBATTLE,_loc5_);
      }
      
      private function initButtonsPut() : void
      {
         var _loc2_:GuessButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.buttonsArr.length)
         {
            _loc2_ = this.buttonsArr[_loc1_];
            if(_loc2_.index < 8)
            {
               _loc2_.x = this.buttonsXY[_loc2_.index - 1][0] * this.lineManager.w + this.lineManager.w_span - _loc2_.width / 2;
               _loc2_.y = this.buttonsXY[_loc2_.index - 1][1] * this.lineManager.h + this.lineManager.h_span - _loc2_.height / 2;
            }
            else
            {
               _loc2_.x = PlantsVsZombies.WIDTH - (this.buttonsXY[_loc2_.index - 8][0] * this.lineManager.w + this.lineManager.w_span) - _loc2_.width / 2;
               _loc2_.y = this.buttonsXY[_loc2_.index - 8][1] * this.lineManager.h + this.lineManager.h_span - _loc2_.height / 2;
            }
            this.buttons.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:GuessButton = null;
         while(this.buttons.numChildren > 0)
         {
            _loc1_ = this.buttons.getChildAt(0) as GuessButton;
            _loc1_.destroy();
         }
         this.lineManager.destroy();
         this.backGround.dispose();
         FuncKit.clearAllChildrens(this.vessel);
         this.removeButtonEventHandler();
         this.nowdayGuessNum = null;
         this.exploitShopButton = null;
         this.guessprizeButton = null;
         this.rankprizesButton = null;
         this.pothuntersArr = null;
         this.buttonsArr = null;
         this.vessel = null;
         this.buttons = null;
         _node = null;
      }
   }
}

