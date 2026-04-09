package pvz.world
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.world.fport.OpenWindowFPort;
   import tip.ToolsTip;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class OpenWindow extends BaseWindow implements IDestroy
   {
      
      private var _window:MovieClip = null;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _checkpoint:Checkpoint = null;
      
      private var _fport:OpenWindowFPort = null;
      
      private var _openBack:Function = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _tips:ToolsTip = null;
      
      public function OpenWindow(param1:DisplayObjectContainer, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("ui.world.openWindow");
         this._window = new _loc3_();
         this._root = param1;
         this._openBack = param2;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._window["_bt_close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._window["_bt_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_bt_cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function show(param1:Checkpoint) : void
      {
         this._fport = new OpenWindowFPort(this);
         this._checkpoint = param1;
         this.showTools(param1.getOpenTools());
         this.setLoction();
         super.showBG(PlantsVsZombies._node);
         this._root.addChild(this._window);
         onShowEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 - this._root.x;
         this._window.y = PlantsVsZombies.HEIGHT - this._window.width;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_close")
         {
            this.hidden();
         }
         else if(param1.currentTarget.name == "_bt_ok")
         {
            this.openCheckpoint();
         }
         else if(param1.currentTarget.name == "_bt_cancel")
         {
            this.hidden();
         }
      }
      
      private function openCheckpoint() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.toOpenWindow(this._checkpoint.getId());
      }
      
      public function portOpenCheckpoint(param1:Checkpoint) : void
      {
         this.updateCheckpoint(param1);
         this.expendTools();
         this.hidden();
         if(this._openBack != null)
         {
            this._openBack();
         }
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         PlantsVsZombies.playFireworks(4);
         PlantsVsZombies.showDataLoading(false);
      }
      
      public function updateCheckpoint(param1:Checkpoint) : void
      {
         this._checkpoint.setBattleTimes(param1.getBattleTimes());
         this._checkpoint.setMaxBattleTimes(param1.getMaxBattleTimes());
         this._checkpoint.setType(param1.getType());
         this._checkpoint.setMaxOrgNum(param1.getMaxOrgNum());
      }
      
      private function expendTools() : void
      {
         if(this._checkpoint.getOpenTools() == null || this._checkpoint.getOpenTools().length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._checkpoint.getOpenTools().length)
         {
            this.playerManager.getPlayer().useTools((this._checkpoint.getOpenTools()[_loc1_] as Tool).getOrderId(),(this._checkpoint.getOpenTools()[_loc1_] as Tool).getNum());
            _loc1_++;
         }
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window,this.destroy);
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         this.clearTools();
         this._tips = null;
         this._root.removeChild(this._window);
      }
      
      private function clearTools() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(this._window["_tool" + _loc1_].numChildren > 0)
            {
               this._window["_tool" + _loc1_].removeChildAt(0);
            }
            this._window["_toolnum" + _loc1_].text = "";
            _loc1_++;
         }
      }
      
      private function showTools(param1:Array) : void
      {
         this.clearTools();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            Icon.setUrlIcon(this._window["_tool" + (1 + _loc2_)],(param1[_loc2_] as Tool).getPicId(),Icon.TOOL_1);
            this._window["_tool" + (1 + _loc2_)].addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
            this._window["_toolnum" + (_loc2_ + 1)].text = "×" + (param1[_loc2_] as Tool).getNum();
            _loc2_++;
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:int = int((param1.target.parent.name as String).slice(5,6));
         var _loc3_:Tool = this._checkpoint.getOpenTools()[_loc2_ - 1];
         if(this._tips == null)
         {
            this._tips = new ToolsTip();
         }
         this._tips.setTooltip(param1.target as InteractiveObject,_loc3_);
         this._tips.setLoction(this.getPositionX(param1.target.parent.x),this.getPositionY());
      }
      
      public function getPositionX(param1:int) : int
      {
         return param1 + 235;
      }
      
      public function getPositionY() : int
      {
         return 140;
      }
   }
}

