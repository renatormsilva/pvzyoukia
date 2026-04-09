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
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   
   public class CheckpointForeBoxTips extends Sprite
   {
      
      private var _bg:MovieClip = null;
      
      private var _checkpoint:Checkpoint = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function CheckpointForeBoxTips()
      {
         super();
         this.init();
         this.visible = false;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.boxTips");
         this._bg = new _loc1_();
      }
      
      private function setTop() : void
      {
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      public function show(param1:Checkpoint, param2:Point) : void
      {
         this.clear();
         this.setTop();
         this.TextMiaobian();
         this._checkpoint = param1;
         this.showText();
         this.addChild(this._bg);
         this.x = param2.x;
         this.y = param2.y;
         this.visible = true;
      }
      
      private function showText() : void
      {
         var _loc1_:Array = this._checkpoint.getPrizes();
         if(_loc1_ == null || _loc1_.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._bg["_text_award" + (_loc2_ + 1)].text = this.getPrizeName(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      private function getPrizeName(param1:Object) : String
      {
         if(param1 == null)
         {
            return "";
         }
         if(param1.type == "tool")
         {
            return XmlToolsConfig.getInstance().getToolAttribute(param1.value).getName();
         }
         return XmlOrganismConfig.getInstance().getOrganismAttribute(param1.value).getName();
      }
      
      private function TextMiaobian() : void
      {
         TextFilter.MiaoBian(this._bg["_text_title"],0);
         TextFilter.MiaoBian(this._bg["_text_award1"],0);
         TextFilter.MiaoBian(this._bg["_text_award2"],0);
         TextFilter.MiaoBian(this._bg["_text_award3"],0);
         TextFilter.MiaoBian(this._bg["_text_award4"],0);
         TextFilter.MiaoBian(this._bg["_text_award5"],0);
         TextFilter.MiaoBian(this._bg["_text_award6"],0);
      }
      
      private function clearMiaobian() : void
      {
         TextFilter.removeFilter(this._bg["_text_title"]);
         TextFilter.removeFilter(this._bg["_text_award1"]);
         TextFilter.removeFilter(this._bg["_text_award2"]);
         TextFilter.removeFilter(this._bg["_text_award3"]);
         TextFilter.removeFilter(this._bg["_text_award4"]);
         TextFilter.removeFilter(this._bg["_text_award5"]);
         TextFilter.removeFilter(this._bg["_text_award6"]);
      }
      
      public function clear() : void
      {
         this.visible = false;
         this.clearMiaobian();
         FuncKit.clearAllChildrens(this);
      }
   }
}

