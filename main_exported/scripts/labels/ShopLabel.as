package labels
{
   import entity.Goods;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.shop.BuyGoodsWindow;
   import pvz.shop.ShopWindow;
   import tip.ToolsTip;
   import utils.Singleton;
   import xmlReader.firstPage.XmlShop;
   
   public class ShopLabel
   {
      
      public var _label:MovieClip;
      
      private var _back:Function;
      
      private var _upDateFun:Function;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var tips:ToolsTip;
      
      public function ShopLabel(param1:Object, param2:MovieClip, param3:Function, param4:Function = null)
      {
         super();
         this._upDateFun = param3;
         this._back = param4;
         this._label = param2;
         this.selectedEvent();
         this._label.buttonMode = true;
         this._label.gotoAndStop(1);
         this.show();
         param1.addChild(this._label);
      }
      
      public function addPic(param1:int, param2:String) : void
      {
         if(param2 == XmlShop.ORG)
         {
            Icon.setUrlIcon(this._label["pic"],param1,Icon.ORGANISM_1);
         }
         else if(param2 == XmlShop.TOOL)
         {
            Icon.setUrlIcon(this._label["pic"],param1,Icon.TOOL_1);
         }
      }
      
      public function getPositionX() : int
      {
         if(this._label.x > 240)
         {
            return this._label.parent.x + 180;
         }
         return this._label.parent.x + 380;
      }
      
      public function getPositionY() : int
      {
         return this._label.parent.y + 130;
      }
      
      public function init(param1:Goods, param2:int, param3:Function = null) : void
      {
         var onClick:Function = null;
         var onOver:Function = null;
         var goods:Goods = param1;
         var _shopType:int = param2;
         var vipShopBuyFunc:Function = param3;
         onClick = function(param1:MouseEvent):void
         {
            if(_shopType == ShopWindow.SHOP_VIP_SHOP)
            {
               if(playerManager.isVip(playerManager.getPlayer().getVipTime()) == null)
               {
                  vipShopBuyFunc();
                  return;
               }
            }
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            var _loc2_:BuyGoodsWindow = new BuyGoodsWindow();
            _loc2_.init(goods,_upDateFun,_shopType,_back);
            _loc2_.show();
         };
         onOver = function(param1:MouseEvent):void
         {
            _label.gotoAndStop(2);
            tips.setTooltipText(_label,goods.getName(),goods.getUseCondition(),goods.getUseResult());
            tips.setLoction(getPositionX(),getPositionY());
         };
         this.tips = new ToolsTip();
         this.addPic(goods.getPicId(),goods.getPicType());
         this._label["info"].text = goods.getName();
         if(_shopType == ShopWindow.SHOP_EXCHANGE)
         {
            this._label["price"].text = goods.getPurchasePrice() + LangManager.getInstance().getLanguage("node012");
         }
         else if(_shopType == ShopWindow.SHOP_RMB || _shopType == ShopWindow.SHOP_HOT_SHOP)
         {
            this._label["price"].text = goods.getPurchasePrice() + LangManager.getInstance().getLanguage("node013");
         }
         else if(_shopType == ShopWindow.SHOP_VIP_SHOP)
         {
            this._label["price"].htmlText = "<font color=\'#ff0000\' size=\'15\'>" + goods.getPurchasePrice() + LangManager.getInstance().getLanguage("node013") + "</font>";
         }
         else if(_shopType == ShopWindow.SHOP_HONOUR)
         {
            this._label["price"].text = goods.getPurchasePrice() + LangManager.getInstance().getLanguage("node019");
         }
         else
         {
            this._label["price"].text = goods.getPurchasePrice() + "G";
         }
         this._label.addEventListener(MouseEvent.CLICK,onClick);
         this._label.addEventListener(MouseEvent.ROLL_OVER,onOver);
         this.show(true);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         var _loc3_:int = param1 % param2;
         var _loc4_:int = param1 / param2;
         if(param2 == 2)
         {
            this._label.x = (this._label.width + param2) * _loc3_;
            this._label.y = (this._label.height + param2) * _loc4_;
         }
         else if(param2 == 4)
         {
            this._label.x = (this._label.width + 7) * _loc3_;
            this._label.y = (this._label.height - 3) * _loc4_;
         }
      }
      
      public function setToolDiscount(param1:int) : void
      {
         if(param1 != 0)
         {
            this._label["discounts"].visible = true;
            this._label["discounts"]["txt"].text = param1 + LangManager.getInstance().getLanguage("window162");
         }
         else
         {
            this._label["discounts"].visible = false;
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._label.gotoAndStop(1);
      }
      
      private function selectedEvent() : void
      {
         this._label.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function show(param1:Boolean = false) : void
      {
         this._label.visible = param1;
      }
   }
}

