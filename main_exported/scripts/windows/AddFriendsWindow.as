package windows
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.GlobalConstants;
   import constants.URLConnectionConstants;
   import core.ui.panel.BaseWindow;
   import entity.Player;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.LangManager;
   import manager.VersionManager;
   import node.Icon;
   import utils.FuncKit;
   import xmlReader.XmlAddFriends;
   import xmlReader.XmlBaseReader;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class AddFriendsWindow extends BaseWindow implements IURLConnection, IDestroy
   {
      
      private static const ADD:int = 1;
      
      private static const INFO:int = 0;
      
      private var _amount:int = 0;
      
      private var _back:Function = null;
      
      private var _friends:Array = null;
      
      private var _mc:MovieClip = null;
      
      public function AddFriendsWindow(param1:Function)
      {
         var _loc2_:String = null;
         super();
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
            _loc2_ = "addFriendsWindowKaixin";
         }
         else
         {
            _loc2_ = "addFriendsWindow";
         }
         var _loc3_:Class = DomainAccess.getClass(_loc2_);
         this._mc = new _loc3_();
         this._mc.visible = false;
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._mc);
         this.addBtEvent();
         this._back = param1;
         PlantsVsZombies.showDataLoading(true);
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_USER_FRIENDS),INFO);
      }
      
      override public function destroy() : void
      {
         PlantsVsZombies.addfriendsWindow = null;
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var _loc4_:ActionWindow = null;
         if(param1 == ADD)
         {
            return;
         }
         var _loc3_:XmlAddFriends = new XmlAddFriends(param2 as String);
         if(!_loc3_.isSuccess())
         {
            if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            _loc4_ = new ActionWindow();
            _loc4_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("hunting003"),_loc3_.error(),null,false);
         }
         else
         {
            this._amount = _loc3_.getAmount();
            this._friends = _loc3_.getFriends();
            if(this._amount == 0)
            {
               this.show(false);
            }
            else
            {
               this.show(true);
            }
         }
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addBtEvent() : void
      {
         this._mc["_bt_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addFriend() : void
      {
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
            JSManager.gotoOtherHome((this._friends[0] as Player).getId());
         }
         else
         {
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_USER_ADDFRIENDS),ADD);
         }
      }
      
      private function hidden() : void
      {
         if(this._back != null)
         {
            this._back();
         }
         removeBG();
         this.removeBtEvent();
         onHiddenEffect(this._mc,this.destroy);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_ok")
         {
            this.addFriend();
         }
         else if(param1.currentTarget.name == "_bt_cancel")
         {
         }
         this.hidden();
      }
      
      private function removeBtEvent() : void
      {
         this._mc["_bt_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_bt_cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoction() : void
      {
         this._mc.x = PlantsVsZombies.WIDTH / 2;
         this._mc.y = PlantsVsZombies.HEIGHT / 2;
      }
      
      private function show(param1:Boolean) : void
      {
         PlantsVsZombies.showDataLoading(false);
         if(!param1)
         {
            this.hidden();
            return;
         }
         this.showFriends();
         this.setLoction();
         this._mc.visible = true;
         onShowEffect(this._mc);
      }
      
      private function showFriends() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         if(this._friends == null || this._friends.length < 1)
         {
            return;
         }
         var _loc1_:Class = DomainAccess.getClass("addFriendLabel");
         var _loc2_:Class = DomainAccess.getClass("grade");
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
            PlantsVsZombies.setHeadPic(this._mc["_pic_head"],PlantsVsZombies.getHeadPicUrl((this._friends[0] as Player).getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,(this._friends[0] as Player).getVipTime(),(this._friends[0] as Player).getVipLevel());
            _loc3_ = new _loc2_();
            _loc3_["num"].addChild(FuncKit.getNumEffect("" + (this._friends[0] as Player).getGrade()));
            _loc3_.x = -_loc3_.width / 2;
            this._mc["_pic_lv"].addChild(_loc3_);
            this._mc["_txt_name"].text = (this._friends[0] as Player).getNickname() + "";
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < this._friends.length)
            {
               _loc5_ = new _loc1_();
               PlantsVsZombies.setHeadPic(_loc5_._pic_head,PlantsVsZombies.getHeadPicUrl((this._friends[_loc4_] as Player).getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,(this._friends[_loc4_] as Player).getVipTime(),(this._friends[_loc4_] as Player).getVipLevel());
               _loc6_ = new _loc2_();
               _loc6_["num"].addChild(FuncKit.getNumEffect("" + (this._friends[_loc4_] as Player).getGrade()));
               _loc6_.x = -_loc6_.width / 2;
               _loc5_._pic_lv.addChild(_loc6_);
               _loc5_._txt_name.text = (this._friends[_loc4_] as Player).getNickname() + "";
               _loc5_.x = _loc4_ % 5 * (_loc5_.width + 8) - 30;
               _loc5_.y = int(_loc4_ / 5) * 87 - 70;
               this._mc.addChild(_loc5_);
               _loc4_++;
            }
         }
      }
   }
}

