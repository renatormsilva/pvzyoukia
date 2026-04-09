package windows
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.URLConnectionConstants;
   import entity.Player;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import manager.JSManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.FriendNode;
   import utils.Singleton;
   import xmlReader.XmlFriends;
   import zlib.utils.DomainAccess;
   
   public class FriendsWindow extends Sprite implements IURLConnection
   {
      
      public static var BASE_X:int = 740;
      
      public static const FIRSTPAGE:int = 0;
      
      public static const GARDEN:int = 1;
      
      public static const HUNTING:int = 2;
      
      public static const POSSESSION:int = 3;
      
      public static var NUM:int = 8;
      
      public static var X:int = 556;
      
      private static const READFRIENDS:int = 1;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public var _infos_nowpage:int = 0;
      
      internal var _friends:Array;
      
      internal var _friendsNodes:Array;
      
      internal var _isLoading:Boolean = false;
      
      internal var _maxPage:int = 1;
      
      internal var _nowPage:int = 1;
      
      internal var _page_num:int;
      
      internal var _type:int = 0;
      
      internal var _window:MovieClip;
      
      internal var backFun:Function;
      
      internal var t:Timer;
      
      internal var urlconnection:URLConnection = null;
      
      public function FriendsWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("_friendsWindow");
         this._window = new _loc1_();
         this.setVisible(false);
         this.setLoction();
         this.addPageEvent();
         this.playLoading(this._isLoading);
         this.addChild(this._window);
      }
      
      public function addFriendNodes() : void
      {
         if(this._nowPage * NUM >= PlayerManager.LOADING_RATE * this._friends.length)
         {
            if(this.playerManager.getPlayer().getFriendsMaxpage() == this._infos_nowpage)
            {
               return;
            }
            this._isLoading = true;
            this.playLoading(this._isLoading);
            this.readFriends();
         }
      }
      
      public function addfriends(param1:Array) : void
      {
         var _loc4_:FriendNode = null;
         this.playerManager.getPlayer().resetFriends(this._friends);
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new FriendNode(param1[_loc3_],this.nodeClick);
            _loc4_.changeType(this._type);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         this._friendsNodes = this._friendsNodes.concat(_loc2_);
      }
      
      public function changePlayer(param1:Player, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._friends.length)
         {
            if(param1 == this._friends[_loc3_] && param1.getIsGardenOrg() != param2)
            {
               param1.setIsGardenOrg(param2);
               this._friends[_loc3_] = param1;
               this.show();
               break;
            }
            _loc3_++;
         }
      }
      
      public function clearAllNodesSelect(param1:Player) : void
      {
         if(this._friendsNodes == null || this._friendsNodes.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._friendsNodes.length)
         {
            if((this._friendsNodes[_loc2_] as FriendNode).getPlayer() != param1)
            {
               (this._friendsNodes[_loc2_] as FriendNode).clearSelected();
            }
            _loc2_++;
         }
      }
      
      public function nodeClick(param1:Player) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         this.backFun(param1);
         this.clearAllNodesSelect(param1);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         if(param1 == READFRIENDS)
         {
            this.readfriends(param2);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
      }
      
      public function readFriends() : void
      {
         var _loc1_:int = this._infos_nowpage + 1;
         if(_loc1_ <= this.playerManager.getPlayer().getFriendsNowpage() || _loc1_ > this.playerManager.getPlayer().getFriendsMaxpage())
         {
            return;
         }
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_FRIENDS_ADDFRIENDS + _loc1_,false),READFRIENDS);
      }
      
      public function readfriends(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc2_:XmlFriends = new XmlFriends(param1 as String);
         if(!_loc2_.isSuccess())
         {
            PlantsVsZombies.showSystemErrorInfo(_loc2_.error());
         }
         else
         {
            _loc3_ = _loc2_.getFriends();
            if(this._infos_nowpage < _loc2_.getNowPage())
            {
               this._infos_nowpage = _loc2_.getNowPage();
               this.playerManager.getPlayer().setFriendsNowpage(_loc2_.getNowPage());
            }
            this._friends = this._friends.concat(_loc3_);
            this.addfriends(_loc3_);
         }
         this._isLoading = false;
         this.playLoading(this._isLoading);
      }
      
      public function setBackFunction(param1:Function) : void
      {
         this.backFun = param1;
      }
      
      public function setFriends(param1:Array) : void
      {
         if(param1 == null || param1.length < 1)
         {
            this._nowPage = 1;
            this._maxPage = 1;
            return;
         }
         this._friends = param1;
         this.init();
      }
      
      public function setLoction() : void
      {
         this._window.x = BASE_X;
         this._window.y = 86;
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
         if(this._type != FIRSTPAGE)
         {
            this.showType();
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._window == null)
         {
            return;
         }
         this._window.visible = param1;
      }
      
      public function show() : void
      {
         if(this._friendsNodes == null || this._friendsNodes.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._friendsNodes.length)
         {
            (this._friendsNodes[_loc1_] as FriendNode).changeType(this._type);
            _loc1_++;
         }
         this._maxPage = (this.playerManager.getPlayer().getFriendsNum() - 1) / NUM + 1;
         this.setPageNum();
         this.showPage();
      }
      
      public function showPage() : void
      {
         if(this._friendsNodes == null || this._friendsNodes.length < 1)
         {
            return;
         }
         this.clearAllFriendsNode();
         var _loc1_:Array = this._friendsNodes.slice((this._nowPage - 1) * NUM,this._nowPage * NUM);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            (_loc1_[_loc2_] as FriendNode).setLoction(33,40 + _loc2_ * ((_loc1_[_loc2_] as FriendNode).height + 3));
            (_loc1_[_loc2_] as FriendNode).addHeadPic();
            this._window.addChild(_loc1_[_loc2_]);
            _loc2_++;
         }
         this._window.setChildIndex(this._window.loading,this._window.numChildren - 1);
      }
      
      public function showType() : void
      {
         this._infos_nowpage = this.playerManager.getPlayer().getFriendsNowpage();
         this.show();
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         this.urlconnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addPageEvent() : void
      {
         this._window["add_num"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["dec_num"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["friend"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["webFriend"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function changeLoction() : void
      {
         var s:int;
         var speed:int = 0;
         var onTimer:Function = null;
         onTimer = function(param1:TimerEvent):void
         {
            _window.x += speed;
            if(_window.x < X)
            {
               _window.x = X;
               t.removeEventListener(TimerEvent.TIMER,onTimer);
               t.stop();
               t = null;
               showPage();
            }
            else if(_window.x > BASE_X)
            {
               _window.x = BASE_X;
               t.removeEventListener(TimerEvent.TIMER,onTimer);
               t.stop();
               t = null;
            }
         };
         if(this.t != null)
         {
            return;
         }
         speed = 16;
         if(this._window.x == BASE_X)
         {
            speed = -16;
         }
         s = BASE_X - X;
         this.t = new Timer(10);
         this.t.addEventListener(TimerEvent.TIMER,onTimer);
         this.t.start();
      }
      
      private function clearAllFriendsNode() : void
      {
         if(this._window.numChildren < 1)
         {
            return;
         }
         var _loc1_:* = int(this._window.numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._window.getChildAt(_loc1_) is FriendNode)
            {
               this._window.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function init() : void
      {
         var _loc2_:FriendNode = null;
         this._friendsNodes = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this._friends.length)
         {
            _loc2_ = new FriendNode(this._friends[_loc1_],this.nodeClick);
            _loc2_.changeType(this._type);
            this._friendsNodes.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "add_num")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._nowPage == this._maxPage)
            {
               return;
            }
            ++this._nowPage;
            this.addFriendNodes();
            this.setPageNum();
            this.showPage();
         }
         else if(param1.currentTarget.name == "dec_num")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this._nowPage < 2)
            {
               return;
            }
            --this._nowPage;
            this.setPageNum();
            this.showPage();
         }
         else if(param1.currentTarget.name == "friend")
         {
            if(this._isLoading)
            {
               return;
            }
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.changeLoction();
         }
         else if(param1.currentTarget.name == "webFriend")
         {
            JSManager.gotoFriendPage();
         }
      }
      
      private function playLoading(param1:Boolean) : void
      {
         if(param1)
         {
            this._window.loading.loading.gotoAndPlay(1);
         }
         else
         {
            this._window.loading.loading.gotoAndStop(1);
         }
         this._window.loading.visible = param1;
      }
      
      private function setPageNum() : void
      {
         this._window["num"].text = this._nowPage + "/" + this._maxPage;
      }
   }
}

