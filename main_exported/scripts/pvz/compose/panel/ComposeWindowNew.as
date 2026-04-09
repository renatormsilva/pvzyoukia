package pvz.compose.panel
{
   import constants.GlobalConstants;
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import entity.Goods;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import labels.ComposeLabel;
   import labels.ComposePicLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import manager.ToolType;
   import pvz.help.HelpNovice;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ComposeWindowNew extends BaseWindow implements IDestroy
   {
      
      public static const MATERIAL_ORG:int = 1;
      
      public static const MATERIAL_TOOL:int = 2;
      
      public static const MATERIAL_BOOK:int = 3;
      
      public static const MATERIAL_MORPH:int = 4;
      
      public static const TYPE_ORG_EVOLUTION:int = 1;
      
      public static const TYPE_ORG_INTENSIFY:int = 2;
      
      public static const TYPE_TOOLS_CHANGE:int = 3;
      
      public static const TYPE_ORG_COMPOSE:int = 4;
      
      public static const TYPE_ORG_INHERIT:int = 5;
      
      private static const LABEL_TOOL:int = 1;
      
      private static const LABEL_BOOK:int = 2;
      
      private static const MATERIAL_PAGE_NUM:int = 9;
      
      private var _loadedCall:Function;
      
      internal var _closeFun:Function = null;
      
      internal var _composeWindow:MovieClip;
      
      internal var composetype:int = 1;
      
      internal var helpBack:Function = null;
      
      internal var material:Array = null;
      
      internal var materialType:int = 0;
      
      internal var maxpage:int = 1;
      
      internal var nowpage:int = 1;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _otherEnter:Boolean = false;
      
      private var _outEnter:Boolean;
      
      private var _paneltype:int;
      
      private var appointedOrgId:int = 0;
      
      private var dialopTip:TextField;
      
      public function ComposeWindowNew(param1:Function, param2:Function, param3:Boolean = false, param4:Boolean = false, param5:Function = null)
      {
         this._outEnter = param4;
         this._closeFun = param2;
         this._otherEnter = param3;
         this._loadedCall = param5;
         this.helpBack = param1;
         super(UINameConst.UI_COMPONSE);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("composeWindowNew");
         this._composeWindow = new _loc1_();
         this._composeWindow.visible = false;
         PlantsVsZombies._node.addChild(this._composeWindow);
         this.initAllEvent();
         this.initBtHand();
         this.init();
      }
      
      public function appointToOrgId(param1:int) : void
      {
         this.appointedOrgId = param1;
      }
      
      override public function destroy() : void
      {
         this.removeWindowEvent();
         this.clearAllCompose();
         this.clearComposePanel();
         if(GlobalConstants.NEW_PLAYER)
         {
            this.helpBack();
         }
         PlantsVsZombies._node.removeChild(this._composeWindow);
         if(this._closeFun != null)
         {
            this._closeFun();
         }
      }
      
      public function init() : void
      {
         this.setJiantou(false);
         this.setAllBtVisibleFalse();
         this.setBtVisibleTrue();
         this._composeWindow["_bt1"].visible = false;
         this._composeWindow["_btSelected1"].visible = true;
         this._composeWindow["_addtxt"].visible = false;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this.updateOrgs();
         if(this._loadedCall != null)
         {
            this._loadedCall(this);
         }
      }
      
      public function orderOrgsByGrade(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getGrade() < _loc3_.getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function toOrgIntensify() : void
      {
         this.setAllBtVisibleFalse();
         this.setBtVisibleTrue();
         this._composeWindow["_bt2"].visible = false;
         this._composeWindow["_btSelected2"].visible = true;
         this.changeComposeType(TYPE_ORG_INTENSIFY);
      }
      
      public function updateOrgs() : void
      {
         if(GlobalConstants.NEW_PLAYER)
         {
            this.show();
            PlantsVsZombies.helpN.show(HelpNovice.COMP_CHOOSE_ORG,PlantsVsZombies._node as DisplayObjectContainer);
         }
         else if(this._otherEnter == true)
         {
            PlantsVsZombies.storageInfo();
            this._composeWindow.visible = true;
            PlantsVsZombies._node.setChildIndex(this._composeWindow,PlantsVsZombies._node.numChildren - 1);
            onShowEffectBig(this._composeWindow);
         }
         else
         {
            PlantsVsZombies.storageInfo(this.show);
         }
      }
      
      private function changeComposeType(param1:int = 1) : void
      {
         this.composetype = param1;
         this.setAllKindBtVisibleFalse();
         this.nowpage = 1;
         this._composeWindow["_addtxt"].visible = false;
         this._composeWindow["_addtxt"].text = "";
         this.setJiantou(false);
         if(param1 == TYPE_ORG_EVOLUTION)
         {
            this._composeWindow["_kindbtSelected1"].visible = true;
            this.setDialopShow();
            this.showComposeTypePanel(param1);
            this.changeMaterial(MATERIAL_ORG);
         }
         else if(param1 == TYPE_ORG_INTENSIFY)
         {
            this._composeWindow["_kindbt2"].visible = true;
            this._composeWindow["_kindbtSelected1"].visible = true;
            this.setDialopShow(true);
            this.showComposeTypePanel(param1);
            this.changeMaterial(MATERIAL_ORG);
         }
         else if(param1 == TYPE_TOOLS_CHANGE)
         {
            this._composeWindow["_kindbtSelected2"].visible = true;
            this._composeWindow["_kindbt3"].t.text = "书籍";
            this._composeWindow["_kindbt3"].visible = true;
            this.setDialopShow();
            this.showComposeTypePanel(param1);
         }
         else if(param1 == TYPE_ORG_COMPOSE)
         {
            this._composeWindow["_addtxt"].visible = true;
            this._composeWindow["_addtxt"].text = LangManager.getInstance().getLanguage("org_inherit19");
            this._composeWindow["_kindbt2"].visible = true;
            this._composeWindow["_kindbtSelected1"].visible = true;
            this.setDialopShow();
            this.showComposeTypePanel(param1);
            this.changeMaterial(MATERIAL_ORG);
         }
         else if(param1 == TYPE_ORG_INHERIT)
         {
            this._composeWindow["_addtxt"].visible = true;
            this._composeWindow["_addtxt"].text = LangManager.getInstance().getLanguage("org_inherit01");
            this._composeWindow["_kindbt2"].visible = true;
            this._composeWindow["_kindbtSelected1"].visible = true;
            this.setDialopShow(false);
            this.showComposeTypePanel(param1);
            this.changeMaterial(MATERIAL_ORG);
         }
      }
      
      private function changeMaterial(param1:int, param2:String = "") : void
      {
         var _loc3_:Array = null;
         if(param1 == 0 && this.materialType == 0)
         {
            throw new Error("ComposeWindow material data error!");
         }
         if(param1 != 0)
         {
            this.materialType = param1;
         }
         if(this.materialType == MATERIAL_ORG)
         {
            this.material = this.playerManager.getPlayer().getAllOrganism();
            this.material = this.orderOrgsByGrade(this.material);
         }
         else if(this.materialType == MATERIAL_TOOL)
         {
            if(param2 == ComposeToolsChangePanel.TOOL_CHANGE_PANEL || this._paneltype == TYPE_TOOLS_CHANGE)
            {
               this.material = this.canChangeButNotBook(this.filterTools());
            }
            else
            {
               this.material = this.playerManager.getPlayer().getAllTools();
            }
            if(this.composetype == TYPE_ORG_INTENSIFY)
            {
               this.material = ComposeOrgIntensifyPanel.chooseToolComp(this.material);
            }
            else if(this.composetype == TYPE_ORG_COMPOSE)
            {
               this.material = ComposeOrgComposePanel.chooseToolComp(this.material);
            }
            else if(this.composetype == TYPE_ORG_INHERIT)
            {
               this.material = ComposeOrgInheritPanel.compToolsChoose(this.material);
            }
            this.material = this.orderToolById(this.material);
         }
         else if(this.materialType == MATERIAL_BOOK)
         {
            if(this._paneltype == TYPE_TOOLS_CHANGE)
            {
               this.material = ToolManager.checkpointBookTools(this.filterTools());
            }
            else
            {
               _loc3_ = this.playerManager.getPlayer().getAllTools();
               this.material = ToolManager.checkpointBookTools(_loc3_);
            }
         }
         else if(this.materialType == MATERIAL_MORPH)
         {
            this.material = this.playerManager.getPlayer().getAllTools();
            this.material = ComposeOrgIntensifyPanel.chooseToolMORHP(this.material);
         }
         this.showMaterial();
      }
      
      private function canChangeButNotBook(param1:Array) : Array
      {
         if(!param1 || param1.length == 0)
         {
            return null;
         }
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(ToolType.isBook(param1[_loc4_]) == false)
            {
               _loc2_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function clearAllCompose() : void
      {
         var _loc1_:* = int(this._composeWindow.numChildren - 1);
         while(_loc1_ >= 0)
         {
            if(this._composeWindow.getChildAt(_loc1_) is ComposeLabel)
            {
               this._composeWindow.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function clearComposePanel() : void
      {
         if(this._composeWindow["_panel"].numChildren <= 0)
         {
            return;
         }
         this._composeWindow["_panel"].getChildAt(0).destroy();
         this._composeWindow["_panel"].removeChild(this._composeWindow["_panel"].getChildAt(0));
      }
      
      private function countPageByAppoPlant() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= this.material.length)
         {
            if((this.material[_loc1_ - 1] as Organism).getId() == this.appointedOrgId)
            {
               this.nowpage = Math.ceil(_loc1_ / 9);
            }
            _loc1_++;
         }
         this._outEnter = false;
      }
      
      private function filterTools() : Array
      {
         var _loc3_:Tool = null;
         var _loc1_:Array = this.playerManager.getPlayer().getAllTools();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            if(this.isToolCanChange(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function filterToolsOtherWay() : Array
      {
         var _loc2_:Tool = null;
         var _loc3_:Goods = null;
         var _loc1_:Array = new Array();
         for each(_loc3_ in this.playerManager.getPlayer().getChangetools())
         {
            _loc2_ = this.getToolByChangeToolId(_loc3_.getChangeId());
            if(_loc2_)
            {
               if(_loc1_.indexOf(_loc2_) == -1)
               {
                  _loc1_.push(_loc2_);
               }
            }
         }
         return _loc1_;
      }
      
      private function getLabelAdd() : Function
      {
         return this._composeWindow["_panel"].getChildAt(0).add;
      }
      
      private function getLabelClear() : Function
      {
         return this._composeWindow["_panel"].getChildAt(0).clear;
      }
      
      private function getToolByChangeToolId(param1:int) : Tool
      {
         var _loc2_:Tool = null;
         var _loc3_:Tool = null;
         for each(_loc3_ in this.playerManager.getPlayer().getAllTools())
         {
            if(_loc3_.getOrderId() == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc3_;
      }
      
      private function initAllEvent() : void
      {
         this._composeWindow["_cancel"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_decnum"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_addnum"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_kindbt1"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_kindbt2"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_kindbt3"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt1"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt2"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt3"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt4"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt5"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
      }
      
      private function initBtHand() : void
      {
         this._composeWindow["_bt1"].buttonMode = true;
         this._composeWindow["_bt2"].buttonMode = true;
         this._composeWindow["_bt3"].buttonMode = true;
         this._composeWindow["_bt4"].buttonMode = true;
         this._composeWindow["_bt5"].buttonMode = true;
         this._composeWindow["_kindbt1"].buttonMode = true;
         this._composeWindow["_kindbt2"].buttonMode = true;
         this._composeWindow["_kindbt3"].buttonMode = true;
         this._composeWindow["_kindbt1"].mouseChildren = false;
         this._composeWindow["_kindbt2"].mouseChildren = false;
         this._composeWindow["_kindbt3"].mouseChildren = false;
      }
      
      private function isToolCanChange(param1:Tool) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.playerManager.getPlayer().getChangetools().length)
         {
            if((this.playerManager.getPlayer().getChangetools()[_loc2_] as Goods).getChangeId() == param1.getOrderId())
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function onWindowClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_cancel")
         {
            onHiddenEffectBig(this._composeWindow,this.destroy);
         }
         else if(param1.currentTarget.name == "_decnum")
         {
            if(this.nowpage <= 1)
            {
               return;
            }
            --this.nowpage;
            this.showMaterial();
         }
         else if(param1.currentTarget.name == "_addnum")
         {
            if(this.nowpage == this.maxpage)
            {
               return;
            }
            ++this.nowpage;
            this.showMaterial();
         }
         else if(param1.currentTarget.name == "_kindbt1")
         {
            this.setAllKindBtVisibleFalse();
            this._composeWindow["_kindbt2"].visible = true;
            this._composeWindow["_kindbtSelected1"].visible = true;
            this.changeMaterial(MATERIAL_ORG);
         }
         else if(param1.currentTarget.name == "_kindbt2")
         {
            this.setAllKindBtVisibleFalse();
            if(this._paneltype == TYPE_ORG_INTENSIFY)
            {
               this._composeWindow["_kindbt1"].visible = true;
            }
            if(this._paneltype == TYPE_ORG_COMPOSE || this._paneltype == TYPE_ORG_INHERIT)
            {
               this._composeWindow["_kindbt1"].visible = true;
            }
            else if(this._paneltype == TYPE_TOOLS_CHANGE)
            {
               this._composeWindow["_kindbt3"].visible = true;
            }
            this._composeWindow["_kindbtSelected2"].visible = true;
            this.changeMaterial(MATERIAL_TOOL);
         }
         else if(param1.currentTarget.name == "_kindbt3")
         {
            this.setAllKindBtVisibleFalse();
            if(this._paneltype == TYPE_TOOLS_CHANGE)
            {
               this._composeWindow["_kindbt2"].visible = true;
            }
            if(this._paneltype == TYPE_ORG_INTENSIFY)
            {
               this._composeWindow["_kindbt1"].visible = true;
               this._composeWindow["_kindbt2"].visible = true;
            }
            else
            {
               this._composeWindow["_kindbtSelected3"].t.text = "书籍";
               this.changeMaterial(MATERIAL_BOOK);
            }
            this._composeWindow["_kindbtSelected3"].visible = true;
         }
         else if(param1.currentTarget.name == "_bt1")
         {
            this.setAllBtVisibleFalse();
            this.setBtVisibleTrue();
            this._composeWindow["_bt1"].visible = false;
            this._composeWindow["_btSelected1"].visible = true;
            this.changeComposeType();
         }
         else if(param1.currentTarget.name == "_bt2")
         {
            this.setAllBtVisibleFalse();
            this.setBtVisibleTrue();
            this._composeWindow["_bt2"].visible = false;
            this._composeWindow["_btSelected2"].visible = true;
            this.changeComposeType(TYPE_ORG_INTENSIFY);
         }
         else if(param1.currentTarget.name == "_bt3")
         {
            this.setAllBtVisibleFalse();
            this.setBtVisibleTrue();
            this._composeWindow["_bt3"].visible = false;
            this._composeWindow["_btSelected3"].visible = true;
            this.changeComposeType(TYPE_TOOLS_CHANGE);
         }
         else if(param1.currentTarget.name == "_bt4")
         {
            if(this.playerManager.getPlayer().getGrade() < 35)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window047"));
               return;
            }
            this.setAllBtVisibleFalse();
            this.setBtVisibleTrue();
            this._composeWindow["_bt4"].visible = false;
            this._composeWindow["_btSelected4"].visible = true;
            this.changeComposeType(TYPE_ORG_COMPOSE);
         }
         else if(param1.currentTarget.name == "_bt5")
         {
            if(this.playerManager.getPlayer().getGrade() < 35)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("org_inherit02"));
               return;
            }
            this.setAllBtVisibleFalse();
            this.setBtVisibleTrue();
            this._composeWindow["_bt5"].visible = false;
            this._composeWindow["_btSelected5"].visible = true;
            this.changeComposeType(TYPE_ORG_INHERIT);
         }
      }
      
      private function orderToolById(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as Tool).getOrderId() > _loc3_.getOrderId())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function removeWindowEvent() : void
      {
         this._composeWindow["_cancel"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_decnum"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_addnum"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_kindbt1"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_kindbt2"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_kindbt3"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt1"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt2"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt3"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt4"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
         this._composeWindow["_bt5"].addEventListener(MouseEvent.CLICK,this.onWindowClick);
      }
      
      private function setAllBtVisibleFalse() : void
      {
         this._composeWindow["_bt1"].visible = false;
         this._composeWindow["_bt1"].gotoAndStop(1);
         this._composeWindow["_bt2"].visible = false;
         this._composeWindow["_bt2"].gotoAndStop(2);
         this._composeWindow["_bt3"].visible = false;
         this._composeWindow["_bt3"].gotoAndStop(3);
         this._composeWindow["_bt4"].visible = false;
         this._composeWindow["_bt4"].gotoAndStop(4);
         this._composeWindow["_bt5"].visible = false;
         this._composeWindow["_bt5"].gotoAndStop(5);
         this._composeWindow["_btSelected1"].visible = false;
         this._composeWindow["_btSelected1"].gotoAndStop(1);
         this._composeWindow["_btSelected2"].visible = false;
         this._composeWindow["_btSelected2"].gotoAndStop(2);
         this._composeWindow["_btSelected3"].visible = false;
         this._composeWindow["_btSelected3"].gotoAndStop(3);
         this._composeWindow["_btSelected4"].visible = false;
         this._composeWindow["_btSelected4"].gotoAndStop(4);
         this._composeWindow["_btSelected5"].visible = false;
         this._composeWindow["_btSelected5"].gotoAndStop(5);
      }
      
      private function setAllKindBtVisibleFalse() : void
      {
         this._composeWindow["_kindbt1"].visible = false;
         this._composeWindow["_kindbt2"].visible = false;
         this._composeWindow["_kindbt3"].visible = false;
         this._composeWindow["_kindbtSelected1"].visible = false;
         this._composeWindow["_kindbtSelected2"].visible = false;
         this._composeWindow["_kindbtSelected3"].visible = false;
      }
      
      private function setAllLabelMaskVisible(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._composeWindow.numChildren)
         {
            if(this._composeWindow.getChildAt(_loc2_) is ComposeLabel)
            {
               (this._composeWindow.getChildAt(_loc2_) as ComposeLabel).setMaskVisible(param1);
            }
            _loc2_++;
         }
      }
      
      private function setBtVisibleTrue() : void
      {
         this._composeWindow["_bt1"].visible = true;
         this._composeWindow["_bt2"].visible = true;
         this._composeWindow["_bt3"].visible = true;
         this._composeWindow["_bt4"].visible = true;
         this._composeWindow["_bt5"].visible = true;
      }
      
      private function setComposeLabelVisible(param1:Object, param2:Boolean) : void
      {
         var _loc4_:ComposeLabel = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._composeWindow.numChildren)
         {
            if(this._composeWindow.getChildAt(_loc3_) is ComposeLabel)
            {
               _loc4_ = this._composeWindow.getChildAt(_loc3_) as ComposeLabel;
               if(_loc4_.getO() == param1)
               {
                  (this._composeWindow.getChildAt(_loc3_) as ComposeLabel).setMaskVisible(param2);
                  return;
               }
            }
            _loc3_++;
         }
      }
      
      private function setComposeLabelVisibleFalse() : void
      {
         var _loc1_:ComposePicLabel = null;
         var _loc2_:Object = null;
         if(this._composeWindow["_panel"] == null)
         {
            return;
         }
         if(this.composetype == TYPE_ORG_EVOLUTION)
         {
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["base_org"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["base_org"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
         }
         else if(this.composetype == TYPE_ORG_INTENSIFY)
         {
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_org"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_org"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_tool"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_tool"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
         }
         else if(this.composetype == TYPE_TOOLS_CHANGE)
         {
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["tool1"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["tool1"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
         }
         else if(this.composetype == TYPE_ORG_COMPOSE)
         {
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_mc_org_1"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_mc_org_1"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_mc_org_2"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_mc_org_2"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_mc_tool_1"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["_mc_tool_1"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
         }
         else if(this.composetype == TYPE_ORG_INHERIT)
         {
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["org1_mc"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["org1_mc"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["org2_mc"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["org2_mc"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
            if(this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["book_mc"].numChildren != 0)
            {
               _loc1_ = this._composeWindow["_panel"].getChildAt(0).getChildAt(0)["book_mc"].getChildAt(0);
               _loc2_ = _loc1_.getO();
               this.setComposeLabelVisible(_loc2_,true);
            }
         }
      }
      
      private function setDialopShow(param1:Boolean = false) : void
      {
         if(this.dialopTip == null)
         {
            this.dialopTip = new TextField();
         }
         this.dialopTip.visible = param1;
         this.dialopTip.htmlText = "<font size=\'12\'><b>" + LangManager.getInstance().getLanguage("newTip003") + "</b></font>";
         this.dialopTip.textColor = 16711680;
         this.dialopTip.width = this.dialopTip.textWidth + 4;
         this.dialopTip.height = this.dialopTip.textHeight + 6;
         this.dialopTip.x = 60;
         this.dialopTip.y = 480;
         this._composeWindow.addChild(this.dialopTip);
      }
      
      private function setJiantou(param1:Boolean) : void
      {
         this._composeWindow["tool_compose_jiantou"].visible = param1;
         if(param1)
         {
            this._composeWindow["tool_compose_jiantou"].gotoAndPlay(1);
         }
         else
         {
            this._composeWindow["tool_compose_jiantou"].gotoAndStop(1);
         }
      }
      
      private function show() : void
      {
         this.changeComposeType();
         this._composeWindow.visible = true;
         PlantsVsZombies._node.setChildIndex(this._composeWindow,PlantsVsZombies._node.numChildren - 1);
         onShowEffectBig(this._composeWindow);
      }
      
      private function showComposeTypePanel(param1:int) : void
      {
         this._paneltype = param1;
         this.clearComposePanel();
         switch(param1)
         {
            case TYPE_ORG_EVOLUTION:
               this._composeWindow["_panel"].addChild(new ComposeOrgEvolutionPanel(this.setAllLabelMaskVisible,this.changeMaterial,this.setJiantou,14));
               break;
            case TYPE_ORG_INTENSIFY:
               this._composeWindow["_panel"].addChild(new ComposeOrgIntensifyPanel(this.setAllLabelMaskVisible,this.changeMaterial,this.setComposeLabelVisible,this.setJiantou,14));
               break;
            case TYPE_TOOLS_CHANGE:
               this._composeWindow["_panel"].addChild(new ComposeToolsChangePanel(this.setAllLabelMaskVisible,this.changeMaterial,this.setComposeLabelVisible,14));
               break;
            case TYPE_ORG_COMPOSE:
               this._composeWindow["_panel"].addChild(new ComposeOrgComposePanel(this.setAllLabelMaskVisible,this.changeMaterial,this.setComposeLabelVisible,this.setJiantou,14));
               break;
            case TYPE_ORG_INHERIT:
               this._composeWindow["_panel"].addChild(new ComposeOrgInheritPanel(this.setAllLabelMaskVisible,this.changeMaterial,this.setComposeLabelVisible,this.setJiantou,14));
         }
         this.changeToolLabelShow();
      }
      
      private function changeToolLabelShow() : void
      {
         switch(this._paneltype)
         {
            case TYPE_ORG_COMPOSE:
            case TYPE_ORG_INHERIT:
               this._composeWindow["_kindbt2"].gotoAndStop(LABEL_BOOK);
               this._composeWindow["_kindbtSelected2"].gotoAndStop(LABEL_BOOK);
               break;
            default:
               this._composeWindow["_kindbt2"].gotoAndStop(LABEL_TOOL);
               this._composeWindow["_kindbtSelected2"].gotoAndStop(LABEL_TOOL);
         }
      }
      
      private function showMaterial() : void
      {
         var _loc5_:ComposeLabel = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.clearAllCompose();
         this.maxpage = (this.material.length - 1) / MATERIAL_PAGE_NUM + 1;
         if(this._outEnter)
         {
            this.countPageByAppoPlant();
         }
         if(this.maxpage != 0 && this.nowpage == 0)
         {
            this.nowpage = 1;
         }
         if(this.maxpage <= this.nowpage)
         {
            this.nowpage = this.maxpage;
         }
         this._composeWindow["_num"].text = this.nowpage + "/" + this.maxpage;
         var _loc1_:Array = this.material.slice((this.nowpage - 1) * MATERIAL_PAGE_NUM,this.nowpage * MATERIAL_PAGE_NUM);
         var _loc2_:Function = this.getLabelAdd();
         var _loc3_:Function = this.getLabelClear();
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(_loc1_[_loc4_] != null)
            {
               _loc5_ = new ComposeLabel(_loc1_[_loc4_],_loc2_,_loc3_);
               _loc6_ = _loc4_ % 3;
               _loc7_ = _loc4_ / 3;
               _loc5_.setLoction(_loc6_ * (10 + _loc5_.width) + this._composeWindow.kind.x + 10,_loc7_ * (4 + _loc5_.height) + 6 + this._composeWindow.kind.y);
               _loc5_.holdType(this.composetype);
               this._composeWindow.addChild(_loc5_);
               if(this._paneltype == TYPE_ORG_EVOLUTION)
               {
                  if((_loc1_[_loc4_] as Organism).getId() == this.appointedOrgId)
                  {
                     _loc5_.executeRobot();
                  }
               }
            }
            this.setComposeLabelVisibleFalse();
            _loc4_++;
         }
      }
   }
}

