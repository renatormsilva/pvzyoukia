package pvz.garden.fore
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import constants.URLConnectionConstants;
   import entity.GardenDoworkEntity;
   import entity.Organism;
   import entity.Player;
   import entity.PlayerUpInfo;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import loading.UILoading;
   import manager.APLManager;
   import manager.LangManager;
   import manager.OrganismManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import node.Icon;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import pvz.garden.manager.MapManager;
   import pvz.garden.node.GardenOrgNode;
   import pvz.garden.rpc.GardenMonster;
   import pvz.garden.rpc.Garden_rpc;
   import pvz.garden.window.GardenGridsWindow;
   import pvz.garden.window.GardenOrgsWindow;
   import pvz.garden.xml.XmlGardenOrgs;
   import pvz.help.HelpNovice;
   import pvz.vip.AutoGainWindow;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.PlayerUpGradeWindow;
   import xmlReader.XmlBaseReader;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class Garden extends Sprite implements IConnection, IURLConnection, IDestroy
   {
      
      public static const BOLIVAR:int = 0;
      
      public static const GEM:int = 2;
      
      public static const GOLD:int = 1;
      
      public static const GRID_H:int = 110;
      
      public static const GRID_W:int = 80;
      
      public static const HEIGTh:int = 535;
      
      public static const MY_TEMP_X:int = 4;
      
      public static const PRIZES_NUM:int = 23;
      
      public static const WIDTH:int = 760;
      
      private static const RPC_GAIN:int = 11;
      
      private static const RPC_INTO:int = 10;
      
      private static const RPC_REMOVE_STATE_FERTILISER:int = 2;
      
      private static const RPC_REMOVE_STATE_WATER:int = 1;
      
      private static const URL_INIT:int = 4;
      
      private var _uiLoad:UILoading = null;
      
      internal var _mc:MovieClip;
      
      private var _node:Object;
      
      internal var dis:MovieClip = null;
      
      internal var doworkOrgs:Array = null;
      
      internal var doworkType:int = 0;
      
      internal var friendMapManager:MapManager;
      
      internal var friendMapOrgs:Array;
      
      internal var friend_num:int = 0;
      
      internal var gardenId:Number = 0;
      
      internal var gardenMaster:String = "";
      
      internal var gardenTimer:Timer;
      
      internal var gardenrpc:Garden_rpc = null;
      
      internal var intoBackFun:Function = null;
      
      internal var intoOrg:Organism = null;
      
      internal var isWorking_fertilizer:Boolean;
      
      internal var isWorking_gainAndSteal:Boolean;
      
      internal var isWorking_water:Boolean;
      
      internal var myMapManager:MapManager;
      
      internal var myMapOrgs:Array;
      
      internal var orgsWindow:GardenOrgsWindow = null;
      
      internal var playerUpGradeWindow:PlayerUpGradeWindow;
      
      internal var playerUpInfos:Array = null;
      
      internal var upIndex:int = -1;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var MapMonsterOrgs:Array;
      
      internal var currPayler:Player;
      
      public function Garden(param1:Object)
      {
         super();
         this._node = param1;
         this.doLoad();
      }
      
      private function doLoad() : void
      {
         this._uiLoad = new UILoading(PlantsVsZombies._node,GlobalConstants.PVZ_RES_BASE_URL,"config/load/garden.xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.removeEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
         this._uiLoad.remove();
         this._uiLoad = null;
         var _loc2_:Class = DomainAccess.getClass("garden");
         this._mc = new _loc2_();
         this._mc.visible = false;
         this.addBtEvent();
         this.addPageButtonEvent();
         PlantsVsZombies._node["autoGainIcon"].visible = false;
         this._node.addChild(this._mc);
         this.clearFlap();
         this.clearOrgNodes();
         this.init(this.playerManager.getPlayerOther());
      }
      
      private function setVipAutoGain() : void
      {
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies._node["autoGainIcon"].visible = false;
         }
         if(MenuButtonManager.instance.checkBtnUpLimit("_bt_vip",this.playerManager.getPlayer().getGrade()))
         {
            PlantsVsZombies._node["autoGainIcon"].visible = true;
         }
         PlantsVsZombies._node["autoGainIcon"].buttonMode = true;
         PlantsVsZombies._node["autoGainIcon"].stop();
         PlantsVsZombies._node["autoGainIcon"].addEventListener(MouseEvent.ROLL_OVER,this.autoGainOver);
         PlantsVsZombies._node["autoGainIcon"].addEventListener(MouseEvent.ROLL_OUT,this.autoGainOut);
         PlantsVsZombies._node["autoGainIcon"].addEventListener(MouseEvent.CLICK,this.autoGainClick);
         if(this.playerManager.getPlayer().getVipAutoGain())
         {
            AutoGainWindow.getAutoGainInstance._func = this.autoGainClip;
            AutoGainWindow.getAutoGainInstance.initUI();
         }
      }
      
      private function autoGainOver(param1:MouseEvent) : void
      {
         PlantsVsZombies._node["autoGainIcon"].gotoAndPlay(1);
      }
      
      private function autoGainOut(param1:MouseEvent) : void
      {
         PlantsVsZombies._node["autoGainIcon"].gotoAndStop(1);
      }
      
      private function autoGainClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         AutoGainWindow.getAutoGainInstance._func = this.autoGainClip;
         AutoGainWindow.getAutoGainInstance.initUI();
      }
      
      private function autoGainClip() : void
      {
         var onEventFrame:Function = null;
         onEventFrame = function(param1:Event):void
         {
            if(PlantsVsZombies._node["autoGainIcon"].currentFrame == PlantsVsZombies._node["autoGainIcon"].totalFrames)
            {
               PlantsVsZombies._node["autoGainIcon"].removeEventListener(Event.ENTER_FRAME,onEventFrame);
               PlantsVsZombies._node.mouseEnabled = true;
               PlantsVsZombies._node.mouseChildren = true;
               PlantsVsZombies._node["autoGainIcon"].gotoAndStop(1);
            }
         };
         PlantsVsZombies._node["autoGainIcon"].gotoAndPlay(17);
         PlantsVsZombies.playSounds(SoundManager.MONEY);
         PlantsVsZombies._node["autoGainIcon"].addEventListener(Event.ENTER_FRAME,onEventFrame);
         PlantsVsZombies._node.mouseEnabled = false;
         PlantsVsZombies._node.mouseChildren = false;
      }
      
      public function allOrgNodeStop() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._mc["org_1"].numChildren)
         {
            if(this._mc["org_1"].getChildAt(_loc1_) is GardenOrgNode)
            {
               (this._mc["org_1"].getChildAt(_loc1_) as GardenOrgNode).stopOrg();
            }
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._mc["org_2"].numChildren)
         {
            (this._mc["org_2"].getChildAt(_loc2_) as GardenOrgNode).stopOrg();
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._mc["org_3"].numChildren)
         {
            (this._mc["org_3"].getChildAt(_loc3_) as GardenOrgNode).stopOrg();
            _loc3_++;
         }
      }
      
      public function clearFlap() : void
      {
         var _loc1_:Class = DomainAccess.getClass("money_" + BOLIVAR);
         var _loc2_:Class = DomainAccess.getClass("money_" + GEM);
         var _loc3_:Class = DomainAccess.getClass("money_" + GOLD);
         if(this._mc.numChildren < 1)
         {
            return;
         }
         var _loc4_:* = int(this._mc.numChildren - 1);
         while(_loc4_ > -1)
         {
            if(this._mc.getChildAt(_loc4_) is _loc3_ || this._mc.getChildAt(_loc4_) is _loc1_ || this._mc.getChildAt(_loc4_) is _loc2_)
            {
               this._mc.removeChildAt(_loc4_);
            }
            _loc4_--;
         }
      }
      
      public function clearOrgNodes() : void
      {
         FuncKit.clearAllChildrens(this._mc["org_1"]);
         FuncKit.clearAllChildrens(this._mc["org_2"]);
         FuncKit.clearAllChildrens(this._mc["org_3"]);
      }
      
      public function destroy() : void
      {
         PlantsVsZombies.ChangeUserHuntNum();
         this.clearOrgNodes();
         this.removeBtEvent();
         this.clearTimer();
         this.removePageButtonEvent();
      }
      
      public function fetchOut() : void
      {
         var showHelp:Function = null;
         showHelp = function():void
         {
            if(GlobalConstants.NEW_PLAYER)
            {
               PlantsVsZombies.helpN.show(HelpNovice.GARDEN_CHOOSE_ORG,PlantsVsZombies._node as DisplayObjectContainer);
            }
         };
         PlantsVsZombies._node.isInto.visible = false;
         PlantsVsZombies._node.isInto.gotoAndStop(1);
         if(this.orgsWindow == null)
         {
            this.orgsWindow = new GardenOrgsWindow(PlantsVsZombies.setDoworkVisible);
            this.orgsWindow.init();
         }
         if(this.gardenId == this.playerManager.getPlayer().getId())
         {
            this.orgsWindow.setWindowClick(this._mc,GardenGridsWindow.MINE,this.myMapManager,this.doWorkInto,this.fetchOut,this.orgsWindow.hidden,this.showIntoGarden);
         }
         else
         {
            this.orgsWindow.setWindowClick(this._mc,GardenGridsWindow.FRIEND,this.friendMapManager,this.doWorkInto,this.fetchOut,this.orgsWindow.hidden,this.showIntoGarden);
         }
         PlantsVsZombies.setDoworkVisible(false);
         this.orgsWindow.show(showHelp);
      }
      
      public function getHeigth() : int
      {
         if(this._mc == null)
         {
            return 0;
         }
         return this._mc.height;
      }
      
      public function getWidth() : int
      {
         if(this._mc == null)
         {
            return 0;
         }
         return this._mc.width;
      }
      
      public function init(param1:Player) : void
      {
         this.currPayler = param1;
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.clear();
         }
         this.isWorking_fertilizer = false;
         this.isWorking_gainAndSteal = false;
         this.isWorking_water = false;
         this.clearOrgNodes();
         this.show();
         PlantsVsZombies.showDataLoading(true);
         this.playerManager.setPlayerOther(param1);
         PlantsVsZombies.changePlayer_other();
         this._node.x = -65;
         this._node.y = -55;
         this.gardenId = param1.getId();
         this.gardenMaster = param1.getNickname();
         this.showLight(param1);
         if(GlobalConstants.NEW_PLAYER && PlantsVsZombies.helpN.nowType == HelpNovice.GARDEN_ENTER_CHOOSEORG)
         {
            this.gotoGardenFirst();
         }
         else if(GlobalConstants.NEW_PLAYER && PlantsVsZombies.helpN.nowType == HelpNovice.GARDEN_GOTO_FRIEND)
         {
            this.gotoGardenOther();
         }
         else
         {
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_GARDEN_INIT + this.gardenId),URL_INIT);
         }
         this.setVipAutoGain();
      }
      
      public function upGarden() : void
      {
         this.init(this.currPayler);
      }
      
      public function isSteal(param1:Array) : Boolean
      {
         if(param1 == null || param1.length < 1)
         {
            return false;
         }
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if((param1[_loc2_] as GardenOrgNode).getOrg().getIsSteal() == 1)
            {
               return true;
            }
            if((param1[_loc2_] as GardenOrgNode).getOrg().getOwner() == this.playerManager.getPlayer().getNickname())
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function loadFriends(param1:Player) : void
      {
         if(this.playerManager.isLoadFriend(param1))
         {
            PlantsVsZombies._friendsWindow.readFriends();
         }
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == RPC_INTO)
         {
            PlantsVsZombies.showDataLoading(true);
            if(rest is Array && rest.length == 4)
            {
               _loc5_.callOOOO(param2,param3,rest[0],rest[1],rest[2],rest[3]);
            }
         }
         else if(param3 == RPC_GAIN)
         {
            _loc5_.callO(param2,param3,rest[0]);
         }
         else if(param3 == RPC_REMOVE_STATE_FERTILISER || param3 == RPC_REMOVE_STATE_WATER)
         {
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:GardenOrgNode = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         this.gardenrpc = new Garden_rpc();
         if(param1 == RPC_INTO)
         {
            if(param2.status == "success")
            {
               PlantsVsZombies.showDataLoading(false);
               if(this.intoOrg == null)
               {
                  return;
               }
               _loc3_ = false;
               this.intoOrg.setNextType(param2.state.type);
               this.intoOrg.setTypeTime(param2.state.time);
               PlantsVsZombies.playSounds(SoundManager.INTO);
               this.intoOrg.setGardenId(this.gardenId);
               this.intoOrg.setOwner(this.playerManager.getPlayer().getNickname());
               this.intoOrg.setGainTime(param2.ripe_time);
               PlantsVsZombies.changeMoneyOrExp(param2.user.exp,PlantsVsZombies.EXP);
               if(this.playerManager.getPlayer().getId() == this.gardenId)
               {
                  this.myMapManager.addOrg(this.intoOrg);
                  _loc3_ = true;
               }
               else
               {
                  this.friendMapManager.addOrg(this.intoOrg);
               }
               _loc4_ = new GardenOrgNode(this.intoOrg,null,this.gardenMaster,this.gardenId);
               _loc4_.setState(GardenOrgNode.PUT);
               _loc4_.x = this.operationOrgPoint(this.intoOrg,_loc3_).x;
               _loc4_.y = this.operationOrgPoint(this.intoOrg,_loc3_).y;
               if(this.intoOrg.getY() == 0)
               {
                  this._mc["org_1"].addChild(_loc4_);
               }
               else if(this.intoOrg.getY() == 1)
               {
                  this._mc["org_2"].addChild(_loc4_);
               }
               else if(this.intoOrg.getY() == 2)
               {
                  this._mc["org_3"].addChild(_loc4_);
               }
               _loc4_.playLight();
               if(this.intoBackFun != null)
               {
                  this.intoBackFun();
               }
               if(param2.user.is_up)
               {
                  this.playerUp(param2.user,this.gardenrpc);
               }
               _loc4_.showGainEffect(param2.user.money,param2.user.exp,this._mc);
               this.showExpFull(param2.user.exp);
               if(this.playerManager.getPlayer() != this.playerManager.getPlayerOther())
               {
                  PlantsVsZombies._friendsWindow.changePlayer(this.playerManager.getPlayerOther(),1);
               }
            }
            else if(param2.error == XmlBaseReader.GARDEN_ERROR1)
            {
               PlantsVsZombies.showDataLoading(false);
               _loc5_ = new Array();
               _loc5_ = this.gardenrpc.addOrgException(param2.organism_all);
               if(_loc5_.length < 1)
               {
                  return;
               }
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  this.addOrg(_loc5_[_loc6_],false);
                  this.friendMapManager.addOrg(_loc5_[_loc6_]);
                  this.clearOrgNodes();
                  this.showOrgs();
                  _loc6_++;
               }
            }
            this.showIntoGarden();
         }
         else if(param1 == RPC_REMOVE_STATE_FERTILISER || param1 == RPC_REMOVE_STATE_WATER)
         {
            _loc7_ = this.gardenrpc.getOrgsWorks(param2.success,param2.failure,param2.exp,param2.money);
            this.clearWithOutOrgs(this.doworkOrgs,_loc7_,param1);
            this.showOrgsDowork(_loc7_,param1,this.playerUp);
            if(param1 == OrganismManager.WATER)
            {
               this.isWorking_water = false;
            }
            else if(param1 == OrganismManager.FERTILISER)
            {
               this.isWorking_fertilizer = false;
            }
            this.playerUp(param2,this.gardenrpc);
         }
         else if(param1 == RPC_GAIN)
         {
            _loc8_ = this.gardenrpc.getOrgsWorksGainAndSteal(param2.out.success,param2.out.failure,param2.steal.success,param2.steal.failure,param2.exp);
            this.clearWithOutOrgs(this.doworkOrgs,_loc8_);
            this.showOrgsDowork(_loc8_,OrganismManager.GAIN,this.playerUp);
            this.isWorking_gainAndSteal = false;
            this.playerUp(param2,this.gardenrpc);
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("garden002"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         if(param1 == URL_INIT)
         {
            this.showInit(param2);
         }
      }
      
      public function showExpFull(param1:int) : void
      {
         if(param1 != 0)
         {
            return;
         }
         if(!this.playerManager.getPlayer().getExpFull())
         {
            return;
         }
         this.playerManager.getPlayer().setExpFull(false);
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden001"));
      }
      
      public function showGarden() : void
      {
         this.initMapManager();
      }
      
      public function showIntoGarden() : void
      {
         var myNum:int = 0;
         var i:int = 0;
         var fNum:int = 0;
         var j:int = 0;
         var isNotLightOrg:Function = function():Boolean
         {
            if(playerManager.getPlayer().getAllOrganism() == null || playerManager.getPlayer().getAllOrganism().length < 1)
            {
               return false;
            }
            var _loc1_:int = 0;
            while(_loc1_ < playerManager.getPlayer().getAllOrganism().length)
            {
               if((playerManager.getPlayer().getAllOrganism()[_loc1_] as Organism).getGardenId() == 0)
               {
                  return true;
               }
               _loc1_++;
            }
            return false;
         };
         PlantsVsZombies._node.isInto.visible = false;
         PlantsVsZombies._node.isInto.gotoAndStop(1);
         if(GlobalConstants.NEW_PLAYER)
         {
            return;
         }
         if(this.playerManager.getPlayer().getNowflowerpotNum() < this.playerManager.getPlayer().getFlowerpotNum() && Boolean(isNotLightOrg()))
         {
            if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
            {
               if(this.myMapOrgs == null || this.myMapOrgs.length < 1)
               {
                  PlantsVsZombies._node.isInto.visible = true;
                  PlantsVsZombies._node.isInto.gotoAndPlay(1);
               }
               else
               {
                  myNum = 0;
                  i = 0;
                  while(i < this.myMapOrgs.length)
                  {
                     myNum += (this.myMapOrgs[i] as Organism).getWidth() * (this.myMapOrgs[i] as Organism).getHeight();
                     i++;
                  }
                  if(myNum < 6)
                  {
                     PlantsVsZombies._node.isInto.visible = true;
                     PlantsVsZombies._node.isInto.gotoAndPlay(1);
                  }
               }
            }
            else if(this.friendMapOrgs == null || this.friendMapOrgs.length < 1)
            {
               PlantsVsZombies._node.isInto.visible = true;
               PlantsVsZombies._node.isInto.gotoAndPlay(1);
            }
            else
            {
               fNum = 0;
               j = 0;
               while(j < this.friendMapOrgs.length)
               {
                  fNum += (this.friendMapOrgs[j] as Organism).getWidth() * (this.friendMapOrgs[j] as Organism).getHeight();
                  j++;
               }
               if(fNum < this.friend_num)
               {
                  PlantsVsZombies._node.isInto.visible = true;
                  PlantsVsZombies._node.isInto.gotoAndPlay(1);
               }
            }
         }
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addBtEvent() : void
      {
         PlantsVsZombies._node["dowork"]["water"].addEventListener(MouseEvent.CLICK,this.btClick);
         PlantsVsZombies._node["dowork"]["fertilizer"].addEventListener(MouseEvent.CLICK,this.btClick);
         PlantsVsZombies._node["dowork"]["fetch_out"].addEventListener(MouseEvent.CLICK,this.btClick);
         PlantsVsZombies._node["dowork"]["gain"].addEventListener(MouseEvent.CLICK,this.btClick);
      }
      
      private function addOrg(param1:Organism, param2:Boolean, param3:GardenMonster = null) : void
      {
         var _loc4_:GardenOrgNode = new GardenOrgNode(param1,null,this.gardenMaster,this.gardenId);
         _loc4_.setState(GardenOrgNode.PUT);
         if(param3)
         {
            _loc4_.setGardenMonster(param3,this.upGarden);
         }
         if(param2)
         {
            _loc4_.x = this.operationOrgPoint(param1,true).x;
            _loc4_.y = this.operationOrgPoint(param1,true).y;
         }
         else
         {
            _loc4_.x = this.operationOrgPoint(param1,false).x;
            _loc4_.y = this.operationOrgPoint(param1,false).y;
         }
         if(param1.getY() == 0)
         {
            this._mc["org_1"].addChild(_loc4_);
         }
         else if(param1.getY() == 1)
         {
            this._mc["org_2"].addChild(_loc4_);
         }
         else if(param1.getY() == 2)
         {
            this._mc["org_3"].addChild(_loc4_);
         }
      }
      
      private function addPageButtonEvent() : void
      {
         PlantsVsZombies._node["_left"].addEventListener(MouseEvent.CLICK,this.onLeft);
         PlantsVsZombies._node["_right"].addEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      private function btClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "water" && !this.isWorking_water)
         {
            this.doWorks(OrganismManager.WATER);
         }
         else if(param1.currentTarget.name == "fertilizer" && !this.isWorking_fertilizer)
         {
            this.doWorks(OrganismManager.FERTILISER);
         }
         else if(param1.currentTarget.name == "fetch_out")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            PlantsVsZombies.storageInfo(this.fetchOut);
         }
         else if(param1.currentTarget.name == "gain" && !this.isWorking_gainAndSteal)
         {
            this.doWorks(OrganismManager.GAIN);
         }
      }
      
      private function changeGardenOrgsType() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Organism = null;
         var _loc3_:int = 0;
         var _loc4_:Organism = null;
         if(this.myMapOrgs != null && this.myMapOrgs.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.myMapOrgs.length)
            {
               _loc2_ = this.myMapOrgs[_loc1_] as Organism;
               _loc2_.setTypeTime(_loc2_.getTypeTime() - 1);
               if(_loc2_.getTypeTime() <= 0)
               {
                  if(_loc2_.getGardenType() != _loc2_.getNextType())
                  {
                     _loc2_.setGardenType(_loc2_.getNextType());
                     _loc2_.setTypeTime(0);
                     this.clearOrgNodes();
                     this.showOrgs();
                  }
               }
               if(_loc2_.getGainTime() > 0)
               {
                  _loc2_.setGainTime(_loc2_.getGainTime() - 1);
                  if(_loc2_.getGainTime() <= 0)
                  {
                     _loc2_.setGainTime(0);
                     this.clearOrgNodes();
                     this.showOrgs();
                  }
               }
               _loc1_++;
            }
         }
         if(this.friendMapOrgs != null && this.friendMapOrgs.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.friendMapOrgs.length)
            {
               _loc4_ = this.friendMapOrgs[_loc3_] as Organism;
               _loc4_.setTypeTime(_loc4_.getTypeTime() - 1);
               if(_loc4_.getTypeTime() <= 0)
               {
                  if(_loc4_.getGardenType() != _loc4_.getNextType())
                  {
                     _loc4_.setGardenType(_loc4_.getNextType());
                     _loc4_.setTypeTime(0);
                     this.clearOrgNodes();
                     this.showOrgs();
                  }
               }
               if(_loc4_.getGainTime() > 0)
               {
                  _loc4_.setGainTime(_loc4_.getGainTime() - 1);
                  if(_loc4_.getGainTime() <= 0)
                  {
                     _loc4_.setGainTime(0);
                     this.clearOrgNodes();
                     this.showOrgs();
                  }
               }
               _loc3_++;
            }
         }
      }
      
      private function clearOrg(param1:Organism) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.myMapOrgs != null && this.myMapOrgs.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.myMapOrgs.length)
            {
               if(this.myMapOrgs[_loc2_] == param1)
               {
                  this.myMapOrgs.splice(_loc2_,1);
               }
               _loc2_++;
            }
         }
         if(this.friendMapOrgs != null && this.friendMapOrgs.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.friendMapOrgs.length > 0)
            {
               if(this.friendMapOrgs[_loc3_] == param1)
               {
                  this.friendMapOrgs.splice(_loc3_,1);
               }
               _loc3_++;
            }
         }
      }
      
      private function clearOrgNode(param1:GardenOrgNode) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._mc["org_1"].numChildren)
         {
            if(this._mc["org_1"].getChildAt(_loc2_) == param1)
            {
               this._mc["org_1"].removeChild(param1);
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._mc["org_2"].numChildren)
         {
            if(this._mc["org_2"].getChildAt(_loc3_) == param1)
            {
               this._mc["org_2"].removeChild(param1);
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._mc["org_3"].numChildren)
         {
            if(this._mc["org_3"].getChildAt(_loc4_) == param1)
            {
               this._mc["org_3"].removeChild(param1);
            }
            _loc4_++;
         }
      }
      
      private function clearTimer() : void
      {
         if(this.gardenTimer != null)
         {
            this.gardenTimer.removeEventListener(TimerEvent.TIMER,this.onGardenTimer);
            this.gardenTimer.stop();
            this.gardenTimer = null;
         }
      }
      
      private function clearWithOutOrgs(param1:Array, param2:Array, param3:int = 0) : void
      {
         var base_array:Array = param1;
         var work_array:Array = param2;
         var work_type:int = param3;
         var clearOrgType:Function = function(param1:GardenOrgNode, param2:int):void
         {
            if(param2 == OrganismManager.WATER || param2 == OrganismManager.FERTILISER)
            {
               param1.getOrg().setNextType(OrganismManager.GAIN);
               param1.getOrg().setTypeTime(0);
               param1.showText(LangManager.getInstance().getLanguage("garden004"));
            }
            else if(param1.getOrg().getGardenId() == playerManager.getPlayer().getId())
            {
               clearOrg(param1.getOrg());
               param1.showText(LangManager.getInstance().getLanguage("garden005"));
            }
            else
            {
               param1.getOrg().setIsSteal(0);
               param1.showText(LangManager.getInstance().getLanguage("garden006"));
            }
            param1.showType();
         };
         var isClearOrg:Function = function(param1:GardenOrgNode, param2:Array):Boolean
         {
            if(param1 == null)
            {
               return false;
            }
            if(param2 == null || param2.length < 1)
            {
               return true;
            }
            var _loc3_:int = 0;
            while(_loc3_ < param2.length)
            {
               if(param1.getOrg().getId() == (param2[_loc3_] as GardenDoworkEntity).getId())
               {
                  return false;
               }
               _loc3_++;
            }
            return true;
         };
         var i:int = 0;
         while(i < base_array.length)
         {
            if(isClearOrg(base_array[i],work_array))
            {
               clearOrgType(base_array[i],work_type);
            }
            i++;
         }
      }
      
      private function doWork(param1:Array, param2:int) : void
      {
         var _loc3_:Tool = null;
         var _loc4_:int = 0;
         if(GlobalConstants.NEW_PLAYER)
         {
            _loc4_ = 0;
            if(param2 == OrganismManager.WATER)
            {
               _loc4_ = 6;
            }
            else
            {
               _loc4_ = 12;
            }
            PlantsVsZombies._node.isInto.visible = false;
            PlantsVsZombies.changeMoneyOrExp(_loc4_);
            PlantsVsZombies.changeMoneyOrExp(1,PlantsVsZombies.EXP);
            param1[0].showBlood();
            param1[0].showDoWorksEffect(param2,_loc4_,1,this._mc);
            PlantsVsZombies.helpN.show(HelpNovice.GARDEN_DOWORK_GAIN,PlantsVsZombies._node as DisplayObjectContainer);
            PlantsVsZombies.helpN.show(HelpNovice.GARDEN_DOWORK_FERTILISER,PlantsVsZombies._node as DisplayObjectContainer);
            return;
         }
         if(param2 == OrganismManager.WATER)
         {
            _loc3_ = this.playerManager.getPlayer().getTool(ToolManager.WATER);
         }
         else if(param2 == OrganismManager.FERTILISER)
         {
            _loc3_ = this.playerManager.getPlayer().getTool(ToolManager.FERTILISER);
         }
         else
         {
            _loc3_ = null;
         }
         if(param2 == OrganismManager.WATER)
         {
            this.isWorking_water = true;
         }
         else if(param2 == OrganismManager.FERTILISER)
         {
            this.isWorking_fertilizer = true;
         }
         this.doworkOrgs = param1;
         this.doworkType = param2;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GARDEN_REMOVE_STATE,this.doworkType,this.playerManager.getPlayerOther().getId(),param2);
      }
      
      private function doWorkGain(param1:Array) : void
      {
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies._node.isInto.visible = false;
            if(param1[0].getOrg().getGardenId() == this.playerManager.getPlayer().getId())
            {
               this.playerManager.getPlayer().setNowflowerpotNum(this.playerManager.getPlayer().getNowflowerpotNum() - 1);
            }
            this.playerManager.getPlayer().setMoney(40 + this.playerManager.getPlayer().getMoney());
            this.playerManager.getPlayer().setExp(1 + this.playerManager.getPlayer().getExp());
            PlantsVsZombies.setUserInfos();
            param1[0].showGainEffect(40,1,this._mc);
            param1[0].playLight();
            this.clearOrgNode(param1[0]);
            PlantsVsZombies.helpN.show(HelpNovice.GARDEN_GOTO_FRIEND,PlantsVsZombies._node as DisplayObjectContainer);
            return;
         }
         if(!this.isSteal(param1))
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden007"));
            return;
         }
         this.doworkOrgs = param1;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GARDEN_GAIN,RPC_GAIN,this.playerManager.getPlayerOther().getId());
      }
      
      private function doWorkInto(param1:Organism, param2:Boolean, param3:int, param4:Function) : void
      {
         var _loc6_:int = 0;
         var _loc7_:GardenOrgNode = null;
         if(PlantsVsZombies._node.dataLoading.visible)
         {
            return;
         }
         if(this.playerManager.getPlayer().getNowflowerpotNum() >= this.playerManager.getPlayer().getFlowerpotNum())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden008"));
            return;
         }
         var _loc5_:Tool = this.playerManager.getPlayer().getTool(ToolManager.FLOWERPOT);
         if(_loc5_ == null || _loc5_.getNum() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden009"));
            return;
         }
         if(param2)
         {
            _loc6_ = this.operationOrg(param3,param2).x + MY_TEMP_X;
         }
         else
         {
            _loc6_ = this.operationOrg(param3,param2).x;
         }
         param1.setX(this.operationOrg(param3,param2).x);
         param1.setY(this.operationOrg(param3,param2).y);
         if(GlobalConstants.NEW_PLAYER)
         {
            if(this.orgsWindow != null)
            {
               this.orgsWindow.hidden();
            }
            param1.setX(4);
            param1.setY(1);
            param1.setGainTime(1000);
            param1.setOwner(this.playerManager.getPlayer().getNickname());
            this.gardenId = this.playerManager.getPlayer().getId();
            this.playerManager.getPlayer().setExp(1 + this.playerManager.getPlayer().getExp());
            PlantsVsZombies.setUserInfos();
            if(this.playerManager.getPlayer().getId() == this.gardenId)
            {
               param1.setX(param1.getX() - MY_TEMP_X);
               this.myMapOrgs = new Array();
               this.myMapOrgs.push(param1);
            }
            else
            {
               this.friendMapManager.addOrg(param1);
            }
            _loc7_ = new GardenOrgNode(param1,null,this.gardenMaster,this.gardenId);
            _loc7_.setState(GardenOrgNode.PUT);
            _loc7_.x = this.operationOrgPoint(param1,param2).x;
            _loc7_.y = this.operationOrgPoint(param1,param2).y;
            if(param1.getY() == 0)
            {
               this._mc["org_1"].addChild(_loc7_);
            }
            else if(param1.getY() == 1)
            {
               this._mc["org_2"].addChild(_loc7_);
            }
            else if(param1.getY() == 2)
            {
               this._mc["org_3"].addChild(_loc7_);
            }
            _loc7_.playLight();
            if(param4 != null)
            {
               param4();
            }
            _loc7_.showGainEffect(0,1,this._mc);
            PlantsVsZombies.helpN.show(HelpNovice.GARDEN_DOWORK_WATER,PlantsVsZombies._node as DisplayObjectContainer);
            PlantsVsZombies._node.isInto.visible = false;
            PlantsVsZombies._node.isInto.gotoAndStop(1);
            PlantsVsZombies.setDoworkVisible(true);
            return;
         }
         this.intoOrg = param1;
         this.intoBackFun = param4;
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_GARDEN_INTO,RPC_INTO,this.gardenId,param1.getId(),_loc6_,this.operationOrg(param3,param2).y);
      }
      
      private function doWorks(param1:int) : void
      {
         if(this._mc == null || this._mc.numChildren < 1)
         {
            return;
         }
         var _loc2_:Array = this.getDowrkedOrgs(param1);
         if(_loc2_ == null || _loc2_.length < 1)
         {
            if(param1 == OrganismManager.WATER)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden010"));
            }
            else if(param1 == OrganismManager.FERTILISER)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden011"));
            }
            else if(param1 == OrganismManager.GAIN)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden012"));
            }
            return;
         }
         var _loc3_:Array = this.getDowrkedOrgs(param1);
         if(param1 == OrganismManager.WATER || param1 == OrganismManager.FERTILISER)
         {
            this.doWork(_loc3_,param1);
         }
         else
         {
            this.doWorkGain(_loc3_);
         }
      }
      
      private function expend(param1:int) : Boolean
      {
         var _loc2_:Tool = null;
         if(param1 == OrganismManager.WATER)
         {
            _loc2_ = this.playerManager.getPlayer().getTool(ToolManager.WATER);
            if(_loc2_ == null)
            {
               return false;
            }
            if(_loc2_.getNum() < 1)
            {
               return false;
            }
            return true;
         }
         if(param1 == OrganismManager.FERTILISER)
         {
            _loc2_ = this.playerManager.getPlayer().getTool(ToolManager.FERTILISER);
            if(_loc2_ == null)
            {
               return false;
            }
            if(_loc2_.getNum() < 1)
            {
               return false;
            }
            return true;
         }
         return true;
      }
      
      private function getDowrkedOrgs(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this._mc["org_1"].numChildren)
         {
            if(this._mc["org_1"].getChildAt(_loc3_) is GardenOrgNode && (this._mc["org_1"].getChildAt(_loc3_) as GardenOrgNode).getOrg().getGardenType() == param1)
            {
               if((this._mc["org_1"].getChildAt(_loc3_) as GardenOrgNode).getOrg().getGardenType() == OrganismManager.GAIN)
               {
                  if((this._mc["org_1"].getChildAt(_loc3_) as GardenOrgNode).getOrg().getGainTime() <= 0)
                  {
                     _loc2_.push(this._mc["org_1"].getChildAt(_loc3_));
                  }
               }
               else
               {
                  _loc2_.push(this._mc["org_1"].getChildAt(_loc3_));
               }
            }
            (this._mc["org_1"].getChildAt(_loc3_) as GardenOrgNode).showType();
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._mc["org_2"].numChildren)
         {
            if(this._mc["org_2"].getChildAt(_loc4_) is GardenOrgNode && (this._mc["org_2"].getChildAt(_loc4_) as GardenOrgNode).getOrg().getGardenType() == param1)
            {
               if((this._mc["org_2"].getChildAt(_loc4_) as GardenOrgNode).getOrg().getGardenType() == OrganismManager.GAIN)
               {
                  if((this._mc["org_2"].getChildAt(_loc4_) as GardenOrgNode).getOrg().getGainTime() <= 0)
                  {
                     _loc2_.push(this._mc["org_2"].getChildAt(_loc4_));
                  }
               }
               else
               {
                  _loc2_.push(this._mc["org_2"].getChildAt(_loc4_));
               }
            }
            (this._mc["org_2"].getChildAt(_loc4_) as GardenOrgNode).showType();
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._mc["org_3"].numChildren)
         {
            if(this._mc["org_3"].getChildAt(_loc5_) is GardenOrgNode && (this._mc["org_3"].getChildAt(_loc5_) as GardenOrgNode).getOrg().getGardenType() == param1)
            {
               if((this._mc["org_3"].getChildAt(_loc5_) as GardenOrgNode).getOrg().getGardenType() == OrganismManager.GAIN)
               {
                  if((this._mc["org_3"].getChildAt(_loc5_) as GardenOrgNode).getOrg().getGainTime() <= 0)
                  {
                     _loc2_.push(this._mc["org_3"].getChildAt(_loc5_));
                  }
               }
               else
               {
                  _loc2_.push(this._mc["org_3"].getChildAt(_loc5_));
               }
            }
            (this._mc["org_3"].getChildAt(_loc5_) as GardenOrgNode).showType();
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function getOrgNode(param1:Organism) : GardenOrgNode
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._mc["org_1"].numChildren)
         {
            if((this._mc["org_1"].getChildAt(_loc2_) as GardenOrgNode).getOrg() == param1)
            {
               return this._mc["org_1"].getChildAt(_loc2_);
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._mc["org_2"].numChildren)
         {
            if((this._mc["org_2"].getChildAt(_loc3_) as GardenOrgNode).getOrg() == param1)
            {
               return this._mc["org_2"].getChildAt(_loc3_);
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._mc["org_3"].numChildren)
         {
            if((this._mc["org_3"].getChildAt(_loc4_) as GardenOrgNode).getOrg() == param1)
            {
               return this._mc["org_3"].getChildAt(_loc4_);
            }
            _loc4_++;
         }
         return null;
      }
      
      private function getOrgNodeById(param1:int) : GardenOrgNode
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._mc["org_1"].numChildren)
         {
            if((this._mc["org_1"].getChildAt(_loc2_) as GardenOrgNode).getOrg().getId() == param1)
            {
               return this._mc["org_1"].getChildAt(_loc2_);
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._mc["org_2"].numChildren)
         {
            if((this._mc["org_2"].getChildAt(_loc3_) as GardenOrgNode).getOrg().getId() == param1)
            {
               return this._mc["org_2"].getChildAt(_loc3_);
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._mc["org_3"].numChildren)
         {
            if((this._mc["org_3"].getChildAt(_loc4_) as GardenOrgNode).getOrg().getId() == param1)
            {
               return this._mc["org_3"].getChildAt(_loc4_);
            }
            _loc4_++;
         }
         return null;
      }
      
      private function gotoGardenFirst() : void
      {
         this.friendMapOrgs = new Array();
         this.myMapOrgs = new Array();
         this.setGardenTimer();
         this.showGarden();
         this.showIntoGarden();
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function gotoGardenOther() : void
      {
         this.urlloaderSend(GlobalConstants.PVZ_RES_BASE_URL + "config/helpGardenInfo.xml",URL_INIT);
      }
      
      private function initMapManager() : void
      {
         this.clearOrgNodes();
         this.friendMapManager = new MapManager(4,3,this.friend_num,this.friendMapOrgs);
         this.myMapManager = new MapManager(2,3,6,this.myMapOrgs);
         this.showOrgs();
      }
      
      private function isHaveMyOrgs() : Boolean
      {
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            return true;
         }
         if(this.friendMapOrgs == null || this.friendMapOrgs.length < 1)
         {
            return false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.friendMapOrgs.length)
         {
            if((this.friendMapOrgs[_loc1_] as Organism).getGardenId() == this.playerManager.getPlayer().getId())
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function isIn(param1:int, param2:Array) : Boolean
      {
         if(param2 == null || param2.length < 1)
         {
            return false;
         }
         if(param1 == 0)
         {
            return true;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1 == param2[_loc3_])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function onGardenTimer(param1:TimerEvent) : void
      {
         this.changeGardenOrgsType();
      }
      
      private function onLeft(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden013"));
            return;
         }
         var _loc2_:int = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
         if(_loc2_ < 0)
         {
            return;
         }
         if(_loc2_ == 0)
         {
            PlantsVsZombies._node["back"].visible = true;
            this.init(this.playerManager.getPlayer());
            return;
         }
         var _loc3_:Player = this.playerManager.getFriendByIndex(_loc2_ - 1);
         if(_loc3_ != null)
         {
            this.init(_loc3_);
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden013"));
         }
      }
      
      private function onRight(param1:MouseEvent) : void
      {
         var _loc2_:Player = null;
         var _loc3_:Player = null;
         var _loc4_:int = 0;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(GlobalConstants.NEW_PLAYER)
         {
            _loc2_ = new Player();
            _loc2_.setId(0);
            _loc2_.setNickname(LangManager.getInstance().getLanguage("garden014"));
            _loc2_.setGrade(1);
            _loc2_.setCharm(0);
            this.init(_loc2_);
            this.clearTimer();
            PlantsVsZombies.helpN.show(HelpNovice.GARDEN_GOTO_FIRST,PlantsVsZombies._node as DisplayObjectContainer);
            return;
         }
         this.loadFriends(this.playerManager.getPlayerOther());
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            _loc3_ = this.playerManager.getFriendByIndex(0);
         }
         else
         {
            _loc4_ = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
            _loc3_ = this.playerManager.getFriendByIndex(_loc4_ + 1);
         }
         if(_loc3_ != null)
         {
            this.init(_loc3_);
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden015"));
         }
      }
      
      private function operationOrg(param1:int, param2:Boolean) : Point
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Point = new Point();
         if(param2)
         {
            _loc4_ = (param1 - 1) % 2;
            _loc5_ = (param1 - 1) / 2;
         }
         else
         {
            _loc4_ = (param1 - 1) % 4;
            _loc5_ = (param1 - 1) / 4;
         }
         _loc3_.x = _loc4_;
         _loc3_.y = _loc5_;
         return _loc3_;
      }
      
      private function operationOrgPoint(param1:Organism, param2:Boolean) : Point
      {
         var _loc3_:Point = new Point();
         var _loc4_:int = param1.getX();
         var _loc5_:int = param1.getY();
         var _loc6_:int = _loc4_ * GRID_W;
         var _loc7_:int = -(_loc5_ - 2) * GRID_H;
         _loc7_ = _loc7_ + 160;
         if(param2)
         {
            _loc6_ += 570;
         }
         else
         {
            _loc6_ += 140;
         }
         _loc3_.x = _loc6_;
         _loc3_.y = _loc7_;
         return _loc3_;
      }
      
      private function playerUp(param1:Object, param2:Garden_rpc) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.upIndex = -1;
         this.playerUpInfos = null;
         this.playerUpInfos = param2.getGradeUpInfos(param1);
         this.showPlayerUpInfo();
      }
      
      private function showPlayerUpInfo() : void
      {
         var _loc1_:PlayerUpGradeWindow = null;
         ++this.upIndex;
         if(this.playerUpInfos == null || this.playerUpInfos.length < 1)
         {
            return;
         }
         if(this.upIndex >= this.playerUpInfos.length)
         {
            return;
         }
         (this.playerUpInfos[this.upIndex] as PlayerUpInfo).upDatePlayer(this.playerManager.getPlayer(),1);
         PlantsVsZombies.setUserInfos();
         if(this.upIndex == this.playerUpInfos.length - 1)
         {
            _loc1_ = new PlayerUpGradeWindow(null);
         }
         else
         {
            _loc1_ = new PlayerUpGradeWindow(this.showPlayerUpInfo);
         }
         _loc1_.show((this.playerUpInfos[this.upIndex] as PlayerUpInfo).getTools(),(this.playerUpInfos[this.upIndex] as PlayerUpInfo).getMoney());
      }
      
      private function removeBtEvent() : void
      {
         PlantsVsZombies._node["autoGainIcon"].removeEventListener(MouseEvent.ROLL_OVER,this.autoGainOver);
         PlantsVsZombies._node["autoGainIcon"].removeEventListener(MouseEvent.ROLL_OUT,this.autoGainOut);
         PlantsVsZombies._node["autoGainIcon"].removeEventListener(MouseEvent.CLICK,this.autoGainClick);
         PlantsVsZombies._node["dowork"]["water"].removeEventListener(MouseEvent.CLICK,this.btClick);
         PlantsVsZombies._node["dowork"]["fertilizer"].removeEventListener(MouseEvent.CLICK,this.btClick);
         PlantsVsZombies._node["dowork"]["fetch_out"].removeEventListener(MouseEvent.CLICK,this.btClick);
         PlantsVsZombies._node["dowork"]["gain"].removeEventListener(MouseEvent.CLICK,this.btClick);
      }
      
      private function removePageButtonEvent() : void
      {
         PlantsVsZombies._node["_left"].removeEventListener(MouseEvent.CLICK,this.onLeft);
         PlantsVsZombies._node["_right"].removeEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      private function setGardenTimer() : void
      {
         if(this.gardenTimer != null)
         {
            this.gardenTimer.removeEventListener(TimerEvent.TIMER,this.onGardenTimer);
            this.gardenTimer.stop();
            this.gardenTimer = null;
         }
         this.gardenTimer = new Timer(1000);
         this.gardenTimer.addEventListener(TimerEvent.TIMER,this.onGardenTimer);
         this.gardenTimer.start();
         this.changeGardenOrgsType();
      }
      
      private function show() : void
      {
         this._mc.visible = true;
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.show(HelpNovice.GARDEN_ENTER_CHOOSEORG,PlantsVsZombies._node as DisplayObjectContainer);
            PlantsVsZombies._node.isInto.visible = false;
            PlantsVsZombies._node.isInto.gotoAndStop(1);
         }
      }
      
      private function showInit(param1:Object) : void
      {
         var _loc3_:ActionWindow = null;
         var _loc2_:XmlGardenOrgs = new XmlGardenOrgs(param1 as String);
         if(!_loc2_.isSuccess())
         {
            if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("garden002"),_loc2_.error(),null,false);
         }
         else
         {
            this.friendMapOrgs = new Array();
            this.myMapOrgs = new Array();
            if(!GlobalConstants.NEW_PLAYER)
            {
               this.friend_num = _loc2_.getFriendLandNum();
               _loc2_.setInfos(this.myMapOrgs,this.friendMapOrgs,this.gardenId);
            }
            else if(PlantsVsZombies.helpN.nowType == HelpNovice.GARDEN_GOTO_FIRST)
            {
               this.friend_num = _loc2_.getFriendLandNum();
               _loc2_.setInfos(this.myMapOrgs,this.friendMapOrgs,this.gardenId);
            }
            this.MapMonsterOrgs = _loc2_.getMosterInfo();
            this.setGardenTimer();
            this.showGarden();
            PlantsVsZombies.ChangeUserGardenNum();
            if(!this.isHaveMyOrgs())
            {
               PlantsVsZombies._friendsWindow.changePlayer(this.playerManager.getPlayerOther(),0);
            }
         }
         this.showIntoGarden();
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function showLight(param1:Player) : void
      {
         PlantsVsZombies._node["_left_light"].visible = false;
         PlantsVsZombies._node["_right_light"].visible = false;
         if(this.playerManager.getPlayer() != this.playerManager.getPlayerOther())
         {
            PlantsVsZombies._node["_left_light"].visible = true;
         }
         var _loc2_:int = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
         var _loc3_:Player = this.playerManager.getFriendByIndex(_loc2_ + 1);
         if(_loc3_ != null)
         {
            PlantsVsZombies._node["_right_light"].visible = true;
         }
      }
      
      private function showMessageNotEnoughTools(param1:Tool) : void
      {
         PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("garden016",param1.getName()));
      }
      
      private function showOrgDowork(param1:GardenDoworkEntity, param2:int, param3:Function = null) : void
      {
         var clearT:Timer = null;
         var orgnode:GardenOrgNode = null;
         var onComp:Function = null;
         var tooltype:int = 0;
         var orgEntity:GardenDoworkEntity = param1;
         var type:int = param2;
         var upFun:Function = param3;
         onComp = function(param1:TimerEvent):void
         {
            clearT.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            clearT.stop();
            clearT = null;
            clearOrg(orgnode.getOrg());
            clearOrgNode(orgnode);
            if(!isHaveMyOrgs())
            {
               PlantsVsZombies._friendsWindow.changePlayer(playerManager.getPlayerOther(),0);
            }
         };
         clearT = null;
         orgnode = this.getOrgNodeById(orgEntity.getId());
         if(type == OrganismManager.WATER || type == OrganismManager.FERTILISER)
         {
            if(orgEntity.getIsSuccess())
            {
               if(type == OrganismManager.WATER)
               {
                  tooltype = ToolManager.WATER;
                  PlantsVsZombies.playSounds(SoundManager.WATER);
               }
               else if(type == OrganismManager.FERTILISER)
               {
                  tooltype = ToolManager.FERTILISER;
                  PlantsVsZombies.playSounds(SoundManager.FERTILISER);
               }
               if(orgnode != null)
               {
                  orgEntity.updateOrg(orgnode.getOrg());
                  orgnode.showBlood();
                  orgnode.showDoWorksEffect(type,orgEntity.getReMoney(),orgEntity.getReExp(),this._mc);
               }
               PlantsVsZombies.changeMoneyOrExp(orgEntity.getReMoney(),PlantsVsZombies.MONEY);
               PlantsVsZombies.changeMoneyOrExp(orgEntity.getReExp(),PlantsVsZombies.EXP);
               this.showExpFull(orgEntity.getReExp());
            }
            else if(orgnode != null)
            {
               if(orgEntity.getErrorType() == XmlBaseReader.GARDNE_ERROR2)
               {
                  orgnode.showText(orgEntity.getErrorInfo());
               }
               else if(orgEntity.getErrorType() == XmlBaseReader.GARDEN_ERROR3)
               {
                  this.clearOrg(orgnode.getOrg());
                  orgnode.showText(orgEntity.getErrorInfo());
               }
               else
               {
                  orgnode.showText(orgEntity.getErrorInfo());
               }
            }
         }
         else if(orgEntity.getIsSuccess())
         {
            if(orgnode != null && orgnode.getOrg().getGardenId() == this.playerManager.getPlayer().getId() || this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
            {
               orgnode.showGainEffect(orgEntity.getReMoney(),orgEntity.getReExp(),this._mc);
               orgnode.playLight();
               clearT = new Timer(1500,1);
               clearT.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
               clearT.start();
            }
            else if(orgnode != null)
            {
               orgnode.getOrg().setIsSteal(0);
               orgnode.showStealEffect(orgEntity.getReMoney(),orgEntity.getReExp(),this._mc);
            }
            PlantsVsZombies.playSounds(SoundManager.MONEY);
            PlantsVsZombies.changeMoneyOrExp(orgEntity.getReMoney(),PlantsVsZombies.MONEY);
            PlantsVsZombies.changeMoneyOrExp(orgEntity.getReExp(),PlantsVsZombies.EXP);
            this.showExpFull(orgEntity.getReExp());
         }
         else
         {
            orgnode.showText(orgEntity.getErrorInfo());
         }
      }
      
      private function showOrgs() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.friendMapOrgs != null && this.friendMapOrgs.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.friendMapOrgs.length)
            {
               this.addOrg(this.friendMapOrgs[_loc2_],false);
               _loc2_++;
            }
         }
         if(this.myMapOrgs != null && this.myMapOrgs.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.myMapOrgs.length)
            {
               this.addOrg(this.myMapOrgs[_loc3_],true);
               _loc3_++;
            }
         }
         var _loc1_:Array = [];
         if(this.MapMonsterOrgs != null && this.MapMonsterOrgs.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this.MapMonsterOrgs.length)
            {
               _loc1_.push(this.MapMonsterOrgs[_loc4_].getShowOrg());
               this.addOrg(this.MapMonsterOrgs[_loc4_].getShowOrg(),false,this.MapMonsterOrgs[_loc4_]);
               _loc4_++;
            }
         }
         this.friendMapManager._monsters = _loc1_;
      }
      
      private function showOrgsDowork(param1:Array, param2:int, param3:Function) : void
      {
         var timers:int = 0;
         var timer:Timer = null;
         var n:int = 0;
         var onTimer:Function = null;
         var onComp:Function = null;
         var array:Array = param1;
         var type:int = param2;
         var upFunction:Function = param3;
         onTimer = function(param1:TimerEvent):void
         {
            if(n == timers - 1)
            {
               showOrgDowork(array[n],type,upFunction);
            }
            else
            {
               showOrgDowork(array[n],type);
            }
            ++n;
         };
         onComp = function(param1:TimerEvent):void
         {
            timer.removeEventListener(TimerEvent.TIMER,onTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            timer.stop();
            timer = null;
         };
         if(array == null || array.length < 1)
         {
            return;
         }
         timers = int(array.length);
         timer = new Timer(300,timers);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         timer.start();
         n = 0;
      }
   }
}

