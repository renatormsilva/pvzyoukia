package pvz.world.tips
{
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import manager.LangManager;
   import manager.PlayerManager;
   import pvz.world.Checkpoint;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class CheckpointTips extends Sprite
   {
      
      private var _bg:MovieClip = null;
      
      private var _checkpoint:Checkpoint = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function CheckpointTips()
      {
         super();
         this.init();
         this.visible = false;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.tips");
         this._bg = new _loc1_();
      }
      
      private function setTop() : void
      {
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      public function show(param1:Checkpoint, param2:Point) : void
      {
         this.clear();
         this.setTop();
         this._checkpoint = param1;
         this.addChild(this._bg);
         if(this._checkpoint.getIsMap())
         {
            this.showMapInfo();
         }
         else
         {
            switch(this._checkpoint.getType())
            {
               case Checkpoint.FINISHED:
                  this.showCheckpointInfo(true);
                  break;
               case Checkpoint.NOT_OPEN:
                  this.showNotOpen();
                  break;
               case Checkpoint.UNFINISHED:
                  this.showCheckpointInfo(false);
                  break;
               case Checkpoint.NOT_ENOUGH_LV:
                  this.showNotEnoughLv();
                  break;
               case Checkpoint.NOT_ENOUGH_TOOL:
                  this.showNotEnoughTool();
                  break;
               case Checkpoint.NOT_ENOUGH_PATH:
                  this.showNotEnoughPath();
            }
         }
         this.x = param2.x - this.width / 2;
         this.y = param2.y;
         this.visible = true;
      }
      
      private function showCheckpointInfo(param1:Boolean) : void
      {
         this._bg.height = 32;
         if(param1)
         {
            if(this._checkpoint.getBattleTimes() == -1)
            {
               this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world003"),new Point(1,0)));
            }
            else
            {
               this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world004",this._checkpoint.getBattleTimes()),new Point(1,0)));
            }
         }
         else
         {
            this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world023"),new Point(1,0)));
         }
         this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world005",this._checkpoint.getCost()),new Point(1,12)));
      }
      
      private function showNotEnoughPath() : void
      {
         this._bg.height = 20;
         this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world032"),new Point(1,0)));
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
      
      private function showNotEnoughTool() : void
      {
         var _loc1_:Array = this.getNeedTools(this._checkpoint.getOpenTools());
         var _loc2_:int = int(_loc1_.length);
         this._bg.height = 8 + _loc2_ * 12;
         this._bg.width = 115;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world008",_loc1_[_loc3_][0],_loc1_[_loc3_][1]),new Point(1,_loc3_ * 12)));
            _loc3_++;
         }
      }
      
      private function showNotEnoughLv() : void
      {
         this._bg.height = 20;
         this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world006",this._checkpoint.getOpenLv()),new Point(1,0)));
      }
      
      private function showNotOpen() : void
      {
         this._bg.height = 20;
         this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world007"),new Point(1,0)));
      }
      
      private function showMapInfo() : void
      {
         this._bg.height = 20;
         this.addChild(this.getTextFiled(LangManager.getInstance().getLanguage("world018"),new Point(1,0)));
      }
      
      private function getTextFiled(param1:String, param2:Point) : TextField
      {
         var _loc3_:TextField = new TextField();
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.size = 12;
         _loc4_.align = TextFormatAlign.CENTER;
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.width = this._bg.width;
         _loc3_.textColor = 16777215;
         _loc3_.x = param2.x;
         _loc3_.y = param2.y;
         _loc3_.selectable = false;
         _loc3_.text = param1;
         TextFilter.MiaoBian(_loc3_,0);
         return _loc3_;
      }
      
      public function clear() : void
      {
         this.visible = false;
         FuncKit.clearAllChildrens(this);
      }
   }
}

