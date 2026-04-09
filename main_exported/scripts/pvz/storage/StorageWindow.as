package pvz.storage
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.StorageLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.genius.GeniusControl;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import windows.ActionWindow;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class StorageWindow extends BaseWindow implements IDestroy, IConnection
   {
      
      public static const MAX:int = 12;
      
      public static const ORG_PAGE:int = 5;
      
      private static const RPC_RETURN:int = 1;
      
      public static const TYPE_ORG:int = 1;
      
      public static const TYPE_TOOL:int = 2;
      
      public static const TYPE_BOX:int = 3;
      
      public static const TYPE_BOOK:int = 4;
      
      public static const TYPE_MATERIAL:int = 5;
      
      public static const TYPE_JEWEL:int = 6;
      
      private var _taskFun:Function = null;
      
      private var _array:Array;
      
      private var _helpFun:Function;
      
      private var _list:Sprite;
      
      private var _nowPage:int = 1;
      
      private var _storageWindow:MovieClip;
      
      private var orgGridsGrade:int = 0;
      
      private var orgGridsMoney:int = 0;
      
      private var orgGridsNum:int = 0;
      
      private var orgs:Array;
      
      private var toolGridsGrade:int = 0;
      
      private var toolGridsMoney:int = 0;
      
      private var toolGridsNum:int = 0;
      
      private var tools:Array;
      
      private var type:int = 0;
      
      private var _objArray:Array;
      
      private var _orgLabels:Array = null;
      
      private var _toolLabels:Array = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function StorageWindow(param1:Function, param2:Function)
      {
         this._helpFun = param1;
         this._taskFun = param2;
         super(UINameConst.UI_STORAGE);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("storage");
         this._storageWindow = new _loc1_();
         this._storageWindow.visible = false;
         PlantsVsZombies._node.addChild(this._storageWindow);
         this._storageWindow["kinds"]["selected1"].visible = true;
         this._storageWindow["kinds"]["selected1"].gotoAndStop(1);
         this._storageWindow["kinds"]["selected2"].visible = false;
         this._storageWindow["kinds"]["selected2"].gotoAndStop(2);
         this._storageWindow["kinds"]["selected3"].visible = false;
         this._storageWindow["kinds"]["selected3"].gotoAndStop(3);
         this._storageWindow["kinds"]["selected4"].visible = false;
         this._storageWindow["kinds"]["selected4"].gotoAndStop(4);
         this._storageWindow["kinds"]["selected5"].visible = false;
         this._storageWindow["kinds"]["selected5"].gotoAndStop(5);
         this._storageWindow["_to_genius"]["_label"].mouseEnabled = false;
         if(this.playerManager.getPlayer().getGrade() < PlantsVsZombies.GENIUS_OPEN_LEVEL)
         {
            FuncKit.setNoColor(this._storageWindow["_to_genius"]);
         }
         else
         {
            FuncKit.clearNoColorState(this._storageWindow["_to_genius"]);
         }
         this.maobian();
         this.initBtEvent();
         this.show();
      }
      
      private function maobian() : void
      {
         TextFilter.MiaoBian(this._storageWindow["_to_genius"]["_label"],1842204,0.5,4,4,8);
      }
      
      override public function destroy() : void
      {
         this.clearArray();
         if(this._list != null)
         {
            this._storageWindow["kinds"].removeChild(this._list);
         }
         FuncKit.clearAllChildrens(this._list);
         this._list = null;
         this._orgLabels = null;
         this._toolLabels = null;
         this._objArray = null;
         this.removeBtEvent();
         if(this._taskFun != null)
         {
            this._taskFun();
         }
         PlantsVsZombies._node.removeChild(this._storageWindow);
      }
      
      private function doLayout() : void
      {
         this.clearArray();
         if(this._objArray == null)
         {
            this._objArray = [];
         }
         var _loc1_:int = 1;
         if(this._list != null)
         {
            FuncKit.clearAllChildrens(this._list);
            this._storageWindow["kinds"].removeChild(this._list);
         }
         else
         {
            this._list = new Sprite();
         }
         var _loc2_:* = int(MAX - 1);
         while(_loc2_ >= 0)
         {
            this._objArray[_loc2_] = new StorageLabel();
            this._objArray[_loc2_].y = int(_loc2_ / 6) * (this._objArray[_loc2_].height + 4) + 15;
            this._objArray[_loc2_].x = _loc2_ % 6 * (this._objArray[_loc2_].width + 9) + 30;
            this._objArray[_loc2_].addEventListener(StorageLabelEvent.STORAGELABEL_CLICK,this.onShowSellClick,false,0,true);
            this._list.addChild(this._objArray[_loc2_]);
            _loc2_--;
         }
         this._storageWindow["kinds"].addChild(this._list);
      }
      
      private function clearArray() : void
      {
         if(this._objArray == null)
         {
            return;
         }
         var _loc1_:* = int(MAX - 1);
         while(_loc1_ >= 0)
         {
            this._objArray[_loc1_].removeEventListener(StorageLabelEvent.STORAGELABEL_CLICK,this.onShowSellClick);
            this._objArray[_loc1_].clearAllEvent();
            this._objArray.pop();
            _loc1_--;
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1 == RPC_RETURN)
         {
            PlantsVsZombies.showDataLoading(false);
            _loc3_ = param2 as Array;
            if(_loc3_ == null || _loc3_.length < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window092"));
               return;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               this.playerManager.getOrganism(this.playerManager.getPlayer(),_loc3_[_loc4_]).setGardenId(0);
               _loc4_++;
            }
            this.update(TYPE_ORG,false);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window093"));
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function update(param1:int = 1, param2:Boolean = true, param3:Boolean = false) : void
      {
         var updateInfo:Function = null;
         var i:int = param1;
         var isupdate:Boolean = param2;
         var isFirst:Boolean = param3;
         updateInfo = function():void
         {
            orgGridsGrade = playerManager.getPlayer().getStorageOrgGrade();
            orgGridsMoney = playerManager.getPlayer().getStorageOrgMoney();
            orgGridsNum = playerManager.getPlayer().getStorageOrgNum();
            toolGridsGrade = playerManager.getPlayer().getStorageToolGrade();
            toolGridsMoney = playerManager.getPlayer().getStorageToolMoney();
            toolGridsNum = GlobalConstants.STORAGE_TOOL_PAGE * MAX;
            orgs = orderOrgsByGrade(playerManager.getPlayer().organisms);
            tools = orderToolById(playerManager.getPlayer().tools);
            showPage(_nowPage,isFirst);
         };
         this.setKindsSelectedFalse();
         if(i != this.type || isupdate)
         {
            this._nowPage = 1;
         }
         this._storageWindow["kinds"]["selected" + i].visible = true;
         this._storageWindow["kinds"]["selected" + i].gotoAndStop(i);
         this.type = i;
         PlantsVsZombies.showDataLoading(true);
         if(isupdate)
         {
            PlantsVsZombies.storageInfo(updateInfo);
         }
         else
         {
            updateInfo();
         }
      }
      
      private function addNum() : void
      {
         if(this._nowPage >= this.getPageNum())
         {
            return;
         }
         ++this._nowPage;
         if(this.type == TYPE_ORG)
         {
            this._storageWindow.kinds._num.text = this._nowPage + "/" + ORG_PAGE;
         }
         else
         {
            this._storageWindow.kinds._num.text = this._nowPage + "/" + GlobalConstants.STORAGE_TOOL_PAGE;
         }
         this.showPage(this._nowPage);
      }
      
      private function decNum() : void
      {
         if(this._nowPage <= 1)
         {
            return;
         }
         --this._nowPage;
         if(this.type == TYPE_ORG)
         {
            this._storageWindow.kinds._num.text = this._nowPage + "/" + ORG_PAGE;
         }
         else
         {
            this._storageWindow.kinds._num.text = this._nowPage + "/" + GlobalConstants.STORAGE_TOOL_PAGE;
         }
         this.showPage(this._nowPage);
      }
      
      private function doingUpdate(param1:int, param2:Boolean) : void
      {
         var _loc3_:Tool = this.playerManager.getPlayer().getTool(param1);
         if(_loc3_ == null || _loc3_.getNum() == 0)
         {
            return;
         }
         var _loc4_:SellGoodsWindow = new SellGoodsWindow(this.upStoragePanelData,this._array);
         _loc4_.update(_loc3_);
         if(param2)
         {
            _loc4_.show();
         }
      }
      
      private function getArray() : Array
      {
         if(this.type == TYPE_ORG)
         {
            return this.orderOrgsByGrade(this.orgs);
         }
         if(this.type == TYPE_TOOL)
         {
            return this.orderToolById(this.tools);
         }
         if(this.type == TYPE_BOX)
         {
            return this.orderToolById(ToolManager.checkBoxTools(this.tools));
         }
         if(this.type == TYPE_BOOK)
         {
            return this.orderToolById(ToolManager.checkpointBookTools(this.tools));
         }
         if(this.type == TYPE_MATERIAL)
         {
            return this.orderToolById(ToolManager.checkMaterialTools(this.tools));
         }
         if(this.type == TYPE_JEWEL)
         {
            return this.orderToolById(ToolManager.getAllJewelTools(this.tools));
         }
         return null;
      }
      
      private function getGridsNum() : int
      {
         if(this.type == TYPE_ORG)
         {
            return this.orgGridsNum;
         }
         if(this.type == TYPE_TOOL || this.type == TYPE_BOX || this.type == TYPE_BOOK || this.type == TYPE_MATERIAL || this.type == TYPE_JEWEL)
         {
            return this.toolGridsNum;
         }
         return 0;
      }
      
      private function getPageNum() : int
      {
         if(this.type == TYPE_ORG)
         {
            return ORG_PAGE;
         }
         if(this.type == TYPE_TOOL || this.type == TYPE_BOX || this.type == TYPE_BOOK || this.type == TYPE_MATERIAL || this.type == TYPE_JEWEL)
         {
            return GlobalConstants.STORAGE_TOOL_PAGE;
         }
         return 0;
      }
      
      private function onShowSellClick(param1:StorageLabelEvent) : void
      {
         var callback:Function;
         var _sellGoodsWindow:SellGoodsWindow = null;
         var orgWindow:OrganismWindow = null;
         var e:StorageLabelEvent = param1;
         if(e.obj is Tool)
         {
            callback = function():void
            {
               onHiddenEffect(_storageWindow,destroy);
            };
            _sellGoodsWindow = new SellGoodsWindow(this.upStoragePanelData,this._array);
            _sellGoodsWindow.update(e.obj as Tool);
            _sellGoodsWindow.show(callback);
         }
         else if(e.obj is Organism)
         {
            orgWindow = new OrganismWindow();
            orgWindow.update(e.obj as Organism);
            orgWindow.setUpdateFun(this.upStoragePanelData);
            orgWindow.show();
         }
      }
      
      private function initBtEvent() : void
      {
         this._storageWindow["kinds"]["bt1"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt2"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt3"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt4"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt5"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt6"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["addnum"].addEventListener(MouseEvent.CLICK,this.onNumEvent);
         this._storageWindow["kinds"]["decnum"].addEventListener(MouseEvent.CLICK,this.onNumEvent);
         this._storageWindow["cancel"].addEventListener(MouseEvent.CLICK,this.onCancel);
         this._storageWindow["_bt_return"].addEventListener(MouseEvent.CLICK,this.onReturn);
         this._storageWindow["_to_genius"].addEventListener(MouseEvent.CLICK,this.toGenius);
      }
      
      private function toGenius(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.playerManager.getPlayer().getAllOrganism().length == 0)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("geniusp001"));
            return;
         }
         if(this.playerManager.getPlayer().getGrade() < PlantsVsZombies.GENIUS_OPEN_LEVEL)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("error001"));
            return;
         }
         new GeniusControl((this.playerManager.getPlayer().getAllOrganism()[0] as Organism).getId());
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         onHiddenEffect(this._storageWindow,this.destroy);
         if(GlobalConstants.NEW_PLAYER)
         {
            if(this._helpFun != null)
            {
               this._helpFun();
            }
         }
      }
      
      private function onKindsClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._nowPage = 1;
         if(param1.currentTarget.name == "bt1")
         {
            this.update(TYPE_ORG,false);
         }
         else if(param1.currentTarget.name == "bt2")
         {
            this.update(TYPE_TOOL,false);
         }
         else if(param1.currentTarget.name == "bt3")
         {
            this.update(TYPE_BOX,false);
         }
         else if(param1.currentTarget.name == "bt4")
         {
            this.update(TYPE_BOOK,false);
         }
         else if(param1.currentTarget.name == "bt5")
         {
            this.update(TYPE_MATERIAL,false);
         }
         else if(param1.currentTarget.name == "bt6")
         {
            this.update(TYPE_JEWEL,false);
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
      
      private function onReturn(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:ActionWindow = new ActionWindow();
         _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window091"),LangManager.getInstance().getLanguage("window090"),this.returnOrg,true);
      }
      
      private function open(param1:String) : void
      {
         if(param1 == "organism")
         {
            this.orgGridsNum = this.playerManager.getPlayer().getStorageOrgNum();
         }
         else if(param1 == "tool")
         {
            this.toolGridsNum = this.playerManager.getPlayer().getStorageToolNum();
         }
         this.updateArray();
      }
      
      private function orderOrgsByGrade(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getGrade() < _loc3_.getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function orderToolById(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as Tool).getOrderId() > _loc3_.getOrderId())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function removeBtEvent() : void
      {
         this._storageWindow["kinds"]["bt1"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt2"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt3"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt4"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt5"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["bt6"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._storageWindow["kinds"]["addnum"].removeEventListener(MouseEvent.CLICK,this.onNumEvent);
         this._storageWindow["kinds"]["decnum"].removeEventListener(MouseEvent.CLICK,this.onNumEvent);
         this._storageWindow["cancel"].removeEventListener(MouseEvent.CLICK,this.onCancel);
         this._storageWindow["_bt_return"].removeEventListener(MouseEvent.CLICK,this.onReturn);
      }
      
      private function returnOrg() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STORAGE_RETURN,RPC_RETURN);
      }
      
      private function upStoragePanelData(param1:int = 0, param2:int = 0, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:int = 0;
         if(param1 == StorageWindow.TYPE_ORG)
         {
            this.orgs = this.orderOrgsByGrade(this.playerManager.getPlayer().organisms);
            _loc5_ = 0;
            while(_loc5_ < this.orgs.length)
            {
               if((this.orgs[_loc5_] as Organism).getId() == param2)
               {
                  this.orgs.splice(_loc5_,1);
               }
               _loc5_++;
            }
            this.updateArray();
            this.showPage(this._nowPage);
         }
         else if(param1 == StorageWindow.TYPE_TOOL || param1 == StorageWindow.TYPE_MATERIAL || param1 == StorageWindow.TYPE_BOX || param1 == StorageWindow.TYPE_BOOK || param1 == StorageWindow.TYPE_JEWEL)
         {
            this.tools = this.orderToolById(this.playerManager.getPlayer().tools);
            this.doingUpdate(param2,param4);
            this.updateArray();
            this.showPage(this._nowPage);
         }
         else
         {
            this.orgs = this.orderOrgsByGrade(this.playerManager.getPlayer().organisms);
            this.tools = this.orderToolById(this.playerManager.getPlayer().tools);
            this.updateArray();
         }
      }
      
      private function setKindsSelectedFalse() : void
      {
         this._storageWindow["kinds"]["selected1"].visible = false;
         this._storageWindow["kinds"]["selected2"].visible = false;
         this._storageWindow["kinds"]["selected3"].visible = false;
         this._storageWindow["kinds"]["selected4"].visible = false;
         this._storageWindow["kinds"]["selected5"].visible = false;
         this._storageWindow["kinds"]["selected6"].visible = false;
      }
      
      private function setLoction() : void
      {
         this._storageWindow.visible = true;
         this._storageWindow.x = 380 + 17;
         this._storageWindow.y = 265 + 13;
         PlantsVsZombies._node.setChildIndex(this._storageWindow,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function show() : void
      {
         this.update(TYPE_ORG,true,true);
      }
      
      private function showPage(param1:int = 1, param2:Boolean = false) : void
      {
         if(param2)
         {
            super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
            this.setKindsSelectedFalse();
            this._storageWindow["kinds"]["selected1"].visible = true;
            this._storageWindow["kinds"]["selected1"].gotoAndStop(1);
            this.setLoction();
            onShowEffect(this._storageWindow);
         }
         this._nowPage = param1;
         if(this.type == TYPE_ORG)
         {
            this._storageWindow.kinds._num.text = this._nowPage + "/" + ORG_PAGE;
         }
         else
         {
            this._storageWindow.kinds._num.text = this._nowPage + "/" + GlobalConstants.STORAGE_TOOL_PAGE;
         }
         this.updateArray();
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function updateArray() : void
      {
         this._array = this.getArray();
         var _loc1_:int = this.getGridsNum();
         var _loc2_:int = (this._nowPage - 1) * MAX;
         this.doLayout();
         var _loc3_:int = 0;
         while(_loc3_ < this._objArray.length)
         {
            if(_loc2_ + _loc3_ < _loc1_)
            {
               if(_loc2_ + _loc3_ < this._array.length)
               {
                  (this._objArray[_loc3_] as StorageLabel).update(this._array[_loc2_ + _loc3_],this.type,this.type,this.open);
               }
               else
               {
                  (this._objArray[_loc3_] as StorageLabel).update(null,StorageLabel.NULL,this.type,this.open);
               }
            }
            else
            {
               (this._objArray[_loc3_] as StorageLabel).update(null,StorageLabel.LOCKED,this.type,this.open);
            }
            _loc3_++;
         }
      }
   }
}

