package pvz.compose.panel
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.ComposePicLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.QualityManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.compose.ComposeOrgWindow;
   import utils.BigInt;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ComposeOrgComposePanel extends Sprite implements IDestroy, IConnection
   {
      
      private static const MAX:int = 10;
      
      private static const COMPOSE_GRADE:int = 100;
      
      private var _toolsnum:Number = 0;
      
      private var _org1:Organism = null;
      
      private var _org2:Organism = null;
      
      private var _tool:Tool = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var composeOrgWindow:ComposeOrgWindow = null;
      
      private var changeMaterial:Function = null;
      
      private var clearMask:Function = null;
      
      private var labelvisible:Function = null;
      
      private var panel:MovieClip = null;
      
      private var setJiantou:Function = null;
      
      public function ComposeOrgComposePanel(param1:Function, param2:Function, param3:Function, param4:Function, param5:int = 0, param6:int = 0)
      {
         super();
         var _loc7_:Class = DomainAccess.getClass("orgComposePanel");
         this.panel = new _loc7_();
         this.panel.visible = false;
         this.panel.gotoAndStop(1);
         this.addChild(this.panel);
         this.changeMaterial = param2;
         this.clearMask = param1;
         this.labelvisible = param3;
         this.setJiantou = param4;
         this.setBtEvent();
         this.setLoction(param5,param6);
         this.setCatalyst();
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
            var _loc2_:int = 0;
            while(_loc2_ < ToolManager.compToolsComp.length / 2)
            {
               if(param1.getOrderId() < ToolManager.compToolsComp[2 * _loc2_ + 1] && param1.getOrderId() > ToolManager.compToolsComp[2 * _loc2_])
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
      
      private function show() : void
      {
         this.setTool();
         this.changeTool();
         this.showInfo();
         this.setToolText();
         this.panel.visible = true;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callOOOO(param2,param3,rest[0],rest[1],rest[2],rest[3]);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:String = param2.hp;
         var _loc4_:String = param2.miss;
         var _loc5_:String = param2.precision;
         var _loc6_:String = param2.speed;
         var _loc7_:String = param2.attack;
         var _loc8_:String = param2.new_miss;
         var _loc9_:String = param2.new_precision;
         FuncKit.clearAllChildrens(this.panel["_mc_org_2"]);
         FuncKit.clearAllChildrens(this.panel["_mc_tool_1"]);
         this.playerManager.removeOrganism(this._org2);
         this.playerManager.getPlayer().useTools(this._tool.getOrderId(),1);
         this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_CATALYST,this._toolsnum);
         this._toolsnum = 0;
         this.changeTool(1);
         this._tool = null;
         this._org2 = null;
         this.showResultWindow(this._org1,_loc7_,_loc3_,_loc4_,_loc5_,_loc6_,_loc9_,_loc8_);
         this._org1.setCompAtt(this._org1.getCompAtt() + Number(_loc7_));
         this._org1.setCompHp(this._org1.getCompHp() + Number(_loc3_));
         this._org1.setCompMiss(this._org1.getCompMiss() + Number(_loc4_));
         this._org1.setCompPre(this._org1.getCompPre() + Number(_loc5_));
         this._org1.setCompSpeed(this._org1.getCompSpeed() + Number(_loc6_));
         this._org1.setCompNewMiss(this._org1.getCompNewMiss() + Number(_loc8_));
         this._org1.setCompNewPre(this._org1.getCompNewPre() + Number(_loc9_));
         this._org1.setAttack(this._org1.getAttack() + Number(_loc7_));
         var _loc10_:BigInt = new BigInt(_loc3_);
         var _loc11_:String = BigInt.plus(this._org1.getHp_max(),_loc3_).toString();
         this._org1.setHp_max(_loc11_);
         this._org1.setMiss(this._org1.getMiss() + Number(_loc4_));
         this._org1.setPrecision(this._org1.getPrecision() + Number(_loc5_));
         this._org1.setSpeed(this._org1.getSpeed() + Number(_loc6_));
         this._org1.setNewMiss(this._org1.getNewMiss() + Number(_loc8_));
         this._org1.setNewPrecision(this._org1.getNewPrecision() + Number(_loc9_));
         this._org1.setBattleE(param2.fight);
         (this.panel["_mc_org_1"].getChildAt(0) as ComposePicLabel).updateO(this._org1);
         this.playerManager.getPlayer().updateOrg(this._org1);
         this.changeMaterial(0);
         this.showInfo();
      }
      
      private function showResultWindow(param1:Organism, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String) : void
      {
         PlantsVsZombies.playFireworks(3);
         this.composeOrgWindow = new ComposeOrgWindow();
         this.composeOrgWindow.show(param1,param2,param3,param4,param5,param6,param7,param8);
         PlantsVsZombies.playFireworks(3);
         PlantsVsZombies.playSounds(SoundManager.GRADE);
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function setCatalyst() : void
      {
         this.panel["_mc_tool_2"].addChild(new ComposePicLabel(new Tool(ToolManager.TOOL_COMP_CATALYST),null,false,0));
      }
      
      private function setBtEvent() : void
      {
         this.panel["_bt_compose"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_bt_add"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_bt_dec"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setTool() : void
      {
         var _loc1_:Tool = this.playerManager.getPlayer().getTool(ToolManager.TOOL_COMP_CATALYST);
         if(_loc1_ == null)
         {
            this._toolsnum = 0;
         }
         else if(_loc1_.getNum() > 1)
         {
            this._toolsnum = 1;
         }
         else
         {
            this._toolsnum = _loc1_.getNum();
         }
      }
      
      private function changeTool(param1:int = 0) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Tool = this.playerManager.getPlayer().getTool(ToolManager.TOOL_COMP_CATALYST);
         if(_loc2_ == null)
         {
            if(this.panel["_mc_num"].numChildren != 0)
            {
               FuncKit.clearAllChildrens(this.panel["_mc_num"]);
            }
            _loc3_ = FuncKit.getNumEffect(0 + "","Small");
            _loc3_.x = -_loc3_.width / 2;
            this.panel["_mc_num"].addChild(_loc3_);
            FuncKit.setNoColor(this.panel["_mc_tool_2"]);
            return;
         }
         if(param1 > 0)
         {
            if(this._toolsnum + param1 > _loc2_.getNum() || this._toolsnum == MAX)
            {
               return;
            }
         }
         else if(param1 < 0)
         {
            if(this._toolsnum - param1 < 0)
            {
               return;
            }
         }
         if(this._toolsnum + param1 < 0)
         {
            return;
         }
         this._toolsnum += param1;
         if(this._toolsnum > 0)
         {
            FuncKit.clearNoColorState(this.panel["_mc_tool_2"]);
         }
         else
         {
            FuncKit.setNoColor(this.panel["_mc_tool_2"]);
         }
         if(this.panel["_mc_num"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.panel["_mc_num"]);
         }
         _loc3_ = FuncKit.getNumEffect(this._toolsnum + "","Small");
         _loc3_.x = -_loc3_.width / 2;
         this.panel["_mc_num"].addChild(_loc3_);
         this.setToolText();
         this.showInfo();
      }
      
      private function setToolText() : void
      {
         this.panel["_txt_num"].text = "";
         var _loc1_:Tool = this.playerManager.getPlayer().getTool(ToolManager.TOOL_COMP_CATALYST);
         if(_loc1_ != null && _loc1_.getNum() > this._toolsnum)
         {
            this.panel["_txt_num"].text = LangManager.getInstance().getLanguage("window001",_loc1_.getNum() - this._toolsnum);
         }
      }
      
      public function destroy() : void
      {
         this.removeBtEvent();
      }
      
      private function isCompose() : Boolean
      {
         if(this._org1 == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window002"));
            return false;
         }
         if(this._org2 == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window003"));
            return false;
         }
         if(this._tool == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window004"));
            return false;
         }
         if(Boolean(this._org2.getIsArena() || this._org2.getIsPossession()) || Boolean(this._org2.getGardenId()) || this._org2.getIsSeverBattle())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window006"));
            return false;
         }
         return true;
      }
      
      private function orgCompose() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_COMPOSE,0,this._org1.getId(),this._org2.getId(),this._tool.getOrderId(),this._toolsnum);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionWindow = null;
         if(param1.currentTarget.name == "_bt_compose")
         {
            if(this.isCompose())
            {
               _loc2_ = new ActionWindow();
               _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window007"),this.getActionInfo(),this.orgCompose,true);
            }
         }
         else if(param1.currentTarget.name == "_bt_add")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.changeTool(1);
         }
         else if(param1.currentTarget.name == "_bt_dec")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.changeTool(-1);
         }
      }
      
      private function getActionInfo() : String
      {
         return this._org2.getName() + LangManager.getInstance().getLanguage("window008");
      }
      
      private function removeBtEvent() : void
      {
         this.panel["_bt_compose"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_bt_add"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_bt_dec"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function toolCompose_check(param1:Object) : MovieClip
      {
         if(param1 is Organism)
         {
            if(this.panel["_mc_org_1"].numChildren == 0)
            {
               if((param1 as Organism).getGrade() < COMPOSE_GRADE)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window009",COMPOSE_GRADE));
                  return null;
               }
               this._org1 = param1 as Organism;
               return this.panel["_mc_org_1"];
            }
            if(this.panel["_mc_org_2"].numChildren == 0)
            {
               this._org2 = param1 as Organism;
               return this.panel["_mc_org_2"];
            }
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window010"));
            return null;
         }
         if(param1 is Tool)
         {
            if(this.panel["_mc_tool_1"].numChildren != 0)
            {
               FuncKit.clearAllChildrens(this.panel["_mc_tool_1"]);
            }
            this._tool = param1 as Tool;
            return this.panel["_mc_tool_1"];
         }
         return null;
      }
      
      public function add(param1:Object) : Boolean
      {
         this.clearTool(param1 as Tool);
         var _loc2_:MovieClip = this.toolCompose_check(param1);
         if(_loc2_ == null)
         {
            return false;
         }
         if(this._org2 != null && XmlQualityConfig.getInstance().getID(this._org2.getQuality_name()) >= 3)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window011",this._org2.getName()));
         }
         var _loc3_:ComposePicLabel = new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_ORG_COMPOSE);
         _loc2_.addChild(_loc3_);
         this.showInfo();
         if(this.panel["_mc_org_1"].numChildren > 0 && this.panel["_mc_org_2"].numChildren > 0 && this.panel["_mc_tool_1"].numChildren == 0 && chooseToolComp(this.playerManager.getPlayer().getAllTools()).length > 0)
         {
            this.setJiantou(true);
         }
         else
         {
            this.setJiantou(false);
         }
         return true;
      }
      
      public function clear(param1:Object) : void
      {
         if(param1 is Organism)
         {
            this.clearOrg(param1 as Organism);
         }
         else if(param1 is Tool)
         {
            this.clearTool(param1 as Tool);
         }
         this.showInfo();
         if(this.panel["_mc_org_1"].numChildren > 0 && this.panel["_mc_org_2"].numChildren > 0 && this.panel["_mc_tool_1"].numChildren == 0)
         {
            this.setJiantou(true);
         }
         else
         {
            this.setJiantou(false);
         }
      }
      
      private function clearOrg(param1:Organism) : void
      {
         var _loc2_:ComposePicLabel = null;
         if(this.panel["_mc_org_1"].numChildren > 0)
         {
            _loc2_ = this.panel["_mc_org_1"].getChildAt(0);
            if(_loc2_.getO() as Organism == param1)
            {
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.panel["_mc_org_1"]);
               this._org1 = null;
               return;
            }
         }
         if(this.panel["_mc_org_2"].numChildren > 0)
         {
            _loc2_ = this.panel["_mc_org_2"].getChildAt(0);
            if(_loc2_.getO() as Organism == param1)
            {
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.panel["_mc_org_2"]);
               this._org2 = null;
               return;
            }
         }
      }
      
      private function clearTool(param1:Tool) : void
      {
         var _loc2_:ComposePicLabel = null;
         if(param1 == null)
         {
            return;
         }
         if(this.panel["_mc_tool_1"].numChildren > 0)
         {
            _loc2_ = this.panel["_mc_tool_1"].getChildAt(0);
            this.labelvisible(_loc2_.getO(),false);
            FuncKit.clearAllChildrens(this.panel["_mc_tool_1"]);
            this._tool = null;
         }
      }
      
      private function setLoction(param1:int, param2:int) : void
      {
         this.panel.x = param1;
         this.panel.y = param2;
      }
      
      private function showInfo() : void
      {
         this.clearInfo();
         this.panel["_txt_info2"].text = this.getComposeResult();
      }
      
      private function clearInfo() : void
      {
         this.panel["_txt_info"].text = "";
         this.panel["_txt_info2"].text = "";
         if(this.panel["_mc_addnum"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.panel["_mc_addnum"]);
         }
      }
      
      private function getComposeResult() : String
      {
         var org:Organism;
         var tool:Tool;
         var getComposeOrg:Function = function(param1:Boolean = true):Organism
         {
            if(param1)
            {
               if(panel["_mc_org_1"].numChildren > 0)
               {
                  return (panel["_mc_org_1"].getChildAt(0) as ComposePicLabel).getO() as Organism;
               }
               return null;
            }
            if(panel["_mc_org_2"].numChildren > 0)
            {
               return (panel["_mc_org_2"].getChildAt(0) as ComposePicLabel).getO() as Organism;
            }
            return null;
         };
         var morg:Organism = getComposeOrg();
         if(morg == null)
         {
            return LangManager.getInstance().getLanguage("window002");
         }
         org = getComposeOrg(false);
         if(org == null)
         {
            return LangManager.getInstance().getLanguage("window003");
         }
         tool = null;
         if(this.panel["_mc_tool_1"].numChildren > 0)
         {
            tool = (this.panel["_mc_tool_1"].getChildAt(0) as ComposePicLabel).getO() as Tool;
            this.showComposeInfo(morg,org,tool);
            return "";
         }
         return LangManager.getInstance().getLanguage("window004");
      }
      
      private function showComposeInfo(param1:Organism, param2:Organism, param3:Tool) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
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
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         this.clearInfo();
         var _loc4_:String = param1.getName();
         var _loc5_:Number = 0;
         var _loc6_:String = "";
         switch(param3.getOrderId())
         {
            case ToolManager.TOOL_COMP_ATT_1078:
               _loc8_ = param1.getAttack() / (1 + param1.getSoulLevel() * 0.03);
               _loc9_ = param2.getAttack() / (1 + param2.getSoulLevel() * 0.03);
               _loc10_ = Math.max(_loc8_,_loc9_);
               if(_loc10_ < 10000000000000000000)
               {
                  _loc5_ = Math.ceil(_loc9_ * Math.min(Math.pow(_loc9_ / _loc8_,0.5),1) * (0.38 + this._toolsnum * 0.6 / 20));
               }
               else
               {
                  _loc5_ = Math.ceil(_loc9_ * (0.38 + this._toolsnum * 0.6 / 20) * (1 - _loc10_ / (_loc10_ + 200000000000000000000)));
               }
               _loc6_ = LangManager.getInstance().getLanguage("window012");
               break;
            case ToolManager.TOOL_COMP_SUPER_HP_BOOK:
               _loc11_ = param1.getHp_max().toNumber() / (1 + param1.getSoulLevel() * 0.03);
               _loc12_ = param2.getHp_max().toNumber() / (1 + param2.getSoulLevel() * 0.03);
               _loc13_ = Math.max(_loc11_,_loc12_);
               if(_loc13_ >= 1.0e+24)
               {
                  _loc5_ = _loc12_ * (0.3 + this._toolsnum / 20) * Number(1 - Number(_loc13_ / (_loc13_ + 2e+25)));
               }
               else if(_loc13_ >= 100000000000000000000)
               {
                  _loc5_ = _loc12_ * 0.595 * (0.3 + this._toolsnum / 20);
               }
               else
               {
                  _loc5_ = _loc12_ * Math.min(Math.pow(_loc12_ / _loc11_,0.5),1) * (0.3 + this._toolsnum / 20);
               }
               _loc6_ = LangManager.getInstance().getLanguage("window016");
               break;
            case ToolManager.TOOL_COMP_ATT:
               _loc8_ = param1.getAttack() / (1 + param1.getSoulLevel() * 0.03);
               _loc9_ = param2.getAttack() / (1 + param2.getSoulLevel() * 0.03);
               _loc10_ = Math.max(_loc8_,_loc9_);
               if(_loc10_ < 10000000000000000000)
               {
                  _loc5_ = Math.ceil(_loc9_ * Math.min(Math.pow(_loc9_ / _loc8_,0.5),1) * (0.3 + this._toolsnum * 0.6 / 20));
               }
               else
               {
                  _loc5_ = Math.ceil(_loc9_ * (0.3 + this._toolsnum * 0.6 / 20) * (1 - _loc10_ / (_loc10_ + 200000000000000000000)));
               }
               _loc6_ = LangManager.getInstance().getLanguage("window012");
               break;
            case ToolManager.TOOL_COMP_MISS:
               _loc14_ = param1.getMiss() / (1 + param1.getSoulLevel() * 0.03);
               _loc15_ = param2.getMiss() / (1 + param2.getSoulLevel() * 0.03);
               _loc16_ = Math.max(_loc14_,_loc15_);
               if(_loc16_ >= 100000000000000000000)
               {
                  _loc5_ = _loc15_ * (0.3 + this._toolsnum / 20) * (1 - _loc16_ / (_loc16_ + 2e+21));
               }
               else
               {
                  _loc5_ = _loc15_ * Math.min(Math.pow(_loc15_ / _loc14_,0.5),1) * (0.3 + this._toolsnum / 20);
               }
               _loc6_ = LangManager.getInstance().getLanguage("window013");
               break;
            case ToolManager.TOOL_COMP_SPEED:
               _loc17_ = param2.getSpeed() / (1 + param2.getSoulLevel() * 0.03);
               _loc5_ = _loc17_ * (0.1 + this._toolsnum / 20);
               _loc6_ = LangManager.getInstance().getLanguage("window014");
               break;
            case ToolManager.TOOL_COMP_PRE:
               _loc18_ = param1.getPrecision() / (1 + param1.getSoulLevel() * 0.03);
               _loc19_ = param2.getPrecision() / (1 + param2.getSoulLevel() * 0.03);
               _loc20_ = Math.max(_loc18_,_loc19_);
               if(_loc20_ >= 100000000000000000000)
               {
                  _loc5_ = _loc19_ * (0.3 + this._toolsnum / 20) * (1 - _loc20_ / (_loc20_ + 2e+21));
               }
               else
               {
                  _loc5_ = _loc19_ * Math.min(Math.pow(_loc19_ / _loc18_,0.5),1) * (0.3 + this._toolsnum / 20);
               }
               _loc6_ = LangManager.getInstance().getLanguage("window015");
               break;
            case ToolManager.TOOL_COMP_HP:
               _loc21_ = param1.getHp_max().toNumber() / (1 + param1.getSoulLevel() * 0.03);
               _loc22_ = param2.getHp_max().toNumber() / (1 + param2.getSoulLevel() * 0.03);
               _loc23_ = Math.max(_loc21_,_loc22_);
               if(_loc23_ >= 100000000000000000000)
               {
                  _loc5_ = _loc22_ * (0.3 + this._toolsnum / 20) * Number(1 - Number(_loc23_ / (_loc23_ + 2e+21)));
               }
               else
               {
                  _loc5_ = _loc22_ * Math.min(Math.pow(_loc22_ / _loc21_,0.5),1) * (0.3 + this._toolsnum / 20);
               }
               _loc6_ = LangManager.getInstance().getLanguage("window016");
               break;
            case ToolManager.TOOL_COMP_NEW_PRECISION:
               _loc24_ = param1.getNewPrecision();
               _loc25_ = param2.getNewPrecision();
               _loc26_ = Math.max(_loc24_,_loc25_);
               if(_loc26_ >= 100000000000000000000)
               {
                  _loc5_ = _loc25_ * (0.3 + this._toolsnum / 20) * (1 - _loc26_ / (_loc26_ + 2e+21));
               }
               else
               {
                  _loc5_ = _loc25_ * Math.min(Math.pow(_loc25_ / _loc24_,0.5),1) * (0.3 + this._toolsnum / 20);
               }
               _loc6_ = LangManager.getInstance().getLanguage("window177");
               break;
            case ToolManager.TOOL_COMP_NEW_MISS:
               _loc27_ = param1.getNewMiss();
               _loc28_ = param2.getNewMiss();
               _loc29_ = Math.max(_loc27_,_loc28_);
               if(_loc29_ >= 100000000000000000000)
               {
                  _loc5_ = _loc28_ * (0.3 + this._toolsnum / 20) * (1 - _loc29_ / (_loc29_ + 2e+21));
               }
               else
               {
                  _loc5_ = _loc28_ * Math.min(Math.pow(_loc28_ / _loc27_,0.5),1) * (0.3 + this._toolsnum / 20);
               }
               _loc6_ = LangManager.getInstance().getLanguage("window176");
         }
         if(param3.getOrderId() != ToolManager.TOOL_COMP_NEW_PRECISION && param3.getOrderId() != ToolManager.TOOL_COMP_NEW_MISS)
         {
            _loc5_ *= 1 + param1.getSoulLevel() * 0.03;
         }
         if(param1.getWidth() > 1 && param3.getOrderId() != ToolManager.TOOL_COMP_SPEED)
         {
            _loc5_ *= 1.1;
         }
         var _loc7_:Number = QualityManager.getQualityPullulateQue(XmlQualityConfig.getInstance().getID(param1.getQuality_name()));
         if(param3.getOrderId() != ToolManager.TOOL_COMP_SPEED)
         {
            _loc5_ *= _loc7_;
         }
         _loc4_ = _loc4_ + _loc6_ + LangManager.getInstance().getLanguage("window017");
         this.panel["_txt_info"].text = _loc4_;
         this.panel["_mc_addnum"].addChild(FuncKit.getNumDisplayObject(Math.ceil(_loc5_)));
      }
   }
}

