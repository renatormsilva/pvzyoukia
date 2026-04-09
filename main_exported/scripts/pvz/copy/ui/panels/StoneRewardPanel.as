package pvz.copy.ui.panels
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.copy.events.StoneRewardEvent;
   import pvz.copy.models.stone.StoneRewardCData;
   import pvz.copy.models.stone.StoneRewardData;
   import pvz.copy.ui.sprites.StoneRewardBoxLabel;
   import pvz.copy.ui.sprites.StoneRewardsLabel;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class StoneRewardPanel extends EventDispatcher implements IDestroy
   {
      
      private var _type:String = "";
      
      private var _panel:DisplayObjectContainer = null;
      
      private var m_value:int = 0;
      
      private var m_allvalue:int = 0;
      
      private var m_max:int = 0;
      
      private var m_rewards:Array = null;
      
      private var m_hasReward:Boolean;
      
      private var m_getedAll:int;
      
      private var m_gateNextStar:int;
      
      public function StoneRewardPanel(param1:DisplayObjectContainer)
      {
         super();
         this._panel = param1;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._panel["_bt_recharge"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_get_prizes"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._panel["_bt_recharge"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_get_prizes"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_recharge")
         {
            PlantsVsZombies.toRecharge();
         }
         else if(param1.currentTarget.name == "_get_prizes")
         {
            dispatchEvent(new StoneRewardEvent(StoneRewardEvent.GET_REWARDS,this.getRewardsIndex()));
         }
      }
      
      private function getRewardsIndex() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_rewards.length)
         {
            if((this.m_rewards[_loc1_] as StoneRewardData).getNeedStar() == this.m_value)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function show(param1:StoneRewardCData) : void
      {
         this.m_rewards = param1.getRewards();
         this.m_max = param1.getAllStar();
         this.m_allvalue = param1.getCurrentStar();
         this.m_value = param1.getCanGetStar();
         this.m_hasReward = param1.getHasReward();
         this.m_getedAll = param1.getAllRewarded();
         this.m_gateNextStar = param1.getNextRewardStar();
         this.clear();
         this._panel["_not_get_prizes"].visible = true;
         this._panel["_get_prizes"].visible = false;
         this._panel["_rewards_type"].gotoAndStop(1);
         this.showProgress();
         this.showRewardsBox();
         this.showAllValue();
         this.showTextInfo();
         this.setIsGetPrizes();
      }
      
      private function showTextInfo() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:DisplayObject = null;
         FuncKit.clearAllChildrens(this._panel["wenzi"]["num"]);
         if(this.m_getedAll == 1)
         {
            this._panel["wenzi"].gotoAndStop(3);
            return;
         }
         if(this.m_allvalue >= this.m_value && this.m_value == 0)
         {
            this._panel["wenzi"].gotoAndStop(2);
            _loc1_ = FuncKit.getNumEffect(String(this.m_gateNextStar - this.m_allvalue),"Exp",-2);
            _loc1_.x = -_loc1_.width / 2;
            this._panel["wenzi"]["num"].x = 62;
            this._panel["wenzi"]["num"].addChild(_loc1_);
         }
         else
         {
            this._panel["wenzi"].gotoAndStop(1);
            _loc2_ = FuncKit.getNumEffect(String(this.m_value),"Exp",-2);
            _loc2_.x = -_loc2_.width / 2;
            this._panel["wenzi"]["num"].x = 113;
            this._panel["wenzi"]["num"].addChild(_loc2_);
         }
      }
      
      public function showProgress() : void
      {
         var _loc1_:Number = this.m_allvalue / this.m_max;
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         this._panel["_mc_progress"]["_mc_color"].scaleX = _loc1_;
      }
      
      private function showAllValue() : void
      {
         if(this._panel["_allvalue"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._panel["_allvalue"]);
         }
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.m_allvalue.toString(),"Rewards");
         _loc1_.x = -_loc1_.width / 2;
         this._panel["_allvalue"].addChild(_loc1_);
      }
      
      public function showRewardsBox() : void
      {
         var _loc3_:StoneRewardBoxLabel = null;
         this.clearBoxes();
         var _loc1_:int = int(this.m_rewards.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new StoneRewardBoxLabel(this.m_rewards[_loc2_],this.m_value,this.m_allvalue,_loc2_ + 1);
            _loc3_.addEventListener(StoneRewardEvent.SHOW_REWARDS,this.onShowPrizes);
            _loc3_.init();
            _loc3_.x = this.getRewardsBoxLoction(this.m_rewards[_loc2_]);
            this._panel["_boxes"].addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function onShowPrizes(param1:StoneRewardEvent) : void
      {
         this.showTools(this.m_rewards[param1.index - 1]);
         this.changeBoxesSelected(param1.index - 1);
      }
      
      private function setIsGetPrizes() : void
      {
         if(this.m_hasReward)
         {
            this._panel["_not_get_prizes"].visible = false;
            this._panel["_get_prizes"].visible = true;
         }
         else
         {
            this._panel["_not_get_prizes"].visible = true;
            this._panel["_get_prizes"].visible = false;
         }
      }
      
      private function changeBoxesSelected(param1:int) : void
      {
         var _loc3_:StoneRewardBoxLabel = null;
         if(this._panel["_boxes"].numChildren < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._panel["_boxes"].numChildren)
         {
            _loc3_ = this._panel["_boxes"].getChildAt(_loc2_);
            if(_loc2_ != param1)
            {
               _loc3_.setBoxSelected(false);
            }
            _loc2_++;
         }
      }
      
      private function clearBoxes() : void
      {
         if(this._panel["_boxes"] != null)
         {
            FuncKit.clearAllChildrens(this._panel["_boxes"]);
         }
      }
      
      private function getRewardBox(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("copy.stone.reward" + param1);
         return new _loc2_();
      }
      
      private function getRewardsBoxLoction(param1:StoneRewardData) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.getNeedStar();
         return int(510 * _loc3_ / this.m_max);
      }
      
      private function showTools(param1:StoneRewardData) : void
      {
         var _loc4_:StoneRewardsLabel = null;
         this.clearTools();
         var _loc2_:Array = param1.getAwardTools();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new StoneRewardsLabel(_loc2_[_loc3_] as Tool);
            _loc4_.x = _loc3_ * 124;
            this._panel["_pic_tool"].addChild(_loc4_);
            _loc3_++;
         }
      }
      
      public function destroy() : void
      {
         this.clear();
         this.removeEvent();
         this.m_allvalue = 0;
         this._panel = null;
         this.m_rewards = null;
         this._type = "";
         this.m_value = 0;
      }
      
      private function clear() : void
      {
         this.clearTools();
         this.clearBoxes();
      }
      
      private function clearTools() : void
      {
         if(this._panel["_pic_tool"] != null)
         {
            FuncKit.clearAllChildrens(this._panel["_pic_tool"]);
         }
      }
   }
}

