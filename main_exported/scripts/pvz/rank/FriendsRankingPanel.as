package pvz.rank
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.URLConnectionConstants;
   import entity.Player;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import manager.SoundManager;
   import utils.FuncKit;
   import utils.Singleton;
   import xmlReader.XmlBaseReader;
   import xmlReader.firstPage.XmlRanking;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class FriendsRankingPanel extends Sprite implements IURLConnection, IDestroy
   {
      
      private static const MAXMUN:int = 99;
      
      private static const NUM:int = 8;
      
      internal var panel:MovieClip = null;
      
      internal var isFriends:Boolean = true;
      
      internal var maxPage:int = 0;
      
      internal var nowArray:Array;
      
      internal var nowPage:int = 1;
      
      internal var userInfo:Class;
      
      internal var usersInfo:Array;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function FriendsRankingPanel(param1:int, param2:int)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("friendsRankingPanel");
         this.panel = new _loc3_();
         this.panel.gotoAndStop(1);
         this.panel.visible = false;
         this.panel.x = param1;
         this.panel.y = param2;
         this.addBtEvent();
         this.addChild(this.panel);
         this.show();
      }
      
      public function destroy() : void
      {
         this.clearInfo();
         this.removeBtEvent();
         this.removeChild(this.panel);
      }
      
      public function doLayout() : void
      {
         var _loc2_:MovieClip = null;
         if(this.nowArray == null || this.nowArray.length < 1)
         {
            return;
         }
         this.clearInfo();
         var _loc1_:int = 0;
         while(_loc1_ < this.nowArray.length)
         {
            _loc2_ = this.getUserMc(this.nowArray[_loc1_] as Player,(this.nowPage - 1) * NUM + _loc1_ + 1);
            _loc2_.name = _loc1_ + "";
            this.panel["_info"].addChild(_loc2_);
            _loc2_.y = _loc1_ * (_loc2_.height + 1);
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
            _loc1_++;
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.changeOverType(param1.currentTarget.name);
      }
      
      private function changeOverType(param1:String) : void
      {
         if(this.panel["_info"] == null || this.panel["_info"].numChildren < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.panel["_info"].numChildren)
         {
            if(this.panel["_info"].getChildAt(_loc2_).name != param1)
            {
               this.panel["_info"].getChildAt(_loc2_).gotoAndStop(1);
            }
            else
            {
               this.panel["_info"].getChildAt(_loc2_).gotoAndStop(2);
            }
            _loc2_++;
         }
      }
      
      private function addBtEvent() : void
      {
         this.panel["_left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_right"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addMyself() : void
      {
         var _loc1_:int = this.playerManager.getPlayer().getGrade();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         if(this.usersInfo.length < 1)
         {
            this.usersInfo.push(this.playerManager.getPlayer());
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.usersInfo.length)
         {
            if((this.usersInfo[_loc4_] as Player).getGrade() <= _loc1_)
            {
               _loc2_ = this.usersInfo.slice(0,_loc4_);
               _loc3_ = this.usersInfo.slice(_loc4_,this.usersInfo.length);
               _loc3_.unshift(this.playerManager.getPlayer());
               this.usersInfo = _loc2_.concat(_loc3_);
               break;
            }
            _loc4_++;
         }
      }
      
      private function clearInfo() : void
      {
         if(this.panel["_info"] == null || this.panel["_info"].numChildren < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.panel["_info"].numChildren)
         {
            this.panel["_info"].getChildAt(_loc1_).removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
            _loc1_++;
         }
         FuncKit.clearAllChildrens(this.panel["_info"]);
      }
      
      private function getUserMc(param1:Player, param2:int) : MovieClip
      {
         if(param1 == null)
         {
            return null;
         }
         if(this.userInfo == null)
         {
            this.userInfo = DomainAccess.getClass("_userRank");
         }
         var _loc3_:MovieClip = new this.userInfo();
         _loc3_["_rankpic"].addChild(FuncKit.getNumEffect(param2 + "","Small"));
         if(param1 == this.playerManager.getPlayer())
         {
            PlantsVsZombies.setHeadPic(_loc3_["_headpic"],PlantsVsZombies.getHeadPicUrl(param1.getFaceUrl2()),PlantsVsZombies.HEADPIC_SMALL,param1.getVipTime(),param1.getVipLevel());
         }
         else
         {
            PlantsVsZombies.setHeadPic(_loc3_["_headpic"],PlantsVsZombies.getHeadPicUrl(param1.getFaceUrl2()),PlantsVsZombies.HEADPIC_SMALL,param1.getVipTime(),param1.getVipLevel());
         }
         _loc3_["_gradepic"].addChild(FuncKit.getNumEffect(param1.getGrade() + ""));
         _loc3_["_name"].text = param1.getNickname();
         _loc3_.gotoAndStop(1);
         return _loc3_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_left")
         {
            if(this.nowPage < 2)
            {
               return;
            }
            --this.nowPage;
            this.panel["_page"].text = this.nowPage + "/" + this.maxPage;
            this.nowArray = this.usersInfo.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
            this.doLayout();
         }
         else if(param1.currentTarget.name == "_right")
         {
            if(this.nowPage == this.maxPage)
            {
               return;
            }
            ++this.nowPage;
            this.panel["_page"].text = this.nowPage + "/" + this.maxPage;
            this.nowArray = this.usersInfo.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
            this.doLayout();
         }
      }
      
      private function removeBtEvent() : void
      {
         this.panel["_left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_right"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function show() : void
      {
         if(this.isFriends)
         {
            this.usersInfo = this.playerManager.getPlayer().getFriends();
            if(this.usersInfo == null)
            {
               this.usersInfo = new Array();
            }
            if(this.usersInfo.length > MAXMUN)
            {
               this.usersInfo = this.usersInfo.slice(0,MAXMUN);
            }
            this.addMyself();
            this.panel.visible = true;
            this.maxPage = (this.usersInfo.length - 1) / NUM + 1;
            this.nowPage = 1;
            this.nowArray = this.usersInfo.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
            this.panel["_page"].text = "1/" + this.maxPage;
            this.doLayout();
         }
         else
         {
            PlantsVsZombies.showDataLoading(true);
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_RANK),0);
         }
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:XmlRanking = new XmlRanking(param2 as String);
         if(_loc3_.isSuccess())
         {
            this.usersInfo = _loc3_.getNowTypeRanking();
         }
         else
         {
            if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            PlantsVsZombies.showSystemErrorInfo(_loc3_.error());
         }
         this.panel.visible = true;
         PlantsVsZombies._node.setChildIndex(this.panel,PlantsVsZombies._node.numChildren - 1);
         if(this.usersInfo == null || this.usersInfo.length < 1)
         {
            return;
         }
         this.maxPage = (this.usersInfo.length - 1) / NUM + 1;
         this.nowPage = 1;
         this.nowArray = this.usersInfo.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
         this.panel["_page"].text = "1/" + this.maxPage;
         this.doLayout();
      }
   }
}

