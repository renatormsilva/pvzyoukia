package pvz.serverbattle
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.BattleLabel;
   import labels.BattleReadyLabel;
   import manager.InitWidthAndHeightInfo;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.serverbattle.fport.SignUpFPort;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.sets.Hashtable;
   import zlib.utils.DomainAccess;
   
   public class SeverBattleReadyWindow extends BaseWindow
   {
      
      private static const SETTING:int = 1;
      
      private static var MAX_BATTLE:int = 7;
      
      private static var MAX_BATTLE_ALL:int = 12;
      
      private static var MAX_STORAGE:int = 10;
      
      private var _closeFun:Function = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _battlePage:int = 1;
      
      internal var _battleSprite:Sprite;
      
      internal var _battle_table:Hashtable;
      
      internal var _max_battlePage:int = 1;
      
      internal var _max_readyPage:int = 0;
      
      internal var _mc:MovieClip;
      
      internal var _nowBattleArray:Array;
      
      internal var _nowReadyArray:Array;
      
      internal var _readyArray:Array;
      
      internal var _readyPage:int = 1;
      
      internal var _readySprite:Sprite;
      
      internal var area:int = 0;
      
      internal var opennum:int = 0;
      
      internal var pic_label:Class;
      
      private var lock_grid:Class = null;
      
      private var open_grid:Class = null;
      
      private var _fport:SignUpFPort = new SignUpFPort(this);
      
      public function SeverBattleReadyWindow(param1:Function = null)
      {
         this._closeFun = param1;
         super(UINameConst.UI_SERVER_PLANTS_SETTING);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.serverbattle.SeverBattleReadyWindow");
         this._mc = new _loc1_();
         this._readyArray = new Array();
         this._nowReadyArray = new Array();
         this._battle_table = new Hashtable();
         this._nowBattleArray = new Array(MAX_BATTLE);
         this._mc["text2"].text = this._battlePage;
         this.addButtonEvent();
         this._mc.visible = false;
         if(this.pic_label == null)
         {
            this.pic_label = DomainAccess.getClass("pic_label");
         }
         this.lock_grid = DomainAccess.getClass("lockLabel");
         this.open_grid = DomainAccess.getClass("openLabel");
         this.show();
      }
      
      public function setOrgsSucess(param1:Object) : void
      {
         if(PlantsVsZombies.playerManager.getPlayer().getSeverBattleOrgs() == null || PlantsVsZombies.playerManager.getPlayer().getSeverBattleOrgs().length < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle010"));
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle020"));
         }
         var _loc2_:Array = new Array();
         _loc2_ = this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table));
         this.resetSeverBattleOrgs(_loc2_);
         this.clear();
         this.hidden();
         PlantsVsZombies.showDataLoading(false);
         if(PlantsVsZombies.playerManager.getPlayer().getSeverBattleStaus() == 2)
         {
            PlantsVsZombies.playerManager.getPlayer().setSeverBattleStaus(3);
         }
      }
      
      private function show() : void
      {
         this.showStorageOrganisms();
         this.setArea(this.area);
         this._max_battlePage = int((this.playerManager.getPlayer().getBattle_num() - 1) / MAX_BATTLE) + 1;
         this.showBattlePage(this._battlePage);
         this._mc.visible = true;
         PlantsVsZombies._node.addChild(this._mc);
         onShowEffectBig(this._mc,null);
      }
      
      private function setSettingOrgs() : void
      {
         var _loc1_:Array = this.playerManager.getPlayer().getSeverBattleOrgs();
         if(_loc1_ == null || _loc1_.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.addBattleArray(_loc1_[_loc2_]);
            this.setReadyArray((_loc1_[_loc2_] as Organism).getId(),true);
            _loc2_++;
         }
      }
      
      private function addBattleArray(param1:Organism) : void
      {
         if(param1 == null)
         {
            return;
         }
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
      
      private function settingOrg() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table));
         if(_loc1_ == null || _loc1_.length < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle011"));
            return;
         }
         PlantsVsZombies.showDataLoading(true);
         this._fport.requestSever(SignUpFPort.SETTING,_loc1_);
      }
      
      private function resetSeverBattleOrgs(param1:Array) : void
      {
         var _loc4_:Organism = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(this.playerManager.getOrganism(this.playerManager.getPlayer(),param1[_loc3_]));
            _loc3_++;
         }
         this.playerManager.getPlayer().setSeverBattleOrgs(_loc2_);
         for each(_loc4_ in _loc2_)
         {
            (_loc4_ as Organism).setIsSeverBattle(true);
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
      }
      
      private function checkAddBattleNum(param1:int) : Boolean
      {
         if(this.area + param1 > this.playerManager.getPlayer().getArenaOrgNum())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("arena003"));
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
         this._fport = null;
      }
      
      private function clearAllText() : void
      {
         FuncKit.clearAllChildrens(this._mc["org_num"]);
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
         onHiddenEffectBig(this._mc,this._closeFun);
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
            this._readyArray[_loc2_] = new BattleReadyLabel(BattleReadyLabel.SEVER_BATTLE);
            (this._readyArray[_loc2_] as BattleReadyLabel).update(param1[_loc2_],this.addBattleArray,this.checkAddBattleNum,this.removerBattleArray);
            _loc2_++;
         }
         this._max_readyPage = int((param1.length - 1) / MAX_STORAGE) + 1;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.settingOrg();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            _loc2_ = new Array();
            _loc2_ = this.getMyOrgsArray(this.getArrayFromBattletable(this._battle_table));
            if(this.playerManager.getPlayer().getSeverBattleOrgs() == null || this.playerManager.getPlayer().getSeverBattleOrgs().length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle011"));
               return;
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
         this.setReadyArray(param1.getId(),false);
      }
      
      private function setArea(param1:int) : void
      {
         FuncKit.clearAllChildrens(this._mc["org_num"]);
         this._mc["org_num"].addChild(FuncKit.getNumEffect(param1 + "c" + int(this.playerManager.getPlayer().getArenaOrgNum()),"Small"));
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
         this.opennum = this.playerManager.getPlayer().getBattle_num() - this.area;
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
         this.setSettingOrgs();
      }
   }
}

