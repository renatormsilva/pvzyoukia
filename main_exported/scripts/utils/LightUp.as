package utils
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class LightUp
   {
      
      private var _color:uint;
      
      private var _toggle:Boolean;
      
      private var _blur:Number;
      
      private var _target:DisplayObject;
      
      public function LightUp(param1:DisplayObject, param2:uint = 16777215, param3:Number = 2)
      {
         super();
         this._target = param1;
         this._color = param2;
         this._toggle = true;
         this._blur = param3;
         this._target.addEventListener(Event.ENTER_FRAME,this.blinkHandler);
      }
      
      private function blinkHandler(param1:Event) : void
      {
         if(this._blur >= 8)
         {
            this._toggle = false;
         }
         else if(this._blur <= 2)
         {
            this._toggle = true;
         }
         if(this._toggle)
         {
            ++this._blur;
         }
         else
         {
            --this._blur;
         }
         var _loc2_:GlowFilter = new GlowFilter(this._color,1,this._blur,this._blur,5,2);
         this._target.filters = [_loc2_];
      }
      
      public function closeLightUp() : void
      {
         this._target.removeEventListener(Event.ENTER_FRAME,this.blinkHandler);
         this._target.filters = null;
      }
   }
}

