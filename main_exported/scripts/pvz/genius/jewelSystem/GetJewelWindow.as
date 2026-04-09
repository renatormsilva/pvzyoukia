package pvz.genius.jewelSystem
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.copy.mediators.StoneMediator;
   import pvz.serverbattle.shop.MedalShopWindow;
   import pvz.shaketree.ShakeTreeControl;
   import pvz.shop.ShopWindow;
   import utils.GetDomainRes;
   
   public class GetJewelWindow extends BaseWindow
   {
      
      public static const OPEN_IN_NORMAL:int = 1;
      
      public static const OPEN_IN_SECNE:int = 2;
      
      public static const OPEN_IN_LACK:int = 3;
      
      private var _openType:int;
      
      private var _ui:MovieClip;
      
      private var _tool:Tool;
      
      private var _callback:Function;
      
      public function GetJewelWindow(param1:Tool = null, param2:Function = null, param3:int = 1)
      {
         super();
         this._callback = param2;
         this._openType = param3;
         this._ui = GetDomainRes.getMoveClip("JewelSystem.getJewelWindow");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._ui);
         this._tool = param1;
         this.showText(param3);
         this.setLocation();
         this.addEvent();
         onShowEffect(this._ui);
      }
      
      private function showText(param1:int) : void
      {
         if(param1 == OPEN_IN_NORMAL)
         {
            this._ui._txt.text = LangManager.getInstance().getLanguage("genius027");
         }
         else if(param1 == OPEN_IN_SECNE)
         {
            this._ui._txt.htmlText = LangManager.getInstance().getLanguage("genius004") + "<font color=\'#ff0000\' size=\'15\'><center>" + this._tool.getName() + "</center></font>" + LangManager.getInstance().getLanguage("genius005");
            this._ui._btn3.gotoAndStop(2);
         }
         else if(param1 == OPEN_IN_LACK)
         {
            this._ui._txt.htmlText = LangManager.getInstance().getLanguage("genius046") + "<font color=\'#ff0000\' size=\'15\'><center>" + this._tool.getName() + "</center></font>" + LangManager.getInstance().getLanguage("genius047");
         }
      }
      
      private function addEvent() : void
      {
         var onClose:Function = null;
         onClose = function():void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _ui._close.removeEventListener(MouseEvent.MOUSE_UP,onClose);
            hide();
         };
         this._ui._btn1.addEventListener(MouseEvent.MOUSE_UP,this.toShakeMoneyTree);
         this._ui._btn2.addEventListener(MouseEvent.MOUSE_UP,this.toShopWindow);
         this._ui._btn3.addEventListener(MouseEvent.MOUSE_UP,this.toCompose);
         this._ui._btn4.addEventListener(MouseEvent.MOUSE_UP,this.toWorld);
         this._ui._close.addEventListener(MouseEvent.MOUSE_UP,onClose);
      }
      
      private function setLocation() : void
      {
         this._ui.x = (PlantsVsZombies.WIDTH - this._ui.width) / 2 + this._ui.width / 2;
         this._ui.y = (PlantsVsZombies.HEIGHT - this._ui.height) / 2 + this._ui.height / 2;
      }
      
      private function toShakeMoneyTree(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         new ShakeTreeControl(this._callback);
         this.hide();
      }
      
      private function toShopWindow(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         new ShopWindow(this._callback,2);
         this.hide();
      }
      
      private function toCompose(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._openType == OPEN_IN_SECNE)
         {
            if(this._tool)
            {
               new JewelComposeWindow(this._tool);
            }
         }
         else if(this._openType == OPEN_IN_NORMAL || this._openType == OPEN_IN_LACK)
         {
            new MedalShopWindow(this._callback,1);
         }
         this.hide();
      }
      
      private function toWorld(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         new StoneMediator(this._callback);
         this.hide();
      }
      
      private function hide() : void
      {
         var end:Function = null;
         end = function():void
         {
            destory();
            PlantsVsZombies._node.removeChild(_ui);
         };
         onHiddenEffect(this._ui,end);
      }
      
      private function destory() : void
      {
         this._ui._btn1.removeEventListener(MouseEvent.MOUSE_UP,this.toShakeMoneyTree);
         this._ui._btn2.removeEventListener(MouseEvent.MOUSE_UP,this.toShopWindow);
         this._ui._btn3.removeEventListener(MouseEvent.MOUSE_UP,this.toCompose);
         this._ui._btn4.removeEventListener(MouseEvent.MOUSE_UP,this.toWorld);
      }
   }
}

