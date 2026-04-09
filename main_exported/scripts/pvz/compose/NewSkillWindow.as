package pvz.compose
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.ArtWordsManager;
   import manager.SoundManager;
   import node.Icon;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class NewSkillWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      public function NewSkillWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("newskillWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function hidden() : void
      {
         this._window["ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
         onHiddenEffect(this._window,null);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.hidden();
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      public function show(param1:String, param2:String, param3:String, param4:Object, param5:Object, param6:int = 0, param7:int = 0) : void
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:DisplayObject = null;
         this.clear();
         if(param4 is Organism)
         {
            Icon.setUrlIcon(this._window._node1,param4.getPicId(),Icon.ORGANISM_1);
         }
         else if(param4 is Tool)
         {
            Icon.setUrlIcon(this._window._node1,param4.getPicId(),Icon.TOOL_1);
         }
         Icon.setUrlIcon(this._window._node2,param5.getPicId(),Icon.TOOL_1);
         if(param4 is Tool && param5 is Tool)
         {
            this._window.lv1.visible = true;
            this._window.lv2.visible = true;
            this._window.lv1.pic.addChild(FuncKit.getNumEffect(param6 - 1 + "","Small"));
            this._window.lv2.pic.addChild(FuncKit.getNumEffect(param6 + "","Small"));
         }
         this._window._tittle.htmlText = param1;
         if(param2 == null)
         {
            param2 = "";
         }
         if(param7 == 0)
         {
            _loc8_ = PlantsVsZombies.isIncludeNum(param2);
            _loc9_ = param2.slice(_loc8_,param2.length);
            _loc10_ = param2.indexOf("→");
            _loc11_ = Number(_loc9_.slice(0,_loc10_ - 2));
            _loc12_ = Number(_loc9_.slice(_loc10_ - 1,_loc9_.length));
            _loc13_ = ArtWordsManager.instance.getArtWordByTwoNumber(_loc11_,_loc12_,0,0,12,1,false);
            this._window._num_node.addChild(_loc13_);
            this._window._num_node.addChild(this._window._text3);
            _loc13_.x = -Math.floor(_loc13_.width / 2);
            this._window._text3.htmlText = param2.slice(0,_loc8_);
            this._window._text3.x = -(_loc13_.width / 2 + this._window._text3.width);
            this._window._text3.y = -4;
         }
         else
         {
            this._window._text.htmlText = param2;
         }
         if(param3 == null)
         {
            param3 = "";
         }
         this._window._text2.htmlText = param3;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
      
      private function clear() : void
      {
         if(this._window._node != null)
         {
            FuncKit.clearAllChildrens(this._window._node);
         }
         if(this._window._node2 != null)
         {
            FuncKit.clearAllChildrens(this._window._node2);
         }
         FuncKit.clearAllChildrens(this._window._num_node);
         this._window._tittle.htmlText = "";
         this._window._text.htmlText = "";
         this._window._text2.htmlText = "";
         this._window._text3.htmlText = "";
         this._window.lv1.visible = false;
         this._window.lv2.visible = false;
         if(this._window.lv1.pic != null)
         {
            FuncKit.clearAllChildrens(this._window.lv1.pic);
         }
         if(this._window.lv2.pic != null)
         {
            FuncKit.clearAllChildrens(this._window.lv2.pic);
         }
      }
   }
}

