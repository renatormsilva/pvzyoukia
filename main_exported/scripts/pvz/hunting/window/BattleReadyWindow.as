package pvz.hunting.window
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.res.IDestroy;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import entity.Grid;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.BattleLabel;
   import labels.BattleReadyLabel;
   import manager.APLManager;
   import manager.InitWidthAndHeightInfo;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.TeachHelpManager;
   import node.Icon;
   import node.OrganismNode;
   import pvz.battle.fore.Battlefield;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.copy.models.limit.ActivtyCopyData;
   import pvz.copy.models.stone.StoneCopyData;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import pvz.garden.rpc.GardenMonster;
   import pvz.help.HelpNovice;
   import pvz.vip.AutoRevertWindow;
   import pvz.vip.VipAddPrizePanel;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.ChallengePropWindow;
   import zlib.sets.Hashtable;
   import zlib.utils.DomainAccess;
   
   public class BattleReadyWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      public static const CDTIME_BATTLE:int = 16;
      
      public static const GENERAL:int = 2;
      
      public static const JEWEL_BATTLE:int = 14;
      
      public static const GARDEN_BATTLE:int = 17;
      
      public static const LIMIT_BATTLE:int = 13;
      
      public static const NORMAL_BATTLE:int = 0;
      
      private static const BATTLE:int = 1;
      
      private static const DIFFICULTY:int = 3;
      
      private static var MAX_BATTLE:int = 7;
      
      private static var MAX_BATTLE_ALL:int = 12;
      
      private static var MAX_STORAGE:int = 10;
      
      private static const OPENGRID:int = 2;
      
      private static const SIMPLE:int = 1;
      
      private var _battlePage:int = 1;
      
      private var _battleSprite:Sprite;
      
      private var _battle_table:Hashtable;
      
      private var _battleorgs:Array = null;
      
      private var _max_battlePage:int = 1;
      
      private var _max_readyPage:int = 0;
      
      private var _mc:MovieClip;
      
      private var _nowBattleArray:Array;
      
      private var _nowReadyArray:Array;
      
      private var _readyArray:Array;
      
      private var _readyPage:int = 1;
      
      private var _readySprite:Sprite;
      
      private var area:int = 0;
      
      private var enemy:Array;
      
      private var isChoose:Boolean = false;
      
      private var map:MovieClip;
      
      private var opennum:int = 0;
      
      private var pic_label:Class;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var start_mouseX:int = 0;
      
      private var start_mouseY:int = 0;
      
      private var _battleType:int = 0;
      
      private var _canbeOpenGird:DisplayObject;
      
      private var _cost:int = 0;
      
      private var _holeid:int = 0;
      
      private var backHunting:Function;
      
      private var can_open_grid:Class = null;
      
      private var difficulty:int = 0;
      
      private var hiddenFun:Function;
      
      private var isV:Boolean = false;
      
      private var lock_grid:Class = null;
      
      private var newPreAreanaOrags:Array = [];
      
      private var open_grid:Class = null;
      
      private var vip3prziebutton:MovieClip;
      
      private var vip4prziebutton:MovieClip;
      
      private var vipRevertBoldIcon:MovieClip;
      
      public var gardenMonster:GardenMonster;
      
      public function BattleReadyWindow(param1:int = 0)
      {
         super();
         this.showType = PANEL_TYPE_1;
         this._battleType = param1;
         var _loc2_:Class = DomainAccess.getClass("battleReadyWindow");
         this._mc = new _loc2_();
         this._readyArray = new Array();
         this._nowReadyArray = new Array();
         this._nowBattleArray = new Array(MAX_BATTLE);
         this._mc["text2"].text = this._battlePage;
         this._mc["_mc_diff"].visible = false;
         this._mc["star"].visible = false;
         this._battle_table = new Hashtable();
         this.addDiffEvent();
         this.addButtonEvent();
         this._mc.visible = false;
         this._mc["zombie"]["zombies"].x = -200;
         this._mc["zombie"]["zombies"].y = -230;
         if(this.pic_label == null)
         {
            this.pic_label = DomainAccess.getClass("pic_label");
         }
         this.addEvent();
         this.lock_grid = DomainAccess.getClass("lockLabel");
         this.open_grid = DomainAccess.getClass("openLabel");
         this.can_open_grid = DomainAccess.getClass("canopenLabel");
         if(GlobalConstants.NEW_PLAYER || !MenuButtonManager.instance.checkBtnUpLimit("_bt_vip",this.playerManager.getPlayer().getGrade()))
         {
            return;
         }
         if(this._battleType == LIMIT_BATTLE || this._battleType == GARDEN_BATTLE)
         {
            this._mc.star.visible = false;
            this._mc._mc_holeDiff.visible = false;
            this._mc._bt_diff_left.visible = false;
            this._mc._bt_diff_right.visible = false;
         }
         if(this._battleType == JEWEL_BATTLE)
         {
            this._mc["_mc_diff"].gotoAndStop(2);
            this._mc._mc_holeDiff.visible = false;
            this._mc["star"].visible = true;
         }
         if(this._battleType == CDTIME_BATTLE)
         {
            this._mc.star.visible = false;
            this._mc._mc_holeDiff.visible = false;
            this._mc._bt_diff_left.visible = false;
            this._mc._bt_diff_right.visible = false;
         }
         this.initVipAutoRevert();
         if(this._battleType != LIMIT_BATTLE && this._battleType != CDTIME_BATTLE && this._battleType != JEWEL_BATTLE && this._battleType != GARDEN_BATTLE)
         {
            this.initVipPrizeButton();
         }
      }
      
      override public function destroy() : void
      {
         PlantsVsZombies._node.removeChild(this._mc);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == BATTLE)
         {
            _loc5_.callOOO(param2,param3,rest[0],rest[1],rest[2]);
         }
         else if(param3 == OPENGRID)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == LIMIT_BATTLE || param3 == JEWEL_BATTLE)
         {
            _loc5_.callOOO(param2,param3,rest[0],rest[1],rest[2]);
         }
         else if(param3 == GARDEN_BATTLE)
         {
            _loc5_.callOOOO(param2,param3,rest[0],rest[1],rest[2],rest[3]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:BattlefieldControlManager = null;
         var _loc4_:BattlefieldControlManager = null;
         var _loc5_:int = 0;
         var _loc6_:BattlefieldControlManager = null;
         var _loc7_:BattlefieldControlManager = null;
         var _loc8_:Organism = null;
         if(param1 == BATTLE)
         {
            PlantsVsZombies.changeMoneyOrExp(-this._cost,PlantsVsZombies.MONEY);
            this.playerManager.getPlayer().setNowHunts(this.playerManager.getPlayer().getNowHunts() - 1);
            PlantsVsZombies.ChangeUserHuntNum();
            if(this.playerManager.getPlayer().getNowHunts() < 1)
            {
               new ChallengePropWindow(ChallengePropWindow.TYPE_ONE);
            }
            _loc3_ = new BattlefieldControlManager();
            _loc3_.doBattleInfosRPC(param2,BattlefieldControlManager.HUNTING);
            new Battlefield(this._battleorgs,this.enemy,_loc3_,this.backHunting,BattlefieldControlManager.HUNTING);
            this.clear();
         }
         else if(param1 == LIMIT_BATTLE)
         {
            _loc4_ = new BattlefieldControlManager();
            _loc4_.doBattleInfosRPC(param2,BattlefieldControlManager.HUNTING);
            new Battlefield(this._battleorgs,this.enemy,_loc4_,this.backHunting,BattlefieldControlManager.HUNTING);
            this.clear();
         }
         else if(param1 == JEWEL_BATTLE)
         {
            _loc5_ = this.playerManager.getPlayer().getStoneChaCount();
            this.playerManager.getPlayer().setStoneChaCount(_loc5_ - 1);
            _loc6_ = new BattlefieldControlManager();
            _loc6_.doBattleInfosRPC(param2,BattlefieldControlManager.HUNTING);
            new Battlefield(this._battleorgs,this.enemy,_loc6_,this.backHunting,BattlefieldControlManager.JEWEL_BATTLE);
            this.clear();
         }
         else if(param1 == GARDEN_BATTLE)
         {
            _loc7_ = new BattlefieldControlManager();
            _loc7_.doBattleInfosRPC(param2,BattlefieldControlManager.HUNTING);
            for each(_loc8_ in this._battleorgs)
            {
               _loc8_.setHp(_loc8_.getHp_max().toString());
            }
            new Battlefield(this._battleorgs,this.enemy,_loc7_,this.backHunting,BattlefieldControlManager.HUNTING);
            this.clear();
         }
         else if(param1 == OPENGRID)
         {
            TeachHelpManager.I.hideArrow();
            this.playerManager.getPlayer().setMoney(this.playerManager.getPlayer().getMoney() - this.playerManager.getPlayer().getBattleOpenMoney());
            this.playerManager.getPlayer().setBattle_num(this.playerManager.getPlayer().getBattle_num() + 1);
            if(this.playerManager.getPlayer().getBattle_num() <= PlayerManager.ARENA_ORG_NUM)
            {
               this.playerManager.getPlayer().setArenaOrgNum(this.playerManager.getPlayer().getBattle_num());
            }
            this.playerManager.getPlayer().setBattleOpenGrade(param2.open_grid.grade);
            this.playerManager.getPlayer().setBattleOpenMoney(param2.open_grid.money);
            this.setArea(this.area);
            this._max_battlePage = int((this.playerManager.getPlayer().getBattle_num() - 1) / MAX_BATTLE) + 1;
            this.showBattlePage(this._battlePage);
            PlantsVsZombies.setUserInfos();
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting017"));
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         if(param1 == BATTLE)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting018"));
            this.backHunting();
            this.clear();
            PlantsVsZombies.showDataLoading(false);
            return;
         }
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("hunting019"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      public function show(param1:int, param2:Array, param3:Function, param4:String, param5:Function, param6:int) : void
      {
         var showHelp:Function = null;
         var star:int = 0;
         var holeid:int = param1;
         var organisms:Array = param2;
         var backFun:Function = param3;
         var awardsinfo:String = param4;
         var hiddenFunc:Function = param5;
         var cost:int = param6;
         showHelp = function():void
         {
            showEnemyOrgs();
            removeBG();
            if(_canbeOpenGird)
            {
               TeachHelpManager.I.showArrowAtBattleReadyWindow(_canbeOpenGird);
            }
            if(GlobalConstants.NEW_PLAYER)
            {
               PlantsVsZombies.helpN.show(HelpNovice.BATTLEREADY_CHOOSE_ORG,PlantsVsZombies._node as DisplayObjectContainer);
            }
         };
         var showEnemyOrgs:Function = function():void
         {
            if(GlobalConstants.NEW_PLAYER)
            {
               showOrganisms(PlantsVsZombies.helpN.getEnemy());
            }
            else
            {
               showOrganisms(enemy);
            }
         };
         this._mc["challageTimes_title"].visible = true;
         this.backHunting = backFun;
         this.hiddenFun = hiddenFunc;
         this._holeid = holeid;
         this._cost = cost;
         this.enemy = organisms;
         if(GlobalConstants.NEW_PLAYER)
         {
            this._mc["_mc_holeDiff"].gotoAndStop(2);
         }
         this.enemy = BattleMapManager.orderOrg(this.enemy);
         if(this._battleType == NORMAL_BATTLE || this._battleType == GARDEN_BATTLE)
         {
            if(this.playerManager.getPlayer().getHoleDifficulty() == 0)
            {
               this.changeDifficulty(GENERAL);
            }
            else
            {
               this.changeDifficulty(this.playerManager.getPlayer().getHoleDifficulty());
            }
         }
         if(this._battleType == JEWEL_BATTLE)
         {
            star = StoneCopyData.getCurrentCp().getStar() > 0 ? StoneCopyData.getCurrentCp().getStar() : 1;
            this.changeStarDifficulty(star);
         }
         this._mc.visible = true;
         this.showStorageOrganisms();
         this.setArea(this.area);
         this.setLastBattleNum();
         PlantsVsZombies._node.addChild(this._mc);
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         onShowEffectBig(this._mc,showHelp);
         if(this._battleType == JEWEL_BATTLE)
         {
            this._max_battlePage = int((Math.min(StoneCopyData.getCurrentCp().getCaveGrid(),this.playerManager.getPlayer().getBattle_num()) - 1) / MAX_BATTLE) + 1;
         }
         else
         {
            this._max_battlePage = int((this.playerManager.getPlayer().getBattle_num() - 1) / MAX_BATTLE) + 1;
         }
         this.showBattlePage(this._battlePage);
         this.preAreanaPlants();
      }
      
      private function addBattleArray(param1:Organism) : void
      {
         var _loc2_:BattleLabel = new BattleLabel(new this.pic_label());
         _loc2_.update(param1,this.removerBattleArray);
         if(this._battle_table[param1.getId() + ""] == null)
         {
            this._battle_table.add(param1.getId() + "",_loc2_);
         }
         this._battlePage = int((this._battle_table.keys.length - 1) / MAX_BATTLE) + 1;
         this.area += param1.getWidth() * param1.getHeight();
         this.setArea(this.area);
         this._mc["text2"].text = this._battlePage;
         this.showBattlePage(this._battlePage);
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.show(HelpNovice.BATTLEREADY_ENTER_BATTLE,PlantsVsZombies._node as DisplayObjectContainer);
         }
      }
      
      private function addButtonEvent() : void
      {
         this._mc["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_diff_left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_diff_right"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addDiffEvent() : void
      {
         this._mc["_bt_diff_left"].addEventListener(MouseEvent.ROLL_OUT,this.onDiffOut);
         this._mc["_bt_diff_left"].addEventListener(MouseEvent.ROLL_OVER,this.onDiffOver);
         this._mc["_bt_diff_right"].addEventListener(MouseEvent.ROLL_OUT,this.onDiffOut);
         this._mc["_bt_diff_right"].addEventListener(MouseEvent.ROLL_OVER,this.onDiffOver);
      }
      
      private function addEvent() : void
      {
         this._mc["zombie"]["zombies"].addEventListener(MouseEvent.MOUSE_DOWN,this.mousedown);
         this._mc["zombie"]["zombies"].addEventListener(MouseEvent.MOUSE_UP,this.mouseup);
         this._mc["zombie"]["zombies"].addEventListener(MouseEvent.MOUSE_MOVE,this.changeLoation);
      }
      
      private function addorg(param1:Grid) : void
      {
         var _loc2_:OrganismNode = new OrganismNode(param1.getOrg(),1,OrganismNode.BATTLE_READY,true);
         _loc2_.x = param1.getX() * BattleMapManager.WIDE_GRID + param1.getWide() * BattleMapManager.WIDE_GRID / 2;
         _loc2_.y = param1.getY() * BattleMapManager.HEIGHT_GRID + param1.getHeigth() * BattleMapManager.HEIGHT_GRID;
         this.map.addChild(_loc2_);
      }
      
      private function battleReady(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         PlantsVsZombies.showDataLoading(true);
         this._battleorgs = param1;
         if(this._battleType == NORMAL_BATTLE || this._battleType == GARDEN_BATTLE)
         {
            this.playerManager.getPlayer().getPreAreanaOrgs().length = 0;
            for each(_loc2_ in this._battle_table.keys.toArray())
            {
               this.playerManager.getPlayer().getPreAreanaOrgs().push((this._battle_table[_loc2_] as BattleLabel).getOrg());
            }
         }
         else if(this._battleType == LIMIT_BATTLE)
         {
            this.playerManager.getPlayer().getPreLimitCopyOrgs().length = 0;
            for each(_loc3_ in this._battle_table.keys.toArray())
            {
               this.playerManager.getPlayer().getPreLimitCopyOrgs().push((this._battle_table[_loc3_] as BattleLabel).getOrg());
            }
         }
         else if(this._battleType == CDTIME_BATTLE)
         {
            this.playerManager.getPlayer().getPreCdTimeCopyOrgs().length = 0;
            for each(_loc4_ in this._battle_table.keys.toArray())
            {
               this.playerManager.getPlayer().getPreCdTimeCopyOrgs().push((this._battle_table[_loc4_] as BattleLabel).getOrg());
            }
         }
         else if(this._battleType == JEWEL_BATTLE)
         {
            this.playerManager.getPlayer().getPreJewelCopyOrgs().length = 0;
            for each(_loc5_ in this._battle_table.keys.toArray())
            {
               this.playerManager.getPlayer().getPreJewelCopyOrgs().push((this._battle_table[_loc5_] as BattleLabel).getOrg());
            }
         }
         if(this._battleType == NORMAL_BATTLE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_HUNTING_BATTLE,BATTLE,this._holeid,this.getMyOrgsArray(param1),this.difficulty);
         }
         else if(this._battleType == LIMIT_BATTLE || this._battleType == CDTIME_BATTLE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVTY_COPY_BATTLE,LIMIT_BATTLE,this._holeid,ActivtyCopyData.getCopyId(),this.getMyOrgsArray(param1));
         }
         else if(this._battleType == JEWEL_BATTLE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STONE_COPY_BATTLE,JEWEL_BATTLE,this._holeid,this.getMyOrgsArray(param1),this.difficulty);
         }
         else if(this._battleType == GARDEN_BATTLE)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GARDEN_BATTLE,GARDEN_BATTLE,this.gardenMonster.owid,this.gardenMonster.position.x,this.gardenMonster.position.y,this.getMyOrgsArray(param1));
         }
      }
      
      private function battleReadyHelp() : void
      {
         PlantsVsZombies.helpN.clear();
         var _loc1_:BattlefieldControlManager = new BattlefieldControlManager();
         var _loc2_:XML = new XML(PlantsVsZombies.helpN.getBattleInfo());
         _loc1_.doBattleInfos(_loc2_);
         new Battlefield(PlantsVsZombies.helpN.getMyOrgs(),PlantsVsZombies.helpN.getEnemy(),_loc1_,this.backHunting,BattlefieldControlManager.HUNTING);
         this.clear();
      }
      
      private function changeDifficulty(param1:int) : void
      {
         if(this.enemy == null)
         {
            return;
         }
         this.difficulty = param1;
         this.playerManager.getPlayer().setHoleDifficulty(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.enemy.length)
         {
            (this.enemy[_loc2_] as Organism).setDifficulty(this.difficulty);
            _loc2_++;
         }
         this._mc["_mc_holeDiff"].gotoAndStop(this.difficulty);
      }
      
      private function changeLoation(param1:MouseEvent) : void
      {
         if(!this.isChoose)
         {
            return;
         }
         var _loc2_:int = this._mc.mouseX - this.start_mouseX;
         var _loc3_:int = this._mc.mouseY - this.start_mouseY;
         if(this._mc["zombie"]["zombies"].x + _loc2_ > 0 || this._mc["zombie"]["zombies"].x + _loc2_ < this._mc["zombie"]["z_mask"].width - this._mc["zombie"]["zombies"].width)
         {
            _loc2_ = 0;
         }
         if(this._mc["zombie"]["zombies"].y + _loc3_ > 0 || this._mc["zombie"]["zombies"].y + _loc3_ < this._mc["zombie"]["z_mask"].height - this._mc["zombie"]["zombies"].height)
         {
            _loc3_ = 0;
         }
         this._mc["zombie"]["zombies"].x += _loc2_;
         this._mc["zombie"]["zombies"].y += _loc3_;
         this.start_mouseX = this._mc.mouseX;
         this.start_mouseY = this._mc.mouseY;
      }
      
      private function changeStarDifficulty(param1:int) : void
      {
         this.difficulty = param1;
         if(this.enemy == null)
         {
            return;
         }
         this.enemy = new Array();
         this.enemy = StoneCopyData.getEmamysByCurrentStarLevel(param1);
         this._mc["star"].gotoAndStop(param1);
         this.showOrganisms(this.enemy);
      }
      
      private function checkAddBattleNum(param1:int) : Boolean
      {
         var _loc2_:ActionWindow = null;
         if(this.playerManager.getPlayer().getBattleOpenGrade() != 0 && this.playerManager.getPlayer().getBattleOpenGrade() <= this.playerManager.getPlayer().getGrade() && this.area + param1 > this.playerManager.getPlayer().getBattle_num())
         {
            if(this.playerManager.getPlayer().getMoney() >= this.playerManager.getPlayer().getBattleOpenMoney())
            {
               _loc2_ = new ActionWindow();
               _loc2_.init(1,Icon.SYSTEM,"",LangManager.getInstance().getLanguage("hunting020",this.playerManager.getPlayer().getBattleOpenMoney()),this.openBattleWindow,true);
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting021",this.playerManager.getPlayer().getBattleOpenMoney()));
            }
            return false;
         }
         if(this._battleType == JEWEL_BATTLE)
         {
            if(this.area + param1 > Math.min(StoneCopyData.getCurrentCp().getCaveGrid(),this.playerManager.getPlayer().getBattle_num()))
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting022"));
               return false;
            }
         }
         else if(this.area + param1 > this.playerManager.getPlayer().getBattle_num())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting022"));
            return false;
         }
         return true;
      }
      
      private function checkOrganisms(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Organism).getHp().toNumber() > 0 && (param1[_loc3_] as Organism).getGardenId() == 0)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function checkStartBattle() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.getArrayFromBattletable(this._battle_table).length < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting023"));
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function clear() : void
      {
         this.area = 0;
         this._readyPage = 1;
         this._mc["text1"].text = "";
         this.removeButtonEvent();
         this.clearArray();
         this._battle_table = null;
         this.clearMap();
         this.vipRevertBoldIcon = null;
         this.vip3prziebutton = null;
         this.vip4prziebutton = null;
         if(this._battleSprite != null)
         {
            FuncKit.clearAllChildrens(this._battleSprite);
         }
         this._battleSprite = null;
         FuncKit.clearAllChildrens(this._mc["battle_plats"]);
         if(this._battleSprite != null && this._battleSprite.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._battleSprite);
         }
         if(this._readySprite != null && this._readySprite.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._readySprite);
         }
      }
      
      private function clearAllText() : void
      {
         FuncKit.clearAllChildrens(this._mc["battle_num"]);
         FuncKit.clearAllChildrens(this._mc["org_num"]);
      }
      
      private function clearArray() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:BattleReadyLabel = null;
         if(this._readyArray != null && this._readyArray.length > 0)
         {
            _loc1_ = int(this._readyArray.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._readyArray[_loc2_];
               _loc3_.destroy();
               this._readyArray[_loc2_] = null;
               _loc2_++;
            }
         }
         this.enemy = null;
         this._readyArray = null;
         this._nowReadyArray = null;
         this._nowBattleArray = null;
      }
      
      private function clearMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:OrganismNode = null;
         if(this.map != null && this.map.numChildren > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.map.numChildren)
            {
               if(this.map.getChildAt(_loc1_) is OrganismNode)
               {
                  _loc2_ = this.map.getChildAt(_loc1_) as OrganismNode;
                  _loc2_.destroy();
                  this.map.removeChild(_loc2_);
               }
               _loc1_++;
            }
         }
         this.map = null;
      }
      
      private function doLayoutBattleSprite(param1:Array) : void
      {
         this._canbeOpenGird = null;
         if(this._battleSprite != null)
         {
            this._mc["battle_plats"].removeChild(this._battleSprite);
         }
         this._battleSprite = new Sprite();
         this._nowBattleArray = new Array(MAX_BATTLE);
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_].x = _loc2_ % MAX_BATTLE * param1[_loc2_].width;
            this._battleSprite.addChild(param1[_loc2_]);
            if(param1[_loc2_] is this.can_open_grid)
            {
               this._canbeOpenGird = param1[_loc2_] as DisplayObject;
            }
            _loc2_++;
         }
         this._mc["battle_plats"].addChild(this._battleSprite);
      }
      
      private function doLayoutReadySprite() : void
      {
         var _loc1_:int = 1;
         if(this._readySprite != null)
         {
            this._mc["ready_plants"].removeChild(this._readySprite);
         }
         this._readySprite = new Sprite();
         var _loc2_:* = int(this._nowReadyArray.length - 1);
         while(_loc2_ >= 0)
         {
            this._nowReadyArray[_loc2_].y = int(_loc2_ / 5) * InitWidthAndHeightInfo.ORG_LABEL_HEIGHT;
            this._nowReadyArray[_loc2_].x = _loc2_ % 5 * InitWidthAndHeightInfo.ORG_LABEL_WIDTH;
            this._readySprite.addChild(this._nowReadyArray[_loc2_]);
            _loc2_--;
         }
         this._mc["ready_plants"].addChild(this._readySprite);
      }
      
      private function getArrayFromBattletable(param1:Hashtable) : Array
      {
         var _loc3_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.keys.toArray())
         {
            _loc2_.push(param1[_loc3_].getOrg());
         }
         return _loc2_;
      }
      
      private function getMyOrgsArray(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push((param1[_loc3_] as Organism).getId());
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getMyOrgsString(param1:Array) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_ == "")
            {
               _loc2_ += (param1[_loc3_] as Organism).getId();
            }
            else
            {
               _loc2_ += "," + (param1[_loc3_] as Organism).getId();
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getsize() : int
      {
         var _loc2_:Organism = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.playerManager.getPlayer().getPreJewelCopyOrgs())
         {
            _loc1_ += _loc2_.getHeight() * _loc2_.getWidth();
         }
         return _loc1_;
      }
      
      private function hidden() : void
      {
         TeachHelpManager.I.hideArrow();
         onHiddenEffectBig(this._mc,this.destroy);
      }
      
      private function initReadyArray(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = this.newPreAreanaOrags;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(this._battleType == GARDEN_BATTLE)
            {
               this._readyArray[_loc3_] = new BattleReadyLabel(BattleReadyLabel.GARDEN);
            }
            else
            {
               this._readyArray[_loc3_] = new BattleReadyLabel(BattleReadyLabel.HUNT);
            }
            (this._readyArray[_loc3_] as BattleReadyLabel).update(param1[_loc3_],this.addBattleArray,this.checkAddBattleNum,this.removerBattleArray);
            _loc3_++;
         }
         this._max_readyPage = int((param1.length - 1) / MAX_STORAGE) + 1;
      }
      
      private function initVipAutoRevert() : void
      {
         this.vipRevertBoldIcon = GetDomainRes.getSprite("vip.revertBoldIcon") as MovieClip;
         this.vipRevertBoldIcon.buttonMode = true;
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
         {
            this.isV = true;
         }
         else
         {
            this.isV = false;
         }
         if(this.isV && this.playerManager.getPlayer().getVipLevel() == 4)
         {
            this.vipRevertBoldIcon.gotoAndStop(1);
         }
         else
         {
            this.vipRevertBoldIcon.gotoAndStop(3);
         }
         this.vipRevertBoldIcon.x = 286;
         this.vipRevertBoldIcon.y = 135;
         this._mc.addChild(this.vipRevertBoldIcon);
         this.vipRevertBoldIcon.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.vipRevertBoldIcon.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.vipRevertBoldIcon.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function initVipPrizeButton() : void
      {
         this.vip3prziebutton = GetDomainRes.getSprite("vipPrize3") as MovieClip;
         this.vip4prziebutton = GetDomainRes.getSprite("vipPrize4") as MovieClip;
         this.vip3prziebutton.buttonMode = true;
         this.vip4prziebutton.buttonMode = true;
         this._mc.addChild(this.vip4prziebutton);
         this._mc.addChild(this.vip3prziebutton);
         this._mc.addChild(this.vipRevertBoldIcon);
         this.vip3prziebutton.name = "vip3button";
         this.vip4prziebutton.name = "vip4button";
         this.vip3prziebutton.x = this.vipRevertBoldIcon.x + this.vipRevertBoldIcon.width + 3;
         this.vip4prziebutton.x = this.vip3prziebutton.x + this.vip3prziebutton.width + 3;
         this.vip3prziebutton.y = this.vip4prziebutton.y = this.vipRevertBoldIcon.y;
         if(this.isV)
         {
            if(this.playerManager.getPlayer().getVipLevel() < 3)
            {
               this.vip3prziebutton.gotoAndStop(2);
               this.vip4prziebutton.gotoAndStop(2);
            }
            else if(this.playerManager.getPlayer().getVipLevel() == 3)
            {
               this.vip3prziebutton.gotoAndStop(1);
               this.vip4prziebutton.gotoAndStop(2);
            }
            else
            {
               this.vip3prziebutton.gotoAndStop(1);
               this.vip4prziebutton.gotoAndStop(1);
            }
         }
         else
         {
            this.vip3prziebutton.gotoAndStop(2);
            this.vip4prziebutton.gotoAndStop(2);
         }
         this.vip3prziebutton.addEventListener(MouseEvent.CLICK,this.vipPrizeClickHandle);
         this.vip3prziebutton.addEventListener(MouseEvent.ROLL_OVER,this.vipPrizeOver1Handle);
         this.vip3prziebutton.addEventListener(MouseEvent.ROLL_OUT,this.vipPrizeOut1Handle);
         this.vip4prziebutton.addEventListener(MouseEvent.CLICK,this.vipPrizeClickHandle);
         this.vip4prziebutton.addEventListener(MouseEvent.ROLL_OVER,this.vipPrizeOver1Handle);
         this.vip4prziebutton.addEventListener(MouseEvent.ROLL_OUT,this.vipPrizeOut1Handle);
      }
      
      private function mousedown(param1:MouseEvent) : void
      {
         this.isChoose = true;
         this.start_mouseX = this._mc.mouseX;
         this.start_mouseY = this._mc.mouseY;
      }
      
      private function mouseup(param1:MouseEvent) : void
      {
         this.isChoose = false;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            if(this._battle_table == null)
            {
               return;
            }
            if(!this.checkStartBattle())
            {
               return;
            }
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(GlobalConstants.NEW_PLAYER)
            {
               this.battleReadyHelp();
            }
            else
            {
               this.battleReady(this.getArrayFromBattletable(this._battle_table));
            }
            this.hidden();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
            if(this.hiddenFun != null)
            {
               this.hiddenFun();
            }
            this.clear();
            this.hidden();
         }
         else if(param1.currentTarget.name == "bt_add1")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._readyPage == this._max_readyPage)
            {
               return;
            }
            ++this._readyPage;
            this.showReadyPage(this._readyPage);
            this._mc["text1"].text = this._readyPage + "/" + this._max_readyPage;
         }
         else if(param1.currentTarget.name == "bt_dec1")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._readyPage <= 1)
            {
               return;
            }
            --this._readyPage;
            this.showReadyPage(this._readyPage);
            this._mc["text1"].text = this._readyPage + "/" + this._max_readyPage;
         }
         else if(param1.currentTarget.name == "bt_add2")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._battlePage == this._max_battlePage)
            {
               return;
            }
            ++this._battlePage;
            this.showBattlePage(this._battlePage);
            this._mc["text2"].text = this._battlePage;
         }
         else if(param1.currentTarget.name == "bt_dec2")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._battlePage <= 1)
            {
               return;
            }
            --this._battlePage;
            this.showBattlePage(this._battlePage);
            this._mc["text2"].text = this._battlePage;
         }
         else if(param1.currentTarget.name == "_bt_diff_left")
         {
            if(this.difficulty < 2)
            {
               return;
            }
            --this.difficulty;
            if(this._battleType == JEWEL_BATTLE)
            {
               this.changeStarDifficulty(this.difficulty);
            }
            else
            {
               this.changeDifficulty(this.difficulty);
            }
         }
         else if(param1.currentTarget.name == "_bt_diff_right")
         {
            if(this.difficulty > 2)
            {
               return;
            }
            ++this.difficulty;
            if(this._battleType == JEWEL_BATTLE)
            {
               this.changeStarDifficulty(this.difficulty);
            }
            else
            {
               this.changeDifficulty(this.difficulty);
            }
         }
      }
      
      private function onDiffOut(param1:MouseEvent) : void
      {
         this._mc["_mc_diff"].visible = false;
      }
      
      private function onDiffOver(param1:MouseEvent) : void
      {
         this._mc["_mc_diff"].visible = true;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var back:Function = null;
         var event:MouseEvent = param1;
         back = function():void
         {
            if(playerManager.isVip(playerManager.getPlayer().getVipTime()) != null)
            {
               isV = true;
            }
            else
            {
               isV = false;
            }
            if(isV && playerManager.getPlayer().getVipLevel() == 4)
            {
               vipRevertBoldIcon.gotoAndStop(1);
            }
            else
            {
               vipRevertBoldIcon.gotoAndStop(3);
            }
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         new AutoRevertWindow(back);
      }
      
      private function onOpenlabelClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionWindow = null;
         if(this.playerManager.getPlayer().getBattleOpenGrade() != 0 && this.playerManager.getPlayer().getBattleOpenGrade() <= this.playerManager.getPlayer().getGrade())
         {
            if(this.playerManager.getPlayer().getMoney() >= this.playerManager.getPlayer().getBattleOpenMoney())
            {
               _loc2_ = new ActionWindow();
               _loc2_.init(1,Icon.SYSTEM,"",LangManager.getInstance().getLanguage("hunting020",this.playerManager.getPlayer().getBattleOpenMoney()),this.openBattleWindow,true);
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting021",this.playerManager.getPlayer().getBattleOpenMoney()));
            }
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         if(this.isV && this.playerManager.getPlayer().getVipLevel() == 4)
         {
            this.vipRevertBoldIcon.gotoAndStop(1);
         }
         else
         {
            this.vipRevertBoldIcon.gotoAndStop(3);
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(this.isV && this.playerManager.getPlayer().getVipLevel() == 4)
         {
            this.vipRevertBoldIcon.gotoAndStop(2);
         }
         else
         {
            this.vipRevertBoldIcon.gotoAndStop(4);
         }
      }
      
      private function openBattleWindow() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_HUNTING_OPENGRID,OPENGRID);
      }
      
      private function orderBattle(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getOrg().getWidth() * param1[_loc4_ - 1].getOrg().getHeight() < _loc3_.getOrg().getWidth() * _loc3_.getOrg().getHeight())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function orderOrgByIsGarden(param1:Array, param2:Boolean) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param2)
            {
               if((param1[_loc4_].getOrg() as Organism).getGardenId() != 0)
               {
                  _loc3_.push(param1[_loc4_]);
               }
            }
            else if((param1[_loc4_].getOrg() as Organism).getGardenId() == 0)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function orderOrgsByGrade(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getOrg().getGrade() < _loc3_.getOrg().getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function preAreanaPlants() : void
      {
         var _loc1_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Organism = null;
         var _loc6_:int = 0;
         var _loc7_:Organism = null;
         if(this._battleType == NORMAL_BATTLE || this._battleType == GARDEN_BATTLE)
         {
            _loc1_ = this.playerManager.getPlayer().getPreAreanaOrgs();
         }
         else if(this._battleType == LIMIT_BATTLE)
         {
            _loc1_ = this.playerManager.getPlayer().getPreLimitCopyOrgs();
         }
         else if(this._battleType == CDTIME_BATTLE)
         {
            _loc1_ = this.playerManager.getPlayer().getPreCdTimeCopyOrgs();
         }
         else if(this._battleType == JEWEL_BATTLE)
         {
            if(StoneCopyData.getCurrentCp().getCaveGrid() < this.getsize())
            {
               this.playerManager.getPlayer().getPreJewelCopyOrgs().length = 0;
            }
            _loc1_ = this.playerManager.getPlayer().getPreJewelCopyOrgs();
         }
         var _loc2_:Boolean = true;
         for(_loc3_ in _loc1_)
         {
            _loc6_ = 0;
            while(_loc6_ < this.playerManager.getPlayer().getAllOrganism().length)
            {
               if(this.playerManager.getPlayer().getAllOrganism()[_loc6_].getId() == _loc1_[_loc3_].getId())
               {
                  if(this._battleType == GARDEN_BATTLE)
                  {
                     this.newPreAreanaOrags.push(this.playerManager.getPlayer().getAllOrganism()[_loc6_]);
                  }
                  else if(this.playerManager.getPlayer().getAllOrganism()[_loc6_].getHp() > 0)
                  {
                     if(this.playerManager.getPlayer().getAllOrganism()[_loc6_].getGardenId() == 0)
                     {
                        this.newPreAreanaOrags.push(this.playerManager.getPlayer().getAllOrganism()[_loc6_]);
                     }
                  }
               }
               _loc6_++;
            }
         }
         this.playerManager.getPlayer().setPreAreanaOrgs(this.newPreAreanaOrags);
         _loc4_ = 0;
         for each(_loc5_ in this.newPreAreanaOrags)
         {
            _loc4_ += _loc5_.getWidth() * _loc5_.getHeight();
         }
         if(this.playerManager.getPlayer().getBattle_num() - _loc4_ < 0)
         {
            this.newPreAreanaOrags.length = 0;
         }
         else
         {
            for each(_loc7_ in this.newPreAreanaOrags)
            {
               this._battle_table.keys.toArray().push(_loc7_);
               this.addBattleArray(_loc7_);
            }
         }
      }
      
      private function removeButtonEvent() : void
      {
         this._mc["ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_diff_left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_diff_right"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["zombie"]["zombies"].removeEventListener(MouseEvent.MOUSE_DOWN,this.mousedown);
         this._mc["zombie"]["zombies"].removeEventListener(MouseEvent.MOUSE_UP,this.mouseup);
         this._mc["zombie"]["zombies"].removeEventListener(MouseEvent.MOUSE_MOVE,this.changeLoation);
         this._mc["_bt_diff_left"].removeEventListener(MouseEvent.ROLL_OUT,this.onDiffOut);
         this._mc["_bt_diff_left"].removeEventListener(MouseEvent.ROLL_OVER,this.onDiffOver);
         this._mc["_bt_diff_right"].removeEventListener(MouseEvent.ROLL_OUT,this.onDiffOut);
         this._mc["_bt_diff_right"].removeEventListener(MouseEvent.ROLL_OVER,this.onDiffOver);
         if(GlobalConstants.NEW_PLAYER || !MenuButtonManager.instance.checkBtnUpLimit("_bt_vip",this.playerManager.getPlayer().getGrade()) || this._battleType == LIMIT_BATTLE)
         {
            return;
         }
         if(this._battleType != LIMIT_BATTLE && this._battleType != CDTIME_BATTLE && this._battleType != JEWEL_BATTLE && this._battleType != GARDEN_BATTLE)
         {
            this.vip3prziebutton.removeEventListener(MouseEvent.CLICK,this.vipPrizeClickHandle);
            this.vip3prziebutton.removeEventListener(MouseEvent.ROLL_OVER,this.vipPrizeOver1Handle);
            this.vip3prziebutton.removeEventListener(MouseEvent.ROLL_OUT,this.vipPrizeOut1Handle);
            this.vip4prziebutton.removeEventListener(MouseEvent.CLICK,this.vipPrizeClickHandle);
            this.vip4prziebutton.removeEventListener(MouseEvent.ROLL_OVER,this.vipPrizeOver1Handle);
            this.vip4prziebutton.removeEventListener(MouseEvent.ROLL_OUT,this.vipPrizeOut1Handle);
         }
         this.vipRevertBoldIcon.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.vipRevertBoldIcon.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.vipRevertBoldIcon.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function removerBattleArray(param1:Organism) : void
      {
         if(this._battle_table[param1.getId() + ""] != null)
         {
            this._battle_table.remove(param1.getId() + "");
         }
         this._battlePage = int((this._battle_table.keys.length - 1) / MAX_BATTLE) + 1;
         this._mc["text2"].text = this._battlePage;
         this.area -= param1.getWidth() * param1.getHeight();
         this.setArea(this.area);
         this.showBattlePage(this._battlePage);
         this.setReadyArray(param1.getId());
      }
      
      private function setArea(param1:int) : void
      {
         FuncKit.clearAllChildrens(this._mc["org_num"]);
         if(this.playerManager.getPlayer().getBattleOpenGrade() != 0 && this.playerManager.getPlayer().getBattleOpenGrade() <= this.playerManager.getPlayer().getGrade())
         {
            this._mc["org_num"].addChild(FuncKit.getNumEffect(param1 + "c" + int(this.playerManager.getPlayer().getBattle_num() + 1),"Small"));
         }
         else
         {
            this._mc["org_num"].addChild(FuncKit.getNumEffect(param1 + "c" + int(this.playerManager.getPlayer().getBattle_num()),"Small"));
         }
      }
      
      private function setAwardsInfo(param1:String) : void
      {
         this._mc["awardsInfo"].text = LangManager.getInstance().getLanguage("hunting024") + param1;
      }
      
      private function setLastBattleNum() : void
      {
         FuncKit.clearAllChildrens(this._mc["battle_num"]);
         if(this._battleType == LIMIT_BATTLE)
         {
            this._mc["battle_num"].addChild(FuncKit.getNumEffect(ActivtyCopyData.getLimitCopyTotalChallageTimes() + "","Small"));
         }
         else if(this._battleType == CDTIME_BATTLE)
         {
            this._mc["challageTimes_title"].visible = false;
         }
         else if(this._battleType == JEWEL_BATTLE)
         {
            this._mc["battle_num"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getStoneChaCount() + "","Small"));
         }
         else if(this._battleType == GARDEN_BATTLE)
         {
            this._mc["battle_num"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getGardenChaCount() + "","Small"));
         }
         else
         {
            this._mc["battle_num"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getNowHunts() + "","Small"));
         }
      }
      
      private function setLoction() : void
      {
         this._mc.x = 0;
         this._mc.y = 0;
      }
      
      private function setReadyArray(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._readyArray.length)
         {
            if(this._readyArray[_loc2_] != null && this._readyArray[_loc2_].getId() == param1)
            {
               this._readyArray[_loc2_].setMask();
            }
            _loc2_++;
         }
         this.doLayoutReadySprite();
      }
      
      private function showBattlePage(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         this._nowBattleArray = new Array(MAX_BATTLE);
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._battle_table.keys.toArray())
         {
            _loc2_.push(this._battle_table[_loc3_]);
         }
         _loc2_ = this.orderOrgsByGrade(_loc2_);
         if(this._battleType == JEWEL_BATTLE)
         {
            this.opennum = Math.min(StoneCopyData.getCurrentCp().getCaveGrid(),this.playerManager.getPlayer().getBattle_num()) - this.area;
         }
         else
         {
            this.opennum = this.playerManager.getPlayer().getBattle_num() - this.area;
         }
         var _loc4_:int = 0;
         if(this.playerManager.getPlayer().getBattleOpenGrade() != 0 && this.playerManager.getPlayer().getBattleOpenGrade() <= this.playerManager.getPlayer().getGrade())
         {
            _loc4_ = 1;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.opennum)
         {
            _loc8_ = new this.open_grid();
            _loc2_.push(_loc8_);
            _loc5_++;
         }
         if(_loc4_ > 0)
         {
            _loc9_ = new this.can_open_grid();
            _loc9_.buttonMode = true;
            _loc9_.addEventListener(MouseEvent.CLICK,this.onOpenlabelClick);
            _loc2_.push(_loc9_);
         }
         var _loc6_:int = this._max_battlePage * MAX_BATTLE - _loc2_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = new this.lock_grid();
            _loc2_.push(_loc10_);
            _loc7_++;
         }
         this.doLayoutBattleSprite(_loc2_.slice((param1 - 1) * MAX_BATTLE,param1 * MAX_BATTLE));
      }
      
      private function showOrganisms(param1:Array) : void
      {
         var _loc4_:Class = null;
         if(this.map == null)
         {
            _loc4_ = DomainAccess.getClass("map");
            this.map = new _loc4_();
            this.map.x = 130;
            this.map.y = 210;
            this.map["grid"].visible = false;
            this._mc["zombie"]["zombies"].addChild(this.map);
         }
         FuncKit.clearAllChildrens(this.map);
         var _loc2_:BattleMapManager = new BattleMapManager();
         _loc2_.areaAndGrids(param1);
         _loc2_.setGridsLoction(BattleMapManager.RIGHT);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.getGrids().length)
         {
            this.addorg(_loc2_.getGrids()[_loc3_]);
            _loc3_++;
         }
      }
      
      private function showReadyPage(param1:int) : void
      {
         this._nowReadyArray = null;
         this._readyArray = this.orderOrgsByGrade(this.orderOrgByIsGarden(this._readyArray,false)).concat(this.orderOrgsByGrade(this.orderOrgByIsGarden(this._readyArray,true)));
         this._nowReadyArray = this._readyArray.slice((param1 - 1) * MAX_STORAGE,param1 * MAX_STORAGE);
         this.doLayoutReadySprite();
      }
      
      private function showStorageOrganisms() : void
      {
         PlantsVsZombies.storageInfo(this.showStorageOrganismsTrue);
      }
      
      private function showStorageOrganismsTrue() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = this.playerManager.getPlayer().getAllOrganism();
         this.initReadyArray(_loc1_);
         this.showReadyPage(this._readyPage);
         this._mc["text1"].text = this._readyPage + "/" + this._max_readyPage;
      }
      
      private function vipPrizeClickHandle(param1:MouseEvent) : void
      {
         var back:Function = null;
         var event:MouseEvent = param1;
         back = function():void
         {
            if(playerManager.isVip(playerManager.getPlayer().getVipTime()) != null)
            {
               isV = true;
            }
            else
            {
               isV = false;
            }
            if(isV)
            {
               if(playerManager.getPlayer().getVipLevel() == 3)
               {
                  vip3prziebutton.gotoAndStop(1);
                  vip4prziebutton.gotoAndStop(2);
               }
               else if(playerManager.getPlayer().getVipLevel() == 4)
               {
                  vip3prziebutton.gotoAndStop(1);
                  vip4prziebutton.gotoAndStop(1);
               }
            }
         };
         new VipAddPrizePanel(back);
      }
      
      private function vipPrizeOut1Handle(param1:MouseEvent) : void
      {
         if(this.isV)
         {
            if(param1.currentTarget.name == "vip3button")
            {
               if(this.playerManager.getPlayer().getVipLevel() >= 3)
               {
                  param1.currentTarget.gotoAndStop(1);
               }
               else
               {
                  param1.currentTarget.gotoAndStop(2);
               }
            }
            else if(param1.currentTarget.name == "vip4button")
            {
               if(this.playerManager.getPlayer().getVipLevel() == 4)
               {
                  param1.currentTarget.gotoAndStop(1);
               }
               else
               {
                  param1.currentTarget.gotoAndStop(2);
               }
            }
         }
         else
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function vipPrizeOver1Handle(param1:MouseEvent) : void
      {
         if(this.isV)
         {
            if(param1.currentTarget.name == "vip3button")
            {
               if(this.playerManager.getPlayer().getVipLevel() >= 3)
               {
                  param1.currentTarget.gotoAndStop(3);
               }
               else
               {
                  param1.currentTarget.gotoAndStop(4);
               }
            }
            else if(param1.currentTarget.name == "vip4button")
            {
               if(this.playerManager.getPlayer().getVipLevel() == 4)
               {
                  param1.currentTarget.gotoAndStop(3);
               }
               else
               {
                  param1.currentTarget.gotoAndStop(4);
               }
            }
         }
         else
         {
            param1.currentTarget.gotoAndStop(4);
         }
      }
   }
}

