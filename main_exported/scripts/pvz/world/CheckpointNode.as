package pvz.world
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import utils.FuncKit;
   import utils.Singleton;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class CheckpointNode extends EventDispatcher implements IDestroy
   {
      
      public var _source:MovieClip = null;
      
      public var _checkpoint:Checkpoint = null;
      
      private var _mapId:int = 0;
      
      private var _selectMc:MovieClip = null;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function CheckpointNode(param1:MovieClip, param2:Checkpoint, param3:int)
      {
         super();
         this._source = param1;
         this._checkpoint = param2;
         this._mapId = param3;
         param1.buttonMode = true;
         this.initEvent();
         this.showType();
         this.showPrizes();
         this.setCheckpointId();
         this.setCheckpointCompStar();
         this.setSelectMc();
         this.setVisible(false);
      }
      
      private function setSelectMc() : void
      {
         var _loc1_:Class = null;
         if(this._checkpoint.getIsBoss())
         {
            _loc1_ = DomainAccess.getClass("ui.world.selected_boss");
            this._selectMc = new _loc1_();
            this._selectMc.x = this._source.x;
            this._selectMc.y = this._source.y;
         }
         else
         {
            _loc1_ = DomainAccess.getClass("ui.world.selected_normal");
            this._selectMc = new _loc1_();
            this._selectMc.x = this._source.x - 13;
            this._selectMc.y = this._source.y - 11;
         }
         this._selectMc.gotoAndStop(1);
         this._selectMc.visible = false;
         this._selectMc.mouseChildren = false;
         this._selectMc.mouseEnabled = false;
         this._source.parent.addChild(this._selectMc);
      }
      
      private function showPrizes() : void
      {
         var _loc2_:Sprite = null;
         if(this._checkpoint.getImportantPrizes() == null || this._checkpoint.getImportantPrizes().length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._checkpoint.getImportantPrizes().length)
         {
            _loc2_ = new Sprite();
            _loc2_.name = "prize_" + this._checkpoint.getId() + "_" + _loc1_;
            Icon.setUrlIcon(_loc2_,XmlToolsConfig.getInstance().getToolAttribute(this._checkpoint.getImportantPrizes()[_loc1_]).getPicId(),Icon.TOOL_1,0.5);
            _loc2_.x = 6 + this._source.x + _loc2_.width * _loc1_;
            _loc2_.y = this._source.y + this._source.height - _loc2_.height - 3;
            _loc2_.visible = false;
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onPrizesOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onPrizesOut);
            this._source.parent.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function onPrizesOver(param1:MouseEvent) : void
      {
         var _loc2_:int = int((param1.target.name as String).split("_")[2]);
         dispatchEvent(new CheckpointPrizeEvent(CheckpointPrizeEvent.SHOW_PRIZE_TIPS,this._checkpoint.getImportantPrizes()[_loc2_]));
      }
      
      private function onPrizesOut(param1:MouseEvent) : void
      {
         dispatchEvent(new CheckpointPrizeEvent(CheckpointPrizeEvent.CLEAR_PRIZE_TIPS,0));
      }
      
      private function setPrizesVisible(param1:Boolean) : void
      {
         if(this._checkpoint.getImportantPrizes() == null || this._checkpoint.getImportantPrizes().length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._checkpoint.getImportantPrizes().length)
         {
            this._source.parent.getChildByName("prize_" + this._checkpoint.getId() + "_" + _loc2_).visible = param1;
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         this._source.addEventListener(MouseEvent.CLICK,this.onClick);
         this._source.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._source.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         this._source.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._source.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._source.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._selectMc.visible = true;
         this._selectMc.play();
         dispatchEvent(new CheckpointEvent(CheckpointEvent.SHOW_TIPS,this._checkpoint));
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._selectMc.visible = false;
         this._selectMc.gotoAndStop(1);
         dispatchEvent(new CheckpointEvent(CheckpointEvent.CLEAR_TIPS,this._checkpoint));
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._checkpoint.getType() < Checkpoint.NOT_OPEN)
         {
            this.setPrizesVisible(false);
         }
         else
         {
            this.setPrizesVisible(param1);
         }
         this._source.visible = param1;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._checkpoint.getIsMap())
         {
            dispatchEvent(new InsideWorldEvent(InsideWorldEvent.CHANGE,this._checkpoint.getNextMapId()));
            return;
         }
         dispatchEvent(new InsideWorldEvent(InsideWorldEvent.LOCTION_CHANGE,this._checkpoint.getId()));
         switch(this._checkpoint.getType())
         {
            case Checkpoint.FINISHED:
               this.toCheckpointFore();
               break;
            case Checkpoint.NOT_OPEN:
               this.openCheckpoint();
               break;
            case Checkpoint.UNFINISHED:
               this.toCheckpointFore();
         }
      }
      
      private function toCheckpointFore() : void
      {
         new CheckpointFore(this._source.parent.parent,this._mapId,this._checkpoint,this.update);
      }
      
      private function update(param1:Boolean) : void
      {
         if(param1)
         {
            this.showCheckpointFinished();
            this._checkpoint.setType(Checkpoint.FINISHED);
         }
         else
         {
            dispatchEvent(new CheckpointEvent(CheckpointEvent.UPDATE,this._checkpoint));
         }
         this.showType();
      }
      
      private function openCheckpoint() : void
      {
         new OpenWindow(PlantsVsZombies._node,this.showCheckpointOpened).show(this._checkpoint);
      }
      
      private function showCheckpointFinished() : void
      {
         var finishEffect:MovieClip = null;
         var onPlay:Function = null;
         onPlay = function(param1:Event):void
         {
            if(finishEffect.currentFrame == finishEffect.totalFrames)
            {
               finishEffect.gotoAndStop(1);
               finishEffect.visible = false;
               finishEffect.removeEventListener(Event.ENTER_FRAME,onPlay);
               _source.parent.removeChild(finishEffect);
               dispatchEvent(new CheckpointEvent(CheckpointEvent.CHANGE,_checkpoint));
            }
         };
         var temp:Class = DomainAccess.getClass("ui.world.checkpointFinish");
         finishEffect = new temp();
         finishEffect.addEventListener(Event.ENTER_FRAME,onPlay);
         finishEffect.x = this._source.x + this._source.width / 2;
         finishEffect.y = this._source.y + this._source.height / 2;
         this._source.parent.addChild(finishEffect);
         this._source.gotoAndPlay(1);
      }
      
      private function showCheckpointOpened() : void
      {
         var openEffect:MovieClip = null;
         var onPlay:Function = null;
         var temp:Class = null;
         onPlay = function(param1:Event):void
         {
            if(openEffect.currentFrame == openEffect.totalFrames)
            {
               openEffect.gotoAndStop(1);
               openEffect.visible = false;
               openEffect.removeEventListener(Event.ENTER_FRAME,onPlay);
               _source.parent.removeChild(openEffect);
            }
         };
         this._checkpoint.setType(Checkpoint.UNFINISHED);
         this.update(false);
         if(this._checkpoint.getIsBoss())
         {
            temp = DomainAccess.getClass("ui.world.checkpointOpenBoss");
         }
         else
         {
            temp = DomainAccess.getClass("ui.world.checkpointOpen");
         }
         openEffect = new temp();
         openEffect.addEventListener(Event.ENTER_FRAME,onPlay);
         openEffect.x = this._source.x;
         openEffect.y = this._source.y;
         this._source.parent.addChild(openEffect);
         this._source.gotoAndPlay(1);
      }
      
      public function getLinkPoint(param1:Point, param2:Boolean) : Point
      {
         var _loc3_:Point = new Point();
         var _loc4_:Point = this.getCenter();
         if(_loc4_.x > param1.x)
         {
            if(param2)
            {
               _loc3_.x = this._source.x;
            }
            else
            {
               _loc3_.x = this._source.x;
            }
            _loc3_.y = _loc4_.y;
         }
         else if(_loc4_.x < param1.x)
         {
            if(param2)
            {
               _loc3_.x = this._source.x + this._source.width;
            }
            else
            {
               _loc3_.x = this._source.x + this._source.width;
            }
            _loc3_.y = _loc4_.y;
         }
         else
         {
            _loc3_.x = _loc4_.x;
            if(_loc4_.y < param1.y)
            {
               if(param2)
               {
                  _loc3_.y = this._source.y + this._source.height;
               }
               else
               {
                  _loc3_.y = this._source.y + this._source.height;
               }
            }
            else
            {
               if(_loc4_.y <= param1.y)
               {
                  throw Error("坐标配置出问题了id " + this._checkpoint.getId() + " name " + this._checkpoint.getName());
               }
               if(param2)
               {
                  _loc3_.y = this._source.y;
               }
               else
               {
                  _loc3_.y = this._source.y;
               }
            }
         }
         return _loc3_;
      }
      
      public function changeType() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         if(this._checkpoint.getType() == Checkpoint.FINISHED || this._checkpoint.getType() == Checkpoint.UNFINISHED || this._checkpoint.getIsMap())
         {
            return;
         }
         if(this._checkpoint.getType() == Checkpoint.NOT_ENOUGH_TOOL)
         {
            _loc1_ = this.getNeedTools(this._checkpoint.getOpenTools());
            if(_loc1_ == null || _loc1_.length < 1)
            {
               this._checkpoint.setType(Checkpoint.NOT_OPEN);
               this.setBGColor();
            }
         }
         else if(this._checkpoint.getType() == Checkpoint.NOT_OPEN)
         {
            _loc2_ = this.getNeedTools(this._checkpoint.getOpenTools());
            if(_loc2_ != null && _loc2_.length > 0)
            {
               this._checkpoint.setType(Checkpoint.NOT_ENOUGH_TOOL);
               this.setBGNoColor();
            }
         }
         this.showType();
      }
      
      private function getNeedTools(param1:Array) : Array
      {
         var _loc4_:Tool = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this.playerManager.getPlayer().getTool((param1[_loc3_] as Tool).getOrderId());
            if(_loc4_ == null)
            {
               _loc5_ = new Array();
               _loc5_.push((param1[_loc3_] as Tool).getName());
               _loc5_.push((param1[_loc3_] as Tool).getNum());
               _loc2_.push(_loc5_);
            }
            else if(_loc4_.getNum() < (param1[_loc3_] as Tool).getNum())
            {
               _loc6_ = new Array();
               _loc6_.push(_loc4_.getName());
               _loc6_.push((param1[_loc3_] as Tool).getNum() - _loc4_.getNum());
               _loc2_.push(_loc6_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function showType() : void
      {
         if(this._source.numChildren > 1)
         {
            this._source.removeChildAt(1);
         }
         if(this._checkpoint.getIsMap())
         {
            this.showMap();
            return;
         }
         switch(this._checkpoint.getType())
         {
            case Checkpoint.FINISHED:
               this.showFinished();
               break;
            case Checkpoint.NOT_ARRIVE:
               this.showNotArrive();
               break;
            case Checkpoint.NOT_ENOUGH_LV:
               this.showNotEnoughLv();
               break;
            case Checkpoint.NOT_ENOUGH_TOOL:
               this.showNotEnoughTool();
               break;
            case Checkpoint.NOT_OPEN:
               this.showNotOpen();
               break;
            case Checkpoint.UNFINISHED:
               this.showUnFinished();
               break;
            case Checkpoint.NOT_ENOUGH_PATH:
               this.showNotEnoughPath();
         }
      }
      
      private function showNotEnoughPath() : void
      {
         this.setBGNoColor();
      }
      
      private function setBGNoColor() : void
      {
         FuncKit.setNoColor(this._source);
      }
      
      private function setBGColor() : void
      {
         FuncKit.clearNoColorState(this._source);
      }
      
      private function showUnFinished() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.gantanhao");
         var _loc2_:MovieClip = new _loc1_();
         _loc2_.x = this._source.width - _loc2_.width - 5;
         _loc2_.y = this._source.height - _loc2_.height - 8;
         this._source.addChild(_loc2_);
         this.setBGColor();
      }
      
      private function showMap() : void
      {
      }
      
      private function setCheckpointId() : void
      {
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this._checkpoint.getShowId() + "");
         _loc1_.name = "checkpoint_id_" + this._checkpoint.getId();
         _loc1_.x = this._source.x;
         _loc1_.y = this._source.y;
         _loc1_.visible = false;
         this._source.parent.addChild(_loc1_);
      }
      
      private function setCheckpointCompStar() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:int = this._checkpoint.getPoint();
         var _loc2_:Sprite = new Sprite();
         if(_loc1_ == 1)
         {
            _loc2_.addChild(this.getRowStar(1));
            _loc2_.x = this._source.x + this._source.width - _loc2_.width + 20;
         }
         else if(_loc1_ == 2)
         {
            _loc2_.addChild(this.getRowStar(2));
            _loc2_.x = this._source.x + this._source.width - _loc2_.width + 40;
         }
         else if(_loc1_ == 3)
         {
            _loc2_.addChild(this.getRowStar(3));
            _loc2_.x = this._source.x + this._source.width - _loc2_.width + 60;
         }
         else if(_loc1_ == 4)
         {
            _loc2_.addChild(this.getRowStar(2));
            _loc2_.addChild(this.getRowStar(2));
            _loc2_.getChildAt(1).y = _loc2_.getChildAt(1).height;
            _loc2_.x = this._source.x + this._source.width - _loc2_.width + 40;
         }
         else if(_loc1_ == 5)
         {
            _loc2_.addChild(this.getRowStar(2));
            _loc2_.addChild(this.getRowStar(3));
            _loc2_.getChildAt(1).y = _loc2_.getChildAt(1).height;
            _loc2_.getChildAt(0).x = -(_loc2_.getChildAt(0) as DisplayObjectContainer).getChildAt(0).width / 2;
            _loc2_.x = this._source.x + this._source.width - _loc2_.width + 60;
         }
         else
         {
            _loc2_.addChild(this.getRowStar(1));
            _loc3_ = FuncKit.getNumEffect("x" + _loc1_);
            _loc3_.y = 2;
            _loc2_.addChild(_loc3_);
            _loc2_.x = this._source.x + this._source.width - _loc2_.width + 20;
         }
         _loc2_.y = this._source.y + this._source.height - _loc2_.height;
         _loc2_.visible = false;
         _loc2_.name = "checkpoint_star_id_" + this._checkpoint.getId();
         this._source.parent.addChild(_loc2_);
      }
      
      private function getRowStar(param1:int) : Sprite
      {
         var _loc5_:MovieClip = null;
         if(param1 > 3)
         {
            throw new Error("一排只能显示3颗星");
         }
         var _loc2_:Class = DomainAccess.getClass("ui.world.checkpointStar");
         var _loc3_:Sprite = new Sprite();
         var _loc4_:int = 1;
         while(_loc4_ <= param1)
         {
            _loc5_ = new _loc2_();
            _loc5_.x = -_loc5_.width * _loc4_;
            _loc3_.addChild(_loc5_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setCheckpointIdVisible(param1:Boolean) : void
      {
         if(this._checkpoint.getType() == Checkpoint.NOT_ARRIVE || this._checkpoint.getIsMap())
         {
            this._source.parent.getChildByName("checkpoint_id_" + this._checkpoint.getId()).visible = false;
         }
         else
         {
            this._source.parent.getChildByName("checkpoint_id_" + this._checkpoint.getId()).visible = param1;
         }
      }
      
      public function showCheckpointCompStarVisible(param1:Boolean) : void
      {
         if(this._checkpoint.getType() == Checkpoint.NOT_ARRIVE || this._checkpoint.getIsMap())
         {
            this._source.parent.getChildByName("checkpoint_star_id_" + this._checkpoint.getId()).visible = false;
         }
         else
         {
            this._source.parent.getChildByName("checkpoint_star_id_" + this._checkpoint.getId()).visible = param1;
         }
      }
      
      private function showNotOpen() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.wenhao");
         var _loc2_:MovieClip = new _loc1_();
         _loc2_.x = this._source.width - _loc2_.width - 5;
         _loc2_.y = this._source.height - _loc2_.height - 8;
         this._source.addChild(_loc2_);
         this.setBGColor();
      }
      
      private function showNotEnoughTool() : void
      {
         this.setBGNoColor();
      }
      
      private function showNotEnoughLv() : void
      {
         this.setBGNoColor();
      }
      
      public function showNotArrive() : void
      {
         this._source.visible = false;
      }
      
      private function showFinished() : void
      {
      }
      
      public function getCenter() : Point
      {
         return new Point(this._source.x + this._source.width / 2,this._source.y + this._source.height / 2);
      }
      
      public function destroy() : void
      {
         this._source.parent.removeChild(this._selectMc);
         this.removeEvent();
         this._checkpoint = null;
         this._source = null;
      }
   }
}

