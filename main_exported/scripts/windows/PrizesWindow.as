package windows
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.JSManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import pvz.battle.node.PrizesNode;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class PrizesWindow extends BaseWindow
   {
      
      public static var NUM:int = 8;
      
      private static const height:Number = 17.2;
      
      private var _backFun:Function;
      
      private var _baseNode:DisplayObjectContainer;
      
      private var _prizesWindow:MovieClip;
      
      private var page:int = 1;
      
      private var maxPage:int = 1;
      
      private var basearray:Array = null;
      
      private var _list:Sprite;
      
      public function PrizesWindow(param1:Function, param2:DisplayObjectContainer)
      {
         super();
         this._backFun = param1;
         this._baseNode = param2;
         var _loc3_:Class = DomainAccess.getClass("prizesWindow");
         this._prizesWindow = new _loc3_();
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
      
      public function show(param1:Array, param2:Function = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         super.showBG(this._baseNode);
         this.maxPage = (param1.length - 1) / NUM + 1;
         this.basearray = param1;
         this.showPage();
         this._prizesWindow.visible = true;
         this.setLoaction();
         onShowEffect(this._prizesWindow,param2);
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
         var _loc3_:PrizesNode = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.clearPrize();
         var _loc1_:Array = this.basearray.slice((this.page - 1) * NUM,this.page * NUM);
         this._list = new Sprite();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] != null)
            {
               _loc3_ = new PrizesNode(_loc1_[_loc2_]);
               _loc4_ = _loc2_ % 4;
               _loc5_ = _loc2_ / 4;
               _loc3_.x = _loc4_ * 80 + 10;
               _loc3_.y = _loc5_ * 100;
               this._list.addChild(_loc3_);
            }
            _loc2_++;
         }
         this._prizesWindow["matter"].addChild(this._list);
         this._list.x = 30;
         this._list.y = 5;
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
            this._prizesWindow.removeEventListener(MouseEvent.CLICK,this.onClick);
            this.hidden(this.destory);
            if(this._backFun != null)
            {
               this._backFun();
            }
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
      
      private function showShare() : void
      {
         JSManager.showShare("share004");
      }
   }
}

