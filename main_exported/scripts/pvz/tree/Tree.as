package pvz.tree
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.GlobalConstants;
   import constants.URLConnectionConstants;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import loading.UILoading;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.PrizesWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.XmlTree;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   import zmyth.ui.TextFilter;
   
   public class Tree extends Sprite implements IURLConnection, IDestroy
   {
      
      public static const MESSAGE_1:String = LangManager.getInstance().getLanguage("tree001");
      
      public static const MESSAGE_2:String = LangManager.getInstance().getLanguage("tree002");
      
      public static const MIDDLE:int = 10;
      
      public static const SMALL:int = 5;
      
      private static const INIT:int = 1;
      
      private static const ADDHEIGHT:int = 2;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _uiLoad:UILoading = null;
      
      private var _basenode:MovieClip;
      
      private var _backComd:Function;
      
      private var bigTree:MovieClip = null;
      
      private var isGetting:Boolean = false;
      
      private var urlconnection:URLConnection = null;
      
      public function Tree(param1:DisplayObjectContainer, param2:Function)
      {
         super();
         this._basenode = param1 as MovieClip;
         this._backComd = param2;
         this.doLoad();
      }
      
      private function doLoad() : void
      {
         this._uiLoad = new UILoading(this._basenode,GlobalConstants.PVZ_RES_BASE_URL,"config/load/tree.xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         PlantsVsZombies.setPlayerInfoVisible(true);
         PlantsVsZombies.setToFirstPageButtonVisible(true);
         this.initUI();
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("tree");
         this.bigTree = new _loc1_();
         this.bigTree.visible = false;
         this._basenode.addChild(this.bigTree);
         this.init();
      }
      
      public function destroy() : void
      {
         this.removeAllEvent();
      }
      
      private function init() : void
      {
         TextFilter.MiaoBian(this.bigTree._treeMessage._text,1129472);
         this.bigTree._tree.gotoAndStop(1);
         this.bigTree._tree._working.visible = false;
         this.bigTree._jiantou.gotoAndStop(1);
         this.bigTree._jiantou.visible = false;
         this.addButtonEvent();
         this.changeTreeType();
         this.changeTreeHigth(this.playerManager.getPlayer().getTreeHeight());
         this.show();
      }
      
      public function show() : void
      {
         this.bigTree.visible = true;
         this.showTreeMessage("");
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         if(param1 == ADDHEIGHT)
         {
            this.showAddHeight(param2);
         }
      }
      
      public function showAddHeight(param1:Object) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:XmlTree = new XmlTree(param1 as String);
         if(_loc3_.isSuccess())
         {
            this.playerManager.getPlayer().setTreeHeight(_loc3_.getTreeHeight());
            this.playerManager.getPlayer().setTreeTimes(this.playerManager.getPlayer().getTreeTimes() - 1);
            this.showTreeMessage(_loc3_.getTreeMessage());
            _loc2_ = _loc3_.getTreeAwards();
            this.showFertiliser(_loc2_);
            this.changeTreeType();
            this.addTools(_loc2_);
            if(this._backComd != null)
            {
               this._backComd();
            }
            this._backComd = null;
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
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
      }
      
      private function removeAllEvent() : void
      {
         this.removeButtonEvent();
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         this.urlconnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addButtonEvent() : void
      {
         this.bigTree._work.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addTools(param1:Array) : void
      {
         var _loc3_:Tool = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = this.playerManager.getPlayer().getTool((param1[_loc2_] as Tool).getOrderId());
            if(_loc3_ == null)
            {
               _loc3_ = new Tool((param1[_loc2_] as Tool).getOrderId());
            }
            _loc3_.setNum(_loc3_.getNum() + (param1[_loc2_] as Tool).getNum());
            _loc2_++;
         }
      }
      
      private function changeTreeHigth(param1:int) : void
      {
         if(this.bigTree._treeHeigth._num != null && this.bigTree._treeHeigth._num.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.bigTree._treeHeigth._num);
         }
         var _loc2_:DisplayObject = FuncKit.getNumEffect(param1 + "","Feared");
         _loc2_.x = -_loc2_.width;
         this.bigTree._treeHeigth._num.addChild(_loc2_);
         this.bigTree._treeHeigth.visible = true;
         if(param1 <= SMALL)
         {
            this.bigTree._tree.gotoAndStop(1);
            this.bigTree._tree._type.x = 292;
            this.bigTree._tree._type.y = 111;
         }
         else if(param1 < MIDDLE)
         {
            this.bigTree._tree.gotoAndStop(2);
            this.bigTree._tree._type.x = 331;
            this.bigTree._tree._type.y = 30;
         }
         else
         {
            this.bigTree._tree.gotoAndStop(3);
            this.bigTree._tree._type.x = 377;
            this.bigTree._tree._type.y = -54;
         }
      }
      
      private function changeTreeType() : void
      {
         if(this.playerManager.getPlayer().getTreeTimes() < 1)
         {
            this.bigTree._tree._type.visible = false;
            this.bigTree._jiantou.gotoAndStop(1);
            this.bigTree._jiantou.visible = false;
         }
         else
         {
            this.bigTree._tree._type.visible = true;
            this.bigTree._jiantou.gotoAndPlay(1);
            this.bigTree._jiantou.visible = true;
         }
      }
      
      private function numEffect(param1:Array) : void
      {
         var t:Timer = null;
         var t2:Timer = null;
         var t3:Timer = null;
         var onTimer:Function = null;
         var onComp:Function = null;
         var onTimerSec:Function = null;
         var onCompSec:Function = null;
         var onCompThird:Function = null;
         var prizes:Array = param1;
         onTimer = function(param1:TimerEvent):void
         {
            changeTreeHigth(playerManager.getPlayer().getTreeHeight());
            bigTree._treeHeigth._num.scaleX += 0.04;
            bigTree._treeHeigth._num.scaleY += 0.04;
         };
         onComp = function(param1:TimerEvent):void
         {
            t.removeEventListener(TimerEvent.TIMER,onTimer);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            t.stop();
            t = null;
            t2.start();
         };
         onTimerSec = function(param1:TimerEvent):void
         {
            bigTree._treeHeigth._num.scaleX -= 0.08;
            bigTree._treeHeigth._num.scaleY -= 0.08;
         };
         onCompSec = function(param1:TimerEvent):void
         {
            t2.removeEventListener(TimerEvent.TIMER,onTimerSec);
            t2.removeEventListener(TimerEvent.TIMER_COMPLETE,onCompSec);
            t2.stop();
            t2 = null;
            t3.start();
         };
         onCompThird = function(param1:TimerEvent):void
         {
            t3.removeEventListener(TimerEvent.TIMER_COMPLETE,onCompThird);
            t3.stop();
            t3 = null;
            showToolsPrizes(prizes);
         };
         var showToolsPrizes:Function = function():void
         {
            var _loc1_:PrizesWindow = null;
            if(prizes != null && prizes.length > 0)
            {
               _loc1_ = new PrizesWindow(null,PlantsVsZombies._node as MovieClip);
               _loc1_.show(prizes);
               PlantsVsZombies.playFireworks(3);
            }
            isGetting = false;
         };
         if(this.bigTree._treeHeigth._num == null && this.bigTree._treeHeigth._num.numChildren < 1)
         {
            return;
         }
         t = new Timer(20,8);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         t2 = new Timer(20,4);
         t2.addEventListener(TimerEvent.TIMER,onTimerSec);
         t2.addEventListener(TimerEvent.TIMER_COMPLETE,onCompSec);
         t3 = new Timer(500,1);
         t3.addEventListener(TimerEvent.TIMER_COMPLETE,onCompThird);
         t.start();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.isGetting)
         {
            return;
         }
         if(this.playerManager.getPlayer().getTreeTimes() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("tree003"));
            return;
         }
         if(this.playerManager.getPlayer().getTool(ToolManager.FERTILISER) == null || this.playerManager.getPlayer().getTool(ToolManager.FERTILISER).getNum() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("tree004"));
            return;
         }
         if(this.playerManager.getPlayer().getStorageFreeTools() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("tree005"));
            return;
         }
         this.isGetting = true;
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.RPC_TREE_ADDHEIGHT,false),ADDHEIGHT);
      }
      
      private function removeButtonEvent() : void
      {
         this.bigTree._work.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function showFertiliser(param1:Array) : void
      {
         var onPlay:Function = null;
         var prizes:Array = param1;
         onPlay = function(param1:Event):void
         {
            if(bigTree._tree._working.currentFrame == bigTree._tree._working.totalFrames)
            {
               bigTree._tree._working.stop();
               bigTree._tree._working.removeEventListener(Event.ENTER_FRAME,onPlay);
               bigTree._tree._working.visible = false;
            }
         };
         this.bigTree._tree._working.visible = true;
         this.bigTree._tree._working.addEventListener(Event.ENTER_FRAME,onPlay);
         this.bigTree._tree._working.gotoAndPlay(1);
         PlantsVsZombies.playSounds(SoundManager.FERTILISER);
         this.numEffect(prizes);
      }
      
      private function showTreeMessage(param1:String) : void
      {
         if(param1 == "")
         {
            if(this.playerManager.getPlayer().getTreeTimes() < 1)
            {
               this.bigTree._treeMessage._text.text = MESSAGE_2;
            }
            else
            {
               this.bigTree._treeMessage._text.text = MESSAGE_1;
            }
         }
         else
         {
            this.bigTree._treeMessage._text.text = param1;
         }
      }
   }
}

