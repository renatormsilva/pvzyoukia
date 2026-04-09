package pvz.arena.window
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.res.IDestroy;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
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
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.sets.Hashtable;
   import zlib.utils.DomainAccess;
   
   public class SettingWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      private static var MAX_BATTLE:int = 7;
      
      private static var MAX_BATTLE_ALL:int = 12;
      
      private static var MAX_STORAGE:int = 10;
      
      private static const SETTING:int = 1;
      
      internal var _allorgs:Array = null;
      
      internal var _battlePage:int = 1;
      
      internal var _battleSprite:Sprite;
      
      internal var _battle_labels:Array = null;
      
      internal var _battle_orgs:Array = null;
      
      internal var _max_battlePage:int = 1;
      
      internal var _max_readyPage:int = 0;
      
      internal var _mc:MovieClip;
      
      internal var _page_labels:Array = null;
      
      internal var _readyPage:int = 1;
      
      internal var _readySprite:Sprite;
      
      internal var area:int = 0;
      
      internal var opennum:int = 0;
      
      internal var pic_label:Class;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _backFun:Function = null;
      
      private var _closeFun:Function = null;
      
      private var lock_grid:Class = null;
      
      private var open_grid:Class = null;
      
      public function SettingWindow(param1:Function, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("arena_setting_window");
         this._mc = new _loc3_();
         this._allorgs = new Array();
         this._page_labels = new Array();
         this._battle_orgs = new Array();
         this._mc["text2"].text = this._battlePage;
         this._backFun = param1;
         this._closeFun = param2;
         this.addButtonEvent();
         this._mc.visible = false;
         if(this.pic_label == null)
         {
            this.pic_label = DomainAccess.getClass("pic_label");
         }
         this.lock_grid = DomainAccess.getClass("lockLabel");
         this.open_grid = DomainAccess.getClass("openLabel");
      }
      
      override public function destroy() : void
      {
         this.removeButtonEvent();
         PlantsVsZombies._node.removeChild(this._mc);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == SETTING)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         if(param1 == SETTING)
         {
            _loc3_ = new Array();
            _loc3_ = this.getMyOrgsArray(this._battle_orgs);
            this.resetArenaOrgs(_loc3_);
            this.playerManager.getPlayer().setArenaRank(int(param2));
            if(this._backFun != null)
            {
               this._backFun();
            }
            this._closeFun();
            this.clear();
            this.hidden();
            PlantsVsZombies.showDataLoading(false);
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
      
      public function show() : void
      {
         this._mc.visible = true;
         this.showStorageOrganisms();
         this.setArea(this.area);
         this.setLastBattleNum();
         PlantsVsZombies._node.addChild(this._mc);
         onShowEffectBig(this._mc,null);
         this._max_battlePage = int((this.playerManager.getPlayer().getArenaOrgNum() - 1) / MAX_BATTLE) + 1;
         this.showBattlePage(this._battlePage);
      }
      
      private function addBattleArray(param1:Organism) : void
      {
         this.addBattleOrg(param1);
         this._battlePage = int((this._battle_orgs.length - 1) / MAX_BATTLE) + 1;
         this.area += param1.getWidth() * param1.getHeight();
         this.setArea(this.area);
         this._mc["text2"].text = this._battlePage;
         this.showBattlePage(this._battlePage);
      }
      
      private function addBattleOrg(param1:Organism) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._battle_orgs.length)
         {
            if((this._battle_orgs[_loc2_] as Organism).getId() == param1.getId())
            {
               return;
            }
            _loc2_++;
         }
         this._battle_orgs.push(param1);
      }
      
      private function addBattleOrgsArray(param1:Array) : void
      {
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.addBattleOrg(param1[_loc2_]);
            this._battlePage = int((this._battle_orgs.length - 1) / MAX_BATTLE) + 1;
            _loc2_++;
         }
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
         this.clearArray();
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
         this.clearPageOrgs();
         this.clearBattleLabels();
         this._allorgs = null;
         this._page_labels = null;
      }
      
      private function clearBattleLabels() : void
      {
         if(this._battle_labels == null || this._battle_labels.length < 1)
         {
            return;
         }
         var _loc1_:* = int(this._battle_labels.length - 1);
         while(_loc1_ > -1)
         {
            if(this._battle_labels[_loc1_] is BattleLabel)
            {
               (this._battle_labels[_loc1_] as BattleLabel).destroy();
            }
            this._battle_labels.splice(_loc1_,_loc1_);
            _loc1_--;
         }
         this._battle_labels = null;
      }
      
      private function clearPageOrgs() : void
      {
         if(this._page_labels == null || this._page_labels.length < 1)
         {
            return;
         }
         var _loc1_:* = int(this._page_labels.length - 1);
         while(_loc1_ > -1)
         {
            (this._page_labels[_loc1_] as BattleReadyLabel).destroy();
            this._page_labels.splice(_loc1_,1);
            _loc1_--;
         }
         this._page_labels = null;
      }
      
      private function doLayoutBattleSprite(param1:Array) : void
      {
         if(this._battleSprite != null)
         {
            this._mc["battle_plats"].removeChild(this._battleSprite);
         }
         this._battleSprite = new Sprite();
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
         var _loc2_:* = int(this._page_labels.length - 1);
         while(_loc2_ >= 0)
         {
            this._page_labels[_loc2_].y = int(_loc2_ / 5) * InitWidthAndHeightInfo.ORG_LABEL_HEIGHT;
            this._page_labels[_loc2_].x = _loc2_ % 5 * InitWidthAndHeightInfo.ORG_LABEL_WIDTH;
            this._readySprite.addChild(this._page_labels[_loc2_]);
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
         onHiddenEffectBig(this._mc,this.destroy);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.settingOrg();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(this.playerManager.getPlayer().getArenaOrgs() == null || this.playerManager.getPlayer().getArenaOrgs().length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("arena002"));
               return;
            }
            this.clear();
            this.hidden();
            this._closeFun();
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
            while(_loc4_ > 0 && param1[_loc4_ - 1].getGrade() < _loc3_.getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function removeBattleArray(param1:Organism) : void
      {
         this.removeBattleOrg(param1);
         this._battlePage = int((this._battle_orgs.length - 1) / MAX_BATTLE) + 1;
         this._mc["text2"].text = this._battlePage;
         this.area -= param1.getWidth() * param1.getHeight();
         this.setArea(this.area);
         this.showBattlePage(this._battlePage);
         this.setReadyArray(param1.getId(),false);
      }
      
      private function removeBattleOrg(param1:Organism) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._battle_orgs.length)
         {
            if((this._battle_orgs[_loc2_] as Organism).getId() == param1.getId())
            {
               this._battle_orgs.splice(_loc2_,1);
            }
            _loc2_++;
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
      
      private function setArea(param1:int) : void
      {
         FuncKit.clearAllChildrens(this._mc["org_num"]);
         this._mc["org_num"].addChild(FuncKit.getNumEffect(param1 + "c" + int(this.playerManager.getPlayer().getArenaOrgNum()),"Small"));
      }
      
      private function setLabelsMask() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._battle_orgs.length)
         {
            this.setReadyArray((this._battle_orgs[_loc1_] as Organism).getId(),true);
            _loc1_++;
         }
      }
      
      private function setLastBattleNum() : void
      {
         FuncKit.clearAllChildrens(this._mc["battle_num"]);
         this._mc["battle_num"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getArenaNum() + "","Small"));
      }
      
      private function setReadyArray(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._page_labels.length)
         {
            if(this._page_labels[_loc3_] != null && this._page_labels[_loc3_].getId() == param1)
            {
               this._page_labels[_loc3_].setMask(param2);
            }
            _loc3_++;
         }
         this.doLayoutReadySprite();
      }
      
      private function setSettingOrgs() : void
      {
         var _loc1_:Array = this.playerManager.getPlayer().getArenaOrgs();
         if(_loc1_ == null || _loc1_.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.addBattleArray(_loc1_[_loc2_]);
            _loc2_++;
         }
         this.addBattleOrgsArray(_loc1_);
      }
      
      private function settingOrg() : void
      {
         if(this._battle_orgs == null || this._battle_orgs.length < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("arena002"));
            return;
         }
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_SETTING,SETTING,this.getMyOrgsArray(this._battle_orgs));
      }
      
      private function showBattlePage(param1:int) : void
      {
         var _loc6_:BattleLabel = null;
         var _loc7_:Organism = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         this.clearBattleLabels();
         this._battle_labels = new Array();
         this._battle_orgs = this.orderOrgsByGrade(this._battle_orgs);
         var _loc2_:int = 0;
         while(_loc2_ < this._battle_orgs.length)
         {
            _loc6_ = new BattleLabel(new this.pic_label());
            _loc7_ = this.playerManager.getPlayer().getOrganismById((this._battle_orgs[_loc2_] as Organism).getId());
            _loc6_.update(_loc7_,this.removeBattleArray);
            this._battle_labels.push(_loc6_);
            _loc2_++;
         }
         this.opennum = this.playerManager.getPlayer().getArenaOrgNum() - this.area;
         var _loc3_:int = 0;
         while(_loc3_ < this.opennum)
         {
            _loc8_ = new this.open_grid();
            this._battle_labels.push(_loc8_);
            _loc3_++;
         }
         var _loc4_:int = this._max_battlePage * MAX_BATTLE - this._battle_labels.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc9_ = new this.lock_grid();
            this._battle_labels.push(_loc9_);
            _loc5_++;
         }
         this.doLayoutBattleSprite(this._battle_labels.slice((param1 - 1) * MAX_BATTLE,param1 * MAX_BATTLE));
      }
      
      private function showReadyPage(param1:int) : void
      {
         var _loc4_:BattleReadyLabel = null;
         this.clearPageOrgs();
         this._page_labels = new Array();
         var _loc2_:Array = this._allorgs.slice((param1 - 1) * MAX_STORAGE,param1 * MAX_STORAGE);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new BattleReadyLabel(BattleReadyLabel.ARENA);
            _loc4_.update(_loc2_[_loc3_],this.addBattleArray,this.checkAddBattleNum,this.removeBattleArray);
            this._page_labels.push(_loc4_);
            _loc3_++;
         }
         this.setLabelsMask();
         this.doLayoutReadySprite();
      }
      
      private function showStorageOrganisms() : void
      {
         PlantsVsZombies.storageInfo(this.showStorageOrganismsTrue);
      }
      
      private function showStorageOrganismsTrue() : void
      {
         this._allorgs = this.playerManager.getPlayer().getAllOrganism();
         this._allorgs = this.orderOrgsByGrade(this._allorgs);
         if(this._allorgs == null || this._allorgs.length < 1)
         {
            return;
         }
         this._max_readyPage = int((this._allorgs.length - 1) / MAX_STORAGE) + 1;
         this._mc["text1"].text = this._readyPage + "/" + this._max_readyPage;
         this.setSettingOrgs();
         this.showReadyPage(this._readyPage);
      }
   }
}

