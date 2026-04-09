package pvz.shop
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Goods;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import utils.Singleton;
   import windows.ActionWindow;
   import xmlReader.firstPage.XmlShop;
   import zlib.utils.DomainAccess;
   
   public class BuyGoodsWindow extends BaseWindow implements IConnection
   {
      
      internal var _back:Function;
      
      internal var _back2:Function;
      
      internal var _goodsWindow:MovieClip;
      
      internal var _id:int = 0;
      
      internal var _maxNum:int = 0;
      
      internal var _name:String = "";
      
      internal var _nowNum:int = 0;
      
      internal var _picType:String = "";
      
      internal var _price:int;
      
      private var _shopType:int = 0;
      
      internal var _goods:Goods;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _isCost:Boolean = false;
      
      public function BuyGoodsWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("goodsWindow");
         this._goodsWindow = new _loc1_();
         this._goodsWindow.visible = false;
         this._goodsWindow["sell"].visible = false;
         this._goodsWindow["doing"].visible = false;
         this._goodsWindow["_left"].visible = false;
         this._goodsWindow["_right"].visible = false;
         this._goodsWindow["left_label"].visible = false;
         this._goodsWindow["left_num_txt"].visible = false;
         this._goodsWindow["_updateGenius"].visible = false;
         this.addEvent();
         PlantsVsZombies._node.addChild(this._goodsWindow);
      }
      
      public function addPic(param1:int, param2:String) : void
      {
         if(param2 == XmlShop.ORG)
         {
            Icon.setUrlIcon(this._goodsWindow["pic"],param1,Icon.ORGANISM_1);
         }
         else if(param2 == XmlShop.TOOL)
         {
            Icon.setUrlIcon(this._goodsWindow["pic"],param1,Icon.TOOL_1);
         }
      }
      
      public function hidden() : void
      {
         onHiddenEffect(this._goodsWindow);
      }
      
      private function getMaxNum(param1:Goods, param2:Number) : int
      {
         if(param1 == null)
         {
            return 1;
         }
         var _loc3_:int = param1.getPurchasePrice();
         var _loc4_:Number = Number(param2 / _loc3_);
         if(_loc4_ < 1)
         {
            return 1;
         }
         if(_loc4_ > param1.getMaxNum())
         {
            return param1.getMaxNum();
         }
         return int(_loc4_);
      }
      
      public function init(param1:Goods, param2:Function, param3:int, param4:Function, param5:Boolean = true) : void
      {
         var _loc6_:Tool = null;
         this._back = param2;
         this._back2 = param4;
         this._picType = param1.getPicType();
         this._shopType = param3;
         this._isCost = param5;
         this.addPic(param1.getPicId(),this._picType);
         if(param3 == ShopWindow.SHOP_EXCHANGE)
         {
            this._nowNum = 1;
            _loc6_ = this.playerManager.getPlayer().getTool(ToolManager.CHANGE);
            if(_loc6_ == null)
            {
               this._maxNum = this.getMaxNum(param1,0);
            }
            else
            {
               this._maxNum = this.getMaxNum(param1,_loc6_.getNum());
            }
            this._goodsWindow["_price"].text = param1.getPurchasePrice() * this._nowNum + LangManager.getInstance().getLanguage("node012");
         }
         else if(param3 == ShopWindow.SHOP_RMB || param3 == ShopWindow.SHOP_HOT_SHOP || param3 == ShopWindow.SHOP_VIP_SHOP)
         {
            this._nowNum = 1;
            this._maxNum = this.getMaxNum(param1,this.playerManager.getPlayer().getRMB());
            this._goodsWindow["_price"].text = param1.getPurchasePrice() * this._nowNum + LangManager.getInstance().getLanguage("node013");
         }
         else if(param3 == ShopWindow.SHOP_HONOUR)
         {
            this._nowNum = 1;
            this._maxNum = this.getMaxNum(param1,this.playerManager.getPlayer().getHonour());
            this._goodsWindow["_price"].text = param1.getPurchasePrice() * this._nowNum + LangManager.getInstance().getLanguage("node019");
         }
         else
         {
            this._maxNum = this.getMaxNum(param1,this.playerManager.getPlayer().getMoney());
            this._nowNum = 1;
            this._goodsWindow["_price"].text = param1.getPurchasePrice() * this._nowNum + "G";
         }
         this._goods = param1;
         this._id = param1.getGoodsId();
         this._name = param1.getName();
         this._price = param1.getPurchasePrice();
         this._goodsWindow["_number"].text = "NO." + param1.getId();
         this._goodsWindow["_name"].text = this._name;
         this._goodsWindow["_type"].text = param1.getType();
         this._goodsWindow["_quality"].text = "??";
         this._goodsWindow["_use_condition_title"].text = LangManager.getInstance().getLanguage("window065");
         this._goodsWindow["_price_title"].text = LangManager.getInstance().getLanguage("window066");
         this._goodsWindow["_use_condition"].text = param1.getUseCondition();
         this._goodsWindow["_use_result"].text = param1.getUseResult();
         this._goodsWindow["_expl"].text = param1.getExpl();
         this._goodsWindow["_num"].text = this._nowNum + "";
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         this.hidden();
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.callOO(param2,0,this._id,this._nowNum);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param2.status == "success")
         {
            if(this._shopType == ShopWindow.SHOP_GENERAL)
            {
               PlantsVsZombies.changeMoneyOrExp(-this._nowNum * this._price,PlantsVsZombies.MONEY,true,this._isCost);
            }
            else if(this._shopType == ShopWindow.SHOP_RMB || this._shopType == ShopWindow.SHOP_VIP_SHOP || this._shopType == ShopWindow.SHOP_HOT_SHOP)
            {
               PlantsVsZombies.changeMoneyOrExp(-this._nowNum * this._price,PlantsVsZombies.RMB,true,this._isCost);
            }
            else if(this._shopType == ShopWindow.SHOP_EXCHANGE)
            {
               this.updateTool(ToolManager.CHANGE,this.playerManager.getPlayer().getTool(ToolManager.CHANGE).getNum() - this._nowNum * this._price);
            }
            else if(this._shopType == ShopWindow.SHOP_HONOUR)
            {
               this.playerManager.getPlayer().setHonour(this.playerManager.getPlayer().getHonour() - this._nowNum * this._price);
            }
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window067",this._nowNum,this._name));
            PlantsVsZombies.showDataLoading(false);
            if(this._picType == XmlShop.ORG)
            {
               this.addOrgs(param2.organisms);
            }
            else
            {
               this.updateTool(param2.tool.id,param2.tool.amount);
            }
            if(this._back != null)
            {
               this._back(this._id,this._nowNum,this._shopType);
            }
            if(this._back2 != null)
            {
               this._back2();
            }
         }
         else
         {
            PlantsVsZombies.showDataLoading(false);
            if(this._picType == XmlShop.TOOL)
            {
               this.updateTool(this._id,this._nowNum);
            }
            else if(param2.exception.call != null)
            {
               this.addOrgs(param2.exception.call);
            }
            if(this._shopType == ShopWindow.SHOP_GENERAL)
            {
               PlantsVsZombies.changeMoneyOrExp(-param2.exception.money,PlantsVsZombies.MONEY,this._isCost);
            }
            PlantsVsZombies.showSystemErrorInfo(param2.exception.message);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         PlantsVsZombies.showDataLoading(false);
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window068"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      public function show() : void
      {
         this.setLoction();
         this._goodsWindow.visible = true;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.setChildIndex(this._goodsWindow,PlantsVsZombies._node.numChildren - 1);
         onShowEffect(this._goodsWindow);
      }
      
      private function addEvent() : void
      {
         this._goodsWindow["addnum"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["decnum"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["buy"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["_num"].addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._goodsWindow["_num"].addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function addNum() : void
      {
         if(this._nowNum >= this._maxNum)
         {
            return;
         }
         ++this._nowNum;
         if(this._shopType == ShopWindow.SHOP_EXCHANGE)
         {
            this._goodsWindow._num.text = this._nowNum;
         }
         else if(this._shopType == ShopWindow.SHOP_RMB)
         {
            this._goodsWindow._num.text = this._nowNum;
         }
         else
         {
            this._goodsWindow._num.text = this._nowNum;
         }
      }
      
      private function addOrgs(param1:Array) : void
      {
         var _loc3_:Organism = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Organism();
            _loc3_.setAttack(param1[_loc2_].attack);
            _loc3_.setExp_max(param1[_loc2_].grade.exp_max);
            _loc3_.setGrade(param1[_loc2_].grade.id);
            _loc3_.setHp(param1[_loc2_].hp);
            _loc3_.setHp_max(param1[_loc2_].hp_max);
            _loc3_.setId(param1[_loc2_].id);
            _loc3_.setMiss(param1[_loc2_].miss);
            _loc3_.setPrecision(param1[_loc2_].precision);
            _loc3_.setPullulation(param1[_loc2_].mature);
            _loc3_.setQuality_name(param1[_loc2_].quality);
            this.addSkills(_loc3_,param1[_loc2_].skills);
            this.playerManager.addOrganism(_loc3_);
            _loc2_++;
         }
      }
      
      private function addSkills(param1:Organism, param2:Array) : void
      {
         var _loc4_:Skill = null;
         if(param2 == null || param2.length < 1)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = new Skill();
            _loc4_.setName(param2[_loc3_].name);
            _loc4_.setGrade(param2[_loc3_].grade);
            _loc4_.setId(param2[_loc3_].id);
            _loc4_.setEffect(param2[_loc3_].organism_attr);
            param1.addSkill(_loc4_);
            _loc3_++;
         }
      }
      
      private function updateTool(param1:int, param2:int) : void
      {
         this.playerManager.getPlayer().updateTool(param1,param2);
      }
      
      private function buy() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,0);
      }
      
      private function decNum() : void
      {
         if(this._nowNum <= 1)
         {
            return;
         }
         --this._nowNum;
         if(this._shopType == ShopWindow.SHOP_EXCHANGE)
         {
            this._goodsWindow._num.text = this._nowNum;
         }
         else if(this._shopType == ShopWindow.SHOP_RMB)
         {
            this._goodsWindow._num.text = this._nowNum;
         }
         else
         {
            this._goodsWindow._num.text = this._nowNum;
         }
      }
      
      private function isBuy() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._picType == XmlShop.TOOL)
         {
            if(this.playerManager.getPlayer().getTool(this._id) == null && this.playerManager.getPlayer().getStorageFreeTools() < 1)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window069"));
               return false;
            }
         }
         else if(this._picType == XmlShop.ORG)
         {
            if(this.playerManager.getPlayer().getStorageOrgNum() <= this.playerManager.getPlayer().organisms.length)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window070"));
               return false;
            }
            if(this.playerManager.getPlayer().getStorageOrgNum() < this._nowNum + this.playerManager.getPlayer().organisms.length)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window071"));
               return false;
            }
         }
         if(this._shopType == ShopWindow.SHOP_GENERAL)
         {
            if(this.playerManager.getPlayer().getMoney() < this._nowNum * this._price)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window072"));
            }
            else
            {
               _loc1_ = true;
            }
         }
         else if(this._shopType == ShopWindow.SHOP_EXCHANGE)
         {
            if(this.playerManager.getPlayer().getTool(ToolManager.CHANGE) == null || this.playerManager.getPlayer().getTool(ToolManager.CHANGE).getNum() < this._nowNum * this._price)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window073"));
            }
            else
            {
               _loc1_ = true;
            }
         }
         else if(this._shopType == ShopWindow.SHOP_RMB || this._shopType == ShopWindow.SHOP_VIP_SHOP || this._shopType == ShopWindow.SHOP_HOT_SHOP)
         {
            if(this.playerManager.getPlayer().getRMB() < this._nowNum * this._price)
            {
               PlantsVsZombies.showRechargeWindow(LangManager.getInstance().getLanguage("window074"));
            }
            else
            {
               _loc1_ = true;
            }
         }
         else if(this._shopType == ShopWindow.SHOP_HONOUR)
         {
            if(this.playerManager.getPlayer().getHonour() < this._nowNum * this._price)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window131"));
            }
            else
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionWindow = null;
         if(param1.currentTarget.name == "addnum")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.addNum();
         }
         else if(param1.currentTarget.name == "decnum")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.decNum();
         }
         else if(param1.currentTarget.name == "buy")
         {
            if(!this.isBuy())
            {
               return;
            }
            _loc2_ = new ActionWindow();
            if(this._shopType == ShopWindow.SHOP_EXCHANGE)
            {
               _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window068"),LangManager.getInstance().getLanguage("window075",this._nowNum * this._price,this._nowNum,this._name),this.buy,true);
            }
            else if(this._shopType == ShopWindow.SHOP_RMB || this._shopType == ShopWindow.SHOP_VIP_SHOP || this._shopType == ShopWindow.SHOP_HOT_SHOP)
            {
               _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window068"),LangManager.getInstance().getLanguage("window076",this._nowNum * this._price,this._nowNum,this._name),this.buy,true);
            }
            else if(this._shopType == ShopWindow.SHOP_HONOUR)
            {
               _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window068"),LangManager.getInstance().getLanguage("window130",this._nowNum * this._price,this._nowNum,this._name),this.buy,true);
            }
            else
            {
               _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window068"),LangManager.getInstance().getLanguage("window077",this._nowNum * this._price,this._nowNum,this._name),this.buy,true);
            }
         }
         else if(param1.currentTarget.name == "cancel")
         {
            this.hidden();
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
      }
      
      private function removeEvent() : void
      {
         this._goodsWindow["addnum"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["decnum"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["buy"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._goodsWindow["_num"].removeEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._goodsWindow["_num"].removeEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function setLoction() : void
      {
         this._goodsWindow.x = PlantsVsZombies.WIDTH - this._goodsWindow.width + 42;
         this._goodsWindow.y = PlantsVsZombies.HEIGHT - this._goodsWindow.height + 100;
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         if(this._goodsWindow["_num"].text == "")
         {
            this._nowNum = 1;
         }
         else
         {
            this._nowNum = int(this._goodsWindow["_num"].text);
         }
         if(this._nowNum > this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else if(this._nowNum <= 1)
         {
            this._nowNum = 1;
         }
         this._goodsWindow["_num"].text = this._nowNum;
      }
   }
}

