package pvz.shaketree.view.secne
{
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import pvz.shaketree.net.ShakeTreeFPort;
   import pvz.shaketree.view.tips.ShakeTreeHelpTips;
   import pvz.shaketree.view.windows.AddTimesWindow;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import tip.notice.NoticeManager;
   import utils.FuncKit;
   
   public class UIPanelLayer
   {
      
      private var _scene:ShakeTreeScene;
      
      private var _tips:ShakeTreeHelpTips;
      
      private var _baoji:BaoJiBar;
      
      public function UIPanelLayer(param1:ShakeTreeScene)
      {
         super();
         this._scene = param1;
         this.addEvent();
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.updateAttackTimes();
         this.updatePassLevel();
         this.updateBaoJiBar();
         this.initNotice();
      }
      
      private function addEvent() : void
      {
         var exitScene:Function = null;
         exitScene = function():void
         {
            _scene.ui["back"].removeEventListener(MouseEvent.MOUSE_UP,exitScene);
            destory();
            _scene.destroy();
            PlantsVsZombies.backToFirstPage();
         };
         this._scene.ui["back"].addEventListener(MouseEvent.MOUSE_UP,exitScene);
         this._scene.ui["help"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._scene.ui["help"].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._scene.ui["buy"].addEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
      }
      
      private function onBuyTimes(param1:MouseEvent) : void
      {
         this.toBuyChallengeTimes();
      }
      
      public function toBuyChallengeTimes() : void
      {
         var buy:Function = null;
         buy = function(param1:int):void
         {
            var onComplete:Function = null;
            var times:int = param1;
            onComplete = function(param1:HandleDataCompleteEvent):void
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("shakeTree006"));
               ShakeTreeSystermData.I.setChanllgeTime(ShakeTreeSystermData.I.getChanllgeTimes() + times);
               ShakeTreeSystermData.I.setCanBuyChanllageTimes(ShakeTreeSystermData.I.getCanBuyChanllageTimes() - times);
               updateAttackTimes();
               PlantsVsZombies.changeMoneyOrExp(-10 * times,PlantsVsZombies.RMB,true,false);
            };
            var port:ShakeTreeFPort = new ShakeTreeFPort();
            port.requestSever(ShakeTreeFPort.ADD_TIMES,times);
            port.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onComplete);
         };
         if(ShakeTreeSystermData.I.getCanBuyChanllageTimes() <= 0)
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("shakeTree009"));
            return;
         }
         new AddTimesWindow(buy);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._tips = new ShakeTreeHelpTips();
         this._scene.ui.addChild(this._tips);
         this._tips.setLocation(310,10);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._scene.ui.removeChild(this._tips);
      }
      
      public function updatePassLevel() : void
      {
         FuncKit.clearAllChildrens(this._scene.ui["passLevelNode"]);
         var _loc1_:int = ShakeTreeSystermData.I.currentPassData().getPassLevel();
         var _loc2_:int = Math.ceil(_loc1_ / 4);
         var _loc3_:String = _loc2_ + "h" + (_loc1_ - (_loc2_ - 1) * 4);
         this._scene.ui["passLevelNode"].addChild(FuncKit.getNumEffect(_loc3_,"Tollgate"));
      }
      
      public function updateAttackTimes() : void
      {
         FuncKit.clearAllChildrens(this._scene.ui["_timesNode"]);
         this._scene.ui["_timesNode"].addChild(FuncKit.getNumEffect(ShakeTreeSystermData.I.getChanllgeTimes() + "","AttackNum"));
      }
      
      private function initNotice() : void
      {
         NoticeManager.getInstance.initNotice(NoticeManager.DYNAMIC_MESSAGES_MAIN,80,100);
      }
      
      public function updateBaoJiBar() : void
      {
         if(this._baoji == null)
         {
            this._baoji = new BaoJiBar(this._scene.ui);
         }
         this._baoji.updatabar();
      }
      
      public function showHundred() : void
      {
         if(this._baoji)
         {
            this._baoji.showHundred();
         }
      }
      
      private function destory() : void
      {
         NoticeManager.getInstance.stop();
         this._baoji.destroy();
         this._scene.ui["help"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._scene.ui["help"].removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._scene.ui["buy"].removeEventListener(MouseEvent.MOUSE_UP,this.onBuyTimes);
      }
   }
}

