package pvz.genius.jewelSystem
{
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import manager.ToolManager;
   import pvz.genius.jewelSystem.componets.DropDownListPanel;
   import pvz.genius.jewelSystem.componets.JewelStorageLabel;
   import pvz.genius.jewelSystem.event.DropDownSelectEvent;
   import pvz.genius.jewelSystem.event.SelectJewelEvent;
   import pvz.genius.jewelSystem.rpc.JewelSystem_rpc;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.FuncKit;
   
   public class JewelStroagePanel extends BasePanel
   {
      
      private const PAGENUM:int = 9;
      
      private var _initCallback:Function;
      
      private var _dropDownList:DropDownListPanel;
      
      private var _tempJewels:Array;
      
      private var _dataRpc:JewelSystem_rpc;
      
      private var _maxPage:int;
      
      private var _curPage:int;
      
      private var _labels:Array;
      
      private var _type:int;
      
      public function JewelStroagePanel()
      {
         super("jewel.JewelStroagePanel");
         this._labels = [];
         this._curPage = 1;
         this._dropDownList = new DropDownListPanel();
         _ui._listnode.addChild(this._dropDownList);
         this._dropDownList.visible = false;
         addChild(this._dropDownList);
         this.addEvent();
         _ui["_DropDownBtn"].mouseChildren = true;
         _ui["_DropDownBtn"]._label.mouseEnabled = false;
      }
      
      public function initUI(param1:int = 0) : void
      {
         this._type = param1;
         this._dropDownList.setFaultAllNode(param1);
         _ui["_DropDownBtn"]._label.text = GeniusSystemConst.GetLabelByType(param1);
         this._curPage = 1;
         this.updateStoage();
      }
      
      public function updateStoage() : void
      {
         var _loc1_:Array = ToolManager.getJewelTools(PlantsVsZombies.playerManager.getPlayer().getAllTools());
         this._dataRpc = new JewelSystem_rpc(_loc1_);
         this._tempJewels = this._dataRpc.getSpecilJewelsByType(this._type);
         if(this._tempJewels.length > 0)
         {
            this._maxPage = this._tempJewels.length % this.PAGENUM > 0 ? int(this._tempJewels.length / this.PAGENUM + 1) : int(this._tempJewels.length / this.PAGENUM);
         }
         this.showCurpageJewels();
      }
      
      private function addEvent() : void
      {
         this._dropDownList.addEventListener(DropDownSelectEvent.SELECT,this.onSelectDropDown);
         this._dropDownList.addEventListener(MouseEvent.MOUSE_UP,this.onCloseDropDown);
         _ui._node.addEventListener(SelectJewelEvent.SELECT_JEWEL,this.onSelectHandler);
         _ui["_pre_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         _ui["_next_btn"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         _ui["_DropDownBtn"].addEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
      }
      
      private function onSelectHandler(param1:SelectJewelEvent) : void
      {
         this.setAllLevelMaskVisibleFalse();
         (param1.target as JewelStorageLabel).setMaskVisible(true);
      }
      
      private function onCloseDropDown(param1:MouseEvent) : void
      {
         this.dropDownListVisible(false);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "_pre_btn":
               this.toPrePage();
               break;
            case "_next_btn":
               this.toNextPage();
               break;
            case "_DropDownBtn":
               this.dropDownListVisible(true);
         }
      }
      
      private function dropDownListVisible(param1:Boolean) : void
      {
         this._dropDownList.visible = param1;
      }
      
      private function toNextPage() : void
      {
         if(this._curPage >= this._maxPage)
         {
            return;
         }
         ++this._curPage;
         this.showCurpageJewels();
      }
      
      private function toPrePage() : void
      {
         if(this._curPage <= 1)
         {
            return;
         }
         --this._curPage;
         this.showCurpageJewels();
      }
      
      private function onSelectDropDown(param1:DropDownSelectEvent) : void
      {
         this.dropDownListVisible(false);
         _ui["_DropDownBtn"]._label.text = GeniusSystemConst.GetLabelByType(param1._stype);
         this._type = param1._stype;
         this._tempJewels = this._dataRpc.getSpecilJewelsByType(param1._stype);
         if(this._tempJewels.length > 0)
         {
            this._maxPage = this._tempJewels.length % this.PAGENUM > 0 ? int(this._tempJewels.length / this.PAGENUM + 1) : int(this._tempJewels.length / this.PAGENUM);
         }
         this._curPage = 1;
         this.showCurpageJewels();
      }
      
      private function showCurpageJewels() : void
      {
         var _loc2_:JewelStorageLabel = null;
         var _loc3_:int = 0;
         this.updataPage();
         this.clearAllLabels();
         var _loc1_:Array = this._tempJewels.slice((this._curPage - 1) * this.PAGENUM,Math.min(this._curPage * this.PAGENUM,this._tempJewels.length));
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = new JewelStorageLabel();
            _loc2_.setInfo(_loc1_[_loc3_],_loc3_);
            _ui._node.addChild(_loc2_);
            _loc2_.x = _loc3_ % 3 * (_loc2_.width + 10);
            _loc2_.y = Math.floor(_loc3_ / 3) * (_loc2_.height + 5);
            this._labels.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function setAllLevelMaskVisibleFalse() : void
      {
         var _loc1_:JewelStorageLabel = null;
         for each(_loc1_ in this._labels)
         {
            _loc1_.setMaskVisible(false);
         }
      }
      
      private function clearAllLabels() : void
      {
         var _loc1_:JewelStorageLabel = null;
         for each(_loc1_ in this._labels)
         {
            _loc1_.destroy();
         }
         FuncKit.clearAllChildrens(_ui._node);
         this._labels = [];
      }
      
      private function updataPage() : void
      {
         _ui._page_txt.text = this._curPage + "/" + this._maxPage;
      }
      
      override public function destroy() : void
      {
         this.clearAllLabels();
         this._dropDownList.destroy();
         this._dropDownList.addEventListener(DropDownSelectEvent.SELECT,this.onSelectDropDown);
         this._dropDownList.removeEventListener(MouseEvent.MOUSE_UP,this.onCloseDropDown);
         _ui._node.removeEventListener(SelectJewelEvent.SELECT_JEWEL,this.onSelectHandler);
         _ui["_pre_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         _ui["_next_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
         _ui["_DropDownBtn"].removeEventListener(MouseEvent.MOUSE_UP,this.onClickHandler);
      }
   }
}

