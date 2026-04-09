package pvz.world
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.BattleLabel;
   import labels.BattleReadyLabel;
   import manager.InitWidthAndHeightInfo;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.battle.fore.Battlefield;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.vip.AutoRevertWindow;
   import pvz.world.fport.CheckpointReadyWindowFPort;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import zlib.sets.Hashtable;
   import zlib.utils.DomainAccess;
   
   public class CheckpointReadyWindow extends BaseWindow
   {
      
      private static const BATTLE:int = 1;
      
      private static var MAX_BATTLE:int = 7;
      
      private static var MAX_BATTLE_ALL:int = 12;
      
      private static var MAX_STORAGE:int = 10;
      
      private static const OPENGRID:int = 2;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _battlePage:int = 1;
      
      internal var _battleSprite:Sprite;
      
      internal var _battle_table:Hashtable;
      
      internal var _battleorgs:Array = null;
      
      internal var _max_battlePage:int = 1;
      
      internal var _max_readyPage:int = 0;
      
      internal var _mc:MovieClip;
      
      internal var _nowBattleArray:Array;
      
      internal var _nowReadyArray:Array;
      
      internal var _readyArray:Array;
      
      internal var _readyPage:int = 1;
      
      internal var _readySprite:Sprite;
      
      internal var area:int = 0;
      
      internal var isChoose:Boolean = false;
      
      internal var opennum:int = 0;
      
      internal var pic_label:Class;
      
      private var _checkpoint:Checkpoint = null;
      
      private var _hiddenFun:Function;
      
      private var lock_grid:Class = null;
      
      private var open_grid:Class = null;
      
      private var _fport:CheckpointReadyWindowFPort = null;
      
      private var vipRevertBoldIcon:MovieClip;
      
      private var isV:Boolean = false;
      
      public function CheckpointReadyWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("ui.world.checkpointReadyWindow");
         this._mc = new _loc1_();
         this._readyArray = new Array();
         this._nowReadyArray = new Array();
         this._battle_table = new Hashtable();
         this._nowBattleArray = new Array(MAX_BATTLE);
         this._mc["text2"].text = this._battlePage;
         this.addButtonEvent();
         this.initVipAutoRevert();
         this._mc.visible = false;
         if(this.pic_label == null)
         {
            this.pic_label = DomainAccess.getClass("pic_label");
         }
         this.lock_grid = DomainAccess.getClass("lockLabel");
         this.open_grid = DomainAccess.getClass("openLabel");
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
      
      public function show(param1:Function, param2:Checkpoint) : void
      {
         this._fport = new CheckpointReadyWindowFPort(this);
         this._hiddenFun = param1;
         this._checkpoint = param2;
         this._mc.visible = true;
         this.showStorageOrganisms();
         this.setArea(this.area);
         this.setLastBattleNum();
         this.setCost();
         this.setComp();
         PlantsVsZombies._node.addChild(this._mc);
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         onShowEffectBig(this._mc,removeBG);
         this._max_battlePage = int((this._checkpoint.getMaxOrgNum() - 1) / MAX_BATTLE) + 1;
         this.showBattlePage(this._battlePage);
         this.showPreWorldsOrgs();
      }
      
      private function showPreWorldsOrgs() : void
      {
         var _loc3_:Organism = null;
         var _loc4_:int = 0;
         var _loc5_:Organism = null;
         var _loc6_:int = 0;
         var _loc7_:Organism = null;
         var _loc1_:Array = this.playerManager.getPlayer().getPreWorldOrgs();
         var _loc2_:Array = [];
         if(this._checkpoint.getMaxOrgNum() < _loc1_.length)
         {
            this.playerManager.getPlayer().setPreWorldOrgs(_loc2_);
            return;
         }
         for each(_loc3_ in _loc1_)
         {
            _loc6_ = 0;
            while(_loc6_ < this.playerManager.getPlayer().getAllOrganism().length)
            {
               if(this.playerManager.getPlayer().getAllOrganism()[_loc6_].getId() == _loc3_.getId())
               {
                  if(this.playerManager.getPlayer().getAllOrganism()[_loc6_].getHp() > 0)
                  {
                     if(this.playerManager.getPlayer().getAllOrganism()[_loc6_].getGardenId() == 0)
                     {
                        _loc2_.push(this.playerManager.getPlayer().getAllOrganism()[_loc6_]);
                     }
                  }
               }
               _loc6_++;
            }
         }
         this.playerManager.getPlayer().setPreWorldOrgs(_loc2_);
         _loc4_ = 0;
         for each(_loc5_ in _loc2_)
         {
            _loc4_ += _loc5_.getWidth() * _loc5_.getHeight();
         }
         if(this._checkpoint.getMaxOrgNum() - _loc4_ < 0)
         {
            _loc2_.length = 0;
            this.playerManager.getPlayer().setPreWorldOrgs(null);
         }
         else
         {
            for each(_loc7_ in _loc2_)
            {
               this._battle_table.keys.toArray().push(_loc7_);
               this.addBattleArray(_loc7_);
            }
         }
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
      }
      
      private function addButtonEvent() : void
      {
         this._mc["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec2"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._mc["ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_add2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["bt_dec2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.vipRevertBoldIcon.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.vipRevertBoldIcon.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.vipRevertBoldIcon.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function battleReady(param1:Array) : void
      {
         var _loc2_:String = null;
         PlantsVsZombies.showDataLoading(true);
         this._battleorgs = param1;
         this.playerManager.getPlayer().setPreWorldOrgs(null);
         for each(_loc2_ in this._battle_table.keys.toArray())
         {
            this.playerManager.getPlayer().getPreWorldOrgs().push((this._battle_table[_loc2_] as BattleLabel).getOrg());
         }
         this._fport.battle(this._checkpoint.getId(),this.getMyOrgsArray(param1));
      }
      
      public function portBattle(param1:BattlefieldControlManager, param2:Array) : void
      {
         PlantsVsZombies.changeMoneyOrExp(-this._checkpoint.getCost(),PlantsVsZombies.MONEY);
         this.playerManager.getPlayer().setWorldTimes(this.playerManager.getPlayer().getWorldTimes() - 1);
         if(this._checkpoint.getBattleTimes() > 0)
         {
            this._checkpoint.setBattleTimes(this._checkpoint.getBattleTimes() - 1);
         }
         new Battlefield(this._battleorgs,param2,param1,this._hiddenFun,BattlefieldControlManager.WORLD);
      }
      
      private function checkAddBattleNum(param1:int) : Boolean
      {
         if(this.area + param1 > this._checkpoint.getMaxOrgNum())
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
         if(this.getArrayFromBattletable(this._battle_table).length < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("hunting023"));
            return false;
         }
         return true;
      }
      
      private function clear() : void
      {
         this.area = 0;
         this._readyPage = 1;
         this._mc["text1"].text = "";
         this.removeEvent();
         this._readyArray = null;
         this._nowReadyArray = null;
         this._battle_table = null;
         this._nowBattleArray = null;
         this._battleSprite = null;
         this.vipRevertBoldIcon = null;
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
      
      private function doLayoutBattleSprite(param1:Array) : void
      {
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
      
      private function hidden() : void
      {
         onHiddenEffectBig(this._mc);
      }
      
      private function initReadyArray(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._readyArray[_loc2_] = new BattleReadyLabel(BattleReadyLabel.WORLD);
            (this._readyArray[_loc2_] as BattleReadyLabel).update(param1[_loc2_],this.addBattleArray,this.checkAddBattleNum,this.removerBattleArray);
            _loc2_++;
         }
         this._max_readyPage = int((param1.length - 1) / MAX_STORAGE) + 1;
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
            this.battleReady(this.getArrayFromBattletable(this._battle_table));
            this.hidden();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
            if(this._hiddenFun != null)
            {
               this._hiddenFun();
            }
            this.hidden();
            this.clear();
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
         this._mc["org_num"].addChild(FuncKit.getNumEffect(param1 + "c" + this._checkpoint.getMaxOrgNum(),"Small"));
      }
      
      private function setCost() : void
      {
         FuncKit.clearAllChildrens(this._mc["cost_num"]);
         this._mc["cost_num"].addChild(FuncKit.getNumEffect(this._checkpoint.getCost() + ""));
      }
      
      private function setComp() : void
      {
         FuncKit.clearAllChildrens(this._mc["_mc_comp"]["comp_num"]);
         if(this._checkpoint.getIsPass())
         {
            this._mc["_mc_comp"].visible = false;
            return;
         }
         this._mc["_mc_comp"].visible = true;
         this._mc["_mc_comp"]["comp_num"].addChild(FuncKit.getNumEffect(this._checkpoint.getPoint() + ""));
      }
      
      private function setLastBattleNum() : void
      {
         FuncKit.clearAllChildrens(this._mc["battle_num"]);
         this._mc["battle_num"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getWorldTimes() + "","Small"));
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
         var _loc4_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         this._nowBattleArray = new Array(MAX_BATTLE);
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._battle_table.keys.toArray())
         {
            _loc2_.push(this._battle_table[_loc3_]);
         }
         _loc2_ = this.orderOrgsByGrade(_loc2_);
         this.opennum = this._checkpoint.getMaxOrgNum() - this.area;
         _loc4_ = 0;
         while(_loc4_ < this.opennum)
         {
            _loc7_ = new this.open_grid();
            _loc2_.push(_loc7_);
            _loc4_++;
         }
         var _loc5_:int = this._max_battlePage * MAX_BATTLE - _loc2_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = new this.lock_grid();
            _loc2_.push(_loc8_);
            _loc6_++;
         }
         this.doLayoutBattleSprite(_loc2_.slice((param1 - 1) * MAX_BATTLE,param1 * MAX_BATTLE));
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
   }
}

