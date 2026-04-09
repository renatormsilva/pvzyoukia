package pvz.serverbattle.shop
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.serverbattle.entity.MedalGoods;
   import pvz.serverbattle.fport.MedalShopFPort;
   import windows.ActionWindow;
   import zlib.utils.DomainAccess;
   
   public class BuyMedalGoodsWindow extends BaseWindow
   {
      
      private var _window:MovieClip = null;
      
      private var _goods:MedalGoods;
      
      private var _fport:MedalShopFPort;
      
      private var _buyNum:int = 1;
      
      private var _callback:Function;
      
      public function BuyMedalGoodsWindow(param1:MedalGoods, param2:Function)
      {
         super();
         this._callback = param2;
         var _loc3_:Class = DomainAccess.getClass("buyMedalGoodsWindow");
         this._window = new _loc3_();
         this._window.visible = false;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
         this._fport = new MedalShopFPort(this);
         this._goods = param1;
         this.addEvent();
         this.show();
      }
      
      private function addEvent() : void
      {
         this._window["cancel"].addEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["buy"].addEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["decnum"].addEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["addnum"].addEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["_num"].addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._window["_num"].addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function onWindowClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "buy":
               this.buyGoods();
               break;
            case "cancel":
               this.hide();
               break;
            case "decnum":
               this.toDecBuyNum();
               break;
            case "addnum":
               this.toAddBuyNum();
         }
      }
      
      private function show() : void
      {
         this.updateBuyNum();
         this.showInfo();
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         var _loc2_:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(ToolManager.TOOL_SERVER_MEDAL);
         if(this._window["_num"].text == "")
         {
            this._buyNum = 1;
         }
         else
         {
            this._buyNum = int(this._window["_num"].text);
            if(this._buyNum * this._goods.getCost() > _loc2_.getNum())
            {
               this._buyNum = Math.floor(_loc2_.getNum() / this._goods.getCost());
            }
         }
         if(this._buyNum > this._goods.getNum())
         {
            this._buyNum = this._goods.getNum();
         }
         else if(this._buyNum <= 1)
         {
            this._buyNum = 1;
         }
         this._window["_num"].text = this._buyNum;
      }
      
      private function toDecBuyNum() : void
      {
         if(this._buyNum <= 1)
         {
            return;
         }
         --this._buyNum;
         this.updateBuyNum();
      }
      
      private function toAddBuyNum() : void
      {
         var _loc1_:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(ToolManager.TOOL_SERVER_MEDAL);
         if(_loc1_ == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle008"));
            return;
         }
         if(this._buyNum >= this._goods.getNum() || (this._buyNum + 1) * this._goods.getCost() > _loc1_.getNum())
         {
            return;
         }
         ++this._buyNum;
         this.updateBuyNum();
      }
      
      private function showInfo() : void
      {
         if(!this._goods)
         {
            return;
         }
         if(this._goods.getType() == Icon.ORGANISM)
         {
            Icon.setUrlIcon(this._window["pic"],this._goods.getPicid(),Icon.ORGANISM_1);
         }
         else if(this._goods.getType() == Icon.TOOL)
         {
            Icon.setUrlIcon(this._window["pic"],this._goods.getPicid(),Icon.TOOL_1);
         }
         this._window["_number"].text = "NO." + this._goods.getOrderId();
         this._window["_name"].text = this._goods.getName();
         this._window["_type"].text = this._goods.getDesType();
         this._window["_price"].text = this._goods.getCost() + "功勋";
         this._window["_use_result"].text = this._goods.getUse_result();
         this._window["_expl"].text = this._goods.getExpl();
         this._window["_use_condition"].text = this._goods.getUse_condition();
      }
      
      private function updateBuyNum() : void
      {
         this._window["_num"].text = this._buyNum;
      }
      
      private function hide() : void
      {
         onHiddenEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function buyGoods() : void
      {
         var actionW:ActionWindow;
         var buy:Function = null;
         buy = function():void
         {
            hide();
            PlantsVsZombies.showDataLoading(true);
            _fport.requestSever(MedalShopFPort.BUY,_goods.getId(),_buyNum);
         };
         var tool:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(ToolManager.TOOL_SERVER_MEDAL);
         if(tool == null)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle008"));
            return;
         }
         if(this._buyNum * this._goods.getCost() > tool.getNum())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle008"));
            return;
         }
         actionW = new ActionWindow();
         actionW.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window068"),LangManager.getInstance().getLanguage("severBattle006",this._buyNum * this._goods.getCost(),this._buyNum,this._goods.getName()),buy,true);
      }
      
      private function isBuy() : Boolean
      {
         if(this._goods.getType() == Icon.TOOL)
         {
            if(PlantsVsZombies.playerManager.getPlayer().getTool(this._goods.getOrderId()) == null && PlantsVsZombies.playerManager.getPlayer().getStorageFreeTools() < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window069"));
               return false;
            }
         }
         else if(this._goods.getType() == Icon.ORGANISM)
         {
            if(PlantsVsZombies.playerManager.getPlayer().getStorageOrgNum() <= PlantsVsZombies.playerManager.getPlayer().organisms.length)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window070"));
               return false;
            }
            if(PlantsVsZombies.playerManager.getPlayer().getStorageOrgNum() < this._buyNum + PlantsVsZombies.playerManager.getPlayer().organisms.length)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window071"));
               return false;
            }
         }
         return true;
      }
      
      public function buySucess() : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc1_:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(ToolManager.TOOL_SERVER_MEDAL);
         _loc1_.setNum(_loc1_.getNum() - this._buyNum * this._goods.getCost());
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle009",this._buyNum,this._goods.getName()));
         var _loc2_:Tool = PlantsVsZombies.playerManager.getPlayer().getTool(this._goods.getOrderId());
         if(_loc2_)
         {
            _loc2_.setNum(_loc2_.getNum() + this._buyNum);
         }
         else if(!_loc2_)
         {
            PlantsVsZombies.playerManager.getPlayer().updateTool(this._goods.getOrderId(),this._buyNum);
         }
         this._goods.setNum(this._goods.getNum() - this._buyNum);
         this._callback(this._goods);
         this.destory();
      }
      
      private function destory() : void
      {
         this._window["cancel"].removeEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["buy"].removeEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["decnum"].removeEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["addnum"].removeEventListener(MouseEvent.MOUSE_UP,this.onWindowClick);
         this._window["_num"].removeEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._window["_num"].removeEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
         this._fport = null;
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

