package windows
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import zlib.utils.DomainAccess;
   
   public class RechargeWindow extends BaseWindow
   {
      
      private static var _callblack:Function;
      
      public static const RECHARGE:int = 1;
      
      public static const BUY:int = 2;
      
      private var _window:MovieClip;
      
      public function RechargeWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("rechargeWindow");
         this._window = new _loc1_();
         this._window.gotoAndPlay(1);
         this._window.visible = false;
         this._window["ok1"].visible = false;
         this._window["ok2"].visible = false;
         this._window["sure"].visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["ok1"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["ok2"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok1" || param1.currentTarget.name == "ok2")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(_callblack != null)
            {
               _callblack();
            }
            this.hidden();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.hidden();
         }
      }
      
      private function hidden() : void
      {
         _callblack = null;
         onHiddenEffect(this._window);
      }
      
      private function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
      }
      
      public function init(param1:String, param2:Function, param3:int = 1) : void
      {
         this._window["ok1"].visible = false;
         this._window["ok2"].visible = false;
         if(param3 == 1)
         {
            this._window["ok1"].visible = true;
         }
         else
         {
            this._window["ok2"].visible = true;
         }
         this._window.gotoAndPlay(param3);
         this._window["text1"].text = param1;
         _callblack = param2;
         this.show();
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}

