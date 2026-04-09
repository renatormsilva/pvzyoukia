package labels
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import pvz.ihandbook.IHandbookOrgWindow;
   import pvz.ihandbook.IHandbookToolWindow;
   import pvz.ihandbook.IHandbookWindow;
   import utils.FuncKit;
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class IHandbookLabel extends Sprite implements IDestroy
   {
      
      private var _label:MovieClip;
      
      private var _index:int;
      
      private var _baseArray:Array;
      
      private var _window:Object;
      
      private var _type:int = 0;
      
      public function IHandbookLabel(param1:int, param2:Array, param3:Boolean, param4:int)
      {
         super();
         this._index = param1;
         this._type = param4;
         this._baseArray = param2;
         var _loc5_:Class = DomainAccess.getClass("label_i");
         this._label = new _loc5_();
         this._label["_mask"].visible = false;
         this._label.gotoAndStop(0);
         this._label._new.visible = false;
         this._label.addEventListener(MouseEvent.CLICK,this.onClick);
         this.selectedEvent();
         this.setInfos();
         this.addChild(this._label);
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         this.removeChild(this._label);
         this._label = null;
      }
      
      public function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._type == IHandbookWindow.ORG)
         {
            this._window = new IHandbookOrgWindow(this._index,this._baseArray);
            this._window.show();
         }
         else if(this._type == IHandbookWindow.TOOL)
         {
            this._window = new IHandbookToolWindow(this._index,this._baseArray);
            this._window.show();
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._label.gotoAndStop(2);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._label.gotoAndStop(1);
      }
      
      private function selectedEvent() : void
      {
         this._label.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._label.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         this._label.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._label.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._label.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function setInfos() : void
      {
         this._label.buttonMode = true;
         FuncKit.clearAllChildrens(this._label["pic"]);
         if(this._type == IHandbookWindow.ORG)
         {
            Icon.setUrlIcon(this._label["pic"],XmlOrganismConfig.getInstance().getOrganismAttribute(this._baseArray[this._index]).getPicId(),Icon.ORGANISM_1);
            this._label["str"].text = "NO." + this._baseArray[this._index];
         }
         else if(this._type == IHandbookWindow.TOOL)
         {
            Icon.setUrlIcon(this._label["pic"],XmlToolsConfig.getInstance().getToolAttribute(this._baseArray[this._index]).getPicId(),Icon.TOOL_1);
            this._label["str"].text = "NO." + this._baseArray[this._index];
         }
      }
      
      public function setLoction(param1:int) : void
      {
         var _loc2_:int = param1 % 4;
         var _loc3_:int = param1 / 4;
         this._label.x = (this._label.width + 4) * _loc2_;
         this._label.y = (this._label.height + 4) * _loc3_;
      }
   }
}

