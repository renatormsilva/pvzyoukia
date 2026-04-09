package pvz.world
{
   import constants.GlobalConstants;
   import flash.display.DisplayObjectContainer;
   import loading.UILoading;
   import manager.LangManager;
   import utils.FuncKit;
   import zlib.event.ForeletEvent;
   import zmyth.res.IDestroy;
   
   public class WorldFore implements IDestroy
   {
      
      private static const MAP1:int = 1;
      
      private var _uiLoad:UILoading = null;
      
      private var _root:DisplayObjectContainer = null;
      
      private var _insideWorld:InsideWorldFore = null;
      
      public function WorldFore(param1:DisplayObjectContainer)
      {
         super();
         LangManager.getInstance().doLoad(LangManager.MODE_WORLD);
         this._root = param1;
         this.doLoad();
      }
      
      private function doLoad() : void
      {
         this._uiLoad = new UILoading(this._root,GlobalConstants.PVZ_RES_BASE_URL,"config/load/world/world.xml?" + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         this._insideWorld = new InsideWorldFore(MAP1,this._root);
      }
      
      public function destroy() : void
      {
         if(this._insideWorld != null)
         {
            this._insideWorld.destroy();
            this._insideWorld = null;
         }
      }
   }
}

