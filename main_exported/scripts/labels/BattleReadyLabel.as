package labels
{
   import com.res.IDestroy;
   import entity.Organism;
   import entity.Skill;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import tip.OrgTip;
   import utils.FuncKit;
   import utils.Singleton;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class BattleReadyLabel extends Sprite implements IDestroy
   {
      
      private static var GRADE_WIDTH:int = 54;
      
      public static const HUNT:int = 1;
      
      public static const ARENA:int = 2;
      
      public static const POSSESSION:int = 3;
      
      public static const WORLD:int = 4;
      
      public static const SEVER_BATTLE:int = 5;
      
      public static const GARDEN:int = 6;
      
      public var _mc:MovieClip;
      
      internal var _o:Organism;
      
      internal var isCheck:Boolean = false;
      
      internal var _click:Function = null;
      
      internal var _remove:Function = null;
      
      internal var _id:int = 0;
      
      internal var _check:Function;
      
      private var t:OrgTip;
      
      private var pic:MovieClip;
      
      internal var bg:MovieClip;
      
      internal var type:int = 0;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _p_icon:MovieClip = null;
      
      public function BattleReadyLabel(param1:int)
      {
         super();
         this.type = param1;
         var _loc2_:Class = DomainAccess.getClass("label");
         this._mc = new _loc2_();
         this._mc.gotoAndStop(1);
         this._mc.buttonMode = true;
         this._mc.mouseChildren = false;
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addMouseEvent();
         this.addPossessionIcon();
         this._mc["_mask"].visible = false;
         this._mc["light"].visible = false;
         this._mc["_mc_arena"].visible = false;
         this._mc["_isInSeverbattle"].visible = false;
         this.addChild(this._mc);
         this.show(true);
      }
      
      private function addPossessionIcon() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_mc_possession_icon");
         this._p_icon = new _loc1_();
         this._p_icon.visible = false;
         this._p_icon.x = 12;
         this._p_icon.y = 12;
         this._mc.addChild(this._p_icon);
      }
      
      private function addMouseEvent() : void
      {
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeMouseEvent() : void
      {
         this._mc.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function getIcon(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("icon_org_" + param1);
         return new _loc2_();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.type == WORLD || this.type == HUNT)
         {
            if(this._o.getGardenId() != 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node001"));
               return;
            }
         }
         if(this._o.getHp().toNumber() < 1)
         {
            if(this.type == HUNT || this.type == WORLD)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node002"));
               return;
            }
         }
         if(this.type == POSSESSION && this._o.getIsPossession())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession034"));
            return;
         }
         if(this._check == null)
         {
            return;
         }
         if(!this.isCheck && !this._check(this._o.getWidth() * this._o.getHeight()))
         {
            return;
         }
         if(!this.isCheck && this._click != null)
         {
            this._click(this._o);
            this._mc["_mask"].visible = true;
            this.isCheck = true;
            return;
         }
         if(this.isCheck && this._remove != null)
         {
            this._remove(this._o);
            this._mc["_mask"].visible = false;
            this.isCheck = false;
         }
      }
      
      private function setOrgBg(param1:Organism) : void
      {
         var _loc2_:Class = DomainAccess.getClass("label_bg" + XmlQualityConfig.getInstance().getCardQualityId(param1.getQuality_name()));
         this.bg = new _loc2_();
         this.bg.gotoAndStop(1);
         this._mc.bg.addChild(this.bg);
         this._mc.bg.visible = true;
      }
      
      public function setMask(param1:Boolean = false) : void
      {
         this.isCheck = param1;
         this._mc["_mask"].visible = param1;
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
      
      public function update(param1:Object, param2:Function, param3:Function, param4:Function) : void
      {
         this._o = param1 as Organism;
         this._click = param2;
         this._check = param3;
         this._remove = param4;
         this._p_icon.visible = false;
         if(this.type == HUNT && this.playerManager.getPlayer().isBattleReady(this._o.getId()))
         {
            this._mc["_mask"].visible = true;
            this.isCheck = true;
         }
         if(this.type == GARDEN && this.playerManager.getPlayer().isBattleReady(this._o.getId()))
         {
            this._mc["_mask"].visible = true;
            this.isCheck = true;
         }
         if(this.type == WORLD && this.playerManager.getPlayer().isBattleReadyInWorld(this._o.getId()))
         {
            this._mc["_mask"].visible = true;
            this.isCheck = true;
         }
         if(this.type == POSSESSION)
         {
            if(this.type == POSSESSION && this._o.getIsPossession())
            {
               FuncKit.setNoColor(this._mc["pic"]);
            }
            this._p_icon.visible = this._o.getIsPossession();
         }
         FuncKit.clearAllChildrens(this._mc["grade"]);
         FuncKit.clearAllChildrens(this._mc["bg"]);
         if(this._o == null)
         {
            return;
         }
         FuncKit.clearAllChildrens(this._mc["pic"]);
         Icon.setUrlIcon(this._mc["pic"],this._o.getPicId(),Icon.ORGANISM_1);
         var _loc5_:Class = DomainAccess.getClass("grade");
         var _loc6_:MovieClip = new _loc5_();
         _loc6_["num"].addChild(FuncKit.getNumEffect("" + (this._o as Organism).getGrade()));
         this._mc["grade"].addChild(_loc6_);
         this._mc["grade"].x = this._mc["grade_loc"].x + (GRADE_WIDTH - _loc6_.width) / 2;
         this._id = param1.getId();
         this._mc["str"].text = "";
         this._mc["str"].visible = true;
         this._mc["str2"].visible = false;
         this.setLife(param1 as Organism);
         this._mc.gotoAndStop(1);
         this.show(true);
         if(this._o.getGardenId() != 0)
         {
            if(this.type == HUNT || this.type == WORLD)
            {
               this._mc["light"].visible = true;
            }
         }
         if(this._o.getGardenId() != 0 || this._o.getHp().toNumber() == 0)
         {
            if(this.type == HUNT || this.type == WORLD)
            {
               FuncKit.setNoColor(this._mc["pic"]);
            }
         }
         this.setOrgBg(this._o);
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
         if(this.type == HUNT || this.type == WORLD)
         {
            this._mc["blood"].scaleX = _loc2_;
         }
         else
         {
            this._mc["blood"].scaleX = 1;
         }
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
         return this._mc.parent.y + this._mc.parent.parent.parent.y - 20;
      }
      
      public function destroy() : void
      {
         this.removeMouseEvent();
         FuncKit.clearAllChildrens(this);
         this._o = null;
         if(this.t != null)
         {
            this.t.destroy();
         }
      }
   }
}

