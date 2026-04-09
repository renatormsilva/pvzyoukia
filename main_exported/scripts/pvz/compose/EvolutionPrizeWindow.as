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
   import pvz.help.HelpNovice;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class EvolutionPrizeWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _type:int;
      
      public function EvolutionPrizeWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("evolutionPrizeWindow");
         this._window = new _loc1_();
         this.setVersionButton();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
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
         if(GlobalConstants.NEW_PLAYER)
         {
            onHiddenEffect(this._window,null);
         }
         else if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
            onHiddenEffect(this._window,null);
         }
         else
         {
            onHiddenEffect(this._window,null);
         }
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.show(HelpNovice.COMP_ENTER_FIRST,PlantsVsZombies._node as DisplayObjectContainer);
         }
      }
      
      private function showInvite() : void
      {
         if(this._type == ComposeWindow.ORG_EVOLUTION)
         {
            if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
            {
               PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("window058"),this.showInvite);
            }
            else
            {
               PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("window058"),null);
            }
         }
      }
      
      public function show(param1:int, param2:Organism, param3:Organism) : void
      {
         var type:int = param1;
         var base_o:Organism = param2;
         var o:Organism = param3;
         var getLeftPartDis:Function = function(param1:Number, param2:DisplayObject):DisplayObject
         {
            var _loc3_:Sprite = new Sprite();
            _loc3_.addChild(param2);
            var _loc4_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(param1,0,12,false);
            var _loc5_:DisplayObject = ArtWordsManager.instance.getSigleSpecilArtWord("→",0,12,false);
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
            _loc5_.x = _loc4_.x + Math.floor(_loc4_.width) + 3;
            return _loc3_;
         };
         var getRightPartDis:Function = function(param1:Number):DisplayObject
         {
            var _loc2_:Sprite = new Sprite();
            var _loc3_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(param1,16711680,12,false);
            _loc2_.addChild(_loc3_);
            return _loc2_;
         };
         var addChildToWindow:Function = function(param1:DisplayObjectContainer, param2:DisplayObject, param3:DisplayObject):void
         {
            param1.addChild(param2);
            param2.x = -60;
            param1.addChild(param3);
            param3.x = param2.x + param2.width + 3;
         };
         this.clear();
         this._type = type;
         switch(type)
         {
            case ComposeWindow.ORG_EVOLUTION:
               this._window.tittle_t.text = LangManager.getInstance().getLanguage("window059",o.getName());
               this._window.tittle.gotoAndStop(1);
               break;
            case ComposeWindow.ORG_PULLULATION:
               this._window.tittle_t.text = LangManager.getInstance().getLanguage("window060",base_o.getName());
               this.setPul(base_o,o);
               this._window.tittle.gotoAndStop(2);
               break;
            case ComposeWindow.ORG_QUALITY:
               this._window.tittle_t.text = LangManager.getInstance().getLanguage("window061",base_o.getName());
               this._window.tittle.gotoAndStop(2);
               this.setQua(base_o,o);
               break;
            case ComposeWindow.ORG_QUALITY_NEW:
               this._window.tittle_t.text = LangManager.getInstance().getLanguage("window061",base_o.getName());
               this._window.tittle.gotoAndStop(2);
               this.setQua(base_o,o);
               break;
            case ComposeWindow.ORG_QUALITY_MOSHEN:
               this._window.tittle_t.text = LangManager.getInstance().getLanguage("window061",base_o.getName());
               this._window.tittle.gotoAndStop(2);
               this.setQua(base_o,o);
            case ComposeWindow.ORG_INHERIT:
               this._window.tittle_t.text = LangManager.getInstance().getLanguage("org_inherit18");
               this._window.tittle.gotoAndStop(3);
               this.setQua(base_o,o);
         }
         Icon.setUrlIcon(this._window._node1,base_o.getPicId(),Icon.ORGANISM_1);
         Icon.setUrlIcon(this._window._node2,o.getPicId(),Icon.ORGANISM_1);
         addChildToWindow(this._window._hp_node,getLeftPartDis(base_o.getHp_max(),this._window.base_hp),getRightPartDis(o.getHp_max()));
         addChildToWindow(this._window._attack_node,getLeftPartDis(base_o.getAttack(),this._window.base_att),getRightPartDis(o.getAttack()));
         addChildToWindow(this._window._hit_node,getLeftPartDis(base_o.getPrecision(),this._window.base_pre),getRightPartDis(o.getPrecision()));
         addChildToWindow(this._window._new_hit_node,getLeftPartDis(base_o.getNewPrecision(),this._window.base_new_pre),getRightPartDis(o.getNewPrecision()));
         addChildToWindow(this._window._new_miss_node,getLeftPartDis(base_o.getNewMiss(),this._window.base_new_miss),getRightPartDis(o.getNewMiss()));
         addChildToWindow(this._window._miss_node,getLeftPartDis(base_o.getMiss(),this._window.base_miss),getRightPartDis(o.getMiss()));
         addChildToWindow(this._window._grow_node,getLeftPartDis(base_o.getPullulation(),this._window.base_pul),getRightPartDis(o.getPullulation()));
         this._window.base_qua.text = LangManager.getInstance().getLanguage("window052") + base_o.getQuality_name() + "→";
         this._window.qua.text = o.getQuality_name();
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
      
      private function setQua(param1:Organism, param2:Organism) : void
      {
         this._window._qua1.visible = true;
         this._window._qua2.visible = true;
         this._window._qua1.gotoAndStop(XmlQualityConfig.getInstance().getID(param1.getQuality_name()));
         this._window._qua2.gotoAndStop(XmlQualityConfig.getInstance().getID(param2.getQuality_name()));
      }
      
      private function setPul(param1:Organism, param2:Organism) : void
      {
         this._window._pic1.addChild(FuncKit.getNumEffect("" + param1.getPullulation(),"Small"));
         this._window._pic2.addChild(FuncKit.getNumEffect("" + param2.getPullulation(),"Small"));
      }
      
      private function clear() : void
      {
         this._window.tittle_t.text = "";
         this._window.base_qua.text = "";
         this._window.qua.text = "";
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
         FuncKit.clearAllChildrens(this._window._new_hit_node);
         FuncKit.clearAllChildrens(this._window._new_miss_node);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
   }
}

