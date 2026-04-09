package pvz.possession
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import entity.Player;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import loading.UILoading;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.possession.fport.PossessionFPort;
   import pvz.possession.fport.PossessionReadyWindowFPort;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.FriendsWindow;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class PossessionFore extends BaseWindow implements IDestroy
   {
      
      private static const OPEN_LV:Array = [1,7,15,25,35,45];
      
      private static const POSSESSION_NUM:int = 6;
      
      public var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _id:Number = 0;
      
      private var _node:DisplayObjectContainer = null;
      
      private var _playerInfo:PlayerInfoPanel = null;
      
      private var _poss:Possession = null;
      
      private var _possFore:MovieClip = null;
      
      private var _uiLoad:UILoading = null;
      
      private var num:int = 0;
      
      private var numMax:int = 0;
      
      private var port:PossessionFPort = null;
      
      private var showJiantouIndex:int = 7;
      
      public function PossessionFore(param1:DisplayObjectContainer, param2:Player)
      {
         super();
         PlantsVsZombies._node.stage.frameRate = 12;
         this._node = param1;
         this._id = param2.getId();
         this.doLoad();
         LangManager.getInstance().doLoad(LangManager.MODE_POSSESSION);
         this.port = new PossessionFPort(this);
      }
      
      public function changePlayer(param1:Player, param2:Boolean = true) : void
      {
         if(param2 && param1.getGrade() < OPEN_LV[1])
         {
            PlantsVsZombies.changePlayer_other();
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession036"));
            return;
         }
         this.playerManager.setPlayerOther(param1);
         this.show(param1.getId());
         PlantsVsZombies.showDataLoading(true);
      }
      
      public function clearAll() : void
      {
         this.clearAllJiantou();
         this.clearAllNode();
      }
      
      private function hiddenAllNodes() : void
      {
         this.clearAllJiantou();
         var _loc1_:* = int(this._possFore["_layer_possession"].numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._possFore["_layer_possession"].getChildAt(_loc1_) is PossessionNode)
            {
               (this._possFore["_layer_possession"].getChildAt(_loc1_) as PossessionNode).visible = false;
            }
            _loc1_--;
         }
      }
      
      public function clearAllJiantou() : void
      {
         var _loc1_:* = int(this._possFore["_layer_jiantou"].numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._possFore["_layer_jiantou"].getChildAt(_loc1_) is DomainAccess.getClass("_possession_jiantou"))
            {
               this._possFore["_layer_jiantou"].removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      override public function destroy() : void
      {
         this.clearAllNode();
         this.removePageButtonEvent();
      }
      
      public function portChangeNum(param1:int, param2:int) : void
      {
         this.playerManager.getPlayerOther().setLastOccupy(param1);
         this.playerManager.getPlayerOther().setOccupy(param2);
         this.showMyInfo();
         this.showOpenPossession();
      }
      
      public function portInit(param1:int) : void
      {
         this.playerManager.getPlayer().setOccupyNum(param1);
         this.show(this._id);
      }
      
      public function portShowGuest(param1:Array) : void
      {
         var _loc2_:* = int(this.playerManager.getPlayerOther().getOccupy() - 1);
         while(_loc2_ > -1)
         {
            if(param1 != null && param1.length > _loc2_)
            {
               new PossessionNode(param1[_loc2_] as Possession,this._possFore,this.getPossessionLoc(_loc2_ + 1),this.updateFore,this.changePlayer,_loc2_ + 1,null,this.showMyInfo,this.hiddenAllNodes,PossessionNode.GUEST);
            }
            else
            {
               new PossessionNode(null,this._possFore,this.getPossessionLoc(_loc2_ + 1),this.updateFore,this.changePlayer,_loc2_ + 1,this.showJiantou,this.showMyInfo,this.hiddenAllNodes,PossessionNode.GUEST);
            }
            _loc2_--;
         }
      }
      
      public function portShowHost(param1:Possession) : void
      {
         new PossessionNode(param1,this._possFore,this.getPossessionLoc(0),this.updateFore,this.changePlayer,0,this.showJiantou,this.showMyInfo,this.hiddenAllNodes,PossessionNode.HOST);
      }
      
      public function portShowOtherPlayer(param1:Player) : void
      {
         var _loc2_:Player = null;
         if(param1.getId() == this.playerManager.getPlayer().getId())
         {
            this.playerManager.setPlayerOther(this.playerManager.getPlayer());
         }
         else
         {
            _loc2_ = this.playerManager.getFriendById(param1.getId());
            if(_loc2_ != null)
            {
               this.playerManager.setPlayerOther(_loc2_);
            }
            else
            {
               this.playerManager.setPlayerOther(param1);
            }
         }
         PlantsVsZombies.changePlayer_other();
      }
      
      public function updatePossession(param1:Possession) : void
      {
         var _loc2_:* = int(this._possFore.numChildren - 1);
         while(_loc2_ > -1)
         {
            if(this._possFore.getChildAt(_loc2_) is PossessionNode)
            {
               if((this._possFore.getChildAt(_loc2_) as PossessionNode).update(param1))
               {
                  break;
               }
            }
            _loc2_--;
         }
      }
      
      private function addPageButtonEvent() : void
      {
         PlantsVsZombies._node["_left"].addEventListener(MouseEvent.CLICK,this.onLeft);
         PlantsVsZombies._node["_right"].addEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      private function clearAllNode() : void
      {
         var _loc1_:* = int(this._possFore["_layer_possession"].numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._possFore["_layer_possession"].getChildAt(_loc1_) is PossessionNode)
            {
               (this._possFore["_layer_possession"].getChildAt(_loc1_) as PossessionNode).destory();
               this._possFore["_layer_possession"].removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function clearOpenPossession() : void
      {
         var _loc1_:* = int(this._possFore["_layer_possession"].numChildren - 1);
         while(_loc1_ > -1)
         {
            if(this._possFore["_layer_possession"].getChildAt(_loc1_) is DomainAccess.getClass("_mc_guest_gray"))
            {
               this._possFore["_layer_possession"].removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      private function doLoad() : void
      {
         this._uiLoad = new UILoading(this._node,GlobalConstants.PVZ_RES_BASE_URL,"config/load/possession.xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function friendsnodeBack(param1:Player) : void
      {
         this.changePlayer(param1);
      }
      
      private function getLoadInfos() : Array
      {
         return new Array();
      }
      
      private function getPossessionLoc(param1:int) : Point
      {
         var _loc2_:Point = new Point();
         switch(param1)
         {
            case 0:
               _loc2_.x = 235;
               _loc2_.y = 173;
               break;
            case 1:
               _loc2_.x = 515;
               _loc2_.y = 280;
               break;
            case 2:
               _loc2_.x = 370;
               _loc2_.y = 370;
               break;
            case 3:
               _loc2_.x = 150;
               _loc2_.y = 385;
               break;
            case 4:
               _loc2_.x = 9;
               _loc2_.y = 284;
               break;
            case 5:
               _loc2_.x = 100;
               _loc2_.y = 90;
               break;
            case 6:
               _loc2_.x = 423;
               _loc2_.y = 75;
         }
         return _loc2_;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_fore_possession");
         if(_loc1_ == null)
         {
            throw new Error(LangManager.getInstance().getLanguage("possession007") + " _fore_possession is null");
         }
         this._possFore = new _loc1_();
         PlantsVsZombies.setFriendWindowVisible(true);
         PlantsVsZombies.setPageButtonVisible(true);
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         PlantsVsZombies.setWindowsButtonsVisible();
         PlantsVsZombies.setFriendWindowType(FriendsWindow.POSSESSION);
         PlantsVsZombies.setFirendWindowBackFun(this.friendsnodeBack);
         this._possFore["_bt_back"].addEventListener(MouseEvent.CLICK,this.onBackClick);
         this._possFore["_p_num"].gotoAndStop(1);
         this._possFore["_layer_org"].mouseChildren = false;
         this._possFore["_layer_org"].mouseEnabled = false;
         this.stopOccupy();
         this.initLayer();
         this.initEvent();
         this.addPageButtonEvent();
         this._node.addChild(this._possFore);
         this.port.toInit();
      }
      
      private function initEvent() : void
      {
         this._possFore.addEventListener(MouseEvent.CLICK,this.onForeClick);
         this._possFore["_bt_info"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._possFore["_p_num"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._possFore["_p_num"].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function initLayer() : void
      {
         this._possFore["_layer_possession"]["_bg"].visible = false;
         this._possFore["_layer_jiantou"]["_bg"].visible = false;
      }
      
      private function loadFriends(param1:Player) : void
      {
         if(this.playerManager.isLoadFriend(param1))
         {
            PlantsVsZombies._friendsWindow.readFriends();
         }
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         this.init();
      }
      
      private function onBackClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         PlantsVsZombies._node["back"].visible = true;
         this.changePlayer(this.playerManager.getPlayer());
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_info")
         {
            new MessageWindow(this.changePlayer);
         }
      }
      
      private function onForeClick(param1:MouseEvent) : void
      {
         this.clearAllButtons(param1.target.name);
      }
      
      private function clearAllButtons(param1:String = "") : void
      {
         var _loc2_:* = int(this._possFore["_layer_possession"].numChildren - 1);
         while(_loc2_ > -1)
         {
            if(this._possFore["_layer_possession"].getChildAt(_loc2_) is PossessionNode)
            {
               (this._possFore["_layer_possession"].getChildAt(_loc2_) as PossessionNode).clearButtons(param1);
            }
            _loc2_--;
         }
      }
      
      private function onLeft(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession031"));
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
            this.changePlayer(this.playerManager.getPlayer());
            return;
         }
         var _loc3_:Player = this.playerManager.getFriendByIndex(_loc2_ - 1);
         if(_loc3_ != null)
         {
            this.changePlayer(_loc3_);
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession032"));
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._possFore["_p_num"].gotoAndStop(1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._possFore["_p_num"].gotoAndStop(2);
      }
      
      private function onRight(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.loadFriends(this.playerManager.getPlayerOther());
         var _loc2_:Player = null;
         if(this.playerManager.getPlayer() == this.playerManager.getPlayerOther())
         {
            _loc2_ = this.playerManager.getFriendByIndex(0);
         }
         else
         {
            _loc3_ = this.playerManager.getFriendIndex(this.playerManager.getPlayerOther());
            _loc2_ = this.playerManager.getFriendByIndex(_loc3_ + 1);
         }
         if(_loc2_ != null)
         {
            this.changePlayer(_loc2_);
         }
         else
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession033"));
         }
      }
      
      private function playOccupy(param1:Function) : void
      {
         var onFrame:Function = null;
         var backFun:Function = param1;
         onFrame = function(param1:Event):void
         {
            if(_possFore["_mc_occupation"].currentFrame == _possFore["_mc_occupation"].totalFrames)
            {
               _possFore["_mc_occupation"].stop();
               _possFore["_mc_occupation"].visible = false;
               _possFore.removeEventListener(Event.ENTER_FRAME,onFrame);
               _possFore["_mc_occupation"].gotoAndStop(1);
               removeBG();
               if(backFun != null)
               {
                  backFun();
               }
            }
         };
         this._possFore["_mc_occupation"].visible = true;
         this._possFore["_mc_occupation"].gotoAndPlay(1);
         this._possFore["_mc_occupation"].addEventListener(Event.ENTER_FRAME,onFrame);
      }
      
      private function removePageButtonEvent() : void
      {
         PlantsVsZombies._node["_left"].removeEventListener(MouseEvent.CLICK,this.onLeft);
         PlantsVsZombies._node["_right"].removeEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      private function show(param1:Number) : void
      {
         this._id = param1;
         this.showBackButton();
         PlantsVsZombies.showDataLoading(false);
         this.showJiantouIndex = 7;
         this.clearAllButtons();
         this.port.toPossessionInfo(param1);
      }
      
      private function showBackButton() : void
      {
         if(this._id == this.playerManager.getPlayer().getId())
         {
            this._possFore._bt_back.visible = false;
         }
         else
         {
            this._possFore._bt_back.visible = true;
         }
      }
      
      private function showJiantou(param1:int, param2:Point) : void
      {
         if(this.showJiantouIndex > param1)
         {
            this.showJiantouIndex = param1;
            this.clearAllJiantou();
            if(this._id != this.playerManager.getPlayer().getId() && this.showJiantouIndex > 0)
            {
               return;
            }
            var _loc3_:Class = DomainAccess.getClass("_possession_jiantou");
            var _loc4_:MovieClip = new _loc3_();
            _loc4_.x = param2.x;
            _loc4_.y = param2.y;
            this._possFore["_layer_jiantou"].addChild(_loc4_);
            return;
         }
      }
      
      private function showMyInfo() : void
      {
         if(this._playerInfo == null)
         {
            this._playerInfo = new PlayerInfoPanel(this._possFore);
         }
         this.showPossessionNum();
         this._playerInfo.upDate();
      }
      
      private function showOpenPossession() : void
      {
         var temp:Class;
         var om:MovieClip;
         var lv:int = 0;
         var onOMClick:Function = null;
         onOMClick = function(param1:MouseEvent):void
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession035",lv));
         };
         this.clearOpenPossession();
         if(this.playerManager.getPlayer().getId() != this.playerManager.getPlayerOther().getId())
         {
            return;
         }
         if(this.playerManager.getPlayer().getOccupy() == POSSESSION_NUM)
         {
            return;
         }
         lv = int(OPEN_LV[this.playerManager.getPlayer().getOccupy()]);
         temp = DomainAccess.getClass("_mc_guest_gray");
         om = new temp();
         om.gotoAndStop(this.playerManager.getPlayer().getOccupy() + 1);
         om.x = this.getPossessionLoc(this.playerManager.getPlayer().getOccupy() + 1).x;
         om.y = this.getPossessionLoc(this.playerManager.getPlayer().getOccupy() + 1).y;
         om.addEventListener(MouseEvent.CLICK,onOMClick);
         om.buttonMode = true;
         this._possFore["_layer_possession"].addChild(om);
      }
      
      private function showPossessionNum() : void
      {
         if(this._possFore["_p_num"]["_num1"].numChildren > 1)
         {
            FuncKit.clearAllChildrens(this._possFore["_p_num"]["_num1"]);
         }
         if(this._possFore["_p_num"]["_num2"].numChildren > 1)
         {
            FuncKit.clearAllChildrens(this._possFore["_p_num"]["_num2"]);
         }
         this._possFore["_p_num"]["_num1"].addChild(FuncKit.getNumEffect("" + (this.playerManager.getPlayer().getOccupy() - this.playerManager.getPlayer().getLastOccupy())));
         this._possFore["_p_num"]["_num2"].addChild(FuncKit.getNumEffect("" + this.playerManager.getPlayer().getOccupy()));
      }
      
      private function stopOccupy() : void
      {
         this._possFore["_mc_occupation"].gotoAndStop(1);
         this._possFore["_mc_occupation"].visible = false;
      }
      
      private function updateFore(param1:int = -1, param2:Possession = null, param3:Boolean = true, param4:int = 0) : void
      {
         var showOccupyInfo:Function = null;
         var type:int = param1;
         var p:Possession = param2;
         var isWin:Boolean = param3;
         var honor:int = param4;
         showOccupyInfo = function():void
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession010",_poss.getMaster()));
         };
         var showQuitInfo:Function = function():void
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession012",_poss.getMaster()));
         };
         this.clearAll();
         this.show(this._id);
         this.showMyInfo();
         this._poss = p;
         if(type == PossessionReadyWindowFPort.HELP)
         {
            if(isWin)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession008",this._poss.getMaster()));
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession009",this._poss.getMaster()));
            }
         }
         else if(type == PossessionReadyWindowFPort.OCCUPY)
         {
            if(isWin)
            {
               this.playOccupy(showOccupyInfo);
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("possession011",this._poss.getMaster()));
            }
         }
         else if(type == PossessionReadyWindowFPort.QUIT)
         {
            this.playOccupy(showOccupyInfo);
         }
      }
   }
}

