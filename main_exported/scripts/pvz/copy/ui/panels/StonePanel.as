package pvz.copy.ui.panels
{
   import core.interfaces.IVo;
   import core.managers.GameManager;
   import core.ui.panel.BaseScene;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.copy.models.stone.StoneGateData;
   import pvz.copy.models.stone.StoneGatesCData;
   import pvz.copy.ui.sprites.StoneGateIcon;
   import pvz.copy.ui.tips.StoneGateTips;
   import pvz.copy.ui.tips.StoneHelpTips;
   import pvz.copy.ui.windows.AddStoneBattleNum;
   import pvz.copy.ui.windows.AddTimesByUseingTool;
   import pvz.invitePrizes.PrizeWindow;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class StonePanel extends BaseScene
   {
      
      public var onCaveClickCall:Function;
      
      public var onRewardsClickCall:Function;
      
      public var onRankingClickCall:Function;
      
      public var onBuyBattleNumCall:Function;
      
      public var onExchangeBattleNumCall:Function;
      
      public var onGetPrizeCall:Function;
      
      private var iconLayer:Sprite;
      
      private var backBtn:SimpleButton;
      
      private var m_tips:StoneGateTips;
      
      private var rewardbtn:SimpleButton;
      
      private var rankbtn:SimpleButton;
      
      private var m_preChapter:int;
      
      private var m_accStar:Sprite;
      
      private var m_battle:Sprite;
      
      private var m_dic:Dictionary = new Dictionary(true);
      
      public var max_buy_num:int = 20;
      
      private var helpBtn:SimpleButton;
      
      private var _tips:StoneHelpTips;
      
      private var stoneicon:StoneGateIcon;
      
      public function StonePanel()
      {
         super();
         this.initUI();
         this.addMouseEvents();
      }
      
      private function initUI() : void
      {
         this.backBtn = GetDomainRes.getSimpleButton("pvz.button.back3");
         this.backBtn.x = GameManager.m_gameWidth - this.backBtn.width;
         this.iconLayer = new Sprite();
         this.iconLayer.x = 80;
         this.iconLayer.y = 130;
         this.rewardbtn = GetDomainRes.getSimpleButton("copy.stone.prizesbtn");
         this.rewardbtn.x = 300;
         this.rewardbtn.y = 420;
         this.rankbtn = GetDomainRes.getSimpleButton("copy.stone.rankbtn");
         this.rankbtn.x = 400;
         this.rankbtn.y = 425;
         this.m_accStar = GetDomainRes.getSprite("stone.ui.accstar");
         this.m_accStar.x = 428;
         this.m_accStar.y = 70;
         this.m_battle = GetDomainRes.getSprite("pvz.addBattle.panel2");
         this.m_battle.x = 100;
         this.m_battle.y = 70;
         this.helpBtn = GetDomainRes.getSimpleButton("stone.helpbtn");
         this.helpBtn.x = 640;
         this.helpBtn.y = 4;
         this.addChild(this.m_accStar);
         this.addChild(this.m_battle);
         this.addChild(this.rankbtn);
         this.addChild(this.rewardbtn);
         this.addChild(this.helpBtn);
         this.addChild(this.backBtn);
         this.addChild(this.iconLayer);
      }
      
      public function changeUI(param1:int) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         if(this.m_preChapter == param1)
         {
            return;
         }
         if(this.getChildByName("bg") != null)
         {
            _loc5_ = this.getChildByName("bg");
            this.removeChild(_loc5_);
         }
         if(this.getChildByName("title") != null)
         {
            _loc6_ = this.getChildByName("title");
            this.removeChild(_loc6_);
         }
         var _loc2_:int = param1;
         if(param1 != 1 && param1 != 2)
         {
            _loc2_ = 2;
         }
         var _loc3_:DisplayObject = GetDomainRes.getDisplayObject("stone.panel.panel_" + _loc2_);
         _loc3_.name = "bg";
         this.addChildAt(_loc3_,0);
         var _loc4_:DisplayObject = GetDomainRes.getDisplayObject("copy.stone.chapter_name_b_" + param1);
         _loc4_.name = "title";
         _loc4_.x = (width - _loc4_.width) / 2 - 5;
         _loc4_.y = 11;
         this.addChildAt(_loc4_,1);
         this.m_preChapter = param1;
      }
      
      public function updata(param1:IVo) : void
      {
         var _loc8_:StoneGateData = null;
         var _loc9_:StoneGateIcon = null;
         var _loc2_:StoneGatesCData = param1 as StoneGatesCData;
         var _loc3_:Vector.<StoneGateData> = _loc2_.getChaptersIconData();
         var _loc4_:int = int(_loc3_.length);
         FuncKit.clearAllChildrens(this.iconLayer);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc8_ = _loc3_[_loc5_];
            if(this.m_dic[_loc5_] == null)
            {
               _loc9_ = new StoneGateIcon(this.onGateClickHandler,this.GetPrizes);
               this.m_dic[_loc5_] = _loc9_;
            }
            else
            {
               _loc9_ = this.m_dic[_loc5_] as StoneGateIcon;
            }
            _loc9_.upData(_loc8_);
            _loc9_.x = int(_loc5_ % 6) * 100;
            _loc9_.y = int(_loc5_ / 6) * 150;
            this.iconLayer.addChild(_loc9_);
            _loc5_++;
         }
         FuncKit.clearAllChildrens(this.m_accStar["num"]);
         var _loc6_:String = _loc2_.getCurrentStar() + "c" + _loc2_.getAllStar();
         var _loc7_:DisplayObject = FuncKit.getNumEffect(_loc6_,"Exp",-2);
         _loc7_.x = -_loc7_.width / 2;
         this.m_accStar["num"].addChild(_loc7_);
         this.updataBattleNum(_loc2_.getChallegeCount());
         if(!this.parent)
         {
            this.onShow();
         }
      }
      
      private function GetPrizes(param1:StoneGateIcon) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.stoneicon = param1;
         this.onGetPrizeCall(param1.getIconData().getId());
      }
      
      public function updataBattleNum(param1:int) : void
      {
         FuncKit.clearAllChildrens(this.m_battle["num"]);
         var _loc2_:DisplayObject = FuncKit.getNumEffect(String(param1),"Exp",-2);
         _loc2_.x = -_loc2_.width / 2;
         this.m_battle["num"].addChild(_loc2_);
      }
      
      protected function onGateOverHandler(param1:MouseEvent) : void
      {
         if(!(param1.target is StoneGateIcon))
         {
            return;
         }
         param1.target.setFilters(true);
         var _loc2_:StoneGateData = (param1.target as StoneGateIcon).getIconData();
         if(this.m_tips == null)
         {
            this.m_tips = new StoneGateTips();
         }
         this.m_tips.show(_loc2_);
         this.m_tips.visible = true;
         this.m_tips.showTips(param1);
      }
      
      protected function onGateOutHandler(param1:MouseEvent) : void
      {
         if(!(param1.target is StoneGateIcon))
         {
            return;
         }
         param1.target.setFilters(false);
         this.m_tips.hideTips();
      }
      
      protected function onGateClickHandler(param1:StoneGateData) : void
      {
         if(PlantsVsZombies.playerManager.getPlayer().getStoneChaCount() <= 0)
         {
            this.onExchangeHandler();
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.onCaveClickCall(param1);
      }
      
      protected function onRewardsClickHandler(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.onRewardsClickCall();
      }
      
      protected function onRankClickHandler(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.onRankingClickCall();
      }
      
      public function onExchangeHandler(param1:MouseEvent = null) : void
      {
         var toolnum:int;
         var tool:Tool = null;
         var addTimes:Function = null;
         var e:MouseEvent = param1;
         addTimes = function(param1:int):void
         {
            PlantsVsZombies.playerManager.getPlayer().updateTool(tool.getOrderId(),tool.getNum() - param1);
            onExchangeBattleNumCall(tool.getOrderId(),param1);
         };
         if(e)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
         else if(PlantsVsZombies.playerManager.getPlayer().getStoneChaCount() > 0)
         {
            return;
         }
         tool = PlantsVsZombies.playerManager.getPlayer().getTool(1001);
         toolnum = 0;
         if(!tool)
         {
            tool = new Tool(1001);
         }
         toolnum = tool.getNum();
         if(toolnum <= 0)
         {
            this.onClickBuyHandler();
         }
         else
         {
            new AddTimesByUseingTool(addTimes,toolnum,tool);
         }
      }
      
      private function onHelpOver(param1:MouseEvent) : void
      {
         if(this._tips == null)
         {
            this._tips = new StoneHelpTips();
         }
         this._tips.visible = true;
         this.addChild(this._tips);
         this._tips.setLocation(310,10);
      }
      
      private function onHelpOut(param1:MouseEvent) : void
      {
         this._tips.visible = false;
         this.removeChild(this._tips);
      }
      
      protected function onClickBuyHandler(param1:MouseEvent = null) : void
      {
         if(param1 != null)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
         if(this.max_buy_num == 0)
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("copy009"));
            return;
         }
         new AddStoneBattleNum(this.onBuyBattleNumCall,this.max_buy_num);
      }
      
      private function addMouseEvents() : void
      {
         this.iconLayer.addEventListener(MouseEvent.MOUSE_OVER,this.onGateOverHandler);
         this.iconLayer.addEventListener(MouseEvent.MOUSE_OUT,this.onGateOutHandler);
         this.helpBtn.addEventListener(MouseEvent.ROLL_OVER,this.onHelpOver);
         this.helpBtn.addEventListener(MouseEvent.ROLL_OUT,this.onHelpOut);
         this.backBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.rewardbtn.addEventListener(MouseEvent.CLICK,this.onRewardsClickHandler);
         this.rankbtn.addEventListener(MouseEvent.CLICK,this.onRankClickHandler);
         this.m_battle["buy"].addEventListener(MouseEvent.CLICK,this.onClickBuyHandler);
         this.m_battle["addTimebtn"].addEventListener(MouseEvent.CLICK,this.onExchangeHandler);
      }
      
      private function removeMouseEvents() : void
      {
         this.iconLayer.removeEventListener(MouseEvent.MOUSE_OVER,this.onGateOverHandler);
         this.iconLayer.removeEventListener(MouseEvent.MOUSE_OUT,this.onGateOverHandler);
         this.helpBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onHelpOver);
         this.helpBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onHelpOut);
         this.backBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.rewardbtn.removeEventListener(MouseEvent.CLICK,this.onRewardsClickHandler);
         this.rankbtn.removeEventListener(MouseEvent.CLICK,this.onRankClickHandler);
         this.m_battle["buy"].removeEventListener(MouseEvent.CLICK,this.onClickBuyHandler);
         this.m_battle["addTimebtn"].removeEventListener(MouseEvent.CLICK,this.onExchangeHandler);
      }
      
      public function portGetPrizes(param1:Array) : void
      {
         var _loc3_:Tool = null;
         var _loc4_:Tool = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = PlantsVsZombies.playerManager.getPlayer().getTool(_loc3_.getOrderId());
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getNum();
            }
            else
            {
               _loc5_ = 0;
            }
            PlantsVsZombies.playerManager.getPlayer().updateTool(_loc3_.getOrderId(),_loc5_ + _loc3_.getNum());
            _loc2_++;
         }
         this.showTools(param1);
      }
      
      private function showTools(param1:Array) : void
      {
         var call:Function = null;
         var tools:Array = param1;
         call = function():void
         {
            if(stoneicon != null)
            {
               stoneicon.setPrizesVisible();
               stoneicon.getIconData().clearThroughPrizes();
            }
         };
         var toolsWindow:PrizeWindow = new PrizeWindow(this);
         toolsWindow.show(tools,call);
      }
      
      override public function destroy() : void
      {
         this.removeMouseEvents();
         FuncKit.clearNode(this.iconLayer);
         this.backBtn = null;
         this.rankbtn = null;
         this.rewardbtn = null;
         this.onCaveClickCall = null;
         this.onRewardsClickCall = null;
         this.onRankingClickCall = null;
         this.onBuyBattleNumCall = null;
         this.onGetPrizeCall = null;
         this.m_accStar = null;
         this.m_battle = null;
         this.stoneicon = null;
         if(this.m_tips != null)
         {
            this.m_tips.clear();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.m_dic.length)
         {
            (this.m_dic[_loc1_] as StoneGateIcon).clear();
            delete this.m_dic[_loc1_];
            _loc1_++;
         }
         this.m_dic = null;
      }
      
      private function closeHandler(param1:MouseEvent = null) : void
      {
         if(param1 != null)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
         this.onHide();
      }
   }
}

