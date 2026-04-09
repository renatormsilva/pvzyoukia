package pvz.compose
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.ArtWordsManager;
   import manager.JSManager;
   import manager.LangManager;
   import manager.SoundManager;
   import manager.VersionManager;
   import node.Icon;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class ComposeOrgWindow extends BaseWindow
   {
      
      internal var _window:MovieClip = null;
      
      public function ComposeOrgWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("evolutionPrizeWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this.setVersionButton();
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setVersionButton() : void
      {
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
         }
      }
      
      private function hidden() : void
      {
         this._window["ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         onHiddenEffect(this._window,null);
      }
      
      public function show(param1:Organism, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String) : void
      {
         var base_o:Organism = param1;
         var att:String = param2;
         var hp:String = param3;
         var miss:String = param4;
         var pre:String = param5;
         var speed:String = param6;
         var new_pre:String = param7;
         var new_miss:String = param8;
         var getLeftPartDis:Function = function(param1:Number, param2:DisplayObject):DisplayObject
         {
            var _loc3_:Sprite = new Sprite();
            _loc3_.addChild(param2);
            var _loc4_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(param1,0,12,false);
            var _loc5_:DisplayObject = ArtWordsManager.instance.getSigleSpecilArtWord("→",16711680,12,false);
            _loc3_.addChild(_loc4_);
            _loc3_.addChild(_loc5_);
            param2.x = 0;
            if(param2 == _window.base_hp)
            {
               param2.y = -1.5;
            }
            else
            {
               param2.y = -2;
            }
            _loc4_.x = Math.floor(param2.width) + 3;
            _loc5_.x = _loc4_.x + Math.floor(_loc4_.width);
            return _loc3_;
         };
         var getRightPartDis:Function = function(param1:Number, param2:Number):DisplayObject
         {
            var _loc5_:DisplayObject = null;
            var _loc6_:DisplayObject = null;
            var _loc7_:DisplayObject = null;
            var _loc3_:Sprite = new Sprite();
            var _loc4_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(param1,16711680,12,false);
            _loc3_.addChild(_loc4_);
            if(param2 > 0)
            {
               _loc5_ = ArtWordsManager.instance.getSigleSpecilArtWord("+【",16711680,12,false);
               _loc6_ = ArtWordsManager.instance.artWordsDisplay(param2,16711680,12,false);
               _loc7_ = ArtWordsManager.instance.getSigleSpecilArtWord("】",16711680,12,false);
               _loc3_.addChild(_loc5_);
               _loc3_.addChild(_loc6_);
               _loc3_.addChild(_loc7_);
               _loc5_.x = _loc4_.width;
               _loc6_.x = _loc5_.x + _loc5_.width;
               _loc7_.x = _loc6_.x + _loc6_.width;
            }
            return _loc3_;
         };
         var addChildToWindow:Function = function(param1:DisplayObjectContainer, param2:DisplayObject, param3:DisplayObject):void
         {
            param1.addChild(param2);
            param2.x = -60;
            param1.addChild(param3);
            param3.x = param2.width + param2.x + 3;
         };
         this.clear();
         this._window.tittle_t.text = LangManager.getInstance().getLanguage("window050",base_o.getName());
         this._window.tittle.gotoAndStop(2);
         Icon.setUrlIcon(this._window._node1,base_o.getPicId(),Icon.ORGANISM_1);
         Icon.setUrlIcon(this._window._node2,base_o.getPicId(),Icon.ORGANISM_1);
         this._window.base_hp.text = LangManager.getInstance().getLanguage("window051");
         this._window.base_att.text = LangManager.getInstance().getLanguage("window012");
         this._window.base_pre.text = LangManager.getInstance().getLanguage("window015");
         this._window.base_miss.text = LangManager.getInstance().getLanguage("window013");
         this._window.base_pul.text = LangManager.getInstance().getLanguage("window014");
         this._window.base_new_pre.text = LangManager.getInstance().getLanguage("window177");
         this._window.base_new_miss.text = LangManager.getInstance().getLanguage("window176");
         this._window.base_qua.text = LangManager.getInstance().getLanguage("window052") + base_o.getQuality_name() + "→";
         addChildToWindow(this._window._hp_node,getLeftPartDis(base_o.getHp_max(),this._window.base_hp),getRightPartDis(base_o.getHp_max(),Number(hp)));
         addChildToWindow(this._window._attack_node,getLeftPartDis(base_o.getAttack(),this._window.base_att),getRightPartDis(base_o.getAttack(),Number(att)));
         addChildToWindow(this._window._hit_node,getLeftPartDis(base_o.getPrecision(),this._window.base_pre),getRightPartDis(base_o.getPrecision(),Number(pre)));
         addChildToWindow(this._window._miss_node,getLeftPartDis(base_o.getMiss(),this._window.base_miss),getRightPartDis(base_o.getMiss(),Number(miss)));
         addChildToWindow(this._window._grow_node,getLeftPartDis(base_o.getSpeed(),this._window.base_pul),getRightPartDis(base_o.getSpeed(),Number(speed)));
         addChildToWindow(this._window._new_miss_node,getLeftPartDis(base_o.getNewMiss(),this._window.base_new_miss),getRightPartDis(base_o.getNewMiss(),Number(new_miss)));
         addChildToWindow(this._window._new_hit_node,getLeftPartDis(base_o.getNewPrecision(),this._window.base_new_pre),getRightPartDis(base_o.getNewPrecision(),Number(new_pre)));
         this._window.qua.text = base_o.getQuality_name();
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.hidden();
         }
      }
      
      private function showShare() : void
      {
         JSManager.showShare("share002");
      }
      
      private function clear() : void
      {
         this._window.tittle_t.text = "";
         this._window._qua1.gotoAndStop(1);
         this._window._qua2.gotoAndStop(1);
         this._window._qua1.visible = false;
         this._window._qua2.visible = false;
         FuncKit.clearAllChildrens(this._window._node1);
         FuncKit.clearAllChildrens(this._window._node2);
         FuncKit.clearAllChildrens(this._window._pic1);
         FuncKit.clearAllChildrens(this._window._pic2);
         FuncKit.clearAllChildrens(this._window._hp_node);
         FuncKit.clearAllChildrens(this._window._attack_node);
         FuncKit.clearAllChildrens(this._window._hit_node);
         FuncKit.clearAllChildrens(this._window._miss_node);
         FuncKit.clearAllChildrens(this._window._grow_node);
         this._window.base_hp.text = "";
         this._window.base_att.text = "";
         this._window.base_pre.text = "";
         this._window.base_miss.text = "";
         this._window.base_pul.text = "";
         this._window.base_qua.text = "";
         this._window.base_new_pre.text = "";
         this._window.base_new_miss.text = "";
         this._window.qua.text = "";
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
   }
}

