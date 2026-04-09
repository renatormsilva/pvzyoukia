package pvz.genius
{
   import constants.GlobalConstants;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import loading.UILoading;
   import manager.LangManager;
   import pvz.genius.scene.GeniusScene;
   import utils.FuncKit;
   import zlib.event.ForeletEvent;
   
   public class GeniusControl extends Sprite
   {
      
      private var loadurl:String = "config/load/genius.xml";
      
      private var domainUrl:String;
      
      private var _uiLoad:UILoading = null;
      
      private var panel:GeniusScene;
      
      private var mainNode:MovieClip;
      
      private var _oid:int;
      
      private var geniusScene:GeniusScene;
      
      public function GeniusControl(param1:int = 0)
      {
         super();
         this._oid = param1;
         this.initUI(PlantsVsZombies._node);
      }
      
      public function initUI(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         _loc2_ = this.loadurl + "?";
         this.mainNode = param1;
         this.initLanaguage();
         this.loadGameUi(_loc2_);
      }
      
      private function loadGameUi(param1:String) : void
      {
         this._uiLoad = new UILoading(this.mainNode,GlobalConstants.PVZ_RES_BASE_URL,param1 + FuncKit.currentTimeMillis());
         this._uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         this._uiLoad.remove();
         this._uiLoad = null;
         this.createObject();
      }
      
      private function initLanaguage() : void
      {
         LangManager.getInstance().doLoad(LangManager.MODE_GENIUS);
      }
      
      private function createObject() : void
      {
         this.geniusScene = new GeniusScene(this._oid);
         this.mainNode.addChild(this.geniusScene);
         this.geniusScene.backFuncDestory = this.backToFirstpage;
      }
      
      private function backToFirstpage() : void
      {
         this.distroy();
         PlantsVsZombies.backToFirstPage();
      }
      
      public function distroy() : void
      {
         if(this.geniusScene == null)
         {
            return;
         }
         this.geniusScene.destroy();
         if(this.mainNode.contains(this.geniusScene))
         {
            this.mainNode.removeChild(this.geniusScene);
         }
         this.geniusScene = null;
         this.mainNode = null;
      }
   }
}

