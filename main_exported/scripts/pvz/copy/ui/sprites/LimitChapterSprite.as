package pvz.copy.ui.sprites
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.copy.models.limit.LimitChapterVo;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class LimitChapterSprite extends Sprite
   {
      
      private var _data:LimitChapterVo;
      
      private var _callback:Function;
      
      public function LimitChapterSprite(param1:LimitChapterVo, param2:Function)
      {
         super();
         this.mouseEnabled = true;
         this.buttonMode = true;
         var _loc3_:MovieClip = GetDomainRes.getMoveClip("pvz.limitcopy.newchpaterSprite");
         addChild(_loc3_);
         this._data = param1;
         this._callback = param2;
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.initView(_loc3_);
         TextFilter.MiaoBian(_loc3_["chapter_title"],1118481);
         TextFilter.MiaoBian(_loc3_["level_txt"],1118481);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(this._data.getOpenGrade() > PlantsVsZombies.playerManager.getPlayer().getGrade())
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy012"));
            return;
         }
         if(this._callback != null)
         {
            this._callback(this._data.getId());
         }
      }
      
      private function initView(param1:MovieClip) : void
      {
         if(this._data)
         {
            param1["chapter_title"].htmlText = this._data.getNameStr();
            param1["level_txt"].text = this._data.getOpenGrade() + LangManager.getInstance().getLanguage("activtyCopy013");
         }
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
   }
}

