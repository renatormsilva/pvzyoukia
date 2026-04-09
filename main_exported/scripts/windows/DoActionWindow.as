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
   
   public class DoActionWindow extends BaseWindow
   {
      
      private static var _callblack:Function;
      
      private var _window:MovieClip;
      
      private var _num:int = 1;
      
      private var toolNum:int;
      
      private var _arr:Array = [];
      
      private var _changeType:Boolean;
      
      private var _shopNum:Number;
      
      public function DoActionWindow()
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
            if(_callblack != null)
            {
               DoActionWindow._callblack(this._num);
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
         _callblack = null;
         onHiddenEffect(this._window);
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
         this._window["text1"].text = this._arr[0] + this._arr[1] * this._num + this._arr[2] + this._arr[3] * this._num + this._arr[4];
      }
      
      public function init(param1:int, param2:int, param3:int, param4:String, param5:String, param6:Function, param7:Boolean, param8:Boolean = false, param9:int = 1) : void
      {
         this.toolNum = param2;
         this.onUpDownBtn(param8);
         if(param3 == Icon.TOOL)
         {
            Icon.setUrlIcon(this._window["pic"],param1,Icon.TOOL_1);
         }
         else if(param3 == Icon.ORGANISM)
         {
            Icon.setUrlIcon(this._window["pic"],param1,Icon.ORGANISM_1);
         }
         else if(param3 == Icon.SYSTEM)
         {
            Icon.setUrlIcon(this._window["pic"],param1,Icon.SYSTEM_1);
         }
         this._window["text0"].visible = false;
         if(param5.indexOf(",") < 0)
         {
            this._window["text1"].text = param5;
         }
         else
         {
            this._shopNum = param9;
            this._arr = param5.split(",");
            this._window["text1"].text = this._arr[0] + this._arr[1] + this._arr[2] + this._arr[3] + this._arr[4];
            this._changeType = true;
         }
         _callblack = param6;
         if(!param7)
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
      
      private function onUpDownBtn(param1:Boolean = true) : void
      {
         this._window["up_down_mc"].visible = param1;
         if(param1 == true)
         {
            this._window["up_down_mc"]["num_text"].text = this._num;
            this._window["up_down_mc"]["up_btn"].addEventListener(MouseEvent.CLICK,this.onUpBtn);
            this._window["up_down_mc"]["down_btn"].addEventListener(MouseEvent.CLICK,this.onDownBtn);
            this._window["up_down_mc"]["num_text"].addEventListener(KeyboardEvent.KEY_UP,this.setNum);
            this._window["up_down_mc"]["num_text"].addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
         }
      }
      
      private function onUpBtn(param1:MouseEvent) : void
      {
         ++this._num;
         if(this._changeType == false)
         {
            if(this._num >= this.toolNum)
            {
               this._num = this.toolNum;
            }
         }
         else
         {
            if(this._num >= this._shopNum)
            {
               this._num = this._shopNum;
            }
            this.showInfo();
         }
         this.onUpDownBtn();
      }
      
      private function onDownBtn(param1:MouseEvent) : void
      {
         --this._num;
         if(this._num <= 0)
         {
            this._num = 1;
         }
         if(this._changeType == true)
         {
            this.showInfo();
         }
         this.onUpDownBtn();
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
         if(isNaN(this._shopNum))
         {
            if(this._num >= this.toolNum)
            {
               this._num = this.toolNum;
            }
         }
         else
         {
            if(this._num >= this._shopNum)
            {
               this._num = this._shopNum;
            }
            this.showInfo();
         }
         this._window["up_down_mc"]["num_text"].text = this._num;
      }
   }
}

