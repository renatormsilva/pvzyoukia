package pvz.compose.panel
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.res.IDestroy;
   import constants.AMFConnectionConstants;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import labels.ComposePicLabel;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.QualityManager;
   import manager.ToolManager;
   import manager.ToolType;
   import node.Icon;
   import pvz.compose.ComposeWindow;
   import pvz.compose.EvolutionPrizeWindow;
   import pvz.genius.vo.Genius;
   import pvz.registration.view.panel.module.HtmlUtil;
   import pvz.registration.view.panel.module.ScrollPanel;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import zlib.utils.DomainAccess;
   
   public class ComposeOrgInheritPanel extends Sprite implements IDestroy, IConnection
   {
      
      private static const GET_ALL_INFO_SHOW:int = 1;
      
      private static const GET_ONE_INFO_SHOW:int = 2;
      
      private static const ONE_INHERIT:int = 3;
      
      private static const ALL_INHERIT:int = 4;
      
      private static const INHERIT_RATE:Number = 0.1;
      
      private var clearMask:Function;
      
      private var changeMaterial:Function;
      
      private var labelvisible:Function;
      
      private var setJiantou:Function;
      
      private var panel:MovieClip;
      
      private var tDescription:TextField;
      
      private var mOrg1:MovieClip;
      
      private var mOrg2:MovieClip;
      
      private var mBook:MovieClip;
      
      private var mStrongerBook:MovieClip;
      
      private var mStrongerBookIcon:MovieClip;
      
      private var mStrongerBookNum:MovieClip;
      
      private var mOrgInfo:MovieClip;
      
      private var btnInherit:SimpleButton;
      
      private var mDes_1:MovieClip;
      
      private var mDes_2:MovieClip;
      
      private var btnLeft:SimpleButton;
      
      private var btnRight:SimpleButton;
      
      private var scrollPanel:ScrollPanel;
      
      private var oldOrg1:Organism;
      
      private var oldOrg2:Organism;
      
      private var newOrg1:Organism;
      
      private var newOrg2:Organism;
      
      private var inheritBook:Tool;
      
      private var strongerBookNum:int;
      
      private var keyWord:String;
      
      private var playerMgr:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var evolPrizeWindow:EvolutionPrizeWindow;
      
      public function ComposeOrgInheritPanel(param1:Function, param2:Function, param3:Function, param4:Function, param5:int = 0, param6:int = 0)
      {
         super();
         this.clearMask = param1;
         this.changeMaterial = param2;
         this.labelvisible = param3;
         this.setJiantou = param4;
         var _loc7_:Class = DomainAccess.getClass("orgInheritPanel");
         this.panel = new _loc7_();
         this.panel.visible = false;
         this.addChild(this.panel);
         this.tDescription = this.panel["description_txt"];
         this.mOrg1 = this.panel["org1_mc"];
         this.mOrg2 = this.panel["org2_mc"];
         this.mBook = this.panel["book_mc"];
         this.mStrongerBook = this.panel["strongerBook_mc"];
         this.mStrongerBookIcon = this.panel["icon_mc"];
         this.mStrongerBookNum = this.panel["num_mc"];
         this.mOrgInfo = this.panel["orgInfo_mc"];
         this.btnInherit = this.panel["inherit_btn"];
         this.btnLeft = this.mStrongerBook["left_btn"];
         this.btnRight = this.mStrongerBook["right_btn"];
         this.mDes_1 = this.panel["des_mc_1"];
         this.mDes_2 = this.panel["des_mc_2"];
         this.scrollPanel = new ScrollPanel(this.mOrgInfo.width - 5,this.mOrgInfo.height - 10,new Sprite());
         this.scrollPanel.x = this.mOrgInfo.x + 15;
         this.scrollPanel.y = this.mOrgInfo.y + 5;
         this.addChild(this.scrollPanel);
         this.scrollPanel.scrollBar.width = 16;
         this.scrollPanel.visible = false;
         var _loc8_:ComposePicLabel = new ComposePicLabel(new Tool(ToolManager.TOOL_INHERIT_STRONGER_BOOK),null,false,0);
         this.mStrongerBookIcon.addChild(_loc8_);
         this.setStrongerBookNum();
         this.mStrongerBook.visible = false;
         this.mStrongerBookIcon.visible = false;
         this.mStrongerBookNum.visible = false;
         this.mOrgInfo.visible = false;
         this.addEvent();
         this.setLoction(param5,param6);
         this.show();
         this.judgeSelectedResult();
      }
      
      public static function compToolsChoose(param1:Array) : Array
      {
         var sourceArr:Array = param1;
         var choose:Function = function(param1:Tool):Boolean
         {
            if(int(param1.getType()) >= ToolType.TOOL_TYPE73 && int(param1.getType()) <= ToolType.TOOL_TYPE80)
            {
               return true;
            }
            return false;
         };
         var arr:Array = [];
         var len:int = int(sourceArr.length);
         var i:int = 0;
         while(i < len)
         {
            if(choose(sourceArr[i] as Tool))
            {
               arr.push(sourceArr[i]);
            }
            i++;
         }
         return arr;
      }
      
      private function setStrongerBookNum(param1:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         FuncKit.clearAllChildrens(this.mStrongerBookNum);
         this.mStrongerBook["restNum_txt"].text = "";
         var _loc2_:Tool = this.playerMgr.getPlayer().getTool(ToolManager.TOOL_INHERIT_STRONGER_BOOK);
         if(param1)
         {
            if(_loc2_.getNum() >= 1)
            {
               this.strongerBookNum = 1;
            }
            else
            {
               this.strongerBookNum = 0;
            }
         }
         if(this.strongerBookNum > 0)
         {
            _loc3_ = FuncKit.getNumEffect(this.strongerBookNum + "","Small");
            FuncKit.clearNoColorState(this.mStrongerBookIcon);
         }
         else
         {
            _loc3_ = FuncKit.getNumEffect(0 + "","Small");
            FuncKit.setNoColor(this.mStrongerBookIcon);
         }
         if(Boolean(_loc2_) && _loc2_.getNum() >= this.strongerBookNum)
         {
            this.mStrongerBook["restNum_txt"].text = "剩余" + (_loc2_.getNum() - this.strongerBookNum) + "个";
         }
         _loc3_.x = -_loc3_.width / 2;
         this.mStrongerBookNum.addChild(_loc3_);
      }
      
      private function addEvent() : void
      {
         this.btnInherit.addEventListener(MouseEvent.CLICK,this.onInteritClick);
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.onLeftBtnClick);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.onRightBtnClick);
      }
      
      private function removeEvent() : void
      {
         this.btnInherit.removeEventListener(MouseEvent.CLICK,this.onInteritClick);
         this.btnLeft.removeEventListener(MouseEvent.CLICK,this.onLeftBtnClick);
         this.btnRight.removeEventListener(MouseEvent.CLICK,this.onRightBtnClick);
      }
      
      protected function onRightBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:Tool = this.playerMgr.getPlayer().getTool(ToolManager.TOOL_INHERIT_STRONGER_BOOK);
         if(!_loc2_)
         {
            return;
         }
         ++this.strongerBookNum;
         if(this.strongerBookNum > _loc2_.getNum())
         {
            this.strongerBookNum = _loc2_.getNum();
         }
         if(this.strongerBookNum > 10)
         {
            this.strongerBookNum = 10;
            return;
         }
         this.setStrongerBookNum();
         this.callOneInfoShow();
      }
      
      protected function onLeftBtnClick(param1:MouseEvent) : void
      {
         --this.strongerBookNum;
         if(this.strongerBookNum <= 0)
         {
            this.strongerBookNum = 0;
            this.tDescription.htmlText = "";
            FuncKit.clearAllChildrens(this.mDes_1);
            FuncKit.clearAllChildrens(this.mDes_2);
         }
         this.setStrongerBookNum();
         this.callOneInfoShow();
      }
      
      protected function onInteritClick(param1:MouseEvent) : void
      {
         var actionWindow:ActionWindow = null;
         var callBackOne:Function = null;
         var callBackAll:Function = null;
         var e:MouseEvent = param1;
         callBackOne = function():void
         {
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INHERIT_ONE,ONE_INHERIT,oldOrg2.getId(),oldOrg1.getId(),inheritBook.getOrderId(),strongerBookNum);
         };
         callBackAll = function():void
         {
            netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INHERIT_ALL,ALL_INHERIT,oldOrg2.getId(),oldOrg1.getId());
         };
         var info:String = "";
         if(!this.oldOrg1 || !this.oldOrg2)
         {
            return;
         }
         if(this.oldOrg2.getIsAcceptInherited())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit12"));
            return;
         }
         if(this.oldOrg1.getGrade() < 100 || this.oldOrg2.getGrade() < 100)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit21"));
            return;
         }
         if(!this.inheritBook)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("请选择传承书！"));
            return;
         }
         if(Boolean(this.oldOrg1.getIsArena() || this.oldOrg1.getIsPossession() || this.oldOrg1.getGardenId() || this.oldOrg1.getIsSeverBattle() || this.oldOrg2.getIsArena() || this.oldOrg2.getIsPossession()) || Boolean(this.oldOrg2.getGardenId()) || this.oldOrg2.getIsSeverBattle())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit20"));
            return;
         }
         if(this.isOneOrAll() == 1)
         {
            if(this.strongerBookNum <= 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit14"));
               return;
            }
            actionWindow = new ActionWindow();
            info = LangManager.getInstance().getLanguage("org_inherit16") + "<br><font color=\'#ff0000\'>" + LangManager.getInstance().getLanguage("org_inherit17") + "</br>";
            actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("org_inherit15"),info,callBackOne,true);
         }
         else if(this.isOneOrAll() == 2)
         {
            info = LangManager.getInstance().getLanguage("org_inherit16") + "<br><font color=\'#ff0000\'>" + LangManager.getInstance().getLanguage("org_inherit17") + "</br>";
            actionWindow = new ActionWindow();
            actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("org_inherit15"),info,callBackAll,true);
         }
      }
      
      private function isOneOrAll() : int
      {
         if(int(this.inheritBook.getType()) >= ToolType.TOOL_TYPE73 && int(this.inheritBook.getType()) <= ToolType.TOOL_TYPE79)
         {
            return 1;
         }
         if(int(this.inheritBook.getType()) == ToolType.TOOL_TYPE80)
         {
            return 2;
         }
         return 0;
      }
      
      private function checkOrgBaseAttr() : Boolean
      {
         var _loc1_:Genius = null;
         var _loc2_:Genius = null;
         if(this.isOneOrAll() == 1)
         {
            if(Number(this.getOrgDataByKeyWord(this.oldOrg1,this.keyWord)) < Number(this.getOrgDataByKeyWord(this.oldOrg2,this.keyWord)))
            {
               return false;
            }
            return true;
         }
         if(this.isOneOrAll() == 2)
         {
            if(this.oldOrg1.getGrade() >= this.oldOrg2.getGrade())
            {
               return true;
            }
            if(QualityManager.getQualityLevelByName(this.oldOrg1.getQuality_name()) >= QualityManager.getQualityLevelByName(this.oldOrg2.getQuality_name()))
            {
               return true;
            }
            if(this.oldOrg1.getCompHp() < this.oldOrg2.getHp_max().toNumber())
            {
               return false;
            }
            if(this.oldOrg1.getMiss() < this.oldOrg2.getMiss())
            {
               return false;
            }
            if(this.oldOrg1.getPrecision() < this.oldOrg2.getPrecision())
            {
               return false;
            }
            if(this.oldOrg1.getNewMiss() < this.oldOrg2.getNewMiss())
            {
               return false;
            }
            if(this.oldOrg1.getNewPrecision() < this.oldOrg2.getNewPrecision())
            {
               return false;
            }
            if(this.oldOrg1.getSoulLevel() < this.oldOrg2.getSoulLevel())
            {
               return false;
            }
            _loc1_ = this.oldOrg1.getGiftData();
            _loc2_ = this.oldOrg2.getGiftData();
            if(_loc1_.storm < _loc2_.storm)
            {
               return false;
            }
            if(_loc1_.strong < _loc2_.strong)
            {
               return false;
            }
            if(_loc1_.focus < _loc2_.focus)
            {
               return false;
            }
            if(_loc1_.phantom < _loc2_.phantom)
            {
               return false;
            }
            if(_loc1_.carzy < _loc2_.carzy)
            {
               return false;
            }
            if(_loc1_.lightDefence < _loc2_.lightDefence)
            {
               return false;
            }
            if(_loc1_.maskLevel < _loc2_.maskLevel)
            {
               return false;
            }
            if(_loc1_.poison < _loc2_.poison)
            {
               return false;
            }
            if(_loc1_.clear < _loc2_.clear)
            {
               return false;
            }
         }
         return true;
      }
      
      public function add(param1:Object) : Boolean
      {
         var _loc2_:ComposePicLabel = null;
         if(param1 is Organism)
         {
            if(this.mOrg1.numChildren == 0)
            {
               this.oldOrg1 = param1 as Organism;
               _loc2_ = new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_ORG_INHERIT);
               this.mOrg1.addChild(_loc2_);
            }
            else
            {
               if(this.mOrg2.numChildren != 0)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit03"));
                  return false;
               }
               this.oldOrg2 = param1 as Organism;
               _loc2_ = new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_ORG_INHERIT);
               this.mOrg2.addChild(_loc2_);
            }
         }
         else if(param1 is Tool)
         {
            if(this.mBook.numChildren > 0)
            {
               this.clear((this.mBook.getChildAt(0) as ComposePicLabel).getO());
            }
            this.inheritBook = param1 as Tool;
            _loc2_ = new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_ORG_INHERIT);
            this.mBook.addChild(_loc2_);
         }
         this.judgeSelectedResult();
         return true;
      }
      
      private function judgeSelectedResult() : void
      {
         this.setJiantou(false);
         FuncKit.clearAllChildrens(this.mDes_1);
         FuncKit.clearAllChildrens(this.mDes_2);
         this.setShowInfoFalse();
         this.scrollPanel.removeAllObjects();
         this.tDescription.defaultTextFormat.size = 20;
         if(this.mOrg1.numChildren == 0 && this.mOrg2.numChildren == 0)
         {
            this.newOrg1 = null;
            this.newOrg2 = null;
            this.tDescription.text = LangManager.getInstance().getLanguage("org_inherit04");
            return;
         }
         if(this.mOrg1.numChildren > 0 && this.mOrg2.numChildren == 0)
         {
            this.newOrg2 = null;
            this.tDescription.text = LangManager.getInstance().getLanguage("org_inherit05");
            return;
         }
         if(this.mOrg1.numChildren == 0 && this.mOrg2.numChildren > 0)
         {
            this.newOrg1 = null;
            this.tDescription.text = LangManager.getInstance().getLanguage("org_inherit06");
            return;
         }
         this.setJiantou(true);
         if(this.mBook.numChildren == 0)
         {
            this.tDescription.text = LangManager.getInstance().getLanguage("org_inherit07");
            return;
         }
         this.setJiantou(false);
         if(this.isOneOrAll() == 2)
         {
            this.tDescription.text = LangManager.getInstance().getLanguage("org_inherit08",this.oldOrg1.getName(),this.oldOrg2.getName());
            this.mOrgInfo.visible = this.scrollPanel.visible = true;
            this.mStrongerBook.visible = this.mStrongerBookIcon.visible = this.mStrongerBookNum.visible = false;
            this.callAllInfoShow();
         }
         else if(this.isOneOrAll() == 1)
         {
            this.tDescription.text = "";
            this.mOrgInfo.visible = this.scrollPanel.visible = false;
            this.mStrongerBook.visible = this.mStrongerBookIcon.visible = this.mStrongerBookNum.visible = true;
            this.setStrongerBookNum(true);
            this.callOneInfoShow();
         }
      }
      
      private function setShowInfoFalse() : void
      {
         this.mOrgInfo.visible = this.scrollPanel.visible = false;
         this.mStrongerBook.visible = this.mStrongerBookIcon.visible = this.mStrongerBookNum.visible = false;
      }
      
      private function callOneInfoShow() : void
      {
         if(!this.oldOrg1 || !this.oldOrg2 || !this.inheritBook)
         {
            return;
         }
         if(this.oldOrg1.getGrade() < 100 || this.oldOrg2.getGrade() < 100)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit21"));
            return;
         }
         if(this.strongerBookNum <= 0)
         {
            return;
         }
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INHERIT_GET_ONE_INFO,GET_ONE_INFO_SHOW,this.oldOrg2.getId(),this.oldOrg1.getId(),this.inheritBook.getOrderId(),this.strongerBookNum);
      }
      
      private function callAllInfoShow() : void
      {
         if(!this.oldOrg1 || !this.oldOrg2)
         {
            return;
         }
         if(this.oldOrg1.getGrade() < 100 || this.oldOrg2.getGrade() < 100)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit21"));
            return;
         }
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_INHERIT_GET_ALL_INFO,GET_ALL_INFO_SHOW,this.oldOrg2.getId(),this.oldOrg1.getId());
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
         this.judgeSelectedResult();
      }
      
      private function clearOrg(param1:Organism) : void
      {
         var _loc2_:ComposePicLabel = null;
         if(this.mOrg1.numChildren > 0)
         {
            _loc2_ = this.mOrg1.getChildAt(0) as ComposePicLabel;
            if(_loc2_.getO() as Organism == param1)
            {
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.mOrg1);
               this.oldOrg1 = null;
               this.newOrg1 = null;
               return;
            }
         }
         if(this.mOrg2.numChildren > 0)
         {
            _loc2_ = this.mOrg2.getChildAt(0) as ComposePicLabel;
            if(_loc2_.getO() as Organism == param1)
            {
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.mOrg2);
               this.oldOrg2 = null;
               this.newOrg2 = null;
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
         if(this.mBook.numChildren > 0)
         {
            _loc2_ = this.mBook.getChildAt(0) as ComposePicLabel;
            if((_loc2_.getO() as Tool).getOrderId() == param1.getOrderId())
            {
               this.labelvisible(_loc2_.getO(),false);
               FuncKit.clearAllChildrens(this.mBook);
               this.inheritBook = null;
               this.strongerBookNum = 0;
            }
         }
      }
      
      private function show() : void
      {
         this.panel.visible = true;
      }
      
      private function setLoction(param1:int, param2:int) : void
      {
         this.panel.x = param1;
         this.panel.y = param2;
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         FuncKit.clearAllChildrens(this.panel);
         this.panel = null;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         PlantsVsZombies.showDataLoading(true);
         if(param3 == GET_ALL_INFO_SHOW || param3 == ALL_INHERIT)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
         else if(param3 == GET_ONE_INFO_SHOW || param3 == ONE_INHERIT)
         {
            _loc5_.callOOOO(param2,param3,rest[0],rest[1],rest[2],rest[3]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(param1 == GET_ALL_INFO_SHOW)
         {
            this.readAllInfoData(param2);
            this.showAllInfo();
         }
         else if(param1 == GET_ONE_INFO_SHOW)
         {
            this.readOneInfoData(param2);
            this.showOneInfo();
         }
         else if(param1 == ONE_INHERIT)
         {
            this.readRe(param2);
            this.showResult();
         }
         else if(param1 == ALL_INHERIT)
         {
            this.readRe(param2);
            this.showResult();
         }
      }
      
      private function showResult() : void
      {
         var _loc1_:Tool = null;
         this.evolPrizeWindow = new EvolutionPrizeWindow();
         this.evolPrizeWindow.show(ComposeWindow.ORG_INHERIT,this.oldOrg2,this.newOrg2);
         PlantsVsZombies.playFireworks(3);
         this.oldOrg1 = (this.mOrg1.getChildAt(0) as ComposePicLabel).getO() as Organism;
         this.oldOrg2 = (this.mOrg2.getChildAt(0) as ComposePicLabel).getO() as Organism;
         this.oldOrg1 = this.newOrg1;
         this.oldOrg2 = this.newOrg2;
         (this.mOrg1.getChildAt(0) as ComposePicLabel).updateO(this.oldOrg1);
         (this.mOrg2.getChildAt(0) as ComposePicLabel).updateO(this.oldOrg2);
         this.playerMgr.getPlayer().updateOrg(this.newOrg1);
         this.playerMgr.getPlayer().updateOrg(this.newOrg2);
         this.inheritBook = (this.mBook.getChildAt(0) as ComposePicLabel).getO() as Tool;
         this.playerMgr.getPlayer().useTools(this.inheritBook.getOrderId(),1);
         if(this.inheritBook.getNum() < 1)
         {
            this.clear(this.inheritBook);
         }
         if(this.isOneOrAll() == 1)
         {
            _loc1_ = this.playerMgr.getPlayer().getTool(ToolManager.TOOL_INHERIT_STRONGER_BOOK);
            this.playerMgr.getPlayer().useTools(_loc1_.getOrderId(),this.strongerBookNum);
            this.setStrongerBookNum(true);
         }
         this.changeMaterial(0);
         this.clearThings();
      }
      
      private function clearThings() : void
      {
         this.clear(this.inheritBook);
         this.clear((this.mOrg2.getChildAt(0) as ComposePicLabel).getO());
         this.judgeSelectedResult();
         this.oldOrg2 = null;
         this.inheritBook = null;
      }
      
      private function readRe(param1:Object) : void
      {
         this.newOrg1 = new Organism();
         this.newOrg2 = new Organism();
         this.oldOrg2.setIsAcceptInherited(1);
         this.newOrg2.setIsAcceptInherited(1);
         this.newOrg1.readOrg(param1[1]);
         this.newOrg2.readOrg(param1[0]);
      }
      
      private function readOneInfoData(param1:Object) : void
      {
         this.newOrg1 = new Organism();
         this.newOrg2 = new Organism();
         switch(int(this.inheritBook.getType()))
         {
            case ToolType.TOOL_TYPE73:
               this.newOrg1.setHp_max(param1[1]);
               this.newOrg2.setHp_max(param1[0]);
               this.keyWord = "生命";
               break;
            case ToolType.TOOL_TYPE74:
               this.newOrg1.setAttack(param1[1]);
               this.newOrg2.setAttack(param1[0]);
               this.keyWord = "攻击";
               break;
            case ToolType.TOOL_TYPE75:
               this.newOrg1.setMiss(param1[1]);
               this.newOrg2.setMiss(param1[0]);
               this.keyWord = "护甲";
               break;
            case ToolType.TOOL_TYPE76:
               this.newOrg1.setPrecision(param1[1]);
               this.newOrg2.setPrecision(param1[0]);
               this.keyWord = "穿透";
               break;
            case ToolType.TOOL_TYPE77:
               this.newOrg1.setNewMiss(param1[1]);
               this.newOrg2.setNewMiss(param1[0]);
               this.keyWord = "闪避";
               break;
            case ToolType.TOOL_TYPE78:
               this.newOrg1.setNewPrecision(param1[1]);
               this.newOrg2.setNewPrecision(param1[0]);
               this.keyWord = "命中";
               break;
            case ToolType.TOOL_TYPE79:
               this.newOrg1.setSpeed(param1[1]);
               this.newOrg2.setSpeed(param1[0]);
               this.keyWord = "速度";
         }
      }
      
      private function getOrgDataByKeyWord(param1:Organism, param2:String) : String
      {
         if(!param1)
         {
            throw new Error("og is null!");
         }
         switch(param2)
         {
            case "生命":
               return param1.getHp_max().toString();
            case "攻击":
               return param1.getAttack() + "";
            case "护甲":
               return param1.getMiss() + "";
            case "穿透":
               return param1.getPrecision() + "";
            case "闪避":
               return param1.getNewMiss() + "";
            case "命中":
               return param1.getNewPrecision() + "";
            case "速度":
               return param1.getSpeed() + "";
            default:
               return "";
         }
      }
      
      private function showAllInfo() : void
      {
         this.scrollPanel.removeAllObjects();
         this.addTxtInPanel("植物等级","Lv." + this.oldOrg1.getGrade() + "","Lv." + this.newOrg1.getGrade() + "","Lv." + this.oldOrg2.getGrade() + "","Lv." + this.newOrg2.getGrade() + "");
         this.addTxtInPanel("植物品质",this.oldOrg1.getQuality_name(),this.newOrg1.getQuality_name(),this.oldOrg2.getQuality_name(),this.newOrg2.getQuality_name());
         this.addTxtInPanel("生命",this.oldOrg1.getHp_max().toString(),this.newOrg1.getHp_max().toString(),this.oldOrg2.getHp_max().toString(),this.newOrg2.getHp_max().toString());
         this.addTxtInPanel("攻击",this.oldOrg1.getAttack() + "",this.newOrg1.getAttack() + "",this.oldOrg2.getAttack() + "",this.newOrg2.getAttack() + "");
         this.addTxtInPanel("护甲",this.oldOrg1.getMiss() + "",this.newOrg1.getMiss() + "",this.oldOrg2.getMiss() + "",this.newOrg2.getMiss() + "");
         this.addTxtInPanel("穿透",this.oldOrg1.getPrecision() + "",this.newOrg1.getPrecision() + "",this.oldOrg2.getPrecision() + "",this.newOrg2.getPrecision() + "");
         this.addTxtInPanel("闪避",this.oldOrg1.getNewMiss() + "",this.newOrg1.getNewMiss() + "",this.oldOrg2.getNewMiss() + "",this.newOrg2.getNewMiss() + "");
         this.addTxtInPanel("速度",this.oldOrg1.getSpeed() + "",this.newOrg1.getSpeed() + "",this.oldOrg2.getSpeed() + "",this.newOrg2.getSpeed() + "");
         this.addTxtInPanel("灵魂等级","Lv." + this.oldOrg1.getSoulLevel(),"Lv." + this.newOrg1.getSoulLevel(),"Lv." + this.oldOrg2.getSoulLevel(),"Lv." + this.newOrg2.getSoulLevel());
         this.addTxtInPanel("猛攻","Lv." + this.oldOrg1.getGiftData().storm,"Lv." + this.newOrg1.getGiftData().storm,"Lv." + this.oldOrg2.getGiftData().storm,"Lv." + this.newOrg2.getGiftData().storm);
         this.addTxtInPanel("强壮","Lv." + this.oldOrg1.getGiftData().strong,"Lv." + this.newOrg1.getGiftData().strong,"Lv." + this.oldOrg2.getGiftData().strong,"Lv." + this.newOrg2.getGiftData().strong);
         this.addTxtInPanel("破甲","Lv." + this.oldOrg1.getGiftData().focus,"Lv." + this.newOrg1.getGiftData().focus,"Lv." + this.oldOrg2.getGiftData().focus,"Lv." + this.newOrg2.getGiftData().focus);
         this.addTxtInPanel("坚韧","Lv." + this.oldOrg1.getGiftData().phantom,"Lv." + this.newOrg1.getGiftData().phantom,"Lv." + this.oldOrg2.getGiftData().phantom,"Lv." + this.newOrg2.getGiftData().phantom);
         this.addTxtInPanel("疾风","Lv." + this.oldOrg1.getGiftData().carzy,"Lv." + this.newOrg1.getGiftData().carzy,"Lv." + this.oldOrg2.getGiftData().carzy,"Lv." + this.newOrg2.getGiftData().carzy);
         this.addTxtInPanel("光盾","Lv." + this.oldOrg1.getGiftData().lightDefence,"Lv." + this.newOrg1.getGiftData().lightDefence,"Lv." + this.oldOrg2.getGiftData().lightDefence,"Lv." + this.newOrg2.getGiftData().lightDefence);
         this.addTxtInPanel("破击","Lv." + this.oldOrg1.getGiftData().maskLevel,"Lv." + this.newOrg1.getGiftData().maskLevel,"Lv." + this.oldOrg2.getGiftData().maskLevel,"Lv." + this.newOrg2.getGiftData().maskLevel);
         this.addTxtInPanel("毒雾","Lv." + this.oldOrg1.getGiftData().poison,"Lv." + this.newOrg1.getGiftData().poison,"Lv." + this.oldOrg2.getGiftData().poison,"Lv." + this.newOrg2.getGiftData().poison);
         this.addTxtInPanel("净化","Lv." + this.oldOrg1.getGiftData().clear,"Lv." + this.newOrg1.getGiftData().clear,"Lv." + this.oldOrg2.getGiftData().clear,"Lv." + this.newOrg2.getGiftData().clear);
      }
      
      private function showOneInfo() : void
      {
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc1_:String = this.oldOrg1.getName();
         var _loc2_:String = this.keyWord;
         var _loc3_:String = int(this.strongerBookNum * INHERIT_RATE * 100) + "%";
         var _loc4_:String = this.oldOrg2.getName();
         var _loc5_:String = this.getOrgDataByKeyWord(this.oldOrg1,_loc2_);
         var _loc6_:String = this.getOrgDataByKeyWord(this.newOrg1,_loc2_);
         var _loc7_:String = this.getOrgDataByKeyWord(this.oldOrg2,_loc2_);
         var _loc8_:String = this.getOrgDataByKeyWord(this.newOrg2,_loc2_);
         if(_loc5_ != _loc6_)
         {
            _loc9_ = 16711680;
         }
         else
         {
            _loc9_ = 0;
         }
         if(_loc7_ != _loc8_)
         {
            _loc10_ = 16711680;
         }
         else
         {
            _loc10_ = 0;
         }
         _loc3_ = "<font color=\'#ff0000\'>" + _loc3_ + "</font>";
         this.tDescription.defaultTextFormat.size = 12;
         this.tDescription.htmlText = LangManager.getInstance().getLanguage("org_inherit10",_loc1_,_loc2_,_loc3_,_loc4_);
         FuncKit.clearAllChildrens(this.mDes_1);
         FuncKit.clearAllChildrens(this.mDes_2);
         var _loc11_:TextField = new TextField();
         _loc11_.text = _loc1_ + " " + _loc2_;
         _loc11_.width = 200;
         this.mDes_1.addChild(_loc11_);
         var _loc12_:DisplayObject = ArtWordsManager.instance.getArtWordByTwoNumber(Number(_loc5_),Number(_loc6_),0,_loc9_,12,1,false);
         this.mDes_1.addChild(_loc12_);
         _loc12_.x = _loc11_.textWidth + 5;
         _loc12_.y = 3;
         _loc11_ = new TextField();
         _loc11_.text = _loc4_ + " " + _loc2_;
         _loc11_.width = 200;
         this.mDes_2.addChild(_loc11_);
         _loc12_ = ArtWordsManager.instance.getArtWordByTwoNumber(Number(_loc7_),Number(_loc8_),0,_loc10_,12,1,false);
         this.mDes_2.addChild(_loc12_);
         _loc12_.x = _loc11_.textWidth + 5;
         _loc12_.y = 3;
         this.mDes_1.x = 196 - this.mDes_1.width / 2;
         this.mDes_1.y = 70;
         this.mDes_2.x = 196 - this.mDes_2.width / 2;
         this.mDes_2.y = 88;
      }
      
      private function addTxtInPanel(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc6_:MovieClip = new MovieClip();
         var _loc7_:TextField = new TextField();
         _loc7_.defaultTextFormat.size = 14;
         _loc7_.width = 350;
         _loc7_.height = 30;
         _loc7_.htmlText = param1 + ":";
         if(param2 != param3)
         {
            _loc8_ = 16711680;
         }
         else
         {
            _loc8_ = 0;
         }
         if(param4 != param5)
         {
            _loc9_ = 16711680;
         }
         else
         {
            _loc9_ = 0;
         }
         _loc6_.addChild(_loc7_);
         if(param1 == "植物品质" || param1 == "植物等级" || param1 == "灵魂等级" || param1 == "猛攻" || param1 == "强壮" || param1 == "破甲" || param1 == "坚韧" || param1 == "疾风" || param1 == "光盾" || param1 == "破击" || param1 == "毒雾" || param1 == "净化")
         {
            param3 = HtmlUtil.font2(param3,_loc8_,12);
            param5 = HtmlUtil.font2(param5,_loc9_,12);
            _loc7_.htmlText = LangManager.getInstance().getLanguage("org_inherit09",param1,param2,param3,param4,param5);
         }
         else
         {
            _loc10_ = ArtWordsManager.instance.getArtWordByTwoNumber(Number(param2),Number(param3),0,_loc8_,12,1,false);
            _loc11_ = ArtWordsManager.instance.getArtWordByTwoNumber(Number(param4),Number(param5),0,_loc8_,12,1,false);
            _loc6_.addChild(_loc10_);
            _loc10_.x = _loc7_.textWidth + 5;
            _loc10_.y = 3;
            _loc6_.addChild(_loc11_);
            _loc11_.x = _loc10_.x + _loc10_.width + 5;
            _loc11_.y = 3;
         }
         this.scrollPanel.addObject(_loc6_);
      }
      
      private function readAllInfoData(param1:Object) : void
      {
         this.newOrg1 = new Organism();
         this.newOrg2 = new Organism();
         this.readOrg(param1[1],this.newOrg1);
         this.readOrg(param1[0],this.newOrg2);
      }
      
      private function readOrg(param1:Object, param2:Organism) : void
      {
         if(!param2 || !param1)
         {
            throw new Error("obj or o is null!");
         }
         param2.setAttack(param1.attack);
         param2.setGrade(param1.grade);
         param2.setHp_max(param1.hp);
         param2.setMiss(param1.miss);
         param2.setNewMiss(param1.new_miss);
         param2.setNewPrecision(param1.new_precision);
         param2.setPrecision(param1.precision);
         param2.setQuality_name(param1.quality_name);
         param2.setSoulLevel(param1.soul);
         param2.setSpeed(param1.speed);
         if((param1.tal as Array).length > 0)
         {
            param2.setGiftData(param1.tal,"array");
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
         PlantsVsZombies.showDataLoading(false);
      }
   }
}

