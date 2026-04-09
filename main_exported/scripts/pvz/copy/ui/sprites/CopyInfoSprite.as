package pvz.copy.ui.sprites
{
   import com.res.IDestroy;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.copy.models.CopyInfoVo;
   import pvz.copy.models.limit.ActivtyCopyData;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class CopyInfoSprite extends Sprite implements IDestroy
   {
      
      private var _data:CopyInfoVo;
      
      private var _mc:MovieClip;
      
      private var _callback:Function;
      
      public function CopyInfoSprite(param1:CopyInfoVo, param2:Function)
      {
         super();
         this._callback = param2;
         this._mc = GetDomainRes.getMoveClip("pvz.activeCopy.enteranceNode");
         addChild(this._mc);
         this._mc["challage_words"].visible = false;
         this._data = param1;
         TextFilter.MiaoBian(this._mc["copyname"],1118481);
         this.initView();
      }
      
      private function initView() : void
      {
         this._mc["descirpt"].text = this._data.descript;
         if(this._data.status == 1)
         {
            this._mc["time"].text = LangManager.getInstance().getLanguage("activtyCopy006");
         }
         else if(this._data.status == 2)
         {
            if(this._data.copyId != ActivtyCopyData.CD_TIME_COPY)
            {
               this._mc["challage_words"].visible = true;
               this._mc["challage_times_node"].addChild(FuncKit.getNumEffect(this._data.challageTimes + ""));
            }
            this._mc["time"].text = LangManager.getInstance().getLanguage("activtyCopyStr001") + FuncKit.getTimeBySec(this._data.eTime - this._data.nowTime);
         }
         else if(this._data.status == 3)
         {
            this._mc["time"].text = LangManager.getInstance().getLanguage("activtyCopyStr002") + FuncKit.getTimeBySec(this._data.sTime - this._data.nowTime);
         }
         var _loc1_:DisplayObject = GetDomainRes.getBitmap("pvz.activtycopy.theme" + this._data.copyId);
         this._mc["picnode"].addChild(_loc1_);
         this._mc["copyname"].text = this._data.getCopyName();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._mc.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUPHandler);
      }
      
      private function onMouseUPHandler(param1:MouseEvent) : void
      {
         if(this._data.status == 3)
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy020"));
            return;
         }
         if(this._callback != null)
         {
            this._callback(this._data.copyId);
         }
      }
      
      public function destroy() : void
      {
         TextFilter.removeFilter(this._mc["copyname"]);
         this._data = null;
         this._mc.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUPHandler);
      }
   }
}

