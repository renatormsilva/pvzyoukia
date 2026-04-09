package core.ui.components
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   
   public class SelectButton
   {
      
      private var _mc:MovieClip;
      
      private var _isClick:Boolean;
      
      private var _clickCallback:Function;
      
      private var _overCallback:Function;
      
      private var _outCallback:Function;
      
      public function SelectButton(param1:DisplayObject, param2:Function, param3:Function = null, param4:Function = null)
      {
         super();
         this._mc = param1 as MovieClip;
         this._clickCallback = param2;
         this._overCallback = param4;
         this._outCallback = param3;
         this._mc.mouseEnabled = true;
         this._mc.mouseChildren = false;
         this._mc.buttonMode = true;
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.addEventListener(MouseEvent.MOUSE_UP,this.onClick);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this._isClick)
         {
            this._mc.gotoAndStop(3);
            return;
         }
         this._mc.gotoAndStop(1);
         if(this._outCallback != null)
         {
            this._outCallback(param1.currentTarget.name);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._isClick)
         {
            this._mc.gotoAndStop(4);
            return;
         }
         this._mc.gotoAndStop(2);
         if(this._overCallback != null)
         {
            this._overCallback(param1.currentTarget.name);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._isClick)
         {
            return;
         }
         this._mc.gotoAndStop(4);
         this._isClick = true;
         if(this._clickCallback != null)
         {
            this._clickCallback(param1.currentTarget.name);
         }
      }
      
      public function setIsClicked(param1:Boolean) : void
      {
         this._isClick = param1;
         if(param1)
         {
            this._mc.gotoAndStop(3);
         }
         else
         {
            this._mc.gotoAndStop(1);
         }
      }
      
      public function enable(param1:Boolean) : void
      {
         this._mc.mouseEnabled = param1;
      }
      
      public function destory() : void
      {
         this._mc.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.removeEventListener(MouseEvent.MOUSE_UP,this.onClick);
      }
      
      public function getBtnName() : String
      {
         return this._mc.name;
      }
   }
}

