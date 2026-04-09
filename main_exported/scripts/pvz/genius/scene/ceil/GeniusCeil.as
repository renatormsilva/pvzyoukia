package pvz.genius.scene.ceil
{
   import com.display.CMovieClip;
   import entity.Tool;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import manager.EffectManager;
   import manager.SoundManager;
   import pvz.genius.events.GeniusUpEvent;
   import pvz.genius.fport.GeniusUpGradeFPort;
   import pvz.genius.tips.GeniusBallTips;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.M_ClipMotion;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class GeniusCeil extends EventDispatcher
   {
      
      private var __name:String = "talent_2";
      
      private var _cglevel:int = 0;
      
      private var _cslevel:int = 0;
      
      private var _icon:Sprite;
      
      private var _effect:CMovieClip;
      
      private var _orgId:int;
      
      public var effectBackFunc:Function;
      
      private var _upFport:GeniusUpGradeFPort;
      
      private var __node:Sprite;
      
      private var _talent_bg:Sprite;
      
      private var __tipsNode:Sprite;
      
      private var _soul_is_up:Boolean;
      
      private var _tips:GeniusBallTips;
      
      private var m_can_upgrade:Boolean = false;
      
      public function GeniusCeil(param1:Sprite, param2:Sprite, param3:String)
      {
         super();
         this.__node = param1;
         this.__name = param3;
         this.__tipsNode = param2;
      }
      
      public function get orgId() : int
      {
         return this._orgId;
      }
      
      public function set orgId(param1:int) : void
      {
         this._orgId = param1;
      }
      
      public function get gname() : String
      {
         return this.__name;
      }
      
      public function get glevel() : int
      {
         return this._cglevel;
      }
      
      public function set glevel(param1:int) : void
      {
         this._cglevel = param1;
         this.clearGeniusEffect();
         this.updataGenius();
      }
      
      public function get slevel() : int
      {
         return this._cslevel;
      }
      
      public function set slevel(param1:int) : void
      {
         this._cslevel = param1;
      }
      
      public function get soulUp() : Boolean
      {
         return this._soul_is_up;
      }
      
      public function set canUpgrade(param1:Boolean) : void
      {
         this.m_can_upgrade = param1;
         this.changeUpgradeBtnType();
      }
      
      public function setDefaultType(param1:int) : void
      {
         if(param1 == 1)
         {
            this._cglevel = 1;
            this.updataStateEffect();
            this.addMouseEvent();
            this._talent_bg["upgrade"].visible = false;
            this._talent_bg["upgrade"].gotoAndStop(1);
            this.setTextEnableAndMiaobian();
         }
         else if(param1 == 2)
         {
            this._cglevel = 0;
            this._talent_bg["_name"].text = "";
            this._talent_bg["upgrade"].visible = true;
         }
         else if(param1 == 3)
         {
            this._cglevel = 0;
            this._talent_bg["_name"].text = "";
            this._talent_bg["upgrade"].visible = false;
         }
      }
      
      private function changeUpgradeBtnType() : void
      {
         if(this.m_can_upgrade)
         {
            this._talent_bg["upgrade"].gotoAndStop(2);
         }
         else
         {
            this._talent_bg["upgrade"].gotoAndStop(1);
         }
      }
      
      private function initGeniusCeilUI() : void
      {
         this.updataStateEffect();
         this.updataLightEffect();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(this._tips == null)
         {
            return;
         }
         this._tips.visible = false;
         if(this._tips.parent)
         {
            this._tips.parent.removeChild(this._tips);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(this._tips == null)
         {
            this._tips = new GeniusBallTips();
         }
         if(param1.target != this._icon)
         {
            return;
         }
         var _loc2_:Object = {
            "level":this.glevel,
            "type":this.__name,
            "orgid":this._orgId
         };
         this._tips.show(_loc2_);
         this.__tipsNode.addChild(this._tips);
         this._tips.visible = true;
         if(this.__name == "talent_1" || this.__name == "talent_2" || this.__name == "talent_3")
         {
            this._tips.x = this.__node.x - 250;
         }
         else
         {
            this._tips.x = 30 + this.__node.x;
         }
         this._tips.y = this.__node.y - this._tips.height / 2;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.lockScreen(false);
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._upFport == null)
         {
            this._upFport = new GeniusUpGradeFPort(this);
         }
         var _loc2_:Tool = this.getNeedToolByTname();
         this._upFport.requestSever(GeniusUpGradeFPort.UPGRADE_GENIUS,this._orgId,this.__name,_loc2_);
      }
      
      private function getNeedToolByTname() : Tool
      {
         var _loc1_:Tool = null;
         if(this.glevel == 0)
         {
            _loc1_ = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(this.__name,1).requiredTool;
         }
         else
         {
            _loc1_ = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(this.__name,this.glevel + 1).requiredTool;
         }
         return _loc1_;
      }
      
      private function updataLightEffect() : void
      {
         if(this.open())
         {
            this._effect = EffectManager.getGeniusEffect(this.glevel);
            this._effect.mouseEnabled = false;
            this._talent_bg["tal_node"].addChild(this._effect);
         }
      }
      
      private function updataStateEffect() : void
      {
         if(this._talent_bg == null)
         {
            this._talent_bg = GetDomainRes.getMoveClip("talent");
            this.__node.addChild(this._talent_bg);
         }
         else
         {
            FuncKit.clearAllChildrens(this._talent_bg["tal_node"]);
         }
         this._icon = GetDomainRes.getSprite(this.__name);
         this._talent_bg["tal_node"].addChild(this._icon);
      }
      
      public function clearGeniusEffect() : void
      {
         if(this._effect == null)
         {
            return;
         }
         this._effect.gotoAndStop(1);
         if(this._effect.parent != null)
         {
            this._effect.parent.removeChild(this._effect);
         }
         this._effect = null;
      }
      
      public function upLevel(param1:int, param2:int, param3:int, param4:int, param5:Number = 0) : void
      {
         var gLevel_upgraded:int = 0;
         var sLevel_upgraded:int = 0;
         var s_upgraded:int = 0;
         var dispather:EventDispatcher = null;
         var backFunc:Function = null;
         var glev:int = param1;
         var gupgraded:int = param2;
         var slev:int = param3;
         var supgraded:int = param4;
         var attackNum:Number = param5;
         backFunc = function():void
         {
            glevel = gLevel_upgraded;
            slevel = sLevel_upgraded;
            if(s_upgraded)
            {
               _soul_is_up = true;
            }
            else
            {
               _soul_is_up = false;
            }
            dispather.dispatchEvent(new GeniusUpEvent(GeniusUpEvent.GENIUS_UP_COMMAD,attackNum));
         };
         gLevel_upgraded = glev;
         var g_upgraded:int = gupgraded;
         sLevel_upgraded = slev;
         s_upgraded = supgraded;
         if(!g_upgraded)
         {
            return;
         }
         M_ClipMotion.play_Up_GradeEffect(this.__node,M_ClipMotion.GENIUS_UPGRADE_EFFECT,backFunc);
         dispather = this;
      }
      
      private function updataGenius() : void
      {
         this.updataStateEffect();
         this.updataLightEffect();
         this.showNameAndLevel();
      }
      
      private function showNameAndLevel() : void
      {
         var _loc2_:String = null;
         var _loc1_:uint = TextFilter.getCoulorByGeniusLevel(this.glevel);
         this._talent_bg["_name"].textColor = _loc1_;
         if(this.glevel)
         {
            _loc2_ = "Lv." + this.glevel + this.getArriveGeniusNameByName(this.__name);
            this._talent_bg["_name"].text = _loc2_;
         }
         else
         {
            this._talent_bg["_name"].text = this.getArriveGeniusNameByName(this.__name);
         }
         if(this.glevel == XmlGeniusDataConfig.GENIUS_MAX_LEVEL)
         {
            this._talent_bg["upgrade"].visible = false;
         }
      }
      
      private function open() : Boolean
      {
         if(this.glevel <= 0)
         {
            return false;
         }
         return true;
      }
      
      private function setTextEnableAndMiaobian() : void
      {
         this._talent_bg["_name"].selectable = false;
         TextFilter.MiaoBian(this._talent_bg["_name"],1118481);
      }
      
      private function getNextSoulLevelInfo(param1:int) : int
      {
         return XmlGeniusDataConfig.getInstance().getSoulDataByLevel(param1).getArriveGeniusLevelByName(this.__name);
      }
      
      public function getGeilX() : Number
      {
         return this.__node.x;
      }
      
      public function getGeilY() : Number
      {
         return this.__node.y;
      }
      
      public function dispose() : void
      {
         this._tips = null;
         this.effectBackFunc = null;
         this.clearGeniusEffect();
         this.removeMouseEvent();
         FuncKit.clearAllChildrens(this.__node);
      }
      
      public function getArriveGeniusNameByName(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case XmlGeniusDataConfig.STRONG:
               _loc2_ = "强壮";
               break;
            case XmlGeniusDataConfig.STROM_ATTACK:
               _loc2_ = "猛攻";
               break;
            case XmlGeniusDataConfig.POISON:
               _loc2_ = "毒雾";
               break;
            case XmlGeniusDataConfig.PHANTOM:
               _loc2_ = "坚韧";
               break;
            case XmlGeniusDataConfig.LIGHT_DEFFENCE:
               _loc2_ = "光盾";
               break;
            case XmlGeniusDataConfig.FOCUS:
               _loc2_ = "破甲";
               break;
            case XmlGeniusDataConfig.DEFEAT:
               _loc2_ = "破击";
               break;
            case XmlGeniusDataConfig.CLEAR:
               _loc2_ = "净化";
               break;
            case XmlGeniusDataConfig.CAZRY_WIND:
               _loc2_ = "疾风";
         }
         return _loc2_;
      }
      
      private function addMouseEvent() : void
      {
         this._talent_bg["upgrade"].addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this._talent_bg["upgrade"].buttonMode = true;
         this._talent_bg["tal_node"].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._talent_bg["tal_node"].addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function removeMouseEvent() : void
      {
         this._talent_bg["upgrade"].removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         this._talent_bg["tal_node"].removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._talent_bg["tal_node"].removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
   }
}

