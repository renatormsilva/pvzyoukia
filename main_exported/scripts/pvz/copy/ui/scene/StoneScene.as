package pvz.copy.ui.scene
{
   import core.interfaces.IVo;
   import core.managers.GameManager;
   import core.ui.panel.BaseScene;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.copy.models.stone.StoneSceneData;
   import pvz.copy.models.stone.StoneSceneIconData;
   import pvz.copy.ui.sprites.StoneSceneIcon;
   import pvz.copy.ui.tips.StoneHelpTips;
   import pvz.copy.ui.tips.StoneSceneTips;
   import pvz.copy.ui.windows.AddStoneBattleNum;
   import pvz.copy.ui.windows.AddTimesByUseingTool;
   import pvz.copy.ui.windows.StoneScaleButton;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class StoneScene extends BaseScene
   {
      
      public var onIconClickCall:Function;
      
      public var onAllCloseCall:Function;
      
      public var onBuyBattleNumCall:Function;
      
      private var dragLayer:Sprite;
      
      private var iconIDS:Array = [1,2,3,4,5,6,7,8,9];
      
      private var m_icons:Dictionary;
      
      private var m_tips:StoneSceneTips;
      
      private var backBtn:SimpleButton;
      
      private var m_battle:Sprite;
      
      public var onExchangeBattleNumCall:Function;
      
      private var background:Sprite;
      
      private var m_scalePanel:StoneScaleButton;
      
      public var max_buy_num:int = 20;
      
      private var helpBtn:SimpleButton;
      
      private var _tips:StoneHelpTips;
      
      public function StoneScene()
      {
         super();
         this.m_icons = new Dictionary(true);
         this.initUI();
         this.addMouseEvents();
      }
      
      private function initUI() : void
      {
         var _loc4_:int = 0;
         var _loc5_:StoneSceneIcon = null;
         this.dragLayer = new Sprite();
         this.background = GetDomainRes.getSprite("ui.stone.bg");
         var _loc1_:DisplayObject = GetDomainRes.getDisplayObject("stone.panel.title");
         _loc1_.x = (GameManager.m_gameWidth - _loc1_.width) / 2;
         _loc1_.y = -5;
         this.backBtn = GetDomainRes.getSimpleButton("pvz.ui.fanhui");
         this.backBtn.x = 710;
         var _loc2_:int = int(this.iconIDS.length);
         this.dragLayer.addChild(this.background);
         this.m_scalePanel = new StoneScaleButton(this.dragLayer,3,this.localizerBG);
         this.m_scalePanel.x = 10;
         this.m_scalePanel.y = 50;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(this.iconIDS[_loc3_]);
            _loc5_ = new StoneSceneIcon(this.background["chapterbtn_" + (_loc3_ + 1)],_loc3_ + 1);
            _loc5_.localizerCall = this.localizerBG;
            this.m_icons["chapterbtn_" + (_loc3_ + 1)] = _loc5_;
            _loc3_++;
         }
         this.m_battle = GetDomainRes.getSprite("pvz.addBattle.panel2");
         this.m_battle.x = 10;
         this.m_battle.y = 20;
         this.helpBtn = GetDomainRes.getSimpleButton("stone.helpbtn");
         this.helpBtn.x = 665;
         this.helpBtn.y = 4;
         this.addChild(this.dragLayer);
         this.addChild(_loc1_);
         this.addChild(this.helpBtn);
         this.addChild(this.backBtn);
         this.addChild(this.m_battle);
         this.addChild(this.m_scalePanel);
      }
      
      public function updataBattleNum(param1:int) : void
      {
         FuncKit.clearAllChildrens(this.m_battle["num"]);
         var _loc2_:DisplayObject = FuncKit.getNumEffect(String(param1),"Exp",-2);
         _loc2_.x = -_loc2_.width / 2;
         this.m_battle["num"].addChild(_loc2_);
      }
      
      public function updata(param1:IVo) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:DisplayObject = null;
         var _loc2_:StoneSceneData = param1 as StoneSceneData;
         var _loc3_:Vector.<StoneSceneIconData> = _loc2_.getSIconData();
         this.max_buy_num = _loc2_.getBuyMaxChallegeCount();
         var _loc4_:int = int(this.m_icons.length);
         var _loc5_:int = 0;
         while(_loc5_ < 9)
         {
            this.m_icons["chapterbtn_" + (_loc5_ + 1)].upData(_loc3_[_loc5_]);
            FuncKit.clearAllChildrens(this.background["star_" + (_loc5_ + 1)]["num"]);
            _loc6_ = (_loc3_[_loc5_] as StoneSceneIconData).getStarNow();
            _loc7_ = (_loc3_[_loc5_] as StoneSceneIconData).getStarMax();
            _loc8_ = _loc6_ + "c" + _loc7_;
            _loc9_ = FuncKit.getNumEffect(_loc8_,"Exp",-2);
            _loc9_.x = -_loc9_.width / 2;
            this.background["star_" + (_loc5_ + 1)]["num"].addChild(_loc9_);
            _loc5_++;
         }
         this.updataBattleNum(_loc2_.getChallegeCount());
         if(!this.parent)
         {
            this.onShow();
         }
      }
      
      private function localizerBG(param1:Number = 1, param2:Number = 1) : void
      {
         this.dragLayer.x = PlantsVsZombies.WIDTH / 2 - param1 * this.dragLayer.scaleX;
         this.dragLayer.y = PlantsVsZombies.HEIGHT / 2 - param2 * this.dragLayer.scaleY;
         if(this.dragLayer.y > 0)
         {
            this.dragLayer.y = 0;
         }
         if(this.dragLayer.x > 0)
         {
            this.dragLayer.x = 0;
         }
         if(this.dragLayer.x < PlantsVsZombies.WIDTH - this.getBGWidth())
         {
            this.dragLayer.x = PlantsVsZombies.WIDTH - this.getBGWidth();
         }
         if(this.dragLayer.y < PlantsVsZombies.HEIGHT - this.getBGHeight())
         {
            this.dragLayer.y = PlantsVsZombies.HEIGHT - this.getBGHeight();
         }
      }
      
      private function getBGWidth() : Number
      {
         return this.dragLayer.width * this.dragLayer.scaleX;
      }
      
      private function getBGHeight() : Number
      {
         return this.dragLayer.height;
      }
      
      protected function onMouseOutHandler(param1:MouseEvent) : void
      {
         if(!(param1.target is SimpleButton) || param1.target is StoneSceneTips)
         {
            return;
         }
         this.m_tips.visible = false;
         this.m_tips.hideTips();
      }
      
      protected function onMouseOverHandler(param1:MouseEvent) : void
      {
         if(!(param1.target is SimpleButton))
         {
            return;
         }
         var _loc2_:String = param1.target.name;
         var _loc3_:StoneSceneIconData = this.m_icons[_loc2_].getIconData();
         if(this.m_tips == null)
         {
            this.m_tips = new StoneSceneTips();
         }
         this.m_tips.show(_loc3_);
         this.m_tips.visible = true;
         this.m_tips.showTips(param1);
      }
      
      protected function onMouseClickHandler(param1:MouseEvent) : void
      {
         if(!(param1.target is SimpleButton))
         {
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:String = param1.target.name;
         var _loc3_:StoneSceneIcon = this.m_icons[_loc2_];
         if(_loc3_.getClosingAttr())
         {
            FuncKit.showSystermInfo(this.getErrorTipsInfo(_loc3_.getId()));
            return;
         }
         var _loc4_:int = _loc3_.getId();
         this.onIconClickCall(_loc4_);
      }
      
      private function getErrorTipsInfo(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 6:
               _loc2_ = LangManager.getInstance().getLanguage("copy012");
               break;
            case 7:
               _loc2_ = LangManager.getInstance().getLanguage("copy013");
               break;
            case 8:
               _loc2_ = LangManager.getInstance().getLanguage("copy014");
               break;
            case 9:
               _loc2_ = LangManager.getInstance().getLanguage("copy015");
         }
         return _loc2_;
      }
      
      protected function onMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = new Rectangle(GameManager.m_gameWidth - this.dragLayer.width,GameManager.m_gameHeight - this.dragLayer.height,this.dragLayer.width - GameManager.m_gameWidth,this.dragLayer.height - GameManager.m_gameHeight);
         this.dragLayer.startDrag(false,_loc2_);
         this.dragLayer.stage.addEventListener(MouseEvent.MOUSE_UP,this.dropDragLayer);
      }
      
      private function dropDragLayer(param1:MouseEvent) : void
      {
         this.dragLayer.stage.removeEventListener(MouseEvent.MOUSE_UP,this.dropDragLayer);
         this.dragLayer.stopDrag();
      }
      
      private function deleteAll() : void
      {
         var _loc1_:StoneSceneIcon = null;
         this.removeMouseEvents();
         this.m_icons.length = 0;
         FuncKit.clearAllChildrens(this.dragLayer);
         this.iconIDS = null;
         this.dragLayer = null;
         this.backBtn = null;
         this.onIconClickCall = null;
         this.onAllCloseCall = null;
         this.m_icons = null;
         for each(_loc1_ in this.m_icons)
         {
            _loc1_.clearAll();
            _loc1_ = null;
         }
         if(this.m_tips != null)
         {
            this.m_tips.clear();
         }
      }
      
      override public function destroy() : void
      {
         this.onHide();
         this.deleteAll();
      }
      
      private function onBackHandler(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.onAllCloseCall();
      }
      
      protected function onClickBuyHandler(param1:MouseEvent = null) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.max_buy_num == 0)
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("copy009"));
            return;
         }
         new AddStoneBattleNum(this.onBuyBattleNumCall,this.max_buy_num);
      }
      
      private function onExchangeHandler(param1:MouseEvent) : void
      {
         var tool:Tool = null;
         var addTimes:Function = null;
         var e:MouseEvent = param1;
         addTimes = function(param1:int):void
         {
            PlantsVsZombies.playerManager.getPlayer().updateTool(tool.getOrderId(),tool.getNum() - param1);
            onExchangeBattleNumCall(tool.getOrderId(),param1);
         };
         tool = PlantsVsZombies.playerManager.getPlayer().getTool(1001);
         var toolnum:int = 0;
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
      
      private function addMouseEvents() : void
      {
         this.backBtn.addEventListener(MouseEvent.CLICK,this.onBackHandler);
         this.helpBtn.addEventListener(MouseEvent.ROLL_OVER,this.onHelpOver);
         this.helpBtn.addEventListener(MouseEvent.ROLL_OUT,this.onHelpOut);
         this.dragLayer.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.dragLayer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         this.dragLayer.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
         this.dragLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         this.m_battle["buy"].addEventListener(MouseEvent.CLICK,this.onClickBuyHandler);
         this.m_battle["addTimebtn"].addEventListener(MouseEvent.CLICK,this.onExchangeHandler);
      }
      
      private function removeMouseEvents() : void
      {
         this.backBtn.removeEventListener(MouseEvent.CLICK,this.onBackHandler);
         this.helpBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onHelpOver);
         this.helpBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onHelpOut);
         this.dragLayer.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.dragLayer.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         this.dragLayer.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
         this.dragLayer.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         this.m_battle["buy"].removeEventListener(MouseEvent.CLICK,this.onClickBuyHandler);
         this.m_battle["addTimebtn"].removeEventListener(MouseEvent.CLICK,this.onExchangeHandler);
      }
   }
}

