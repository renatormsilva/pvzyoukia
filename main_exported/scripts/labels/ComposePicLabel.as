package labels
{
   import entity.Goods;
   import entity.Organism;
   import entity.Tool;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import pvz.compose.panel.ComposeWindowNew;
   import tip.OrgTip;
   import tip.ToolsTip;
   import xmlReader.config.XmlToolsConfig;
   
   public class ComposePicLabel extends Sprite
   {
      
      internal var _o:Object;
      
      internal var tips:ToolsTip;
      
      internal var orgtips:OrgTip;
      
      internal var windowType:int = 0;
      
      internal var _backFunction:Function;
      
      public function ComposePicLabel(param1:Object, param2:Function, param3:Boolean, param4:int)
      {
         super();
         this._backFunction = param2;
         this.windowType = param4;
         this.updateO(param1);
         this.buttonMode = param3;
         this.addClickEvent();
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
      }
      
      public function updateO(param1:Object) : void
      {
         this._o = param1;
         if(param1 is Organism)
         {
            Icon.setUrlIcon(this,param1.getPicId(),Icon.ORGANISM_1);
         }
         else if(param1 is Tool)
         {
            Icon.setUrlIcon(this,param1.getPicId(),Icon.TOOL_1);
         }
         else if(param1 is Goods)
         {
            Icon.setUrlIcon(this,XmlToolsConfig.getInstance().getToolAttribute(param1.getId()).getPicId(),Icon.TOOL_1);
         }
      }
      
      private function clear() : void
      {
         this.removeEvent();
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._o is Organism && this.windowType != ComposeWindowNew.TYPE_ORG_EVOLUTION)
         {
            if(this.orgtips == null)
            {
               this.orgtips = new OrgTip();
            }
            this.orgtips.setOrgtip(this,this._o as Organism);
            this.orgtips.setLoction(this.getPositionX(),this.getPositionY());
         }
         else
         {
            if(this.tips == null)
            {
               this.tips = new ToolsTip();
            }
            this.tips.setTooltip(this,this._o);
            this.tips.setLoction(this.getPositionX(),this.getPositionY());
         }
      }
      
      public function getO() : Object
      {
         return this._o;
      }
      
      private function addClickEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._backFunction != null)
         {
            this._backFunction(this._o);
         }
      }
      
      public function getPositionX() : int
      {
         if(this.parent.x + this.parent.parent.parent.x + this.width + 20 > 600)
         {
            return this.parent.x - 2 * this.width - 45;
         }
         return this.parent.x + this.width + 40;
      }
      
      public function getPositionY() : int
      {
         return this.parent.y + 30;
      }
   }
}

