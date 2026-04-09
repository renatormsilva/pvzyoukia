package pvz.storage
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.ui.panel.BaseWindow;
   import entity.ExSkill;
   import entity.Goods;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.ArtWordsManager;
   import manager.JSManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.QualityManager;
   import manager.SkillManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.compose.EvolutionPrizeWindow;
   import pvz.compose.NewSkillWindow;
   import pvz.compose.panel.ComposeWindowNew;
   import pvz.genius.GeniusControl;
   import pvz.genius.tips.PlantsGeniusTips;
   import pvz.genius.vo.Genius;
   import pvz.shop.ShopWindow;
   import pvz.shop.rpc.Shop_rpc;
   import tip.AdaptTip;
   import tip.DialogTip;
   import tip.ExSkillTip;
   import tip.Ex_Unstudy_Tip;
   import tip.InfoShowTip;
   import tip.OrgComposeTip;
   import tip.OrgGrowAreaTips;
   import tip.SkillTip;
   import utils.FuncKit;
   import utils.M_ClipMotion;
   import utils.Singleton;
   import utils.TextFilter;
   import windows.ActionWindow;
   import windows.DoActionWindow;
   import windows.RechargeWindow;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class OrganismWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      public static const NUM:int = 1;
      
      public static const SELL_ORG:int = 2;
      
      private static const BOOK_BUY:int = 10;
      
      private static var HP:Array = [0,100000,1000000,10000000];
      
      private static const INIT:int = 0;
      
      private static const ORG_PULLULATION:int = 4;
      
      private static const ORG_QUALITY:int = 3;
      
      private static const SCALE_HP_ATT:int = 4;
      
      private static const SELL:int = 1;
      
      private static var SPEED:Array = [0,100,2500,50000];
      
      private static const UPSKILL:int = 2;
      
      private static const UP_EXSKILL:int = 5;
      
      private var _baseArray:Array = null;
      
      private var _getId:int;
      
      private var _getUserNum:int;
      
      private var _mc:MovieClip;
      
      private var _o:Organism;
      
      private var _price:int;
      
      private var _skill_id:int;
      
      private var _type:int;
      
      private var _upGrowArea:Tool;
      
      private var _updateF:Function;
      
      private var _userNum:int;
      
      private var actionWindow:ActionWindow;
      
      private var dialogTip:DialogTip;
      
      private var evolPrizeWindow:EvolutionPrizeWindow;
      
      private var gridNum:int;
      
      private var index:int;
      
      private var newSkillWindow:NewSkillWindow;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var qalityInfoTip:AdaptTip;
      
      private var skillFailTipEndPoint:Point = new Point();
      
      private var skillFailTipStartPoint:Point = new Point();
      
      private var tips:SkillTip;
      
      private var tipsOrg:OrgComposeTip;
      
      private var tipsOrgGrowArea:OrgGrowAreaTips;
      
      private var upQualityfailTip:AdaptTip;
      
      private var upskill:Skill;
      
      private var _geniusTips:PlantsGeniusTips;
      
      private var _txtTips:InfoShowTip;
      
      private var _exSkill_tips:ExSkillTip;
      
      private var _ex_unstudy_tips:Ex_Unstudy_Tip;
      
      private var upExSkill:ExSkill;
      
      public function OrganismWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("organismWindow");
         this._mc = new _loc1_();
         this.textMiaobian();
         this._mc.visible = false;
         if(this.playerManager.getPlayer().getGrade() < PlantsVsZombies.GENIUS_OPEN_LEVEL)
         {
            FuncKit.setNoColor(this._mc["_geniusBtn"]);
         }
         this.addEvent();
         PlantsVsZombies._node.addChild(this._mc);
         this.showExSkillOrNot(true);
      }
      
      private function showExSkillOrNot(param1:Boolean) : void
      {
         this._mc["ex_skill_label"].visible = param1;
         this._mc["ex_skill1"].visible = param1;
         this._mc["ex_skill_btn1"].visible = param1;
         this._mc["_ex_box1"].visible = param1;
         this._mc["up_ex_skill1"].visible = param1;
      }
      
      override public function destroy() : void
      {
         this._exSkill_tips = null;
         this.tips = null;
         this._txtTips = null;
         this._ex_unstudy_tips = null;
         this.removeEvent();
         onHiddenEffect(this._mc);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         PlantsVsZombies.showDataLoading(true);
         if(param3 == SELL)
         {
            _loc5_.callOOO(param2,param3,SELL_ORG,this._o.getId(),NUM);
         }
         else if(param3 == UPSKILL || param3 == UP_EXSKILL)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == ORG_QUALITY || param3 == ORG_PULLULATION)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == INIT)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == BOOK_BUY)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var backComand:Function;
         var str:String = null;
         var news:Skill = null;
         var olds:Skill = null;
         var tool:Tool = null;
         var infoSkill:String = null;
         var new_es:ExSkill = null;
         var old_es:ExSkill = null;
         var need_tool:Tool = null;
         var str1:String = null;
         var str_info:String = null;
         var tem_tool:Tool = null;
         var info_Skill:String = null;
         var org:Organism = null;
         var orgA:Organism = null;
         var infoQua:String = null;
         var shoprpc:Shop_rpc = null;
         var ishasGood:Boolean = false;
         var i:String = null;
         var compTool:Tool = null;
         var doActionWindow:DoActionWindow = null;
         var copTool:Tool = null;
         var info:String = null;
         var type:int = param1;
         var re:Object = param2;
         PlantsVsZombies.showDataLoading(false);
         if(type == SELL)
         {
            PlantsVsZombies.playSounds(SoundManager.MONEY);
            str = LangManager.getInstance().getLanguage("window097",this._o.getGrade(),this._o.getName(),int(re));
            PlantsVsZombies.showSystemErrorInfo(str);
            PlantsVsZombies.changeMoneyOrExp(Number(re),PlantsVsZombies.MONEY);
            if(this._updateF != null)
            {
               this._updateF(StorageWindow.TYPE_ORG,this._o.getId());
            }
         }
         else if(type == UPSKILL)
         {
            news = SkillManager.getInstance.getNextSkillById(int(re.prev_id));
            olds = SkillManager.getInstance.getSkillById(int(re.prev_id));
            tool = new Tool(news.getLearnTool());
            this.playerManager.getPlayer().useTools(tool.getOrderId(),1);
            if(re.now_id == re.prev_id)
            {
               infoSkill = LangManager.getInstance().getLanguage("window159");
               this.showFailIntensify(this.skillFailTipStartPoint,this.skillFailTipEndPoint,infoSkill);
               return;
            }
            PlantsVsZombies.playFireworks(3);
            this._o.upSkill(olds,news);
            this.playerManager.getPlayer().updateOrg(this._o);
            this.newSkillWindow = new NewSkillWindow();
            this.newSkillWindow.show(LangManager.getInstance().getLanguage("window099"),"",news.getInfo(),new Tool(SkillManager.getInstance.getLearnSkill(olds.getGroup()).getLearnTool()),new Tool(SkillManager.getInstance.getLearnSkill(olds.getGroup()).getLearnTool()),news.getGrade(),1);
            this.upDateSkills();
         }
         else if(type == UP_EXSKILL)
         {
            new_es = SkillManager.getInstance.getNextExSkillById(int(re.prev_id));
            old_es = SkillManager.getInstance.getExSkillById(int(re.prev_id));
            need_tool = new Tool(new_es.getLearnTool());
            this.playerManager.getPlayer().useTools(need_tool.getOrderId(),1);
            if(re.now_id == re.prev_id)
            {
               info_Skill = LangManager.getInstance().getLanguage("window159");
               this.showFailIntensify(this.skillFailTipStartPoint,this.skillFailTipEndPoint,info_Skill);
               return;
            }
            PlantsVsZombies.playFireworks(3);
            this._o.upExSkill(old_es,new_es);
            this.playerManager.getPlayer().updateOrg(this._o);
            str1 = LangManager.getInstance().getLanguage("window099");
            str_info = new_es.getInfo();
            tem_tool = new Tool(SkillManager.getInstance.getExSkillByTool(int(old_es.getType() + 63)).getLearnTool());
            this.newSkillWindow = new NewSkillWindow();
            this.newSkillWindow.show(str1,"",str_info,tem_tool,tem_tool,new_es.getGrade(),1);
            this.updateExSkills();
         }
         else if(type == ORG_PULLULATION)
         {
            this.playerManager.getPlayer().useTools(ToolManager.TOOL_COMP_PULLULATION,1);
            org = new Organism();
            org.readOrg(re);
            this.showOrgChange(type,this._o,org);
            this._o.readOrg(re);
            this.playerManager.getPlayer().updateOrg(this._o);
            this.update(this._o);
            this._updateF();
         }
         else if(type == ORG_QUALITY)
         {
            backComand = function():void
            {
               hideNextQuality(null);
               _mc["show_quality"].mouseEnabled = true;
               showOrgChange(type,_o,orgA);
               _o.readOrg(re);
               playerManager.getPlayer().updateOrg(_o);
               update(_o);
               _updateF();
               _mc.mouseEnabled = _mc.mouseChildren = true;
            };
            this.playerManager.getPlayer().useTools(this._type,1);
            orgA = new Organism();
            orgA.readOrg(re);
            if(this._o.getQuality_name() == orgA.getQuality_name())
            {
               infoQua = LangManager.getInstance().getLanguage("window158");
               this.showFailIntensify(new Point(200,250),new Point(200,100),infoQua);
               return;
            }
            this._mc.mouseEnabled = this._mc.mouseChildren = false;
            this._mc["show_quality"].mouseEnabled = false;
            M_ClipMotion.playUpQualityEffect(this._mc["pic"],backComand);
         }
         else if(type == INIT)
         {
            shoprpc = new Shop_rpc();
            this._baseArray = shoprpc.getShopArray(re.goods);
            ishasGood = false;
            for(i in this._baseArray)
            {
               if((this._baseArray[i] as Goods).getId() == this._type)
               {
                  this._userNum = (this._baseArray[i] as Goods).getChangeNum();
                  this._getId = (this._baseArray[i] as Goods).getGoodsId();
                  this._price = (this._baseArray[i] as Goods).getPurchasePrice();
                  ishasGood = true;
               }
            }
            compTool = new Tool(this._type);
            if(ishasGood)
            {
               doActionWindow = new DoActionWindow();
               doActionWindow.init(compTool.getPicId(),0,Icon.TOOL,compTool.getName(),LangManager.getInstance().getLanguage("window128",this._price,compTool.getName()),this.upDateUserBookOne,true,true,this._userNum);
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(LangManager.getInstance().getLanguage("window160",compTool.getName())));
            }
         }
         else if(type == BOOK_BUY)
         {
            copTool = new Tool(re.tool.id);
            info = LangManager.getInstance().getLanguage("window067",re.tool.amount,copTool.getName());
            PlantsVsZombies.showSystemErrorInfo(info);
            this.playerManager.getPlayer().updateTool(re.tool.id,re.tool.amount);
            PlantsVsZombies.changeMoneyOrExp(-this._getUserNum * this._price,PlantsVsZombies.RMB);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
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
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window100"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      public function setUpdateFun(param1:Function) : void
      {
         this._updateF = param1;
      }
      
      public function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._mc.visible = true;
         this.setLoction();
         onShowEffect(this._mc);
         this.addEvent();
         PlantsVsZombies._node.setChildIndex(this._mc,PlantsVsZombies._node.numChildren - 1);
      }
      
      public function upSkill() : void
      {
         if(this.upskill == null || this._o == null)
         {
            return;
         }
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_SKILL_UP,UPSKILL,this._o.getId(),this.upskill.getId());
      }
      
      public function upSkillEvent(param1:MouseEvent) : void
      {
         var _loc4_:Tool = null;
         this.actionWindow = new ActionWindow();
         var _loc2_:int = int(param1.currentTarget.name.substring(7));
         this.upskill = this._o.getAllSkills()[_loc2_ - 1];
         if(SkillManager.getInstance.getNextSkillById(this.upskill.getId()) == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("OrganismWindow001",SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnGrade(),this.upskill.getName(),this.upskill.getGrade() + 1));
            return;
         }
         if(SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnGrade() > this._o.getGrade())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window094",SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnGrade()));
            return;
         }
         var _loc3_:Tool = this.playerManager.getPlayer().getTool(SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnTool());
         if(_loc3_ == null || _loc3_.getNum() < 1)
         {
            this._skill_id = SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnTool();
            _loc4_ = new Tool(this._skill_id);
            this.showTipWindow(_loc4_.getOrderId());
            return;
         }
         this.skillFailTipStartPoint.x = param1.currentTarget.x - 108;
         this.skillFailTipStartPoint.y = param1.currentTarget.y - 16;
         this.skillFailTipEndPoint.x = this.skillFailTipStartPoint.x;
         this.skillFailTipEndPoint.y = this.skillFailTipStartPoint.y - 40;
         this.upSkill();
      }
      
      public function update(param1:Organism) : void
      {
         var temp:Class;
         var mc:MovieClip;
         var p:int;
         var hp_dis:DisplayObject;
         var attack_dis:DisplayObject;
         var precision_dis:DisplayObject;
         var miss_dis:DisplayObject;
         var new_precision_dis:DisplayObject;
         var new_miss_dis:DisplayObject;
         var speed_dis:DisplayObject;
         var hp_wordsType:uint = 0;
         var attack_wordsType:uint = 0;
         var hit_wordsType:uint = 0;
         var miss_wordsType:uint = 0;
         var speed_wordsType:uint = 0;
         var new_miss_wordsType:uint = 0;
         var new_pre_wordsType:uint = 0;
         var o:Organism = param1;
         var setInfoColor:Function = function():void
         {
            if(_o.getAllAddAttackValue() >= HP[3] / SCALE_HP_ATT)
            {
               attack_wordsType = getColor(4);
            }
            else if(_o.getAllAddAttackValue() >= HP[2] / SCALE_HP_ATT)
            {
               attack_wordsType = getColor(3);
            }
            else if(_o.getAllAddAttackValue() >= HP[1] / SCALE_HP_ATT)
            {
               attack_wordsType = getColor(2);
            }
            else if(_o.getAllAddAttackValue() > HP[0] / SCALE_HP_ATT)
            {
               attack_wordsType = getColor(1);
            }
            else
            {
               attack_wordsType = getColor(0);
            }
            if(_o.getAllAddMissValue() >= HP[3] / SCALE_HP_ATT)
            {
               miss_wordsType = getColor(4);
            }
            else if(_o.getAllAddMissValue() >= HP[2] / SCALE_HP_ATT)
            {
               miss_wordsType = getColor(3);
            }
            else if(_o.getAllAddMissValue() >= HP[1] / SCALE_HP_ATT)
            {
               miss_wordsType = getColor(2);
            }
            else if(_o.getAllAddMissValue() > HP[0] / SCALE_HP_ATT)
            {
               miss_wordsType = getColor(1);
            }
            else
            {
               miss_wordsType = getColor(0);
            }
            if(_o.getAllAddPreValue() >= HP[3] / SCALE_HP_ATT)
            {
               hit_wordsType = getColor(4);
            }
            else if(_o.getAllAddPreValue() >= HP[2] / SCALE_HP_ATT)
            {
               hit_wordsType = getColor(3);
            }
            else if(_o.getAllAddPreValue() >= HP[1] / SCALE_HP_ATT)
            {
               hit_wordsType = getColor(2);
            }
            else if(_o.getAllAddPreValue() > HP[0] / SCALE_HP_ATT)
            {
               hit_wordsType = getColor(1);
            }
            else
            {
               hit_wordsType = getColor(0);
            }
            if(_o.getAllAddHpValue() >= HP[3])
            {
               hp_wordsType = getColor(4);
            }
            else if(_o.getAllAddHpValue() >= HP[2])
            {
               hp_wordsType = getColor(3);
            }
            else if(_o.getAllAddHpValue() >= HP[1])
            {
               hp_wordsType = getColor(2);
            }
            else if(_o.getAllAddHpValue() > HP[0])
            {
               hp_wordsType = getColor(1);
            }
            else
            {
               hp_wordsType = getColor(0);
            }
            if(_o.getAllAddSpeedValue() >= SPEED[3])
            {
               speed_wordsType = getColor(4);
            }
            else if(_o.getAllAddSpeedValue() >= SPEED[2])
            {
               speed_wordsType = getColor(3);
            }
            else if(_o.getAllAddSpeedValue() >= SPEED[1])
            {
               speed_wordsType = getColor(2);
            }
            else if(_o.getAllAddSpeedValue() > SPEED[0])
            {
               speed_wordsType = getColor(1);
            }
            else
            {
               speed_wordsType = getColor(0);
            }
            if(_o.getAllAddNewMissValue() >= HP[3] / SCALE_HP_ATT)
            {
               new_miss_wordsType = getColor(4);
            }
            else if(_o.getAllAddNewMissValue() >= HP[2] / SCALE_HP_ATT)
            {
               new_miss_wordsType = getColor(3);
            }
            else if(_o.getAllAddNewMissValue() >= HP[1] / SCALE_HP_ATT)
            {
               new_miss_wordsType = getColor(2);
            }
            else if(_o.getAllAddNewMissValue() > HP[0] / SCALE_HP_ATT)
            {
               new_miss_wordsType = getColor(1);
            }
            else
            {
               new_miss_wordsType = getColor(0);
            }
            if(_o.getAllAddNewPreValue() >= HP[3] / SCALE_HP_ATT)
            {
               new_pre_wordsType = getColor(4);
            }
            else if(_o.getAllAddNewPreValue() >= HP[2] / SCALE_HP_ATT)
            {
               new_pre_wordsType = getColor(3);
            }
            else if(_o.getAllAddNewPreValue() >= HP[1] / SCALE_HP_ATT)
            {
               new_pre_wordsType = getColor(2);
            }
            else if(_o.getAllAddNewPreValue() > HP[0] / SCALE_HP_ATT)
            {
               new_pre_wordsType = getColor(1);
            }
            else
            {
               new_pre_wordsType = getColor(0);
            }
         };
         this.clear();
         this._o = this.playerManager.getPlayer().getOrganismById(o.getId());
         this.showSkillsBG();
         if(this._o.getGardenId() != 0)
         {
            this._mc["light"].visible = true;
         }
         else
         {
            this._mc["light"].visible = false;
         }
         Icon.setUrlIcon(this._mc["pic"],this._o.getPicId(),Icon.ORGANISM_1);
         this._mc["_picid"].text = "NO." + this._o.getOrderId();
         this._mc["_name"].text = this._o.getName() + "";
         (this._mc["atrribute_mc"] as MovieClip).gotoAndStop(this._o.getAttribute_name());
         this._mc["quality"].gotoAndStop(XmlQualityConfig.getInstance().getID(this._o.getQuality_name()));
         this._mc["_purse_amount"].text = this._o.getPurse_amount();
         this._mc["_pullulation"].text = this._o.getPullulation();
         if(this._mc["_grade_pic"] != null)
         {
            FuncKit.clearAllChildrens(this._mc["_grade_pic"]);
         }
         temp = DomainAccess.getClass("grade");
         mc = new temp();
         mc["num"].addChild(FuncKit.getNumEffect("" + this._o.getGrade()));
         mc.x = -mc.width / 2;
         PlantsVsZombies._node["player"]["num_level"].addChild(mc);
         this._mc["_grade_pic"].addChild(mc);
         this._mc["_evolution"].text = "";
         if(this._mc.getChildByName("battlenum") != null)
         {
            this._mc.removeChild(this._mc.getChildByName("battlenum"));
         }
         setInfoColor();
         this._mc["_evolution"].addChild(FuncKit.getNumDisplayObject(this._o.getBattleE(),"Exp",-2));
         p = 100 * ((this._o.getExp() - this._o.getExp_min()) / (this._o.getExp_max() - this._o.getExp_min() + 1));
         this._mc["exp"].scaleX = p / 100;
         this._mc["_exp"].text = p + "%";
         hp_dis = ArtWordsManager.instance.getArtWordByTwoNumber(this._o.getHp().toNumber(),this._o.getHp_max().toNumber(),hp_wordsType,hp_wordsType,14,2,hp_wordsType > 0 ? true : false);
         this._mc["_hp"].addChild(hp_dis);
         hp_dis.x = -Math.floor(hp_dis.width / 2) + 2;
         attack_dis = ArtWordsManager.instance.artWordsDisplay(this._o.getAttack(),attack_wordsType,14,attack_wordsType > 0 ? true : false);
         this._mc["_attack"].addChild(attack_dis);
         attack_dis.x = -Math.floor(attack_dis.width / 2);
         precision_dis = ArtWordsManager.instance.artWordsDisplay(this._o.getPrecision(),hit_wordsType,14,hit_wordsType > 0 ? true : false);
         this._mc["_precision"].addChild(precision_dis);
         precision_dis.x = -Math.floor(precision_dis.width / 2);
         miss_dis = ArtWordsManager.instance.artWordsDisplay(this._o.getMiss(),miss_wordsType,14,miss_wordsType > 0 ? true : false);
         this._mc["_miss"].addChild(miss_dis);
         miss_dis.x = -Math.floor(miss_dis.width / 2);
         new_precision_dis = ArtWordsManager.instance.artWordsDisplay(this._o.getNewPrecision(),new_pre_wordsType,14,new_pre_wordsType > 0 ? true : false);
         this._mc["_new_precision"].addChild(new_precision_dis);
         new_precision_dis.x = -Math.floor(new_precision_dis.width / 2);
         new_miss_dis = ArtWordsManager.instance.artWordsDisplay(this._o.getNewMiss(),new_miss_wordsType,14,new_miss_wordsType > 0 ? true : false);
         this._mc["_new_miss"].addChild(new_miss_dis);
         new_miss_dis.x = -Math.floor(new_miss_dis.width / 2);
         speed_dis = ArtWordsManager.instance.artWordsDisplay(this._o.getSpeed(),speed_wordsType,14,speed_wordsType > 0 ? true : false);
         this._mc["_speed"].addChild(speed_dis);
         speed_dis.x = -Math.floor(speed_dis.width / 2);
         this.upDateSkills();
         this.updateExSkills();
         this.getStudySkill(XmlQualityConfig.getInstance().getID(this._o.getQuality_name()));
         if(XmlQualityConfig.getInstance().getID(this._o.getQuality_name()) >= QualityManager.WUJI)
         {
            this._mc["show_quality"].visible = false;
         }
         else
         {
            this._mc["show_quality"].visible = true;
         }
      }
      
      private function addEvent() : void
      {
         this._mc["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["sell"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_box1"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_box2"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_box3"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_box4"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_hp"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_attack"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_precision"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_miss"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_speed"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["quality"].addEventListener(MouseEvent.ROLL_OVER,this.showQualityArea);
         this._mc["quality"].addEventListener(MouseEvent.ROLL_OUT,this.hideNextQuality);
         this._mc["_new_precision"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_new_miss"].addEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_pullulation"].addEventListener(MouseEvent.ROLL_OVER,this.showGrowArea);
         this._mc["show_growArea"].addEventListener(MouseEvent.CLICK,this.useBook);
         this._mc["show_quality"].addEventListener(MouseEvent.CLICK,this.useBook);
         this._mc["upskill1"].addEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["upskill2"].addEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["upskill3"].addEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["upskill4"].addEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["_left"].addEventListener(MouseEvent.CLICK,this.onLeft);
         this._mc["_right"].addEventListener(MouseEvent.CLICK,this.onRight);
         this._mc["studySkill_1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_3"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_4"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_1"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["studySkill_2"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["studySkill_3"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["studySkill_4"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["no_skill_1"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["no_skill_2"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["no_skill_3"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["_geniusBtn"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_geniusBtn"].addEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["_geniusBtn"].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc["hp_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["miss_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["armor_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["speed_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["attack_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["hitRate_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["penetrate_txt"].addEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["ex_skill_btn1"].addEventListener(MouseEvent.CLICK,this.onExSkillBtnClick);
         this._mc["ex_skill_btn1"].addEventListener(MouseEvent.ROLL_OVER,this.onExSkillBtnOver);
         this._mc["up_ex_skill1"].addEventListener(MouseEvent.CLICK,this.onExSkillUpClick);
         this._mc["_ex_box1"].addEventListener(MouseEvent.ROLL_OVER,this.onOverExSkill);
      }
      
      private function onExSkillBtnOver(param1:MouseEvent) : void
      {
         var _loc2_:ExSkill = null;
         var _loc3_:Array = SkillManager.getInstance.getCanLearnExSkills(this._o);
         if(_loc3_.length > 0)
         {
            _loc2_ = _loc3_[0];
            this._ex_unstudy_tips = new Ex_Unstudy_Tip();
            this._ex_unstudy_tips.setOrgtip(param1.currentTarget as InteractiveObject,_loc2_);
            this._ex_unstudy_tips.setLoction(130,310);
         }
      }
      
      private function onExSkillUpClick(param1:MouseEvent) : void
      {
         var _loc3_:Tool = null;
         var _loc2_:int = int(param1.currentTarget.name.substring(12));
         this.upExSkill = this._o.getAllExSkills()[_loc2_];
         if(SkillManager.getInstance.getNextExSkillById(this.upExSkill.getId()) == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("exskill06"));
            return;
         }
         if(SkillManager.getInstance.getNextExSkillById(this.upExSkill.getId()).getLearnGrade() > this._o.getGrade())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window094",SkillManager.getInstance.getNextExSkillById(this.upExSkill.getId()).getLearnGrade()));
            return;
         }
         if(this.upExSkill.getGrade() > 0)
         {
            _loc3_ = this.playerManager.getPlayer().getTool(SkillManager.getInstance.getNextExSkillById(this.upExSkill.getId()).getLearnTool());
         }
         else
         {
            _loc3_ = this.playerManager.getPlayer().getTool(SkillManager.getInstance.getExSkillById(this.upExSkill.getId()).getLearnTool());
         }
         if(_loc3_ == null || _loc3_.getNum() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("exskill07"));
            return;
         }
         this.skillFailTipStartPoint.x = param1.currentTarget.x - 108;
         this.skillFailTipStartPoint.y = param1.currentTarget.y - 16;
         this.skillFailTipEndPoint.x = this.skillFailTipStartPoint.x;
         this.skillFailTipEndPoint.y = this.skillFailTipStartPoint.y - 40;
         this.upexskill();
      }
      
      private function upexskill() : void
      {
         if(this.upExSkill == null || this._o == null)
         {
            return;
         }
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_EXSKILL_UP,UP_EXSKILL,this._o.getId(),this.upExSkill.getId());
      }
      
      private function onOverTxt(param1:MouseEvent) : void
      {
         this._txtTips = null;
         this._txtTips = new InfoShowTip();
         var _loc2_:String = "";
         switch(param1.currentTarget.name)
         {
            case "hp_txt":
               _loc2_ = LangManager.getInstance().getLanguage("hp_tip");
               break;
            case "miss_txt":
               _loc2_ = LangManager.getInstance().getLanguage("dodge_tip");
               break;
            case "armor_txt":
               _loc2_ = LangManager.getInstance().getLanguage("armor_tip");
               break;
            case "speed_txt":
               _loc2_ = LangManager.getInstance().getLanguage("speed_tip");
               break;
            case "attack_txt":
               _loc2_ = LangManager.getInstance().getLanguage("attack_tip");
               break;
            case "hitRate_txt":
               _loc2_ = LangManager.getInstance().getLanguage("hitRate_tip");
               break;
            case "penetrate_txt":
               _loc2_ = LangManager.getInstance().getLanguage("penetrate_tip");
         }
         this._txtTips.setTxt(param1.currentTarget as InteractiveObject,_loc2_);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._mc.removeChild(this._geniusTips);
      }
      
      private function changeOrg() : void
      {
         this._updateF();
      }
      
      private function clear() : void
      {
         FuncKit.clearAllChildrens(this._mc["_evolution"]);
         FuncKit.clearAllChildrens(this._mc["_hp"]);
         FuncKit.clearAllChildrens(this._mc["_attack"]);
         FuncKit.clearAllChildrens(this._mc["_precision"]);
         FuncKit.clearAllChildrens(this._mc["_miss"]);
         FuncKit.clearAllChildrens(this._mc["_speed"]);
         FuncKit.clearAllChildrens(this._mc["_new_miss"]);
         FuncKit.clearAllChildrens(this._mc["_new_precision"]);
      }
      
      private function layout() : void
      {
         this._mc["_hp"].y -= 3;
         this._mc["_attack"].y -= 3;
         this._mc["_precision"].y -= 3;
         this._mc["_miss"].y -= 3;
         this._mc["_speed"].y -= 3;
      }
      
      private function clearMiaobian() : void
      {
         TextFilter.removeFilter(this._mc["_hp"]);
         TextFilter.removeFilter(this._mc["_attack"]);
         TextFilter.removeFilter(this._mc["_precision"]);
         TextFilter.removeFilter(this._mc["_miss"]);
         TextFilter.removeFilter(this._mc["_speed"]);
         TextFilter.removeFilter(this._mc["_new_miss"]);
         TextFilter.removeFilter(this._mc["_new_precision"]);
         this._mc["_hp"].textColor = 0;
         this._mc["_attack"].textColor = 0;
         this._mc["_precision"].textColor = 0;
         this._mc["_miss"].textColor = 0;
         this._mc["_speed"].textColor = 0;
         this._mc["_new_miss"].textColor = 0;
         this._mc["_new_precision"].textColor = 0;
      }
      
      private function func() : void
      {
         this.showTipWindow(this._skill_id);
      }
      
      private function getChallegeNum(param1:int) : int
      {
         return int(this.playerManager.getPlayer().getTool(param1).getNum());
      }
      
      private function getStudySkill(param1:int) : void
      {
         var _loc2_:int = int(this._o.getAllSkills().length);
         if(param1 >= 1 && param1 < 3)
         {
            this.gridNum = 1 - _loc2_;
         }
         else if(param1 >= 3 && param1 < 5)
         {
            this.gridNum = 2 - _loc2_;
         }
         else if(param1 >= 5 && param1 < 7)
         {
            this.gridNum = 3 - _loc2_;
         }
         else
         {
            if(!(param1 >= 7 && param1 <= 18))
            {
               return;
            }
            this.gridNum = 4 - _loc2_;
         }
         if(this.gridNum < 0)
         {
            return;
         }
         this.index = _loc2_ + 1;
         this.setSkillIcon();
      }
      
      private function hideNextQuality(param1:MouseEvent) : void
      {
         if(Boolean(this.qalityInfoTip) && this.qalityInfoTip.parent == PlantsVsZombies._node)
         {
            PlantsVsZombies._node.removeChild(this.qalityInfoTip);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var end:Function;
         var actionWindow:ActionWindow = null;
         var e:MouseEvent = param1;
         if(e.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.destroy();
         }
         else if(e.currentTarget.name == "sell")
         {
            if(this._o.getGardenId() != 0)
            {
               PlantsVsZombies.playSounds(SoundManager.BUTTON2);
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window109"));
               return;
            }
            actionWindow = new ActionWindow();
            actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window110"),LangManager.getInstance().getLanguage("window111",int(this._o.getSell_price() * (0.95 + this._o.getGrade() * 0.05)),this._o.getGrade(),this._o.getName()),this.sell,true);
         }
         else if(e.currentTarget.name == "studySkill_1" || e.currentTarget.name == "studySkill_2" || e.currentTarget.name == "studySkill_3" || e.currentTarget.name == "studySkill_4")
         {
            end = function():void
            {
               var _loc1_:ComposeWindowNew = new ComposeWindowNew(null,changeOrg,true);
               _loc1_.toOrgIntensify();
               destroy();
            };
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_COMPONSE,end);
         }
         else if(e.currentTarget.name == "_geniusBtn")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this.playerManager.getPlayer().getGrade() < PlantsVsZombies.GENIUS_OPEN_LEVEL)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("error001"));
               return;
            }
            new GeniusControl(this._o.getId());
            this.destroy();
         }
      }
      
      private function onLeft(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:int = this.playerManager.getOrganismIndex(this._o);
         var _loc3_:Organism = this.playerManager.getOrganismByIndex(_loc2_ - 1);
         if(_loc3_ != null)
         {
            this.update(_loc3_);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:int = int((param1.currentTarget.name as String).substring(4));
         if(this._o.getSkill(_loc2_ - 1) == null)
         {
            return;
         }
         this.upskill = this._o.getAllSkills()[_loc2_ - 1];
         if(SkillManager.getInstance.getNextSkillById(this._o.getSkill(_loc2_ - 1).getId()) != null)
         {
            _loc3_ = SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnProbability();
            _loc4_ = new Tool(SkillManager.getInstance.getNextSkillById(this.upskill.getId()).getLearnTool()).getName();
         }
         this.tips = new SkillTip();
         this.tips.setOrgtip(this._mc["_box" + _loc2_],this._o.getSkill(_loc2_ - 1));
         this.tips.setText(_loc4_,_loc3_);
         this.tips.setLoction(130 + 120 * (_loc2_ - 1),155);
      }
      
      private function onOverExSkill(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:int = int((param1.currentTarget.name as String).substring(7));
         if(this._o.getExSkill(_loc2_ - 1) == null)
         {
            return;
         }
         this.upExSkill = this._o.getAllExSkills()[_loc2_ - 1];
         if(SkillManager.getInstance.getNextExSkillById(this._o.getExSkill(_loc2_ - 1).getId()) != null)
         {
            _loc3_ = SkillManager.getInstance.getNextExSkillById(this.upExSkill.getId()).getLearnProbability();
            _loc4_ = new Tool(SkillManager.getInstance.getNextExSkillById(this.upExSkill.getId()).getLearnTool()).getName();
         }
         this._exSkill_tips = new ExSkillTip();
         this._exSkill_tips.setOrgtip(this._mc["_ex_box" + _loc2_],this._o.getExSkill(_loc2_ - 1));
         this._exSkill_tips.setText(_loc4_,_loc3_);
         this._exSkill_tips.setLoction(130 + 125 * (_loc2_ - 1),200);
      }
      
      private function onOverOrg(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var getText:Function = function(param1:String):String
         {
            if(param1 == "_hp")
            {
               return LangManager.getInstance().getLanguage("window016");
            }
            if(param1 == "_attack")
            {
               return LangManager.getInstance().getLanguage("window012");
            }
            if(param1 == "_precision")
            {
               return LangManager.getInstance().getLanguage("window015");
            }
            if(param1 == "_miss")
            {
               return LangManager.getInstance().getLanguage("window013");
            }
            if(param1 == "_speed")
            {
               return LangManager.getInstance().getLanguage("window014");
            }
            if(param1 == "_new_precision")
            {
               return LangManager.getInstance().getLanguage("window177");
            }
            if(param1 == "_new_miss")
            {
               return LangManager.getInstance().getLanguage("window176");
            }
            return "";
         };
         var getData:Function = function(param1:String):Object
         {
            var _loc2_:Object = {};
            if(param1 == "_hp")
            {
               _loc2_.att1 = _o.getCompHp();
               _loc2_.att2 = _o.getGeniusHp();
               _loc2_.att3 = _o.getSoulHp();
            }
            else if(param1 == "_attack")
            {
               _loc2_.att1 = _o.getCompAtt();
               _loc2_.att2 = _o.getGeniusAtt();
               _loc2_.att3 = _o.getSoulAtt();
            }
            else if(param1 == "_precision")
            {
               _loc2_.att1 = _o.getCompPre();
               _loc2_.att2 = _o.getGeniusPre();
               _loc2_.att3 = _o.getSoulPre();
            }
            else if(param1 == "_miss")
            {
               _loc2_.att1 = _o.getCompMiss();
               _loc2_.att2 = _o.getGeniusMiss();
               _loc2_.att3 = _o.getSoulMiss();
            }
            else if(param1 == "_speed")
            {
               _loc2_.att1 = _o.getCompSpeed();
               _loc2_.att2 = _o.getGeniusSpeed();
               _loc2_.att3 = _o.getSoulSpeed();
            }
            else if(param1 == "_new_precision")
            {
               _loc2_.att1 = _o.getCompNewPre();
               _loc2_.att2 = _o.getGeniusNewPre();
               _loc2_.att3 = _o.getSoulNewPre();
            }
            else if(param1 == "_new_miss")
            {
               _loc2_.att1 = _o.getCompNewMiss();
               _loc2_.att2 = _o.getGeniusNewMiss();
               _loc2_.att3 = _o.getSoulNewMiss();
            }
            return _loc2_;
         };
         this.tipsOrg = new OrgComposeTip();
         this.tipsOrg.setTxt(e.currentTarget as InteractiveObject,getText(e.currentTarget.name),getData(e.currentTarget.name));
         this.tipsOrg.setLoction(310,60);
      }
      
      private function onOverSkill(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Organism = null;
         var _loc4_:Genius = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         if(!this.dialogTip)
         {
            this.dialogTip = new DialogTip();
         }
         if(param1.currentTarget.name == "studySkill_1")
         {
            _loc2_ = LangManager.getInstance().getLanguage("newTip004");
            this.dialogTip.setTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(-45,25);
         }
         else if(param1.currentTarget.name == "studySkill_2")
         {
            _loc2_ = LangManager.getInstance().getLanguage("newTip004");
            this.dialogTip.setTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(75,25);
         }
         else if(param1.currentTarget.name == "studySkill_3")
         {
            _loc2_ = LangManager.getInstance().getLanguage("newTip004");
            this.dialogTip.setTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(195,25);
         }
         else if(param1.currentTarget.name == "studySkill_4")
         {
            _loc2_ = LangManager.getInstance().getLanguage("newTip004");
            this.dialogTip.setTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(315,25);
         }
         else if(param1.currentTarget.name == "no_skill_1")
         {
            _loc2_ = LangManager.getInstance().getLanguage("quality001");
            this.dialogTip.setColorTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(75,25);
         }
         else if(param1.currentTarget.name == "no_skill_2")
         {
            _loc2_ = LangManager.getInstance().getLanguage("quality002");
            this.dialogTip.setColorTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(195,25);
         }
         else if(param1.currentTarget.name == "no_skill_3")
         {
            _loc2_ = LangManager.getInstance().getLanguage("quality003");
            this.dialogTip.setColorTip(param1.currentTarget as InteractiveObject,_loc2_);
            this.dialogTip.setLoction(315,25);
         }
         else if(param1.currentTarget.name == "_geniusBtn")
         {
            this._geniusTips = new PlantsGeniusTips();
            _loc3_ = this.playerManager.getPlayer().getOrganismById(this._o.getId());
            _loc4_ = _loc3_.getGiftData();
            _loc5_ = _loc3_.getSoulLevel();
            _loc6_ = new Object();
            _loc6_.gift = _loc4_;
            _loc6_.soullevel = _loc5_;
            this._geniusTips.show(_loc6_);
            this._mc.addChild(this._geniusTips);
            this._geniusTips.setLocation(355,-60);
         }
      }
      
      private function onRight(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:int = this.playerManager.getOrganismIndex(this._o);
         var _loc3_:Organism = this.playerManager.getOrganismByIndex(_loc2_ + 1);
         if(_loc3_ != null)
         {
            this.update(_loc3_);
         }
      }
      
      private function removeEvent() : void
      {
         this._mc["cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["sell"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_box1"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_box2"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_box3"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_box4"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_hp"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_attack"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_precision"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_miss"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_speed"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["quality"].removeEventListener(MouseEvent.ROLL_OUT,this.hideNextQuality);
         this._mc["quality"].removeEventListener(MouseEvent.ROLL_OVER,this.showQualityArea);
         this._mc["_new_precision"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["_new_miss"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverOrg);
         this._mc["show_growArea"].removeEventListener(MouseEvent.ROLL_OVER,this.showGrowArea);
         this._mc["show_growArea"].removeEventListener(MouseEvent.CLICK,this.useBook);
         this._mc["show_quality"].removeEventListener(MouseEvent.CLICK,this.useBook);
         this._mc["upskill1"].removeEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["upskill2"].removeEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["upskill3"].removeEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["upskill4"].removeEventListener(MouseEvent.CLICK,this.upSkillEvent);
         this._mc["_left"].removeEventListener(MouseEvent.CLICK,this.onLeft);
         this._mc["_right"].removeEventListener(MouseEvent.CLICK,this.onRight);
         this._mc["studySkill_1"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_2"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_3"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_4"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["studySkill_1"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["studySkill_2"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["studySkill_3"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["studySkill_4"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["no_skill_1"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["no_skill_2"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["no_skill_3"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["_geniusBtn"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_geniusBtn"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSkill);
         this._mc["_geniusBtn"].removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc["hp_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["miss_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["armor_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["speed_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["attack_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["hitRate_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["penetrate_txt"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverTxt);
         this._mc["ex_skill_btn1"].removeEventListener(MouseEvent.CLICK,this.onExSkillBtnClick);
         this._mc["ex_skill_btn1"].removeEventListener(MouseEvent.ROLL_OVER,this.onExSkillBtnOver);
         this._mc["up_ex_skill1"].removeEventListener(MouseEvent.CLICK,this.onExSkillUpClick);
         this._mc["_ex_box1"].removeEventListener(MouseEvent.ROLL_OVER,this.onOverExSkill);
      }
      
      private function onExSkillBtnClick(param1:MouseEvent) : void
      {
         var end:Function = null;
         var e:MouseEvent = param1;
         end = function():void
         {
            var _loc1_:ComposeWindowNew = new ComposeWindowNew(null,changeOrg,true);
            _loc1_.toOrgIntensify();
            destroy();
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_COMPONSE,end);
      }
      
      private function sell() : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         PlantsVsZombies.showDataLoading(true);
         this.destroy();
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STORAGE_SELL,SELL);
      }
      
      private function setBtnVisible(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean) : void
      {
         this._mc["studySkill_1"].visible = param1;
         this._mc["studySkill_2"].visible = param2;
         this._mc["studySkill_3"].visible = param3;
         this._mc["studySkill_4"].visible = param4;
         this._mc["no_skill_1"].gotoAndStop(2);
         this._mc["no_skill_2"].gotoAndStop(2);
         this._mc["no_skill_3"].gotoAndStop(2);
         this._mc["no_skill_1"].visible = param5;
         this._mc["no_skill_2"].visible = param6;
         this._mc["no_skill_3"].visible = param7;
      }
      
      private function getColor(param1:int) : uint
      {
         var _loc2_:uint = 0;
         if(param1 == 4)
         {
            _loc2_ = 16646144;
         }
         else if(param1 == 3)
         {
            _loc2_ = 16711935;
         }
         else if(param1 == 2)
         {
            _loc2_ = 65331;
         }
         else if(param1 == 1)
         {
            _loc2_ = 16777011;
         }
         else if(param1 == 0)
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      private function setLoction() : void
      {
         this._mc.x = (PlantsVsZombies.WIDTH - this._mc.width) / 2;
         this._mc.y = (PlantsVsZombies.HEIGHT - this._mc.height) / 2;
      }
      
      private function setSkillIcon() : void
      {
         if(this.index == 1)
         {
            if(this.gridNum == 1)
            {
               this.setBtnVisible(true,false,false,false,true,true,true);
            }
            else if(this.gridNum == 2)
            {
               this.setBtnVisible(true,true,false,false,false,true,true);
            }
            else if(this.gridNum == 3)
            {
               this.setBtnVisible(true,true,true,false,false,false,true);
            }
            else if(this.gridNum == 4)
            {
               this.setBtnVisible(true,true,true,true,false,false,false);
            }
         }
         else if(this.index == 2)
         {
            if(this.gridNum == 0)
            {
               this.setBtnVisible(false,false,false,false,true,true,true);
            }
            else if(this.gridNum == 1)
            {
               this.setBtnVisible(false,true,false,false,false,true,true);
            }
            else if(this.gridNum == 2)
            {
               this.setBtnVisible(false,true,true,false,false,false,true);
            }
            else if(this.gridNum == 3)
            {
               this.setBtnVisible(false,true,true,true,false,false,false);
            }
         }
         else if(this.index == 3)
         {
            if(this.gridNum == 0)
            {
               this.setBtnVisible(false,false,false,false,false,true,true);
            }
            else if(this.gridNum == 1)
            {
               this.setBtnVisible(false,false,true,false,false,false,true);
            }
            else if(this.gridNum == 2)
            {
               this.setBtnVisible(false,false,true,true,false,false,false);
            }
         }
         else if(this.index == 4)
         {
            if(this.gridNum == 0)
            {
               this.setBtnVisible(false,false,false,false,false,false,true);
            }
            else if(this.gridNum == 1)
            {
               this.setBtnVisible(false,false,false,true,false,false,false);
            }
         }
         else if(this.index == 5)
         {
            this.setBtnVisible(false,false,false,false,false,false,false);
         }
      }
      
      private function showFailIntensify(param1:Point, param2:Point, param3:String) : void
      {
         if(this.upQualityfailTip == null)
         {
            this.upQualityfailTip = new AdaptTip(120,30);
         }
         this.upQualityfailTip.creatInfoText(param3,"","",3);
         this._mc.addChild(this.upQualityfailTip);
         this.upQualityfailTip.visible = false;
         this.upQualityfailTip.goAnimate(param1,param2);
      }
      
      private function showGrowArea(param1:MouseEvent) : void
      {
         var _loc2_:String = this._o.getExpl().split("，")[1];
         var _loc3_:String = this._o.getExpl().split("，")[1].split("：")[0];
         var _loc4_:String = this._o.getExpl().split("，")[1].split("：")[1];
         this.tipsOrgGrowArea = new OrgGrowAreaTips();
         this.tipsOrgGrowArea.setTxt(param1.currentTarget as InteractiveObject,_loc3_,_loc4_);
         this.tipsOrgGrowArea.setLoction(370,70);
      }
      
      private function showOrgChange(param1:int, param2:Organism, param3:Organism) : void
      {
         PlantsVsZombies.playFireworks(3);
         this.evolPrizeWindow = new EvolutionPrizeWindow();
         this.evolPrizeWindow.show(param1,param2,param3);
      }
      
      private function showQualityArea(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc2_:int = XmlQualityConfig.getInstance().getID(this._o.getQuality_name());
         if(_loc2_ >= QualityManager.WUJI)
         {
            _loc3_ = this.getNowAttribute(_loc2_);
            this.qalityInfoTip = new AdaptTip(160,60);
            this.qalityInfoTip.creatInfoText(_loc3_.toString(),"","",2);
            PlantsVsZombies._node.addChild(this.qalityInfoTip);
            return;
         }
         _loc3_ = (_loc2_ - 1) * 5;
         this.qalityInfoTip = new AdaptTip(160,110);
         var _loc4_:int = _loc2_ + 1;
         var _loc6_:int = XmlQualityConfig.getInstance().getUpRatio(this._o.getQuality_name());
         if(_loc2_ >= QualityManager.MOSHEN)
         {
            _loc3_ = this.getNowAttribute(_loc2_);
            _loc5_ = this.getUpAttribute(_loc2_);
            _loc8_ = QualityManager.getQualityIdByLevel(XmlQualityConfig.getInstance().getID(this._o.getQuality_name()));
            _loc7_ = new Tool(_loc8_).getName();
            this.qalityInfoTip.creatInfoText(_loc3_.toString(),_loc5_.toString(),_loc6_.toString(),4,_loc7_);
         }
         else
         {
            _loc5_ = (_loc4_ - 1) * 5;
            _loc7_ = new Tool(ToolManager.TOOL_COMP_QUALITY).getName();
            this.qalityInfoTip.creatInfoText(_loc3_.toString(),_loc5_.toString(),_loc6_.toString(),1,_loc7_);
         }
         PlantsVsZombies._node.addChild(this.qalityInfoTip);
      }
      
      private function getNowAttribute(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case QualityManager.MOSHEN:
               _loc2_ = 55;
               break;
            case QualityManager.YAOSI:
               _loc2_ = 65;
               break;
            case QualityManager.BUXIU:
               _loc2_ = 80;
               break;
            case QualityManager.YONGHENG:
               _loc2_ = 110;
               break;
            case QualityManager.TAISHANG:
               _loc2_ = 120;
               break;
            case QualityManager.HUNDUN:
               _loc2_ = 135;
               break;
            case QualityManager.WUJI:
               _loc2_ = 160;
         }
         return _loc2_;
      }
      
      private function getUpAttribute(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case QualityManager.MOSHEN:
               _loc2_ = 65;
               break;
            case QualityManager.YAOSI:
               _loc2_ = 80;
               break;
            case QualityManager.BUXIU:
               _loc2_ = 110;
               break;
            case QualityManager.YONGHENG:
               _loc2_ = 120;
               break;
            case QualityManager.TAISHANG:
               _loc2_ = 135;
               break;
            case QualityManager.HUNDUN:
               _loc2_ = 160;
         }
         return _loc2_;
      }
      
      private function showSkillGrade(param1:Skill, param2:int) : void
      {
         if(param1.getGrade() < 6)
         {
            this._mc["_box" + param2].gotoAndStop(2);
            this._mc["skill" + param2].textColor = 16777215;
            this._mc["skill" + param2].text = "Lv." + param1.getGrade() + "  " + param1.getName();
         }
         else if(param1.getGrade() < 11)
         {
            this._mc["_box" + param2].gotoAndStop(3);
            this._mc["skill" + param2].textColor = 10092288;
            if(param1.getGrade() == 10)
            {
               this._mc["skill" + param2].text = "Lv." + param1.getGrade() + " " + param1.getName();
            }
            else
            {
               this._mc["skill" + param2].text = "Lv." + param1.getGrade() + "  " + param1.getName();
            }
         }
         else if(param1.getGrade() < 21)
         {
            this._mc["_box" + param2].gotoAndStop(4);
            this._mc["skill" + param2].textColor = 16711935;
            this._mc["skill" + param2].text = "Lv." + param1.getGrade() + " " + param1.getName();
         }
         else
         {
            this._mc["_box" + param2].gotoAndStop(5);
            this._mc["skill" + param2].textColor = 16720418;
            this._mc["skill" + param2].text = "Lv." + param1.getGrade() + " " + param1.getName();
         }
         this._mc["upskill" + param2].visible = true;
         if(SkillManager.getInstance.getNextSkillById(param1.getId()) == null)
         {
            this._mc["upskill" + param2].visible = false;
         }
      }
      
      private function showExSkillGrade(param1:ExSkill, param2:int) : void
      {
         this._mc["_ex_box" + param2].visible = true;
         this._mc["ex_skill" + param2].visible = true;
         this._mc["up_ex_skill" + param2].visible = true;
         if(param1.getGrade() < 6)
         {
            this._mc["_ex_box" + param2].gotoAndStop(2);
            this._mc["ex_skill" + param2].textColor = 16777215;
            this._mc["ex_skill" + param2].text = "Lv." + param1.getGrade() + "  " + param1.getName();
         }
         else if(param1.getGrade() < 11)
         {
            this._mc["_ex_box" + param2].gotoAndStop(2);
            this._mc["ex_skill" + param2].textColor = 10092288;
            this._mc["ex_skill" + param2].text = "Lv." + param1.getGrade() + "  " + param1.getName();
            if(param1.getGrade() == 10)
            {
               this._mc["ex_skill" + param2].text = "Lv." + param1.getGrade() + " " + param1.getName();
            }
            else
            {
               this._mc["ex_skill" + param2].text = "Lv." + param1.getGrade() + "  " + param1.getName();
            }
         }
         else if(param1.getGrade() < 21)
         {
            this._mc["_ex_box" + param2].gotoAndStop(4);
            this._mc["ex_skill" + param2].textColor = 16711935;
            this._mc["ex_skill" + param2].text = "Lv." + param1.getGrade() + " " + param1.getName();
         }
         else
         {
            this._mc["_ex_box" + param2].gotoAndStop(5);
            this._mc["ex_skill" + param2].textColor = 16720418;
            this._mc["ex_skill" + param2].text = "Lv." + param1.getGrade() + " " + param1.getName();
         }
         if(SkillManager.getInstance.getNextExSkillById(param1.getId()) == null)
         {
            this._mc["up_ex_skill" + param2].visible = false;
         }
      }
      
      private function showSkillsBG() : void
      {
         var _loc1_:int = XmlQualityConfig.getInstance().getSkillNum(this._o.getQuality_name());
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            if(_loc2_ <= _loc1_)
            {
               this._mc["_box" + _loc2_].visible = true;
            }
            else
            {
               this._mc["_box" + _loc2_].visible = false;
            }
            this._mc["_box" + _loc2_].gotoAndStop(1);
            _loc2_++;
         }
         var _loc3_:int = 1;
         while(_loc3_ <= 1)
         {
            this._mc["_ex_box" + _loc3_].visble = false;
            this._mc["_ex_box" + _loc3_].gotoAndStop(1);
            _loc3_++;
         }
      }
      
      private function textMiaobian() : void
      {
         this._mc["skill1"].mouseEnabled = false;
         this._mc["skill2"].mouseEnabled = false;
         this._mc["skill3"].mouseEnabled = false;
         this._mc["skill4"].mouseEnabled = false;
         this._mc["ex_skill1"].mouseEnabled = false;
         TextFilter.MiaoBian(this._mc["skill1"],0);
         TextFilter.MiaoBian(this._mc["skill2"],0);
         TextFilter.MiaoBian(this._mc["skill3"],0);
         TextFilter.MiaoBian(this._mc["skill4"],0);
         TextFilter.MiaoBian(this._mc["ex_skill1"],0);
      }
      
      private function upDateSkills() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this._mc["skill" + _loc1_].text = "";
            this._mc["upskill" + _loc1_].visible = false;
            _loc1_++;
         }
         if(this._o.getAllSkills() != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this._o.getAllSkills().length)
            {
               _loc3_ = _loc2_ + 1;
               this.showSkillGrade(this._o.getSkill(_loc2_),_loc3_);
               _loc2_++;
            }
         }
      }
      
      private function updateExSkills() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 1;
         while(_loc1_ <= 1)
         {
            this._mc["ex_skill" + _loc1_].text = "";
            this._mc["up_ex_skill" + _loc1_].visible = false;
            this._mc["_ex_box" + _loc1_].visible = false;
            this._mc["ex_skill" + _loc1_].visible = false;
            this._mc["ex_skill_btn" + _loc1_].visible = false;
            _loc1_++;
         }
         if(this._o.getAllExSkills() != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this._o.getAllExSkills().length)
            {
               this.showExSkillGrade(this._o.getExSkill(_loc2_),_loc2_ + 1);
               _loc2_++;
            }
         }
         if(SkillManager.getInstance.getCanLearnExSkills(this._o).length > 0)
         {
            if(this._o.getAllExSkills() != null && this._o.getAllExSkills().length > 0)
            {
               this._mc["ex_skill_btn1"].visible = false;
            }
            else
            {
               this._mc["ex_skill_btn1"].visible = true;
            }
         }
      }
      
      private function upDateUserBookOne(param1:int) : void
      {
         var callBack:Function;
         var recharge:RechargeWindow = null;
         var str:String = null;
         var num:int = param1;
         this._getUserNum = num;
         if(this._userNum != 0)
         {
            if(this.playerManager.getPlayer().getRMB() >= this._price * num && num <= this._userNum)
            {
               this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,BOOK_BUY,this._getId,num);
            }
            else
            {
               callBack = function():void
               {
                  JSManager.toRecharge();
               };
               recharge = new RechargeWindow();
               str = "金券不足，是否充值？";
               recharge.init(str,callBack,1);
            }
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo("挑战书已卖完，6小时后可以购买");
         }
      }
      
      private function upGrowAreaBook() : void
      {
         this._type = ToolManager.TOOL_COMP_PULLULATION;
         if(this.playerManager.getPlayer().getTool(ToolManager.TOOL_COMP_PULLULATION))
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_PULLULATION,ORG_PULLULATION,this._o.getId());
         }
         else
         {
            this.showTipWindow(ToolManager.TOOL_COMP_PULLULATION);
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.destroy();
         }
      }
      
      private function upQualityBook() : void
      {
         var _loc1_:String = null;
         this._type = QualityManager.getQualityIdByLevel(XmlQualityConfig.getInstance().getID(this._o.getQuality_name()));
         if(this.playerManager.getPlayer().getTool(this._type))
         {
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ORG_QUALITY,ORG_QUALITY,this._o.getId());
         }
         else
         {
            if(XmlQualityConfig.getInstance().getID(this._o.getQuality_name()) >= 12)
            {
               _loc1_ = new Tool(this._type).getName();
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window168",_loc1_));
               return;
            }
            this.showTipWindow(this._type);
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.destroy();
         }
      }
      
      private function showTipWindow(param1:int) : void
      {
         this._type = param1;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_INIT,ShopWindow.INIT);
      }
      
      private function useBook(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "show_growArea":
               this.upGrowAreaBook();
               break;
            case "show_quality":
               this.upQualityBook();
         }
      }
   }
}

