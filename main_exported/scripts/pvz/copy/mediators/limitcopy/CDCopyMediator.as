package pvz.copy.mediators.limitcopy
{
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import core.ui.panel.BaseMediator;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.copy.models.cd.CDTimeCheckPoint;
   import pvz.copy.models.cd.CDTimeCheckPointProxy;
   import pvz.copy.models.limit.ActivtyCopyData;
   import pvz.copy.net.ActivtyCopyFPort;
   import pvz.copy.ui.scene.ActvityCopySence;
   import pvz.copy.ui.sprites.CDCheckPointSprite;
   import pvz.copy.ui.tips.ActivtyCopyHelpTips;
   import pvz.hunting.window.BattleReadyWindow;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   
   public class CDCopyMediator extends BaseMediator
   {
      
      private var _view:ActvityCopySence;
      
      private const MAX:int = 4;
      
      private var _cdCheckPointProxy:CDTimeCheckPointProxy;
      
      private var _helpTips:ActivtyCopyHelpTips;
      
      public function CDCopyMediator()
      {
         super();
         this._view = getView(ActvityCopySence) as ActvityCopySence;
         this._view.backBtn.visible = false;
         this._view.getChallagePanel().visible = false;
         this.addEvent();
         ActivtyCopyData.setCopyId(2);
         this.initdata();
      }
      
      private function initdata() : void
      {
         var port:ActivtyCopyFPort = null;
         var onCompete:Function = null;
         onCompete = function(param1:HandleDataCompleteEvent):void
         {
            port.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onCompete);
            if(_cdCheckPointProxy == null)
            {
               _cdCheckPointProxy = new CDTimeCheckPointProxy();
            }
            _cdCheckPointProxy.setData(param1._data);
            showCheckPoint();
            _view.updateActivtyTime(_cdCheckPointProxy.getStartTime(),_cdCheckPointProxy.getEndTime());
            _view.onShow();
         };
         port = new ActivtyCopyFPort();
         port.requestSever(ActivtyCopyFPort.CDTIME_INIT);
         port.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onCompete);
      }
      
      private function showCheckPoint() : void
      {
         var _loc2_:CDCheckPointSprite = null;
         var _loc6_:int = 0;
         this.clearAllCheckPoint();
         var _loc1_:Vector.<CDTimeCheckPoint> = this._cdCheckPointProxy.getAllCheckPoint();
         var _loc3_:int = int(_loc1_.length);
         if(_loc3_ <= 0)
         {
            return;
         }
         var _loc4_:int = _loc3_ % 4 > 0 ? int(_loc3_ / this.MAX + 1) : int(_loc3_ / this.MAX);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = 0;
            while(_loc6_ < this.MAX)
            {
               if(_loc5_ * this.MAX + _loc6_ >= _loc3_)
               {
                  break;
               }
               _loc2_ = new CDCheckPointSprite(_loc1_[_loc5_ * this.MAX + _loc6_],this.toBattle);
               this._view.chpaterNode.addChild(_loc2_);
               _loc2_.x = 110 + 130 * _loc6_;
               _loc2_.y = 150 + _loc5_ * 150;
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this._helpTips)
         {
            this._helpTips.hideTips();
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._helpTips == null)
         {
            this._helpTips = new ActivtyCopyHelpTips();
         }
         this._helpTips.showTips(this._cdCheckPointProxy.getHelpTips());
      }
      
      private function clearAllCheckPoint() : void
      {
         var _loc1_:CDCheckPointSprite = null;
         while(this._view.chpaterNode.numChildren)
         {
            _loc1_ = this._view.chpaterNode.getChildAt(0) as CDCheckPointSprite;
            _loc1_.destroy();
            this._view.chpaterNode.removeChild(_loc1_);
         }
      }
      
      private function toBattle(param1:CDTimeCheckPoint) : void
      {
         var end:Function = null;
         var cpv:CDTimeCheckPoint = param1;
         end = function():void
         {
            var _loc1_:BattleReadyWindow = new BattleReadyWindow(BattleReadyWindow.CDTIME_BATTLE);
            _loc1_.show(cpv.getId(),cpv.getEnemyOrgs(),update,null,null,0);
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(cpv == null)
         {
            return;
         }
         DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_BATTLE_READY_WINDOW,end);
      }
      
      private function update() : void
      {
         this.initdata();
      }
      
      private function addEvent() : void
      {
         this._view.closeBtn.addEventListener(MouseEvent.MOUSE_UP,this.closeWindow);
         this._view.helpButton.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._view.helpButton.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function closeWindow(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._view.closeBtn.removeEventListener(MouseEvent.MOUSE_UP,this.closeWindow);
         this._view.helpButton.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._view.helpButton.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.destory();
         this._view.onHide();
      }
      
      private function destory() : void
      {
         if(this._cdCheckPointProxy)
         {
            this._cdCheckPointProxy.destroy();
         }
         this.clearAllCheckPoint();
      }
   }
}

