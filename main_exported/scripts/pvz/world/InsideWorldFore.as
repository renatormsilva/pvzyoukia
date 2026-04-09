package pvz.world
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import loading.UILoading;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.world.fport.InsideWorldFPort;
   import pvz.world.repetition.RankingControl;
   import pvz.world.tips.CheckpointPrizeTips;
   import pvz.world.tips.CheckpointTips;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldFore extends BaseWindow implements IDestroy
   {
      
      private static const CHECKPOINT:String = "checkpoint";
      
      private var _mapId:int = 0;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _uiLoad:UILoading = null;
      
      private var _insideMc:MovieClip = null;
      
      private var _checkpointNodes:Array = null;
      
      private var _fport:InsideWorldFPort = null;
      
      private var _insideWorldMap:InsideWorldScence = null;
      
      private var _tips:CheckpointTips = null;
      
      private var _prizeTips:CheckpointPrizeTips = null;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _insideUI:MovieClip = null;
      
      private var _numPanel:InsideWorldNumPanel = null;
      
      private var _changePanel:InsideWorldChangePanel = null;
      
      private var _titlePanel:InsideWorldTitlePanel = null;
      
      private var _scalePanel:InsideWorldScalePanel = null;
      
      private var changeCheckpoint:Checkpoint = null;
      
      private var _locId:int = 0;
      
      private var _starFlyManager:StarFlyManager = null;
      
      private var _rankButton:SimpleButton = null;
      
      private var _rewardsButton:MovieClip = null;
      
      private var _arrowMc:MovieClip = null;
      
      private var backBtn:SimpleButton;
      
      public function InsideWorldFore(param1:int, param2:DisplayObjectContainer)
      {
         super();
         this._mapId = param1;
         this._root = param2;
         this.doLoad(param1);
      }
      
      override public function destroy() : void
      {
         this.changeClear();
         this._starFlyManager.destroy();
         this._starFlyManager = null;
         FuncKit.clearAllChildrens(this._insideMc);
         this._insideMc = null;
      }
      
      private function changeClear() : void
      {
         PlantsVsZombies.setToFirstPageButtonVisible(false);
         this.clearAllCheckpointNode();
         this.removeEvent();
         if(this._tips != null)
         {
            this._tips.clear();
         }
         if(this._prizeTips != null)
         {
            this._prizeTips.clear();
         }
         this._tips = null;
         this._insideWorldMap = null;
         this._fport = null;
         this.clearPanel();
         this.removeRankButton();
         this.removeRewardsButton();
      }
      
      private function clearPanel() : void
      {
         this._numPanel.destroy();
         this._root.removeChild(this._numPanel);
         this._numPanel = null;
         this._changePanel.destroy();
         this._changePanel.removeEventListener(InsideWorldEvent.CHANGE,this.onInsideChange);
         this._changePanel = null;
         this._scalePanel.destroy();
         this._scalePanel.addEventListener(InsideWorldEvent.LOCTION_CHANGE,this.onInsideChange);
         this._root.removeChild(this._scalePanel);
         this._scalePanel = null;
      }
      
      private function clearAllCheckpointNode() : void
      {
         if(this._checkpointNodes == null || this._checkpointNodes.length < 1)
         {
            return;
         }
         var _loc1_:int = int(this._checkpointNodes.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.removeCheckpointNodeEvent(this._checkpointNodes[_loc2_]);
            (this._checkpointNodes[_loc2_] as CheckpointNode).destroy();
            _loc2_++;
         }
         this._checkpointNodes = null;
      }
      
      private function doLoad(param1:int) : void
      {
         this._mapId = param1;
         this._uiLoad = new UILoading(this._root,GlobalConstants.PVZ_RES_BASE_URL,"config/load/world/insideWorld_" + param1 + ".xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         this._fport = new InsideWorldFPort(this);
         this.init();
      }
      
      private function showAllCheckpointFalse() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._insideMc.numChildren)
         {
            if(this._insideMc.getChildAt(_loc1_).name.indexOf(CHECKPOINT) != -1)
            {
               this._insideMc.getChildAt(_loc1_).visible = false;
            }
            _loc1_++;
         }
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.insideWorld" + this._mapId);
         if(this._insideMc != null)
         {
            FuncKit.clearAllChildrens(this._insideMc);
            this._root.removeChild(this._insideMc);
            this._insideMc = null;
         }
         this._insideMc = new _loc1_();
         this.showAllCheckpointFalse();
         this._root.addChild(this._insideMc);
         this._tips = new CheckpointTips();
         this._insideMc.addChild(this._tips);
         this._prizeTips = new CheckpointPrizeTips();
         this._insideMc.addChild(this._prizeTips);
         this.backBtn = GetDomainRes.getSimpleButton("pvz.ui.fanhui");
         this.backBtn.x = 710;
         this._root.addChild(this.backBtn);
         PlantsVsZombies.showDataLoading(true);
         this._fport.initInsideWorld(this._mapId);
         this.addEvent();
         this.addPanel();
         this.addRankButton();
         this.addRewardsButton();
         this.initStarManager();
      }
      
      private function initStarManager() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.star");
         this._starFlyManager = new StarFlyManager(this._root,_loc1_);
      }
      
      private function addPanel() : void
      {
         this._numPanel = new InsideWorldNumPanel();
         this._numPanel.x = 14;
         this._numPanel.y = 70;
         this._root.addChild(this._numPanel);
         this._changePanel = new InsideWorldChangePanel(this._mapId);
         this._changePanel.addEventListener(InsideWorldEvent.CHANGE,this.onInsideChange);
         this._root.addChild(this._changePanel);
         this._titlePanel = new InsideWorldTitlePanel(this._mapId);
         this._titlePanel.addEventListener(InsideWorldEvent.TO_CHECKPOINT,this.onInsideChange);
         this._root.addChild(this._titlePanel);
         this._scalePanel = new InsideWorldScalePanel(this._insideMc);
         this._scalePanel.x = 20;
         this._scalePanel.y = 94;
         this._scalePanel.addEventListener(InsideWorldEvent.LOCTION_CHANGE,this.onInsideChange);
         this._root.addChild(this._scalePanel);
      }
      
      private function addRankButton() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.rankButton");
         this._rankButton = new _loc1_();
         this._rankButton.addEventListener(MouseEvent.CLICK,this.onRankClick);
         this._rankButton.x = 300;
         this._rankButton.y = 4;
         this._root.addChild(this._rankButton);
      }
      
      private function onRankClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         new RankingControl(this._mapId);
      }
      
      private function removeRankButton() : void
      {
         this._rankButton.removeEventListener(MouseEvent.CLICK,this.onRankClick);
         this._root.removeChild(this._rankButton);
      }
      
      private function addRewardsButton() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.rewardsButton");
         this._rewardsButton = new _loc1_();
         this._rewardsButton.gotoAndStop(1);
         this._rewardsButton.buttonMode = true;
         this._rewardsButton.addEventListener(MouseEvent.CLICK,this.onRewardsClick);
         this._rewardsButton.addEventListener(MouseEvent.MOUSE_OVER,this.onRewardsOver);
         this._rewardsButton.addEventListener(MouseEvent.MOUSE_OUT,this.onRewardsOut);
         this._rewardsButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onRewardsDown);
         this._rewardsButton.x = 194;
         this._rewardsButton.y = -1;
         this._root.addChild(this._rewardsButton);
      }
      
      private function removeRewardsButton() : void
      {
         this._rewardsButton.removeEventListener(MouseEvent.CLICK,this.onRewardsClick);
         this._root.removeChild(this._rewardsButton);
      }
      
      private function onRewardsOver(param1:MouseEvent) : void
      {
         this._rewardsButton.gotoAndStop(2);
      }
      
      private function onRewardsDown(param1:MouseEvent) : void
      {
         this._rewardsButton.gotoAndStop(3);
      }
      
      private function onRewardsOut(param1:MouseEvent) : void
      {
         this._rewardsButton.gotoAndStop(1);
      }
      
      private function onRewardsClick(param1:MouseEvent) : void
      {
         new InsideWorldRewardWindow(this._root,this._mapId,this.setIsRewards);
      }
      
      private function setIsRewards(param1:Boolean) : void
      {
         this._rewardsButton["_effect"].visible = param1;
      }
      
      private function onInsideChange(param1:InsideWorldEvent) : void
      {
         if(param1.type == InsideWorldEvent.CHANGE)
         {
            this.changeClear();
            this.doLoad(param1.id);
         }
         else if(param1.type == InsideWorldEvent.LOCTION_CHANGE)
         {
            if(param1.id != 0)
            {
               this._locId = param1.id;
            }
            this.setLoctionById();
         }
         else if(param1.type == InsideWorldEvent.TO_CHECKPOINT)
         {
            this.toCheckpoint(param1.id,false);
         }
      }
      
      private function addEvent() : void
      {
         this._insideMc.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._insideMc.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.backBtn.addEventListener(MouseEvent.CLICK,this.onBackHandler);
      }
      
      private function removeEvent() : void
      {
         this._insideMc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._insideMc.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.backBtn.addEventListener(MouseEvent.CLICK,this.onBackHandler);
      }
      
      private function onBackHandler(param1:MouseEvent) : void
      {
         this.destroy();
         PlantsVsZombies.backToFirstPage();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = new Rectangle(PlantsVsZombies.WIDTH - this.getBGWidth(),PlantsVsZombies.HEIGHT - this.getBGHeight(),this.getBGWidth() - PlantsVsZombies.WIDTH,this.getBGHeight() - PlantsVsZombies.HEIGHT);
         this._insideMc.startDrag(false,_loc2_);
         this.showNodesId(true);
         this.showNodesStars(true);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._insideMc.stopDrag();
         this.showNodesId(false);
         this.showNodesStars(false);
      }
      
      private function onChange(param1:CheckpointEvent) : void
      {
         if(param1.type == CheckpointEvent.CHANGE)
         {
            this.changeCheckpoint = param1.checkpoint;
            this._fport.updateInsideWorld(this._mapId);
         }
         else if(param1.type == CheckpointEvent.SHOW_TIPS)
         {
            this.showCheckpointTips(param1.checkpoint,new Point(param1.target._source.x + (param1.target._source as DisplayObject).width / 2,param1.target._source.y + (param1.target._source as DisplayObject).height));
         }
         else if(param1.type == CheckpointEvent.CLEAR_TIPS)
         {
            this.clearCheckpointTips();
         }
         else if(param1.type == CheckpointEvent.UPDATE)
         {
            this._numPanel.showNum();
            this.updateNodes();
         }
      }
      
      private function updateNodes() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._checkpointNodes.length)
         {
            (this._checkpointNodes[_loc1_] as CheckpointNode).changeType();
            _loc1_++;
         }
      }
      
      private function showNodesId(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpointNodes.length)
         {
            (this._checkpointNodes[_loc2_] as CheckpointNode).setCheckpointIdVisible(param1);
            _loc2_++;
         }
      }
      
      private function showNodesStars(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpointNodes.length)
         {
            (this._checkpointNodes[_loc2_] as CheckpointNode).showCheckpointCompStarVisible(param1);
            _loc2_++;
         }
      }
      
      private function showCheckpointTips(param1:Checkpoint, param2:Point) : void
      {
         this._tips.show(param1,param2);
      }
      
      private function clearCheckpointTips() : void
      {
         this._tips.clear();
      }
      
      private function onPrizeChange(param1:CheckpointPrizeEvent) : void
      {
         if(param1.type == CheckpointPrizeEvent.SHOW_PRIZE_TIPS)
         {
            this.showCheckpointPrizeTips(param1.toolid,new Point(param1.target._source.x + (param1.target._source as DisplayObject).width / 2,param1.target._source.y + (param1.target._source as DisplayObject).height));
         }
         else if(param1.type == CheckpointPrizeEvent.CLEAR_PRIZE_TIPS)
         {
            this.clearCheckpointPrizeTips();
         }
      }
      
      private function showCheckpointPrizeTips(param1:int, param2:Point) : void
      {
         this._prizeTips.show(param1,param2);
      }
      
      private function clearCheckpointPrizeTips() : void
      {
         this._prizeTips.clear();
      }
      
      public function portDateInit(param1:Array, param2:int, param3:Array, param4:int, param5:int, param6:Boolean) : void
      {
         var _loc9_:CheckpointNode = null;
         this.clearAllCheckpointNode();
         if(param1 == null || param1.length < 1)
         {
            throw new Error("InsideWorld" + this._mapId + " checkpoints is null");
         }
         this._checkpointNodes = new Array();
         this._insideWorldMap = new InsideWorldScence();
         this._locId = param4;
         var _loc7_:int = 0;
         while(_loc7_ < param1.length)
         {
            _loc9_ = new CheckpointNode(this._insideMc[CHECKPOINT + (param1[_loc7_] as Checkpoint).getId()],param1[_loc7_],this._mapId);
            this.addCheckpointNodeEvent(_loc9_);
            this._checkpointNodes.push(_loc9_);
            this._insideWorldMap.pushCheckpoint(param1[_loc7_]);
            _loc7_++;
         }
         var _loc8_:int = 0;
         while(_loc8_ < this._checkpointNodes.length)
         {
            this.showCheckpointNode(this._checkpointNodes[_loc8_]);
            this.showArrivedLink(this._checkpointNodes[_loc8_]);
            _loc8_++;
         }
         this.setIsRewards(param6);
         this._changePanel.update(param3);
         this._titlePanel.initComp(param5);
         this.setInsideWorldHelpArrow();
         this.playerManager.getPlayer().setWorldBuyNum(param2);
         this._numPanel.showNum();
         this.setLoctionById();
         PlantsVsZombies.showDataLoading(false);
      }
      
      public function portDateUpdate(param1:Array, param2:int, param3:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc7_:CheckpointNode = null;
         var _loc8_:CheckpointNode = null;
         this._numPanel.showNum();
         var _loc4_:Array = this.changeCheckpoint.getDownlinks();
         var _loc5_:Array = this.getAddCheckpoints(param1,_loc4_);
         if(_loc5_ != null || _loc5_.length > 1)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(this._insideWorldMap.isExistent((_loc5_[_loc6_] as Checkpoint).getId()))
               {
                  _loc7_ = this.getCheckpointNode((_loc5_[_loc6_] as Checkpoint).getId());
                  _loc7_._checkpoint = _loc5_[_loc6_];
                  this._insideWorldMap.changeCheckpointType(_loc5_[_loc6_]);
               }
               else
               {
                  _loc8_ = new CheckpointNode(this._insideMc[CHECKPOINT + (_loc5_[_loc6_] as Checkpoint).getId()],_loc5_[_loc6_],this._mapId);
                  this.addCheckpointNodeEvent(_loc8_);
                  this._checkpointNodes.push(_loc8_);
                  this._insideWorldMap.pushCheckpoint(_loc5_[_loc6_]);
               }
               _loc6_++;
            }
         }
         this.setIsRewards(param3);
         this.updateNodes();
         this.setInsideWorldHelpArrow();
         this.showInsideWorldComp(this.changeCheckpoint.getId(),param2 - this._titlePanel.getComp());
      }
      
      private function setInsideWorldHelpArrow() : void
      {
         if(this._arrowMc != null)
         {
            this._insideMc.removeChild(this._arrowMc);
            this._arrowMc = null;
         }
         if(this._checkpointNodes.length != 1)
         {
            return;
         }
         var _loc1_:CheckpointNode = this._checkpointNodes[0];
         if(_loc1_._checkpoint.getId() != 1)
         {
            return;
         }
         var _loc2_:Class = DomainAccess.getClass("ui.world.arrow2");
         this._arrowMc = new _loc2_();
         this._arrowMc.x = _loc1_.getCenter().x - 20;
         this._arrowMc.y = _loc1_.getCenter().y - 80;
         this._insideMc.addChild(this._arrowMc);
      }
      
      private function showInsideWorldComp(param1:int, param2:int) : void
      {
         showBG(this._root);
         var _loc3_:CheckpointNode = this.getCheckpointNode(param1);
         this._titlePanel.setId(param1);
         this._starFlyManager.flyStars(this.getNodeRootLoc(_loc3_.getCenter()),this._titlePanel.getCompPoint(),param2,this._titlePanel.addComplete);
      }
      
      private function getNodeRootLoc(param1:Point) : Point
      {
         var _loc2_:Point = new Point();
         _loc2_.x = this._insideMc.x + param1.x * this._insideMc.scaleX;
         _loc2_.y = this._insideMc.y + param1.y * this._insideMc.scaleY;
         return _loc2_;
      }
      
      private function getAddCheckpoints(param1:Array, param2:Array) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:Array = new Array();
         if(param1 == null || param1.length < 1)
         {
            return _loc3_;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               if((param1[_loc4_] as Checkpoint).getId() == param2[_loc5_])
               {
                  _loc3_.push(param1[_loc4_]);
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function addCheckpointNodeEvent(param1:CheckpointNode) : void
      {
         param1.addEventListener(CheckpointEvent.CHANGE,this.onChange);
         param1.addEventListener(CheckpointEvent.CLEAR_TIPS,this.onChange);
         param1.addEventListener(CheckpointEvent.SHOW_TIPS,this.onChange);
         param1.addEventListener(CheckpointPrizeEvent.CLEAR_PRIZE_TIPS,this.onPrizeChange);
         param1.addEventListener(CheckpointPrizeEvent.SHOW_PRIZE_TIPS,this.onPrizeChange);
         param1.addEventListener(CheckpointEvent.UPDATE,this.onChange);
         param1.addEventListener(InsideWorldEvent.CHANGE,this.onInsideChange);
         param1.addEventListener(InsideWorldEvent.LOCTION_CHANGE,this.onInsideChange);
      }
      
      private function removeCheckpointNodeEvent(param1:CheckpointNode) : void
      {
         param1.removeEventListener(CheckpointEvent.CHANGE,this.onChange);
         param1.removeEventListener(CheckpointEvent.CLEAR_TIPS,this.onChange);
         param1.removeEventListener(CheckpointEvent.SHOW_TIPS,this.onChange);
         param1.removeEventListener(CheckpointPrizeEvent.CLEAR_PRIZE_TIPS,this.onPrizeChange);
         param1.removeEventListener(CheckpointPrizeEvent.SHOW_PRIZE_TIPS,this.onPrizeChange);
         param1.removeEventListener(CheckpointEvent.UPDATE,this.onChange);
         param1.removeEventListener(InsideWorldEvent.CHANGE,this.onInsideChange);
         param1.removeEventListener(InsideWorldEvent.LOCTION_CHANGE,this.onInsideChange);
      }
      
      private function showArrivedLink(param1:CheckpointNode) : void
      {
         if(param1._checkpoint.getIsPass())
         {
            this.toCheckpoint(param1._checkpoint.getId(),true);
            return;
         }
      }
      
      private function showCheckpointNode(param1:CheckpointNode) : void
      {
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = param1._checkpoint.getUplinks();
         if(_loc2_ == null || _loc2_.length < 1 || _loc2_[0] == "")
         {
            param1.setVisible(true);
            return;
         }
         if(param1._checkpoint.getType() == Checkpoint.NOT_ENOUGH_PATH)
         {
            param1.setVisible(true);
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(this.getCheckpointNode(_loc2_[_loc3_]) == null || !this.getCheckpointNode(_loc2_[_loc3_])._checkpoint.getIsPass())
            {
               param1.setVisible(false);
               return;
            }
            _loc3_++;
         }
         param1.setVisible(true);
         param1.showType();
      }
      
      private function toCheckpoint(param1:int, param2:Boolean) : void
      {
         var _loc8_:CheckpointNode = null;
         var _loc3_:Array = this._insideWorldMap.getCheckPoint(param1).getDownlinks();
         var _loc4_:CheckpointNode = this.getCheckpointNode(param1);
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc8_ = this.getCheckpointNode(_loc3_[_loc6_]);
            if(_loc8_ != null)
            {
               _loc5_.push(_loc8_);
            }
            _loc6_++;
         }
         if(_loc5_ == null || _loc5_.length < 1)
         {
            removeBG();
            return;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            this.lineToCheckPoint(_loc4_,_loc5_[_loc7_],param2);
            _loc7_++;
         }
      }
      
      private function lineToCheckPoint(param1:CheckpointNode, param2:CheckpointNode, param3:Boolean) : void
      {
         var showNode:Function = null;
         var s_node:CheckpointNode = param1;
         var e_node:CheckpointNode = param2;
         var immediately:Boolean = param3;
         showNode = function():void
         {
            showCheckpointNode(e_node);
            removeBG();
         };
         var pinfo:PathInfo = new PathInfo(s_node.getLinkPoint(e_node.getCenter(),false),e_node.getLinkPoint(s_node.getCenter(),true),s_node.getLinkPoint(e_node.getCenter(),false));
         this._insideMc.addChildAt(new LineSprite(pinfo,10,showNode,immediately),1);
      }
      
      private function getCheckpointNode(param1:int) : CheckpointNode
      {
         if(this._checkpointNodes == null || this._checkpointNodes.length < 1)
         {
            throw new Error("_checkpoints is null!");
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpointNodes.length)
         {
            if((this._checkpointNodes[_loc2_] as CheckpointNode)._checkpoint.getId() == param1)
            {
               return this._checkpointNodes[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function setLoctionById() : void
      {
         this._insideMc.stopDrag();
         var _loc1_:CheckpointNode = this.getCheckpointNode(this._locId);
         if(_loc1_ == null)
         {
            _loc1_ = this._checkpointNodes[0];
         }
         var _loc2_:Point = _loc1_.getCenter();
         this._insideMc.x = PlantsVsZombies.WIDTH / 2 - _loc2_.x * this._insideMc.scaleX;
         this._insideMc.y = PlantsVsZombies.HEIGHT / 2 - _loc2_.y * this._insideMc.scaleY;
         if(this._insideMc.y > 0)
         {
            this._insideMc.y = 0;
         }
         if(this._insideMc.x > 0)
         {
            this._insideMc.x = 0;
         }
         if(this._insideMc.x < PlantsVsZombies.WIDTH - this.getBGWidth())
         {
            this._insideMc.x = PlantsVsZombies.WIDTH - this.getBGWidth();
         }
         if(this._insideMc.y < PlantsVsZombies.HEIGHT - this.getBGHeight())
         {
            this._insideMc.y = PlantsVsZombies.HEIGHT - this.getBGHeight();
         }
      }
      
      private function getBGWidth() : int
      {
         return this._insideMc.getChildAt(0).width * this._insideMc.scaleX;
      }
      
      private function getBGHeight() : int
      {
         return this._insideMc.getChildAt(0).height * this._insideMc.scaleY;
      }
   }
}

