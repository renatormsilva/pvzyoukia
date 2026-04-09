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
   
   public class ComposePrizeWindow extends BaseWindow
   {
      
      internal var _window:MovieClip;
      
      internal var _type:int;
      
      public function ComposePrizeWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("composePrizeWindow");
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
      
      public function show(param1:String, param2:String, param3:Object) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:DisplayObject = null;
         this.clear();
         if(param3 is Organism)
         {
            Icon.setUrlIcon(this._window["_node"],param3.getPicId(),Icon.ORGANISM_1);
         }
         else if(param3 is Tool)
         {
            Icon.setUrlIcon(this._window._node2,param3.getPicId(),Icon.TOOL_1);
         }
         this._window._str.text = param1;
         var _loc4_:int = param2.indexOf("到");
         if(_loc4_ == -1)
         {
            this._window._str2.text = param2;
         }
         else
         {
            _loc5_ = param2.slice(0,_loc4_ + 1);
            _loc6_ = param2.slice(_loc4_ + 1,param2.length - 1);
            this._window._str2.text = _loc5_;
            _loc7_ = ArtWordsManager.instance.artWordsDisplay(Number(_loc6_),0,14,false);
            this._window["_num_node"].addChild(_loc7_);
            _loc7_.x = -Math.floor(_loc7_.width / 2);
         }
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
      
      private function clear() : void
      {
         FuncKit.clearAllChildrens(this._window._node);
         FuncKit.clearAllChildrens(this._window["_num_node"]);
         this._window._str.text = "";
         this._window._str2.text = "";
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
   }
}

