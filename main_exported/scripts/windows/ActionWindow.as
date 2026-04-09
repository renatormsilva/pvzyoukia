package windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import zlib.utils.DomainAccess;
   
   public class ActionWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      private var _callblack:Function;
      
      public function ActionWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("actionWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(this._callblack != null)
            {
               this._callblack();
            }
            this.hidden();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.hidden();
         }
      }
      
      private function hidden() : void
      {
         this._callblack = null;
         onHiddenEffect(this._window);
      }
      
      private function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
      }
      
      public function init(param1:int, param2:int, param3:String, param4:String, param5:Function, param6:Boolean) : void
      {
         this._window["up_down_mc"].visible = false;
         if(param2 == Icon.SYSTEM)
         {
            Icon.setUrlIcon(this._window["pic"],param1,Icon.SYSTEM_1);
         }
         else if(param2 == Icon.TOOL)
         {
            Icon.setUrlIcon(this._window["pic"],param1,Icon.TOOL_1);
         }
         else if(param2 == Icon.ORGANISM)
         {
            Icon.setUrlIcon(this._window["pic"],param1,Icon.ORGANISM_1);
         }
         this._window["text0"].htmlText = param3;
         this._window["text1"].htmlText = param4;
         this._callblack = param5;
         if(!param6)
         {
            this._window["ok"].x = (this._window.width - this._window["ok"].width) / 4;
            this._window["cancel"].visible = false;
         }
         else
         {
            this._window["cancel"].visible = true;
            this._window["ok"].x = (this._window.width - this._window["ok"].width) / 4 - 80;
         }
         this.show();
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}

