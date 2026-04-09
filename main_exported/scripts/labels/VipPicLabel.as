package labels
{
   import entity.Tool;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import node.Icon;
   import tip.OrgTip;
   import tip.ToolsTip;
   
   public class VipPicLabel extends Sprite
   {
      
      internal var _t:Tool;
      
      internal var tips:ToolsTip;
      
      internal var orgtips:OrgTip;
      
      internal var windowType:int = 0;
      
      public function VipPicLabel(param1:Tool)
      {
         super();
         this._t = param1;
         this.updateO(param1);
         this.buttonMode = true;
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
      }
      
      public function updateO(param1:Tool) : void
      {
         Icon.setUrlIcon(this,param1.getPicId(),Icon.TOOL_1);
      }
      
      private function clear() : void
      {
         this.removeEvent();
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new ToolsTip();
         }
         this.tips.setTooltip(this,this._t);
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      public function getTool() : Tool
      {
         return this._t;
      }
      
      public function getPositionX() : int
      {
         if(this.parent.x > 175)
         {
            return this.parent.x + 200;
         }
         return this.parent.x + this.width + 400;
      }
      
      public function getPositionY() : int
      {
         return this.parent.y + 220;
      }
   }
}

