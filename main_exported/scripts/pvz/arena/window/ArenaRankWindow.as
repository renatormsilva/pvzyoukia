package pvz.arena.window
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.PlayerManager;
   import pvz.arena.node.ArenaChooseRankNode;
   import pvz.arena.node.ArenaRankInfoNode;
   import pvz.arena.rpc.Arena_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class ArenaRankWindow extends BaseWindow implements IConnection
   {
      
      private static const LAST_RANK:int = 2;
      
      private static const NOW_RANK:int = 1;
      
      private static const PAGE_NUM:int = 8;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _maxPage:int = 1;
      
      internal var _mc:MovieClip = null;
      
      internal var _nowArray:Array = null;
      
      internal var _nowPage:int = 0;
      
      internal var _type:int = 0;
      
      internal var _typeRank:int = -1;
      
      internal var info_class:Class = null;
      
      internal var rank_class:Class = null;
      
      internal var rankinfo:Array = null;
      
      internal var lastrankinfo:Array = null;
      
      public function ArenaRankWindow()
      {
         super();
         this.rankinfo = new Array(GlobalConstants.RANK_NUM + 1);
         this.lastrankinfo = new Array(GlobalConstants.RANK_NUM + 1);
         var _loc1_:Class = DomainAccess.getClass("arena_rank_window");
         this._mc = new _loc1_();
         this._mc.visible = false;
         this.initRankType();
         this.initRankBt();
         this.addEvent();
         this._mc["_txt_date"].text = this.playerManager.getPlayer().getArenaDate();
         PlantsVsZombies._node.addChild(this._mc);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callO(param2,param3,rest[0]);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:Arena_rpc = new Arena_rpc();
         if(this._type == NOW_RANK)
         {
            this.rankinfo[param1] = _loc3_.getArenaAllRank(param2);
            this._maxPage = (this.rankinfo[param1].length - 1) / PAGE_NUM + 1;
            if(this._maxPage == 0)
            {
               this._maxPage = 1;
            }
         }
         else
         {
            this.lastrankinfo[param1] = _loc3_.getArenaAllRank(param2);
            this._maxPage = (this.lastrankinfo[param1].length - 1) / PAGE_NUM + 1;
            if(this._maxPage == 0)
            {
               this._maxPage = 1;
            }
         }
         this._nowPage = 1;
         this.showRank();
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
         showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._typeRank = 0;
         this.setMyRank();
         this.changeRank(0);
         this.clearRankBtSelected();
         this.setRankBtSelected(0,true);
         this._mc.visible = true;
         onShowEffectBig(this._mc,removeBG);
      }
      
      private function setMyRank() : void
      {
         if(this._mc["_pic_rank"] != null && this._mc["_pic_rank"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_pic_rank"]);
         }
         this._mc["_pic_rank"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getArenaRank() + "","Red"));
      }
      
      private function initRankType() : void
      {
         this._type = NOW_RANK;
         this._mc["_bt_ranknow"].visible = false;
         this._mc["_bt_ranknow_selected"].visible = true;
         this._mc["_bt_ranklast"].visible = true;
         this._mc["_bt_ranklast_selected"].visible = false;
         this.initRankTypeBtEvent();
      }
      
      private function initRankTypeBtEvent() : void
      {
         this._mc["_bt_ranknow"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_ranklast"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addEvent() : void
      {
         this._mc["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_last"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_next"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function changeRank(param1:int) : void
      {
         this.clearRankBtSelected();
         this._typeRank = param1;
         if(this._type == NOW_RANK)
         {
            if(this.rankinfo[param1] == null || this.rankinfo[param1].length < 1)
            {
               this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_RANK,param1,param1);
            }
            else
            {
               this._maxPage = (this.rankinfo[param1].length - 1) / PAGE_NUM + 1;
               if(this._maxPage == 0)
               {
                  this._maxPage = 1;
               }
               this._nowPage = 1;
               this.showRank();
            }
         }
         else if(this.lastrankinfo[param1] == null || this.lastrankinfo[param1].length < 1)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_OLDRANK,param1,param1);
         }
         else
         {
            this._maxPage = (this.lastrankinfo[param1].length - 1) / PAGE_NUM + 1;
            if(this._maxPage == 0)
            {
               this._maxPage = 1;
            }
            this._nowPage = 1;
            this.showRank();
         }
      }
      
      private function clearRankBtSelected() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._mc.numChildren)
         {
            if(this._mc.getChildAt(_loc1_) is ArenaChooseRankNode)
            {
               (this._mc.getChildAt(_loc1_) as ArenaChooseRankNode).setSelect(false);
            }
            _loc1_++;
         }
      }
      
      private function clearRankInfoSelected() : void
      {
         var _loc1_:* = int(this._mc.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._mc.getChildAt(_loc1_) is ArenaRankInfoNode)
            {
               (this._mc.getChildAt(_loc1_) as ArenaRankInfoNode).setSelected(false);
            }
            _loc1_--;
         }
      }
      
      private function clearRankinfo() : void
      {
         var _loc1_:* = int(this._mc.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._mc.getChildAt(_loc1_) is ArenaRankInfoNode)
            {
               (this._mc.getChildAt(_loc1_) as ArenaRankInfoNode).clear();
               this._mc.removeChild(this._mc.getChildAt(_loc1_));
            }
            _loc1_--;
         }
      }
      
      private function initRankBt() : void
      {
         var _loc2_:ArenaChooseRankNode = null;
         var _loc1_:int = 0;
         while(_loc1_ < GlobalConstants.RANK_NUM)
         {
            _loc2_ = new ArenaChooseRankNode(_loc1_,this.changeRank);
            _loc2_.x = 21;
            _loc2_.y = 140 + (_loc1_ - 1) * (_loc2_.height - 1);
            this._mc.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_close")
         {
            onHiddenEffectBig(this._mc);
         }
         else if(param1.currentTarget.name == "_bt_last")
         {
            if(this._nowPage < 2)
            {
               return;
            }
            --this._nowPage;
            this.showRank();
         }
         else if(param1.currentTarget.name == "_bt_next")
         {
            if(this._nowPage == this._maxPage)
            {
               return;
            }
            ++this._nowPage;
            this.showRank();
         }
         else if(param1.currentTarget.name == "_bt_ranknow")
         {
            this._mc["_bt_ranknow"].visible = false;
            this._mc["_bt_ranknow_selected"].visible = true;
            this._mc["_bt_ranklast_selected"].visible = false;
            this._mc["_bt_ranklast"].visible = true;
            this._type = NOW_RANK;
            this.changeRank(0);
            this.clearRankBtSelected();
            this.setRankBtSelected(0,true);
            this._mc["_txt_date"].text = this.playerManager.getPlayer().getArenaDate();
         }
         else if(param1.currentTarget.name == "_bt_ranklast")
         {
            this._mc["_bt_ranklast"].visible = false;
            this._mc["_bt_ranklast_selected"].visible = true;
            this._mc["_bt_ranknow_selected"].visible = false;
            this._mc["_bt_ranknow"].visible = true;
            this._type = LAST_RANK;
            this.changeRank(0);
            this.clearRankBtSelected();
            this.setRankBtSelected(0,true);
            this._mc["_txt_date"].text = this.playerManager.getPlayer().getLastArenaDate();
         }
      }
      
      private function setRankBtSelected(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._mc.numChildren)
         {
            if(this._mc.getChildAt(_loc3_) is ArenaChooseRankNode && (this._mc.getChildAt(_loc3_) as ArenaChooseRankNode).getType() == param1)
            {
               (this._mc.getChildAt(_loc3_) as ArenaChooseRankNode).setSelect(param2);
            }
            _loc3_++;
         }
      }
      
      private function showRank() : void
      {
         var _loc2_:ArenaRankInfoNode = null;
         this.clearRankinfo();
         this._nowArray = new Array();
         this._mc["_txt_page"].text = this._nowPage + "/" + this._maxPage;
         if(this._type == NOW_RANK)
         {
            this._nowArray = this.rankinfo[this._typeRank].slice((this._nowPage - 1) * PAGE_NUM,this._nowPage * PAGE_NUM);
         }
         else
         {
            this._nowArray = this.lastrankinfo[this._typeRank].slice((this._nowPage - 1) * PAGE_NUM,this._nowPage * PAGE_NUM);
         }
         if(this._nowArray == null || this._nowArray.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._nowArray.length)
         {
            _loc2_ = new ArenaRankInfoNode(this._nowArray[_loc1_],this.clearRankInfoSelected);
            if(_loc1_ == 0)
            {
               _loc2_.setSelected(true);
            }
            _loc2_.x = 280;
            _loc2_.y = 119 + _loc1_ * (_loc2_.height + 1);
            this._mc.addChild(_loc2_);
            _loc1_++;
         }
      }
   }
}

