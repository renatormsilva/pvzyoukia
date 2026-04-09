package pvz.world.tips
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import manager.PlayerManager;
   import pvz.world.Checkpoint;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   
   public class CheckpointPrizeTips extends Sprite
   {
      
      private var _bg:MovieClip = null;
      
      private var _checkpoint:Checkpoint = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function CheckpointPrizeTips()
      {
         super();
         this.init();
         this.visible = false;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.prizestips");
         this._bg = new _loc1_();
         TextFilter.MiaoBian(this._bg._name,1118481);
         TextFilter.MiaoBian(this._bg._use_result,1118481);
      }
      
      private function setTop() : void
      {
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      public function show(param1:int, param2:Point) : void
      {
         this.clear();
         this.setTop();
         this._bg["_name"].text = XmlToolsConfig.getInstance().getToolAttribute(param1).getName();
         this._bg["_use_result"].text = XmlToolsConfig.getInstance().getToolAttribute(param1).getExpl();
         this._bg.x = param2.x - 10;
         this._bg.y = param2.y - this._bg.height / 2;
         this.addChild(this._bg);
         this.visible = true;
      }
      
      public function setLoction() : void
      {
      }
      
      public function clear() : void
      {
         this.visible = false;
         FuncKit.clearAllChildrens(this);
      }
   }
}

