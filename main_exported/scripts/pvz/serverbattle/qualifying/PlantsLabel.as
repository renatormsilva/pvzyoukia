package pvz.serverbattle.qualifying
{
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import node.Icon;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import xmlReader.config.XmlQualityConfig;
   
   public class PlantsLabel extends Sprite
   {
      
      public var _o:Organism;
      
      public function PlantsLabel(param1:Organism)
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         super();
         this._o = param1;
         if(param1 != null)
         {
            _loc2_ = GetDomainRes.getMoveClip("pic_label");
            this.addChild(_loc2_);
            this.setQuality(param1.getQuality_name(),_loc2_);
            Icon.setUrlIcon(_loc2_["pic"],param1.getPicId(),Icon.ORGANISM_1);
         }
         else
         {
            _loc3_ = GetDomainRes.getMoveClip("serverbattle.qualitying.emptylabel");
            addChild(_loc3_);
         }
      }
      
      private function setQuality(param1:String, param2:Sprite) : void
      {
         var _loc3_:MovieClip = GetDomainRes.getMoveClip("_quality_small");
         _loc3_.gotoAndStop(XmlQualityConfig.getInstance().getID(param1));
         this.addChild(_loc3_);
         _loc3_.y = param2.height - _loc3_.height;
      }
      
      public function dispose() : void
      {
         FuncKit.clearAllChildrens(this);
         this.parent.removeChild(this);
      }
   }
}

