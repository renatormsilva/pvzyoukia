package pvz.possession
{
   import core.ui.panel.BaseWindow;
   import entity.Player;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.possession.fport.RecommenWindowFPort;
   import zlib.utils.DomainAccess;
   
   public class RecommenWindow extends BaseWindow
   {
      
      private var _window:MovieClip = null;
      
      private var _backFun:Function = null;
      
      private var _fport:RecommenWindowFPort = null;
      
      public function RecommenWindow(param1:Function)
      {
         super();
         this._backFun = param1;
         this._fport = new RecommenWindowFPort(this);
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_mc_recommenWindow");
         if(_loc1_ == null)
         {
            throw new Error(LangManager.getInstance().getLanguage("possession027"));
         }
         this._window = new _loc1_();
         this._window.visible = false;
         this.addBtEvent();
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      private function addBtEvent() : void
      {
         this._window["_bt_cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_refresh"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_cancel")
         {
            this.hidden();
         }
         else if(param1.currentTarget.name == "_bt_refresh")
         {
            this.toRecommen();
         }
      }
      
      private function toRecommen() : void
      {
         this.clear();
         this._fport.toRecommen();
      }
      
      public function portShow(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this._window.addChild(new RecommenNode(param1[_loc2_],this.nodeBackFun,this.getNodeLoction(_loc2_)));
               _loc2_++;
            }
         }
         this._window.visible = true;
      }
      
      public function show() : void
      {
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.toRecommen();
      }
      
      private function getNodeLoction(param1:int) : Point
      {
         var _loc2_:Point = new Point();
         _loc2_.x = param1 * 80 + 55;
         _loc2_.y = 79;
         return _loc2_;
      }
      
      private function nodeBackFun(param1:Player) : void
      {
         this.hidden();
         this._backFun(param1);
      }
      
      private function hidden() : void
      {
         this.clear();
         this._window.visible = false;
         removeBG();
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function clear() : void
      {
         var _loc1_:* = int(this._window.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._window.getChildAt(_loc1_) is RecommenNode)
            {
               this._window.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
   }
}

