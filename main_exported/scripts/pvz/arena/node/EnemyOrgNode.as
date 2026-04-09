package pvz.arena.node
{
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import node.Icon;
   import tip.ArenaOrgTip;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class EnemyOrgNode extends Sprite
   {
      
      internal var _org:Organism = null;
      
      internal var _tips:ArenaOrgTip = null;
      
      internal var _mc:MovieClip = null;
      
      public function EnemyOrgNode(param1:Organism)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("challenge_orgs_node");
         this._mc = new _loc2_();
         this._mc.gotoAndStop(1);
         this._mc.visible = false;
         addChild(this._mc);
         this.show(param1);
         this._org = param1;
         this._mc.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._org == null)
         {
            return;
         }
         if(this._tips == null)
         {
            this._tips = new ArenaOrgTip();
         }
         this._tips.setTooltipText(this._mc,this._org.getName(),this._org.getUse_condition(),this._org.getBattleE() + "",this._org);
         this._tips.setLoction(this.parent.x + this.x - 10,this.parent.parent.y + this.parent.y - 50);
      }
      
      public function clear() : void
      {
         FuncKit.clearAllChildrens(this._mc["_pic_org"]);
         FuncKit.clearAllChildrens(this._mc["_pic_lv"]);
         FuncKit.clearAllChildrens(this._mc["_pic_quality"]);
      }
      
      private function setLv(param1:int) : void
      {
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + param1));
         _loc3_.x = -_loc3_.width / 2;
         this._mc["_pic_lv"].addChild(_loc3_);
      }
      
      private function setOrg(param1:Organism) : void
      {
         this.setLv(param1.getGrade());
         this.setQuality(param1.getQuality_name());
         this.setPic(param1.getPicId());
      }
      
      private function setPic(param1:int) : void
      {
         Icon.setUrlIcon(this._mc["_pic_org"],param1,Icon.ORGANISM_1);
      }
      
      private function getIcon(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("icon_org_" + param1);
         return new _loc2_();
      }
      
      private function setQuality(param1:String) : void
      {
         var _loc2_:Class = DomainAccess.getClass("_quality_small");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_.gotoAndStop(XmlQualityConfig.getInstance().getID(param1));
         this._mc["_pic_quality"].addChild(_loc3_);
      }
      
      private function show(param1:Organism) : void
      {
         this._mc.visible = true;
         if(param1 == null)
         {
            this._mc.gotoAndStop(2);
            return;
         }
         this.setOrg(param1);
      }
   }
}

