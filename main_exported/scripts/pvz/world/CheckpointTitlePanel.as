package pvz.world
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class CheckpointTitlePanel extends Sprite implements IDestroy
   {
      
      private var _mc:MovieClip = null;
      
      private var _name:String = "";
      
      public function CheckpointTitlePanel(param1:String)
      {
         super();
         this._name = param1;
         this.init();
      }
      
      public function destroy() : void
      {
         this._name = "";
         TextFilter.removeFilter(this._mc["_txt_title"]);
         this._mc["_txt_title"].text = "";
         removeChild(this._mc);
         this._mc = null;
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.checkpointTitle");
         this._mc = new _loc1_();
         TextFilter.MiaoBian(this._mc["_txt_title"],0);
         this._mc["_txt_title"].text = this._name;
         addChild(this._mc);
      }
   }
}

