package labels
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.Goods;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import pvz.compose.panel.ComposeWindowNew;
   import tip.OrgTip;
   import tip.ToolsTip;
   import utils.FuncKit;
   import xmlReader.config.XmlToolsConfig;
   
   public class TaskToolLabel extends Sprite
   {
      
      internal var _o:Object;
      
      internal var tips:ToolsTip;
      
      internal var orgtips:OrgTip;
      
      internal var windowType:int = 0;
      
      internal var _backFunction:Function;
      
      public function TaskToolLabel(param1:Object, param2:Function, param3:Boolean, param4:int, param5:Boolean = false)
      {
         super();
         this._backFunction = param2;
         this.windowType = param4;
         this.updateO(param1,param5);
         this.buttonMode = param3;
         this.addClickEvent();
         if(param1 is Tool)
         {
            this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
      }
      
      public function updateO(param1:Object, param2:Boolean) : void
      {
         var addNum:Function;
         var addExpNum:Function;
         var addExpNum1:Function;
         var sp:Sprite = null;
         var nod:Sprite = null;
         var nod1:Sprite = null;
         var o:Object = param1;
         var shownum:Boolean = param2;
         this._o = o;
         if(o is Organism)
         {
            Icon.setUrlIcon(this,o.getPicId(),Icon.ORGANISM_1);
         }
         else if(o is Tool)
         {
            addNum = function():void
            {
               var _loc1_:DisplayObject = FuncKit.getNumEffect((o as Tool).getNum() + "");
               _loc1_.x = 62 - _loc1_.width;
               _loc1_.y = 69 - _loc1_.height;
               sp.addChild(_loc1_);
            };
            sp = this;
            if(!shownum)
            {
               Icon.setUrlIcon(this,o.getPicId(),Icon.TOOL_1,1,addNum);
            }
            else
            {
               Icon.setUrlIcon(this,o.getPicId(),Icon.TOOL_1,1,null);
            }
         }
         else if(o is Goods)
         {
            Icon.setUrlIcon(this,XmlToolsConfig.getInstance().getToolAttribute(o.getId()).getPicId(),Icon.TOOL_1);
         }
         else if(o is Exp)
         {
            addExpNum = function():void
            {
               var _loc1_:DisplayObject = FuncKit.getNumEffect((o as Exp).getExpValue() + "");
               _loc1_.x = 62 - _loc1_.width;
               _loc1_.y = 69 - _loc1_.height;
               nod.addChild(_loc1_);
            };
            nod = this;
            Icon.setUrlIcon(this,(o as Exp).getPicId(),Icon.SYSTEM_1,1,addExpNum);
         }
         else if(o is GameMoney)
         {
            addExpNum1 = function():void
            {
               var _loc1_:DisplayObject = FuncKit.getMoneyArtDisplay((o as GameMoney).getMoneyValue());
               _loc1_.x = 62 - _loc1_.width;
               _loc1_.y = 69 - _loc1_.height;
               nod1.addChild(_loc1_);
            };
            nod1 = this;
            Icon.setUrlIcon(this,(o as GameMoney).getPicId(),Icon.SYSTEM_1,1,addExpNum1);
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
         return this.parent.x + this.width + 95;
      }
      
      public function getPositionY() : int
      {
         return this.parent.y + 55;
      }
   }
}

