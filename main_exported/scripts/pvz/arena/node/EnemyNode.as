package pvz.arena.node
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.arena.entity.ArenaEnemy;
   import pvz.arena.window.ArenaWindow;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class EnemyNode extends Sprite
   {
      
      private static const MAX:int = 6;
      
      internal var _ae:ArenaEnemy = null;
      
      internal var _backfun:Function = null;
      
      internal var _mc:MovieClip = null;
      
      private var _maxPage:int = 1;
      
      private var _nowPage:int = 1;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function EnemyNode(param1:ArenaEnemy, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("challenge_node");
         this._mc = new _loc3_();
         this._mc.visible = false;
         this.addEvent();
         addChild(this._mc);
         this._backfun = param2;
         TextFilter.MiaoBian(this._mc["_txt_name"],0,1,5,5);
         this._ae = param1;
         this.show();
      }
      
      public function clear() : void
      {
         this.clearOrgs();
         this.clearInfo();
         this.removeEvent();
      }
      
      private function addEvent() : void
      {
         this._mc["_bt_challenge"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_right"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function changeBtShow() : void
      {
         this._mc["_bt_right"].visible = true;
         this._mc["_bt_left"].visible = true;
         if(this._nowPage <= 1)
         {
            this._mc["_bt_left"].visible = false;
         }
         if(this._nowPage >= this._maxPage)
         {
            this._mc["_bt_right"].visible = false;
         }
      }
      
      private function clearInfo() : void
      {
         this._mc["_txt_name"].text = "";
         TextFilter.removeFilter(this._mc["_txt_name"]);
         FuncKit.clearAllChildrens(this._mc["_pic_head"]);
         FuncKit.clearAllChildrens(this._mc["_pic_lv"]);
         FuncKit.clearAllChildrens(this._mc["_pic_rank"]);
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
            if(this._mc.getChildAt(_loc1_) is EnemyOrgNode)
            {
               this._mc.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_challenge")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(this.playerManager.getPlayer().getArenaNum() == 0)
            {
               dispatchEvent(new Event(Event.CHANGE));
               return;
            }
            new ArenaWindow(this._ae,this._backfun);
         }
         else if(param1.currentTarget.name == "_bt_left")
         {
            if(this._nowPage <= 1)
            {
               return;
            }
            --this._nowPage;
            this.setOrgs(this._ae);
         }
         else if(param1.currentTarget.name == "_bt_right")
         {
            if(this._nowPage >= this._maxPage)
            {
               return;
            }
            ++this._nowPage;
            this.setOrgs(this._ae);
         }
      }
      
      private function removeEvent() : void
      {
         this._mc["_bt_challenge"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_right"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setBtLayer() : void
      {
         this._mc.setChildIndex(this._mc["_bt_right"],this._mc.numChildren - 1);
         this._mc.setChildIndex(this._mc["_bt_left"],this._mc.numChildren - 1);
      }
      
      private function setInfo(param1:ArenaEnemy) : void
      {
         this._mc["_txt_name"].text = param1.getNickName();
         PlantsVsZombies.setHeadPic(this._mc["_pic_head"],PlantsVsZombies.getHeadPicUrl(param1.getFaceUrl()),PlantsVsZombies.HEADPIC_BIG,param1.getVipTime(),param1.getVipLevel());
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + param1.getGrade()));
         this._mc["_pic_lv"].addChild(_loc3_);
         var _loc4_:DisplayObject = FuncKit.getNumEffect("" + param1.getArenaRank(),"Red");
         _loc4_.x = -_loc4_.width / 2;
         this._mc["_pic_rank"].addChild(_loc4_);
         this._nowPage = 1;
         this._maxPage = (param1.getArenaOrgs().length - 1) / MAX + 1;
      }
      
      private function setOrgs(param1:ArenaEnemy) : void
      {
         var _loc5_:Array = null;
         var _loc6_:EnemyOrgNode = null;
         this.changeBtShow();
         this.clearOrgs();
         var _loc2_:int = 0;
         if(this._nowPage * MAX > param1.getArenaOrgs().length)
         {
            _loc5_ = param1.getArenaOrgs().slice((this._nowPage - 1) * MAX,param1.getArenaOrgs().length);
         }
         else
         {
            _loc5_ = param1.getArenaOrgs().slice((this._nowPage - 1) * MAX,this._nowPage * MAX);
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc6_ = new EnemyOrgNode(_loc5_[_loc3_]);
            _loc6_.x = this._mc["_loc_orgs"].x + _loc3_ * (_loc6_.width + 1);
            _loc6_.y = this._mc["_loc_orgs"].y;
            this._mc.addChild(_loc6_);
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < MAX - _loc5_.length)
         {
            _loc6_ = new EnemyOrgNode(null);
            _loc6_.x = this._mc["_loc_orgs"].x + (_loc4_ + _loc5_.length) * (_loc6_.width + 1);
            _loc6_.y = this._mc["_loc_orgs"].y;
            this._mc.addChild(_loc6_);
            _loc4_++;
         }
         this.setBtLayer();
      }
      
      private function show() : void
      {
         this.setInfo(this._ae);
         this.setOrgs(this._ae);
         this._mc.visible = true;
      }
   }
}

