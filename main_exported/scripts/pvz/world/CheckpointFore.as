package pvz.world
{
   import entity.Goods;
   import entity.Grid;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import node.OrganismNode;
   import pvz.shop.BuyGoodsWindow;
   import pvz.shop.ShopWindow;
   import pvz.world.fport.CheckpointForeFPort;
   import pvz.world.tips.CheckpointForeBoxTips;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionChangeWindow;
   import windows.RechargeWindow;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class CheckpointFore implements IDestroy
   {
      
      private var _bgType:int = 0;
      
      private var _checkpoint:Checkpoint = null;
      
      private var _prizes:Array = null;
      
      private var _orgs:Array = null;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _fore:MovieClip = null;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _fport:CheckpointForeFPort = null;
      
      private var _panel:InsideWorldNumPanel = null;
      
      private var _box:CheckpointForeBox = null;
      
      private var _boxTips:CheckpointForeBoxTips = null;
      
      private var _titlePanel:CheckpointTitlePanel = null;
      
      private var _update:Function = null;
      
      public function CheckpointFore(param1:DisplayObjectContainer, param2:int, param3:Checkpoint, param4:Function)
      {
         super();
         PlantsVsZombies.setToFirstPageButtonVisible(false);
         this._bgType = param2;
         this._checkpoint = param3;
         this._root = param1;
         this._update = param4;
         this.init();
      }
      
      private function init() : void
      {
         var _loc3_:Class = null;
         if(this._checkpoint.getIsBoss())
         {
            _loc3_ = DomainAccess.getClass("ui.world.checkpointFore" + this._bgType);
         }
         else
         {
            _loc3_ = DomainAccess.getClass("ui.world.checkpointForeBoss" + this._bgType);
         }
         var _loc1_:Class = DomainAccess.getClass("ui.world.checkpointFore");
         var _loc2_:MovieClip = new _loc3_();
         this._fore = new _loc1_();
         this._fore["checkpointNumPanel"].visible = false;
         this._fore.addChildAt(_loc2_,0);
         this.initEvent();
         this._root.addChild(this._fore);
         this.dateInit();
         this._panel = new InsideWorldNumPanel();
         this._panel.x = 9;
         this._panel.y = 11;
         this._fore.addChild(this._panel);
         this.addBox(_loc2_);
         this._boxTips = new CheckpointForeBoxTips();
         this._fore.addChild(this._boxTips);
         this._titlePanel = new CheckpointTitlePanel(this._checkpoint.getName());
         this._titlePanel.x = 300;
         this._titlePanel.y = 0;
         this._fore.addChild(this._titlePanel);
      }
      
      private function addBox(param1:DisplayObjectContainer) : void
      {
         this._box = new CheckpointForeBox(this._checkpoint);
         this._box.x = param1["_box_point"].x;
         this._box.y = param1["_box_point"].y;
         this._box.addEventListener(CheckpointEvent.SHOW_BOX_TIPS,this.onShowBoxTip);
         this._box.addEventListener(CheckpointEvent.CLEAR_BOX_TIPS,this.onClearBoxTip);
         this._fore.addChild(this._box);
      }
      
      private function onShowBoxTip(param1:CheckpointEvent) : void
      {
         this._boxTips.show(this._checkpoint,new Point(this._box.x + this._box.width + 8,this._box.y - 14));
      }
      
      private function onClearBoxTip(param1:CheckpointEvent) : void
      {
         this._boxTips.clear();
      }
      
      private function removeBox() : void
      {
         this._box.destroy();
         this._fore.removeChild(this._box);
      }
      
      private function dateInit() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport = new CheckpointForeFPort(this);
         this._fport.foreInfo(this._checkpoint.getId());
      }
      
      public function portInit(param1:Array, param2:Array) : void
      {
         if(param1 == null || param1.length < 1)
         {
            throw new Error("CheckpointFore id " + this._checkpoint.getId() + "  orgs is null!");
         }
         if(param2 == null || param2.length < 1)
         {
            throw new Error("CheckpointFore id " + this._checkpoint.getId() + "  prizes is null!");
         }
         this._orgs = param1;
         this.showMonster();
         this._prizes = param2;
         this._checkpoint.setPrizes(this._prizes);
         this.showNum();
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function showNum() : void
      {
         this.clearNum();
         this._fore["checkpointNumPanel"].visible = true;
         if(this._checkpoint.getBattleTimes() == -1)
         {
            this._fore["checkpointNumPanel"].visible = false;
         }
         else
         {
            this._fore["checkpointNumPanel"]["_node_checkpoint"].addChild(FuncKit.getNumEffect(this._checkpoint.getBattleTimes() + ""));
         }
      }
      
      private function clearNum() : void
      {
         if(this._fore["checkpointNumPanel"]["_node_checkpoint"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._fore["checkpointNumPanel"]["_node_checkpoint"]);
         }
      }
      
      private function initEvent() : void
      {
         this._fore["_bt_battleReady"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._fore["_bt_return"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._fore["checkpointNumPanel"]["_bt_addCheckpoint"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._fore["_bt_battleReady"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._fore["_bt_return"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._fore["checkpointNumPanel"]["_bt_addCheckpoint"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:CheckpointReadyWindow = null;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_battleReady")
         {
            if(this.playerManager.getPlayer().getWorldTimes() <= 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world017"));
               return;
            }
            if(this._checkpoint.getMaxBattleTimes() != -1 && this._checkpoint.getBattleTimes() != -1 && this._checkpoint.getBattleTimes() < 1)
            {
               this.addCheckpointNum();
               return;
            }
            if(this.playerManager.getPlayer().getMoney() < this._checkpoint.getCost())
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world001",this._checkpoint.getCost() - this.playerManager.getPlayer().getMoney()));
               return;
            }
            _loc2_ = new CheckpointReadyWindow();
            _loc2_.show(this.back,this._checkpoint);
            this.clearMonster();
         }
         else if(param1.currentTarget.name == "_bt_return")
         {
            this.destroy();
            this._update(false);
         }
         else if(param1.currentTarget.name == "_bt_addCheckpoint")
         {
            this.addCheckpointNum();
         }
      }
      
      private function update() : void
      {
         this.showaddCheckpointNum();
         this._panel.showNum();
         this.showNum();
         this.showMonster();
      }
      
      private function showaddCheckpointNum() : void
      {
         if(this._checkpoint.getBattleTimes() == 0)
         {
            this.addCheckpointNum();
         }
      }
      
      private function back(param1:Boolean = false) : void
      {
         if(param1)
         {
            if(this._checkpoint.getIsPass())
            {
               this.update();
            }
            else
            {
               this._update(true);
               this.destroy();
            }
         }
         else
         {
            this.update();
         }
      }
      
      private function addCheckpointNum() : void
      {
         if(this._checkpoint.getMaxBattleTimes() == -1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world009"));
            return;
         }
         var _loc1_:Tool = this.playerManager.getPlayer().getTool(ToolManager.TOOL_WORLD_ADDCHECKPOINT);
         if(_loc1_ == null || _loc1_.getNum() < 1)
         {
            this.toBuyCheckpointTool();
         }
         else
         {
            this.addCheckpointNumByTool(_loc1_);
         }
      }
      
      private function toBuyCheckpointTool() : void
      {
         var toBuyTool:Function = null;
         toBuyTool = function():void
         {
            _fport.initShopDate();
         };
         var rechargeWindow:RechargeWindow = new RechargeWindow();
         rechargeWindow.init(LangManager.getInstance().getLanguage("world015"),toBuyTool,RechargeWindow.BUY);
      }
      
      public function portBuyCheckpoint(param1:Goods) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc2_:BuyGoodsWindow = new BuyGoodsWindow();
         _loc2_.init(param1,null,ShopWindow.SHOP_RMB,null,false);
         _loc2_.show();
      }
      
      private function addCheckpointNumByTool(param1:Tool) : void
      {
         var toUseTool:Function = null;
         var t:Tool = param1;
         toUseTool = function(param1:int):String
         {
            return LangManager.getInstance().getLanguage("world013",param1);
         };
         new ActionChangeWindow().init(t.getPicId(),Icon.TOOL,toUseTool,this.useToolAddCheckpoint,true,t.getNum());
      }
      
      private function useToolAddCheckpoint(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport.useToolAddCheckpoint(this._checkpoint.getId(),param1);
      }
      
      public function portUseToolAddCheckpoint(param1:int) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc2_:int = param1 - this._checkpoint.getBattleTimes();
         this._checkpoint.setBattleTimes(param1);
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("world014",_loc2_));
         this.playerManager.getPlayer().useTools(ToolManager.TOOL_WORLD_ADDCHECKPOINT,_loc2_);
         this.showNum();
      }
      
      private function showMonster() : void
      {
         if(this._orgs == null || this._orgs.length < 1)
         {
            return;
         }
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this._orgs.length)
         {
            if((this._orgs[_loc3_] as Organism).getIsBoss() == 1)
            {
               _loc2_.push(this._orgs[_loc3_]);
            }
            else
            {
               _loc1_.push(this._orgs[_loc3_]);
            }
            _loc3_++;
         }
         this.doWitchArr(_loc1_);
         this.doWitchArr(_loc2_);
         var _loc4_:Array = _loc2_.concat(_loc1_);
         var _loc5_:CheckpointForeMapManager = new CheckpointForeMapManager();
         _loc5_.areaAndGrids(_loc4_);
         _loc5_.setGridsLoction();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.getGrids().length)
         {
            this.addOrg(_loc5_.getGrids()[_loc6_]);
            _loc6_++;
         }
         this._fore.setChildIndex(this._fore["_bt_battleReady"],this._fore.numChildren - 1);
         this._fore.setChildIndex(this._box,this._fore.numChildren - 1);
      }
      
      private function addOrg(param1:Grid) : void
      {
         var _loc2_:OrganismNode = new OrganismNode(param1.getOrg(),1,OrganismNode.CHECKPOINT_READY,true);
         _loc2_.x = param1.getX() + 180;
         _loc2_.y = param1.getY() + 350;
         this._fore.addChild(_loc2_);
      }
      
      private function clearMonster() : void
      {
         if(this._fore.numChildren < 1)
         {
            return;
         }
         var _loc1_:* = int(this._fore.numChildren - 1);
         while(_loc1_ >= 0)
         {
            if(this._fore.getChildAt(_loc1_) is OrganismNode)
            {
               this._fore.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      public function destroy() : void
      {
         this.removeBox();
         this._panel.destroy();
         this._fore.removeChild(this._panel);
         this._panel = null;
         this._titlePanel.destroy();
         this._fore.removeChild(this._titlePanel);
         this._titlePanel = null;
         this.removeEvent();
         this.clearMonster();
         this.clearNum();
         this._root.removeChild(this._fore);
      }
      
      private function doWitchArr(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Organism = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc5_:int = int(param1.length);
         while(_loc2_ < _loc5_)
         {
            _loc6_ = param1[_loc2_];
            _loc3_ = _loc2_ + 1;
            _loc4_ = _loc2_;
            while(_loc3_ < _loc5_)
            {
               if(this.getGird(param1[_loc2_]) < this.getGird(param1[_loc3_]))
               {
                  param1[_loc2_] = param1[_loc3_];
                  _loc4_ = _loc3_;
               }
               else if(this.getGird(param1[_loc2_]) == this.getGird(param1[_loc3_]))
               {
                  if(this.getQuality(param1[_loc2_]) < this.getQuality(param1[_loc3_]))
                  {
                     param1[_loc2_] = param1[_loc3_];
                     _loc4_ = _loc3_;
                  }
               }
               _loc3_++;
            }
            param1[_loc4_] = _loc6_;
            _loc2_++;
         }
      }
      
      private function getGird(param1:Organism) : int
      {
         return param1.getWidth() * param1.getHeight();
      }
      
      private function getQuality(param1:Organism) : int
      {
         return XmlQualityConfig.getInstance().getID(param1.getQuality_name());
      }
   }
}

