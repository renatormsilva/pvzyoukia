package pvz.arena.window
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import zlib.utils.DomainAccess;
   
   public class ArenaNoticeWindow extends BaseWindow
   {
      
      internal var _log:Array = null;
      
      internal var _window:MovieClip = null;
      
      public function ArenaNoticeWindow(param1:Array)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("arena_notice_window");
         this._window = new _loc2_();
         this._window.visible = false;
         this.setLoction();
         this.addBtEvent();
         this._log = param1;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.show();
      }
      
      private function addBtEvent() : void
      {
         this._window["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeBtEvent() : void
      {
         this._window["_bt_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_close")
         {
            this.hidden();
         }
      }
      
      private function hidden() : void
      {
         this.clearInfo();
         this.removeBtEvent();
         onHiddenEffect(this._window);
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function show() : void
      {
         this.setInfo();
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function setInfo() : void
      {
         var _loc2_:int = 0;
         this.clearInfo();
         if(this._log == null || this._log.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._log.length)
         {
            _loc2_ = _loc1_ + 1;
            this._window["_txt_line" + _loc2_ + "_name1"].text = "" + this._log[_loc1_].a;
            this._window["_txt_line" + _loc2_ + "_str1"].text = "" + this._log[_loc1_].a_info;
            this._window["_txt_line" + _loc2_ + "_name2"].text = "" + this._log[_loc1_].b;
            this._window["_txt_line" + _loc2_ + "_str2"].text = "" + this._log[_loc1_].b_info;
            this._window["_txt_line" + _loc2_ + "_rank"].text = "" + this._log[_loc1_].rank;
            _loc1_++;
         }
      }
      
      private function clearInfo() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 6)
         {
            this._window["_txt_line" + _loc1_ + "_name1"].text = "";
            this._window["_txt_line" + _loc1_ + "_str1"].text = "";
            this._window["_txt_line" + _loc1_ + "_name2"].text = "";
            this._window["_txt_line" + _loc1_ + "_str2"].text = "";
            this._window["_txt_line" + _loc1_ + "_rank"].text = "";
            _loc1_++;
         }
      }
   }
}

