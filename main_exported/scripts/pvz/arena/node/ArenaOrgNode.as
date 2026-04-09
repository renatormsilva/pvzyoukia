package pvz.arena.node
{
   import com.res.IDestroy;
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import node.Icon;
   import tip.ArenaOrgTip;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class ArenaOrgNode extends Sprite implements IDestroy
   {
      
      internal var _tips:ArenaOrgTip = null;
      
      internal var _org:Organism = null;
      
      public function ArenaOrgNode(param1:Organism)
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         super();
         if(param1 != null)
         {
            _loc2_ = DomainAccess.getClass("pic_label");
            _loc3_ = new _loc2_();
            Icon.setUrlIcon(_loc3_,param1.getPicId(),Icon.ORGANISM_1);
            this.addChild(_loc3_);
            this.setQuality(param1.getQuality_name(),_loc3_);
            this._org = param1;
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         }
         else
         {
            _loc4_ = DomainAccess.getClass("lockLabel");
            _loc5_ = new _loc4_();
            addChild(_loc5_);
         }
      }
      
      public function destroy() : void
      {
         if(this._tips != null)
         {
            this._tips.destroy();
         }
         if(this._org != null)
         {
            this.removeEventListener(MouseEvent.CLICK,this.onOver);
         }
         FuncKit.clearAllChildrens(this);
      }
      
      private function setQuality(param1:String, param2:MovieClip) : void
      {
         var _loc3_:Class = DomainAccess.getClass("_quality_small");
         var _loc4_:MovieClip = new _loc3_();
         _loc4_.gotoAndStop(XmlQualityConfig.getInstance().getID(param1));
         this.addChild(_loc4_);
         _loc4_.y = param2.height - _loc4_.height;
      }
      
      private function onOver(param1:Event) : void
      {
         if(this._org == null)
         {
            return;
         }
         if(this._tips == null)
         {
            this._tips = new ArenaOrgTip();
         }
         this._tips.setTooltipText(param1.target as MovieClip,this._org.getName(),this._org.getUse_condition(),this._org.getBattleE() + "",this._org);
         this._tips.setLoction(this.x + 115,this.y + 15);
      }
   }
}

