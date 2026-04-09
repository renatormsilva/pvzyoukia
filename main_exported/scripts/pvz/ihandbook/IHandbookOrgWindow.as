package pvz.ihandbook
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import node.OrgLoader;
   import utils.FuncKit;
   import xmlReader.config.XmlOrganismConfig;
   import zlib.utils.DomainAccess;
   
   public class IHandbookOrgWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _index:int;
      
      internal var _baseArray:Array;
      
      public function IHandbookOrgWindow(param1:int, param2:Array)
      {
         super();
         this._index = param1;
         this._baseArray = param2;
         var _loc3_:Class = DomainAccess.getClass("ihandbook_org");
         this._window = new _loc3_();
         this._window.visible = false;
         this._window._cancel.addEventListener(MouseEvent.CLICK,this.onHidden);
         this._window._right.addEventListener(MouseEvent.CLICK,this.onRight);
         this._window._left.addEventListener(MouseEvent.CLICK,this.onLeft);
         this.setInfo();
         PlantsVsZombies._node.addChild(this._window);
      }
      
      private function removeEvent() : void
      {
         this._window._right.removeEventListener(MouseEvent.CLICK,this.onRight);
         this._window._left.removeEventListener(MouseEvent.CLICK,this.onLeft);
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
         if(this._index >= this._baseArray.length - 1)
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
         this.removeEvent();
         this.clearOrg();
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._window._cancel.removeEventListener(MouseEvent.CLICK,this.onHidden);
         if(this._window._org != null && this._window._org.numChildren > 0)
         {
            (this._window._org.getChildAt(0) as OrgLoader).destroy();
            FuncKit.clearAllChildrens(this._window._org);
         }
         onHiddenEffect(this._window,clear);
      }
      
      private function setInfo() : void
      {
         this._window["_name"].text = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getName();
         this._window._id.text = this._baseArray[this._index];
         this._window._attribute.text = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getAttribute_name();
         this._window._uotput.text = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getPurse_amount();
         this._window._type.text = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getType();
         this._window._use_result.text = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getUse_result();
         this._window._expl.text = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getExpl();
         var _loc1_:int = XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getPicId();
         this.setHeadPic(_loc1_);
         this.setOrg(_loc1_);
      }
      
      private function setOrg(param1:int) : void
      {
         this.clearOrg();
         var _loc2_:DisplayObject = new OrgLoader(param1,0,null);
         this._window._org.x = 172 / 2 + this._window._base_org.x;
         this._window._org.y = 150 + this._window._base_org.y;
         this._window._org.mouseChildren = false;
         this._window._org.mouseEnabled = false;
         this._window._org.addChild(_loc2_);
      }
      
      private function clearOrg() : void
      {
         if(this._window._org != null && this._window._org.numChildren > 0)
         {
            (this._window._org.getChildAt(0) as OrgLoader).destroy();
            FuncKit.clearAllChildrens(this._window._org);
         }
      }
      
      private function setHeadPic(param1:int) : void
      {
         if(this._window._pic != null && this._window._pic.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._window._pic);
         }
         Icon.setUrlIcon(this._window._pic,param1,Icon.ORGANISM_1);
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

