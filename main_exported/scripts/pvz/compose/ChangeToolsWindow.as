package pvz.compose
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Goods;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import utils.FuncKit;
   import utils.Singleton;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ChangeToolsWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      internal var _window:MovieClip = null;
      
      internal var _okBackFun:Function = null;
      
      internal var _maxNum:int = 0;
      
      internal var _nowNum:int = 0;
      
      internal var _goods:Goods;
      
      internal var _tool:Tool;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function ChangeToolsWindow(param1:Tool, param2:Goods, param3:Function)
      {
         super();
         var _loc4_:Class = DomainAccess.getClass("changeToolsWindow");
         this._window = new _loc4_();
         this._goods = param2;
         this._tool = param1;
         this._okBackFun = param3;
         this.init(param1,param2);
         this.initButtonEvent();
      }
      
      override public function destroy() : void
      {
         this.removeButtonEvent();
         this._maxNum = 0;
         this._nowNum = 0;
         this._okBackFun = null;
         FuncKit.clearAllChildrens(this._window._pic);
         this._window._num.text = "";
      }
      
      private function initButtonEvent() : void
      {
         this._window._add.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._dec.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._ok.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._cancel.addEventListener(MouseEvent.CLICK,this.onClick);
         this._window._num.addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._window._num.addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function removeButtonEvent() : void
      {
         this._window._add.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._dec.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._ok.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._cancel.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window._num.removeEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._window._num.removeEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         if(this._window._num.text == "")
         {
            this._nowNum = 1;
         }
         else
         {
            this._nowNum = int(this._window._num.text);
         }
         if(this._nowNum <= 1)
         {
            this._nowNum = 1;
         }
         if(this._nowNum >= this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         this._window._num.text = this._nowNum;
      }
      
      private function init(param1:Tool, param2:Goods) : void
      {
         Icon.setUrlIcon(this._window._pic,XmlToolsConfig.getInstance().getToolAttribute(param2.getId()).getPicId(),Icon.TOOL_1);
         this._window._text1.text = LangManager.getInstance().getLanguage("window048",param2.getName());
         this._maxNum = param1.getNum() / param2.getPurchasePrice();
         this._nowNum = this._maxNum;
         this.show();
      }
      
      private function setText() : void
      {
         this._window._num.text = this._nowNum + "";
      }
      
      private function show() : void
      {
         showBG(PlantsVsZombies._node);
         this.setText();
         this.setLoction();
         PlantsVsZombies._node.addChild(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = PlantsVsZombies.WIDTH / 2;
         this._window.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         PlantsVsZombies.showDataLoading(true);
         _loc5_.callOO(param2,param3,this._goods.getGoodsId(),this._nowNum);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:int = 0;
         if(param2.status == "success")
         {
            _loc3_ = this._goods.getPurchasePrice() * this._nowNum;
            this._tool.setNum(this._tool.getNum() - _loc3_);
            this.playerManager.getPlayer().updateTool(this._tool.getOrderId(),this._tool.getNum());
            this.playerManager.getPlayer().updateTool(param2.tool.id,param2.tool.amount);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window049",this._nowNum,this._goods.getName()));
            if(this._okBackFun != null)
            {
               this._okBackFun();
            }
            PlantsVsZombies.showDataLoading(false);
            this.hidden();
         }
         else
         {
            PlantsVsZombies.showDataLoading(false);
            PlantsVsZombies.showSystemErrorInfo(param2.exception.message);
            this.hidden();
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
            this.hidden();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_add")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._nowNum >= this._maxNum)
            {
               return;
            }
            ++this._nowNum;
            this.setText();
         }
         else if(param1.currentTarget.name == "_dec")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._nowNum <= 1)
            {
               return;
            }
            --this._nowNum;
            this.setText();
         }
         else if(param1.currentTarget.name == "_ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_BUY,0);
         }
         else if(param1.currentTarget.name == "_cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.hidden();
         }
      }
      
      private function hidden() : void
      {
         this.destroy();
         onHiddenEffect(this._window);
      }
   }
}

