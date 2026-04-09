package pvz.ihandbook
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import labels.IHandbookLabel;
   import manager.SoundManager;
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class IHandbookWindow extends BaseWindow implements IDestroy
   {
      
      public static const MAX:int = 12;
      
      public static const ORG:int = 1;
      
      public static const TOOL:int = 2;
      
      internal var _type:int = 0;
      
      internal var _window:MovieClip;
      
      internal var _nowPage:int = 1;
      
      internal var _maxPages:int = 1;
      
      internal var _baseArray:Array;
      
      internal var _nowArray:Array;
      
      internal var tools_num:int;
      
      internal var orgs_num:int;
      
      public function IHandbookWindow()
      {
         super(UINameConst.UI_ATLAS);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ihandbookWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["kinds"]["selected1"].visible = true;
         this._window["kinds"]["selected1"].gotoAndStop(1);
         this._window["kinds"]["selected2"].visible = false;
         this._window["kinds"]["selected2"].gotoAndStop(2);
         this.addButtonEvent();
         onShowEffect(this._window);
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this.show();
      }
      
      override public function destroy() : void
      {
         this.removeButtonEvent();
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function setKindsSelectedFalse() : void
      {
         this._window["kinds"]["selected1"].visible = false;
         this._window["kinds"]["selected2"].visible = false;
      }
      
      private function addButtonEvent() : void
      {
         this._window.cancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this._window["kinds"]["bt1"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._window["kinds"]["bt2"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._window["kinds"]["addnum"].addEventListener(MouseEvent.CLICK,this.onNumEvent);
         this._window["kinds"]["decnum"].addEventListener(MouseEvent.CLICK,this.onNumEvent);
      }
      
      private function removeButtonEvent() : void
      {
         this._window.cancel.removeEventListener(MouseEvent.CLICK,this.onCancel);
         this._window["kinds"]["bt1"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._window["kinds"]["bt2"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._window["kinds"]["addnum"].removeEventListener(MouseEvent.CLICK,this.onNumEvent);
         this._window["kinds"]["decnum"].removeEventListener(MouseEvent.CLICK,this.onNumEvent);
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.hidden();
      }
      
      private function initArray(param1:int) : void
      {
         this._baseArray = new Array();
         var _loc2_:Array = new Array();
         if(param1 == ORG)
         {
            _loc2_ = XmlOrganismConfig.getInstance().getAllPlants();
         }
         else if(param1 == TOOL)
         {
            _loc2_ = XmlToolsConfig.getInstance().getAllTools();
         }
         if(_loc2_ == null || _loc2_.length < 1)
         {
            return;
         }
         var _loc3_:int = 0;
         this._maxPages = (_loc2_.length - 1) / MAX + 1;
         this._baseArray = _loc2_;
         this._window._p.text = "";
      }
      
      private function isNew(param1:int, param2:Array) : Boolean
      {
         return false;
      }
      
      private function show(param1:int = 1, param2:Boolean = true) : void
      {
         this.setKindsSelectedFalse();
         this._type = param1;
         if(this._type == ORG)
         {
            this._window["kinds"]["selected1"].visible = true;
            this._window["kinds"]["selected1"].gotoAndStop(ORG);
         }
         else if(this._type == TOOL)
         {
            this._window["kinds"]["selected2"].visible = true;
            this._window["kinds"]["selected2"].gotoAndStop(TOOL);
         }
         this._nowPage = 1;
         this.initArray(this._type);
         this.showPage(this._nowPage);
         this.setPage();
         this.setLoction();
      }
      
      private function setPage() : void
      {
         this._window.kinds._num.text = this._nowPage + "/" + this._maxPages;
      }
      
      private function showPage(param1:int) : void
      {
         this._nowArray = null;
         this._nowArray = new Array();
         var _loc2_:Array = this._baseArray.slice((param1 - 1) * MAX,param1 * MAX);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this._nowArray.push(new IHandbookLabel((param1 - 1) * MAX + _loc3_,this._baseArray,this.isNew((param1 - 1) * MAX + _loc3_,this._baseArray),this._type));
            _loc3_++;
         }
         this.doLayout();
      }
      
      public function doLayout() : void
      {
         var _loc1_:int = 1;
         if(this._nowArray == null || this._nowArray.length <= 0)
         {
            return;
         }
         this.clearAllLabel();
         var _loc2_:* = int(this._nowArray.length - 1);
         while(_loc2_ >= 0)
         {
            this._nowArray[_loc2_].y = int(_loc2_ / 6) * (this._nowArray[_loc2_].height + 4) + 15;
            this._nowArray[_loc2_].x = _loc2_ % 6 * (this._nowArray[_loc2_].width + 9) + 30;
            this._window["kinds"].addChild(this._nowArray[_loc2_]);
            _loc2_--;
         }
      }
      
      private function clearAllLabel() : void
      {
         var _loc1_:* = int(this._window["kinds"].numChildren - 1);
         while(_loc1_ >= 0)
         {
            if(this._window["kinds"].getChildAt(_loc1_) is IHandbookLabel)
            {
               (this._window["kinds"].getChildAt(_loc1_) as IHandbookLabel).destroy();
               this._window["kinds"].removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window,this.destroy);
      }
      
      private function onKindsClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "bt1")
         {
            this.show(ORG,false);
         }
         else if(param1.currentTarget.name == "bt2")
         {
            this.show(TOOL,false);
         }
      }
      
      private function onNumEvent(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "addnum")
         {
            this.addNum();
         }
         else if(param1.currentTarget.name == "decnum")
         {
            this.decNum();
         }
      }
      
      private function addNum() : void
      {
         if(this._nowPage >= this._maxPages)
         {
            return;
         }
         ++this._nowPage;
         this._window.kinds._num.text = this._nowPage + "/" + this._maxPages;
         this.showPage(this._nowPage);
      }
      
      private function decNum() : void
      {
         if(this._nowPage <= 1)
         {
            return;
         }
         --this._nowPage;
         this._window.kinds._num.text = this._nowPage + "/" + this._maxPages;
         this.showPage(this._nowPage);
      }
      
      private function setLoction() : void
      {
         this._window.visible = true;
         this._window.x = 370;
         this._window.y = 273;
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}

