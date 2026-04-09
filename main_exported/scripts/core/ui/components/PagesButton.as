package core.ui.components
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   
   public class PagesButton extends Sprite
   {
      
      private var _nowpage:int = 1;
      
      private var _maxPage:int;
      
      private var _resouce:MovieClip;
      
      private var _checkContentByPage:Function;
      
      public function PagesButton(param1:MovieClip, param2:Function)
      {
         super();
         this._resouce = param1;
         this._checkContentByPage = param2;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._resouce["_next"].addEventListener(MouseEvent.MOUSE_UP,this.toCheckNextPage);
         this._resouce["_pre"].addEventListener(MouseEvent.MOUSE_UP,this.onCheckPrePage);
      }
      
      private function toCheckNextPage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._nowpage >= this._maxPage)
         {
            return;
         }
         ++this._nowpage;
         this.updatePages();
         if(this._checkContentByPage != null)
         {
            this._checkContentByPage(this._nowpage);
         }
      }
      
      private function onCheckPrePage(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._nowpage <= 1)
         {
            return;
         }
         --this._nowpage;
         this.updatePages();
         if(this._checkContentByPage != null)
         {
            this._checkContentByPage(this._nowpage);
         }
      }
      
      private function updatePages() : void
      {
         this._resouce["_page"].text = this._nowpage + "/" + this._maxPage;
      }
      
      public function initMaxPage(param1:int) : void
      {
         this._maxPage = param1;
         this._nowpage = 1;
         this.updatePages();
      }
      
      public function destory() : void
      {
         this._resouce["_next"].removeEventListener(MouseEvent.MOUSE_UP,this.toCheckNextPage);
         this._resouce["_pre"].removeEventListener(MouseEvent.MOUSE_UP,this.onCheckPrePage);
      }
   }
}

