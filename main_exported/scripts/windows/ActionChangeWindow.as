package windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import zlib.utils.DomainAccess;
   
   public class ActionChangeWindow extends BaseWindow
   {
      
      private var _callblack:Function = null;
      
      private var _max:int = 1;
      
      private var _num:int = 1;
      
      private var _window:MovieClip = null;
      
      private var _getInfo:Function = null;
      
      public function ActionChangeWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("actionWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this.addEvent();
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function init(param1:int, param2:int, param3:Function, param4:Function, param5:Boolean, param6:int = 1) : void
      {
         this._max = param6;
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
         this._window["text0"].visible = false;
         this._getInfo = param3;
         this._callblack = param4;
         if(!param5)
         {
            this._window["ok"].x = (this._window.width - this._window["ok"].width) / 4;
            this._window["cancel"].visible = false;
         }
         else
         {
            this._window["cancel"].visible = true;
            this._window["ok"].x = (this._window.width - this._window["ok"].width) / 4 - 80;
         }
         this._window["up_down_mc"]["num_text"].text = this._num;
         this.showInfo();
         this.show();
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function addEvent() : void
      {
         this._window["up_down_mc"]["up_btn"].addEventListener(MouseEvent.CLICK,this.onUpBtn);
         this._window["up_down_mc"]["down_btn"].addEventListener(MouseEvent.CLICK,this.onDownBtn);
         this._window["up_down_mc"]["num_text"].addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._window["up_down_mc"]["num_text"].addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function hidden() : void
      {
         this._callblack = null;
         onHiddenEffect(this._window);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(this._callblack != null)
            {
               this._callblack(this._num);
            }
            this.hidden();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.hidden();
         }
      }
      
      private function onDownBtn(param1:MouseEvent) : void
      {
         --this._num;
         if(this._num <= 0)
         {
            this._num = 1;
         }
         this.showInfo();
         this._window["up_down_mc"]["num_text"].text = this._num;
      }
      
      private function onUpBtn(param1:MouseEvent) : void
      {
         ++this._num;
         if(this._num >= this._max)
         {
            this._num = this._max;
         }
         this.showInfo();
         this._window["up_down_mc"]["num_text"].text = this._num;
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         if(this._window["up_down_mc"]["num_text"].text == "")
         {
            this._num = 1;
         }
         else
         {
            this._num = int(this._window["up_down_mc"]["num_text"].text);
         }
         if(this._num <= 1)
         {
            this._num = 1;
         }
         if(this._num >= this._max)
         {
            this._num = this._max;
         }
         this.showInfo();
         this._window["up_down_mc"]["num_text"].text = this._num;
      }
      
      private function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
      }
      
      private function showInfo() : void
      {
         if(this._getInfo != null)
         {
            this._window["text1"].text = this._getInfo(this._num);
            return;
         }
         throw new Error("getInfo is null");
      }
   }
}

