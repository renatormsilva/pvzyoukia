package pvz
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.shop.ShopWindow;
   import pvz.storage.rpc.GetPrizes_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.PrizesWindow;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.load.UILoader;
   import zmyth.res.IDestroy;
   
   public class ActivityWindow extends BaseWindow implements IConnection, IDestroy
   {
      
      private static const ACTIVITY:int = 1;
      
      private static const PRIZE:int = 2;
      
      internal var activityNum:int = 0;
      
      internal var nowPage:int = 1;
      
      internal var _window:MovieClip = null;
      
      internal var _backFun:Function = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function ActivityWindow(param1:Function = null)
      {
         super();
         this._backFun = param1;
         var _loc2_:Class = DomainAccess.getClass("ActivityWindow");
         this._window = new _loc2_();
         this.activityNum = this.playerManager.getPlayer().getBannerNum();
         this._window.visible = false;
         this.addBtEvent();
         this._window["_draw"].visible = false;
         this._window["goto_shop"].visible = true;
         this.show();
      }
      
      public function showBanner(param1:int = 1) : void
      {
         var loader:UILoader = null;
         var onLoaded:Function = null;
         var id:int = param1;
         onLoaded = function(param1:ForeletEvent):void
         {
            PlantsVsZombies.showDataLoading(false);
            if(_window["_pic_banner"] != null && _window["_pic_banner"].numChildren > 0)
            {
               FuncKit.clearAllChildrens(_window["_pic_banner"]);
            }
            loader.removeEventListener(ForeletEvent.COMPLETE,onLoaded);
            loader = null;
            var _loc2_:Bitmap = PlantsVsZombies.copy(param1.parameter as Bitmap);
            _window["_pic_banner"].addChild(_loc2_);
         };
         loader = new UILoader(this._window["_pic_banner"],this.playerManager.getPlayer().getBannerUrl() + id + ".png?" + FuncKit.currentTimeMillis(),false,false);
         loader.addEventListener(ForeletEvent.COMPLETE,onLoaded);
         loader.doLoad();
         PlantsVsZombies.showDataLoading(true);
      }
      
      private function setPage() : void
      {
         this._window["_draw"].visible = false;
         this._window["_page"].text = this.nowPage + "/" + this.activityNum;
         this.showBanner(this.nowPage);
      }
      
      override public function destroy() : void
      {
         this.removeBtEvent();
         if(this._backFun != null)
         {
            this._backFun();
         }
         PlantsVsZombies._node.removeChild(this._window);
      }
      
      private function getLostPrize() : void
      {
         if(this.playerManager.getPlayer().getKey() == "")
         {
            return;
         }
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_BATTLE_GETPRIZES,PRIZE,this.playerManager.getPlayer().getKey());
      }
      
      private function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._window);
         this.setPage();
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = 380 + 17;
         this._window.y = 265 + 13;
      }
      
      private function addBtEvent() : void
      {
         this._window["_close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_right"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_draw"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["goto_shop"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionWindow = null;
         if(param1.currentTarget.name == "_left")
         {
            if(this.nowPage == 1)
            {
               return;
            }
            --this.nowPage;
            this.setPage();
         }
         else if(param1.currentTarget.name == "_draw")
         {
            _loc2_ = new ActionWindow();
            _loc2_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window081"),LangManager.getInstance().getLanguage("window082"),this.getActivityPrizes,true);
         }
         else if(param1.currentTarget.name == "_right")
         {
            if(this.nowPage == this.activityNum)
            {
               return;
            }
            ++this.nowPage;
            this.setPage();
         }
         else if(param1.currentTarget.name == "_close")
         {
            onHiddenEffect(this._window,this.getLostPrize);
            this.destroy();
         }
         else if(param1.currentTarget.name == "goto_shop")
         {
            new ShopWindow(PlantsVsZombies._node.upDateTask);
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
      }
      
      private function getActivityPrizes() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ACTIVITY_GET,0);
      }
      
      private function removeBtEvent() : void
      {
         this._window["_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_right"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._window["_draw"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         PlantsVsZombies.showDataLoading(true);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == ACTIVITY)
         {
            _loc5_.call(param2,param3);
         }
         else if(param3 == PRIZE)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:PrizesWindow = null;
         if(param1 == ACTIVITY)
         {
            if(param2.state == 0)
            {
               PlantsVsZombies.showSystemErrorInfo(param2.reason);
               PlantsVsZombies.showDataLoading(false);
               return;
            }
            _loc5_ = new PrizesWindow(null,PlantsVsZombies._node as MovieClip);
            _loc3_ = new Array();
            _loc4_ = new Array();
            _loc4_.push("organism");
            _loc4_.push(int(param2.reason));
            _loc3_.push(_loc4_);
            _loc5_.show(_loc3_);
            this.playerManager.getPlayer().setIsActivity(false);
            this._window["_draw"].visible = this.playerManager.getPlayer().getIsActivity();
            PlantsVsZombies.showDataLoading(false);
         }
         if(param1 == PRIZE)
         {
            PlantsVsZombies.showDataLoading(false);
            this.showToolsPrizes(new GetPrizes_rpc().getAllAwards(param2));
            this.playerManager.getPlayer().setKey("");
         }
      }
      
      private function showToolsPrizes(param1:Array) : void
      {
         var _loc2_:PrizesWindow = new PrizesWindow(null,PlantsVsZombies._node);
         _loc2_.show(param1,null);
      }
      
      private function getToolsAwards(param1:Array) : Array
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_][0] == "tool" || param1[_loc3_][0] == "organism")
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
   }
}

