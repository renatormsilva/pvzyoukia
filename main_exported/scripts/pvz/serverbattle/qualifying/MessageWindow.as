package pvz.serverbattle.qualifying
{
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.serverbattle.entity.Message;
   import pvz.serverbattle.fport.MessageFPort;
   import zlib.utils.DomainAccess;
   
   public class MessageWindow extends BaseWindow
   {
      
      private static const PAGESNUM:int = 5;
      
      private var _window:MovieClip;
      
      private var _fport:MessageFPort;
      
      private var _allTxt:Array;
      
      private var _allMesInfos:Array;
      
      private var _nowpage:int;
      
      private var _maxpage:int;
      
      public function MessageWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("_mc_server_messageWindow");
         this._window = new _loc1_();
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this._window.visible = false;
         this._fport = new MessageFPort(this);
         this.setLoction();
         this.addEvent();
         this.initUI();
         this.initdata();
      }
      
      private function initUI() : void
      {
         var _loc1_:MessageInfo = null;
         this._allTxt = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < PAGESNUM)
         {
            _loc1_ = new MessageInfo();
            this._window["_node"].addChild(_loc1_);
            this._allTxt.push(_loc1_);
            _loc1_.y = 30 * _loc2_;
            _loc2_++;
         }
      }
      
      private function hideAllTxt() : void
      {
         var _loc1_:MessageInfo = null;
         for each(_loc1_ in this._allTxt)
         {
            _loc1_.visible = false;
         }
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      public function showMessage(param1:Array) : void
      {
         this._allMesInfos = param1;
         PlantsVsZombies.showDataLoading(false);
         this._maxpage = this._allMesInfos.length % PAGESNUM > 0 ? int(this._allMesInfos.length / PAGESNUM + 1) : int(this._allMesInfos.length / PAGESNUM);
         this._maxpage = this._maxpage > 0 ? this._maxpage : 1;
         this._nowpage = 1;
         this.showBattleInfo();
         this.show();
      }
      
      private function showBattleInfo() : void
      {
         this.showpagetxt();
         this.hideAllTxt();
         var _loc1_:Array = this._allMesInfos.slice((this._nowpage - 1) * PAGESNUM,Math.min(this._nowpage * PAGESNUM,this._allMesInfos.length));
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._allTxt[_loc2_].visible = true;
            (this._allTxt[_loc2_] as MessageInfo).update(_loc1_[_loc2_] as Message);
            _loc2_++;
         }
      }
      
      private function showpagetxt() : void
      {
         this._window["_txt_page"].text = this._nowpage + "/" + this._maxpage;
      }
      
      private function initdata() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.requestSever(MessageFPort.INIT);
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window["_bt_close"].removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffect(_window,destory);
         };
         this._window["_bt_close"].addEventListener(MouseEvent.MOUSE_UP,onClose);
         this._window["_bt_last"].addEventListener(MouseEvent.CLICK,this.tolastPage);
         this._window["_bt_next"].addEventListener(MouseEvent.CLICK,this.toNextPage);
      }
      
      private function tolastPage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._nowpage <= 1)
         {
            return;
         }
         --this._nowpage;
         this.showBattleInfo();
      }
      
      private function toNextPage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._nowpage >= this._maxpage)
         {
            return;
         }
         ++this._nowpage;
         this.showBattleInfo();
      }
      
      private function destory() : void
      {
         this._window["_bt_last"].removeEventListener(MouseEvent.CLICK,this.tolastPage);
         this._window["_bt_next"].removeEventListener(MouseEvent.CLICK,this.toNextPage);
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

