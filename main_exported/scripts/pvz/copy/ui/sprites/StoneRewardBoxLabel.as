package pvz.copy.ui.sprites
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.copy.events.StoneRewardEvent;
   import pvz.copy.models.stone.StoneRewardData;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class StoneRewardBoxLabel extends Sprite
   {
      
      private var _reward:StoneRewardData = null;
      
      private var _value:int = 0;
      
      private var _allvalue:int = 0;
      
      private var _box:MovieClip = null;
      
      private var _index:int = 0;
      
      private var m_hasGeted:int;
      
      public function StoneRewardBoxLabel(param1:StoneRewardData, param2:int, param3:int, param4:int)
      {
         super();
         this._reward = param1;
         this._value = param2;
         this._allvalue = param3;
         this._index = param4;
         this.m_hasGeted = param1.getRewardType();
      }
      
      public function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("copy.stone.reward" + this._index);
         this._box = new _loc1_();
         this._box.gotoAndStop(1);
         this._box.x = -18;
         this.initEvent();
         this.setNum();
         this.changeBox();
         this.addChild(this._box);
      }
      
      private function initEvent() : void
      {
         this._box.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.m_hasGeted == 1)
         {
            return;
         }
         this.setBoxSelected(true);
         dispatchEvent(new StoneRewardEvent(StoneRewardEvent.SHOW_REWARDS,this._index));
      }
      
      private function setNum() : void
      {
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this._reward.getNeedStar().toString());
         _loc1_.x = -_loc1_.width / 2;
         this._box["num"].addChild(_loc1_);
      }
      
      public function setBoxSelected(param1:Boolean) : void
      {
         if(this.m_hasGeted == 1)
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
      
      private function changeBox() : void
      {
         if(this.m_hasGeted == 1)
         {
            this._box["jian"].visible = false;
            this._box.gotoAndStop(3);
            this._box["_effect"].visible = false;
            this.buttonMode = false;
         }
         else if(this.m_hasGeted == 2)
         {
            this._box["jian"].visible = true;
            this._box.gotoAndStop(1);
            this._box["_effect"].gotoAndPlay(1);
            this._box["_effect"].visible = true;
            this.buttonMode = true;
         }
         else if(this.m_hasGeted == 3)
         {
            this._box["jian"].visible = false;
            this._box.gotoAndStop(1);
            this._box["_effect"].gotoAndPlay(1);
            this._box["_effect"].visible = false;
            this.buttonMode = true;
         }
      }
   }
}

