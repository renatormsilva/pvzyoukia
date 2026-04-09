package pvz.copy.ui.tips
{
   import core.ui.tips.BaseTips;
   import entity.Goods;
   import entity.Organism;
   import entity.Tool;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import utils.FuncKit;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class PrizeTip extends BaseTips
   {
      
      private static var BEGIN_X:int = 10;
      
      private var _temp_class:Class;
      
      private var _background:Sprite;
      
      private var nowwidth:int;
      
      private var nowheight:int = 0;
      
      private var _o:InteractiveObject;
      
      private var _obj:Object;
      
      public function PrizeTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("toolstip");
         this._background = new this._temp_class();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      override public function destroy() : void
      {
         this.removeFilters();
         FuncKit.clearAllChildrens(this);
      }
      
      public function setTooltip(param1:InteractiveObject, param2:Object) : void
      {
         this.visible = true;
         this.showTips();
         this._o = param1;
         this._obj = param2;
         this.setText();
      }
      
      public function setTooltipText(param1:String, param2:String, param3:String) : void
      {
         this._background["_name"].text = param1;
         this._background["_use_condition"].text = param2;
         this._background["_use_result"].text = param3;
      }
      
      private function setText() : void
      {
         if(this._obj == null)
         {
            return;
         }
         if(this._obj is Tool)
         {
            this._background["_name"].text = (this._obj as Tool).getName();
            this._background["_use_condition"].text = (this._obj as Tool).getUse_condition();
            this._background["_use_result"].text = (this._obj as Tool).getUse_result();
         }
         else if(this._obj is Organism)
         {
            this._background["_name"].text = (this._obj as Organism).getName();
            this._background["_use_condition"].text = (this._obj as Organism).getUse_condition();
            this._background["_use_result"].text = (this._obj as Organism).getUse_result();
         }
         else if(this._obj is Goods)
         {
            this._background["_name"].text = (this._obj as Goods).getName();
            this._background["_use_condition"].text = (this._obj as Goods).getUseCondition();
            this._background["_use_result"].text = (this._obj as Goods).getUseResult();
         }
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background["_name"],1118481);
         TextFilter.MiaoBian(this._background["_use_condition"],1118481);
         TextFilter.MiaoBian(this._background["_use_result"],1118481);
      }
      
      private function removeFilters() : void
      {
         TextFilter.removeFilter(this._background["_name"]);
         TextFilter.removeFilter(this._background["_use_condition"]);
         TextFilter.removeFilter(this._background["_use_result"]);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
   }
}

