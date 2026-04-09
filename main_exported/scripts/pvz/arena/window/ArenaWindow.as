package pvz.arena.window
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.arena.entity.ArenaEnemy;
   import pvz.arena.node.ArenaOrgNode;
   import pvz.battle.fore.Battlefield;
   import pvz.battle.manager.BattlefieldControlManager;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ChallengePropWindow;
   import zlib.utils.DomainAccess;
   import zmyth.ui.TextFilter;
   
   public class ArenaWindow extends BaseWindow implements IConnection
   {
      
      public static const START:int = 1;
      
      private static const MAX:int = 6;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _backfun:Function = null;
      
      internal var _isStart:Boolean = false;
      
      internal var _mc:MovieClip = null;
      
      private var _ae:ArenaEnemy = null;
      
      private var _maxPage:Array = null;
      
      private var _nowPage:Array = null;
      
      public function ArenaWindow(param1:ArenaEnemy, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("arena_window");
         this._mc = new _loc3_();
         this._mc.visible = false;
         this.addEvent();
         this._ae = param1;
         this.show();
         this._backfun = param2;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._mc);
         this.miaobian();
         this._isStart = false;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == START)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:BattlefieldControlManager = null;
         if(param1 == START)
         {
            this.playerManager.getPlayer().setArenaNum(this.playerManager.getPlayer().getArenaNum() - 1);
            if(this.playerManager.getPlayer().getArenaNum() == 0)
            {
               new ChallengePropWindow(ChallengePropWindow.TYPE_TWO,this._backfun);
            }
            _loc3_ = new BattlefieldControlManager();
            _loc3_.doBattleInfosRPC(param2,BattlefieldControlManager.ARENA);
            this.changeOrgsHp(this.playerManager.getPlayer().getArenaOrgs());
            this._mc.visible = false;
            this._isStart = false;
            PlantsVsZombies.showDataLoading(false);
            new Battlefield(this.playerManager.getPlayer().getArenaOrgs(),_loc3_.getEnemyOrgs(param2),_loc3_,this._backfun,BattlefieldControlManager.ARENA,this._ae);
            PlantsVsZombies._node.removeChild(this._mc);
            this.clear();
            removeBG();
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
      
      private function addEvent() : void
      {
         this._mc["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_start"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_right1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_left1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_right2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_left2"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function changeBtShow(param1:int) : void
      {
         this._mc["_bt_right" + (param1 + 1)].visible = true;
         this._mc["_bt_left" + (param1 + 1)].visible = true;
         if(this._nowPage[param1] <= 1)
         {
            this._mc["_bt_left" + (param1 + 1)].visible = false;
         }
         if(this._nowPage[param1] >= this._maxPage[param1])
         {
            this._mc["_bt_right" + (param1 + 1)].visible = false;
         }
      }
      
      private function changeOrgsHp(param1:Array) : Array
      {
         if(param1 == null || param1.length < 1)
         {
            throw new Error("竞技场，生物数据不存在");
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            (param1[_loc2_] as Organism).setHp((param1[_loc2_] as Organism).getHp_max().toString());
            _loc2_++;
         }
         return param1;
      }
      
      private function clear() : void
      {
         TextFilter.removeFilter(this._mc["_txt_name1"]);
         TextFilter.removeFilter(this._mc["_txt_name2"]);
         this.removeEvent();
         this.clearOrgs();
         FuncKit.clearAllChildrens(this._mc);
      }
      
      private function clearOrgs() : void
      {
         if(this._mc.numChildren <= 0)
         {
            return;
         }
         var _loc1_:* = int(this._mc.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._mc.getChildAt(_loc1_) is ArenaOrgNode)
            {
               (this._mc.getChildAt(_loc1_) as ArenaOrgNode).destroy();
               this._mc.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function initPageInfo() : void
      {
         this._nowPage = new Array(1,1);
         this._maxPage = new Array(int((this.playerManager.getPlayer().getArenaOrgs().length - 1) / MAX) + 1,int((this._ae.getArenaOrgs().length - 1) / MAX) + 1);
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._mc["_txt_name1"],0);
         TextFilter.MiaoBian(this._mc["_txt_name2"],0);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_close")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            onHiddenEffect(this._mc,this.clear);
         }
         else if(param1.currentTarget.name == "_bt_start")
         {
            if(this._isStart)
            {
               return;
            }
            PlantsVsZombies.showDataLoading(true);
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.start();
         }
         else if(param1.currentTarget.name == "_bt_left1")
         {
            if(this._nowPage[0] <= 1)
            {
               return;
            }
            --this._nowPage[0];
            this.setAllOrgs();
         }
         else if(param1.currentTarget.name == "_bt_right1")
         {
            if(this._nowPage[0] >= this._maxPage[0])
            {
               return;
            }
            ++this._nowPage[0];
            this.setAllOrgs();
         }
         else if(param1.currentTarget.name == "_bt_left2")
         {
            if(this._nowPage[1] <= 1)
            {
               return;
            }
            --this._nowPage[1];
            this.setAllOrgs();
         }
         else if(param1.currentTarget.name == "_bt_right2")
         {
            if(this._nowPage[1] >= this._maxPage[1])
            {
               return;
            }
            ++this._nowPage[1];
            this.setAllOrgs();
         }
      }
      
      private function removeEvent() : void
      {
         this._mc["_bt_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_start"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_right1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_left1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_right2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_left2"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setAllOrgs() : void
      {
         this.clearOrgs();
         this.setOrgs(this.getRealOrg(),this._mc["_loc_orgs1"],0);
         this.setOrgs(this._ae.getArenaOrgs(),this._mc["_loc_orgs2"],1);
      }
      
      private function getRealOrg() : Array
      {
         var _loc3_:Organism = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = this.playerManager.getPlayer().getArenaOrgs();
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(this.playerManager.getPlayer().getOrganismById(_loc3_.getId()));
         }
         return _loc1_;
      }
      
      private function setBtLayer() : void
      {
         this._mc.setChildIndex(this._mc["_bt_right1"],this._mc.numChildren - 1);
         this._mc.setChildIndex(this._mc["_bt_left1"],this._mc.numChildren - 1);
         this._mc.setChildIndex(this._mc["_bt_right2"],this._mc.numChildren - 1);
         this._mc.setChildIndex(this._mc["_bt_left2"],this._mc.numChildren - 1);
      }
      
      private function setLoction() : void
      {
         this._mc.x = (PlantsVsZombies.WIDTH - this._mc.width) / 2;
         this._mc.y = (PlantsVsZombies.HEIGHT - this._mc.height) / 2 + 10;
      }
      
      private function setOrgs(param1:Array, param2:MovieClip, param3:int) : void
      {
         var _loc7_:Array = null;
         var _loc8_:ArenaOrgNode = null;
         this.changeBtShow(param3);
         var _loc4_:int = 0;
         if(this._nowPage[param3] * MAX > param1.length)
         {
            _loc7_ = param1.slice((this._nowPage[param3] - 1) * MAX,param1.length);
         }
         else
         {
            _loc7_ = param1.slice((this._nowPage[param3] - 1) * MAX,this._nowPage[param3] * MAX);
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc7_.length)
         {
            _loc8_ = new ArenaOrgNode(_loc7_[_loc5_]);
            _loc8_.x = param2.x + _loc5_ * (_loc8_.width + 1);
            _loc8_.y = param2.y;
            this._mc.addChild(_loc8_);
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < MAX - _loc7_.length)
         {
            _loc8_ = new ArenaOrgNode(null);
            _loc8_.x = param2.x + (_loc6_ + _loc7_.length) * (_loc8_.width + 1);
            _loc8_.y = param2.y;
            this._mc.addChild(_loc8_);
            _loc6_++;
         }
         this.setBtLayer();
      }
      
      private function show() : void
      {
         this.setLoction();
         this.showRank(this._ae);
         this.initPageInfo();
         this.setAllOrgs();
         this.showUserInfo(this._ae);
         this._mc.visible = true;
         onShowEffect(this._mc);
      }
      
      private function showRank(param1:ArenaEnemy) : void
      {
         var _loc2_:DisplayObject = FuncKit.getNumEffect("" + this.playerManager.getPlayer().getArenaRank(),"Red");
         var _loc3_:DisplayObject = FuncKit.getNumEffect("" + param1.getArenaRank(),"Red");
         this._mc["_pic_rank1"].addChild(_loc2_);
         this._mc["_pic_rank2"].addChild(_loc3_);
      }
      
      private function showUserInfo(param1:ArenaEnemy) : void
      {
         this._mc["_txt_name1"].text = this.playerManager.getPlayer().getNickname();
         this._mc["_txt_name2"].text = param1.getNickName();
         PlantsVsZombies.setHeadPic(this._mc["_pic_head1"],PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
         PlantsVsZombies.setHeadPic(this._mc["_pic_head2"],PlantsVsZombies.getHeadPicUrl(param1.getFaceUrl()),PlantsVsZombies.HEADPIC_BIG,param1.getVipTime(),param1.getVipLevel());
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + this.playerManager.getPlayer().getGrade()));
         this._mc["_pic_lv1"].addChild(_loc3_);
         var _loc4_:MovieClip = new _loc2_();
         _loc4_["num"].addChild(FuncKit.getNumEffect("" + param1.getGrade()));
         this._mc["_pic_lv2"].addChild(_loc4_);
      }
      
      private function start() : void
      {
         this._isStart = true;
         PlantsVsZombies.showDataLoading(true);
         var _loc1_:Number = this._ae.getUserId();
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_START,START,_loc1_);
      }
   }
}

