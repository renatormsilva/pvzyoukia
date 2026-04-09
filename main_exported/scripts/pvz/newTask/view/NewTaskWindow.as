package pvz.newTask.view
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import pvz.newTask.ctrl.NewTaskCtrl;
   import pvz.newTask.data.NewTaskVo;
   import utils.GetDomainRes;
   
   public class NewTaskWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _panel:NewTaskPanel;
      
      public var _mrg:NewTaskCtrl;
      
      public var currentType:int = 1;
      
      public function NewTaskWindow()
      {
         super(UINameConst.UI_TASK_WINDOW);
      }
      
      override protected function initWindowUI() : void
      {
         this.init();
      }
      
      private function init() : void
      {
         this.showType = PANEL_TYPE_2;
         this._window = GetDomainRes.getMoveClip("pvz.newTask.newTaskWindw");
         this._window.tab1.gotoAndStop(1);
         this._window.tab1.isOver.visible = false;
         this._window.tab2.gotoAndStop(1);
         this._window.tab2.isOver.visible = false;
         this._window.tab3.gotoAndStop(1);
         this._window.tab3.isOver.visible = false;
         this._window.tab4.gotoAndStop(1);
         this._window.tab4.isOver.visible = false;
         this.addChild(this._window);
         this._panel = new NewTaskPanel();
         this._window.panel.addChild(this._panel);
      }
      
      public function selectTyep(param1:int = 1) : void
      {
         this.currentType = param1;
         switch(param1)
         {
            case 1:
               this._window.tab1.gotoAndStop(2);
               this.upData(this._mrg._vo);
               break;
            case 2:
               this._window.tab2.gotoAndStop(2);
               this.upData(this._mrg._vo);
               break;
            case 3:
               this._window.tab3.gotoAndStop(2);
               this.upData(this._mrg._vo);
               break;
            case 4:
               this._window.tab4.gotoAndStop(2);
               this.upData(this._mrg._vo);
         }
      }
      
      public function upData(param1:NewTaskVo) : void
      {
         this._window.tab1.isOver.visible = param1.getIsOver(1);
         this._window.tab2.isOver.visible = param1.getIsOver(2);
         this._window.tab3.isOver.visible = param1.getIsOver(3);
         this._window.tab4.isOver.visible = param1.getIsOver(4);
         this._window.tab1.isOver.y = 1.5;
         this._window.tab2.isOver.y = 1.5;
         this._window.tab3.isOver.y = 1.5;
         this._window.tab4.isOver.y = 1.5;
         switch(this.currentType)
         {
            case 1:
               this._window.tab1.isOver.y = -6.5;
               this._panel.upData(param1.getMainTask());
               break;
            case 2:
               this._window.tab2.isOver.y = -6.5;
               this._panel.upData(param1.getSideTask());
               break;
            case 3:
               this._window.tab3.isOver.y = -6.5;
               this._panel.upData(param1.getDailyTask());
               break;
            case 4:
               this._window.tab4.isOver.y = -6.5;
               this._panel.upData(param1.getActiveTask());
         }
      }
      
      override public function onShow() : void
      {
         super.onShow();
         this.addEvent();
         this.setLoction();
         this.selectTyep(this.currentType);
      }
      
      private function select(param1:MouseEvent) : void
      {
         this._window.tab1.gotoAndStop(1);
         this._window.tab2.gotoAndStop(1);
         this._window.tab3.gotoAndStop(1);
         this._window.tab4.gotoAndStop(1);
         switch(param1.currentTarget)
         {
            case this._window.tab1:
               this.selectTyep(1);
               break;
            case this._window.tab2:
               this.selectTyep(2);
               break;
            case this._window.tab3:
               this.selectTyep(3);
               break;
            case this._window.tab4:
               this.selectTyep(4);
         }
      }
      
      private function close(param1:MouseEvent) : void
      {
         this._mrg.Close();
      }
      
      private function addEvent() : void
      {
         this._window.tab1.addEventListener(MouseEvent.CLICK,this.select);
         this._window.tab2.addEventListener(MouseEvent.CLICK,this.select);
         this._window.tab3.addEventListener(MouseEvent.CLICK,this.select);
         this._window.tab4.addEventListener(MouseEvent.CLICK,this.select);
         this._window.btn_close.addEventListener(MouseEvent.CLICK,this.close);
      }
      
      private function delEvent() : void
      {
         this._window.tab1.removeEventListener(MouseEvent.CLICK,this.select);
         this._window.tab2.removeEventListener(MouseEvent.CLICK,this.select);
         this._window.tab3.removeEventListener(MouseEvent.CLICK,this.select);
         this._window.tab4.removeEventListener(MouseEvent.CLICK,this.select);
         this._window.btn_close.removeEventListener(MouseEvent.CLICK,this.close);
      }
      
      override public function onHide() : void
      {
         super.onHide();
         this.delEvent();
      }
      
      private function setLoction() : void
      {
         this.x = (PlantsVsZombies.WIDTH - this.width) / 2;
         this.y = (PlantsVsZombies.HEIGHT - this.height) / 2 + 5;
      }
   }
}

