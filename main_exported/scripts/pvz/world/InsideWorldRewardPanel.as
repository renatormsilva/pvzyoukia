package pvz.world
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldRewardPanel extends EventDispatcher implements IDestroy
   {
      
      private var _type:String = "";
      
      private var _panel:DisplayObjectContainer = null;
      
      private var _value:int = 0;
      
      private var _allvalue:int = 0;
      
      private var _max:int = 0;
      
      private var _rewards:Array = null;
      
      public function InsideWorldRewardPanel(param1:DisplayObjectContainer)
      {
         super();
         this._panel = param1;
         this.init();
      }
      
      private function init() : void
      {
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
         if(param1.currentTarget.name == "_bt_recharge")
         {
            PlantsVsZombies.toRecharge();
         }
         else if(param1.currentTarget.name == "_get_prizes")
         {
            dispatchEvent(new InsideWorldRewardEvent(InsideWorldRewardEvent.GET_REWARDS,this.getRewardsIndex()));
         }
      }
      
      private function getRewardsIndex() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._rewards.length)
         {
            if((this._rewards[_loc1_] as InsideWorldReward).getValue() == this._value)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function show(param1:String, param2:Array, param3:int, param4:int, param5:int) : void
      {
         this._allvalue = param4;
         this._value = param3;
         this._rewards = param2;
         this._max = param5;
         this.clear();
         this._panel["_not_get_prizes"].visible = true;
         this._panel["_get_prizes"].visible = false;
         if(param1 == InsideWorldReward.COMPLETE)
         {
            this._panel["_rewards_type"].gotoAndStop(1);
         }
         else if(param1 == InsideWorldReward.MEDAL)
         {
            this._panel["_rewards_type"].gotoAndStop(2);
         }
         this.showProgress(param4);
         this.showRewardsBox(param2);
         this.showAllValue();
         this.showTextInfo(param1);
      }
      
      private function showTextInfo(param1:String) : void
      {
         if(this._value == 0)
         {
            this._panel["_txt_info"].text = LangManager.getInstance().getLanguage("world028");
            return;
         }
         if(param1 == InsideWorldReward.COMPLETE)
         {
            if(this._allvalue >= this._value)
            {
               this._panel["_txt_info"].htmlText = "<font><b>" + LangManager.getInstance().getLanguage("world025") + "<b/><font><font color=\"#FF0000\"><b>" + this._value + "</b></font><font><b>" + LangManager.getInstance().getLanguage("world027") + "<b/><font>";
            }
            else
            {
               this._panel["_txt_info"].htmlText = "<font><b>" + LangManager.getInstance().getLanguage("world029") + "<b/><font><font color=\"#FF0000\">" + (this._value - this._allvalue) + "</b></font><font><b>" + LangManager.getInstance().getLanguage("world031") + "<b/><font>";
            }
         }
         else if(param1 == InsideWorldReward.MEDAL)
         {
            if(this._allvalue >= this._value)
            {
               this._panel["_txt_info"].htmlText = "<font><b>" + LangManager.getInstance().getLanguage("world025") + "<b/><font><font color=\"#FF0000\"><b>" + this._value + "</b></font><font><b>" + LangManager.getInstance().getLanguage("world026") + "<b/><font>";
            }
            else
            {
               this._panel["_txt_info"].htmlText = "<font><b>" + LangManager.getInstance().getLanguage("world029") + "<b/><font><font color=\"#FF0000\">" + (this._value - this._allvalue) + "</b></font><font><b>" + LangManager.getInstance().getLanguage("world030") + "<b/><font>";
            }
         }
      }
      
      public function showProgress(param1:int) : void
      {
         var _loc2_:Number = param1 / this._max;
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         this._panel["_mc_progress"]["_mc_color"].scaleX = _loc2_;
      }
      
      private function showAllValue() : void
      {
         if(this._panel["_allvalue"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._panel["_allvalue"]);
         }
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this._allvalue.toString(),"Rewards");
         _loc1_.x = -_loc1_.width / 2;
         this._panel["_allvalue"].addChild(_loc1_);
      }
      
      public function showRewardsBox(param1:Array) : void
      {
         var _loc3_:InsideWorldRewardBoxLabel = null;
         this.clearBoxes();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new InsideWorldRewardBoxLabel(param1[_loc2_],this._value,this._allvalue,_loc2_ + 1);
            _loc3_.addEventListener(InsideWorldRewardEvent.SHOW_REWARDS,this.onShowPrizes);
            _loc3_.init();
            _loc3_.x = this.getRewardsBoxLoction(param1[_loc2_]);
            this._panel["_boxes"].addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function onShowPrizes(param1:InsideWorldRewardEvent) : void
      {
         this.showTools(this._rewards[param1.index - 1]);
         this.changeBoxesSelected(param1.index - 1);
         this.setIsGetPrizes(this._rewards[param1.index - 1]);
      }
      
      private function setIsGetPrizes(param1:InsideWorldReward) : void
      {
         var _loc2_:int = param1.getRewardType(this._value,this._allvalue);
         if(_loc2_ == 3)
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
         var _loc3_:InsideWorldRewardBoxLabel = null;
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
         var _loc2_:Class = DomainAccess.getClass("ui.world.rewardBox" + param1);
         return new _loc2_();
      }
      
      private function getRewardsBoxLoction(param1:InsideWorldReward) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.getValue();
         return int(510 * _loc3_ / this._max);
      }
      
      private function showTools(param1:InsideWorldReward) : void
      {
         var _loc4_:InsideWorldRewardsLabel = null;
         this.clearTools();
         var _loc2_:Array = param1.getAwardTools();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new InsideWorldRewardsLabel(_loc2_[_loc3_] as Tool);
            _loc4_.x = _loc3_ * 124;
            this._panel["_pic_tool"].addChild(_loc4_);
            _loc3_++;
         }
      }
      
      public function destroy() : void
      {
         this.clear();
         this.removeEvent();
         this._allvalue = 0;
         this._panel = null;
         this._rewards = null;
         this._type = "";
         this._value = 0;
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

