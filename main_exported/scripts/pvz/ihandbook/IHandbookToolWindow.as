package pvz.ihandbook
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import utils.FuncKit;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   
   public class IHandbookToolWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _index:int;
      
      internal var _baseArray:Array;
      
      public function IHandbookToolWindow(param1:int, param2:Array)
      {
         super();
         this._index = param1;
         this._baseArray = param2;
         var _loc3_:Class = DomainAccess.getClass("ihandbook_tool");
         this._window = new _loc3_();
         this._window.visible = false;
         this._window._cancel.addEventListener(MouseEvent.CLICK,this.onHidden);
         this._window._right.addEventListener(MouseEvent.CLICK,this.onRight);
         this._window._left.addEventListener(MouseEvent.CLICK,this.onLeft);
         this.setInfo();
         PlantsVsZombies._node.addChild(this._window);
      }
      
      private function onLeft(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._index < 1)
         {
            return;
         }
         --this._index;
         this.setInfo();
      }
      
      private function onRight(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._index == this._baseArray.length - 1)
         {
            return;
         }
         ++this._index;
         this.setInfo();
      }
      
      private function onHidden(param1:MouseEvent) : void
      {
         var clear:Function = null;
         var e:MouseEvent = param1;
         clear = function():void
         {
            PlantsVsZombies._node.removeChild(_window);
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._window._cancel.removeEventListener(MouseEvent.CLICK,this.onHidden);
         onHiddenEffect(this._window,clear);
      }
      
      private function setInfo() : void
      {
         this._window._name.text = XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getName();
         this._window._id.text = this._baseArray[this._index];
         this._window._type_name.text = XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getTypeName();
         this._window._sell_price.text = XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getSell_price();
         this._window._use_result.text = XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getUse_result();
         this._window._expl.text = XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getExpl();
         this._window._use_condition.text = XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getUse_condition();
         this.setHeadPic(XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getPicId());
      }
      
      private function setHeadPic(param1:int) : void
      {
         if(this._window._pic != null && this._window._pic.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window._pic);
         }
         Icon.setUrlIcon(this._window._pic,param1,Icon.TOOL_1);
      }
      
      public function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         onShowEffect(this._window);
         this.setLoction();
      }
      
      private function setLoction() : void
      {
         this._window.visible = true;
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}

