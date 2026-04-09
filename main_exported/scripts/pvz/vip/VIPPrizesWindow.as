package pvz.vip
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import manager.VersionManager;
   import node.VIPPrizesNode;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class VIPPrizesWindow extends BaseWindow
   {
      
      public static var NUM:int = 8;
      
      private var _backFun:Function;
      
      private var _baseNode:MovieClip;
      
      private var _prizesWindow:MovieClip;
      
      private var page:int = 1;
      
      private var maxPage:int = 1;
      
      private var basearray:Array = null;
      
      public function VIPPrizesWindow(param1:MovieClip)
      {
         super();
         this._baseNode = param1;
         var _loc2_:Class = DomainAccess.getClass("prizesWindow");
         this._prizesWindow = new _loc2_();
         this.setVersionButton();
         this.setLoaction();
         this.addClickEvent();
         this._prizesWindow.visible = false;
         this._baseNode.addChild(this._prizesWindow);
      }
      
      private function setVersionButton() : void
      {
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
         }
      }
      
      public function show(param1:Array, param2:int, param3:Function) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._backFun = param3;
         super.showBG(this._baseNode);
         this.maxPage = (param1.length - 1) / NUM + 1;
         this.basearray = param1;
         if(param2 != 0)
         {
            this.basearray.push(param2);
         }
         this.showPage();
         this._prizesWindow.visible = true;
         this.setLoaction();
         onShowEffect(this._prizesWindow);
         this._baseNode.setChildIndex(this._prizesWindow,this._baseNode.numChildren - 1);
      }
      
      private function showPage() : void
      {
         this.clearPage();
         this._prizesWindow["_page"].addChild(FuncKit.getNumEffect(this.page + "c" + this.maxPage));
         this.doLayout();
      }
      
      private function doLayout() : void
      {
         var _loc3_:VIPPrizesNode = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.clearPrize();
         var _loc1_:Array = this.basearray.slice((this.page - 1) * NUM,this.page * NUM);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] != null)
            {
               _loc3_ = new VIPPrizesNode(_loc1_[_loc2_]);
               _loc4_ = _loc2_ % 4;
               _loc5_ = _loc2_ / 4;
               _loc3_.x = _loc4_ * (_loc3_.width + 15) + 30;
               _loc3_.y = _loc5_ * (_loc3_.height + 10) + 5;
               this._prizesWindow["matter"].addChild(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function clearPrize() : void
      {
         FuncKit.clearAllChildrens(this._prizesWindow["matter"]);
      }
      
      private function clearPage() : void
      {
         FuncKit.clearAllChildrens(this._prizesWindow["_page"]);
      }
      
      private function addClickEvent() : void
      {
         this._prizesWindow["_ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._prizesWindow["_left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._prizesWindow["_right"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeClickEvent() : void
      {
         this._prizesWindow["_ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._prizesWindow["_left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._prizesWindow["_right"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_ok")
         {
            this.removeClickEvent();
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            if(this._backFun != null)
            {
               this._backFun();
            }
            this.hidden(this.destory);
         }
         else if(param1.currentTarget.name == "_left")
         {
            if(this.page == 1)
            {
               return;
            }
            --this.page;
            this.showPage();
         }
         else if(param1.currentTarget.name == "_right")
         {
            if(this.page == this.maxPage)
            {
               return;
            }
            ++this.page;
            this.showPage();
         }
      }
      
      private function destory() : void
      {
         try
         {
            this._baseNode.removeChild(this._prizesWindow);
         }
         catch(e:ArgumentError)
         {
         }
      }
      
      private function hidden(param1:Function) : void
      {
         this._prizesWindow.visible = false;
         this.clearPage();
         this.clearPrize();
         removeBG();
         param1();
      }
      
      private function setLoaction() : void
      {
         this._prizesWindow.x = PlantsVsZombies.WIDTH - this._prizesWindow.width + 75;
         this._prizesWindow.y = PlantsVsZombies.HEIGHT - this._prizesWindow.height + 110;
      }
   }
}

