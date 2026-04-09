package pvz.world
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class InsideWorldRewardBoxLabel extends Sprite
   {
      
      private var _reward:InsideWorldReward = null;
      
      private var _value:int = 0;
      
      private var _allvalue:int = 0;
      
      private var _box:MovieClip = null;
      
      private var _type:int = 0;
      
      private var _index:int = 0;
      
      public function InsideWorldRewardBoxLabel(param1:InsideWorldReward, param2:int, param3:int, param4:int)
      {
         super();
         this._reward = param1;
         this._value = param2;
         this._allvalue = param3;
         this._index = param4;
         this._type = this._reward.getRewardType(this._value,this._allvalue);
      }
      
      public function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.rewardBox" + this._index);
         this._box = new _loc1_();
         this._box.gotoAndStop(1);
         this.changeBox(this._type);
         this._box.x = -18;
         this.addChild(this._box);
         this.setNum();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._box.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._type == 1)
         {
            return;
         }
         this.setBoxSelected(true);
         dispatchEvent(new InsideWorldRewardEvent(InsideWorldRewardEvent.SHOW_REWARDS,this._index));
      }
      
      private function setNum() : void
      {
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this._reward.getValue().toString());
         _loc1_.x = -_loc1_.width / 2;
         this._box["num"].addChild(_loc1_);
      }
      
      public function setBoxSelected(param1:Boolean) : void
      {
         if(this._type == 1)
         {
            this._box.gotoAndStop(3);
            this._box["_effect"].visible = false;
            this.buttonMode = false;
            return;
         }
         if(param1)
         {
            this._box.gotoAndStop(2);
            this._box["_effect"].visible = true;
            this._box["_effect"].gotoAndPlay(1);
            this.buttonMode = true;
         }
         else
         {
            this._box.gotoAndStop(1);
            this._box["_effect"].visible = false;
            this.buttonMode = true;
         }
      }
      
      private function changeBox(param1:int) : void
      {
         this._type = param1;
         if(param1 == 1)
         {
            this._box["jian"].visible = false;
            this._box.gotoAndStop(3);
            this._box["_effect"].visible = false;
            this.buttonMode = false;
         }
         else if(param1 == 2)
         {
            this._box["jian"].visible = false;
            this._box["_effect"].visible = false;
            this._box.gotoAndStop(1);
            this.buttonMode = true;
         }
         else if(param1 == 3)
         {
            dispatchEvent(new InsideWorldRewardEvent(InsideWorldRewardEvent.SHOW_REWARDS,this._index));
            this._box["jian"].visible = true;
            this._box.gotoAndStop(2);
            this._box["_effect"].gotoAndPlay(1);
            this._box["_effect"].visible = true;
            this.buttonMode = true;
         }
      }
   }
}

