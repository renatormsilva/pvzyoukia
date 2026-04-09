package entity
{
   public class Player
   {
      
      public var organisms:Array;
      
      public var tools:Array;
      
      private var _holeDifficulty:int = 0;
      
      private var _honour:int = 0;
      
      private var _occupyMaxNum:int = 0;
      
      private var _occupyNum:int = 0;
      
      private var _preAreanaOrgs:Array;
      
      private var _preWorldOrgs:Array;
      
      private var _preLimitCopyOrgs:Array;
      
      private var _preCdTimeCopyOrgs:Array;
      
      private var _preJewelCopyOrgs:Array;
      
      private var _vipTime:int = 0;
      
      private var arenaDate:String = "";
      
      private var arenaLastRank:int = -1;
      
      private var arenaNum:int = 0;
      
      private var arenaOrgNum:int = 0;
      
      private var arenaOrgs:Array = null;
      
      private var arenaRank:int = -1;
      
      private var bannerUrl:String = "";
      
      private var banner_num:int = 0;
      
      private var battle_num:int;
      
      private var battle_open_grade:int = 0;
      
      private var battle_open_money:int = 0;
      
      private var changetools:Array = null;
      
      private var charm:int = 0;
      
      private var everyDayPrize:int = 0;
      
      private var exp:int = 0;
      
      private var expFull:Boolean = true;
      
      private var exp_max:int = 0;
      
      private var exp_min:int = 0;
      
      private var faceUrl1:String = "";
      
      private var faceUrl2:String = "";
      
      private var firstLogin:Boolean = false;
      
      private var flowerpotNum:int = 0;
      
      private var friendLands:int = 0;
      
      private var friends:Array;
      
      private var friends_maxpage:int = 0;
      
      private var friends_nowpage:int = 0;
      
      private var friends_num:int = 0;
      
      private var friends_pagenum:int = 0;
      
      private var grade:int = 0;
      
      private var hunts:int;
      
      private var id:Number = 0;
      
      private var invite_amount:int = 0;
      
      private var isActivity:Boolean = true;
      
      private var isGardenOrg:int = 0;
      
      private var isNew:Boolean = false;
      
      private var key:String = "";
      
      private var lastArenaDate:String = "";
      
      private var lastHoleId:int = 0;
      
      private var last_occupy:int = 0;
      
      private var max_use_invite_num:int = 0;
      
      private var money:Number = 0;
      
      private var nickname:String = "";
      
      private var nowflowerpotNum:int = 0;
      
      private var nowhunts:int;
      
      private var occupy:int = 0;
      
      private var rmb:int = 0;
      
      private var storage_org_grade:int = 0;
      
      private var storage_org_money:int = 0;
      
      private var storage_org_num:int = 0;
      
      private var storage_tool_grade:int = 0;
      
      private var storage_tool_money:int = 0;
      
      private var storage_tool_num:int = 0;
      
      private var today_exp:int = 0;
      
      private var today_max_exp:int;
      
      private var tree_height:int = 0;
      
      private var tree_times:int = 0;
      
      private var use_invite_num:int = 0;
      
      private var wins:int = 0;
      
      private var _activeAreward:int;
      
      private var _activeBreward:int;
      
      private var _consumeReward:int;
      
      private var _day:int;
      
      private var _reward:int;
      
      private var _serverBattleStaus:int = 0;
      
      private var _severBattleOrgs:Array = [];
      
      private var _severBattleOrgsNum:int = 0;
      
      private var _vipAutoGain:int;
      
      private var _vipAutoRevert:int;
      
      private var _vipExp:int;
      
      private var _vipLevel:int;
      
      private var stone_cha_count:int;
      
      private var shake_can_defy:int;
      
      private var _isRegistration:Boolean;
      
      private var _garden_cha_count:int;
      
      private var _IsNewTaskSystem:Boolean;
      
      private var copy_active:int;
      
      private var isfirstRecharge:int = 0;
      
      private var worldBuyNum:int = 0;
      
      private var worldTimes:int = 0;
      
      private var _activtyBtnStaus:int = 0;
      
      public function Player()
      {
         super();
      }
      
      public function getStoneChaCount() : int
      {
         return this.stone_cha_count;
      }
      
      public function setStoneChaCount(param1:int) : void
      {
         this.stone_cha_count = param1;
      }
      
      public function getGardenChaCount() : int
      {
         return this._garden_cha_count;
      }
      
      public function setGardenChaCount(param1:int) : void
      {
         this._garden_cha_count = param1;
      }
      
      public function getShakeDefy() : int
      {
         return this.shake_can_defy;
      }
      
      public function setShakeDefy(param1:int) : void
      {
         this.shake_can_defy = param1;
      }
      
      public function getCopyActiveState() : int
      {
         return this.copy_active;
      }
      
      public function setCopyActiveState(param1:int) : void
      {
         this.copy_active = param1;
      }
      
      public function addFriend(param1:Player) : void
      {
         if(this.friends == null)
         {
            this.friends = new Array();
         }
         this.friends.push(param1);
      }
      
      public function getAllOrganism() : Array
      {
         return this.organisms;
      }
      
      public function getAllTools() : Array
      {
         if(this.tools == null)
         {
            return null;
         }
         return this.tools;
      }
      
      public function getArenaDate() : String
      {
         return this.arenaDate;
      }
      
      public function getArenaLastRank() : int
      {
         return this.arenaLastRank;
      }
      
      public function getArenaNum() : int
      {
         return this.arenaNum;
      }
      
      public function getArenaOrgNum() : int
      {
         return this.arenaOrgNum;
      }
      
      public function getArenaOrgs() : Array
      {
         return this.arenaOrgs;
      }
      
      public function getArenaRank() : int
      {
         return this.arenaRank;
      }
      
      public function getBannerNum() : int
      {
         return this.banner_num;
      }
      
      public function getBannerUrl() : String
      {
         return this.bannerUrl;
      }
      
      public function getBattleOpenGrade() : int
      {
         return this.battle_open_grade;
      }
      
      public function getBattleOpenMoney() : int
      {
         return this.battle_open_money;
      }
      
      public function getBattle_num() : int
      {
         return this.battle_num;
      }
      
      public function getChangetools() : Array
      {
         return this.changetools;
      }
      
      public function getCharm() : int
      {
         return this.charm;
      }
      
      public function getEveryDayPrize() : int
      {
         return this.everyDayPrize;
      }
      
      public function getExp() : int
      {
         return this.exp;
      }
      
      public function getExpFull() : Boolean
      {
         return this.expFull;
      }
      
      public function getExp_max() : int
      {
         return this.exp_max;
      }
      
      public function getExp_min() : int
      {
         return this.exp_min;
      }
      
      public function getFaceUrl1() : String
      {
         return this.faceUrl1;
      }
      
      public function getFaceUrl2() : String
      {
         return this.faceUrl2;
      }
      
      public function getFirstLogin() : Boolean
      {
         return this.firstLogin;
      }
      
      public function getFirstRecharge() : int
      {
         return this.isfirstRecharge;
      }
      
      public function getActivtyBtnStaus() : int
      {
         return this._activtyBtnStaus;
      }
      
      public function setActivtyBtnStaus(param1:int) : void
      {
         this._activtyBtnStaus = param1;
      }
      
      public function getFlowerpotNum() : int
      {
         return this.flowerpotNum;
      }
      
      public function getFriendLands() : int
      {
         return this.friendLands;
      }
      
      public function getFriends() : Array
      {
         return this.friends;
      }
      
      public function getFriendsMaxpage() : int
      {
         return this.friends_maxpage;
      }
      
      public function getFriendsNowpage() : int
      {
         return this.friends_nowpage;
      }
      
      public function getFriendsNum() : int
      {
         return this.friends_num;
      }
      
      public function getFriendsPagenum() : int
      {
         return this.friends_pagenum;
      }
      
      public function getGrade() : int
      {
         return this.grade;
      }
      
      public function getHasActiveAreward() : int
      {
         return this._activeAreward;
      }
      
      public function getHasActiveBreward() : int
      {
         return this._activeBreward;
      }
      
      public function getHasConsumeBreward() : int
      {
         return this._consumeReward;
      }
      
      public function getHasReward() : int
      {
         return this._reward;
      }
      
      public function getHoleDifficulty() : int
      {
         return this._holeDifficulty;
      }
      
      public function getHonour() : int
      {
         return this._honour;
      }
      
      public function getHunts() : int
      {
         return this.hunts;
      }
      
      public function getId() : Number
      {
         return this.id;
      }
      
      public function getInviteAmount() : int
      {
         return this.invite_amount;
      }
      
      public function getIsActivity() : Boolean
      {
         return this.isActivity;
      }
      
      public function getIsGardenOrg() : int
      {
         return this.isGardenOrg;
      }
      
      public function getIsNew() : Boolean
      {
         return this.isNew;
      }
      
      public function getKey() : String
      {
         return this.key;
      }
      
      public function getLastArenaDate() : String
      {
         return this.lastArenaDate;
      }
      
      public function getLastHoleId() : int
      {
         return this.lastHoleId;
      }
      
      public function getLastOccupy() : int
      {
         return this.last_occupy;
      }
      
      public function getMaxUseInviteNum() : int
      {
         return this.max_use_invite_num;
      }
      
      public function getMoney() : Number
      {
         return this.money;
      }
      
      public function getNickname() : String
      {
         return this.nickname;
      }
      
      public function getNowHunts() : int
      {
         return this.nowhunts;
      }
      
      public function getNowflowerpotNum() : int
      {
         return this.nowflowerpotNum;
      }
      
      public function getOccupy() : int
      {
         return this.occupy;
      }
      
      public function getOccupyMaxNum() : int
      {
         return this._occupyMaxNum;
      }
      
      public function getOccupyNum() : int
      {
         return this._occupyNum;
      }
      
      public function getPreAreanaOrgs() : Array
      {
         if(this._preAreanaOrgs == null)
         {
            this._preAreanaOrgs = new Array();
         }
         return this._preAreanaOrgs;
      }
      
      public function getPreLimitCopyOrgs() : Array
      {
         if(this._preLimitCopyOrgs == null)
         {
            this._preLimitCopyOrgs = new Array();
         }
         return this._preLimitCopyOrgs;
      }
      
      public function getPreCdTimeCopyOrgs() : Array
      {
         if(this._preCdTimeCopyOrgs == null)
         {
            this._preCdTimeCopyOrgs = new Array();
         }
         return this._preCdTimeCopyOrgs;
      }
      
      public function getPreJewelCopyOrgs() : Array
      {
         if(this._preJewelCopyOrgs == null)
         {
            this._preJewelCopyOrgs = new Array();
         }
         return this._preJewelCopyOrgs;
      }
      
      public function getPreWorldOrgs() : Array
      {
         if(this._preWorldOrgs == null)
         {
            this._preWorldOrgs = new Array();
         }
         return this._preWorldOrgs;
      }
      
      public function getRMB() : int
      {
         return this.rmb;
      }
      
      public function getRewardDaily() : int
      {
         return this._day;
      }
      
      public function getSeverBattleOrgs() : Array
      {
         return this._severBattleOrgs;
      }
      
      public function getSeverBattleOrgsNum() : int
      {
         return this._severBattleOrgsNum;
      }
      
      public function getSeverBattleStaus() : int
      {
         return this._serverBattleStaus;
      }
      
      public function getStorageFreeTools() : int
      {
         var _loc1_:* = this.storage_tool_num;
         var _loc2_:int = int(this.tools.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.tools[_loc3_] != null && (this.tools[_loc3_] as Tool).getNum() > 0)
            {
               _loc1_--;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getStorageOrgGrade() : int
      {
         return this.storage_org_grade;
      }
      
      public function getStorageOrgMoney() : int
      {
         return this.storage_org_money;
      }
      
      public function getStorageOrgNum() : int
      {
         return this.storage_org_num;
      }
      
      public function getStorageToolGrade() : int
      {
         return this.storage_tool_grade;
      }
      
      public function getStorageToolMoney() : int
      {
         return this.storage_tool_money;
      }
      
      public function getStorageToolNum() : int
      {
         return this.storage_tool_num;
      }
      
      public function getTodayExp() : int
      {
         return this.today_exp;
      }
      
      public function getTodayMaxExp() : int
      {
         return this.today_max_exp;
      }
      
      public function getTool(param1:int) : Tool
      {
         if(this.tools == null)
         {
            return null;
         }
         var _loc2_:int = int(this.tools.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((this.tools[_loc3_] as Tool).getOrderId() == param1)
            {
               return this.tools[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getToolByIndex(param1:int) : Tool
      {
         if(this.tools == null || this.tools.length < 1 || param1 > this.tools.length)
         {
            return null;
         }
         return this.tools[param1];
      }
      
      public function getToolIndex(param1:Tool) : int
      {
         if(this.tools == null || this.tools.length < 1)
         {
            return -1;
         }
         var _loc2_:int = int(this.tools.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this.tools[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function getTreeHeight() : int
      {
         return this.tree_height;
      }
      
      public function getTreeTimes() : int
      {
         return this.tree_times;
      }
      
      public function getUseInviteNum() : int
      {
         return this.use_invite_num;
      }
      
      public function getVipAutoGain() : int
      {
         return this._vipAutoGain;
      }
      
      public function getVipAutoRevert() : int
      {
         return this._vipAutoRevert;
      }
      
      public function getVipEXP() : int
      {
         return this._vipExp;
      }
      
      public function getVipLevel() : int
      {
         return this._vipLevel;
      }
      
      public function getVipTime() : int
      {
         return this._vipTime;
      }
      
      public function getWins() : int
      {
         return this.wins;
      }
      
      public function getWorldBuyNum() : int
      {
         return this.worldBuyNum;
      }
      
      public function getWorldTimes() : int
      {
         return this.worldTimes;
      }
      
      public function isBattleReady(param1:int) : Boolean
      {
         if(this._preAreanaOrgs == null || this._preAreanaOrgs.length == 0)
         {
            return false;
         }
         var _loc2_:int = int(this._preAreanaOrgs.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == (this._preAreanaOrgs[_loc3_] as Organism).getId())
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function isBattleReadyInWorld(param1:int) : Boolean
      {
         var _loc2_:Organism = null;
         if(this._preWorldOrgs == null || this._preWorldOrgs.length == 0)
         {
            return false;
         }
         for each(_loc2_ in this._preWorldOrgs)
         {
            if(param1 == _loc2_.getId())
            {
               return true;
            }
         }
         return false;
      }
      
      public function resetFriends(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.friends = new Array();
         this.friends = param1;
      }
      
      public function setArenaDate(param1:String) : void
      {
         this.arenaDate = param1;
      }
      
      public function setArenaLastRank(param1:int) : void
      {
         this.arenaLastRank = param1;
      }
      
      public function setArenaNum(param1:int) : void
      {
         this.arenaNum = param1;
      }
      
      public function setArenaOrgNum(param1:int) : void
      {
         this.arenaOrgNum = param1;
      }
      
      public function setArenaOrgs(param1:Array) : void
      {
         this.arenaOrgs = param1;
      }
      
      public function setArenaRank(param1:int) : void
      {
         this.arenaRank = param1;
      }
      
      public function setBannerNum(param1:int) : void
      {
         this.banner_num = param1;
      }
      
      public function setBannerUrl(param1:String) : void
      {
         this.bannerUrl = param1;
      }
      
      public function setBattleOpenGrade(param1:int) : void
      {
         this.battle_open_grade = param1;
      }
      
      public function setBattleOpenMoney(param1:int) : void
      {
         this.battle_open_money = param1;
      }
      
      public function setBattle_num(param1:int) : void
      {
         this.battle_num = param1;
      }
      
      public function setChangetools(param1:Array) : void
      {
         this.changetools = param1;
      }
      
      public function setCharm(param1:int) : void
      {
         this.charm = param1;
      }
      
      public function setEveryDayPrize(param1:int) : void
      {
         this.everyDayPrize = param1;
      }
      
      public function setExp(param1:int) : void
      {
         this.exp = param1;
      }
      
      public function setExpFull(param1:Boolean) : void
      {
         this.expFull = param1;
      }
      
      public function setExp_max(param1:int) : void
      {
         this.exp_max = param1;
      }
      
      public function setExp_min(param1:int) : void
      {
         this.exp_min = param1;
      }
      
      public function setFaceUrl1(param1:String) : void
      {
         this.faceUrl1 = param1;
      }
      
      public function setFaceUrl2(param1:String) : void
      {
         this.faceUrl2 = param1;
      }
      
      public function setFirstLogin(param1:Boolean) : void
      {
         this.firstLogin = param1;
      }
      
      public function setFirstRecharge(param1:int) : void
      {
         this.isfirstRecharge = param1;
      }
      
      public function setFlowerpotNum(param1:int) : void
      {
         this.flowerpotNum = param1;
      }
      
      public function setFriendLands(param1:int) : void
      {
         this.friendLands = param1;
      }
      
      public function setFriendsMaxpage(param1:int) : void
      {
         this.friends_maxpage = param1;
      }
      
      public function setFriendsNowpage(param1:int) : void
      {
         this.friends_nowpage = param1;
      }
      
      public function setFriendsNum(param1:int) : void
      {
         this.friends_num = param1;
      }
      
      public function setFriendsPagenum(param1:int) : void
      {
         this.friends_pagenum = param1;
      }
      
      public function setGrade(param1:int) : void
      {
         this.grade = param1;
      }
      
      public function setHasActiveAreward(param1:int) : void
      {
         this._activeAreward = param1;
      }
      
      public function setHasActiveBreward(param1:int) : void
      {
         this._activeBreward = param1;
      }
      
      public function setHasConsumeBreward(param1:int) : void
      {
         this._consumeReward = param1;
      }
      
      public function setHasReward(param1:int) : void
      {
         this._reward = param1;
      }
      
      public function setHoleDifficulty(param1:int) : void
      {
         this._holeDifficulty = param1;
      }
      
      public function setHonour(param1:int) : void
      {
         this._honour = param1;
      }
      
      public function setHunts(param1:int) : void
      {
         this.hunts = param1;
      }
      
      public function setId(param1:Number) : void
      {
         this.id = param1;
      }
      
      public function setInviteAmount(param1:int) : void
      {
         this.invite_amount = param1;
      }
      
      public function setIsActivity(param1:Boolean) : void
      {
         this.isActivity = param1;
      }
      
      public function setIsGardenOrg(param1:int) : void
      {
         this.isGardenOrg = param1;
      }
      
      public function setIsNew(param1:Boolean) : void
      {
         this.isNew = param1;
      }
      
      public function setKey(param1:String) : void
      {
         this.key = param1;
      }
      
      public function setLastArenaDate(param1:String) : void
      {
         this.lastArenaDate = param1;
      }
      
      public function setLastHoleId(param1:int) : void
      {
         this.lastHoleId = param1;
      }
      
      public function setLastOccupy(param1:int) : void
      {
         this.last_occupy = param1;
      }
      
      public function setMaxUseInviteNum(param1:int) : void
      {
         this.max_use_invite_num = param1;
      }
      
      public function setMoney(param1:Number) : void
      {
         this.money = param1;
      }
      
      public function setNickname(param1:String) : void
      {
         this.nickname = param1;
      }
      
      public function setNowHunts(param1:int) : void
      {
         this.nowhunts = param1;
      }
      
      public function setNowflowerpotNum(param1:int) : void
      {
         this.nowflowerpotNum = param1;
      }
      
      public function setOccupy(param1:int) : void
      {
         this.occupy = param1;
      }
      
      public function setOccupyMaxNum(param1:int) : void
      {
         this._occupyMaxNum = param1;
      }
      
      public function setOccupyNum(param1:int) : void
      {
         this._occupyNum = param1;
      }
      
      public function setPreAreanaOrgs(param1:Array) : void
      {
         this._preAreanaOrgs = param1;
      }
      
      public function setPreWorldOrgs(param1:Array) : void
      {
         this._preWorldOrgs = param1;
      }
      
      public function setRMB(param1:int) : void
      {
         this.rmb = param1;
      }
      
      public function setRewardDaily(param1:int) : void
      {
         this._day = param1;
      }
      
      public function setSeverBattleOrgs(param1:Array) : void
      {
         this._severBattleOrgs = param1;
      }
      
      public function setSeverBattleOrgsNum(param1:int) : void
      {
         this._severBattleOrgsNum = param1;
      }
      
      public function setSeverBattleStaus(param1:int) : void
      {
         this._serverBattleStaus = param1;
      }
      
      public function setStorageOrgGrade(param1:int) : void
      {
         this.storage_org_grade = param1;
      }
      
      public function setStorageOrgMoney(param1:int) : void
      {
         this.storage_org_money = param1;
      }
      
      public function setStorageOrgNum(param1:int) : void
      {
         this.storage_org_num = param1;
      }
      
      public function setStorageToolGrade(param1:int) : void
      {
         this.storage_tool_grade = param1;
      }
      
      public function setStorageToolMoney(param1:int) : void
      {
         this.storage_tool_money = param1;
      }
      
      public function setStorageToolNum(param1:int) : void
      {
         this.storage_tool_num = param1;
      }
      
      public function setToadyMaxExp(param1:int) : void
      {
         this.today_max_exp = param1;
      }
      
      public function setTodayExp(param1:int) : void
      {
         this.today_exp = param1;
      }
      
      public function setTreeHeight(param1:int) : void
      {
         this.tree_height = param1;
      }
      
      public function setTreeTimes(param1:int) : void
      {
         this.tree_times = param1;
      }
      
      public function setUseInviteNum(param1:int) : void
      {
         this.use_invite_num = param1;
      }
      
      public function setVipAutoGain(param1:int) : void
      {
         this._vipAutoGain = param1;
      }
      
      public function setVipAutoRevert(param1:int) : void
      {
         this._vipAutoRevert = param1;
      }
      
      public function setVipEXP(param1:int) : void
      {
         this._vipExp = param1;
      }
      
      public function setVipLevel(param1:int) : void
      {
         this._vipLevel = param1;
      }
      
      public function setVipTime(param1:int) : void
      {
         this._vipTime = param1;
      }
      
      public function setWins(param1:int) : void
      {
         this.wins = param1;
      }
      
      public function setWorldBuyNum(param1:int) : void
      {
         this.worldBuyNum = param1;
      }
      
      public function setWorldTimes(param1:int) : void
      {
         this.worldTimes = param1;
      }
      
      public function updateOrg(param1:Organism) : void
      {
         if(this.organisms == null || this.organisms.length < 1)
         {
            return;
         }
         var _loc2_:int = int(this.organisms.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((this.organisms[_loc3_] as Organism).getId() == param1.getId())
            {
               this.organisms[_loc3_] = param1;
            }
            _loc3_++;
         }
      }
      
      public function updateTool(param1:int, param2:int) : void
      {
         var _loc3_:Tool = this.getTool(param1);
         if(param2 == 0 && _loc3_ != null)
         {
            this.tools.splice(this.getToolIndex(_loc3_),1);
         }
         if(_loc3_ == null)
         {
            _loc3_ = new Tool(param1);
            _loc3_.setNum(param2);
            this.tools.push(_loc3_);
         }
         else
         {
            _loc3_.setNum(param2);
         }
      }
      
      public function useTools(param1:int, param2:int) : void
      {
         if(param2 == 0)
         {
            return;
         }
         var _loc3_:Tool = this.getTool(param1);
         if(param2 > _loc3_.getNum())
         {
            return;
         }
         _loc3_.setNum(_loc3_.getNum() - param2);
         if(_loc3_.getNum() == 0)
         {
            this.tools.splice(this.getToolIndex(_loc3_),1);
         }
      }
      
      public function getOrganismById(param1:int) : Organism
      {
         var _loc2_:Organism = null;
         for each(_loc2_ in this.organisms)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function setIsRegistration(param1:Boolean) : void
      {
         this._isRegistration = param1;
      }
      
      public function getIsRegistration() : Boolean
      {
         return this._isRegistration;
      }
      
      public function get IsNewTaskSystem() : Boolean
      {
         return this._IsNewTaskSystem;
      }
      
      public function set IsNewTaskSystem(param1:Boolean) : void
      {
         this._IsNewTaskSystem = param1;
      }
   }
}

