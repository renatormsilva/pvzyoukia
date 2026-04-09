package node
{
   import entity.Player;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import windows.FriendsWindow;
   import zlib.utils.DomainAccess;
   
   public class FriendNode extends Sprite
   {
      
      internal var _mc:MovieClip;
      
      internal var isSelected:Boolean = false;
      
      internal var p_other:Player;
      
      internal var backFun:Function;
      
      public function FriendNode(param1:Player, param2:Function)
      {
         super();
         this.backFun = param2;
         this.p_other = param1;
         this.mouseEnabled = true;
         var _loc3_:Class = DomainAccess.getClass("friendNode");
         this._mc = new _loc3_();
         this.addEvent();
         this._mc["_name"].text = param1.getNickname();
         this._mc["_gardenOrg"].visible = false;
      }
      
      public function addHeadPic() : void
      {
         if(this._mc["_pic"].numChildren > 0)
         {
            return;
         }
         PlantsVsZombies.setHeadPic(this._mc["_pic"],PlantsVsZombies.getHeadPicUrl(this.p_other.getFaceUrl2()),27,this.p_other.getVipTime(),this.p_other.getVipLevel());
      }
      
      public function changeType(param1:int) : void
      {
         this._mc["_gardenOrg"].visible = false;
         if(param1 == FriendsWindow.GARDEN)
         {
            if(this.p_other.getIsGardenOrg() == 1)
            {
               this._mc["_gardenOrg"].visible = true;
            }
         }
         this.addChild(this._mc);
         this._mc.gotoAndStop(1);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      private function addEvent() : void
      {
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc.addEventListener(MouseEvent.MOUSE_MOVE,this.onOver);
         this._mc.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         this._mc.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.onOver);
         this._mc.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.isSelected)
         {
            return;
         }
         this._mc.gotoAndStop(2);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this.isSelected)
         {
            return;
         }
         this._mc.gotoAndStop(1);
      }
      
      public function clearSelected() : void
      {
         this.isSelected = false;
         this._mc.gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.p_other == null || this.isSelected)
         {
            return;
         }
         this._mc.gotoAndStop(3);
         this.backFun(this.p_other);
         this.isSelected = true;
      }
      
      public function getPlayer() : Player
      {
         return this.p_other;
      }
   }
}

