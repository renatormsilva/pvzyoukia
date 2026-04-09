package labels
{
   import com.res.IDestroy;
   import entity.Organism;
   import entity.Skill;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import node.Icon;
   import tip.OrgTip;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class OrganismLabel extends Sprite implements IDestroy
   {
      
      private static var GRADE_WIDTH:int = 54;
      
      public var _mc:MovieClip;
      
      internal var _o:Organism;
      
      internal var isCheck:Boolean = false;
      
      internal var _click:Function;
      
      internal var _id:int = 0;
      
      private var t:OrgTip;
      
      private var pic:MovieClip;
      
      internal var bg:MovieClip;
      
      public function OrganismLabel()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("label_org");
         this._mc = new _loc1_();
         this._mc.buttonMode = true;
         this.addEvent();
         this._mc.mouseChildren = false;
         this._mc["_mask"].visible = false;
         this.addChild(this._mc);
         this._mc["light"].visible = false;
         this.show(true);
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         FuncKit.clearAllChildrens(this);
      }
      
      private function addEvent() : void
      {
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._mc.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setOrgBg(param1:Organism) : void
      {
         var _loc2_:Class = DomainAccess.getClass("label_bg" + XmlQualityConfig.getInstance().getCardQualityId(param1.getQuality_name()));
         this.bg = new _loc2_();
         this.bg.gotoAndStop(1);
         this._mc.bg.addChild(this.bg);
         this._mc.bg.visible = true;
      }
      
      private function getIcon(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("icon_org_" + param1);
         return new _loc2_();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this._mc.removeEventListener(MouseEvent.CLICK,this.onClick);
         if(this._click != null)
         {
            this._click(this._o);
         }
      }
      
      public function setMaskFalse() : void
      {
         this.isCheck = false;
         this._mc["_mask"].visible = false;
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         this.bg.gotoAndStop(2);
         if(this._mc["_mask"].visible)
         {
            return;
         }
         if(this.t == null)
         {
            this.t = new OrgTip();
         }
         this.t.setOrgtip(this._mc,this._o);
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < this._o.getAllSkills().length)
         {
            _loc5_ = "lv." + (this._o.getAllSkills()[_loc4_] as Skill).getGrade() + " " + (this._o.getAllSkills()[_loc4_] as Skill).getName();
            _loc2_ += _loc5_ + "  ";
            if(_loc4_ > 1)
            {
               _loc3_ += _loc5_ + "   ";
            }
            _loc4_++;
         }
         this.t.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.bg.gotoAndStop(1);
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function update(param1:Object, param2:Function) : void
      {
         this._o = param1 as Organism;
         this._click = param2;
         FuncKit.clearAllChildrens(this._mc["grade"]);
         FuncKit.clearAllChildrens(this._mc["bg"]);
         if(param1 == null)
         {
            return;
         }
         FuncKit.clearAllChildrens(this._mc["pic"]);
         Icon.setUrlIcon(this._mc["pic"],this._o.getPicId(),Icon.ORGANISM_1);
         var _loc3_:Class = DomainAccess.getClass("grade");
         var _loc4_:MovieClip = new _loc3_();
         _loc4_["num"].addChild(FuncKit.getNumEffect("" + (this._o as Organism).getGrade()));
         this._mc["grade"].addChild(_loc4_);
         this._mc["grade"].x = this._mc["grade_loc"].x + (GRADE_WIDTH - _loc4_.width) / 2;
         this._id = param1.getId();
         this._mc["str"].text = "";
         this._mc["str"].visible = true;
         this._mc["str2"].visible = false;
         this.setOrgBg(param1 as Organism);
         this.setLife(param1 as Organism);
         this.bg.gotoAndStop(1);
         this.show(true);
      }
      
      public function getOrg() : Organism
      {
         return this._o;
      }
      
      private function setLife(param1:Organism) : void
      {
         var _loc2_:Number = param1.getHp().toNumber() / param1.getHp_max().toNumber();
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         this._mc["blood"].scaleX = _loc2_;
      }
      
      private function show(param1:Boolean = false) : void
      {
         this._mc.visible = param1;
      }
      
      public function getPositionX() : int
      {
         if(this._mc.parent.x > 336)
         {
            return this._mc.parent.x - this.width;
         }
         return this._mc.parent.x + this.width + 125;
      }
      
      public function getPositionY() : int
      {
         return this._mc.parent.y + this._mc.parent.parent.parent.y - 40;
      }
   }
}

