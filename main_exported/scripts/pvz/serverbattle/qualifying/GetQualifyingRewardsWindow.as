package pvz.serverbattle.qualifying
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.invitePrizes.PrizeWindow;
   import pvz.serverbattle.fport.GetRewardsFPort;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import zlib.utils.DomainAccess;
   
   public class GetQualifyingRewardsWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _fport:GetRewardsFPort;
      
      private var _callback:Function;
      
      public function GetQualifyingRewardsWindow(param1:Function)
      {
         super();
         this._callback = param1;
         var _loc2_:Class = DomainAccess.getClass("qualifyingPrizeWindow");
         this._window = new _loc2_();
         showBG(PlantsVsZombies._node);
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
         this.addEvent();
         this.initData();
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window["close_btn"].removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffect(_window,destory);
         };
         this._window["close_btn"].addEventListener(MouseEvent.MOUSE_UP,onClose);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function initData() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._fport = new GetRewardsFPort(this);
         this._fport.requestSever(GetRewardsFPort.QUALIFYING_INIT);
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      public function initUI(param1:Object) : void
      {
         var rewardInfo:Array;
         var getHandler:Function = null;
         var re:Object = param1;
         getHandler = function(param1:MouseEvent):void
         {
            PlantsVsZombies.showDataLoading(true);
            _fport.requestSever(GetRewardsFPort.QUALIFYING_GET);
            _window["get_prize_btn"].removeEventListener(MouseEvent.MOUSE_UP,getHandler);
         };
         PlantsVsZombies.showDataLoading(false);
         this.show();
         if(re == null)
         {
            return;
         }
         if(re.myOldRank == 0 || re.myOldRank == null)
         {
            this._window["rank_txt"].text = LangManager.getInstance().getLanguage("severBattle019");
         }
         else
         {
            this._window["rank_txt"].text = re.myOldRank;
         }
         this._window["get_prize_btn"].gotoAndStop(int(re.award_status) + 1);
         if((this._window["get_prize_btn"] as MovieClip).currentFrame == 2)
         {
            this._window["get_prize_btn"].addEventListener(MouseEvent.MOUSE_UP,getHandler);
         }
         rewardInfo = new Array();
         rewardInfo = re.reward as Array;
         if(re.myReward == null)
         {
            return;
         }
         this._window["_rewardResult"].gotoAndStop(2);
         this.setToolsNumToDisPlayerObject(this._window["_rewardResult"]["_node"],re.myReward.tool.amount);
      }
      
      private function showRewardDescriptInfo(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.setRegionDisplayObject(this._window["rank" + _loc2_],param1[_loc2_].min_rank,param1[_loc2_].max_rank);
            this.setToolsNumToDisPlayerObject(this._window["reward" + _loc2_],param1[_loc2_].tool.amount);
            _loc2_++;
         }
      }
      
      private function setRegionDisplayObject(param1:DisplayObjectContainer, param2:int, param3:int) : void
      {
         var _loc4_:DisplayObject = StringMovieClip.getStringImage(param2 + "","Score");
         var _loc5_:DisplayObject = StringMovieClip.getStringImage("h","Score");
         var _loc6_:DisplayObject = StringMovieClip.getStringImage(param3 + "","Score");
         param1.addChild(_loc4_);
         _loc4_.scaleX = 0.9;
         _loc6_.scaleX = 0.9;
         _loc4_.scaleY = 0.9;
         _loc6_.scaleY = 0.9;
         param1.addChild(_loc5_);
         param1.addChild(_loc6_);
         _loc5_.x = _loc4_.width;
         _loc6_.x = _loc4_.width + _loc5_.width;
      }
      
      private function setToolsNumToDisPlayerObject(param1:DisplayObjectContainer, param2:int) : void
      {
         var _loc3_:DisplayObject = StringMovieClip.getStringImage(param2 + "","Score");
         param1.addChild(_loc3_);
      }
      
      public function showToolsPrizes(param1:Object) : void
      {
         var toolsWindow:PrizeWindow;
         var back:Function = null;
         var re:Object = param1;
         back = function():void
         {
            var _loc1_:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(re.tool_id);
            _loc1_.setNum(_loc1_.getNum() + re.amount);
            _callback(_loc1_.getNum());
            _window["get_prize_btn"].gotoAndStop(3);
            (_window["get_prize_btn"] as MovieClip).buttonMode = false;
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle013"));
            FuncKit.clearAllChildrens(_window["_rewardResult"]["_node"]);
            _window["_rewardResult"].gotoAndStop(1);
         };
         if(re.tool_id == null)
         {
            return;
         }
         PlantsVsZombies.showDataLoading(false);
         toolsWindow = new PrizeWindow(PlantsVsZombies._node as MovieClip);
         toolsWindow.show(this.getToolsByPrezes(re),back);
      }
      
      private function getToolsByPrezes(param1:Object) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Tool = new Tool(param1.tool_id);
         _loc3_.setNum(param1.amount);
         _loc2_.push(_loc3_);
         return _loc2_;
      }
      
      private function destory() : void
      {
         this._fport = null;
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

