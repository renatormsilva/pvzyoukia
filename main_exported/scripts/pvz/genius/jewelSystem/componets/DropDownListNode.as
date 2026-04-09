package pvz.genius.jewelSystem.componets
{
   import flash.events.MouseEvent;
   import pvz.genius.jewelSystem.BasePanel;
   import pvz.genius.jewelSystem.event.DropDownSelectEvent;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.TextFilter;
   
   public class DropDownListNode extends BasePanel
   {
      
      private var _type:int;
      
      public function DropDownListNode()
      {
         super("jewel.DrapDownListNode");
         _ui.mouseChildren = false;
         _ui.buttonMode = true;
         _ui._bg.visible = false;
         TextFilter.MiaoBian(_ui._txt,1118481);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         _ui.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         _ui.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         var _loc2_:DropDownSelectEvent = new DropDownSelectEvent(true);
         _loc2_._stype = this._type;
         this.dispatchEvent(_loc2_);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         _ui._bg.visible = false;
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         _ui._bg.visible = true;
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
         _ui._txt.text = GeniusSystemConst.GetLabelByType(param1);
      }
      
      public function setIsSelect(param1:Boolean) : void
      {
         if(param1)
         {
            _ui._circle.gotoAndStop(2);
         }
         else
         {
            _ui._circle.gotoAndStop(1);
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      override public function destroy() : void
      {
         _ui.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         _ui.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
   }
}

