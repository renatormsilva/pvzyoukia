package pvz.serverbattle.shop
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import manager.ToolManager;
   import pvz.serverbattle.entity.MedalGoods;
   import pvz.serverbattle.fport.MedalShopFPort;
   import pvz.serverbattle.tip.MedalGoodsTips;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class MedalShopWindow extends BaseWindow implements IDestroy
   {
      
      public static var _tips:MedalGoodsTips;
      
      private static const PAGESNUM:int = 8;
      
      private var _window:MovieClip = null;
      
      private var _allgoods:Array;
      
      private var _labels:Array;
      
      private var _maxPage:int;
      
      private var _curPage:int = 1;
      
      private var _shopFport:MedalShopFPort;
      
      private var _callback:Function;
      
      private var _type:int;
      
      public function MedalShopWindow(param1:Function = null, param2:int = 0, param3:int = 1)
      {
         this._type = param2;
         this._curPage = param3;
         this._callback = param1;
         super(UINameConst.UI_MEDAL_SHOP);
      }
      
      override protected function initWindowUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("medal_shopWindow");
         this._window = new _loc1_();
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
         this._window.visible = false;
         this.addEvent();
         this.initUI();
         this.initData();
      }
      
      private function initUI() : void
      {
         this._window["_decnum"].buttonMode = true;
         this._window["_addnum"].buttonMode = true;
         this._window["_decnum"].mouseEnabled = true;
         this._window["_addnum"].mouseEnabled = true;
         _tips = new MedalGoodsTips();
         this._window.addChild(_tips);
         _tips.visible = false;
         this.hideAllLebals();
      }
      
      private function initData() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this._shopFport = new MedalShopFPort(this);
         this._shopFport.requestSever(MedalShopFPort.INIT);
      }
      
      public function initShop(param1:Array) : void
      {
         this.updataMedalsNumber();
         PlantsVsZombies.showDataLoading(false);
         this._allgoods = this.order(param1);
         if(this._allgoods.length > 0)
         {
            this._maxPage = this._allgoods.length % PAGESNUM > 0 ? int(this._allgoods.length / PAGESNUM + 1) : int(this._allgoods.length / PAGESNUM);
         }
         else
         {
            this._maxPage = 1;
         }
         this.showGoodsByPage();
         this.show();
      }
      
      private function order(param1:Array) : Array
      {
         var _loc3_:MedalGoods = null;
         var _loc4_:* = 0;
         if(param1 == null || param1.length <= 1)
         {
            return param1;
         }
         var _loc2_:int = 1;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && (param1[_loc4_ - 1] as MedalGoods).getSeqId() > (_loc3_ as MedalGoods).getSeqId())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      private function buyBackFunction(param1:MedalGoods) : void
      {
         this.updataMedalsNumber();
         this.updateGoods(param1);
      }
      
      private function updataMedalsNumber() : void
      {
         var _loc1_:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(ToolManager.TOOL_SERVER_MEDAL);
         if(this._callback != null)
         {
            if(_loc1_)
            {
               this._callback(_loc1_.getNum());
            }
            else
            {
               this._callback(0);
            }
         }
         if(_loc1_)
         {
            this._window["medal_num_txt"].text = PlantsVsZombies.playerManager.getPlayer().getTool(ToolManager.TOOL_SERVER_MEDAL).getNum();
         }
         else
         {
            this._window["medal_num_txt"].text = 0;
         }
      }
      
      private function updateGoods(param1:MedalGoods) : void
      {
         if(this._allgoods == null || this._allgoods.length < 1)
         {
            return;
         }
         var _loc2_:* = int(this._allgoods.length - 1);
         while(_loc2_ >= 0)
         {
            if((this._allgoods[_loc2_] as MedalGoods).getId() == param1.getId())
            {
               (this._allgoods[_loc2_] as MedalGoods).setNum(param1.getNum());
               if((this._allgoods[_loc2_] as MedalGoods).getNum() == 0)
               {
                  this._allgoods.splice(_loc2_,1);
                  if(this._allgoods.length % PAGESNUM == 0 && this._allgoods.length > 0)
                  {
                     if(this._allgoods.length > 0)
                     {
                        this._maxPage = this._allgoods.length % PAGESNUM > 0 ? int(this._allgoods.length / PAGESNUM + 1) : int(this._allgoods.length / PAGESNUM);
                     }
                     else
                     {
                        this._maxPage = 1;
                     }
                     if(this._curPage > 1)
                     {
                        --this._curPage;
                     }
                  }
               }
            }
            _loc2_--;
         }
         this.showGoodsByPage();
      }
      
      private function addEvent() : void
      {
         this._window["close_btn"].addEventListener(MouseEvent.CLICK,this.onMedalShopClick);
         this._window["_decnum"].addEventListener(MouseEvent.CLICK,this.onMedalShopClick);
         this._window["_addnum"].addEventListener(MouseEvent.CLICK,this.onMedalShopClick);
      }
      
      private function onMedalShopClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "close_btn":
               this.hide();
               this._window["close_btn"].removeEventListener(MouseEvent.CLICK,this.onMedalShopClick);
               if(this._type == 1)
               {
                  if(this._callback != null)
                  {
                     this._callback();
                  }
               }
               break;
            case "_decnum":
               this.toPrePage();
               break;
            case "_addnum":
               this.toNextPage();
         }
      }
      
      private function toNextPage() : void
      {
         ++this._curPage;
         if(this._curPage > this._maxPage)
         {
            this._curPage = this._maxPage;
            return;
         }
         this.showGoodsByPage();
      }
      
      private function toPrePage() : void
      {
         --this._curPage;
         if(this._curPage <= 0)
         {
            this._curPage = 1;
            return;
         }
         this.showGoodsByPage();
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function hide() : void
      {
         onHiddenEffect(this._window,this.destroy);
      }
      
      private function show() : void
      {
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function showGoodsByPage() : void
      {
         this.hideAllLebals();
         this.updatePages();
         var _loc1_:Array = this._allgoods.slice((this._curPage - 1) * PAGESNUM,Math.min(this._curPage * PAGESNUM,this._allgoods.length));
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._labels[_loc2_].visible = true;
            (this._labels[_loc2_] as MedalGoodsLabel).setGoods(_loc1_[_loc2_] as MedalGoods);
            _loc2_++;
         }
      }
      
      private function updatePages() : void
      {
         this._window["_num"].text = this._curPage + "/" + this._maxPage;
      }
      
      private function buyMedalGoods(param1:MedalGoods) : void
      {
         new BuyMedalGoodsWindow(param1,this.buyBackFunction);
      }
      
      private function hideAllLebals() : void
      {
         var _loc1_:MedalGoodsLabel = null;
         var _loc3_:int = 0;
         FuncKit.clearAllChildrens(this._window["label_point"]);
         this._labels = [];
         var _loc2_:int = 0;
         while(_loc2_ < 2)
         {
            _loc3_ = 0;
            while(_loc3_ < PAGESNUM / 2)
            {
               _loc1_ = new MedalGoodsLabel(this.buyMedalGoods);
               this._window["label_point"].addChild(_loc1_);
               _loc1_.x = _loc3_ * 90;
               _loc1_.y = _loc2_ * 120;
               this._labels.push(_loc1_);
               _loc1_.visible = false;
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:MedalGoodsLabel = null;
         for each(_loc1_ in this._labels)
         {
            _loc1_.destory();
            this._window["label_point"].removeChild(_loc1_);
         }
         this._window["close_btn"].removeEventListener(MouseEvent.CLICK,this.onMedalShopClick);
         this._window["_decnum"].removeEventListener(MouseEvent.CLICK,this.onMedalShopClick);
         this._window["_addnum"].addEventListener(MouseEvent.CLICK,this.onMedalShopClick);
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

