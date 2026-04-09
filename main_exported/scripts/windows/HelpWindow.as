package windows
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.GlobalConstants;
   import constants.URLConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Player;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.help.HelpNovice;
   import utils.Singleton;
   import xmlReader.XmlBaseReader;
   import xmlReader.XmlHelp;
   import xmlReader.XmlNewUserHelp;
   import zlib.utils.DomainAccess;
   
   public class HelpWindow extends BaseWindow implements IURLConnection
   {
      
      private static const ADDFRIENDS:int = 1;
      
      private static const REMOVENEW:int = 2;
      
      internal var _mc:MovieClip;
      
      internal var type:int = 0;
      
      internal var backFun:Function;
      
      internal var toHunting:Function;
      
      internal var urlconnection:URLConnection = null;
      
      private var isadd:int = 0;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function HelpWindow(param1:Function, param2:Function)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("helpWindow");
         this._mc = new _loc3_();
         this._mc.visible = false;
         this._mc._cancel.visible = false;
         this._mc._ok.addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc._cancel.addEventListener(MouseEvent.CLICK,this.onClickCancel);
         this.backFun = param1;
         this.toHunting = param2;
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         this.urlconnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         if(param1 == ADDFRIENDS)
         {
            this.showAddFriends(param2);
         }
         else if(param1 == REMOVENEW)
         {
            this.showRemovenew(param2);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
      }
      
      private function onClickCancel(param1:MouseEvent) : void
      {
         this.type = -7;
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_HELP_REMOVENEW + this.isadd),REMOVENEW);
         PlantsVsZombies.showDataLoading(true);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         if(this.type == HelpNovice.COMP_ENTER_FIRST)
         {
            this._mc.gotoAndStop(3);
            this.type = -1;
            return;
         }
         if(this.type == -1)
         {
            this.type = -2;
            this._mc.gotoAndStop(4);
            return;
         }
         if(this.type == -2)
         {
            this.type = -3;
            this._mc.gotoAndStop(5);
            return;
         }
         if(this.type == -3)
         {
            this.type = -4;
            this._mc.gotoAndStop(6);
            return;
         }
         if(this.type == -4)
         {
            this.type = -5;
            this._mc.gotoAndStop(7);
            return;
         }
         if(this.type == -5)
         {
            this.type = -6;
            this._mc.gotoAndStop(8);
            this._mc._cancel.visible = true;
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_HELP_ADDFRIENDS),ADDFRIENDS);
            return;
         }
         if(this.type == -6)
         {
            this.type = -7;
            this.isadd = 1;
            PlantsVsZombies.showDataLoading(true);
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_HELP_REMOVENEW + this.isadd),REMOVENEW);
         }
         this.hidden();
      }
      
      private function showAddFriends(param1:Object) : void
      {
         var _loc6_:MovieClip = null;
         var _loc2_:XmlHelp = new XmlHelp(param1 as String);
         var _loc3_:Array = _loc2_.getFriends();
         var _loc4_:Class = DomainAccess.getClass("friendLabel");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = new _loc4_();
            PlantsVsZombies.setHeadPic(_loc6_._pic,PlantsVsZombies.getHeadPicUrl((_loc3_[_loc5_] as Player).getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,(_loc3_[_loc5_] as Player).getVipTime(),(_loc3_[_loc5_] as Player).getVipLevel());
            _loc6_._name.text = (_loc3_[_loc5_] as Player).getNickname() + "";
            _loc6_.x = _loc5_ % 5 * (_loc6_.width + 8) - 228 + 20;
            _loc6_.y = int(_loc5_ / 5) * 87 - 87;
            this._mc.addChild(_loc6_);
            _loc5_++;
         }
      }
      
      private function showRemovenew(param1:Object) : void
      {
         var _loc2_:XmlNewUserHelp = new XmlNewUserHelp(param1 as String);
         if(_loc2_.isSuccess())
         {
            this.playerManager.getPlayer().organisms = _loc2_.getOrgs();
            this.playerManager.getPlayer().tools = _loc2_.getTools();
            this.playerManager.getPlayer().setMoney(_loc2_.getMoney());
            PlantsVsZombies.setUserInfos();
            GlobalConstants.NEW_PLAYER = false;
            PlantsVsZombies.firstLogin = 2;
         }
         else
         {
            if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            PlantsVsZombies.showSystemErrorInfo(_loc2_.error());
         }
         this.hidden();
         this.toHunting();
         this.backFun(true);
         PlantsVsZombies.showDataLoading(false);
      }
      
      public function show(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            this._mc.gotoAndStop(1);
         }
         else
         {
            if(param1 != HelpNovice.COMP_ENTER_FIRST)
            {
               return;
            }
            this._mc.gotoAndStop(2);
         }
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         onShowEffect(this._mc);
         this.type = param1;
         this._mc.visible = true;
         this._mc.x = PlantsVsZombies.WIDTH / 2;
         this._mc.y = PlantsVsZombies.HEIGHT / 2;
         PlantsVsZombies._node.addChild(this._mc);
         PlantsVsZombies._node.setChildIndex(this._mc,PlantsVsZombies._node.numChildren - 1);
      }
      
      public function hidden() : void
      {
         PlantsVsZombies.firstpage.getTaskJianTou().visible = false;
         onHiddenEffect(this._mc);
         if(this.type == 0)
         {
            PlantsVsZombies.helpN.show(HelpNovice.FIRST_ENTER_HUNTING,PlantsVsZombies._node as DisplayObjectContainer);
         }
      }
   }
}

