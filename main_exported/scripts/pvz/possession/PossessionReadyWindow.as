package pvz.possession
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import labels.BattleLabel;
   import labels.BattleReadyLabel;
   import manager.InitWidthAndHeightInfo;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.battle.fore.Battlefield;
   import pvz.battle.manager.BattlefieldControlManager;
   import pvz.possession.fport.PossessionReadyWindowFPort;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.sets.Hashtable;
   import zlib.utils.DomainAccess;
   
   public class PossessionReadyWindow extends BaseWindow
   {
      
      private static var MAX_BATTLE:int = 7;
      
      private static var MAX_BATTLE_ALL:int = 2;
      
      private static var MAX_STORAGE:int = 10;
      
      private var _backFun:Function = null;
      
      private var _battleMoney:int = 0;
      
      private var _battlePage:int = 1;
      
      private var _battleSprite:Sprite;
      
      private var _battle_table:Hashtable;
      
      private var _fport:PossessionReadyWindowFPort = null;
      
      private var _isHelp:Boolean = false;
      
      private var _max_battlePage:int = 1;
      
      private var _max_readyPage:int = 0;
      
      private var _mc:MovieClip;
      
      private var _nowBattleArray:Array;
      
      private var _nowReadyArray:Array;
      
      public var _p:Possession = null;
      
      private var _readyArray:Array;
      
      private var _readyPage:int = 1;
      
      private var _readySprite:Sprite;
      
      private var _toolid:int = 0;
      
      private var area:int = 0;
      
      private var lock_grid:Class = null;
      
      private var open_grid:Class = null;
      
      private var opennum:int = 0;
      
      private var pic_label:Class;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PossessionReadyWindow(param1:Function, param2:Possession, param3:Boolean, param4:int, param5:int)
      {
         super();
         var _loc6_:Class = DomainAccess.getClass("_possession_setting_window");
         this._mc = new _loc6_();
         this._readyArray = new Array();
         this._nowReadyArray = new Array();
         this._battle_table = new Hashtable();
         this._nowBattleArray = new Array(MAX_BATTLE);
         this._mc["text2"].text = this._battlePage;
         this._backFun = param1;
         this._p = param2;
         this._isHelp = param3;
         this._toolid = param4;
         this._battleMoney = param5;
         this._fport = new PossessionReadyWindowFPort(this);
         this.addButtonEvent();
         this._mc.visible = false;
         if(this.pic_label == null)
         {
            this.pic_label = DomainAccess.getClass("pic_label");
         }
         this.lock_grid = DomainAccess.getClass("lockLabel");
         this.open_grid = DomainAccess.getClass("openLabel");
         this.showPossessionOrgs();
      }
      
      public function portDoBattle(param1:BattlefieldControlManager, param2:int, param3:int, param4:Array, param5:Array) : void
      {
         this.playerManager.getPlayer().setMoney(this.playerManager.getPlayer().getMoney() - param3);
         var _loc6_:Array = new Array();
         _loc6_.push(this._p,param2);
         new Battlefield(param4,param5,param1,this._backFun,BattlefieldControlManager.POSSESSION,_loc6_);
         this.clear();
         this.hidden();
      }
      
      public function portWithoutBattle(param1:int, param2:int, param3:int) : void
      {
         this.clear();
         this.hidden();
         this.playerManager.getPlayer().setMoney(this.playerManager.getPlayer().getMoney() - param3);
         var _loc4_:int = param2 - this.playerManager.getPlayer().getHonour();
         this.playerManager.getPlayer().setHonour(param2);
         this._backFun(param1,this._p,true,_loc4_);
      }
      
      public function show() : void
      {
         this._mc.visible = true;
         this.showStorageOrganisms();
         this.setBattleMoney();
         this.setLastBattleNum();
         PlantsVsZombies._node.addChild(this._mc);
         onShowEffectBig(this._mc,null);
         this._max_battlePage = int((this.playerManager.getPlayer().getArenaOrgNum() - 1) / MAX_BATTLE) + 1;
         this.showBattlePage(this._battlePage);
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
      
      private function showPossessionOrgs() : void
      {
         var i:int;
         var pnode:PossessionOrgNode = null;
         var getOrgLoc:Function = function(param1:int, param2:int):Point
         {
            return new Point(240 - param1 * 100 - param2 / 2,330);
         };
         if(this._p.getOccupyOrgs() == null || this._p.getOccupyOrgs().length < 1)
         {
            return;
         }
         i = 0;
         while(i < this._p.getOccupyOrgs().length)
         {
            pnode = new PossessionOrgNode(this._p.getOccupyOrgs()[i],0,0,true);
            pnode.setLoction(getOrgLoc(i,pnode._mc.width),new Point());
            this._mc["_mc_orgs"].addChild(pnode);
            i++;
         }
      }
      
      private function battle() : void
      {
         if(this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table)) == null || this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table)).length < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession029"));
            return;
         }
         if(!this._isHelp)
         {
            this._fport.toBattle(this._p.getPossessionId(),this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table)),1,this._toolid);
         }
         else
         {
            this._fport.toBattle(this._p.getPossessionId(),this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table)),0,0);
         }
      }
      
      private function checkAddBattleNum(param1:int) : Boolean
      {
         if(this.area + param1 > MAX_BATTLE_ALL)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession030"));
            return false;
         }
         return true;
      }
      
      private function clear() : void
      {
         this.area = 0;
         this._readyPage = 1;
         this._mc["text1"].text = "";
         this._readyArray = new Array();
         this._nowReadyArray = new Array();
         this._battle_table = new Hashtable();
         this._nowBattleArray = new Array(MAX_BATTLE);
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
         FuncKit.clearAllChildrens(this._mc["battle_money"]);
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
      
      private function hidden() : void
      {
         this._mc.visible = false;
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
            this._readyArray[_loc2_] = new BattleReadyLabel(BattleReadyLabel.POSSESSION);
            (this._readyArray[_loc2_] as BattleReadyLabel).update(param1[_loc2_],this.addBattleArray,this.checkAddBattleNum,this.removerBattleArray);
            _loc2_++;
         }
         this._max_readyPage = int((param1.length - 1) / MAX_STORAGE) + 1;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.battle();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.clear();
            this.hidden();
            this._backFun();
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
         this.showBattlePage(this._battlePage);
         this.setReadyArray(param1.getId(),false);
      }
      
      private function resetArenaOrgs(param1:Array) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(this.playerManager.getOrganism(this.playerManager.getPlayer(),param1[_loc3_]));
            _loc3_++;
         }
         this.playerManager.getPlayer().setArenaOrgs(_loc2_);
      }
      
      private function setBattleMoney() : void
      {
         FuncKit.clearAllChildrens(this._mc["battle_money"]);
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this._battleMoney + "","Red");
         _loc1_.x = -_loc1_.width / 2;
         this._mc["battle_money"].addChild(_loc1_);
      }
      
      private function setLastBattleNum() : void
      {
         FuncKit.clearAllChildrens(this._mc["battle_num"]);
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.playerManager.getPlayer().getOccupyNum() + "","Red");
         _loc1_.x = -_loc1_.width / 2;
         this._mc["battle_num"].addChild(_loc1_);
      }
      
      private function setReadyArray(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._readyArray.length)
         {
            if(this._readyArray[_loc3_] != null && this._readyArray[_loc3_].getId() == param1)
            {
               this._readyArray[_loc3_].setMask(param2);
            }
            _loc3_++;
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
         this.opennum = MAX_BATTLE_ALL - this.area;
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
         this._readyArray = this.orderOrgsByGrade(this._readyArray);
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

