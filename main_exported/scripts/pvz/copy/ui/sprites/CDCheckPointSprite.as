package pvz.copy.ui.sprites
{
   import com.res.IDestroy;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.copy.models.cd.CDTimeCheckPoint;
   import pvz.copy.ui.tips.CdTimeCheckPointTips;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class CDCheckPointSprite extends Sprite implements IDestroy
   {
      
      private var _data:CDTimeCheckPoint;
      
      private var _callback:Function;
      
      private var _cTimer:CTimer;
      
      private var _mc:MovieClip;
      
      private var cdtime:Number;
      
      private var _tips:CdTimeCheckPointTips;
      
      private var _timedis:DisplayObject;
      
      public function CDCheckPointSprite(param1:CDTimeCheckPoint, param2:Function)
      {
         super();
         this.mouseEnabled = true;
         this.mouseChildren = false;
         this.buttonMode = true;
         this._mc = GetDomainRes.getMoveClip("pvz.cdcopy.checkpoint");
         addChild(this._mc);
         this._data = param1;
         this._callback = param2;
         this.initView(this._mc);
         this.addEvent();
         this.miaobain();
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      protected function onHandler(param1:MouseEvent) : void
      {
      }
      
      protected function onOver(param1:MouseEvent) : void
      {
         TextFilter.MiaoBian(this._mc["avatar"],16776960,0.6,6,6);
         if(this._tips == null)
         {
            this._tips = new CdTimeCheckPointTips();
         }
         this._tips.initTips(this._data.getRewards(),this._data.getName());
         this._tips.showTips(param1);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         TextFilter.removeFilter(this._mc["avatar"]);
         if(this._tips)
         {
            this._tips.destroy();
            this._tips.hideTips();
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(this._callback != null)
         {
            if(this.cdtime > 0)
            {
               FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy003"));
               return;
            }
            if(this._data.getChallageTime() == 0)
            {
               FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy002"));
               return;
            }
            this._callback(this._data);
         }
      }
      
      private function miaobain() : void
      {
         TextFilter.MiaoBian(this._mc["name_txt"],17895697);
         TextFilter.MiaoBian(this._mc["challage_times"],17895697);
      }
      
      private function removeMiaobian() : void
      {
         TextFilter.removeFilter(this._mc["name_txt"]);
         TextFilter.removeFilter(this._mc["challage_times"]);
      }
      
      private function initView(param1:MovieClip) : void
      {
         if(this._data)
         {
            param1["avatar"].addChild(GetDomainRes.getDisplayObject("pvz.avatar" + this._data.getPicid()));
            param1["name_txt"].text = this._data.getName();
            if(this._data.getChallageTime() != -1)
            {
               param1["challage_times"].text = LangManager.getInstance().getLanguage("activtyCopy004") + this._data.getChallageTime();
            }
            else
            {
               param1["txtbg"].visible = false;
            }
            this.cdtime = this._data.getCDTime();
            if(this.cdtime > 0)
            {
               FuncKit.clearAllChildrens(this._mc["countdown"]);
               this._timedis = FuncKit.getArtTimeBySec(this.cdtime);
               this._mc["countdown"].addChild(this._timedis);
               this._timedis.x = -this._timedis.width / 2;
               if(this._cTimer == null)
               {
                  this._cTimer = new CTimer(1000);
               }
               this._cTimer.addEventListener(CTimerEvent.TIMER,this.onTimer);
               this._cTimer.start();
            }
         }
      }
      
      private function onTimer(param1:CTimerEvent) : void
      {
         FuncKit.clearAllChildrens(this._mc["countdown"]);
         --this.cdtime;
         if(this.cdtime <= 0)
         {
            this._cTimer.stop();
            this._cTimer.removeEventListener(CTimerEvent.TIMER,this.onTimer);
            this._cTimer = null;
         }
         else
         {
            this._timedis = FuncKit.getArtTimeBySec(this.cdtime);
            this._mc["countdown"].addChild(this._timedis);
            this._timedis.x = -this._timedis.width / 2;
         }
      }
      
      public function destroy() : void
      {
         if(this._cTimer)
         {
            this._cTimer.stop();
            this._cTimer.removeEventListener(CTimerEvent.TIMER,this.onTimer);
            this._cTimer = null;
         }
         this.removeMiaobian();
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
   }
}

