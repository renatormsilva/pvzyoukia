package labels
{
   import com.res.IDestroy;
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import tip.OrgTip;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class BattleLabel extends Sprite implements IDestroy
   {
      
      public var _mc:MovieClip;
      
      internal var _o:Organism;
      
      internal var inNull:Boolean = false;
      
      internal var _click:Function;
      
      private var pic:MovieClip;
      
      private var tips:OrgTip;
      
      public function BattleLabel(param1:MovieClip)
      {
         super();
         this._mc = param1;
         this._mc.gotoAndStop(1);
         this._mc.buttonMode = true;
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addSelectedEvent();
         this.addChild(this._mc);
         this.show(true);
      }
      
      private function addSelectedEvent() : void
      {
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function removeSelectedEvent() : void
      {
         this._mc.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.inNull)
         {
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.inNull = true;
         if(this._click != null)
         {
            this._click(this._o);
         }
      }
      
      public function destroy() : void
      {
         this.removeSelectedEvent();
         if(this.tips != null)
         {
            this.tips.destroy();
         }
      }
      
      private function getIcon(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("icon_org_" + param1);
         return new _loc2_();
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._mc.gotoAndStop(2);
         if(this.tips == null)
         {
            this.tips = new OrgTip();
         }
         this.tips.showTips();
         this.tips.setOrgtip(this._mc,this._o);
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._mc.gotoAndStop(1);
      }
      
      public function update(param1:Organism, param2:Function) : void
      {
         this._o = param1;
         this._click = param2;
         if(param1 == null)
         {
            return;
         }
         FuncKit.clearAllChildrens(this._mc["pic"]);
         Icon.setUrlIcon(this._mc["pic"],this._o.getPicId(),Icon.ORGANISM_1);
         this._mc.gotoAndStop(1);
         this.show(true);
      }
      
      private function show(param1:Boolean = false) : void
      {
         this._mc.visible = param1;
      }
      
      public function getPositionX() : int
      {
         return this._mc.parent.x + this._mc.parent.parent.parent.x + this.width + 20;
      }
      
      public function getPositionY() : int
      {
         return this._mc.parent.y + this._mc.parent.parent.parent.y + 22;
      }
      
      public function getOrg() : Organism
      {
         return this._o;
      }
   }
}

