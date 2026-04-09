package pvz.registration.view.panel.module
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Component extends Sprite
   {
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _willDraw:Boolean;
      
      protected var _validateType:Array;
      
      public function Component(param1:Number, param2:Number)
      {
         super();
         this._width = param1;
         this._height = param2;
         this._validateType = [];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddtoStage,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage,false,0,true);
      }
      
      public function dispose() : void
      {
      }
      
      public function removeFromParent(param1:Boolean = true) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(param1)
         {
            this.dispose();
         }
      }
      
      protected function validate(param1:String = "all") : void
      {
         if(param1 != "" && this._validateType.indexOf(param1) < 0)
         {
            this._validateType.push(param1);
         }
         if(this._willDraw)
         {
            return;
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._willDraw = true;
      }
      
      protected function draw() : void
      {
      }
      
      protected function hasValidateType(param1:String) : Boolean
      {
         return this._validateType.indexOf("all") > -1 || this._validateType.indexOf(param1) > -1;
      }
      
      protected function onAddtoStage(param1:Event) : void
      {
      }
      
      protected function onRemoveFromStage(param1:Event) : void
      {
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._willDraw = false;
         this.draw();
         this._validateType.length = 0;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this._width = param1;
         this.validate();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         this._height = param1;
         this.validate();
      }
   }
}

