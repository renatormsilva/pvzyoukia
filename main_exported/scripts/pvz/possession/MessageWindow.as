package pvz.possession
{
   import core.ui.panel.BaseWindow;
   import entity.Player;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.SoundManager;
   import pvz.possession.fport.MessageWindowFPort;
   import zlib.utils.DomainAccess;
   
   public class MessageWindow extends BaseWindow
   {
      
      private static const MAX:int = 5;
      
      private var page_max:int = 5;
      
      private var _backFun:Function = null;
      
      private var _fport:MessageWindowFPort = null;
      
      private var _infos:Array = null;
      
      private var _nowPage:int = 1;
      
      private var _window:MovieClip = null;
      
      public function MessageWindow(param1:Function)
      {
         super();
         this._backFun = param1;
         this._fport = new MessageWindowFPort(this);
         this.init();
      }
      
      public function portShow(param1:Array) : void
      {
         this._infos = param1;
         this._window.visible = true;
         this.setLoction();
         if(this._infos == null || this._infos.length < MAX + 1)
         {
            this.page_max = 1;
         }
         else
         {
            this.page_max = (param1.length - 1) / MAX + 1;
         }
         this.showPage();
      }
      
      private function addEvent() : void
      {
         this._window["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_last"].addEventListener(MouseEvent.CLICK,this.onPageClick);
         this._window["_bt_next"].addEventListener(MouseEvent.CLICK,this.onPageClick);
      }
      
      private function clearInfo() : void
      {
         var _loc1_:* = int(this._window.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._window.getChildAt(_loc1_) is MessageInfo)
            {
               this._window.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function getInfoLoction(param1:int) : Point
      {
         return new Point(40,46 + 30 * param1);
      }
      
      private function hidden() : void
      {
         this._window.visible = false;
         removeBG();
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function infoBackFun(param1:Number) : void
      {
         var _loc2_:Player = null;
         this.hidden();
         if(this._backFun != null)
         {
            _loc2_ = new Player();
            _loc2_.setId(param1);
            this._backFun(_loc2_,false);
         }
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_mc_possession_messageWindow");
         this._window = new _loc1_();
         this.addEvent();
         this._window.visible = false;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._fport.toMessageInfo();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_close")
         {
            this.hidden();
         }
      }
      
      private function onPageClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_last")
         {
            if(this._nowPage <= 1)
            {
               return;
            }
            --this._nowPage;
            this.showPage();
         }
         else if(param1.currentTarget.name == "_bt_next")
         {
            if(this._nowPage >= this.page_max)
            {
               this._nowPage = this.page_max;
            }
            else
            {
               ++this._nowPage;
            }
            this.showPage();
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      private function setPage() : void
      {
         this._window["_txt_page"].text = this._nowPage + "/" + this.page_max;
      }
      
      private function showPage() : void
      {
         this.setPage();
         this.clearInfo();
         if(this._infos == null || this._infos.length < 1)
         {
            return;
         }
         var _loc1_:Array = this._infos.slice(MAX * (this._nowPage - 1),MAX * this._nowPage);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._window.addChild(new MessageInfo(_loc1_[_loc2_],this.infoBackFun,this.getInfoLoction(_loc2_)));
            _loc2_++;
         }
      }
   }
}

