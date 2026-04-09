package pvz.serverbattle.qualifying
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.battle.fore.Battlefield;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.serverbattle.SeverBattleReadyWindow;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.entity.PlayerInfo;
   import pvz.serverbattle.fport.QualifyingFport;
   import pvz.serverbattle.ranking.ScoreRankWindow;
   import pvz.serverbattle.shop.MedalShopWindow;
   import pvz.serverbattle.tip.AddTimeTips;
   import tip.AdaptTip;
   import tip.ToolsTip;
   import tip.notice.NoticeManager;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.ReBuidBitmap;
   import utils.Singleton;
   import windows.RechargeWindow;
   import zmyth.res.IDestroy;
   
   public class QualityingPanel implements IDestroy
   {
      
      public static var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var playerInfoPanel:Sprite;
      
      private var prizeInfoLeft:Sprite;
      
      private var prizeInfoRight:Sprite;
      
      private var plantsAreaLeft:QualifyRunerWindow;
      
      private var plantsAreaRight:QualifyRunerWindow;
      
      private var searchPlayer:Sprite;
      
      private var endtime:Sprite;
      
      private var backGround:ReBuidBitmap;
      
      private var mainnode:Sprite;
      
      private var qualifyfp:QualifyingFport;
      
      private var meritorious:int;
      
      private var integral:int = 200;
      
      private var remaining_challenges:int = 0;
      
      private var message:Array;
      
      private var qualifyingEndTime:String = "2012-12-10 20:10:00";
      
      private var reward:Array;
      
      private var serverGroup:int;
      
      private var userGroup:int;
      
      private var panelMoveType:int = 1;
      
      private var panelMoveDirect:int = 1;
      
      private var remainChallengesMoney:int;
      
      private var remainChallengesAddNum:int;
      
      private var overTip:AddTimeTips;
      
      private var battleButton:SimpleButton;
      
      private var myInfo:Contestant;
      
      private var otherInfo:Contestant;
      
      private var isOrNotNeedClick:Boolean = true;
      
      private var playfindplayermc:MovieClip;
      
      private var changePlantsButton:SimpleButton;
      
      private var exploitShopButton:SimpleButton;
      
      private var rankButton:SimpleButton;
      
      private var prizesButton:SimpleButton;
      
      private var contain:DisplayObjectContainer;
      
      private var boxtip:ToolsTip;
      
      private var orderPrize:Array = [];
      
      private var addRemainTip:AdaptTip;
      
      private var clickedName:String;
      
      private var _re:Array;
      
      private var getDataBool:Boolean = false;
      
      private var loadingCurFrame:int = 0;
      
      public function QualityingPanel(param1:MovieClip)
      {
         super();
         if(this.mainnode == null)
         {
            this.mainnode = new Sprite();
         }
         if(this.backGround == null)
         {
            this.backGround = new ReBuidBitmap("serverbattle.qualitying.background");
         }
         this.contain = param1;
         this.contain.addChild(this.mainnode);
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         PlantsVsZombies.showDataLoading(true);
         this.mainnode.addChildAt(this.backGround,0);
         this.connectServer();
      }
      
      private function connectServer() : void
      {
         if(this.qualifyfp == null)
         {
            this.qualifyfp = new QualifyingFport(this);
         }
         this.qualifyfp.initPanelData(QualifyingFport.INIT);
      }
      
      public function initData(param1:Object = null) : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.integral = param1.integral;
         this.meritorious = param1.meritorious;
         this.remaining_challenges = param1.remaining_challenges;
         this.message = param1.message;
         this.qualifyingEndTime = param1.qualifyingEndTime;
         this.reward = param1.reward;
         this.serverGroup = param1.serverGroup;
         this.userGroup = param1.userGroup;
         this.remainChallengesMoney = param1.add_count.cost;
         this.remainChallengesAddNum = param1.add_count.n;
         this.suitPretendData();
         this.addButtonHandlerAndButtonMode();
         this.initNotice(param1.messages);
      }
      
      private function initNotice(param1:Array) : void
      {
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         var _loc2_:NoticeManager = NoticeManager.getInstance;
         _loc2_.initNotice(param1,90,100);
         _loc2_.start();
      }
      
      private function addButtonHandlerAndButtonMode() : void
      {
         this.playerInfoPanel["addbattle"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.playerInfoPanel["addbattle"].addEventListener(MouseEvent.ROLL_OVER,this.onExploitOver);
         this.playerInfoPanel["addbattle"].addEventListener(MouseEvent.ROLL_OUT,this.showAddbattleTipOut);
         this.playerInfoPanel["rule"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.playerInfoPanel["message"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.searchPlayer["searchPlayer"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.changePlantsButton.addEventListener(MouseEvent.CLICK,this.onClick);
         this.exploitShopButton.addEventListener(MouseEvent.CLICK,this.onClick);
         this.rankButton.addEventListener(MouseEvent.CLICK,this.onClick);
         this.prizesButton.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeButtonHandlerAndButtonMode() : void
      {
         this.playerInfoPanel["addbattle"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.playerInfoPanel["addbattle"].removeEventListener(MouseEvent.ROLL_OVER,this.onExploitOver);
         this.playerInfoPanel["addbattle"].removeEventListener(MouseEvent.ROLL_OUT,this.showAddbattleTipOut);
         this.playerInfoPanel["rule"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.playerInfoPanel["message"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.searchPlayer["searchPlayer"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.changePlantsButton.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.exploitShopButton.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.rankButton.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.prizesButton.removeEventListener(MouseEvent.CLICK,this.onClick);
         if(this.battleButton != null)
         {
            this.battleButton.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(this.searchPlayer != null)
         {
            if(this.searchPlayer.hasEventListener(MouseEvent.MOUSE_OVER))
            {
               this.searchPlayer.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            }
            if(this.searchPlayer["addnum"].hasEventListener(MouseEvent.CLICK))
            {
               this.searchPlayer["addnum"].removeEventListener(MouseEvent.CLICK,this.onClick);
            }
         }
         if(this.prizeInfoRight != null)
         {
            if(this.prizeInfoRight.hasEventListener(MouseEvent.MOUSE_OVER))
            {
               this.prizeInfoRight.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            }
         }
         if(this.prizeInfoLeft != null)
         {
            if(this.prizeInfoLeft.hasEventListener(MouseEvent.MOUSE_OVER))
            {
               this.prizeInfoLeft.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            }
         }
      }
      
      private function onExploitOver(param1:MouseEvent) : void
      {
         this.showAddbattleTipOver(this.remainChallengesMoney,this.remainChallengesAddNum);
      }
      
      private function showAddbattleTipOver(param1:int, param2:int) : void
      {
         if(this.overTip == null)
         {
            this.overTip = new AddTimeTips(240,30);
         }
         this.overTip.crateHtmlTxt(param1,param2);
         this.overTip.x = this.playerInfoPanel["addbattle"].x + 80;
         this.overTip.y = this.playerInfoPanel["addbattle"].y;
         this.mainnode.addChild(this.overTip);
         this.overTip.visible = true;
      }
      
      private function showAddbattleTipOut(param1:MouseEvent) : void
      {
         if(this.overTip.visible)
         {
            this.overTip.visible = false;
         }
         this.mainnode.removeChild(this.overTip);
      }
      
      public function upDataRemainChallengesMoneyAndNum(param1:Object) : void
      {
         PlantsVsZombies.changeMoneyOrExp(-1 * this.remainChallengesMoney,PlantsVsZombies.RMB,true,false);
         var _loc2_:String = LangManager.getInstance().getLanguage("severBattle003",this.remainChallengesMoney);
         if(this.clickedName == "addbattle")
         {
            this.showAddRemainChallenge(new Point(PlantsVsZombies.WIDTH / 2 - 45,70),new Point(PlantsVsZombies.WIDTH / 2 - 45,10),_loc2_);
         }
         else if(this.clickedName == "addnum")
         {
            this.showAddRemainChallenge(new Point(PlantsVsZombies.WIDTH / 2 - 110,400),new Point(PlantsVsZombies.WIDTH / 2 - 110,300),_loc2_);
         }
         this.remaining_challenges = param1.count;
         this.remainChallengesMoney = param1.cost;
         this.remainChallengesAddNum = param1.n;
         if(this.clickedName == "addbattle")
         {
            this.showAddbattleTipOver(this.remainChallengesMoney,this.remainChallengesAddNum);
         }
         FuncKit.clearAllChildrens(this.playerInfoPanel["battlenum"]);
         var _loc3_:DisplayObject = FuncKit.getNumEffect(this.remaining_challenges + "");
         this.playerInfoPanel["battlenum"].addChild(_loc3_);
         this.upDataSearchPlayerPanel();
      }
      
      private function upDataSearchPlayerPanel() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.remaining_challenges < 1)
         {
            this.searchPlayer["searchPlayer"].visible = false;
            this.searchPlayer["addnum"].visible = true;
            this.searchPlayer["lightMc"].visible = true;
            _loc1_ = LangManager.getInstance().getLanguage("node013");
            _loc2_ = "</font><font color=\'#00ff00\' size=\'15\'>" + this.remainChallengesMoney + _loc1_ + "</font><font color=\'#ffffff\' size=\'15\'>";
            this.searchPlayer["lightMc"]["txt"].htmlText = "<font color=\'#ffffff\' size=\'15\'>" + LangManager.getInstance().getLanguage("severBattle001",_loc2_,this.remainChallengesAddNum) + "</font>";
            this.searchPlayer["addnum"].addEventListener(MouseEvent.CLICK,this.onClick);
         }
         else
         {
            if(this.searchPlayer["addnum"].hasEventListener(MouseEvent.CLICK))
            {
               this.searchPlayer["addnum"].removeEventListener(MouseEvent.CLICK,this.onClick);
            }
            this.searchPlayer["addnum"].visible = false;
            this.searchPlayer["lightMc"].visible = false;
            this.searchPlayer["searchPlayer"].visible = true;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var callBack:Function;
         var recharge:RechargeWindow = null;
         var str:String = null;
         var sever:SeverBattleReadyWindow = null;
         var e:MouseEvent = param1;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(e.currentTarget.name == "addbattle" || e.currentTarget.name == "addnum")
         {
            this.clickedName = e.currentTarget.name;
            if(playerManager.getPlayer().getRMB() < this.remainChallengesMoney || playerManager.getPlayer().getRMB() == 0)
            {
               callBack = function():void
               {
                  PlantsVsZombies.toRecharge();
               };
               recharge = new RechargeWindow();
               str = LangManager.getInstance().getLanguage("window074");
               recharge.init(str,callBack,1);
            }
            else
            {
               this.qualifyfp.initPanelData(QualifyingFport.OVER_ADD_CHANGE_NUM);
            }
         }
         else if(e.currentTarget.name == "rule")
         {
            new RuleWindow();
         }
         else if(e.currentTarget.name == "message")
         {
            new MessageWindow();
         }
         else if(e.currentTarget.name == "battle")
         {
            PlantsVsZombies.showDataLoading(true);
            this.qualifyfp.initPanelData(QualifyingFport.BATTLE_CHALLENGE);
         }
         else if(e.currentTarget.name == "searchPlayer")
         {
            this.panelMoveType = 8;
            this.MoveCl();
         }
         else if(e.currentTarget.name == "changePlantsButton")
         {
            sever = new SeverBattleReadyWindow(this.changeMinePlants);
         }
         else if(e.currentTarget.name == "exploitShopButton")
         {
            new MedalShopWindow(this.upDataMedal);
         }
         else if(e.currentTarget.name == "rankButton")
         {
            new ScoreRankWindow();
         }
         else if(e.currentTarget.name == "prizesButton")
         {
            new GetQualifyingRewardsWindow(this.upDataMedal);
         }
      }
      
      private function changeMinePlants() : void
      {
         if(this.plantsAreaLeft != null)
         {
            this.plantsAreaLeft.setPlantArea(playerManager.getPlayer().getSeverBattleOrgs());
         }
      }
      
      private function upDataMedal(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.playerInfoPanel != null)
         {
            FuncKit.clearAllChildrens(this.playerInfoPanel["exploitnum"]);
            _loc2_ = FuncKit.getNumEffect(param1 + "");
            this.playerInfoPanel["exploitnum"].addChild(_loc2_);
         }
      }
      
      private function showAddRemainChallenge(param1:Point, param2:Point, param3:String) : void
      {
         if(this.addRemainTip == null)
         {
            this.addRemainTip = new AdaptTip(250,30);
         }
         this.addRemainTip.creatInfoText(param3,"","",3);
         this.contain.addChild(this.addRemainTip);
         this.addRemainTip.goAnimate(param1,param2);
      }
      
      public function startBattle(param1:Object = null) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc2_:BattlefieldControlManager = new BattlefieldControlManager();
         _loc2_.doBattleInfosRPC(param1,BattlefieldControlManager.SERVERBATTLE);
         this.remaining_challenges = param1.sc;
         _loc2_.integralAdd = param1.upi;
         var _loc3_:Array = _loc2_.getMyOrgs(param1);
         var _loc4_:Array = _loc2_.getEnemyOrgs(param1);
         var _loc5_:PlayerInfo = new PlayerInfo();
         _loc5_.firstPlayer = this.myInfo;
         _loc5_.secondPlayer = this.otherInfo;
         _loc5_.type = PlayerInfo.QUALITYING;
         new Battlefield(_loc3_,_loc4_,_loc2_,this.battleEndAutoFindEmulant,BattlefieldControlManager.SERVERBATTLE,_loc5_);
      }
      
      private function battleEndAutoFindEmulant() : void
      {
         this.mainnode.removeChild(this.plantsAreaLeft);
         this.mainnode.removeChild(this.plantsAreaRight);
         this.mainnode.removeChild(this.prizeInfoLeft);
         this.mainnode.removeChild(this.prizeInfoRight);
         this.mainnode.removeChild(this.battleButton);
         if(this.remaining_challenges < 1)
         {
            this.isOrNotNeedClick = true;
         }
         else
         {
            this.isOrNotNeedClick = false;
         }
         this.connectServer();
      }
      
      private function suitPretendData() : void
      {
         if(this.playerInfoPanel == null)
         {
            this.playerInfoPanel = GetDomainRes.getSprite("serverbattle.qualitying.playerinfo");
         }
         if(this.searchPlayer == null)
         {
            this.searchPlayer = GetDomainRes.getSprite("serverbattle.qualitying.searchplayer");
         }
         if(this.endtime == null)
         {
            this.endtime = GetDomainRes.getSprite("serverbattle.qualitying.qualifyingEndTime");
         }
         if(this.changePlantsButton == null)
         {
            this.changePlantsButton = GetDomainRes.getSimpleButton("serverbattle.changePlantsButton");
         }
         if(this.exploitShopButton == null)
         {
            this.exploitShopButton = GetDomainRes.getSimpleButton("serverbattle.exploitshopButton");
         }
         if(this.rankButton == null)
         {
            this.rankButton = GetDomainRes.getSimpleButton("serverbattle.rankButton");
         }
         if(this.prizesButton == null)
         {
            this.prizesButton = GetDomainRes.getSimpleButton("serverbattle.prizesButton");
         }
         this.changePlantsButton.name = "changePlantsButton";
         this.exploitShopButton.name = "exploitShopButton";
         this.rankButton.name = "rankButton";
         this.prizesButton.name = "prizesButton";
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.meritorious + "");
         var _loc2_:DisplayObject = FuncKit.getNumEffect(this.remaining_challenges + "");
         FuncKit.clearAllChildrens(this.playerInfoPanel["exploitnum"]);
         FuncKit.clearAllChildrens(this.playerInfoPanel["battlenum"]);
         this.playerInfoPanel["exploitnum"].addChild(_loc1_);
         this.playerInfoPanel["battlenum"].addChild(_loc2_);
         FuncKit.clearAllChildrens(this.playerInfoPanel["num"]);
         var _loc3_:DisplayObject = FuncKit.getNumEffect(this.integral + "","Server");
         _loc3_.x = -_loc3_.width / 2;
         this.playerInfoPanel["num"].addChild(_loc3_);
         this.upDataSearchPlayerPanel();
         this.setSearchPlayerPrize();
         this.endtime["times"].text = this.qualifyingEndTime;
         this.endtime["times"].selectable = false;
         this.layoutUI();
      }
      
      private function setSearchPlayerPrize() : void
      {
         var _loc1_:Tool = null;
         var _loc2_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         this.searchPlayer["serverName"].text = this.getGroupNameById(this.serverGroup) + this.getEdh(this.userGroup);
         this.searchPlayer["serverName"].selectable = false;
         this.orderPrize = [];
         this.searchPlayer["box2"].visible = false;
         this.searchPlayer["box3"].visible = false;
         this.searchPlayer["box4"].visible = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.reward.length)
         {
            _loc2_ = this.reward[_loc3_];
            _loc1_ = new Tool(_loc2_["tool_id"]);
            switch(_loc2_["index"])
            {
               case 1:
                  FuncKit.clearAllChildrens(this.searchPlayer["box1"]["num"]);
                  _loc4_ = FuncKit.getNumEffect(("x" + _loc2_["amount"]).toString());
                  this.searchPlayer["box1"]["num"].addChild(_loc4_);
                  this.searchPlayer["box1"].mouseChildren = false;
                  this.orderPrize[0] = _loc1_;
                  break;
               case 2:
                  this.searchPlayer["box2"].visible = true;
                  FuncKit.clearAllChildrens(this.searchPlayer["box2"]["pic"]);
                  this.searchPlayer["box2"]["pic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
                  _loc5_ = this.getColorByPicId(_loc1_.getPicId());
                  this.searchPlayer["box2"]["txt"].htmlText = "<font color=\'" + _loc5_ + "\'size=\'15\'>" + _loc1_.getName() + "</font>";
                  this.searchPlayer["box2"].mouseChildren = false;
                  this.orderPrize[1] = _loc1_;
                  break;
               case 3:
                  this.searchPlayer["box3"].visible = true;
                  FuncKit.clearAllChildrens(this.searchPlayer["box3"]["pic"]);
                  this.searchPlayer["box3"]["pic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
                  _loc6_ = this.getColorByPicId(_loc1_.getPicId());
                  this.searchPlayer["box3"]["txt"].htmlText = "<font color=\'" + _loc6_ + "\' size=\'15\'>" + _loc1_.getName() + "</font>";
                  this.searchPlayer["box3"].mouseChildren = false;
                  this.orderPrize[2] = _loc1_;
                  break;
               case 4:
                  this.searchPlayer["box4"].visible = true;
                  FuncKit.clearAllChildrens(this.searchPlayer["box4"]["pic"]);
                  this.searchPlayer["box4"]["pic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
                  _loc7_ = this.getColorByPicId(_loc1_.getPicId());
                  this.searchPlayer["box4"]["txt"].htmlText = "<font color=\'" + _loc7_ + "\' size=\'15\'>" + _loc1_.getName() + "</font>";
                  this.searchPlayer["box4"].mouseChildren = false;
                  this.orderPrize[3] = _loc1_;
            }
            _loc3_++;
         }
         if(!this.searchPlayer.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.searchPlayer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc3_:Tool = null;
         var _loc4_:Tool = null;
         var _loc5_:Tool = null;
         var _loc6_:Tool = null;
         var _loc2_:Sprite = param1.target as Sprite;
         if(_loc2_ == null)
         {
            return;
         }
         if(this.boxtip == null)
         {
            this.boxtip = new ToolsTip();
         }
         switch(_loc2_.name)
         {
            case "box1":
               _loc3_ = this.orderPrize[0];
               this.boxtip.setTooltipText(_loc2_,_loc3_.getName(),_loc3_.getUse_condition(),_loc3_.getUse_result());
               if(param1.currentTarget == this.searchPlayer)
               {
                  this.boxtip.setLoction(_loc2_.x + 600,140);
               }
               else
               {
                  this.boxtip.setLoction(_loc2_.x + 570,110);
               }
               break;
            case "box2":
               _loc4_ = this.orderPrize[1];
               this.boxtip.setTooltipText(_loc2_,_loc4_.getName(),_loc4_.getUse_condition(),_loc4_.getUse_result());
               if(param1.currentTarget == this.searchPlayer)
               {
                  this.boxtip.setLoction(_loc2_.x + 250,100);
               }
               else
               {
                  this.boxtip.setLoction(_loc2_.x + 160,100);
               }
               break;
            case "box3":
               _loc5_ = this.orderPrize[2];
               this.boxtip.setTooltipText(_loc2_,_loc5_.getName(),_loc5_.getUse_condition(),_loc5_.getUse_result());
               if(param1.currentTarget == this.searchPlayer)
               {
                  this.boxtip.setLoction(_loc2_.x + 350,100);
               }
               else
               {
                  this.boxtip.setLoction(_loc2_.x + 270,100);
               }
               break;
            case "box4":
               _loc6_ = this.orderPrize[3];
               this.boxtip.setTooltipText(_loc2_,_loc6_.getName(),_loc6_.getUse_condition(),_loc6_.getUse_result());
               if(param1.currentTarget == this.searchPlayer)
               {
                  this.boxtip.setLoction(_loc2_.x + 230,100);
               }
               else
               {
                  this.boxtip.setLoction(_loc2_.x - 10,100);
               }
               break;
            default:
               return;
         }
      }
      
      private function setPrizeInfo() : void
      {
         var _loc1_:Tool = null;
         var _loc2_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         this.prizeInfoRight["box2"].visible = false;
         this.prizeInfoRight["box3"].visible = false;
         this.prizeInfoRight["box4"].visible = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.reward.length)
         {
            _loc2_ = this.reward[_loc3_];
            _loc1_ = new Tool(_loc2_["tool_id"]);
            switch(_loc2_["index"])
            {
               case 1:
                  FuncKit.clearAllChildrens(this.prizeInfoLeft["box1"]["num"]);
                  _loc4_ = FuncKit.getNumEffect(("x" + _loc2_["amount"]).toString());
                  this.prizeInfoLeft["box1"]["num"].addChild(_loc4_);
                  this.prizeInfoLeft["box1"].mouseChildren = false;
                  break;
               case 2:
                  FuncKit.clearAllChildrens(this.prizeInfoRight["box2"]["pic"]);
                  this.prizeInfoRight["box2"].visible = true;
                  _loc5_ = this.getColorByPicId(_loc1_.getPicId());
                  this.prizeInfoRight["box2"]["txt"].htmlText = "<font color=\'" + _loc5_ + "\' size=\'15\'>" + _loc1_.getName() + "</font>";
                  this.prizeInfoRight["box2"]["pic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
                  this.prizeInfoRight["box2"].mouseChildren = false;
                  break;
               case 3:
                  FuncKit.clearAllChildrens(this.prizeInfoRight["box3"]["pic"]);
                  this.prizeInfoRight["box3"].visible = true;
                  _loc6_ = this.getColorByPicId(_loc1_.getPicId());
                  this.prizeInfoRight["box3"]["txt"].htmlText = "<font color=\'" + _loc6_ + "\' size=\'15\'>" + _loc1_.getName() + "</font>";
                  this.prizeInfoRight["box3"]["pic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
                  this.prizeInfoRight["box3"].mouseChildren = false;
                  break;
               case 4:
                  FuncKit.clearAllChildrens(this.prizeInfoRight["box4"]["pic"]);
                  this.prizeInfoRight["box4"].visible = true;
                  _loc7_ = this.getColorByPicId(_loc1_.getPicId());
                  this.prizeInfoRight["box4"]["txt"].htmlText = "<font color=\'" + _loc7_ + "\' size=\'15\'>" + _loc1_.getName() + "</font>";
                  this.prizeInfoRight["box4"]["pic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
                  this.prizeInfoRight["box4"].mouseChildren = false;
            }
            _loc3_++;
         }
         if(!this.prizeInfoRight.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.prizeInfoRight.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         }
         if(!this.prizeInfoLeft.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.prizeInfoLeft.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         }
      }
      
      private function getColorByPicId(param1:int) : String
      {
         switch(param1)
         {
            case 535:
               return "#92d050";
            case 527:
               return "#9954cc";
            case 528:
               return "#ff33cc";
            case 346:
               return "#ffcc00";
            case 534:
               return "#ff0000";
            default:
               return "#ff0000";
         }
      }
      
      private function getBoxByPicID(param1:int) : Sprite
      {
         return GetDomainRes.getSprite("box_" + param1);
      }
      
      private function StopAllTheMc() : void
      {
         if(this.searchPlayer != null)
         {
            this.searchPlayer["box2"]["mc"].gotoAndStop(1);
            this.searchPlayer["box3"]["mc"].gotoAndStop(1);
            this.searchPlayer["box4"]["mc"].gotoAndStop(1);
         }
         if(this.prizeInfoLeft != null)
         {
            this.prizeInfoLeft["box1"]["mc"].gotoAndStop(1);
         }
         if(this.prizeInfoRight != null)
         {
            this.prizeInfoRight["box2"]["mc"].gotoAndStop(1);
            this.prizeInfoRight["box3"]["mc"].gotoAndStop(1);
            this.prizeInfoRight["box4"]["mc"].gotoAndStop(1);
         }
      }
      
      private function getGroupNameById(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 1:
               _loc2_ = LangManager.getInstance().getLanguage("severBattle026");
               break;
            case 2:
               _loc2_ = LangManager.getInstance().getLanguage("severBattle022");
               break;
            case 3:
               _loc2_ = LangManager.getInstance().getLanguage("severBattle023");
               break;
            case 4:
               _loc2_ = LangManager.getInstance().getLanguage("severBattle025");
               break;
            case 5:
               _loc2_ = LangManager.getInstance().getLanguage("severBattle024");
         }
         return _loc2_;
      }
      
      private function getEdh(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 1:
               _loc2_ = "A" + LangManager.getInstance().getLanguage("severBattle005");
               break;
            case 2:
               _loc2_ = "B" + LangManager.getInstance().getLanguage("severBattle005");
               break;
            case 3:
               _loc2_ = "C" + LangManager.getInstance().getLanguage("severBattle005");
               break;
            case 4:
               _loc2_ = "D" + LangManager.getInstance().getLanguage("severBattle005");
         }
         return _loc2_;
      }
      
      private function layoutUI() : void
      {
         if(!this.mainnode.contains(this.playerInfoPanel))
         {
            this.mainnode.addChild(this.playerInfoPanel);
            this.playerInfoPanel.x = 0;
            this.playerInfoPanel.y = -this.playerInfoPanel.height;
            this.panelMoveType = 1;
            this.MoveCl();
         }
         this.mainnode.addChild(this.searchPlayer);
         this.mainnode.addChild(this.endtime);
         this.searchPlayer.x = -this.searchPlayer.width;
         this.searchPlayer.y = PlantsVsZombies.HEIGHT / 2 - 10;
         this.endtime.x = PlantsVsZombies.WIDTH - this.endtime.width;
         this.endtime.y = PlantsVsZombies.HEIGHT - 30;
         this.mainnode.addChild(this.changePlantsButton);
         this.mainnode.addChild(this.exploitShopButton);
         this.mainnode.addChild(this.rankButton);
         this.mainnode.addChild(this.prizesButton);
         this.changePlantsButton.y = PlantsVsZombies.HEIGHT + this.changePlantsButton.height;
         this.exploitShopButton.x = this.changePlantsButton.x + this.changePlantsButton.width;
         this.exploitShopButton.y = PlantsVsZombies.HEIGHT;
         this.rankButton.x = this.exploitShopButton.x + this.exploitShopButton.width - 5;
         this.rankButton.y = PlantsVsZombies.HEIGHT;
         this.prizesButton.x = this.rankButton.x + this.rankButton.width + 3;
         this.prizesButton.y = PlantsVsZombies.HEIGHT;
         this.panelMoveType = 3;
         this.MoveCl();
         this.panelMoveType = 9;
         this.MoveCl();
         this.panelMoveType = 10;
         this.MoveCl();
         this.panelMoveType = 11;
         this.MoveCl();
         this.panelMoveType = 12;
         this.MoveCl();
      }
      
      private function initRunPlayer() : void
      {
         var battleMc:MovieClip = null;
         var onBattleEnter:Function = null;
         onBattleEnter = function(param1:Event):void
         {
            if(battleMc.currentFrame == battleMc.totalFrames)
            {
               battleMc.removeEventListener(Event.ENTER_FRAME,onBattleEnter);
               mainnode.removeChild(battleMc);
               battleButton = GetDomainRes.getSimpleButton("serverbattle.qualitying.battlebutton");
               battleButton.name = "battle";
               mainnode.addChild(battleButton);
               battleButton.x = PlantsVsZombies.WIDTH / 2 - 80;
               battleButton.y = PlantsVsZombies.HEIGHT / 2 - 40;
               battleButton.addEventListener(MouseEvent.CLICK,onClick);
            }
         };
         this.mainnode.removeChild(this.searchPlayer);
         this.myInfo = this._re[0];
         this.otherInfo = this._re[1];
         if(this.prizeInfoLeft == null)
         {
            this.prizeInfoLeft = GetDomainRes.getSprite("serverbattle.qualitying.prizeinfoleft");
         }
         if(this.prizeInfoRight == null)
         {
            this.prizeInfoRight = GetDomainRes.getSprite("serverbattle.qualitying.prizeinforight");
         }
         this.setPrizeInfo();
         if(this.plantsAreaLeft == null)
         {
            this.plantsAreaLeft = new QualifyRunerWindow(0);
         }
         this.plantsAreaLeft.setArea(this._re[0]);
         if(this.plantsAreaRight == null)
         {
            this.plantsAreaRight = new QualifyRunerWindow(1);
         }
         this.plantsAreaRight.setArea(this._re[1]);
         this.mainnode.addChild(this.prizeInfoLeft);
         this.prizeInfoLeft.x = -this.prizeInfoLeft.width;
         this.prizeInfoLeft.y = PlantsVsZombies.HEIGHT / 2 - 28;
         this.mainnode.addChild(this.prizeInfoRight);
         this.prizeInfoRight.x = PlantsVsZombies.WIDTH;
         this.prizeInfoRight.y = PlantsVsZombies.HEIGHT / 2 - 28;
         this.mainnode.addChild(this.plantsAreaLeft);
         this.plantsAreaLeft.x = -this.plantsAreaLeft.width;
         this.plantsAreaLeft.y = 100;
         this.mainnode.addChild(this.plantsAreaRight);
         this.plantsAreaRight.x = PlantsVsZombies.WIDTH;
         this.plantsAreaRight.y = PlantsVsZombies.HEIGHT - 195;
         battleMc = GetDomainRes.getMoveClip("serverbattle.qualitying.battleButtonMc");
         battleMc.x = PlantsVsZombies.WIDTH / 2 - 100;
         battleMc.y = PlantsVsZombies.HEIGHT / 2 - 56;
         this.mainnode.addChild(battleMc);
         battleMc.addEventListener(Event.ENTER_FRAME,onBattleEnter);
         this.panelMoveType = 4;
         this.MoveCl();
         this.panelMoveType = 5;
         this.MoveCl();
         this.panelMoveType = 6;
         this.MoveCl();
         this.panelMoveType = 7;
         this.MoveCl();
      }
      
      private function MoveCl() : void
      {
         var _loc1_:MovieMotion = new MovieMotion();
         this.mainnode.mouseChildren = false;
         this.mainnode.mouseEnabled = false;
         PlantsVsZombies._node["back"].mouseEnabled = false;
         switch(this.panelMoveType)
         {
            case 1:
               _loc1_.goAnimate(this.playerInfoPanel,0,this.panelMoveDirect,null);
               break;
            case 3:
               this.panelMoveDirect = 0;
               if(this.isOrNotNeedClick)
               {
                  _loc1_.goAnimate(this.searchPlayer,PlantsVsZombies.WIDTH / 2,this.panelMoveDirect,null);
               }
               else
               {
                  _loc1_.goAnimate(this.searchPlayer,PlantsVsZombies.WIDTH / 2,this.panelMoveDirect,this.clearSearchPlayerAndRequest);
               }
               break;
            case 4:
               this.panelMoveDirect = 0;
               _loc1_.goAnimate(this.plantsAreaLeft,PlantsVsZombies.WIDTH - 30,this.panelMoveDirect,null);
               break;
            case 5:
               this.panelMoveDirect = 0;
               _loc1_.goAnimate(this.plantsAreaRight,30,this.panelMoveDirect,null);
               break;
            case 6:
               this.panelMoveDirect = 0;
               _loc1_.goAnimate(this.prizeInfoLeft,PlantsVsZombies.WIDTH / 2,this.panelMoveDirect,null);
               break;
            case 7:
               this.panelMoveDirect = 0;
               _loc1_.goAnimate(this.prizeInfoRight,PlantsVsZombies.WIDTH / 2,this.panelMoveDirect,null);
               break;
            case 8:
               this.panelMoveDirect = 0;
               _loc1_.goAnimate(this.searchPlayer,-this.searchPlayer.width,this.panelMoveDirect,this.clearSearchPlayerAndRequest);
               break;
            case 9:
               this.panelMoveDirect = 1;
               _loc1_.goAnimate(this.changePlantsButton,PlantsVsZombies.HEIGHT - this.changePlantsButton.height,this.panelMoveDirect,null);
               break;
            case 10:
               this.panelMoveDirect = 1;
               _loc1_.goAnimate(this.exploitShopButton,PlantsVsZombies.HEIGHT - this.changePlantsButton.height - 3,this.panelMoveDirect,null);
               break;
            case 11:
               this.panelMoveDirect = 1;
               _loc1_.goAnimate(this.rankButton,PlantsVsZombies.HEIGHT - this.rankButton.height,this.panelMoveDirect,null);
               break;
            case 12:
               this.panelMoveDirect = 1;
               _loc1_.goAnimate(this.prizesButton,PlantsVsZombies.HEIGHT - this.prizesButton.height,this.panelMoveDirect,null);
               break;
            case 13:
               this.panelMoveDirect = 0;
               _loc1_.goAnimate(this.searchPlayer,-this.searchPlayer.width,this.panelMoveDirect,this.initRunPlayer);
         }
         PlantsVsZombies._node["back"].mouseEnabled = true;
         this.mainnode.mouseChildren = true;
         this.mainnode.mouseEnabled = true;
      }
      
      private function playFindPlayerMc() : void
      {
         if(this.playfindplayermc == null)
         {
            this.playfindplayermc = GetDomainRes.getMoveClip("serverbattle.qualitying.findloading");
         }
         this.mainnode.addChild(this.playfindplayermc);
         this.playfindplayermc["loading"].play();
         this.playfindplayermc["loading"].addEventListener(Event.ENTER_FRAME,this.onPlayEnterHandler);
      }
      
      private function onPlayEnterHandler(param1:Event) : void
      {
         if(this.getDataBool)
         {
            if(this.playfindplayermc["loading"].currentFrameLabel == "end")
            {
               this.clearLoading();
               this.panelMoveType = 13;
               this.MoveCl();
               return;
            }
         }
         else if(this.playfindplayermc["loading"].currentFrameLabel == "end")
         {
            this.clearLoading();
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle021"));
            this.isOrNotNeedClick = true;
            this.panelMoveType = 3;
            this.MoveCl();
         }
      }
      
      public function setSecondPanelData(param1:Array) : void
      {
         this._re = param1;
         this.getDataBool = true;
         this.loadingCurFrame = this.playfindplayermc["loading"].currentFrame;
      }
      
      private function clearSearchPlayerAndRequest() : void
      {
         this.playFindPlayerMc();
         this.qualifyfp.initPanelData(QualifyingFport.GET_OPPONET);
      }
      
      private function clearLoading() : void
      {
         if(this.mainnode == null || this.playfindplayermc == null)
         {
            return;
         }
         if(!this.mainnode.contains(this.playfindplayermc))
         {
            return;
         }
         this.playfindplayermc["loading"].removeEventListener(Event.ENTER_FRAME,this.onPlayEnterHandler);
         this.playfindplayermc["loading"].gotoAndStop(1);
         this.mainnode.removeChild(this.playfindplayermc);
         this.getDataBool = false;
         this.loadingCurFrame = 0;
      }
      
      public function destroy() : void
      {
         this.clearLoading();
         this.backGround.dispose();
         this.StopAllTheMc();
         if(this.plantsAreaLeft != null)
         {
            this.plantsAreaLeft.dispose();
         }
         if(this.plantsAreaRight != null)
         {
            this.plantsAreaRight.dispose();
         }
         NoticeManager.getInstance.stop();
         FuncKit.clearAllChildrens(this.mainnode);
         this.mainnode.parent.removeChild(this.mainnode);
         this.removeButtonHandlerAndButtonMode();
         this.mainnode = null;
         this.overTip = null;
         this.reward = null;
         this.message = null;
         this.endtime = null;
         this.qualifyfp = null;
         this.searchPlayer = null;
         this.playerInfoPanel = null;
         this.prizeInfoLeft = null;
         this.prizeInfoRight = null;
         this.plantsAreaLeft = null;
         this.plantsAreaRight = null;
         this.isOrNotNeedClick = true;
      }
   }
}

