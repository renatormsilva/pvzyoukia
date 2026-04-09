package pvz.genius.jewelSystem
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import pvz.genius.jewelSystem.event.SelectJewelEvent;
   import pvz.genius.jewelSystem.event.UpdateJewelStorageEvent;
   import pvz.genius.tips.JewelComposeHelpTips;
   import pvz.genius.tips.JewelTips;
   import utils.GetDomainRes;
   
   public class JewelComposeWindow extends BaseWindow
   {
      
      public static var jewelTips:JewelTips;
      
      private var _leftPanel:JewelComposePanel;
      
      private var _rightPanel:JewelStroagePanel;
      
      private var _window:MovieClip;
      
      private var _type:int;
      
      private var _lackJewel:Tool;
      
      private var _helpTips:JewelComposeHelpTips;
      
      public function JewelComposeWindow(param1:Tool = null)
      {
         super();
         if(param1)
         {
            this._type = int(param1.getType());
         }
         this._lackJewel = param1;
         this._window = GetDomainRes.getMoveClip("jewel.JewelComposeWindow");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.setLocation();
         this._window.visible = false;
         this.initUI(this._type);
      }
      
      private function setLocation() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window._close.removeEventListener(MouseEvent.MOUSE_UP,onClose);
            onHiddenEffect(_window,destory);
         };
         this._rightPanel.addEventListener(SelectJewelEvent.SELECT_JEWEL,this.onSelectJewel);
         this._leftPanel.addEventListener(UpdateJewelStorageEvent.UPDATE,this.onUpdate);
         this._window._close.addEventListener(MouseEvent.MOUSE_UP,onClose);
         this._window._help.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._window._help.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._helpTips = new JewelComposeHelpTips();
         this._window.addChild(this._helpTips);
         this._helpTips.setLocation(-80,-230);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._window.removeChild(this._helpTips);
      }
      
      private function onUpdate(param1:UpdateJewelStorageEvent) : void
      {
         this.initUI(this._type);
      }
      
      private function onSelectJewel(param1:SelectJewelEvent) : void
      {
         var updateStorage:Function = null;
         var e:SelectJewelEvent = param1;
         updateStorage = function():void
         {
            _rightPanel.updateStoage();
         };
         this._leftPanel.initUI(e._jewelId,updateStorage);
      }
      
      private function initUI(param1:int = 0) : void
      {
         var dataEnd:Function = null;
         var type:int = param1;
         dataEnd = function():void
         {
            PlantsVsZombies.showDataLoading(false);
            _leftPanel = new JewelComposePanel();
            _leftPanel.setNoteWordsInfo(_lackJewel);
            _rightPanel = new JewelStroagePanel();
            _rightPanel.initUI(type);
            _window._panel1.addChild(_leftPanel);
            _window._panel2.addChild(_rightPanel);
            addEvent();
            jewelTips = new JewelTips();
            jewelTips.visible = false;
            _window.addChild(jewelTips);
            if(_window.visible == false)
            {
               _window.visible = true;
               onShowEffect(_window);
            }
         };
         PlantsVsZombies.showDataLoading(true);
         PlantsVsZombies.storageInfo(dataEnd);
      }
      
      private function destory() : void
      {
         this._rightPanel.removeEventListener(SelectJewelEvent.SELECT_JEWEL,this.onSelectJewel);
         this._leftPanel.removeEventListener(UpdateJewelStorageEvent.UPDATE,this.onUpdate);
         this._rightPanel.destroy();
         this._leftPanel.destroy();
      }
   }
}

