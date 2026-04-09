package pvz.genius.jewelSystem.componets
{
   import entity.Tool;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.genius.jewelSystem.BasePanel;
   import pvz.genius.jewelSystem.JewelComposeWindow;
   import pvz.genius.jewelSystem.event.SelectJewelEvent;
   
   public class JewelStorageLabel extends BasePanel
   {
      
      private var _id:int;
      
      private var _jewel:Tool;
      
      public function JewelStorageLabel()
      {
         super("JewelSystem.storageLabel");
         _ui.mouseChildren = false;
         _ui.mouseEnabled = true;
         _ui.buttonMode = true;
         this.setMaskVisible(false);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         _ui.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         _ui.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:SelectJewelEvent = new SelectJewelEvent(true);
         _loc2_._jewelId = this._jewel.getOrderId();
         this.dispatchEvent(_loc2_);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         _ui._bg.gotoAndStop(2);
         JewelComposeWindow.jewelTips.setInfo(this._jewel);
         JewelComposeWindow.jewelTips.visible = true;
         JewelComposeWindow.jewelTips.Layout(this.x,this.y);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         _ui._bg.gotoAndStop(1);
         JewelComposeWindow.jewelTips.visible = false;
      }
      
      public function setInfo(param1:Tool, param2:int) : void
      {
         this._jewel = param1;
         this._id = param2;
         Icon.setUrlIcon(_ui["pic"],this._jewel.getPicId(),Icon.TOOL_1);
         _ui["_txt1"].text = this._jewel.getName();
         _ui["_txt2"].text = this._jewel.getNum() + LangManager.getInstance().getLanguage("vip001");
      }
      
      public function setMaskVisible(param1:Boolean) : void
      {
         _ui._mask.visible = param1;
      }
      
      override public function destroy() : void
      {
         _ui.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         _ui.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
   }
}

