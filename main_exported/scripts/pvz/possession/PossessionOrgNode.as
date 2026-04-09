package pvz.possession
{
   import com.display.CMovieClip;
   import com.res.IDestroy;
   import entity.Organism;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.EffectManager;
   import node.OrgLoader;
   import pvz.possession.tip.PossessionOrgTip;
   import utils.FuncKit;
   
   public class PossessionOrgNode extends Sprite implements IDestroy
   {
      
      public var _mc:OrgLoader = null;
      
      public var _org:Organism = null;
      
      private var _index:int = 0;
      
      private var _tip:PossessionOrgTip = null;
      
      private var _type:int = 0;
      
      private var lightC:CMovieClip = null;
      
      public function PossessionOrgNode(param1:Organism, param2:int, param3:int, param4:Boolean = false)
      {
         super();
         this._org = param1;
         this._index = param3;
         this._type = param2;
         if(!param4)
         {
            this.mouseEnabled = false;
            this.mouseChildren = false;
         }
         this.setOrgMc(this._org.getPicId());
         this.setLightEffect();
         if(param4)
         {
            this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         }
      }
      
      public function destroy() : void
      {
         if(this._tip != null)
         {
            this._tip.destroy();
         }
         this.clearOrg();
         FuncKit.clearAllChildrens(this);
      }
      
      public function setLoction(param1:Point, param2:Point) : void
      {
         if(this._type == PossessionNode.GUEST)
         {
            this.x = param1.x * 0.6 + param2.x;
            this.y = param1.y * 0.6 + param2.y;
         }
         else
         {
            this.x = param1.x + param2.x;
            this.y = param1.y + param2.y;
         }
      }
      
      private function changeLightLoc() : void
      {
         if(this.lightC != null)
         {
            this.lightC.x = -this.lightC.width / 2;
         }
      }
      
      private function clearOrg() : void
      {
         if(this._mc == null)
         {
            return;
         }
         removeChild(this._mc);
      }
      
      private function getTipLoc() : Point
      {
         var _loc1_:Point = new Point();
         if(this._type == PossessionNode.GUEST)
         {
            _loc1_.x = this.parent.x + (this._mc.width + 25) * 0.6;
            _loc1_.y = this.parent.y - (this._mc.height + 42) * 0.6;
         }
         else
         {
            _loc1_.x = this.parent.x + this._mc.width + 25;
            _loc1_.y = this.parent.y - this._mc.height - 20;
         }
         if(this.parent.x + _loc1_.x + this._tip.width > PlantsVsZombies.WIDTH)
         {
            _loc1_.x = this.parent.x - this._tip.width;
         }
         if(this.parent.y + _loc1_.y + this._tip.height > PlantsVsZombies.HEIGHT)
         {
            _loc1_.y = this.parent.y - this._tip.height;
         }
         return _loc1_;
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._tip == null)
         {
            this._tip = new PossessionOrgTip();
         }
         this._tip.setTip(this,this._org,PlantsVsZombies._node);
         this._tip.setLoction(this.getTipLoc().x,this.getTipLoc().y);
      }
      
      private function setLightEffect() : void
      {
         var _loc1_:Number = 1;
         if(this._type == PossessionNode.GUEST)
         {
            _loc1_ = 0.6;
         }
         this.lightC = EffectManager.getQualityEffect(this._org,_loc1_);
         if(this.lightC != null)
         {
            this.lightC.mouseChildren = false;
            this.lightC.mouseEnabled = false;
            addChild(this.lightC);
         }
      }
      
      private function setOrgMc(param1:int) : void
      {
         var _loc2_:Number = 1;
         if(this._type == PossessionNode.GUEST)
         {
            _loc2_ = 0.6;
         }
         if(this._type == 0)
         {
            this._mc = new OrgLoader(param1,1,null,_loc2_);
         }
         else
         {
            this._mc = new OrgLoader(param1,0,null,_loc2_);
         }
         this._mc.mouseChildren = false;
         this._mc.mouseEnabled = false;
         addChild(this._mc);
      }
   }
}

