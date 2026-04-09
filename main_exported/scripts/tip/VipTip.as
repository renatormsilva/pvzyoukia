package tip
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class VipTip extends Tips
   {
      
      private static var BEGIN_X:int = 10;
      
      private var _temp_class:Class;
      
      private var _mc:MovieClip;
      
      private var nowwidth:int;
      
      private var nowheight:int = 0;
      
      private var _o:InteractiveObject;
      
      private var _obj:Object;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function VipTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("_mc_viptip");
         this._mc = new this._temp_class();
         this.visible = false;
         this.addChild(this._mc);
      }
      
      public function setTooltip(param1:InteractiveObject) : void
      {
         this._o = param1;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.init();
         this.setInfo();
      }
      
      private function init() : void
      {
         this._mc.gotoAndStop(1);
         this._mc["_mc_time_title"].visible = false;
         this._mc["_mc_time_title"].gotoAndStop(1);
         if(this._mc["_mc_time"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_mc_time"]);
         }
      }
      
      private function setInfo() : void
      {
         if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) == null)
         {
            return;
         }
         this.showTime();
      }
      
      private function showTime() : void
      {
         var _loc1_:int = int(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()).type);
         var _loc2_:int = int(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()).time);
         this._mc.gotoAndStop(2);
         this._mc["_mc_time_title"].visible = true;
         this._mc["_mc_time_title"].gotoAndStop(_loc1_);
         if(this._mc["_mc_time"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_mc_time"]);
         }
         var _loc3_:DisplayObject = FuncKit.getNumEffect(_loc2_ + "");
         _loc3_.x = -_loc3_.width / 2;
         this._mc["_mc_time"].addChild(_loc3_);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
   }
}

