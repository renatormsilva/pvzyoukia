package pvz.genius.windows
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import labels.StorageLabel;
   import manager.SoundManager;
   import tip.OrgTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class ChangePlantsWindow extends BaseWindow
   {
      
      public static var _tips:OrgTip;
      
      public static const JEWEL_ORG:int = 7;
      
      private var _callback:Function;
      
      private var _window:MovieClip;
      
      private var _orgs:Array;
      
      private var _curpage:int;
      
      private const PAGE_NUM:int = 12;
      
      private var _maxPage:int = 0;
      
      private var _labels:Array;
      
      public function ChangePlantsWindow(param1:Function)
      {
         super();
         this._callback = param1;
         this._window = GetDomainRes.getMoveClip("jewelSystem.ChangePlantsWindow");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         TextFilter.MiaoBian(this._window._txt1,1118481);
         this._window.visible = false;
         this.initUI();
         this.setLoction();
         PlantsVsZombies.storageInfo(this.show);
         this._labels = [];
         this.addEvent();
         this._window._page_txt.mouseEnabled = false;
      }
      
      private function initUI() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         _tips = new OrgTip();
         this._window.addChild(_tips);
         while(_loc2_ < 12)
         {
            _loc1_ = GetDomainRes.getMoveClip("labelbg");
            this._window._bgnode.addChild(_loc1_);
            _loc1_.x = _loc2_ % 6 * (_loc1_.width + 10);
            _loc1_.y = Math.floor(_loc2_ / 6) * (_loc1_.height + 5);
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         var onUp:Function = null;
         onUp = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window._closeBtn.removeEventListener(MouseEvent.MOUSE_UP,onUp);
            onHiddenEffect(_window,destory);
         };
         this._window._closeBtn.addEventListener(MouseEvent.MOUSE_UP,onUp);
         this._window._prebtn.addEventListener(MouseEvent.MOUSE_UP,this.toPrePage);
         this._window._nextbtn.addEventListener(MouseEvent.MOUSE_UP,this.toNextPage);
      }
      
      private function toPrePage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._curpage <= 1)
         {
            return;
         }
         --this._curpage;
         this.showCurpage();
      }
      
      private function toNextPage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._curpage >= this._maxPage)
         {
            return;
         }
         ++this._curpage;
         this.showCurpage();
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2 + this._window.width / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2 + this._window.height / 2;
      }
      
      private function show() : void
      {
         this._orgs = this.orderOrgsByGrade(PlantsVsZombies.playerManager.getPlayer().organisms);
         this._maxPage = this._orgs.length % this.PAGE_NUM > 0 ? int(this._orgs.length / this.PAGE_NUM + 1) : int(this._orgs.length / this.PAGE_NUM);
         this._curpage = 1;
         this.showCurpage();
         this._window.visible = true;
         onShowEffect(this._window);
      }
      
      private function showCurpage() : void
      {
         var _loc2_:StorageLabel = null;
         var _loc3_:int = 0;
         this.clearAllLebels();
         this._labels = [];
         this.updataPage();
         var _loc1_:Array = this._orgs.slice((this._curpage - 1) * this.PAGE_NUM,Math.min(this._curpage * this.PAGE_NUM,this._orgs.length));
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = new StorageLabel();
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
            this._window._node.addChild(_loc2_);
            _loc2_.x = _loc3_ % 6 * (_loc2_.width + 10);
            _loc2_.y = Math.floor(_loc3_ / 6) * (_loc2_.height + 5);
            _loc2_.update(_loc1_[_loc3_] as Organism,JEWEL_ORG,1,this.changePlants);
            _loc3_++;
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:StorageLabel = param1.target as StorageLabel;
         _tips.setOrgtip(_loc2_,_loc2_._o as Organism);
         _tips.setLoction(-170,-25);
         var _loc3_:Number = -170;
         var _loc4_:Number = -25;
         if(_loc2_.x >= 430)
         {
            _loc3_ = -450;
         }
         if(_loc2_.y >= 110)
         {
            _loc4_ = -230;
         }
         _tips.setLoction(_loc3_,_loc4_);
      }
      
      private function changePlants(param1:Object) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1 is Organism)
         {
            this._callback((param1 as Organism).getId());
         }
         onHiddenEffect(this._window,this.destory);
      }
      
      private function updataPage() : void
      {
         this._window._page_txt.text = this._curpage + "/" + this._maxPage;
      }
      
      private function clearAllLebels() : void
      {
         var _loc1_:StorageLabel = null;
         for each(_loc1_ in this._labels)
         {
            _loc1_.clearAllEvent();
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         }
         FuncKit.clearAllChildrens(this._window._node);
      }
      
      private function orderOrgsByGrade(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(param1 == null)
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
      
      private function destory() : void
      {
         this.clearAllLebels();
         this._window._prebtn.removeEventListener(MouseEvent.MOUSE_UP,this.toPrePage);
         this._window._nextbtn.removeEventListener(MouseEvent.MOUSE_UP,this.toNextPage);
         PlantsVsZombies._node.removeChild(this._window);
      }
   }
}

