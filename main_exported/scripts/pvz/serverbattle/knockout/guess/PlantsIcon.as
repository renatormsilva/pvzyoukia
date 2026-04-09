package pvz.serverbattle.knockout.guess
{
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import node.Icon;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class PlantsIcon extends Sprite
   {
      
      public var _org:Organism = null;
      
      public function PlantsIcon(param1:Organism)
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         super();
         this.mouseChildren = false;
         if(param1 != null)
         {
            this._org = param1;
            _loc2_ = DomainAccess.getClass("pic_label");
            _loc3_ = new _loc2_();
            this.addChild(_loc3_);
            this.setQuality(param1.getQuality_name(),_loc3_);
            Icon.setUrlIcon(_loc3_["pic"],param1.getPicId(),Icon.ORGANISM_1);
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
   }
}

