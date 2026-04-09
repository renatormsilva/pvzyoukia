package pvz.arena.fore
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import loading.UILoading;
   import manager.APLManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.arena.node.EnemyNode;
   import pvz.arena.rpc.Arena_rpc;
   import pvz.arena.window.ArenaNoticeWindow;
   import pvz.arena.window.ArenaRankWindow;
   import pvz.arena.window.SettingWindow;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import windows.ChallengePropWindow;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ArenaForelet extends Sprite implements IConnection, IDestroy
   {
      
      public static const INIT:int = 1;
      
      public static const NUM:int = 3;
      
      public static const PUBLIC_CHANGE:int = 1;
      
      internal var _enemy:Array = null;
      
      internal var _log:Array = null;
      
      internal var _maxPage:int = 1;
      
      internal var _mc:MovieClip = null;
      
      internal var _node:DisplayObjectContainer = null;
      
      internal var _nowPage:int = 0;
      
      internal var _rankWindow:ArenaRankWindow = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _uiLoad:UILoading = null;
      
      public function ArenaForelet(param1:DisplayObjectContainer)
      {
         super();
         this._node = param1;
         PlantsVsZombies.setToFirstPageButtonVisible(false);
         this.doLoad();
      }
      
      public function destroy() : void
      {
         TextFilter.removeFilter(this._mc["_info"]["_txt_name"]);
         this.removeBtEvent();
         this.clearEnemy();
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:Arena_rpc = new Arena_rpc();
         if(param1 == INIT)
         {
            this.playerManager.setPlayer(_loc3_.getInitPlayer(param2,this.playerManager.getPlayer()));
            if(this.playerManager.getPlayer().getArenaOrgs() == null || this.playerManager.getPlayer().getArenaOrgs().length < 1)
            {
               new SettingWindow(this.init,this.changeJiantouShow).show();
               return;
            }
            this._log = _loc3_.getInitLog(param2);
            this._enemy = _loc3_.getInitEnemy(param2);
            this._maxPage = (this._enemy.length - 1) / NUM + 1;
            this._nowPage = 1;
            this.setRankAndArenaNum();
            this.showEnemy();
            this.changeJiantouShow();
            this.showAttention(_loc3_.getAttention(param2));
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
      
      private function ListenEventWindow(param1:Event) : void
      {
         new ChallengePropWindow(ChallengePropWindow.TYPE_TWO,this.setRankAndArenaNum);
      }
      
      private function addBtEvent() : void
      {
         this._mc["_info"]["_bt_notice"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_info"]["user_book_window"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_setting"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_rank"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_last"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_next"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function changeJiantouShow() : void
      {
         var countArena:Function = function():int
         {
            var _loc2_:int = 0;
            var _loc1_:int = 0;
            if(playerManager.getPlayer().getArenaOrgs())
            {
               _loc2_ = 0;
               while(_loc2_ < playerManager.getPlayer().getArenaOrgs().length)
               {
                  if(playerManager.getPlayer().getArenaOrgs()[_loc2_] as Organism)
                  {
                     _loc1_ += (playerManager.getPlayer().getArenaOrgs()[_loc2_] as Organism).getWidth() * (playerManager.getPlayer().getArenaOrgs()[_loc2_] as Organism).getHeight();
                  }
                  _loc2_++;
               }
            }
            return _loc1_;
         };
         this._mc["_mc_jiantou"].visible = false;
         if(countArena() < this.playerManager.getPlayer().getBattle_num())
         {
            this._mc.setChildIndex(this._mc["_mc_jiantou"],this._mc.numChildren - 1);
            this._mc["_mc_jiantou"].visible = true;
         }
      }
      
      private function chooseEnemy() : Array
      {
         return this._enemy.slice((this._nowPage - 1) * NUM,this._nowPage * NUM);
      }
      
      private function clearEnemy() : void
      {
         var _loc1_:* = int(this._mc.numChildren - 1);
         while(_loc1_ >= 0)
         {
            if(this._mc.getChildAt(_loc1_) is EnemyNode)
            {
               (this._mc.getChildAt(_loc1_) as EnemyNode).clear();
               this._mc.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function clearPicNum() : void
      {
         FuncKit.clearAllChildrens(this._mc["_info"]["_num"]);
         FuncKit.clearAllChildrens(this._mc["_info"]["_rank"]);
      }
      
      private function doLoad() : void
      {
         this._uiLoad = new UILoading(this._node,GlobalConstants.PVZ_RES_BASE_URL,"config/load/arena.xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function init(param1:int = 0) : void
      {
         if(param1 != 0)
         {
            this.setRankAndArenaNum();
         }
         else
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_INIT,INIT);
         }
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("arena_forelet");
         this._mc = new _loc1_();
         this._mc.visible = false;
         this._node.addChild(this._mc);
         this._mc["_info"]["_mc_att"].visible = false;
         TextFilter.MiaoBian(this._mc["_info"]["_txt_name"],0,1,5,5);
         this.addBtEvent();
         this.show();
      }
      
      private function onAllComp(param1:ForeletEvent = null) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         this.initUI();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_notice")
         {
            new ArenaNoticeWindow(this._log);
         }
         else if(param1.currentTarget.name == "_bt_setting")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            new SettingWindow(null,this.changeJiantouShow).show();
         }
         else if(param1.currentTarget.name == "_bt_rank")
         {
            if(this._rankWindow == null)
            {
               this._rankWindow = new ArenaRankWindow();
            }
            this._rankWindow.show();
         }
         else if(param1.currentTarget.name == "_bt_last")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._nowPage < 2)
            {
               return;
            }
            --this._nowPage;
            this.showEnemy();
         }
         else if(param1.currentTarget.name == "_bt_next")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._nowPage == this._maxPage)
            {
               return;
            }
            ++this._nowPage;
            this.showEnemy();
         }
         else if(param1.currentTarget.name == "user_book_window")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            new ChallengePropWindow(ChallengePropWindow.TYPE_TWO,this.setRankAndArenaNum);
         }
      }
      
      private function removeBtEvent() : void
      {
         this._mc["_info"]["_bt_notice"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_setting"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_rank"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_last"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_functional"]["_bt_next"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setPlayerInfo() : void
      {
         PlantsVsZombies.setHeadPic(this._mc["_info"]["_pic_head"],PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
         this._mc["_info"]["_txt_name"].text = this.playerManager.getPlayer().getNickname();
         var _loc1_:Class = DomainAccess.getClass("grade");
         var _loc2_:MovieClip = new _loc1_();
         _loc2_["num"].addChild(FuncKit.getNumEffect("" + this.playerManager.getPlayer().getGrade()));
         this._mc["_info"]["_pic_lv"].addChild(_loc2_);
      }
      
      private function setRankAndArenaNum(param1:String = null) : void
      {
         if(this._mc["_info"]["_pic_rank"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_info"]["_pic_rank"]);
         }
         var _loc2_:DisplayObject = FuncKit.getNumEffect("" + this.playerManager.getPlayer().getArenaRank(),"Red");
         _loc2_.x = -_loc2_.width / 2;
         this._mc["_info"]["_pic_rank"].addChild(_loc2_);
         if(this._mc["_info"]["_pic_num"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_info"]["_pic_num"]);
         }
         var _loc3_:DisplayObject = FuncKit.getNumEffect("" + this.playerManager.getPlayer().getArenaNum(),"Small");
         _loc3_.x = -_loc3_.width / 2;
         this._mc["_info"]["_pic_num"].addChild(_loc3_);
      }
      
      private function show() : void
      {
         this.setPlayerInfo();
         this._mc["_mc_jiantou"].visible = false;
         this._mc.visible = true;
         this.init();
      }
      
      private function showAttention(param1:int) : void
      {
         if(this._mc["_info"]["_mc_attention"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_info"]["_mc_attention"]);
         }
         this._mc["_info"]["_mc_att"].visible = false;
         if(param1 < 2)
         {
            return;
         }
         var _loc2_:DisplayObject = FuncKit.getNumEffect("" + param1,"Small");
         _loc2_.x = -_loc2_.width + 3;
         this._mc["_info"]["_mc_attention"].addChild(_loc2_);
         this._mc["_info"]["_mc_att"].visible = true;
      }
      
      private function showEnemy() : void
      {
         var _loc3_:EnemyNode = null;
         this._mc["_functional"]["_txt_page"].text = this._nowPage + "/" + this._maxPage;
         if(this._enemy == null || this._enemy.length < 1)
         {
            return;
         }
         this.clearEnemy();
         var _loc1_:Array = this.chooseEnemy();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new EnemyNode(_loc1_[_loc2_],this.init);
            _loc3_.addEventListener(Event.CHANGE,this.ListenEventWindow);
            _loc3_.x = this._mc["_loc_enemy"].x;
            _loc3_.y = this._mc["_loc_enemy"].y + (_loc3_.height - 1) * _loc2_;
            this._mc.addChild(_loc3_);
            _loc2_++;
         }
         this.changeJiantouShow();
      }
   }
}

