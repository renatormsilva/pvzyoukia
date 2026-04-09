package pvz.compose.panel
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.ExSkill;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import labels.ComposePicLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.QualityManager;
   import manager.SkillManager;
   import manager.ToolManager;
   import manager.ToolType;
   import node.Icon;
   import pvz.compose.ChooseSkillWindow;
   import pvz.compose.ComposePrizeWindow;
   import pvz.compose.EvolutionPrizeWindow;
   import pvz.compose.LearnSkillWindow;
   import pvz.compose.NewSkillWindow;
   import tip.AdaptTip;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ComposeOrgIntensifyPanel extends Sprite implements IDestroy, IConnection
   {
      
      private static const ORG_HP_1:int = 5;
      
      private static const ORG_HP_2:int = 6;
      
      private static const ORG_HP_3:int = 7;
      
      private static const ORG_LEARN:int = 8;
      
      private static const ORG_PULLULATION:int = 4;
      
      private static const ORG_QUALITY:int = 3;
      
      private static const ORG_QUALITY_NEW:int = 15;
      
      private static const ORG_QUALITY_MOSHEN:int = 16;
      
      private static const ORG_UP:int = 9;
      
      private static const INTENSIFY_COMPOSE_LIFE:int = 10;
      
      private static const INDENTIFY_COMPOSE_SPEED:int = 11;
      
      private static const INDENTIFY_COMPOSE_ATTACK:int = 12;
      
      private static const INDENTIFY_COMPOSE_DUCK:int = 13;
      
      private static const INDENTIFY_COMPOSE_DOOM:int = 14;
      
      private static const INDENTIFY_COMPOSE_NEW_MISS:int = 17;
      
      private static const INDENTIFY_COMPOSE_NEW_PRE:int = 18;
      
      private static var compToolArr:Array = [614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108];
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var changeMaterial:Function = null;
      
      private var clearMask:Function = null;
      
      private var csWindow:ChooseSkillWindow = null;
      
      private var evolPrizeWindow:EvolutionPrizeWindow = null;
      
      private var labelvisible:Function = null;
      
      private var learnSkillWindow:LearnSkillWindow = null;
      
      private var newSkillWindow:NewSkillWindow = null;
      
      private var panel:MovieClip = null;
      
      private var useToolResultWindow:ComposePrizeWindow = null;
      
      private var setJiantou:Function = null;
      
      private var upQualityfailTip:AdaptTip;
      
      private var orgQualityLevel:int;
      
      public function ComposeOrgIntensifyPanel(param1:Function, param2:Function, param3:Function, param4:Function, param5:int = 0, param6:int = 0)
      {
         super();
         var _loc7_:Class = DomainAccess.getClass("orgIntensifyPanel");
         this.panel = new _loc7_();
         this.panel.visible = false;
         this.panel.gotoAndStop(1);
         this.addChild(this.panel);
         this.changeMaterial = param2;
         this.clearMask = param1;
         this.labelvisible = param3;
         this.setJiantou = param4;
         this.addBtEvent();
         this.setLoction(param5,param6);
         this.show();
      }
      
      public static function chooseToolComp(param1:Array) : Array
      {
         var i:int;
         var array:Array = param1;
         var choose:Function = function(param1:Tool):Boolean
         {
            if(param1 == null || param1.getNum() < 1)
            {
               return false;
            }
            if(param1.getOrderId() == ToolManager.TOOL_COMP_QUALITY_MOSHEN)
            {
               return true;
            }
            var _loc2_:int = 0;
            while(_loc2_ < ToolManager.compTools.length / 2)
            {
               if(ToolManager.newQualityBook.indexOf(param1.getOrderId()) > -1 || param1.getOrderId() < ToolManager.compTools[2 * _loc2_ + 1] && param1.getOrderId() > ToolManager.compTools[2 * _loc2_])
               {
                  return true;
               }
               _loc2_++;
            }
            return false;
         };
         var tools:Array = new Array();
         if(array == null || array.length < 1)
         {
            return tools;
         }
         i = 0;
         while(i < array.length)
         {
            if(choose(array[i]))
            {
               tools.push(array[i]);
            }
            i++;
         }
         return tools;
      }
      
      public static function chooseToolMORHP(param1:Array) : Array
      {
         var i:int;
         var array:Array = param1;
         var choose:Function = function(param1:Tool):Boolean
         {
            if(param1 == null || param1.getNum() < 1)
            {
               return false;
            }
            if(ToolType.isMorph(param1))
            {
               return true;
            }
            return false;
         };
         var tools:Array = new Array();
         if(array == null || array.length < 1)
         {
            return tools;
         }
         i = 0;
         while(i < array.length)
         {
            if(choose(array[i]))
            {
               tools.push(array[i]);
            }
            i++;
         }
         return tools;
      }
      
      public function add(param1:Object) : Boolean
      {
         var _loc2_:Organism = null;
         var _loc5_:Tool = null;
         var _loc6_:Tool = null;
         var _loc7_:Tool = null;
         if(this.panel["_org"].numChildren != 0)
         {
            _loc2_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
         }
         if(param1 is Tool && Boolean(_loc2_))
         {
            _loc5_ = Tool(param1);
            if(_loc5_.getUseLevel() > _loc2_.getGrade())
            {
               FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("window182",_loc5_.getUseLevel(),_loc5_.getName()));
               return false;
            }
         }
         if(param1 is Organism && this.panel["_tool"].numChildren != 0)
         {
            _loc6_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            if(_loc6_.getUseLevel() > (param1 as Organism).getGrade())
            {
               FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("window182",_loc6_.getUseLevel(),_loc6_.getName()));
               return false;
            }
         }
         this.clear(param1);
         var _loc3_:MovieClip = this.toolCompose_check(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         if(param1 is Organism && this.panel["_tool"].numChildren == 0 && chooseToolComp(this.playerManager.getPlayer().getAllTools()).length > 0)
         {
            this.setJiantou(true);
         }
         var _loc4_:ComposePicLabel = new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_ORG_INTENSIFY);
         _loc3_.addChild(_loc4_);
         if(this.panel["_org"].numChildren != 0)
         {
            _loc2_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
         }
         if(this.panel["_tool"].numChildren != 0)
         {
            _loc7_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            if(_loc7_.getOrderId() == ToolManager.TOOL_COMP_QUALITY)
            {
               if(Boolean(_loc2_) && XmlQualityConfig.getInstance().getID(_loc2_.getQuality_name()) >= QualityManager.WUJI)
               {
                  this.panel["_info"].text = LangManager.getInstance().getLanguage("window167");
               }
               else
               {
                  this.panel["_info"].text = (_loc7_ as Tool).getUse_result();
               }
            }
            else
            {
               this.panel["_info"].text = (_loc7_ as Tool).getUse_result();
            }
         }
         this.showCompSuccess();
         return true;
      }
      
      public function clear(param1:Object) : void
      {
         var _loc2_:ComposePicLabel = null;
         if(param1 is Organism)
         {
            this.setJiantou(false);
            if(this.panel["_org"].numChildren != 0)
            {
               _loc2_ = this.panel["_org"].getChildAt(0);
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.panel["_org"]);
               this.showCompSuccess();
               return;
            }
         }
         else if(param1 is Tool)
         {
            this.setJiantou(false);
            if(this.panel["_tool"].numChildren != 0)
            {
               _loc2_ = this.panel["_tool"].getChildAt(0);
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.panel["_tool"]);
               this.panel["_info"].text = "";
               this.showCompSuccess();
               return;
            }
         }
      }
      
      public function destroy() : void
      {
         this.removeBtEvent();
         this.clear(new Tool(0));
         this.clear(new Organism());
         FuncKit.clearAllChildrens(this.panel);
         this.removeChild(this.panel);
         this.panel = null;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == ORG_QUALITY || param3 == ORG_PULLULATION || param3 == ORG_QUALITY_MOSHEN)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == ORG_HP_1 || param3 == ORG_HP_2 || param3 == ORG_HP_3)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == ORG_LEARN || param3 == ORG_UP)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(Boolean(param3 == INTENSIFY_COMPOSE_LIFE || INDENTIFY_COMPOSE_DOOM || INDENTIFY_COMPOSE_SPEED || INDENTIFY_COMPOSE_ATTACK || INDENTIFY_COMPOSE_DUCK) || Boolean(INDENTIFY_COMPOSE_NEW_MISS) || Boolean(INDENTIFY_COMPOSE_NEW_PRE))
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Organism = null;
         var _loc4_:Tool = null;
         var _loc5_:Organism = null;
         var _loc6_:String = null;
         var _loc7_:Organism = null;
         var _loc8_:ExSkill = null;
         var _loc9_:Skill = null;
         var _loc10_:Skill = null;
         var _loc11_:Skill = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         PlantsVsZombies.showDataLoading(false);
         if(param1 == ORG_QUALITY || param1 == ORG_QUALITY_NEW || param1 == ORG_PULLULATION || param1 == ORG_QUALITY_MOSHEN)
         {
            if(param1 == ORG_QUALITY)
            {
               this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_QUALITY,1);
            }
            else if(param1 == ORG_QUALITY_NEW)
            {
               this.playerManager.getPlayer().useTools(QualityManager.getQualityIdByLevel(this.orgQualityLevel),1);
            }
            else if(param1 == ORG_PULLULATION)
            {
               this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_PULLULATION,1);
            }
            else if(param1 == ORG_QUALITY_MOSHEN)
            {
               this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_QUALITY_MOSHEN,1);
            }
            _loc3_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            _loc4_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            if(_loc4_.getNum() < 1)
            {
               this.clear(_loc4_);
            }
            _loc5_ = new Organism();
            _loc5_.readOrg(param2);
            if(param1 == ORG_QUALITY || param1 == ORG_QUALITY_NEW || param1 == ORG_QUALITY_MOSHEN)
            {
               if(_loc3_.getQuality_name() == _loc5_.getQuality_name())
               {
                  _loc6_ = LangManager.getInstance().getLanguage("window158");
                  this.showFailIntensify(new Point(147,277),new Point(147,227),_loc6_);
                  this.changeMaterial(0);
                  return;
               }
            }
            this.showOrgChange(param1,_loc3_,_loc5_);
            _loc3_.readOrg(param2);
            (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
            this.playerManager.getPlayer().updateOrg(_loc3_);
            this.changeMaterial(0);
            this.showCompSuccess();
         }
         else if(param1 == ORG_HP_1 || param1 == ORG_HP_2 || param1 == ORG_HP_3)
         {
            _loc7_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            _loc7_.setHp(param2.toString());
            this.playerManager.getPlayer().updateOrg(_loc7_);
            switch(param1)
            {
               case ORG_HP_1:
                  this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_HP_1,1);
                  break;
               case ORG_HP_2:
                  this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_HP_2,1);
                  break;
               case ORG_HP_3:
                  this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_HP_3,1);
            }
            _loc4_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            if(_loc4_.getNum() < 1)
            {
               this.clear(_loc4_);
            }
            this.changeMaterial(0);
            if(_loc7_.getHp() != _loc7_.getHp_max())
            {
               this.showToolsUse(LangManager.getInstance().getLanguage("window025"),LangManager.getInstance().getLanguage("window026",_loc7_.getName(),_loc7_.getHp()),_loc7_);
            }
            else
            {
               this.showToolsUse(LangManager.getInstance().getLanguage("window025"),LangManager.getInstance().getLanguage("window027",_loc7_.getName()),_loc7_);
            }
         }
         else if(param1 == ORG_LEARN)
         {
            PlantsVsZombies.playFireworks(3);
            _loc3_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            _loc3_.readOrg(param2);
            (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
            this.playerManager.getPlayer().updateOrg(_loc3_);
            _loc4_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            this.playerManager.getPlayer().useTools(_loc4_.getOrderId(),1);
            this.newSkillWindow = new NewSkillWindow();
            if(int(_loc4_.getType()) >= ToolType.TOOL_TYPE64 && int(_loc4_.getType()) <= ToolType.TOOL_TYPE71)
            {
               _loc8_ = SkillManager.getInstance.getExSkillByTool(int(_loc4_.getType()));
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window028"),LangManager.getInstance().getLanguage("exskill05",_loc3_.getName(),_loc8_.getName()),_loc8_.getInfo(),_loc3_,_loc4_,0,1);
            }
            else
            {
               _loc9_ = SkillManager.getInstance.getLearnSkill(_loc4_.getLotteryName());
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window028"),LangManager.getInstance().getLanguage("window029",_loc3_.getName(),_loc9_.getName()),_loc9_.getInfo(),_loc3_,_loc4_,0,1);
            }
            this.clear(_loc4_);
            this.changeMaterial(0);
         }
         else if(param1 == ORG_UP)
         {
            _loc3_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            _loc10_ = SkillManager.getInstance.getSkillById(int(param2.now_id));
            _loc11_ = SkillManager.getInstance.getSkillById(int(param2.prev_id));
            _loc4_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            this.playerManager.getPlayer().useTools(_loc4_.getOrderId(),1);
            if(param2.now_id == param2.prev_id)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window030",_loc3_.getName(),_loc11_.getName()));
               this.clear(_loc4_);
               this.changeMaterial(0);
               return;
            }
            PlantsVsZombies.playFireworks(3);
            _loc3_.upSkill(_loc11_,_loc10_);
            this.playerManager.getPlayer().updateOrg(_loc3_);
            this.newSkillWindow = new NewSkillWindow();
            this.newSkillWindow.show(LangManager.getInstance().getLanguage("window031"),"",_loc10_.getInfo(),new Tool(SkillManager.getInstance.getLearnSkill(_loc11_.getGroup()).getLearnTool()),new Tool(SkillManager.getInstance.getLearnSkill(_loc11_.getGroup()).getLearnTool()),_loc10_.getGrade());
            this.clear(_loc4_);
            this.changeMaterial(0);
         }
         else
         {
            PlantsVsZombies.playFireworks(3);
            _loc4_ = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            this.playerManager.getPlayer().useTools(_loc4_.getOrderId(),1);
            _loc3_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            if(param1 == INTENSIFY_COMPOSE_LIFE)
            {
               _loc12_ = _loc3_.getHp_max().toNumber();
               _loc3_.readOrg(param2);
               _loc13_ = _loc3_.getHp_max().toNumber();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window139",_loc3_.getName()),LangManager.getInstance().getLanguage("window144",_loc12_,_loc13_),null,_loc3_,_loc4_);
            }
            else if(param1 == INDENTIFY_COMPOSE_DOOM)
            {
               _loc14_ = _loc3_.getPrecision();
               _loc3_.readOrg(param2);
               _loc15_ = _loc3_.getPrecision();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window140",_loc3_.getName()),LangManager.getInstance().getLanguage("window145",_loc14_,_loc15_),null,_loc3_,_loc4_);
            }
            else if(param1 == INDENTIFY_COMPOSE_SPEED)
            {
               _loc16_ = _loc3_.getSpeed();
               _loc3_.readOrg(param2);
               _loc17_ = _loc3_.getSpeed();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window143",_loc3_.getName()),LangManager.getInstance().getLanguage("window148",_loc16_,_loc17_),null,_loc3_,_loc4_);
            }
            else if(param1 == INDENTIFY_COMPOSE_ATTACK)
            {
               _loc18_ = _loc3_.getAttack();
               _loc3_.readOrg(param2);
               _loc19_ = _loc3_.getAttack();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window141",_loc3_.getName()),LangManager.getInstance().getLanguage("window146",_loc18_,_loc19_),null,_loc3_,_loc4_);
            }
            else if(param1 == INDENTIFY_COMPOSE_DUCK)
            {
               _loc20_ = _loc3_.getMiss();
               _loc3_.readOrg(param2);
               _loc21_ = _loc3_.getMiss();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window142",_loc3_.getName()),LangManager.getInstance().getLanguage("window147",_loc20_,_loc21_),null,_loc3_,_loc4_);
            }
            else if(param1 == INDENTIFY_COMPOSE_NEW_MISS)
            {
               _loc22_ = _loc3_.getNewMiss();
               _loc3_.readOrg(param2);
               _loc23_ = _loc3_.getNewMiss();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window178",_loc3_.getName()),LangManager.getInstance().getLanguage("window180",_loc22_,_loc23_),null,_loc3_,_loc4_);
            }
            else if(param1 == INDENTIFY_COMPOSE_NEW_PRE)
            {
               _loc24_ = _loc3_.getNewPrecision();
               _loc3_.readOrg(param2);
               _loc25_ = _loc3_.getNewPrecision();
               (this.panel["_org"].getChildAt(0) as ComposePicLabel).updateO(_loc3_);
               this.playerManager.getPlayer().updateOrg(_loc3_);
               this.newSkillWindow = new NewSkillWindow();
               this.newSkillWindow.show(LangManager.getInstance().getLanguage("window179",_loc3_.getName()),LangManager.getInstance().getLanguage("window181",_loc24_,_loc25_),null,_loc3_,_loc4_);
            }
            if(_loc4_.getNum() < 1)
            {
               this.clear(_loc4_);
            }
            this.changeMaterial(0);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function addBtEvent() : void
      {
         this.panel["compose"].addEventListener(MouseEvent.CLICK,this.onIntensify);
      }
      
      private function learnAndUpSkill(param1:Organism, param2:Tool) : void
      {
         var learnSkill:Function = null;
         var skills:Array = null;
         var o:Organism = param1;
         var t:Tool = param2;
         var checkSkillGrade:Function = function(param1:Organism, param2:Array):Array
         {
            var _loc3_:Array = new Array();
            var _loc4_:int = 0;
            while(_loc4_ < param2.length)
            {
               if(SkillManager.getInstance.getNextSkillById((param2[_loc4_] as Skill).getId()).getLearnGrade() <= param1.getGrade())
               {
                  _loc3_.push(param2[_loc4_]);
               }
               _loc4_++;
            }
            return _loc3_;
         };
         learnSkill = function(param1:Organism, param2:Tool):void
         {
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_SKILL_LEARN,ORG_LEARN,param1.getId(),param2.getOrderId());
         };
         var upSkill:Function = function(param1:Organism, param2:Skill):void
         {
            var _loc3_:int = SkillManager.getInstance.getSkillById(param2.getId()).getLearnGrade();
            if(param1.getGrade() < _loc3_)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window037",_loc3_,param2.getName(),param2.getGrade() + 1));
               return;
            }
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_SKILL_UP,ORG_UP,param1.getId(),param2.getId());
         };
         if(t.getType() == ToolType.TOOL_TYPE5 + "")
         {
            if(o.isLearnSkillRepetition(SkillManager.getInstance.getLearnSkill(t.getLotteryName()),SkillManager.getInstance))
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window032"));
               return;
            }
            if(!SkillManager.getInstance.isLearnSkillAttr(o,SkillManager.getInstance.getLearnSkill(t.getLotteryName())))
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window033"));
               return;
            }
            this.learnSkillWindow = new LearnSkillWindow();
            this.learnSkillWindow.show(o,t,learnSkill);
         }
         if(int(t.getType()) >= ToolType.TOOL_TYPE64 && int(t.getType()) <= ToolType.TOOL_TYPE71)
         {
            if(SkillManager.getInstance.isLearnExSkillFull(o))
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("exskill04"));
               return;
            }
            if(!SkillManager.getInstance.isCanLearnExSkill(o) || !SkillManager.getInstance.judgeToolForExSkill(o,int(t.getType())))
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("exskill01"));
               return;
            }
            this.learnSkillWindow = new LearnSkillWindow();
            this.learnSkillWindow.show(o,t,learnSkill);
         }
         else if(t.getType() == ToolType.TOOL_TYPE6 + "")
         {
            if(o.getAllSkills() == null || o.getAllSkills().length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window034"));
               return;
            }
            skills = new Array();
            skills = o.getUpSkill(t,SkillManager.getInstance);
            if(skills == null || skills.length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window035"));
               return;
            }
            skills = checkSkillGrade(o,skills);
            if(skills == null || skills.length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window036"));
               return;
            }
            upSkill();
         }
      }
      
      private function onIntensify(param1:MouseEvent) : void
      {
         if(this.panel["_org"].numChildren == 0)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window038"));
            return;
         }
         if(this.panel["_tool"].numChildren == 0)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window039"));
            return;
         }
         this.useTool();
      }
      
      private function removeBtEvent() : void
      {
         this.panel["compose"].removeEventListener(MouseEvent.CLICK,this.onIntensify);
      }
      
      private function setLoction(param1:int, param2:int) : void
      {
         this.panel.x = param1;
         this.panel.y = param2;
      }
      
      private function show() : void
      {
         this.panel.visible = true;
      }
      
      private function showCompSuccess() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Organism = null;
         var _loc4_:int = 0;
         FuncKit.clearAllChildrens(this.panel["_success"]);
         if(this.panel["_org"].numChildren == 0 || this.panel["_tool"].numChildren == 0)
         {
            this.panel["_success"].addChild(FuncKit.getNumEffect("0p","Feared"));
            return;
         }
         var _loc1_:Tool = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
         if(_loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY || _loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_YAOSI || _loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_BUXIU || _loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_YONGHENG || _loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_TAISHANG || _loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_HUNDUN || _loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_WUJI)
         {
            _loc2_ = XmlQualityConfig.getInstance().getUpRatio(((this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism).getQuality_name());
            this.panel["_success"].addChild(FuncKit.getNumEffect(_loc2_ + "p","Feared"));
            return;
         }
         if(_loc1_.getOrderId() == ToolManager.TOOL_COMP_QUALITY_MOSHEN)
         {
            _loc3_ = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            _loc4_ = XmlQualityConfig.getInstance().getID(_loc3_.getQuality_name());
            if(_loc4_ >= 12 || _loc4_ <= 2)
            {
               this.panel["_success"].addChild(FuncKit.getNumEffect("0p","Feared"));
               return;
            }
            this.panel["_success"].addChild(FuncKit.getNumEffect("3p","Feared"));
         }
         else if(_loc1_.getOrderId() == ToolManager.TOOL_COMP_HP_1 || _loc1_.getOrderId() == ToolManager.TOOL_COMP_HP_2 || _loc1_.getOrderId() == ToolManager.TOOL_COMP_HP_3 || _loc1_.getOrderId() == ToolManager.TOOL_COMP_PULLULATION || this.judgeId(_loc1_.getOrderId()))
         {
            this.panel["_success"].addChild(FuncKit.getNumEffect("100p","Feared"));
            return;
         }
         if(_loc1_.getType() == ToolType.TOOL_TYPE5 + "")
         {
            this.panel["_success"].addChild(FuncKit.getNumEffect("100p","Feared"));
            return;
         }
         if(_loc1_.getType() == ToolType.TOOL_TYPE6 + "")
         {
            this.panel["_success"].addChild(FuncKit.getNumEffect("wwp","Feared"));
            return;
         }
         if(int(_loc1_.getType()) >= ToolType.TOOL_TYPE64 && int(_loc1_.getType()) <= ToolType.TOOL_TYPE71)
         {
            this.panel["_success"].addChild(FuncKit.getNumEffect("100p","Feared"));
            return;
         }
      }
      
      private function judgeId(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(compToolArr.length);
         while(_loc2_ < _loc3_)
         {
            if(param1 == compToolArr[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function showOrgChange(param1:int, param2:Organism, param3:Organism) : void
      {
         PlantsVsZombies.playFireworks(3);
         this.evolPrizeWindow = new EvolutionPrizeWindow();
         this.evolPrizeWindow.show(param1,param2,param3);
      }
      
      private function showToolsUse(param1:String, param2:String, param3:Object) : void
      {
         PlantsVsZombies.playFireworks(3);
         this.useToolResultWindow = new ComposePrizeWindow();
         this.useToolResultWindow.show(param1,param2,param3);
      }
      
      private function showFailIntensify(param1:Point, param2:Point, param3:String) : void
      {
         if(this.upQualityfailTip == null)
         {
            this.upQualityfailTip = new AdaptTip(120,30);
         }
         this.upQualityfailTip.creatInfoText(param3,"","",3);
         this.panel.addChild(this.upQualityfailTip);
         this.upQualityfailTip.visible = false;
         this.upQualityfailTip.goAnimate(param1,param2);
      }
      
      private function toolCompose_check(param1:Object) : MovieClip
      {
         if(param1 is Organism)
         {
            if(this.panel["_org"].numChildren != 0)
            {
               FuncKit.clearAllChildrens(this.panel["_org"]);
            }
            return this.panel["_org"];
         }
         if(param1 is Tool)
         {
            if(this.panel["_tool"].numChildren != 0)
            {
               FuncKit.clearAllChildrens(this.panel["_tool"]);
            }
            return this.panel["_tool"];
         }
         return null;
      }
      
      private function useTool() : void
      {
         var orgCompose:Function;
         var st:String = null;
         var actionWindow:ActionWindow = null;
         var toolid:int = 0;
         var toolname:String = null;
         var toolnames:String = null;
         var compTool:Tool = (this.panel["_tool"].getChildAt(0) as ComposePicLabel).getO() as Tool;
         var compOrg:Organism = (this.panel["_org"].getChildAt(0) as ComposePicLabel).getO() as Organism;
         var api:String = "";
         this.orgQualityLevel = XmlQualityConfig.getInstance().getID(compOrg.getQuality_name());
         if(int(compTool.getType()) == ToolType.TOOL_TYPE82 || int(compTool.getType()) == ToolType.TOOL_TYPE83)
         {
            orgCompose = function():void
            {
            };
            st = int(compTool.getType()) == ToolType.TOOL_TYPE82 ? "确定使用变身卡？" : "确定使用还原卡？";
            actionWindow = new ActionWindow();
            actionWindow.init(1,Icon.SYSTEM,compTool.getName(),st,orgCompose,true);
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_PULLULATION)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_PULLULATION,ORG_PULLULATION,compOrg.getId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_MOSHEN)
         {
            if(this.orgQualityLevel < QualityManager.YOUXIU || this.orgQualityLevel >= QualityManager.MOSHEN)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window175"));
               return;
            }
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_QUALITY_12_UP,ORG_QUALITY_MOSHEN,compOrg.getId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY || compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_YAOSI || compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_BUXIU || compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_YONGHENG || compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_TAISHANG || compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_HUNDUN || compTool.getOrderId() == ToolManager.TOOL_COMP_QUALITY_WUJI)
         {
            if(XmlQualityConfig.getInstance().getID(compOrg.getQuality_name()) >= QualityManager.WUJI)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window167"));
               return;
            }
            if(XmlQualityConfig.getInstance().getID(compOrg.getQuality_name()) >= QualityManager.MOSHEN)
            {
               if(compTool.getOrderId() != QualityManager.getQualityIdByLevel(this.orgQualityLevel))
               {
                  toolid = QualityManager.getQualityIdByLevel(XmlQualityConfig.getInstance().getID(compOrg.getQuality_name()));
                  toolname = new Tool(toolid).getName();
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window169",toolname));
                  return;
               }
               this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_QUALITY,ORG_QUALITY_NEW,compOrg.getId());
            }
            else
            {
               if(compTool.getOrderId() != ToolManager.TOOL_COMP_QUALITY)
               {
                  toolnames = new Tool(ToolManager.TOOL_COMP_QUALITY).getName();
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window169",toolnames));
                  return;
               }
               this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_QUALITY,ORG_QUALITY,compOrg.getId());
            }
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_HP_1)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_HP,ORG_HP_1,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_HP_2)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_HP,ORG_HP_2,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_HP_3)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_HP,ORG_HP_3,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_G || compTool.getOrderId() == ToolManager.TOOL_COMP_LIFE_INTENSIFY_BOOK_H)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INTENSIFY_COMPOSE_LIFE,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_G || compTool.getOrderId() == ToolManager.TOOL_COMP_ATTACK_INTENSIFY_BOOK_H)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INDENTIFY_COMPOSE_ATTACK,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_G || compTool.getOrderId() == ToolManager.TOOL_COMP_DUCK_INTENSIFY_BOOK_H)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INDENTIFY_COMPOSE_DUCK,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_G || compTool.getOrderId() == ToolManager.TOOL_COMP_SPEED_INTENSIFY_BOOK_H)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INDENTIFY_COMPOSE_SPEED,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_G || compTool.getOrderId() == ToolManager.TOOL_COMP_DOOM_INTENSIFY_BOOK_H)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INDENTIFY_COMPOSE_DOOM,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_G)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INDENTIFY_COMPOSE_NEW_MISS,compOrg.getId(),compTool.getOrderId());
         }
         else if(compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_A || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_B || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_C || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_D || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_E || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_F || compTool.getOrderId() == ToolManager.TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_G)
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INDETIFY_COMPOSE,INDENTIFY_COMPOSE_NEW_PRE,compOrg.getId(),compTool.getOrderId());
         }
         else
         {
            this.learnAndUpSkill(compOrg,compTool);
         }
      }
   }
}

