package pvz.shaketree
{
   import constants.GlobalConstants;
   import flash.events.Event;
   import loading.UILoading;
   import manager.LangManager;
   import pvz.shaketree.view.secne.ShakeTreeScene;
   import utils.FuncKit;
   import zlib.event.ForeletEvent;
   
   public class ShakeTreeControl
   {
      
      private const UI_RES_URL:String = "config/load/shakeTree.xml";
      
      private var _uiLoad:UILoading;
      
      private var _callback:Function;
      
      public function ShakeTreeControl(param1:Function = null)
      {
         super();
         this._callback = param1;
         LangManager.getInstance().doLoad(LangManager.SHAKE_TREE);
         this.startLoadAssets();
      }
      
      private function startLoadAssets() : void
      {
         this._uiLoad = new UILoading(PlantsVsZombies._node,GlobalConstants.PVZ_RES_BASE_URL,this.UI_RES_URL + "?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      protected function onAllComp(param1:Event) : void
      {
         this._uiLoad.remove();
         this._uiLoad.removeEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
         this._uiLoad = null;
         this.toShakeTreeScence();
      }
      
      private function toShakeTreeScence() : void
      {
         new ShakeTreeScene(this._callback);
      }
   }
}

