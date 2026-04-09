package
{
   import com.adobe.crypto.MD5;
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import core.managers.GameManager;
   import effect.flap.FlapManager;
   import entity.Player;
   import entity.Task;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import loading.Loading;
   import manager.*;
   import node.Icon;
   import pvz.compose.panel.ComposeWindowNew;
   import pvz.firstpage.Firstpage;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import pvz.help.HelpNovice;
   import pvz.ihandbook.IHandbookWindow;
   import pvz.newTask.ctrl.NewTaskCtrl;
   import pvz.rank.RankingWindow;
   import pvz.serverbattle.SeverBattleControl;
   import pvz.shop.ShopWindow;
   import pvz.storage.StorageWindow;
   import pvz.task.rpc.Task_rpc;
   import pvz.vip.AutoGainWindow;
   import tip.notice.NoticeManager;
   import utils.ConfigURLLoader;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.StringMovieClip;
   import utils.TextFilter;
   import windows.APLWindow;
   import windows.ActionWindow;
   import windows.AddFriendsWindow;
   import windows.AvertWallowWindow;
   import windows.ChallengePropWindow;
   import windows.FriendsWindow;
   import windows.HelpWindow;
   import windows.PlayerInfoWindow;
   import windows.RechargeWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.XmlUserInfo;
   import xmlReader.config.XmlChangeJewelConfig;
   import xmlReader.config.XmlGeniusDataConfig;
   import xmlReader.config.XmlHolePrizesConfig;
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlQualityConfig;
   import xmlReader.config.XmlToolsConfig;
   import xmlReader.config.XmlUIConfig;
   import xmlReader.firstPage.XmlStorage;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.load.UILoader;
   
   public class PlantsVsZombies extends Sprite implements IURLConnection, IConnection
   {
      
      public static var _friendsWindow:FriendsWindow;
      
      public static var _node:MovieClip;
      
      public static var configLoader:ConfigURLLoader;
      
      public static var helpN:HelpNovice;
      
      public static var functionObj:Object;
      
      public static var soundManager:SoundManager;
      
      public static var systemInfo:MovieClip;
      
      public static var systemTimer:Timer;
      
      public static var EXP:int = 1;
      
      public static const GENIUS_OPEN_LEVEL:int = 20;
      
      public static const HEADPIC_BIG:int = 48;
      
      public static const HEADPIC_MIDDLE:int = 40;
      
      public static const HEADPIC_SMALL:int = 34;
      
      public static var HEIGHT:int = 535;
      
      public static var HONOUR:int = 3;
      
      public static var MONEY:int = 0;
      
      public static var RMB:int = 2;
      
      public static const WAN:Number = 10000;
      
      public static const WAN_YI:Number = 10000 * 10000 * 10000;
      
      public static var WIDTH:int = 760;
      
      public static const YI:Number = 10000 * 10000;
      
      public static var _task:Task = null;
      
      public static var addfriendsWindow:AddFriendsWindow = null;
      
      public static var aplWindow:APLWindow = null;
      
      public static var firstLogin:int = 0;
      
      public static var firstpage:Firstpage = null;
      
      public static var isAllLoadOver:Boolean = false;
      
      public static var language_type:String = "";
      
      public static var orgRankingArray:Array = null;
      
      public static var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public static var skill_manager:SkillManager = null;
      
      private static const BUTTON_CONFIG:String = "config/MenuBtnConfig.xml";
      
      private static const CONFIG:String = "config/config.xml";
      
      private static var GRADE_WIDTH:int = 54;
      
      private static var code:String = "";
      
      private static var onLineTimer:Timer = null;
      
      public var player:Player;
      
      private var _playerInfoWindow:PlayerInfoWindow;
      
      private var isHelpOver:Boolean = false;
      
      private var loadingFore:Loading;
      
      private var loadingloader:UILoader;
      
      private var loadloader:UILoader;
      
      private var m_configxml:XML = null;
      
      private var rankingWindow:RankingWindow;
      
      public function PlantsVsZombies()
      {
         super();
         Object["parameters"] = this.loaderInfo.parameters;
         GlobalConstants.PVZ_RES_BASE_URL = this.loaderInfo.parameters["base_url_info"];
         if(GlobalConstants.PVZ_RES_BASE_URL == null)
         {
            GlobalConstants.PVZ_RES_BASE_URL = "";
         }
         this.urlloaderSend(GlobalConstants.PVZ_RES_BASE_URL + CONFIG + "?" + FuncKit.currentTimeMillis(),0);
         this.urlloaderSend(GlobalConstants.PVZ_RES_BASE_URL + BUTTON_CONFIG + "?" + FuncKit.currentTimeMillis(),1);
         functionObj = this.showHelpWindow;
      }
      
      public static function ChangeUserHuntNum() : void
      {
         if(PlantsVsZombies._node["player"]["num_hunt"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player"]["num_hunt"]);
         }
         PlantsVsZombies._node["player"]["player_info"]["player_zhi"].gotoAndStop(1);
         PlantsVsZombies._node["player"]["hunt"].gotoAndStop(1);
         PlantsVsZombies._node["player"]["num_hunt"].addChild(FuncKit.getNumEffect(playerManager.getPlayer().getNowHunts() + ""));
         PlantsVsZombies._node["player"]["num_hunt"].getChildAt(0).x = (85 - PlantsVsZombies._node["player"]["num_hunt"].getChildAt(0).width) / 2;
      }
      
      public static function ChangeUserGardenNum() : void
      {
         if(PlantsVsZombies._node["player"]["num_hunt"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player"]["num_hunt"]);
         }
         PlantsVsZombies._node["player"]["player_info"]["player_zhi"].gotoAndStop(2);
         PlantsVsZombies._node["player"]["hunt"].gotoAndStop(2);
         PlantsVsZombies._node["player"]["num_hunt"].addChild(FuncKit.getNumEffect(playerManager.getPlayer().getGardenChaCount() + ""));
         PlantsVsZombies._node["player"]["num_hunt"].getChildAt(0).x = (85 - PlantsVsZombies._node["player"]["num_hunt"].getChildAt(0).width) / 2;
      }
      
      public static function backToFirstPage() : void
      {
         Firstpage.setBtnVisible = true;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         _node["_left_light"].visible = false;
         _node["_right_light"].visible = false;
         _node["_toOtherHunting"].visible = false;
         _node["autoGainIcon"].visible = false;
         _node["autoGainIcon"].stop();
         setPageButtonVisible(false);
         _node.isInto.visible = false;
         _node.isInto.gotoAndStop(1);
         setBackLastFloorButtonVisible(false);
         setGoHomeButtonVisible(false);
         setPlayerInfoVisible(true);
         setFriendWindowVisible(false);
         setToFirstPageButtonVisible(false);
         changePlayer_other();
         setWindowsButtonsVisible(true);
         setDoworkVisible(false);
         _friendsWindow.setType(FriendsWindow.FIRSTPAGE);
         _node["draw"].x = 0;
         _node["draw"].y = 0;
         setUserInfos();
         if(_node["draw"].numChildren > 0)
         {
            _node["draw"].removeChildAt(0);
         }
         if(firstpage == null)
         {
            firstpage = new Firstpage(_node["draw"]);
         }
         firstpage.show();
      }
      
      public static function changeMoneyOrExp(param1:Number, param2:int = 0, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false) : void
      {
         var _loc7_:Class = null;
         var _loc6_:MovieClip = null;
         if(param2 == 0)
         {
            if(param1 < 0)
            {
               _loc7_ = DomainAccess.getClass("jian");
               _loc6_ = new _loc7_();
               _loc6_["num"].addChild(StringMovieClip.getStringImage(Math.abs(param1) + "","Exp"));
            }
            else
            {
               _loc7_ = DomainAccess.getClass("jia");
               _loc6_ = new _loc7_();
               _loc6_["num"].addChild(StringMovieClip.getStringImage(Math.abs(param1) + "","Exp"));
            }
            if(param3)
            {
               playerManager.getPlayer().setMoney(playerManager.getPlayer().getMoney() + param1);
            }
            _loc6_.x = PlantsVsZombies._node.eff_money.x;
            _loc6_.y = PlantsVsZombies._node.eff_money.y;
         }
         else if(param2 == 1)
         {
            if(playerManager.getPlayer().getTodayMaxExp() - playerManager.getPlayer().getTodayExp() <= 0)
            {
               return;
            }
            _loc7_ = DomainAccess.getClass("exp");
            _loc6_ = new _loc7_();
            _loc6_["num"].addChild(StringMovieClip.getStringImage(param1 + "","Exp"));
            if(param3)
            {
               param5 = true;
               playerManager.getPlayer().setExp(playerManager.getPlayer().getExp() + param1);
               playerManager.getPlayer().setTodayExp(playerManager.getPlayer().getTodayExp() + param1);
            }
            _loc6_.x = PlantsVsZombies._node.eff_exp.x;
            _loc6_.y = PlantsVsZombies._node.eff_exp.y;
         }
         else
         {
            if(param2 != 2)
            {
               return;
            }
            if(param1 < 0)
            {
               _loc7_ = DomainAccess.getClass("jian");
               _loc6_ = new _loc7_();
               _loc6_["num"].addChild(StringMovieClip.getStringImage(Math.abs(param1) + "","Exp"));
            }
            else
            {
               _loc7_ = DomainAccess.getClass("jia");
               _loc6_ = new _loc7_();
               _loc6_["num"].addChild(StringMovieClip.getStringImage(Math.abs(param1) + "","Exp"));
            }
            if(param3)
            {
               playerManager.getPlayer().setRMB(playerManager.getPlayer().getRMB() + param1);
            }
            _loc6_.x = PlantsVsZombies._node.eff_money.x + 130;
            _loc6_.y = PlantsVsZombies._node.eff_money.y;
         }
         if(param4)
         {
            PlantsVsZombies._node.addChild(_loc6_);
            FlapManager.flapInfos(_loc6_.x,_loc6_.y,PlantsVsZombies._node as MovieClip,_loc6_ as DisplayObject,1);
         }
         else
         {
            _loc6_ = null;
         }
         setUserInfos(false,param5);
      }
      
      public static function changePlayer_other() : void
      {
         PlantsVsZombies._node["right"].visible = false;
         if(playerManager.getPlayer() == playerManager.getPlayerOther())
         {
            PlantsVsZombies._node["player_other"].visible = false;
            PlantsVsZombies._node["player_other_back"].visible = false;
         }
         else
         {
            PlantsVsZombies._node["player_other"].visible = true;
            PlantsVsZombies._node["player_other_back"].visible = true;
            PlantsVsZombies.showPlayer_otherInfo();
         }
      }
      
      public static function copy(param1:DisplayObject) : Bitmap
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,1);
         _loc2_.draw(param1);
         return new Bitmap(_loc2_);
      }
      
      public static function getHeadPicUrl(param1:String) : String
      {
         if(param1 == "")
         {
            return "";
         }
         return playerManager.getPlayer().getFaceUrl1() + param1;
      }
      
      public static function getRPCUrl() : String
      {
         var _loc1_:String = "amf";
         var _loc2_:RegExp = /index.php/;
         return GlobalConstants.PVZ_WEB_URL.replace(_loc2_,_loc1_);
      }
      
      public static function getStoryTools(param1:Function = null) : void
      {
         var ul:URLLoader = null;
         var onListLoaded:Function = null;
         var loadOver:Function = param1;
         onListLoaded = function(param1:Event):void
         {
            var _loc3_:ActionWindow = null;
            ul.removeEventListener(Event.COMPLETE,onListLoaded);
            var _loc2_:XmlStorage = new XmlStorage(ul.data);
            showDataLoading(false);
            if(_loc2_.isSuccess())
            {
               playerManager.getPlayer().tools = _loc2_.getTools();
               if(loadOver != null)
               {
                  loadOver();
               }
            }
            else
            {
               if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  showRushLoading();
                  return;
               }
               _loc3_ = new ActionWindow();
               _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("main001"),_loc2_.error(),null,false);
            }
         };
         APLManager.reset(3);
         showDataLoading(true);
         ul = new URLLoader();
         ul.load(new URLRequest(getURL("Warehouse",true)));
         ul.addEventListener(Event.COMPLETE,onListLoaded);
      }
      
      public static function getURL(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:String = "";
         if(param2)
         {
            _loc3_ = GlobalConstants.PVZ_WEB_URL + param1 + "/index" + code + "?" + FuncKit.currentTimeMillis();
         }
         else
         {
            _loc3_ = GlobalConstants.PVZ_WEB_URL + param1 + code + "?" + FuncKit.currentTimeMillis();
         }
         return _loc3_;
      }
      
      public static function isIncludeNum(param1:String) : int
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1.charCodeAt(_loc3_);
            if(_loc2_ >= 48 && _loc2_ <= 57)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public static function lockScreen(param1:Boolean) : void
      {
         _node.mouseChildren = param1;
      }
      
      public static function playFireworks(param1:int) : void
      {
         var temp:Class;
         var playx:int;
         var playy:int;
         var mc:MovieClip = null;
         var onPlay:Function = null;
         var times:int = param1;
         onPlay = function(param1:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.removeEventListener(Event.ENTER_FRAME,onPlay);
               PlantsVsZombies._node.removeChild(mc);
            }
            if(mc.currentFrame == 3)
            {
               playFireworks(times - 1);
            }
         };
         if(times <= 0)
         {
            return;
         }
         temp = DomainAccess.getClass("fireworks");
         mc = new temp();
         playx = FuncKit.getRandom(100,600);
         playy = FuncKit.getRandom(100,400);
         mc.x = playx;
         mc.y = playy;
         PlantsVsZombies._node.addChild(mc);
         PlantsVsZombies._node.setChildIndex(mc,PlantsVsZombies._node.numChildren - 1);
         mc.addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      public static function playSounds(param1:String) : void
      {
         if(soundManager == null)
         {
            soundManager = new SoundManager();
            SoundManager.setVolume(10);
         }
         soundManager.playSound(param1);
      }
      
      public static function rush() : void
      {
         JSManager.rush();
      }
      
      public static function setBackLastFloorButtonVisible(param1:Boolean) : void
      {
         _node["lastFloor_btn"].visible = param1;
      }
      
      public static function setDoworkVisible(param1:Boolean) : void
      {
         _node["dowork"].visible = param1;
      }
      
      public static function setFirendWindowBackFun(param1:Function) : void
      {
         _friendsWindow.setBackFunction(param1);
      }
      
      public static function setFriendWindowType(param1:int) : void
      {
         _friendsWindow.setType(param1);
      }
      
      public static function setFriendWindowVisible(param1:Boolean) : void
      {
         _friendsWindow.setVisible(param1);
         _friendsWindow.setLoction();
      }
      
      public static function setGoHomeButtonVisible(param1:Boolean) : void
      {
         PlantsVsZombies._node["goHome_btn"].visible = param1;
      }
      
      public static function setHeadPic(param1:DisplayObjectContainer, param2:String, param3:int, param4:int, param5:uint = 0, param6:uint = 1) : void
      {
         var isV:Boolean = false;
         var loader:Loader = null;
         var onComp:Function = null;
         var ioError:Function = null;
         var disNode:DisplayObjectContainer = param1;
         var url:String = param2;
         var size:int = param3;
         var vipTime:int = param4;
         var vipLevel:uint = param5;
         var vipWin:uint = param6;
         onComp = function(param1:Event):void
         {
            var _loc2_:MovieClip = null;
            disNode.addChild(loader);
            loader.removeEventListener(Event.COMPLETE,onComp);
            loader.width = size - 1;
            loader.height = size - 1;
            if(isV && Boolean(vipWin))
            {
               _loc2_ = getVipDis(size);
               _loc2_.gotoAndStop(vipLevel);
               _loc2_.x = loader.width - _loc2_.width;
               _loc2_.y = loader.height - _loc2_.height;
               disNode.addChild(_loc2_);
            }
         };
         ioError = function(param1:IOErrorEvent):void
         {
         };
         var getVipDis:Function = function(param1:int):DisplayObject
         {
            var _loc2_:Class = null;
            if(param1 == HEADPIC_BIG)
            {
               _loc2_ = DomainAccess.getClass("_mc_headvip");
            }
            else
            {
               _loc2_ = DomainAccess.getClass("_mc_headvipS");
            }
            return new _loc2_();
         };
         if(disNode != null && disNode.numChildren > 0)
         {
            FuncKit.clearAllChildrens(disNode);
         }
         if(url == "")
         {
            return;
         }
         isV = false;
         if(playerManager.isVip(vipTime) != null)
         {
            isV = true;
         }
         loader = new Loader();
         loader.load(new URLRequest(url));
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComp);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
      }
      
      public static function setPageButtonVisible(param1:Boolean) : void
      {
         PlantsVsZombies._node["_left"].visible = param1;
         PlantsVsZombies._node["_right"].visible = param1;
      }
      
      public static function setPlayerInfoVisible(param1:Boolean = false) : void
      {
         PlantsVsZombies._node["player"].visible = param1;
      }
      
      public static function setToFirstPageButtonVisible(param1:Boolean) : void
      {
         _node["back"].visible = param1;
      }
      
      public static function setUserInfos(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(playerManager.getPlayer() == null)
         {
            return;
         }
         if(param1)
         {
            setHeadPic(PlantsVsZombies._node["player"]["pic"],getHeadPicUrl(playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,playerManager.getPlayer().getVipTime(),playerManager.getPlayer().getVipLevel());
         }
         _node["player"]["player_info"]["player_name"].text = playerManager.getPlayer().getNickname();
         if(playerManager.getPlayer().getExp() > playerManager.getPlayer().getExp_max())
         {
            _node["player"]["exp"].exp.text = playerManager.getPlayer().getExp_max() - playerManager.getPlayer().getExp_min() + "/" + (playerManager.getPlayer().getExp_max() - playerManager.getPlayer().getExp_min());
         }
         else
         {
            _node["player"]["exp"].exp.text = playerManager.getPlayer().getExp() - playerManager.getPlayer().getExp_min() + "/" + (playerManager.getPlayer().getExp_max() - playerManager.getPlayer().getExp_min());
         }
         _node["player"]["exp"].exp_mask.scaleX = (playerManager.getPlayer().getExp() - playerManager.getPlayer().getExp_min()) / (playerManager.getPlayer().getExp_max() - playerManager.getPlayer().getExp_min());
         if(param2)
         {
            (_node["player"]["_light"] as MovieClip).play();
         }
         setUserInfosNum();
      }
      
      public static function setUserInfosNum() : void
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Number = NaN;
         var _loc6_:DisplayObject = null;
         var _loc7_:Number = NaN;
         var _loc8_:DisplayObject = null;
         if(PlantsVsZombies._node["player"]["num_money"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player"]["num_money"]);
         }
         if(PlantsVsZombies._node["player"]["num_hunt"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player"]["num_hunt"]);
         }
         if(PlantsVsZombies._node["player"]["num_rmb"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player"]["num_rmb"]);
         }
         if(PlantsVsZombies._node["player"]["num_level"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player"]["num_level"]);
         }
         var _loc1_:Class = DomainAccess.getClass("gradeLev");
         var _loc2_:MovieClip = new _loc1_();
         _loc2_["num"].addChild(StringMovieClip.getStringImage(playerManager.getPlayer().getGrade() + "","Lev"));
         PlantsVsZombies._node["player"]["num_level"].addChild(_loc2_);
         PlantsVsZombies._node["player"]["num_level"].x = PlantsVsZombies._node["player"]["num_level_loc"].x + (GRADE_WIDTH - _loc2_.width) / 2;
         if(playerManager.getPlayer().getMoney() >= 100000)
         {
            _loc3_ = DomainAccess.getClass("wan");
            _loc4_ = new _loc3_();
            _loc5_ = Math.floor(playerManager.getPlayer().getMoney() / 10000);
            _loc6_ = FuncKit.getNumEffect(_loc5_ + "");
            if(_loc5_ <= 100)
            {
               PlantsVsZombies._node["player"]["num_money"].x = 150;
            }
            else if(_loc5_ <= 1000)
            {
               PlantsVsZombies._node["player"]["num_money"].x = 165;
            }
            else
            {
               PlantsVsZombies._node["player"]["num_money"].x = 185;
            }
            _loc4_.addChild(_loc6_);
            _loc6_.x = -_loc6_.width - 2;
            _loc6_.y = _loc6_.height - 4;
            PlantsVsZombies._node["player"]["num_money"].addChild(_loc4_);
            _loc4_.x = 200;
            _loc4_.y = -10;
         }
         else
         {
            _loc7_ = playerManager.getPlayer().getMoney();
            _loc8_ = FuncKit.getNumEffect(_loc7_ + "");
            PlantsVsZombies._node["player"]["num_money"].x = 120;
            PlantsVsZombies._node["player"]["num_money"].addChild(_loc8_);
         }
         if(PlantsVsZombies._node["player"]["player_info"]["player_zhi"].currentFrame == 2)
         {
            PlantsVsZombies._node["player"]["num_hunt"].addChild(FuncKit.getNumEffect(playerManager.getPlayer().getGardenChaCount() + ""));
         }
         else
         {
            PlantsVsZombies._node["player"]["num_hunt"].addChild(FuncKit.getNumEffect(playerManager.getPlayer().getNowHunts() + ""));
         }
         PlantsVsZombies._node["player"]["num_rmb"].addChild(FuncKit.getNumEffect(playerManager.getPlayer().getRMB() + ""));
         PlantsVsZombies._node["player"]["num_money"].getChildAt(0).x = (85 - PlantsVsZombies._node["player"]["num_money"].getChildAt(0).width) / 2;
         PlantsVsZombies._node["player"]["num_hunt"].getChildAt(0).x = (85 - PlantsVsZombies._node["player"]["num_hunt"].getChildAt(0).width) / 2;
         PlantsVsZombies._node["player"]["num_rmb"].getChildAt(0).x = (85 - PlantsVsZombies._node["player"]["num_rmb"].getChildAt(0).width) / 2;
      }
      
      public static function setWindowsButtonsVisible(param1:Boolean = false) : void
      {
         PlantsVsZombies._node["right"].visible = param1;
      }
      
      public static function showAPLWindow(param1:int) : void
      {
         if(aplWindow == null)
         {
            aplWindow = new APLWindow();
         }
         else
         {
            aplWindow.hidden();
         }
         switch(param1)
         {
            case 1:
               aplWindow.setBackFun(rush);
               break;
            case 2:
               aplWindow.setBackFun(null);
               break;
            case 3:
               aplWindow.setBackFun(rush);
         }
         aplWindow.show(param1);
      }
      
      public static function showAddFriends(param1:Function) : void
      {
         if(addfriendsWindow == null)
         {
            addfriendsWindow = new AddFriendsWindow(param1);
         }
      }
      
      public static function showDataLoading(param1:Boolean, param2:Function = null) : void
      {
         if(!isAllLoadOver)
         {
            return;
         }
         PlantsVsZombies._node.dataLoading["loadName"].text = "";
         PlantsVsZombies._node.dataLoading["_p"].text = "";
         PlantsVsZombies._node.dataLoading.visible = param1;
         PlantsVsZombies._node.setChildIndex(PlantsVsZombies._node.dataLoading,PlantsVsZombies._node.numChildren - 1);
         if(param1)
         {
            PlantsVsZombies._node.dataLoading.loading.gotoAndPlay(1);
            PlantsVsZombies._node.dataLoading.loading2.gotoAndPlay(1);
         }
         else
         {
            PlantsVsZombies._node.dataLoading.loading.gotoAndStop(1);
            PlantsVsZombies._node.dataLoading.loading2.gotoAndStop(1);
         }
         if(param2 != null)
         {
            param2();
         }
      }
      
      public static function showInviteWindow(param1:String, param2:Function) : void
      {
      }
      
      public static function showPlayer_otherInfo() : void
      {
         PlantsVsZombies._node["back"].visible = false;
         if(playerManager.getPlayerOther() == null)
         {
            return;
         }
         setHeadPic(PlantsVsZombies._node["player_other"]["pic"],PlantsVsZombies.getHeadPicUrl(playerManager.getPlayerOther().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,playerManager.getPlayerOther().getVipTime(),playerManager.getPlayerOther().getVipLevel());
         PlantsVsZombies._node["player_other"]["player_info"]["player_name"].text = playerManager.getPlayerOther().getNickname();
         if(PlantsVsZombies._node["player_other"]["num_charm"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player_other"]["num_charm"]);
         }
         if(PlantsVsZombies._node["player_other"]["num_level"] != null)
         {
            FuncKit.clearAllChildrens(PlantsVsZombies._node["player_other"]["num_level"]);
         }
         var _loc1_:Class = DomainAccess.getClass("gradeLev");
         var _loc2_:MovieClip = new _loc1_();
         _loc2_["num"].addChild(StringMovieClip.getStringImage(playerManager.getPlayerOther().getGrade() + "","Lev"));
         PlantsVsZombies._node["player_other"]["num_level"].addChild(_loc2_);
         PlantsVsZombies._node["player_other"]["num_level"].x = PlantsVsZombies._node["player_other"]["num_level_loc"].x + (GRADE_WIDTH - _loc2_.width) / 2;
         PlantsVsZombies._node["player_other"]["num_charm"].addChild(FuncKit.getNumEffect(playerManager.getPlayerOther().getCharm() + ""));
         PlantsVsZombies._node["player_other"]["num_charm"].getChildAt(0).x = (85 - PlantsVsZombies._node["player_other"]["num_charm"].getChildAt(0).width) / 2;
      }
      
      public static function showRechargeWindow(param1:String) : void
      {
         var _loc2_:RechargeWindow = new RechargeWindow();
         _loc2_.init(param1,toRecharge);
      }
      
      public static function showRushLoading() : void
      {
         var sec:int = 0;
         var t:Timer = null;
         var p:int = 0;
         var onTimer:Function = null;
         var onComp:Function = null;
         onTimer = function(param1:TimerEvent):void
         {
            if(PlantsVsZombies._node.rushLoading.pic != null)
            {
               FuncKit.clearAllChildrens(PlantsVsZombies._node.rushLoading.pic);
            }
            ++p;
            var _loc2_:DisplayObject = FuncKit.getNumEffect(int(p * 100 / sec) + "","Feared");
            _loc2_.x = -_loc2_.width + 20;
            PlantsVsZombies._node.rushLoading.pic.addChild(_loc2_);
         };
         onComp = function(param1:TimerEvent):void
         {
            PlantsVsZombies._node.rushLoading.loading.gotoAndStop(1);
            t.removeEventListener(TimerEvent.TIMER,onTimer);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            rush();
         };
         showDataLoading(false);
         PlantsVsZombies._node.rushLoading.visible = true;
         PlantsVsZombies._node.setChildIndex(PlantsVsZombies._node.rushLoading,PlantsVsZombies._node.numChildren - 1);
         PlantsVsZombies._node.rushLoading.loading.gotoAndPlay(1);
         sec = 20;
         t = new Timer(1000,sec);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         t.start();
         p = 0;
      }
      
      public static function showSystemErrorInfo(param1:String, param2:Function = null) : void
      {
         var temp:Class;
         var startX:int;
         var startY:int;
         var i:int = 0;
         var onTimer:Function = null;
         var onComp:Function = null;
         var str:String = param1;
         var backFun:Function = param2;
         onTimer = function(param1:TimerEvent):void
         {
            if(i <= 3)
            {
               systemInfo.y -= 3;
            }
            else if(i > 3 && i < 15)
            {
               systemInfo.y -= 0;
            }
            else
            {
               systemInfo.y -= 3;
            }
            ++i;
         };
         onComp = function(param1:TimerEvent):void
         {
            systemTimer.removeEventListener(TimerEvent.TIMER,onTimer);
            systemTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            systemTimer.stop();
            systemTimer = null;
            _node.removeChild(systemInfo);
            if(backFun != null)
            {
               backFun();
            }
         };
         if(systemTimer != null)
         {
            systemTimer.removeEventListener(TimerEvent.TIMER,onTimer);
            systemTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            systemTimer.stop();
            systemTimer = null;
            _node.removeChild(systemInfo);
         }
         temp = DomainAccess.getClass("systeminfo");
         systemInfo = new temp();
         systemInfo.str.text = str;
         TextFilter.MiaoBian(systemInfo.str,16777215,1,5,5);
         startX = (WIDTH - systemInfo.str.width) / 2;
         startY = HEIGHT / 2 - 60;
         systemTimer = new Timer(80,20);
         systemTimer.addEventListener(TimerEvent.TIMER,onTimer);
         systemTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         systemTimer.start();
         systemInfo.x = startX;
         systemInfo.y = startY;
         _node.addChild(systemInfo);
         i = 0;
      }
      
      public static function storageInfo(param1:Function = null) : void
      {
         var ul:URLLoader = null;
         var onListLoaded:Function = null;
         var loadOver:Function = param1;
         onListLoaded = function(param1:Event):void
         {
            var _loc3_:ActionWindow = null;
            ul.removeEventListener(Event.COMPLETE,onListLoaded);
            var _loc2_:XmlStorage = new XmlStorage(ul.data);
            showDataLoading(false);
            if(_loc2_.isSuccess())
            {
               playerManager.getPlayer().tools = _loc2_.getTools();
               playerManager.getPlayer().organisms = _loc2_.getOrganisms();
               playerManager.getPlayer().setArenaOrgs(_loc2_.getArenaOrgs());
               playerManager.getPlayer().setSeverBattleOrgs(_loc2_.getSeverBattleOrgs());
               playerManager.getPlayer().setStorageOrgGrade(_loc2_.getOrgGridsGrade());
               playerManager.getPlayer().setStorageOrgMoney(_loc2_.getOrgGridsMoney());
               playerManager.getPlayer().setStorageOrgNum(_loc2_.getOrgGridsNum());
               playerManager.getPlayer().setStorageToolGrade(_loc2_.getToolGridsGrade());
               playerManager.getPlayer().setStorageToolMoney(_loc2_.getToolGridsMoney());
               playerManager.getPlayer().setStorageToolNum(GlobalConstants.STORAGE_TOOL_PAGE * StorageWindow.MAX);
               if(loadOver != null)
               {
                  loadOver();
               }
            }
            else
            {
               if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  showRushLoading();
                  return;
               }
               _loc3_ = new ActionWindow();
               _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("main001"),_loc2_.error(),null,false);
            }
         };
         if(GlobalConstants.NEW_PLAYER)
         {
            playerManager.getPlayer().tools = helpN.getMyTools();
            if(helpN.nowType < HelpNovice.BATTLE_OK)
            {
               playerManager.getPlayer().organisms = new Array();
               playerManager.addOrganism(helpN.getMyOrgBeforeBattle());
            }
            else if(helpN.nowType == HelpNovice.COMP_CLOSE_EVOLUTION)
            {
               playerManager.getPlayer().organisms = helpN.getAllOrgAfterEvo();
            }
            else
            {
               playerManager.getPlayer().organisms = helpN.getMyOrgAfterBattle();
            }
            if(loadOver != null)
            {
               loadOver();
            }
            return;
         }
         APLManager.reset(3);
         showDataLoading(true);
         ul = new URLLoader();
         ul.load(new URLRequest(getURL("Warehouse",true)));
         ul.addEventListener(Event.COMPLETE,onListLoaded);
      }
      
      public static function toRecharge() : void
      {
         JSManager.toRecharge();
      }
      
      private static function getCode() : String
      {
         var _loc1_:String = "";
         return "/sig/" + MD5.hash("Y9d5n7St3w8K" + FuncKit.currentTimeMillis() + "1a2b3c4d5e6f");
      }
      
      private static function onLine() : void
      {
         var onTimer:Function = null;
         var call:Function = null;
         onTimer = function(param1:TimerEvent):void
         {
            fatigue();
         };
         var fatigue:Function = function():void
         {
            var _loc1_:ActionWindow = null;
            if(ExternalInterface.call("fatigue") == "0")
            {
               onLineTimer.removeEventListener(TimerEvent.TIMER,onTimer);
               onLineTimer.stop();
               onLineTimer = null;
               _loc1_ = new ActionWindow();
               _loc1_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("main002"),LangManager.getInstance().getLanguage("main003"),call,false);
            }
         };
         call = function():void
         {
            JSManager.gotoCardNo();
         };
         if(onLineTimer == null)
         {
            onLineTimer = new Timer(5 * 1000);
            onLineTimer.addEventListener(TimerEvent.TIMER,onTimer);
            onLineTimer.start();
         }
      }
      
      public static function upUserData() : void
      {
         var ul:URLLoader = null;
         var onListLoaded:Function = null;
         onListLoaded = function(param1:Event):void
         {
            var _loc3_:ActionWindow = null;
            var _loc4_:Array = null;
            ul.removeEventListener(Event.COMPLETE,onListLoaded);
            var _loc2_:XmlUserInfo = new XmlUserInfo(ul.data);
            if(!_loc2_.isSuccess())
            {
               if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  showRushLoading();
                  return;
               }
               _loc3_ = new ActionWindow();
               _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("main004"),_loc2_.error(),null,false);
            }
            else
            {
               playerManager.setPlayer(_loc2_.getPlayer());
               playerManager.setPlayerOther(playerManager.getPlayer());
               _loc4_ = _loc2_.getFriends(playerManager.getPlayer());
               _friendsWindow.setFriends(_loc4_);
               storageInfo(null);
            }
         };
         ul = new URLLoader();
         ul.load(new URLRequest(getURL("default/user")));
         ul.addEventListener(Event.COMPLETE,onListLoaded);
      }
      
      public function addFriendsWindow() : void
      {
         _friendsWindow = new FriendsWindow();
         _node.addChild(_friendsWindow);
      }
      
      public function addPlayerEvent() : void
      {
         var onPlayerClick:Function = null;
         onPlayerClick = function(param1:MouseEvent):void
         {
            var callBack:Function;
            var recharge:RechargeWindow = null;
            var str:String = null;
            var e:MouseEvent = param1;
            firstpage.getTaskJianTou().visible = false;
            playSounds(SoundManager.BUTTON2);
            switch(e.currentTarget.name)
            {
               case "players":
                  playerManager.changeNowFlowers(playerManager.getPlayer());
                  if(_playerInfoWindow == null)
                  {
                     _playerInfoWindow = new PlayerInfoWindow();
                  }
                  _playerInfoWindow.show();
                  break;
               case "shop":
                  if(!MenuButtonManager.instance.checkBtnUpLimit("shop",playerManager.getPlayer().getGrade()))
                  {
                     return;
                  }
                  new ShopWindow(upDateTask);
                  break;
               case "hunt":
                  if(PlantsVsZombies._node["player"]["player_info"]["player_zhi"].currentFrame == 2)
                  {
                     if(5 - playerManager.getPlayer().getGardenChaCount() > 0)
                     {
                        new ChallengePropWindow(ChallengePropWindow.TYPE_GARDEN);
                     }
                     else
                     {
                        showSystemErrorInfo("挑战次数已满");
                     }
                  }
                  else
                  {
                     new ChallengePropWindow(ChallengePropWindow.TYPE_ONE);
                  }
                  break;
               case "recharge":
                  callBack = function():void
                  {
                     toRecharge();
                  };
                  recharge = new RechargeWindow();
                  str = "金券可在商城购买进化素材、品质书、高级技能书等强力道具，是否充值？";
                  recharge.init(str,callBack,1);
            }
         };
         _node["player"]["players"].addEventListener(MouseEvent.CLICK,onPlayerClick);
         _node["player"]["shop"].addEventListener(MouseEvent.CLICK,onPlayerClick);
         _node["player"]["hunt"].addEventListener(MouseEvent.CLICK,onPlayerClick);
         _node["player"]["recharge"].addEventListener(MouseEvent.CLICK,onPlayerClick);
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onLoaded(param1:ForeletEvent) : void
      {
         this.loadingloader.removeEventListener(ForeletEvent.COMPLETE,this.onLoaded);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Task_rpc = new Task_rpc();
         _task = _loc3_.getTask(param2);
         if(firstpage != null)
         {
            firstpage.showTaskType();
         }
         showDataLoading(false);
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            showDataLoading(false);
         }
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var _loc3_:XML = null;
         if(param1 == 0)
         {
            this.initConfig(param2 as String);
         }
         else if(param1 == 1)
         {
            _loc3_ = new XML(param2);
            MenuButtonManager.instance.decodeconfig(_loc3_);
         }
      }
      
      public function upDateTask() : void
      {
         if(playerManager.getPlayer().IsNewTaskSystem)
         {
            NewTaskCtrl.getNewTaskCtrl().getTaskInfo(firstpage.showTaskType);
            return;
         }
         if(PlantsVsZombies._task != null && PlantsVsZombies._task.getStatus() == Task.STATUS_1)
         {
            return;
         }
         showDataLoading(true);
         this.netConnectionSend(getRPCUrl(),AMFConnectionConstants.RPC_TASK_INFO,0);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function HelpOver() : void
      {
         this.isHelpOver = true;
         showDataLoading(true);
         if(firstpage != null)
         {
            firstpage.showTask();
         }
      }
      
      private function NewUserLoaderUI() : void
      {
         var _loc1_:UILoaderManager = new UILoaderManager();
         _loc1_.start(this as DisplayObjectContainer,this.m_configxml,GlobalConstants.PVZ_RES_BASE_URL);
         this.addEventListener(ForeletEvent.ALL_COMPLETE,this.onComplete);
         this.show();
      }
      
      private function addButtonToButtonMag() : void
      {
         _node["right"]["shop"].visible = false;
         _node["right"]["picture"].visible = false;
         _node["autoGainIcon"].visible = false;
         _node["right"]["storage"].visible = false;
         _node["right"]["compound"].visible = false;
         MenuButtonManager.instance.addButtonToDic(_node["right"]["shop"].name,_node["right"]["shop"]);
         MenuButtonManager.instance.addButtonToDic(_node["right"]["picture"].name,_node["right"]["picture"]);
         MenuButtonManager.instance.addButtonToDic(_node["autoGainIcon"].name,_node["autoGainIcon"]);
         MenuButtonManager.instance.addButtonToDic(_node["right"]["storage"].name,_node["right"]["storage"]);
         MenuButtonManager.instance.addButtonToDic(_node["right"]["compound"].name,_node["right"]["compound"]);
      }
      
      private function addPlayer_otherBackBtEvent() : void
      {
         PlantsVsZombies._node["player_other_back"].addEventListener(MouseEvent.CLICK,this.player_otherBackBtClick);
      }
      
      private function getUILoader() : UILoader
      {
         if(UILoader.unLoaded.keys.length == 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE));
            return null;
         }
         return UILoader.unLoaded[UILoader.unLoaded.keys.getItemAt(0)];
      }
      
      private function init() : void
      {
         this.addPlayer_otherBackBtEvent();
         this.setWindowsButton();
         this.userInfoMiaobian();
         setToFirstPageButtonVisible(false);
         _node["back"].addEventListener(MouseEvent.CLICK,this.setToFirstPageButtonEvent);
         this.showHelp();
      }
      
      private function initConfig(param1:String) : void
      {
         var src:String = param1;
         this.m_configxml = new XML(src);
         with(GlobalConstants)
         {
            RANK_NUM = m_configxml.base.rank;
            PVZ_VERSION = m_configxml.version;
            LANGUAGE_VERSION = m_configxml.base.language;
            LOADING_VERSION = m_configxml.loading_version;
            STORAGE_TOOL_PAGE = m_configxml.setting.storage.toolpage;
            ORG_RES_VERSION = m_configxml.org_version;
            PVZ_RES_VERSION = m_configxml.pvz_version;
            if(m_configxml.base.isWeb == "true")
            {
               PVZ_WEB_URL = this.loaderInfo.parameters["base_url"];
            }
            else
            {
               VersionManager.getVersionManagerInstance.setVersionType(m_configxml.version);
            }
         }
         code = getCode();
         this.loadNew();
         this.tabChildren = false;
      }
      
      private function loadBaseConfig() : void
      {
         showDataLoading(true);
         configLoader = new ConfigURLLoader();
         XmlToolsConfig.getInstance();
         XmlOrganismConfig.getInstance();
         XmlQualityConfig.getInstance();
         XmlHolePrizesConfig.getInstance();
         XmlGeniusDataConfig.getInstance();
         XmlChangeJewelConfig.getInstance();
         XmlUIConfig.getInstance();
         LangManager.getInstance().doLoad(LangManager.MODE_LANGUAGE);
         configLoader.addEventListener("AllLoadOver",this.onAllConfigLoadOver);
      }
      
      private function loadNew() : void
      {
         var ul:URLLoader = null;
         var onListLoaded:Function = null;
         onListLoaded = function(param1:Event):void
         {
            ul.removeEventListener(Event.COMPLETE,onListLoaded);
            if(ul.data == 1)
            {
               loadUI(true);
            }
            else
            {
               loadUI(false);
            }
         };
         ul = new URLLoader();
         ul.load(new URLRequest(getURL("default/isnew")));
         ul.addEventListener(Event.COMPLETE,onListLoaded);
      }
      
      private function loadUI(param1:Boolean) : void
      {
         this.loadingFore = new Loading(this,GlobalConstants.PVZ_RES_BASE_URL,this.m_configxml.loading_version);
         this.loadingFore.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
         this.loadloader = new UILoader(this,GlobalConstants.PVZ_RES_BASE_URL + "UILibs/pvz" + this.m_configxml.pvz_version + ".swf",false,false,"UI");
         if(param1)
         {
            this.loadloader.addEventListener(ForeletEvent.COMPLETE,this.onLoadLoadingNew);
         }
         else
         {
            this.loadloader.addEventListener(ForeletEvent.COMPLETE,this.onLoadLoading);
         }
         this.loadloader.doLoad();
      }
      
      private function loadUserInfo(param1:Boolean = true, param2:Function = null) : void
      {
         var ul:URLLoader = null;
         var onListLoaded:Function = null;
         var b:Boolean = param1;
         var backFun:Function = param2;
         onListLoaded = function(param1:Event):void
         {
            var _loc3_:ActionWindow = null;
            var _loc4_:Array = null;
            var _loc5_:Boolean = false;
            ul.removeEventListener(Event.COMPLETE,onListLoaded);
            var _loc2_:XmlUserInfo = new XmlUserInfo(ul.data);
            if(!_loc2_.isSuccess())
            {
               if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  showRushLoading();
                  return;
               }
               _loc3_ = new ActionWindow();
               _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("main004"),_loc2_.error(),null,false);
            }
            else
            {
               playerManager.setPlayer(_loc2_.getPlayer());
               playerManager.setPlayerOther(playerManager.getPlayer());
               _loc4_ = _loc2_.getFriends(playerManager.getPlayer());
               _friendsWindow.setFriends(_loc4_);
               _loc5_ = _loc2_.getFirstLogin() == 0 ? false : true;
               GlobalConstants.NEW_PLAYER = playerManager.getPlayer().getIsNew();
               if(b)
               {
                  if(!GlobalConstants.NEW_PLAYER)
                  {
                     if(isHelpOver)
                     {
                        storageInfo(show);
                     }
                     else
                     {
                        storageInfo(null);
                     }
                  }
               }
               if(GlobalConstants.NEW_PLAYER)
               {
                  playerManager.getPlayer().setMoney(HelpNovice.INIT_MONEY);
               }
               setAPL(GlobalConstants.NEW_PLAYER);
               setUserInfos(true);
               if(_loc5_)
               {
                  firstLogin = 0;
               }
               else if(firstLogin != 2)
               {
                  firstLogin = 1;
               }
               if(GlobalConstants.NEW_PLAYER)
               {
                  firstLogin = 2;
               }
               if(backFun != null)
               {
                  backFun();
               }
               if(GlobalConstants.NEW_PLAYER)
               {
                  NewUserLoaderUI();
               }
               if(firstpage != null)
               {
                  firstpage.showEveryPrizesWindow();
                  firstpage.setPrizeLightEffect();
                  firstpage.setAutoClip();
                  MenuButtonManager.instance.updateAllButtonsWhenGameInit(playerManager.getPlayer().getGrade());
                  firstpage.setFirstRecharge(playerManager.getPlayer().getFirstRecharge());
                  firstpage.setSeverBattleBtnStaus(playerManager.getPlayer().getSeverBattleStaus());
                  firstpage.setActivtyBtnStaus(playerManager.getPlayer().getActivtyBtnStaus());
                  firstpage._vgroupLayout.layout();
                  firstpage.setActvityTipVisible();
                  if(playerManager.getPlayer().getGrade() >= 20)
                  {
                     NoticeManager.getInstance.initNotice(NoticeManager.DYNAMIC_MESSAGES_MAIN,80,100);
                  }
               }
               if(GlobalConstants.PVZ_VERSION == VersionManager.WEB_VERSION)
               {
                  onLine();
               }
            }
         };
         showDataLoading(true);
         ul = new URLLoader();
         ul.load(new URLRequest(getURL("default/user")));
         ul.addEventListener(Event.COMPLETE,onListLoaded);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         FuncKit.clearAllChildrens(this);
         showDataLoading(false);
         this.addPlayerEvent();
         this.addButtonToButtonMag();
         SkillManager.getInstance;
         setGoHomeButtonVisible(false);
         setBackLastFloorButtonVisible(false);
         setPageButtonVisible(false);
         setDoworkVisible(false);
         PlantsVsZombies._node.isInto.visible = false;
         _node.rushLoading.visible = false;
         _node["player_other"].visiblele = false;
         _node["back"].visible = false;
         this.addFriendsWindow();
         this.toFirstPage();
         GameManager.getInstance().init(this,_node);
         this.loadBaseConfig();
      }
      
      private function onAllConfigLoadOver(param1:Event) : void
      {
         configLoader.removeEventListener("AllLoadOver",this.onAllConfigLoadOver);
         showDataLoading(false);
         this.loadUserInfo(true,this.init);
      }
      
      private function onComplete(param1:ForeletEvent) : void
      {
         isAllLoadOver = true;
         if(GlobalConstants.NEW_PLAYER)
         {
            showDataLoading(false);
         }
      }
      
      private function onLoadLoading(param1:ForeletEvent) : void
      {
         this.loadloader.removeEventListener(ForeletEvent.COMPLETE,this.onLoadLoading);
         _node = param1.parameter as MovieClip;
         var _loc2_:UILoaderManager = new UILoaderManager();
         _loc2_.start(this as DisplayObjectContainer,this.m_configxml,GlobalConstants.PVZ_RES_BASE_URL);
         isAllLoadOver = true;
      }
      
      private function onLoadLoadingNew(param1:ForeletEvent) : void
      {
         this.loadloader.removeEventListener(ForeletEvent.COMPLETE,this.onLoadLoadingNew);
         _node = param1.parameter as MovieClip;
         var _loc2_:UILoaderManager = new UILoaderManager();
         _loc2_.setIsNew(true);
         _loc2_.start(this as DisplayObjectContainer,this.m_configxml,GlobalConstants.PVZ_RES_BASE_URL);
      }
      
      private function onOneComplete(param1:ForeletEvent) : void
      {
         var _loc2_:UILoader = param1.target as UILoader;
         _loc2_.removeEventListener(ForeletEvent.COMPLETE,this.onOneComplete);
         _loc2_ = null;
         this.showNextProgress();
      }
      
      private function player_otherBackBtClick(param1:MouseEvent) : void
      {
         playerManager.setPlayerOther(playerManager.getPlayer());
         PlantsVsZombies._node["right"].visible = true;
         PlantsVsZombies._node["player_other"].visible = false;
         PlantsVsZombies._node["player_other_back"].visible = false;
         PlantsVsZombies._friendsWindow.clearAllNodesSelect(playerManager.getPlayer());
         Firstpage.setBtnVisible = true;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(PlantsVsZombies._node.getChildByName("autoGain") != null)
         {
            AutoGainWindow.getAutoGainInstance._func = null;
            AutoGainWindow.getAutoGainInstance.dispose();
         }
         this.toFirstPage();
      }
      
      private function setAPL(param1:Boolean) : void
      {
         APLManager.init(!param1);
      }
      
      private function setToFirstPageButtonEvent(param1:MouseEvent) : void
      {
         Firstpage.setBtnVisible = true;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         SeverBattleControl.getInstance().distroy();
         if(PlantsVsZombies._node.getChildByName("autoGain") != null)
         {
            AutoGainWindow.getAutoGainInstance._func = null;
            AutoGainWindow.getAutoGainInstance.dispose();
         }
         this.toFirstPage();
      }
      
      private function setWindowsButton() : void
      {
         _node["right"]["shop"].addEventListener(MouseEvent.CLICK,this.setWindowsButtonEvent);
         _node["right"]["storage"].addEventListener(MouseEvent.CLICK,this.setWindowsButtonEvent);
         _node["right"]["compound"].addEventListener(MouseEvent.CLICK,this.setWindowsButtonEvent);
         _node["right"]["picture"].addEventListener(MouseEvent.CLICK,this.setWindowsButtonEvent);
      }
      
      private function setWindowsButtonEvent(param1:MouseEvent) : void
      {
         firstpage.getTaskJianTou().visible = false;
         playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "storage")
         {
            TeachHelpManager.I.hideArrow();
            new StorageWindow(this.showHelpWindow,this.upDateTask);
         }
         else if(param1.currentTarget.name == "shop")
         {
            new ShopWindow(this.upDateTask);
         }
         else if(param1.currentTarget.name == "compound")
         {
            TeachHelpManager.I.hideArrow();
            new ComposeWindowNew(this.showHelpWindow,this.upDateTask,false,false,null);
         }
         else if(param1.currentTarget.name == "picture")
         {
            new IHandbookWindow();
         }
      }
      
      private function show() : void
      {
         if(UILoader.unLoaded.keys.length == 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE));
         }
         else
         {
            this.showNextProgress();
         }
      }
      
      private function showAvertWallowWindow() : void
      {
         var _loc1_:AvertWallowWindow = new AvertWallowWindow(this.showHelpWindow);
         _loc1_.show();
      }
      
      private function showHelp() : void
      {
         if(GlobalConstants.NEW_PLAYER)
         {
            if(helpN == null)
            {
               helpN = new HelpNovice(GlobalConstants.PVZ_RES_BASE_URL);
               firstpage.playNameGuide();
               this.showAvertWallowWindow();
            }
            helpN.clear();
            helpN.show(HelpNovice.FIRST_OPEN_COMP,_node as DisplayObjectContainer);
            helpN.show(HelpNovice.FIRST_ENTER_GARDEN,_node as DisplayObjectContainer);
         }
      }
      
      private function showHelpWindow() : void
      {
         helpN.clear();
         var _loc1_:HelpWindow = new HelpWindow(this.loadUserInfo,this.HelpOver);
         _loc1_.show(helpN.nowType);
      }
      
      private function showNextProgress() : void
      {
         var _loc1_:UILoader = this.getUILoader();
         if(_loc1_ != null)
         {
            _loc1_.addEventListener(ForeletEvent.COMPLETE,this.onOneComplete);
            PlantsVsZombies._node.dataLoading.visible = this.isHelpOver;
            _loc1_.setListener(PlantsVsZombies._node.dataLoading);
         }
      }
      
      private function toFirstPage() : void
      {
         _node["_left_light"].visible = false;
         _node["_right_light"].visible = false;
         _node["_toOtherHunting"].visible = false;
         _node["autoGainIcon"].visible = false;
         _node["autoGainIcon"].stop();
         setPageButtonVisible(false);
         _node.isInto.visible = false;
         _node.isInto.gotoAndStop(1);
         setBackLastFloorButtonVisible(false);
         setGoHomeButtonVisible(false);
         setPlayerInfoVisible(true);
         setFriendWindowVisible(false);
         setToFirstPageButtonVisible(false);
         changePlayer_other();
         setWindowsButtonsVisible(true);
         this.stage.frameRate = 12;
         setDoworkVisible(false);
         _friendsWindow.setType(FriendsWindow.FIRSTPAGE);
         _node["draw"].x = 0;
         _node["draw"].y = 0;
         setUserInfos();
         if(_node["draw"].numChildren > 0)
         {
            _node["draw"].removeChildAt(0);
         }
         if(firstpage == null)
         {
            firstpage = new Firstpage(_node["draw"]);
         }
         firstpage.show();
         this.showHelp();
      }
      
      private function toHunting() : void
      {
         if(this.isHelpOver && isAllLoadOver)
         {
            this.removeEventListener(ForeletEvent.ALL_COMPLETE,this.onComplete);
            firstpage.toHunting();
         }
      }
      
      private function userInfoMiaobian() : void
      {
         TextFilter.MiaoBian(_node["player"]["player_info"]["player_name"],16777164,1,5,5);
         TextFilter.MiaoBian(_node["player"]["player_info"]["player_hunt"],16777164);
         TextFilter.MiaoBian(_node["player"]["player_info"]["player_money"],16777164);
         TextFilter.MiaoBian(_node["player"]["player_info"]["player_ymoney"],16777164);
         TextFilter.MiaoBian(_node["player_other"]["player_info"]["player_name"],16777164);
      }
   }
}

