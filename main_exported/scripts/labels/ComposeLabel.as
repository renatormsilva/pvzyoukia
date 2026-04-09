package labels
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import entity.Organism;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.compose.panel.ComposeWindowNew;
   import tip.OrgTip;
   import tip.ToolsTip;
   import utils.FuncKit;
   import windows.ActionWindow;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class ComposeLabel extends Sprite
   {
      
      public static const ORG:int = 1;
      
      public static const TOOL:int = 2;
      
      private static var GRADE_WIDTH:int = 54;
      
      private static var SHORTCUT_PRIZE:int = 1;
      
      internal var tips:Object;
      
      internal var _p_icon:MovieClip = null;
      
      public var _mc:MovieClip;
      
      internal var _backFunction:Function;
      
      internal var _clearFunction:Function;
      
      internal var _labelType:int = 0;
      
      internal var _o:Object;
      
      internal var bg:MovieClip;
      
      private var _evoltionPrize:Object;
      
      private var _donum:int = 0;
      
      private var evolutionPath:int = 0;
      
      private var _type:int;
      
      public function ComposeLabel(param1:Object, param2:Function = null, param3:Function = null)
      {
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         this._evoltionPrize = {};
         super();
         var _loc4_:Class = DomainAccess.getClass("label");
         this._mc = new _loc4_();
         this._o = param1;
         this.setOrg();
         this._backFunction = param2;
         this._clearFunction = param3;
         this._mc["light"].visible = false;
         this._mc["_isInSeverbattle"].visible = false;
         this._mc["_mc_arena"].visible = false;
         this._mc.mouseChildren = false;
         FuncKit.clearAllChildrens(this._mc["grade"]);
         FuncKit.clearAllChildrens(this._mc["bg"]);
         this.addPossessionIcon();
         if(param1 is Organism)
         {
            if((param1 as Organism).getGardenId() != 0)
            {
               this._mc["light"].visible = true;
            }
            this._labelType = ORG;
            this._mc.str2.visible = false;
            this._mc["_mc_arena"].visible = (param1 as Organism).getIsArena();
            _loc5_ = DomainAccess.getClass("grade");
            _loc6_ = new _loc5_();
            _loc6_["num"].addChild(FuncKit.getNumEffect("" + (this._o as Organism).getGrade()));
            this._mc["grade"].addChild(_loc6_);
            this._mc["grade"].x = this._mc["grade_loc"].x + (GRADE_WIDTH - _loc6_.width) / 2;
            this.setOrgBg(this._o as Organism);
            this._p_icon.visible = (this._o as Organism).getIsPossession();
            this._mc["_isInSeverbattle"].visible = (this._o as Organism).getIsSeverBattle();
         }
         else
         {
            this._labelType = TOOL;
            this._mc.blood.visible = false;
            this._mc.blood_bg.visible = false;
         }
         this.init();
         if(this._labelType == ORG)
         {
            Icon.setUrlIcon(this._mc["pic"],param1.getPicId(),Icon.ORGANISM_1);
         }
         else if(this._labelType == TOOL)
         {
            Icon.setUrlIcon(this._mc["pic"],param1.getPicId(),Icon.TOOL_1);
         }
         this.addClickEvent();
         this.addOverAndOutEvent();
         this.selectedEvent();
         this.buttonMode = true;
         this.addChild(this._mc);
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
      
      private function setOrgBg(param1:Organism) : void
      {
         var _loc2_:Class = DomainAccess.getClass("label_bg" + XmlQualityConfig.getInstance().getCardQualityId(param1.getQuality_name()));
         this.bg = new _loc2_();
         this.bg.gotoAndStop(1);
         this._mc.bg.addChild(this.bg);
         this._mc.bg.visible = true;
      }
      
      public function holdType(param1:int) : void
      {
         this._type = param1;
      }
      
      public function getO() : Object
      {
         return this._o;
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function setMaskVisible(param1:Boolean) : void
      {
         this._mc._mask.visible = param1;
      }
      
      private function addOverAndOutEvent() : void
      {
         var onOver:Function = null;
         onOver = function(param1:MouseEvent):void
         {
            if(_o is Organism)
            {
               if(tips == null)
               {
                  tips = new OrgTip();
               }
               tips.setOrgtip(_mc,_o as Organism);
            }
            else if(_o is Tool)
            {
               if(tips == null)
               {
                  tips = new ToolsTip();
               }
               (tips as ToolsTip).setTooltip(_mc,_o);
            }
            tips.setLoction(getPositionX(),getPositionY());
         };
         this.addEventListener(MouseEvent.ROLL_OVER,onOver);
      }
      
      public function getPositionX() : int
      {
         if(this._mc.parent.x + this._mc.parent.parent.parent.x + this.width + 20 > 600)
         {
            return this._mc.parent.x - 2 * this.width - 45;
         }
         return this._mc.parent.x + this.width + 20 - 25;
      }
      
      public function getPositionY() : int
      {
         return this._mc.parent.y - 60;
      }
      
      private function addClickEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function executeRobot() : void
      {
         this.onClick(null);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this._donum = 0;
         this.changeLabelState();
      }
      
      private function changeLabelState() : void
      {
         var _loc1_:int = 0;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(!this._mc._mask.visible)
         {
            if(this._type != ComposeWindowNew.TYPE_ORG_EVOLUTION || GlobalConstants.NEW_PLAYER)
            {
               if(this._backFunction != null)
               {
                  if(this._backFunction(this._o))
                  {
                     this._mc._mask.visible = true;
                  }
               }
               return;
            }
            this.evolutionPath = (this._o as Organism).getEvolution().length;
            if(this.evolutionPath <= 0)
            {
               if(this._backFunction != null)
               {
                  if(this._backFunction(this._o))
                  {
                     this._mc._mask.visible = true;
                  }
               }
               return;
            }
            PlantsVsZombies.showDataLoading(true);
            _loc1_ = int(this._o.getEvolution()[0].id);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GET_EVOLUTION_ORGS_COST,SHORTCUT_PRIZE,this._o.getId(),_loc1_);
         }
         else
         {
            if(this._clearFunction != null)
            {
               this._clearFunction(this._o);
            }
            this._mc._mask.visible = false;
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == SHORTCUT_PRIZE)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      private function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:int = 0;
         ++this._donum;
         this._evoltionPrize[this._donum] = param2;
         if(this._donum == this.evolutionPath)
         {
            PlantsVsZombies.showDataLoading(false);
            if(this._backFunction != null)
            {
               if(this._backFunction(this._o,this._evoltionPrize))
               {
                  this._mc._mask.visible = true;
               }
               return;
            }
         }
         if(this.evolutionPath == 2)
         {
            _loc3_ = int(this._o.getEvolution()[1].id);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GET_EVOLUTION_ORGS_COST,SHORTCUT_PRIZE,this._o.getId(),_loc3_);
         }
      }
      
      private function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window079"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      private function getIcon(param1:Object) : MovieClip
      {
         var _loc2_:Class = null;
         if(this._labelType == ORG)
         {
            _loc2_ = DomainAccess.getClass("icon_org_" + param1.getPicId());
         }
         else
         {
            if(this._labelType != TOOL)
            {
               return null;
            }
            _loc2_ = DomainAccess.getClass("icon_tool_" + param1.getPicId());
         }
         return new _loc2_();
      }
      
      private function init() : void
      {
         this._mc._mask.visible = false;
         this._mc.gotoAndStop(1);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._mc.gotoAndStop(1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._mc.gotoAndStop(2);
      }
      
      private function selectedEvent() : void
      {
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function setOrg() : void
      {
         var _loc1_:Number = NaN;
         if(this._o is Organism)
         {
            this._mc.str.text = "";
            _loc1_ = (this._o as Organism).getHp().toNumber() / (this._o as Organism).getHp_max().toNumber();
            if(_loc1_ > 1)
            {
               _loc1_ = 1;
            }
            this._mc.blood.scaleX = _loc1_;
         }
         else if(this._o is Tool)
         {
            this._mc.str.text = (this._o as Tool).getName();
            this._mc.str2.text = (this._o as Tool).getNum() + "个";
         }
      }
   }
}

