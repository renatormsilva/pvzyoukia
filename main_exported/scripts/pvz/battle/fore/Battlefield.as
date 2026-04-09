package pvz.battle.fore
{
   import com.display.CMovieClip;
   import com.display.CMovieClipEvent;
   import com.greensock.TweenLite;
   import com.motion.ChangeManager;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import constants.GlobalConstants;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.managers.GameManager;
   import effect.flap.FlapManager;
   import entity.Exp;
   import entity.GameMoney;
   import entity.Grid;
   import entity.LevelUpInfo;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SkillManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.arena.entity.ArenaEnemy;
   import pvz.battle.battleMode.Battle;
   import pvz.battle.battleMode.BattleAllAttack;
   import pvz.battle.battleMode.BattleApeak;
   import pvz.battle.battleMode.BattleClose;
   import pvz.battle.battleMode.BattleLine;
   import pvz.battle.battleMode.BattleParabola;
   import pvz.battle.entity.AttackedOrg;
   import pvz.battle.entity.BPlantAttr;
   import pvz.battle.entity.BattleCommand;
   import pvz.battle.fport.BattleFPort;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.battle.node.BattleOrg;
   import pvz.battle.window.ArenaResultWindow;
   import pvz.battle.window.OrgsPrizesWindow;
   import pvz.help.HelpNovice;
   import pvz.possession.Possession;
   import pvz.possession.PossessionResultWindow;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.entity.PlayerInfo;
   import pvz.serverbattle.knockout.scene.KnockoutBattleResultWindow;
   import pvz.serverbattle.qualifying.QualityingBattleResultWindow;
   import tip.XueZhanTip;
   import utils.BigInt;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import utils.StringMovieClip;
   import utils.TextFilter;
   import utils.Tremor;
   import windows.ActionWindow;
   import windows.Evlation;
   import windows.PlayerUpGradeWindow;
   import windows.PrizeWinowForGameMoney;
   import windows.PrizesWindow;
   import zlib.utils.DomainAccess;
   
   public class Battlefield
   {
      
      private static const ALL_ATACK_TYPE:int = 13;
      
      private static const ALL_CLOSE_ATTACK_TYPE:int = 14;
      
      private static var allAttackbol:Boolean = false;
      
      public var _isStart:Boolean;
      
      internal var cm:ChangeManager;
      
      private var _ae:ArenaEnemy = null;
      
      private var _backFun:Function;
      
      private var _battleFPort:BattleFPort = null;
      
      private var _battleField:MovieClip;
      
      private var _battleManager:BattlefieldControlManager;
      
      private var _battleType:int = 0;
      
      private var _container:DisplayObjectContainer = null;
      
      private var _enemyOrg:Array;
      
      private var _honor:int = 0;
      
      private var _myOrg:Array;
      
      private var _p:Possession = null;
      
      private var _scence:BattleScence = null;
      
      private var allPrizes:Array;
      
      private var allRoundBattleNum:int;
      
      private var isFlapPrizes:Boolean = false;
      
      private var isPass:Boolean = false;
      
      private var isPlayOver:Boolean = false;
      
      private var isPrizes:Boolean = true;
      
      private var islastBattleRound:Boolean = false;
      
      private var orgsPage:int = 1;
      
      private var playerManager:PlayerManager;
      
      private var roundBattleNum:int = 0;
      
      private var tremor:Tremor = null;
      
      private var upOrgPage:int = 1;
      
      private var xuezhanTip:XueZhanTip;
      
      private var currentcommand:BattleCommand;
      
      public function Battlefield(param1:Array, param2:Array, param3:BattlefieldControlManager, param4:Function, param5:int, param6:Object = null)
      {
         var end:Function = null;
         var myOrg:Array = param1;
         var enemyOrg:Array = param2;
         var battleManager:BattlefieldControlManager = param3;
         var backFun:Function = param4;
         var battleType:int = param5;
         var obj:Object = param6;
         this.cm = new ChangeManager();
         this.playerManager = Singleton.getInstance(PlayerManager);
         super();
         end = function():void
         {
            var loadingOver:Function = null;
            loadingOver = function():void
            {
               setAllOrganisms(myOrg,enemyOrg);
               islastBattleRound = false;
               _battleField["_bt_pass"].addEventListener(MouseEvent.CLICK,onPass);
               GameManager.getInstance().framerate = 60;
               _container.addChild(_battleField);
               _battleField["org_floor"].visible = false;
               _battleField["blood_floor"].visible = false;
               playBattleStart(playBattleStartOver);
            };
            _scence = new BattleScence();
            _battleField = BattleScenceShow.getBattleField();
            if(battleType == BattlefieldControlManager.WORLD)
            {
               changeBG(true);
            }
            else
            {
               changeBG(false);
            }
            _battleType = battleType;
            setBattleType(battleType,obj);
            _battleManager = battleManager;
            _backFun = backFun;
            _container = GameManager.getInstance().pvzNode;
            showBossInfo(isBossBattle(enemyOrg));
            setTitleInfo();
            showXueZhanEffect(false);
            _battleField["_bt_pass"].visible = !GlobalConstants.NEW_PLAYER;
            isPass = false;
            _battleField["map1"].visible = false;
            _battleField["map2"].visible = false;
            _isStart = false;
            _scence.saveOrgsInfo(myOrg);
            new BattleLoading(_container,myOrg,enemyOrg,loadingOver);
         };
         this._battleFPort = new BattleFPort(this);
         DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_BATTLE_SYSYTEM,end);
      }
      
      private function isBossBattle(param1:Array) : Organism
      {
         var _loc2_:Organism = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.getIsCopyBoss())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function showBossInfo(param1:Organism) : void
      {
         if(param1)
         {
            this._battleField.bossInfoPanel.mouseChildren = false;
            this._battleField.bossInfoPanel.mouseEnabled = false;
            this._battleField["_title1"].visible = false;
            this._battleField["_title2"].visible = false;
            TextFilter.removeFilter(this._battleField.bossInfoPanel.bossname_txt);
            TextFilter.MiaoBian(this._battleField.bossInfoPanel.bossname_txt,1118481);
            this.changeBossBlood(param1.getHp(),param1.getHp_max());
            this._battleField.bossInfoPanel.visible = true;
            this._battleField.bossInfoPanel.bossname_txt.text = param1.getName();
            this._battleField.bossInfoPanel.bloodBar.maskbar.scaleX = 1;
            this._battleField.bossInfoPanel.bloodBar.bar.mask = this._battleField.bossInfoPanel.bloodBar.maskbar;
            FuncKit.clearAllChildrens(this._battleField.bossInfoPanel.picNode);
            this._battleField.bossInfoPanel.picNode.addChild(GetDomainRes.getMoveClip("pvz.avatar" + param1.getPicId()));
         }
         else
         {
            this._battleField["_title1"].visible = true;
            this._battleField["_title2"].visible = true;
            this._battleField.bossInfoPanel.visible = false;
         }
      }
      
      private function changeBossBlood(param1:BigInt, param2:BigInt) : void
      {
         FuncKit.clearAllChildrens(this._battleField.bossInfoPanel.hp_node);
         var _loc3_:DisplayObject = ArtWordsManager.instance.getArtWordByTwoNumber(param1.toNumber(),param2.toNumber(),16777215,16777215,15,0,true);
         this._battleField.bossInfoPanel.hp_node.addChild(_loc3_);
         _loc3_.x = -_loc3_.width / 2;
         TweenLite.to(this._battleField.bossInfoPanel.bloodBar.maskbar,0.5,{"scaleX":param1.toNumber() / param2.toNumber()});
      }
      
      public function changeBG(param1:Boolean) : void
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         if(!param1)
         {
            if(this._battleField.getChildByName("worldBattleBg") != null)
            {
               this._battleField.getChildByName("worldBattleBg").visible = false;
            }
            this._battleField["bg"].visible = true;
            return;
         }
         this._battleField["bg"].visible = false;
         if(this._battleField.getChildByName("worldBattleBg") == null)
         {
            _loc2_ = DomainAccess.getClass("ui.world.battleBG");
            _loc3_ = new _loc2_();
            _loc3_.name = "worldBattleBg";
            this._battleField.addChildAt(_loc3_,this._battleField.getChildIndex(this._battleField["bg"]));
         }
         this._battleField.getChildByName("worldBattleBg").visible = true;
      }
      
      public function portShowPrizes(param1:Array, param2:GameMoney = null, param3:Exp = null, param4:Array = null) : void
      {
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         this.isPrizes = true;
         if(param3)
         {
            param1.push(param3);
         }
         this._scence.addPlayerTool(param1);
         this._scence.addPlayerGameMoney(param2);
         this._scence.addPlayerExp(param3);
         this._scence.addUpinfos(param4);
         if(this.isPass && this._battleType != BattlefieldControlManager.ARENA && this._battleType != BattlefieldControlManager.SERVERBATTLE)
         {
            this.showAllOrgPrizes();
            return;
         }
         if(this._battleType == BattlefieldControlManager.ARENA || this._battleType == BattlefieldControlManager.SERVERBATTLE)
         {
            this.showToolsPrizes();
            return;
         }
         if(this.isPlayOver)
         {
            this.playPrizes();
         }
      }
      
      public function portShowPrizesError(param1:String) : void
      {
         this.isPrizes = false;
         var _loc2_:ActionWindow = new ActionWindow();
         _loc2_ = new ActionWindow();
         if(this._battleType == BattlefieldControlManager.ARENA || this._battleType == BattlefieldControlManager.SERVERBATTLE)
         {
            _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("battle002"),param1,this.closeBattle,false);
         }
         else
         {
            _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("battle002"),param1,this.showAllOrgPrizes,false);
         }
      }
      
      private function AttackedEffect(param1:AttackedOrg, param2:int, param3:int, param4:int, param5:int, param6:Array, param7:int, param8:BigInt, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:BattleOrg = null) : void
      {
         var orgX:Number;
         var orgY:Number;
         var orgVgeniusSkills:Array;
         var orgEgeniusSkills:Array;
         var curentAttackedOrg:BattleOrg = null;
         var curentHp:Number = NaN;
         var curentCout:int = 0;
         var battleCommand:Function = null;
         var attnum:Number = NaN;
         var attackedOrg:AttackedOrg = param1;
         var attackType:int = param2;
         var num:int = param3;
         var hit:int = param4;
         var campType:int = param5;
         var skillsed:Array = param6;
         var fear:int = param7;
         var attackNum:BigInt = param8;
         var attackLastbool:Boolean = param9;
         var isGroupAttack:Boolean = param10;
         var isCloseAll:Boolean = param11;
         var isDodge:Boolean = param12;
         var attacker:BattleOrg = param13;
         battleCommand = function():void
         {
            var _loc2_:BattleOrg = null;
            var _loc1_:Boolean = showGeiusEffectAttacked(curentAttackedOrg,attackedOrg.getVgeniusSkill(),attackedOrg.getEgeniusSkill(),hit,num,campType,curentHp,attackLastbool);
            if(num == hit)
            {
               showExclusiveSkillsEffect(attacker,attackedOrg);
            }
            if(_loc1_)
            {
               _loc2_ = attacker._o.getHp().toNumber() <= 0 ? attacker : curentAttackedOrg;
               playBattleCommadEnd(_loc2_,curentCout);
            }
         };
         curentAttackedOrg = attackedOrg.getBattleOrg();
         curentHp = attackedOrg.getAttackedHp();
         curentCout = attackedOrg.getCurrentCout();
         if(isDodge == false)
         {
            if(curentAttackedOrg._exdamage)
            {
               attnum = attackNum.toNumber() - curentAttackedOrg._exdamage.toNumber();
               this.flapDamage(curentAttackedOrg,new BigInt(attnum),fear);
            }
            else
            {
               this.flapDamage(curentAttackedOrg,attackNum,fear);
            }
         }
         (curentAttackedOrg as BattleOrg).attacked();
         orgX = BattleScenceShow.getAttackedPoint(curentAttackedOrg).x;
         orgY = BattleScenceShow.getAttackedPoint(curentAttackedOrg).y;
         (curentAttackedOrg as BattleOrg).dodgeEf(isDodge,orgX,orgY,this._battleField);
         this.addBuffers(this.currentcommand.buffers,this._myOrg.concat(this._enemyOrg));
         if(isGroupAttack)
         {
            if(!allAttackbol)
            {
               PlantsVsZombies.playSounds(SoundManager.HIT);
               if(isCloseAll)
               {
                  this.showAllAttackedEffect(curentAttackedOrg,ALL_ATACK_TYPE,campType);
               }
               else
               {
                  this.showAllAttackedEffect(curentAttackedOrg,ALL_CLOSE_ATTACK_TYPE,campType);
               }
            }
            allAttackbol = true;
            if(attackLastbool)
            {
               ++this.roundBattleNum;
               allAttackbol = false;
            }
         }
         else
         {
            PlantsVsZombies.playSounds(SoundManager.HIT);
            this.showAttackedEffect(curentAttackedOrg,attackType,num);
            if(num == hit)
            {
               ++this.roundBattleNum;
            }
         }
         orgVgeniusSkills = attackedOrg.getVgeniusSkill();
         orgEgeniusSkills = attackedOrg.getEgeniusSkill();
         this.changeBlood(curentAttackedOrg,campType,curentHp,attackNum,battleCommand);
      }
      
      private function addBlood(param1:BattleOrg, param2:int, param3:int, param4:Grid, param5:DisplayObject) : void
      {
         var _loc6_:Class = DomainAccess.getClass("blood");
         var _loc7_:MovieClip = new _loc6_();
         _loc7_["grade"].t.text = "Lv." + param1.getOrg().getGrade();
         TextFilter.MiaoBian(_loc7_["grade"].t,0);
         _loc7_.x = param1.x - _loc7_.width / 2;
         _loc7_.y = param1.y;
         _loc7_.name = "blood_" + param2 + "_" + param3;
         var _loc8_:Number = param1.getOrg().getHp().toNumber() / param1.getOrg().getHp_max().toNumber();
         if(_loc8_ > 1)
         {
            _loc8_ = 1;
         }
         _loc7_["cover"].scaleX = _loc8_;
         this._battleField["blood_floor"].addChildAt(_loc7_,this._battleField["blood_floor"].numChildren);
      }
      
      private function addorg(param1:Grid, param2:int, param3:MovieClip, param4:Array, param5:int) : void
      {
         var _loc6_:BattleOrg = new BattleOrg(param1.getOrg(),param2,param5);
         _loc6_.x = param3.x + param1.getX() * BattleMapManager.WIDE_GRID + param1.getWide() * BattleMapManager.WIDE_GRID / 2;
         _loc6_.y = param3.y + param1.getY() * BattleMapManager.HEIGHT_GRID + param1.getHeigth() * BattleMapManager.HEIGHT_GRID;
         this._battleField["org_floor"].addChild(_loc6_);
         param4.push(_loc6_);
         this.addBlood(_loc6_,param1.getOrg().getId(),param5,param1,param3);
      }
      
      private function battleLimit() : void
      {
         var _loc1_:ActionWindow = new ActionWindow();
         if(this._battleType == BattlefieldControlManager.SERVERBATTLE)
         {
            _loc1_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("battle003"),LangManager.getInstance().getLanguage("battle012"),this.passBattle,false);
         }
         else
         {
            _loc1_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("battle003"),LangManager.getInstance().getLanguage("battle011"),this.passBattle,false);
         }
      }
      
      private function canDrop(param1:Number, param2:Number, param3:int) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         switch(param3)
         {
            case -1:
               _loc4_ = 25;
               break;
            case 0:
               _loc4_ = 35;
               break;
            case 1:
               _loc4_ = 45;
         }
         if(param1 <= 382)
         {
            _loc5_ = Math.pow(10,2 * param1 / _loc4_);
            if(_loc5_ >= param2)
            {
               return true;
            }
            return false;
         }
         _loc5_ = Math.pow(10,2 * (765 - param1) / _loc4_);
         if(_loc5_ >= param2)
         {
            return true;
         }
         return false;
      }
      
      private function changeBlood(param1:BattleOrg, param2:int, param3:Number = 0, param4:BigInt = null, param5:Function = null) : void
      {
         var _loc6_:int = 0;
         if(param2 == BattlefieldControlManager.ENEMY_ORG)
         {
            _loc6_ = BattlefieldControlManager.MINE_ORG;
         }
         else
         {
            _loc6_ = BattlefieldControlManager.ENEMY_ORG;
         }
         var _loc7_:Organism = param1.getOrg();
         var _loc8_:BigInt = param4;
         var _loc9_:String = _loc8_.toString();
         var _loc10_:BigInt = _loc7_.getHp();
         var _loc11_:BigInt = BigInt.minus(_loc10_,_loc9_);
         var _loc12_:BigInt = _loc7_.getHp_max();
         _loc7_.setHp(_loc11_.toString());
         var _loc13_:DisplayObject = BattleScenceShow.getBlood(_loc7_.getId(),_loc6_);
         if(_loc13_ == null)
         {
            if(_loc7_.getHp().toNumber() <= 0)
            {
               this.dead(param1,param2);
            }
            if(param5 != null)
            {
               param5();
               param5 = null;
            }
            return;
         }
         var _loc14_:Number = _loc11_.toNumber() / _loc12_.toNumber();
         if(_loc14_ > 1)
         {
            _loc14_ = 1;
         }
         _loc13_["cover"].scaleX = _loc14_;
         if(_loc7_.getIsCopyBoss())
         {
            this.changeBossBlood(_loc11_,_loc12_);
         }
         if(_loc7_.getHp().toNumber() <= 0)
         {
            this.dead(param1,param2);
         }
         if(param5 != null)
         {
            param5();
            param5 = null;
         }
      }
      
      private function clearAllBloodNode() : void
      {
         FuncKit.clearAllChildrens(this._battleField["blood_floor"]);
      }
      
      private function clearAllOrgNode() : void
      {
         var _loc1_:BattleOrg = null;
         while(this._battleField["org_floor"].numChildren > 0)
         {
            _loc1_ = this._battleField["org_floor"].getChildAt(0);
            _loc1_.destroy();
         }
      }
      
      private function closeBattle() : void
      {
         if(this._backFun != null)
         {
            if(this._battleType == BattlefieldControlManager.POSSESSION)
            {
               this._backFun(this._battleManager.getBattletype(),this._p,this._battleManager.win);
            }
            else if(this._battleType == BattlefieldControlManager.WORLD)
            {
               this._backFun(this._battleManager.win);
            }
            else if(this._battleType == BattlefieldControlManager.JEWEL_BATTLE)
            {
               this._backFun(this._battleManager.getJewelCopyChpaterName());
            }
            else
            {
               this._backFun();
            }
         }
         this.destory();
      }
      
      private function destory() : void
      {
         this.clearAllBloodNode();
         this.clearAllOrgNode();
         this._container.removeChild(this._battleField);
         this._battleManager.destory();
         this._battleManager = null;
         this._battleField = null;
         GameManager.getInstance().framerate = 12;
         this.clearData();
      }
      
      private function clearData() : void
      {
         this._battleFPort = null;
         this._ae = null;
         this._enemyOrg = null;
         this._myOrg = null;
         this._p = null;
         this._scence.destory();
         this._scence = null;
         this.allPrizes = null;
         this.tremor = null;
      }
      
      private function dead(param1:DisplayObject, param2:int) : void
      {
         var t:CTimer = null;
         var onDead:Function = null;
         var g:DisplayObject = param1;
         var campType:int = param2;
         onDead = function(param1:CTimerEvent):void
         {
            t.removeEventListener(CTimerEvent.TIMER,onDead);
            t.stop();
            t = null;
            g.visible = false;
            var _loc2_:Organism = (g as BattleOrg).getOrg();
            var _loc3_:int = 0;
            if(campType == BattlefieldControlManager.ENEMY_ORG)
            {
               _loc3_ = BattlefieldControlManager.MINE_ORG;
            }
            else
            {
               _loc3_ = BattlefieldControlManager.ENEMY_ORG;
            }
            var _loc4_:DisplayObject = BattleScenceShow.getBlood(_loc2_.getId(),_loc3_);
            if(_loc4_ != null)
            {
               BattleScenceShow.removeBlood(_loc4_);
            }
         };
         t = new CTimer(800);
         t.addEventListener(CTimerEvent.TIMER,onDead);
         t.start();
      }
      
      private function flapDamAndCblood(param1:BattleOrg, param2:BigInt, param3:Number, param4:int) : void
      {
         var myInterval:uint = 0;
         var move:Function = null;
         var battleorg:BattleOrg = param1;
         var attackNum:BigInt = param2;
         var currentHp:Number = param3;
         var comptype:int = param4;
         move = function():void
         {
            clearInterval(myInterval);
            flapDamage(battleorg,attackNum);
         };
         myInterval = setInterval(move,1000);
         this.changeBlood(battleorg,comptype,currentHp,attackNum);
      }
      
      private function flapDamage(param1:BattleOrg, param2:BigInt, param3:int = 0) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Number = param2.toNumber();
         if(param3 == 0)
         {
            if(_loc5_ > PlantsVsZombies.WAN_YI)
            {
               _loc4_ = FuncKit.getAttackNumDis(_loc5_);
            }
            else if(_loc5_ > 999 && _loc5_ <= PlantsVsZombies.WAN_YI)
            {
               _loc4_ = StringMovieClip.getStringImage(_loc5_ + "","Huge");
            }
            else if(_loc5_ > 99)
            {
               _loc4_ = StringMovieClip.getStringImage(_loc5_ + "","Middle");
            }
            else
            {
               _loc4_ = StringMovieClip.getStringImage(_loc5_ + "","Small");
            }
         }
         else if(param3 == 1)
         {
            if(_loc5_ >= PlantsVsZombies.WAN_YI)
            {
               _loc4_ = FuncKit.getAttackNumDis(_loc5_,"Fear");
            }
            else
            {
               _loc4_ = StringMovieClip.getStringImage(_loc5_ + "","Fear");
            }
         }
         else if(_loc5_ >= PlantsVsZombies.WAN_YI)
         {
            _loc4_ = FuncKit.getAttackNumDis(_loc5_,"Feared");
         }
         else
         {
            _loc4_ = StringMovieClip.getStringImage(_loc5_ + "","Feared");
         }
         var _loc6_:Number = BattleScenceShow.getAttackedPoint(param1).x;
         var _loc7_:Number = BattleScenceShow.getAttackedPoint(param1).y;
         if(this.canDrop(_loc6_,_loc5_,param3))
         {
            FlapManager.flapInfos(_loc6_ - _loc4_.width / 2,_loc7_,this._battleField,_loc4_,1);
         }
         else if(_loc6_ <= 382)
         {
            FlapManager.flapInfos(20,_loc7_,this._battleField,_loc4_,1);
         }
         else
         {
            FlapManager.flapInfos(745 - _loc4_.width,_loc7_,this._battleField,_loc4_,1);
         }
      }
      
      private function getBattleOrg(param1:int, param2:int) : BattleOrg
      {
         var _loc4_:Array = null;
         var _loc3_:BattleOrg = null;
         if(param2 == BattlefieldControlManager.MINE_ORG)
         {
            _loc4_ = this._myOrg;
         }
         else
         {
            _loc4_ = this._enemyOrg;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(((_loc4_[_loc5_] as BattleOrg).getOrg() as Organism).getId() == param1)
            {
               _loc3_ = _loc4_[_loc5_];
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      private function getPrizes() : void
      {
         var _loc1_:String = this._battleManager.key;
         this._battleFPort.toGetPrizes(_loc1_);
      }
      
      private function getUpExpOrgs(param1:Array, param2:Array) : Array
      {
         var _loc5_:Organism = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = this._scence.getOrgById(param1,param2[_loc4_]);
            if(_loc5_ != null)
            {
               _loc3_.push(param2[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function onPass(param1:MouseEvent) : void
      {
         this.isPass = true;
         if(this._battleField)
         {
            this._battleField["_bt_pass"].removeEventListener(MouseEvent.CLICK,this.onPass);
            this._battleField["_bt_pass"].visible = false;
         }
      }
      
      private function opinDead(param1:Number, param2:Number, param3:int, param4:int) : Boolean
      {
         if(param3 == param4)
         {
            if(param2 >= param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function passBattle() : void
      {
         this.isPlayOver = true;
         if(this._battleType == BattlefieldControlManager.ARENA)
         {
            this.showArenaResult();
         }
         else if(this._battleType == BattlefieldControlManager.POSSESSION)
         {
            this.showPossessionResult();
         }
         else if(this._battleType == BattlefieldControlManager.SERVERBATTLE)
         {
            this.showServerBattleResult();
         }
         else if(this._battleManager.win && this._battleType != BattlefieldControlManager.POSSESSION)
         {
            this.getPrizes();
         }
         else
         {
            this.playOver();
         }
      }
      
      private function playBattle(param1:BattleOrg, param2:Array, param3:int, param4:int, param5:Array, param6:Array, param7:int) : void
      {
         var _loc8_:BattleLine = null;
         var _loc9_:BattleClose = null;
         var _loc10_:BattleParabola = null;
         var _loc11_:BattleApeak = null;
         var _loc12_:BattleAllAttack = null;
         if(param4 == Battle.BATTLE_LINE)
         {
            _loc8_ = new BattleLine();
            _loc8_.lineAttack(this._battleField["bullet_floor"],param1,param2,24,this.AttackedEffect,param5,param6,this.showSkill,param7,this.cm);
         }
         else if(param4 == Battle.BATTLE_CLOSE)
         {
            _loc9_ = new BattleClose();
            _loc9_.closeAttack(param1,param2,BattleScenceShow.getBlood(param3,param7),param5,param6,this.showSkill,this.AttackedEffect,param7);
         }
         else if(param4 == Battle.BATTLE_PARABOLA)
         {
            _loc10_ = new BattleParabola();
            _loc10_.parabolaAttack(this._battleField["bullet_floor"],param1,param2,this.AttackedEffect,param5,param6,this.showSkill,param7);
         }
         else if(param4 == Battle.BATTLE_APEAK)
         {
            _loc11_ = new BattleApeak();
            _loc11_.ApeakAttack(this._battleField["bullet_floor"],param1,param2,36,this.AttackedEffect,param5,param6,this.showSkill,param7);
         }
         else if(param4 == Battle.BATTLE_ALL_ATTACK)
         {
            _loc12_ = new BattleAllAttack();
            _loc12_.allAttack(param1,param2,param5,param6,param7,this.showSkill,this.AttackedEffect);
         }
      }
      
      private function playBattleCommadEnd(param1:BattleOrg, param2:int) : void
      {
         var settomeout:Function;
         var t:uint = 0;
         var borg:BattleOrg = param1;
         var currentcout:int = param2;
         if(currentcout == 21)
         {
            this.showXueZhanEffect(true);
         }
         if(this.roundBattleNum == this.allRoundBattleNum)
         {
            if(this.islastBattleRound)
            {
               this.showXueZhanEffect(false);
               if(this._battleManager.dieStatus == 1)
               {
                  this.clearAllOrgNode();
                  this.clearAllBloodNode();
                  this.battleLimit();
               }
               else
               {
                  settomeout = function():void
                  {
                     clearTimeout(t);
                     BattleScenceShow.lastBattleEffect(borg,playNextRound);
                  };
                  t = setTimeout(settomeout,300);
               }
            }
            else
            {
               this.playNextRound();
            }
         }
      }
      
      private function playBattleEnd() : void
      {
         var endMc:MovieClip = null;
         var onPlay:Function = null;
         onPlay = function(param1:Event):void
         {
            if(endMc.currentFrame == endMc.totalFrames)
            {
               endMc.visible = false;
               endMc.gotoAndStop(1);
               endMc.removeEventListener(Event.ENTER_FRAME,onPlay);
               _battleField.removeChild(endMc);
               playBattleEndOver();
            }
         };
         if(this._battleType == BattlefieldControlManager.ARENA)
         {
            this.showArenaResult();
            GameManager.getInstance().framerate = 12;
            return;
         }
         if(this._battleType == BattlefieldControlManager.POSSESSION)
         {
            this.showPossessionResult();
            GameManager.getInstance().framerate = 12;
            return;
         }
         if(this._battleType == BattlefieldControlManager.SERVERBATTLE)
         {
            this.showServerBattleResult();
            GameManager.getInstance().framerate = 12;
            return;
         }
         endMc = BattleScenceShow.getBattleEnd();
         this._battleField.addChild(endMc);
         endMc.gotoAndPlay(1);
         endMc.addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      private function playBattleEndOver() : void
      {
         var class1:Class;
         var class2:Class;
         var class3:Class;
         var award1:MovieClip = null;
         var award2:MovieClip = null;
         var award3:MovieClip = null;
         var onPlay:Function = null;
         var onClick:Function = null;
         var onPlaySec:Function = null;
         onPlay = function(param1:Event):void
         {
            if(award1.currentFrame == award1.totalFrames)
            {
               award1.gotoAndStop(1);
               _battleField["floor_prize"].removeChild(award1);
               award1.removeEventListener(Event.ENTER_FRAME,onPlay);
               award2.x = _battleField["bg"].width / 2 - 40 - 3;
               award2.y = _battleField["bg"].height / 2 - 200 - 1;
               award2.gotoAndPlay(1);
               _battleField["flap_floor"].addChild(award2);
               award2.addEventListener(MouseEvent.CLICK,onClick);
               if(GlobalConstants.NEW_PLAYER)
               {
                  PlantsVsZombies.helpN.show(HelpNovice.BATTLE_CHOOSE_PRIZES,_container);
               }
            }
         };
         onClick = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(GlobalConstants.NEW_PLAYER)
            {
               PlantsVsZombies.helpN.clear();
            }
            clearAllOrgNode();
            clearAllBloodNode();
            if(!GlobalConstants.NEW_PLAYER)
            {
               getPrizes();
            }
            else
            {
               _scence.setAwards(PlantsVsZombies.helpN.getAwards());
            }
            award2.stop();
            award2.removeEventListener(MouseEvent.CLICK,onClick);
            _battleField["flap_floor"].removeChild(award2);
            award3.x = _battleField["bg"].width / 2 - 43;
            award3.y = _battleField["bg"].height / 2 - 88;
            award3.gotoAndPlay(1);
            _battleField["floor_prize"].addChild(award3);
            award3.addEventListener(Event.ENTER_FRAME,onPlaySec);
         };
         onPlaySec = function(param1:Event):void
         {
            if(!isPrizes)
            {
               award3.stop();
               award3.removeEventListener(Event.ENTER_FRAME,onPlaySec);
               _battleField["floor_prize"].removeChild(award3);
            }
            if(award3.currentFrame == award3.totalFrames)
            {
               isPlayOver = true;
               award3.stop();
               award3.removeEventListener(Event.ENTER_FRAME,onPlaySec);
               _battleField["floor_prize"].removeChild(award3);
               playPrizes();
            }
         };
         GameManager.getInstance().framerate = 12;
         class1 = DomainAccess.getClass("award_1");
         class2 = DomainAccess.getClass("award_2");
         class3 = DomainAccess.getClass("award_3");
         award1 = new class1();
         award2 = new class2();
         award3 = new class3();
         this._battleField["floor_prize"].addChild(award1);
         award2.buttonMode = true;
         award1.x = this._battleField["bg"].width / 2 - 40;
         award1.y = this._battleField["bg"].height / 2 - 200;
         award1.addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      private function playBattleStart(param1:Function) : void
      {
         var startMc:MovieClip = null;
         var onPlay:Function = null;
         var func:Function = param1;
         onPlay = function(param1:Event):void
         {
            if(startMc.currentFrame == startMc.totalFrames)
            {
               startMc.visible = false;
               startMc.gotoAndStop(1);
               startMc.removeEventListener(Event.ENTER_FRAME,onPlay);
               _battleField.removeChild(startMc);
               func();
            }
         };
         startMc = BattleScenceShow.getBattleStart();
         this._battleField.addChildAt(startMc,this._battleField.numChildren - 2);
         startMc.gotoAndPlay(1);
         startMc.addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      private function playBattleStartOver() : void
      {
         this._isStart = true;
         GameManager.getInstance().framerate = 12;
         this._battleField["org_floor"].visible = true;
         this._battleField["blood_floor"].visible = true;
         if(!GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.showDataLoading(true);
            PlantsVsZombies.storageInfo(this.start);
         }
         else
         {
            this.playerManager.getPlayer().organisms = PlantsVsZombies.helpN.getFirstAfterBattleOrgs();
            this.start();
         }
      }
      
      private function playDragonFirst() : void
      {
         var dragonMcClass:Class;
         var dragonMc:MovieClip = null;
         var onPlay:Function = null;
         onPlay = function(param1:Event):void
         {
            if(dragonMc.currentFrame == dragonMc.totalFrames)
            {
               dragonMc.gotoAndStop(1);
               dragonMc.visible = false;
               dragonMc.removeEventListener(Event.ENTER_FRAME,onPlay);
               _battleField.removeChild(dragonMc);
               resetBattle();
            }
         };
         PlantsVsZombies.helpN.show(HelpNovice.BATTLE_PLAY_CARTOON,null);
         dragonMcClass = DomainAccess.getClass("battle.battleField.helpStart");
         dragonMc = new dragonMcClass();
         dragonMc.x = 333 + 60;
         dragonMc.y = 258;
         this._battleField.addChild(dragonMc);
         dragonMc.gotoAndPlay(1);
         dragonMc.addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      private function playDragonSec() : void
      {
         var dragonMc:MovieClip = null;
         var onPlay:Function = null;
         onPlay = function(param1:Event):void
         {
            var _loc2_:ActionWindow = null;
            if(dragonMc.currentFrame == dragonMc.totalFrames)
            {
               dragonMc.gotoAndStop(1);
               dragonMc.visible = false;
               dragonMc.removeEventListener(Event.ENTER_FRAME,onPlay);
               _battleField.removeChild(dragonMc);
               clearAllOrgNode();
               clearAllBloodNode();
               PlantsVsZombies.helpN.show(HelpNovice.BATTLE_OK,_container);
               _loc2_ = new ActionWindow();
               _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("battle003"),LangManager.getInstance().getLanguage("battle004"),closeBattle,false);
            }
         };
         var dragonMcClass:Class = DomainAccess.getClass("battle.battleField.helpEnd");
         dragonMc = new dragonMcClass();
         dragonMc.x = 379;
         dragonMc.y = 277;
         this._battleField.addChild(dragonMc);
         dragonMc.gotoAndPlay(1);
         dragonMc.addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      private function playNextRound() : void
      {
         var t:CTimer = null;
         var playRoundT:Function = null;
         playRoundT = function(param1:CTimerEvent):void
         {
            t.removeEventListener(CTimerEvent.TIMER,playRoundT);
            t.stop();
            t = null;
            playRound();
         };
         t = new CTimer(800);
         t.addEventListener(CTimerEvent.TIMER,playRoundT);
         t.start();
      }
      
      private function playOver() : void
      {
         GameManager.getInstance().framerate = 24;
         if(!this._battleManager.win)
         {
            if(this._battleType == BattlefieldControlManager.HUNTING || this._battleType == BattlefieldControlManager.WORLD || this._battleType == BattlefieldControlManager.JEWEL_BATTLE)
            {
               if(!GlobalConstants.NEW_PLAYER)
               {
                  this.clearAllOrgNode();
                  this.clearAllBloodNode();
                  this.showCompose();
                  return;
               }
               this.playDragonSec();
               return;
            }
         }
         this.playBattleEnd();
      }
      
      private function playPrizes() : void
      {
         var i:int;
         var awardMc:MovieClip = null;
         var onClick:Function = null;
         var j:int = 0;
         onClick = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(GlobalConstants.NEW_PLAYER)
            {
               PlantsVsZombies.helpN.clear();
            }
            if(isFlapPrizes)
            {
               return;
            }
            removeEvent();
            showAllPrizesFlap();
            isFlapPrizes = true;
         };
         var removeEvent:Function = function():void
         {
            var _loc1_:int = 0;
            while(_loc1_ < allPrizes.length)
            {
               allPrizes[_loc1_].removeEventListener(MouseEvent.CLICK,onClick);
               _loc1_++;
            }
         };
         var effect:Class = DomainAccess.getClass("prize");
         this.allPrizes = new Array();
         if(this._scence.getAwards() == null || this._scence.getAwards().length < 1)
         {
            this.showAllOrgPrizes();
            return;
         }
         i = 0;
         while(i < this._scence.getAwards().length)
         {
            if(this._scence.getAwards()[i] is Tool)
            {
               j = 0;
               while(j < (this._scence.getAwards()[i] as Tool).getNum())
               {
                  awardMc = new effect();
                  awardMc.buttonMode = true;
                  Icon.setUrlIcon(awardMc["card"],BattleScenceShow.getAwardPicId(this._scence.getAwards()[i]),BattleScenceShow.getAwardMcType(this._scence.getAwards()[i]));
                  awardMc.addEventListener(MouseEvent.CLICK,onClick);
                  this.allPrizes.push(awardMc);
                  j++;
               }
            }
            else
            {
               awardMc = new effect();
               awardMc.buttonMode = true;
               Icon.setUrlIcon(awardMc["card"],BattleScenceShow.getAwardPicId(this._scence.getAwards()[i]),BattleScenceShow.getAwardMcType(this._scence.getAwards()[i]));
               awardMc.addEventListener(MouseEvent.CLICK,onClick);
               this.allPrizes.push(awardMc);
            }
            i++;
         }
         this.isFlapPrizes = false;
         this.showPrizes(this.allPrizes);
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.show(HelpNovice.BATTLE_GET_PRIZES,this._container);
         }
      }
      
      private function playRound() : void
      {
         var _loc1_:Array = this._battleManager.getNowRound();
         if(this.isPass)
         {
            this.clearAllOrgNode();
            this.clearAllBloodNode();
            if(this._battleManager.dieStatus == 1)
            {
               this.battleLimit();
            }
            else
            {
               this.passBattle();
            }
            return;
         }
         if(_loc1_ == null)
         {
            this._battleField["_bt_pass"].visible = false;
            this.playOver();
            return;
         }
         this.islastBattleRound = this._battleManager.isLastRound();
         this.roundBattleNum = 0;
         this.allRoundBattleNum = _loc1_.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.playSingle(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function updateBuffers(param1:Array, param2:Array) : void
      {
         var _loc3_:BattleOrg = null;
         for each(_loc3_ in param2)
         {
            _loc3_.refBuff(param1);
         }
      }
      
      public function addBuffers(param1:Array, param2:Array) : void
      {
         var _loc3_:BattleOrg = null;
         for each(_loc3_ in param2)
         {
            _loc3_.addBuff(param1);
         }
      }
      
      private function playSingle(param1:BattleCommand) : void
      {
         var playT:CTimer = null;
         var onPlay:Function = null;
         var command:BattleCommand = param1;
         onPlay = function(param1:CTimerEvent):void
         {
            var _loc6_:AttackedOrg = null;
            var _loc7_:BPlantAttr = null;
            var _loc8_:BattleOrg = null;
            playT.removeEventListener(CTimerEvent.TIMER,onPlay);
            playT.stop();
            playT = null;
            var _loc2_:BattleOrg = getBattleOrg(command.getAttack_id(),command.getCampType());
            _loc2_.setExclusiveSkillsData(command.getExclusive());
            var _loc3_:Array = [];
            updateBuffers(command.buffers,_myOrg.concat(_enemyOrg));
            currentcommand = command;
            var _loc4_:int = 0;
            while(_loc4_ < command.getAttackedArr().length)
            {
               _loc6_ = new AttackedOrg();
               if(command.getCampType() == BattlefieldControlManager.ENEMY_ORG)
               {
                  _loc8_ = getBattleOrg(command.getAttackedArr()[_loc4_]["id"],BattlefieldControlManager.MINE_ORG);
               }
               else
               {
                  _loc8_ = getBattleOrg(command.getAttackedArr()[_loc4_]["id"],BattlefieldControlManager.ENEMY_ORG);
               }
               _loc7_ = command.getAttackedArr()[_loc4_] as BPlantAttr;
               _loc6_.setId(_loc7_.id);
               _loc6_.setFear(_loc7_.fear);
               _loc6_.setCurrentCout(_loc7_.cout);
               _loc6_.setAttackNum(_loc7_.attackAllNum);
               _loc6_.setAttackNormal(_loc7_.attackNormal);
               _loc6_.setAttackedHp(_loc7_.current_Hp);
               _loc6_.setDodge(_loc7_.dodge);
               _loc6_.setBattleOrg(_loc8_);
               _loc6_.setEgeniusSkill(command.getEgenius());
               _loc6_.setVgeniusSkill(command.getVgenius());
               _loc6_.setExclusiveSkills(command.getExclusive());
               _loc6_.setBuffs(command.buffers);
               _loc3_.push(_loc6_);
               _loc4_++;
            }
            var _loc5_:int = _loc2_.getOrg().getAttackType();
            playBattle(_loc2_,_loc3_,command.getAttack_id(),_loc5_,command.getSkills(),command.getSkillsed(),command.getCampType());
         };
         var r:int = FuncKit.getRandom(200,1000);
         playT = new CTimer(r + 200);
         playT.addEventListener(CTimerEvent.TIMER,onPlay);
         playT.start();
      }
      
      private function resetBattle() : void
      {
         var _loc1_:XML = new XML(PlantsVsZombies.helpN.getBattleInfoSec());
         this._battleManager = new BattlefieldControlManager();
         this._battleManager.doBattleInfos(_loc1_);
         this._isStart = false;
         this.playBattleStart(this.resetBattleOver);
      }
      
      private function resetBattleOver() : void
      {
         GameManager.getInstance().framerate = 12;
         this.setAllOrganisms(PlantsVsZombies.helpN.getMyOrgsSec(),PlantsVsZombies.helpN.getEnemySec());
         this.start();
      }
      
      private function setAllOrganisms(param1:Array, param2:Array) : void
      {
         this._myOrg = new Array();
         this._enemyOrg = new Array();
         this.setOrganisms(param1,this._battleField["map1"],BattleMapManager.LEFT,this._myOrg,BattlefieldControlManager.MINE_ORG);
         this.setOrganisms(param2,this._battleField["map2"],BattleMapManager.RIGHT,this._enemyOrg,BattlefieldControlManager.ENEMY_ORG);
      }
      
      private function setOrganisms(param1:Array, param2:MovieClip, param3:int, param4:Array, param5:int) : void
      {
         var _loc6_:BattleMapManager = new BattleMapManager();
         _loc6_.areaAndGrids(param1);
         _loc6_.setGridsLoction(param3);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.getGrids().length)
         {
            this.addorg(_loc6_.getGrids()[_loc7_],param3,param2,param4,param5);
            _loc7_++;
         }
      }
      
      private function setBattleType(param1:int, param2:Object) : void
      {
         if(param1 == BattlefieldControlManager.ARENA)
         {
            this._ae = param2 as ArenaEnemy;
         }
         else if(param1 == BattlefieldControlManager.POSSESSION)
         {
            this._p = (param2 as Array)[0];
            this._honor = (param2 as Array)[1];
         }
         else if(param1 == BattlefieldControlManager.SERVERBATTLE)
         {
            this._scence.setBattlePlayerInfo(param2 as PlayerInfo);
         }
      }
      
      private function setTitleInfo() : void
      {
         var _loc1_:Contestant = null;
         var _loc2_:Contestant = null;
         var _loc3_:String = null;
         var _loc4_:Class = null;
         this._battleField["_title1"].gotoAndStop(1);
         this._battleField["_title2"].gotoAndStop(1);
         FuncKit.clearAllChildrens(this._battleField["_title1"]._pic1);
         FuncKit.clearAllChildrens(this._battleField["_title2"]._pic2);
         if(this._battleType == BattlefieldControlManager.ARENA)
         {
            this._battleField["_title1"]._grade1.text = "lv." + this.playerManager.getPlayer().getGrade();
            this._battleField["_title1"]._name1.text = this.playerManager.getPlayer().getNickname();
            this._battleField["_title1"]._rank1.text = this.playerManager.getPlayer().getArenaLastRank();
            PlantsVsZombies.setHeadPic(this._battleField["_title1"]._pic1,PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
            this._battleField["_title2"]._grade2.text = "lv." + this._ae.getGrade();
            this._battleField["_title2"]._name2.text = this._ae.getNickName();
            this._battleField["_title2"]._rank2.text = this._ae.getArenaRank();
            this._battleField["_title1"]._appellation1.text = LangManager.getInstance().getLanguage("battle013");
            this._battleField["_title2"]._appellation2.text = LangManager.getInstance().getLanguage("battle013");
            this._battleField["_title1"]["_title1"].text = LangManager.getInstance().getLanguage("battle009");
            this._battleField["_title2"]["_title2"].text = LangManager.getInstance().getLanguage("battle009");
            PlantsVsZombies.setHeadPic(this._battleField["_title2"]._pic2,PlantsVsZombies.getHeadPicUrl(this._ae.getFaceUrl()),PlantsVsZombies.HEADPIC_BIG,this._ae.getVipTime(),this._ae.getVipLevel());
         }
         else if(this._battleType == BattlefieldControlManager.POSSESSION)
         {
            this._battleField["_title1"]._grade1.text = "lv." + this.playerManager.getPlayer().getGrade();
            this._battleField["_title1"]._name1.text = this.playerManager.getPlayer().getNickname();
            this._battleField["_title1"]._rank1.text = "-";
            PlantsVsZombies.setHeadPic(this._battleField["_title1"]._pic1,PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
            this._battleField["_title2"]._grade2.text = "lv." + this._p.getOccupyGrade();
            this._battleField["_title2"]._name2.text = this._p.getOccupyName();
            this._battleField["_title2"]._rank2.text = "-";
            this._battleField["_title1"]._appellation1.text = "-";
            this._battleField["_title2"]._appellation2.text = "-";
            this._battleField["_title1"]["_title1"].text = LangManager.getInstance().getLanguage("battle009");
            this._battleField["_title2"]["_title2"].text = LangManager.getInstance().getLanguage("battle009");
            PlantsVsZombies.setHeadPic(this._battleField["_title2"]._pic2,PlantsVsZombies.getHeadPicUrl(this._p.getFace()),PlantsVsZombies.HEADPIC_BIG,0);
         }
         else if(this._battleType == BattlefieldControlManager.SERVERBATTLE)
         {
            _loc1_ = this._scence.getBattlePlayerInfo().firstPlayer;
            _loc2_ = this._scence.getBattlePlayerInfo().secondPlayer;
            _loc3_ = this._scence.getBattlePlayerInfo().type;
            this._battleField["_title1"]._grade1.text = "lv." + _loc1_.getGrade();
            this._battleField["_title1"]._name1.text = _loc1_.getName();
            if(_loc3_ == PlayerInfo.QUALITYING)
            {
               this._battleField["_title1"]._appellation1.text = _loc1_.getIntegral();
            }
            else
            {
               this._battleField["_title1"]._appellation1.text = "-";
               this._battleField["_title2"]._appellation2.text = "-";
            }
            this._battleField["_title1"]._rank1.text = "";
            this._battleField["_title1"]._wins1.text = "";
            this._battleField["_title1"]["_title1"].text = _loc1_.getServerName();
            PlantsVsZombies.setHeadPic(this._battleField["_title1"]._pic1,PlantsVsZombies.getHeadPicUrl(_loc1_.getfaceUrl()),PlantsVsZombies.HEADPIC_BIG,_loc1_.getVipTime(),_loc1_.getVipGrade());
            this._battleField["_title2"]._grade2.text = "lv." + _loc2_.getGrade();
            this._battleField["_title2"]._name2.text = _loc2_.getName();
            if(_loc3_ == PlayerInfo.QUALITYING)
            {
               this._battleField["_title2"]._appellation2.text = _loc2_.getIntegral();
            }
            this._battleField["_title2"]._rank2.text = "";
            this._battleField["_title2"]._wins2.text = "";
            this._battleField["_title2"]["_title2"].text = _loc2_.getServerName();
            PlantsVsZombies.setHeadPic(this._battleField["_title2"]._pic2,PlantsVsZombies.getHeadPicUrl(_loc2_.getfaceUrl()),PlantsVsZombies.HEADPIC_BIG,_loc2_.getVipTime(),_loc2_.getVipGrade());
            this._battleField["_title2"].gotoAndStop(2);
            this._battleField["_title1"].gotoAndStop(2);
         }
         else
         {
            this._battleField["_title1"]["_title1"].text = LangManager.getInstance().getLanguage("battle009");
            this._battleField["_title2"]["_title2"].text = LangManager.getInstance().getLanguage("battle010");
            this._battleField["_title1"]._grade1.text = "lv." + this.playerManager.getPlayer().getGrade();
            this._battleField["_title2"]._grade2.text = "lv??";
            this._battleField["_title1"]._name1.text = this.playerManager.getPlayer().getNickname();
            this._battleField["_title2"]._name2.text = "僵尸";
            this._battleField["_title1"]._rank1.text = "-";
            this._battleField["_title2"]._rank2.text = "-";
            this._battleField["_title1"]._wins1.text = "-";
            this._battleField["_title2"]._wins2.text = "-";
            this._battleField["_title1"]._appellation1.text = LangManager.getInstance().getLanguage("battle013");
            this._battleField["_title2"]._appellation2.text = LangManager.getInstance().getLanguage("battle013");
            PlantsVsZombies.setHeadPic(this._battleField["_title1"]._pic1,PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
            _loc4_ = DomainAccess.getClass("_mc_head");
            this._battleField["_title2"]._pic2.addChild(new _loc4_());
         }
      }
      
      private function showAllAttackedEffect(param1:BattleOrg, param2:int, param3:int) : void
      {
         var mc_effect:CMovieClip = null;
         var onComp:Function = null;
         var attackedOrg:BattleOrg = param1;
         var attackType:int = param2;
         var camp:int = param3;
         onComp = function(param1:CMovieClipEvent):void
         {
            mc_effect.removeEventListener(CMovieClipEvent.COMPLETE,onComp);
            _battleField["bullet_floor"].removeChild(mc_effect);
         };
         mc_effect = BattleScenceShow.getAttackedEffect(attackType,1.5);
         mc_effect.gotoAndPlay(1);
         mc_effect.addEventListener(CMovieClipEvent.COMPLETE,onComp);
         PlantsVsZombies.playSounds(SoundManager.EFFECT_4);
         if(camp == 0)
         {
            mc_effect.x = 435;
            mc_effect.y = 100;
         }
         else if(camp == 1)
         {
            mc_effect.x = 95;
            mc_effect.y = 100;
         }
         this._battleField["bullet_floor"].addChild(mc_effect);
         if(this.tremor != null)
         {
            this.tremor.clear();
            this.tremor = null;
         }
         this.tremor = new Tremor(this._battleField,12,10,4);
      }
      
      private function showAllOrgPrizes() : void
      {
         var showHelp:Function;
         var prizesWindow:OrgsPrizesWindow = null;
         if(this._scence.getExpUpOrgs().length > 0)
         {
            showHelp = function():void
            {
               if(GlobalConstants.NEW_PLAYER)
               {
                  PlantsVsZombies.helpN.show(HelpNovice.BATTLE_ORGS_PRIZE,_container);
               }
            };
            if(this._scence.getExpUpOrgs().length - (this.orgsPage - 1) * OrgsPrizesWindow.NUM > OrgsPrizesWindow.NUM)
            {
               prizesWindow = new OrgsPrizesWindow(this.showAllOrgPrizes,this._battleField);
            }
            else
            {
               prizesWindow = new OrgsPrizesWindow(this.showToolsPrizes,this._battleField);
            }
            prizesWindow.show(this._scence.getBaseOrg(),this._scence.getExpUpOrgs(),this.orgsPage,showHelp);
            ++this.orgsPage;
         }
         else
         {
            this.showToolsPrizes();
         }
      }
      
      private function showAllPrizesFlap() : void
      {
         var tt:CTimer = null;
         var onComp:Function = null;
         var t:int = 0;
         onComp = function(param1:CTimerEvent):void
         {
            tt.removeEventListener(CTimerEvent.TIMER_COMPLETE,onComp);
            tt.stop();
            tt = null;
            orgsPage = 1;
            upOrgPage = 1;
            showAllOrgPrizes();
         };
         var i:int = 0;
         while(i < this.allPrizes.length)
         {
            t = FuncKit.getRandom(500,2000);
            BattleScenceShow.showPrizeFlap(this._battleField["floor_prize"],this.allPrizes[i],this.allPrizes[i]["effect"],t);
            i++;
         }
         tt = new CTimer(3000,1);
         tt.addEventListener(CTimerEvent.TIMER_COMPLETE,onComp);
         tt.start();
      }
      
      private function showArenaResult() : void
      {
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         new ArenaResultWindow(this._battleManager.win,this.getPrizes);
         PlantsVsZombies.playFireworks(5);
      }
      
      private function showAttackedEffect(param1:BattleOrg, param2:int, param3:int) : void
      {
         var soundtype:int;
         var mc_effect:CMovieClip = null;
         var onComp:Function = null;
         var attackedOrg:BattleOrg = param1;
         var attackType:int = param2;
         var num:int = param3;
         onComp = function(param1:CMovieClipEvent):void
         {
            mc_effect.removeEventListener(CMovieClipEvent.COMPLETE,onComp);
            _battleField["bullet_floor"].removeChild(mc_effect);
         };
         if(attackType == 0)
         {
            return;
         }
         mc_effect = BattleScenceShow.getAttackedEffect(attackType,1);
         mc_effect.gotoAndPlay(1);
         mc_effect.addEventListener(CMovieClipEvent.COMPLETE,onComp);
         mc_effect.x = attackedOrg.x;
         mc_effect.y = attackedOrg.y - BattleMapManager.HEIGHT_GRID / 2;
         this._battleField["bullet_floor"].addChild(mc_effect);
         soundtype = attackType % 6;
         if(soundtype == 0)
         {
            soundtype = 6;
         }
         PlantsVsZombies.playSounds("Sound_" + soundtype);
         if(this.tremor != null)
         {
            this.tremor.clear();
            this.tremor = null;
         }
         this.tremor = new Tremor(this._battleField,12,10,4);
      }
      
      private function showCompose() : void
      {
         var _loc1_:Evlation = new Evlation(this.closeBattle);
      }
      
      private function showGeiusEffectAttacked(param1:BattleOrg, param2:Array, param3:Array, param4:int, param5:int, param6:int, param7:Number, param8:Boolean) : Boolean
      {
         var backFunc:Function;
         var attackedOrg:BattleOrg = param1;
         var geniusSkills:Array = param2;
         var geniusSkilleds:Array = param3;
         var hit:int = param4;
         var num:int = param5;
         var comp:int = param6;
         var currentHp:Number = param7;
         var isallAttackLast:Boolean = param8;
         if(geniusSkills == null && geniusSkilleds == null || geniusSkills.length == 0 && geniusSkilleds.length == 0)
         {
            return true;
         }
         if(geniusSkilleds != null && geniusSkilleds.length > 0)
         {
            if(num == hit)
            {
               attackedOrg.clearLightDongEffect();
            }
         }
         if(geniusSkills != null && geniusSkills.length > 0)
         {
            if(num == hit)
            {
               backFunc = function():void
               {
                  flapDamAndCblood(attackedOrg,attackedOrg._damage,currentHp,comp);
               };
               attackedOrg.setGeiusEffect(geniusSkills,backFunc);
            }
         }
         return true;
      }
      
      private function showExclusiveSkillsEffect(param1:BattleOrg, param2:AttackedOrg) : Boolean
      {
         var backFunc:Function = null;
         var backFunced:Function = null;
         var timeout:Function = null;
         var attacker:BattleOrg = param1;
         var attacked:AttackedOrg = param2;
         backFunc = function(param1:Object, param2:BattleOrg):void
         {
            flapDamAndCblood(param2,param2._exRallydamage,param1.old_hp,param1.camp);
         };
         backFunced = function(param1:Object, param2:BattleOrg):void
         {
            setTimeout(timeout,300,param2);
         };
         timeout = function(param1:Object):void
         {
            flapDamage(param1 as BattleOrg,param1._exdamage,1);
         };
         var attackOrg:BattleOrg = attacker;
         attackOrg.setExclusiveSkillsHp(attackOrg.getExclusiveSkillsData(),backFunc);
         attacked.getBattleOrg().setExclusiveSkillsHp(attacked.getExclusiveSkills(),backFunced);
         return true;
      }
      
      private function showHit(param1:DisplayObject, param2:int) : void
      {
         var hitT:CTimer = null;
         var onTimer:Function = null;
         var g:DisplayObject = param1;
         var hit:int = param2;
         onTimer = function(param1:CTimerEvent):void
         {
            hitT.removeEventListener(CTimerEvent.TIMER,onTimer);
            hitT.stop();
            hitT = null;
            var _loc2_:DisplayObject = StringMovieClip.getStringImage(hit + "","Yellow");
            FlapManager.flapInfos(BattleScenceShow.getAttackedPoint(g).x - _loc2_.width / 2,BattleScenceShow.getAttackedPoint(g).y,_battleField,_loc2_,1);
         };
         hitT = new CTimer(500);
         hitT.addEventListener(CTimerEvent.TIMER,onTimer);
         hitT.start();
      }
      
      private function showPossessionResult() : void
      {
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         if(this._battleManager.win)
         {
            new PossessionResultWindow(this._battleManager.win,this.closeBattle,this._honor);
         }
         else
         {
            new PossessionResultWindow(this._battleManager.win,this.showCompose,this._honor);
         }
         PlantsVsZombies.playFireworks(5);
      }
      
      private function showPrizes(param1:Array) : void
      {
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(GlobalConstants.NEW_PLAYER)
         {
            FlapManager.flapInfos2(_loc2_,_loc3_,this._battleField["floor_prize"],param1[1],(param1[1] as MovieClip).effect);
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_ = 280 + _loc4_ * 80;
               _loc3_ = 280;
               (param1[_loc4_] as MovieClip).effect.visible = false;
               FlapManager.flapInfos2(_loc2_,_loc3_,this._battleField["floor_prize"],param1[_loc4_],(param1[_loc4_] as MovieClip).effect);
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_ = FuncKit.getRandom(0,this._battleField["bg"].width - (param1[_loc4_] as MovieClip).width);
               _loc3_ = FuncKit.getRandom(0,int(this._battleField["bg"].height - (param1[_loc4_] as MovieClip).height) - 80) + 80;
               (param1[_loc4_] as MovieClip).effect.visible = false;
               FlapManager.flapInfos2(_loc2_,_loc3_,this._battleField["floor_prize"],param1[_loc4_],(param1[_loc4_] as MovieClip).effect);
               _loc4_++;
            }
         }
      }
      
      private function showServerBattleResult() : void
      {
         if(this._scence.getBattlePlayerInfo().type == PlayerInfo.QUALITYING)
         {
            PlantsVsZombies.playSounds(SoundManager.GRADE);
            new QualityingBattleResultWindow(this._battleManager.win,this._battleManager.integralAdd,this.getPrizes);
            PlantsVsZombies.playFireworks(5);
         }
         else
         {
            new KnockoutBattleResultWindow(this._battleManager.win,this._scence.getBattlePlayerInfo(),this.closeBattle);
         }
      }
      
      private function showSkill(param1:Sprite, param2:Array) : void
      {
         var temp:Class;
         var i:int = 0;
         var skillT:CTimer = null;
         var onShowSkill:Function = null;
         var onShowSkillComp:Function = null;
         var g:Sprite = param1;
         var skills:Array = param2;
         onShowSkill = function(param1:CTimerEvent):void
         {
            var _loc2_:MovieClip = null;
            var _loc3_:String = null;
            if(SkillManager.getInstance.getSkillById((skills[i] as Skill).getId()).getTouchOff() == Skill.INITIATIVE)
            {
               BattleScenceShow.showSkillLight(g as BattleOrg,(skills[i] as Skill).getGrade());
               _loc2_ = new temp();
               _loc3_ = "Lv" + (skills[i] as Skill).getGrade() + (skills[i] as Skill).getName();
               TextFilter.MiaoBian(_loc2_["t"],0);
               _loc2_["t"].text = _loc3_;
               BattleScenceShow.setSkillColor(_loc2_["t"],(skills[i] as Skill).getGrade());
               FlapManager.flapInfos(BattleScenceShow.getAttackedPoint(g).x - _loc2_.width / 2,BattleScenceShow.getAttackedPoint(g).y,_battleField,_loc2_,1);
            }
            ++i;
         };
         onShowSkillComp = function(param1:CTimerEvent):void
         {
            skillT.stop();
            skillT.removeEventListener(CTimerEvent.TIMER,onShowSkill);
            skillT.removeEventListener(CTimerEvent.TIMER_COMPLETE,onShowSkillComp);
            skillT = null;
         };
         if(skills == null || skills.length < 1)
         {
            return;
         }
         temp = DomainAccess.getClass("skill");
         i = 0;
         skillT = new CTimer(200,skills.length);
         skillT.addEventListener(CTimerEvent.TIMER,onShowSkill);
         skillT.addEventListener(CTimerEvent.TIMER_COMPLETE,onShowSkillComp);
         skillT.start();
      }
      
      private function showToolsPrizes() : void
      {
         var showHelp:Function;
         var toolsWindow:PrizesWindow = null;
         if(this.isPrizes && this._scence.getAwards() != null && this._scence.getAwards().length > 0)
         {
            showHelp = function():void
            {
               if(GlobalConstants.NEW_PLAYER)
               {
                  PlantsVsZombies.helpN.show(HelpNovice.BATTLE_SHOW_PRIZES,_container);
               }
            };
            if(!GlobalConstants.NEW_PLAYER)
            {
               if(this._battleManager.win)
               {
                  toolsWindow = new PrizesWindow(this.showGameMoneyPrize,this._battleField);
               }
               else
               {
                  toolsWindow = new PrizesWindow(this.showCompose,this._battleField);
               }
            }
            else
            {
               showHelp();
               toolsWindow = new PrizesWindow(this.playDragonFirst,this._battleField);
            }
            toolsWindow.show(this._scence.getAwards(),null);
         }
         else
         {
            this.showGameMoneyPrize();
         }
      }
      
      private function showGameMoneyPrize() : void
      {
         var _loc2_:PrizeWinowForGameMoney = null;
         var _loc1_:GameMoney = this._scence.getGameMoneyPrize();
         if(_loc1_)
         {
            _loc2_ = new PrizeWinowForGameMoney(this.showExpPrize);
            _loc2_.show(_loc1_.getMoneyValue());
         }
         else
         {
            this.showExpPrize();
         }
      }
      
      private function showExpPrize() : void
      {
         var _loc1_:Exp = this._scence.getExpPrize();
         this.showLevelup();
      }
      
      private function showLevelup() : void
      {
         var upinfos:Array = null;
         var backfuc:Function = null;
         var index:int = 0;
         var len:int = 0;
         var upwindows:PlayerUpGradeWindow = null;
         var levelupinfo:LevelUpInfo = null;
         var showSigleUp:Function = function():void
         {
            levelupinfo = upinfos[index];
            upwindows = new PlayerUpGradeWindow(backfuc);
            upwindows.show(levelupinfo.getTools(),levelupinfo.getMoney());
            PlantsVsZombies.setUserInfos();
         };
         backfuc = function():void
         {
            ++index;
            if(index >= len)
            {
               closeBattle();
            }
            else
            {
               showSigleUp();
            }
         };
         upinfos = this._scence.getUpInfos();
         if(upinfos.length > 0)
         {
            index = 0;
            len = int(upinfos.length);
            showSigleUp();
         }
         else
         {
            this.closeBattle();
         }
      }
      
      private function showXueZhanEffect(param1:Boolean) : void
      {
         this._battleField["xuezhan"].visible = param1;
         if(param1)
         {
            this._battleField["xuezhan"].addEventListener(MouseEvent.ROLL_OVER,this.xueZhanMcOver);
            this._battleField["xuezhan"].addEventListener(MouseEvent.ROLL_OUT,this.xueZhanMcOut);
         }
         else
         {
            if(this._battleField["xuezhan"].hasEventListener(MouseEvent.ROLL_OVER))
            {
               this._battleField["xuezhan"].removeEventListener(MouseEvent.ROLL_OVER,this.xueZhanMcOver);
            }
            if(this._battleField["xuezhan"].hasEventListener(MouseEvent.ROLL_OUT))
            {
               this._battleField["xuezhan"].removeEventListener(MouseEvent.ROLL_OUT,this.xueZhanMcOut);
            }
         }
      }
      
      private function start() : void
      {
         PlantsVsZombies.showDataLoading(false);
         this.playRound();
      }
      
      private function xueZhanMcOut(param1:MouseEvent) : void
      {
         this.xuezhanTip.visible = false;
         this._battleField.removeChild(this.xuezhanTip);
      }
      
      private function xueZhanMcOver(param1:MouseEvent) : void
      {
         if(this.xuezhanTip == null)
         {
            this.xuezhanTip = new XueZhanTip();
            this.xuezhanTip.x = this._battleField["xuezhan"].x + 20;
            this.xuezhanTip.y = this._battleField["xuezhan"].y + 20;
         }
         this.xuezhanTip.visible = true;
         this._battleField.addChild(this.xuezhanTip);
      }
   }
}

