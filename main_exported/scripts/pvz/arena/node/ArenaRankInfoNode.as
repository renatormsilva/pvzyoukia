package pvz.arena.node
{
   import entity.Player;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class ArenaRankInfoNode extends Sprite
   {
      
      private var _backFun:Function = null;
      
      private var isSelected:Boolean = false;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _mc:MovieClip = null;
      
      public function ArenaRankInfoNode(param1:Player, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("arena_rank_info_node");
         this._mc = new _loc3_();
         this._mc.gotoAndStop(1);
         this._backFun = param2;
         this.setInfo(param1);
         this.addEvent();
         addChild(this._mc);
      }
      
      private function addEvent() : void
      {
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._mc.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._backFun != null)
         {
            this._backFun();
         }
         this.setSelected(true);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.isSelected = param1;
         if(param1)
         {
            this._mc.gotoAndStop(2);
         }
         else
         {
            this._mc.gotoAndStop(1);
         }
      }
      
      private function setInfo(param1:Player) : void
      {
         var _loc2_:DisplayObject = FuncKit.getNumEffect(param1.getArenaRank() + "","Small");
         _loc2_.x = -_loc2_.width / 2;
         this._mc["_pic_rank"].addChild(_loc2_);
         var _loc3_:DisplayObject = FuncKit.getNumEffect(param1.getGrade() + "");
         _loc3_.x = -_loc3_.width / 2;
         this._mc["_pic_lv"].addChild(_loc3_);
         if(param1 == this.playerManager.getPlayer())
         {
            PlantsVsZombies.setHeadPic(this._mc["_pic_head"],PlantsVsZombies.getHeadPicUrl(param1.getFaceUrl2()),PlantsVsZombies.HEADPIC_SMALL,param1.getVipTime(),param1.getVipLevel());
         }
         else
         {
            PlantsVsZombies.setHeadPic(this._mc["_pic_head"],PlantsVsZombies.getHeadPicUrl(param1.getFaceUrl2()),PlantsVsZombies.HEADPIC_SMALL,param1.getVipTime(),param1.getVipLevel());
         }
         this._mc["_txt_name"].text = param1.getNickname();
      }
      
      public function clear() : void
      {
         this.removeEvent();
      }
   }
}

