package pvz.shaketree.view.secne
{
   import com.res.IDestroy;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import pvz.shaketree.net.ShakeTreeFPort;
   import utils.GetDomainRes;
   
   public class ShakeTreeScene implements IDestroy
   {
      
      private static var _miao:MovieClip;
      
      private static const UI_LAYER:int = 1;
      
      private static const ZOMBIES_LAYER:int = 2;
      
      private static const EFFECT_LAYER:int = 3;
      
      private var _ui:MovieClip;
      
      private var _layerDiction:Dictionary;
      
      private var _updateJewelFun:Function;
      
      public function ShakeTreeScene(param1:Function)
      {
         super();
         this._updateJewelFun = param1;
         var _loc2_:MovieClip = GetDomainRes.getMoveClip("pvz.shakeTree.scene");
         if(!_loc2_)
         {
            return;
         }
         this._ui = _loc2_;
         PlantsVsZombies._node.addChild(_loc2_);
         _miao = this._ui.miao;
         _miao.visible = false;
         _miao.mouseEnabled = false;
         _miao.mouseChildren = false;
         this.initData();
      }
      
      public static function miao() : MovieClip
      {
         return _miao;
      }
      
      private function initData() : void
      {
         var _loc1_:ShakeTreeFPort = new ShakeTreeFPort();
         _loc1_.requestSever(ShakeTreeFPort.INIT);
         _loc1_.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,this.initUI);
      }
      
      private function initUI(param1:HandleDataCompleteEvent) : void
      {
         this._layerDiction = new Dictionary();
         var _loc2_:UIPanelLayer = new UIPanelLayer(this);
         this._layerDiction[UI_LAYER] = _loc2_;
         var _loc3_:ZombiesLayer = new ZombiesLayer(this);
         this._layerDiction[ZOMBIES_LAYER] = _loc3_;
         var _loc4_:EffectLayer = new EffectLayer(this._ui.effectLayer);
         this._layerDiction[EFFECT_LAYER] = _loc4_;
      }
      
      public function getUILayer() : UIPanelLayer
      {
         return this._layerDiction[UI_LAYER];
      }
      
      public function getZomebiesLayer() : ZombiesLayer
      {
         return this._layerDiction[ZOMBIES_LAYER];
      }
      
      public function getEffectLayer() : EffectLayer
      {
         return this._layerDiction[EFFECT_LAYER];
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      public function destroy() : void
      {
         if(this._updateJewelFun != null)
         {
            this._updateJewelFun.call();
         }
         this.getZomebiesLayer().destroy();
         PlantsVsZombies._node.removeChild(this.ui);
      }
   }
}

