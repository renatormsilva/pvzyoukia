package windows
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import labels.BackPanel;
   import manager.ToolManager;
   import zlib.utils.DomainAccess;
   
   public class ChallengePropWindow extends BaseWindow
   {
      
      public static const TOOL:int = 2;
      
      public static const TYPE_ONE:int = 0;
      
      public static const TYPE_TWO:int = 1;
      
      public static const TYPE_VIP:int = 2;
      
      public static const TYPE_GARDEN:int = 3;
      
      private var _challengePropWindow:MovieClip;
      
      private var str:String;
      
      public function ChallengePropWindow(param1:int, param2:Function = null, param3:Boolean = false)
      {
         super();
         var _loc4_:Class = DomainAccess.getClass("ChallengePropWindow");
         this._challengePropWindow = new _loc4_();
         this._challengePropWindow.visible = false;
         PlantsVsZombies._node.addChild(this._challengePropWindow);
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._challengePropWindow.visible = true;
         this.show();
         this.update(param1,param2);
         if(param3)
         {
            this._challengePropWindow["vip_mc"].visible = true;
            this._challengePropWindow["challege_mc"].visible = false;
         }
         else
         {
            this._challengePropWindow["vip_mc"].visible = false;
            this._challengePropWindow["challege_mc"].visible = true;
         }
      }
      
      private function show() : void
      {
         this.setLocation();
      }
      
      private function update(param1:int, param2:Function) : void
      {
         var _loc3_:Tool = null;
         var _loc4_:BackPanel = null;
         var _loc5_:Tool = null;
         var _loc6_:BackPanel = null;
         var _loc7_:Tool = null;
         var _loc8_:BackPanel = null;
         var _loc9_:Tool = null;
         var _loc10_:BackPanel = null;
         var _loc11_:Tool = null;
         var _loc12_:BackPanel = null;
         var _loc13_:Tool = null;
         var _loc14_:BackPanel = null;
         if(param1 == TYPE_ONE)
         {
            _loc3_ = new Tool(ToolManager.CHALL_BOOK_ONE);
            _loc4_ = new BackPanel();
            this.str = "挑战书";
            _loc4_.init(_loc3_,this.str,ToolManager.CHALL_BOOK_ONE,this.destroy);
            this._challengePropWindow.addChildAt(_loc4_,this._challengePropWindow.numChildren - 1);
            _loc4_.x = -90;
            _loc4_.y = -30;
            _loc5_ = new Tool(ToolManager.CHALL_BOOK_FIVE);
            _loc6_ = new BackPanel();
            this.str = "高级挑战书";
            _loc6_.init(_loc5_,this.str,ToolManager.CHALL_BOOK_FIVE,this.destroy);
            this._challengePropWindow.addChildAt(_loc6_,this._challengePropWindow.numChildren - 1);
            _loc6_.x = 10;
            _loc6_.y = -30;
         }
         else if(param1 == TYPE_TWO)
         {
            _loc7_ = new Tool(ToolManager.ARENA_BOOK);
            _loc8_ = new BackPanel(param2);
            this.str = "斗技场战书";
            _loc8_.init(_loc7_,this.str,ToolManager.ARENA_BOOK,this.destroy);
            this._challengePropWindow.addChildAt(_loc8_,this._challengePropWindow.numChildren - 1);
            _loc8_.x = -40;
            _loc8_.y = -30;
         }
         else if(param1 == TYPE_VIP)
         {
            _loc9_ = new Tool(ToolManager.TOOL_VIP_MONTH);
            _loc10_ = new BackPanel(param2);
            this.str = "VIP月卡";
            _loc10_.init(_loc9_,this.str,ToolManager.TOOL_VIP_MONTH,this.destroy,true);
            this._challengePropWindow.addChildAt(_loc10_,this._challengePropWindow.numChildren - 1);
            _loc10_.x = -90;
            _loc10_.y = -30;
            _loc11_ = new Tool(ToolManager.TOOL_VIP_SEASON);
            _loc12_ = new BackPanel(param2);
            this.str = "VIP季卡";
            _loc12_.init(_loc11_,this.str,ToolManager.TOOL_VIP_SEASON,this.destroy,true);
            this._challengePropWindow.addChildAt(_loc12_,this._challengePropWindow.numChildren - 1);
            _loc12_.x = 10;
            _loc12_.y = -30;
         }
         else if(param1 == TYPE_GARDEN)
         {
            _loc13_ = new Tool(ToolManager.GARDEN_BOOK);
            _loc14_ = new BackPanel(param2);
            this.str = "花园挑战书";
            _loc14_.init(_loc13_,this.str,ToolManager.GARDEN_BOOK,this.destroy);
            this._challengePropWindow.addChildAt(_loc14_,this._challengePropWindow.numChildren - 1);
            _loc14_.x = -40;
            _loc14_.y = -30;
         }
         this._challengePropWindow["close_btn"].addEventListener(MouseEvent.CLICK,this.onCloseClick);
      }
      
      private function setLocation() : void
      {
         this._challengePropWindow.visible = true;
         this._challengePropWindow.x = 380 + 17;
         this._challengePropWindow.y = 265 + 13;
         PlantsVsZombies._node.setChildIndex(this._challengePropWindow,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         this.destroy();
      }
      
      override public function destroy() : void
      {
         onHiddenEffect(this._challengePropWindow);
         PlantsVsZombies._node.removeChild(this._challengePropWindow);
      }
   }
}

