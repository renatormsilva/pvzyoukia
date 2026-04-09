package pvz.garden.window
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import labels.OrganismLabel;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.garden.manager.MapManager;
   import pvz.help.HelpNovice;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class GardenOrgsWindow extends BaseWindow
   {
      
      public static var ORG:int = 1;
      
      public static var SEED:int = 2;
      
      internal var _mc:MovieClip;
      
      internal var _node:Object;
      
      internal var _nowPage:int = 1;
      
      internal var _maxPage:int = 1;
      
      internal var _type:int = 0;
      
      internal var doworShow:Function;
      
      internal var basearray:Array;
      
      internal var nowArray:Array;
      
      internal var NUM:int = 6;
      
      internal var _window:GardenGridsWindow;
      
      internal var labelFun:Function;
      
      internal var hiddenBackFun:Function;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function GardenOrgsWindow(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("gardenKindsWindow");
         this._mc = new _loc2_();
         this._node = PlantsVsZombies._node;
         this.doworShow = param1;
         this._node.addChild(this._mc);
      }
      
      public function setWindowClick(param1:MovieClip, param2:int, param3:MapManager, param4:Function, param5:Function, param6:Function, param7:Function) : void
      {
         this._window = new GardenGridsWindow(param1,param2,param3,param4,param5);
         this.hiddenBackFun = param7;
         this.labelFun = param6;
      }
      
      public function orgLabelClick(param1:Organism) : void
      {
         var t:Timer = null;
         var onTimer:Function = null;
         var o:Organism = param1;
         onTimer = function(param1:TimerEvent):void
         {
            _window.show(o);
            PlantsVsZombies.setDoworkVisible(false);
            if(GlobalConstants.NEW_PLAYER)
            {
               PlantsVsZombies.helpN.show(HelpNovice.GARDEN_INTO_ORG,PlantsVsZombies._node as DisplayObjectContainer);
            }
            t.removeEventListener(TimerEvent.TIMER,onTimer);
            t.stop();
         };
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this.labelFun != null)
         {
            this.labelFun();
         }
         t = new Timer(550);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.start();
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.hidden();
         if(this.hiddenBackFun != null)
         {
            this.hiddenBackFun();
         }
         if(this.doworShow != null)
         {
            this.doworShow(true);
         }
      }
      
      public function orderOrgsByGrade(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null || param1.length < 1)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getGrade() < _loc3_.getGrade())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function show(param1:Function) : void
      {
         this.playerManager.changeNowFlowers(this.playerManager.getPlayer());
         this.setText();
         this._mc["cancel"].addEventListener(MouseEvent.CLICK,this.onCancel);
         this.setLoction();
         this.addPageBtEvent();
         this.addKindsEvent();
         this._mc["kinds"]["bt1"].gotoAndStop(1);
         this._mc["kinds"]["bt2"].gotoAndStop(2);
         this._mc["kinds"]["bt1"].buttonMode = true;
         this._mc["kinds"]["bt2"].buttonMode = false;
         this._mc["kinds"]["bt2"].visible = false;
         this._mc["kinds"]["bt1_selected"].gotoAndStop(1);
         this._mc["kinds"]["bt2_selected"].gotoAndStop(2);
         this._mc["kinds"]["bt1_selected"].visible = true;
         this._mc["kinds"]["bt2_selected"].visible = false;
         this._mc.visible = true;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.setChildIndex(this._mc,PlantsVsZombies._node.numChildren - 1);
         onShowEffect(this._mc,param1);
         this.basearray = new Array();
         this.basearray = this.checkOrgs(this.orderOrgsByGrade(this.playerManager.getPlayer().getAllOrganism()));
         if(this.basearray != null && this.basearray.length != 0)
         {
            this._maxPage = (this.basearray.length - 1) / this.NUM + 1;
         }
         else
         {
            this._maxPage = 1;
         }
         if(this._nowPage > this._maxPage)
         {
            this._nowPage = this._maxPage;
         }
         this.setPage();
         this.showPage();
      }
      
      public function init() : void
      {
         this.setPage();
         this._type = ORG;
         this._nowPage = 1;
      }
      
      public function checkOrgs(param1:Array) : Array
      {
         if(param1 == null || param1.length < 1)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Organism).getGardenId() == 0)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setText() : void
      {
         if(this._mc["_pic_flowerinfo"] != null && this._mc["_pic_flowerinfo"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_pic_flowerinfo"]);
         }
         if(this._mc["_pic_flowernum"] != null && this._mc["_pic_flowernum"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._mc["_pic_flowernum"]);
         }
         this._mc["_pic_flowerinfo"].addChild(FuncKit.getNumEffect(this.playerManager.getPlayer().getNowflowerpotNum() + "c" + this.playerManager.getPlayer().getFlowerpotNum()));
      }
      
      public function hidden() : void
      {
         this.clearLabels();
         this._mc["cancel"].removeEventListener(MouseEvent.CLICK,this.onCancel);
         this.removePageEvent();
         this.removeKindsEvent();
         onHiddenEffect(this._mc);
      }
      
      private function setLoction() : void
      {
         this._mc.x = (PlantsVsZombies.WIDTH - this._mc.width) / 2 + 10;
         this._mc.y = PlantsVsZombies.HEIGHT - this._mc.height - 10;
      }
      
      private function addPageBtEvent() : void
      {
         this._mc["bt_dec"].addEventListener(MouseEvent.CLICK,this.onPageClick);
         this._mc["bt_add"].addEventListener(MouseEvent.CLICK,this.onPageClick);
      }
      
      private function addKindsEvent() : void
      {
         this._mc["kinds"]["bt1"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._mc["kinds"]["bt2"].addEventListener(MouseEvent.CLICK,this.onKindsClick);
      }
      
      private function removePageEvent() : void
      {
         this._mc["bt_dec"].removeEventListener(MouseEvent.CLICK,this.onPageClick);
         this._mc["bt_add"].removeEventListener(MouseEvent.CLICK,this.onPageClick);
      }
      
      private function removeKindsEvent() : void
      {
         this._mc["kinds"]["bt1"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
         this._mc["kinds"]["bt2"].removeEventListener(MouseEvent.CLICK,this.onKindsClick);
      }
      
      private function onKindsClick(param1:MouseEvent) : void
      {
         this._mc["kinds"]["bt1_selected"].visible = false;
         this._mc["kinds"]["bt2_selected"].visible = false;
         this._nowPage = 1;
         this.setPage();
         if(param1.currentTarget.name == "bt1")
         {
            this._type = ORG;
            this._mc["kinds"]["bt1_selected"].visible = true;
         }
         else if(param1.currentTarget.name == "bt2")
         {
            this._type == SEED;
            this._mc["kinds"]["bt2_selected"].visible = true;
         }
         this.showPage();
      }
      
      private function onPageClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "bt_dec")
         {
            if(this._nowPage == 1)
            {
               return;
            }
            --this._nowPage;
            this.setPage();
            this.showPage();
         }
         else if(param1.currentTarget.name == "bt_add")
         {
            if(this._nowPage == this._maxPage)
            {
               return;
            }
            ++this._nowPage;
            this.setPage();
            this.showPage();
         }
      }
      
      private function showPage() : void
      {
         this.setPage();
         this.clearLabels();
         if(this.basearray == null || this.basearray.length < 1)
         {
            return;
         }
         this.nowArray = this.basearray.slice((this._nowPage - 1) * this.NUM,this._nowPage * this.NUM);
         this.doLayout();
      }
      
      public function doLayout() : void
      {
         var _loc3_:OrganismLabel = null;
         var _loc1_:int = 1;
         if(this.nowArray == null || this.nowArray.length <= 0)
         {
            return;
         }
         var _loc2_:* = int(this.nowArray.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = new OrganismLabel();
            _loc3_.update(this.nowArray[_loc2_],this.orgLabelClick);
            _loc3_.x += (_loc3_.width + 7) * _loc2_;
            this._mc["orgsInfos"].addChild(_loc3_);
            _loc2_--;
         }
      }
      
      private function clearLabels() : void
      {
         var _loc2_:OrganismLabel = null;
         if(this._mc["orgsInfos"].numChildren < 1)
         {
            return;
         }
         var _loc1_:* = int(this._mc["orgsInfos"].numChildren - 1);
         while(_loc1_ > -1)
         {
            _loc2_ = this._mc["orgsInfos"].getChildAt(_loc1_) as OrganismLabel;
            _loc2_.destroy();
            this._mc["orgsInfos"].removeChildAt(_loc1_);
            _loc1_--;
         }
      }
      
      private function setPage() : void
      {
         this._mc["page"]["t"].text = this._nowPage + "/" + this._maxPage;
      }
   }
}

