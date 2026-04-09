package tip
{
   import entity.GameMoney;
   import entity.Goods;
   import entity.Organism;
   import entity.Rmb;
   import entity.Tool;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import utils.FuncKit;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class ToolsTip extends Tips
   {
      
      private static var BEGIN_X:int = 10;
      
      private var _temp_class:Class;
      
      private var _background:MovieClip;
      
      private var nowwidth:int;
      
      private var nowheight:int = 0;
      
      private var _o:InteractiveObject;
      
      private var _obj:Object;
      
      public function ToolsTip()
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
         this.clearAllEvent();
         this._o = null;
         FuncKit.clearAllChildrens(this);
      }
      
      public function setTooltip(param1:InteractiveObject, param2:Object) : void
      {
         this._o = param1;
         this._obj = param2;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.setText();
      }
      
      public function setTooltipText(param1:InteractiveObject, param2:String, param3:String, param4:String) : void
      {
         this._o = param1;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._background._name.text = param2;
         this._background._use_condition.text = param3;
         this._background._use_result.text = param4;
      }
      
      private function setText() : void
      {
         if(this._obj == null)
         {
            return;
         }
         if(this._obj is Tool)
         {
            this._background._name.text = (this._obj as Tool).getName();
            this._background._use_condition.text = (this._obj as Tool).getUse_condition();
            this._background._use_result.text = (this._obj as Tool).getUse_result();
         }
         else if(this._obj is Organism)
         {
            this._background._name.text = (this._obj as Organism).getName();
            this._background._use_condition.text = (this._obj as Organism).getUse_condition();
            this._background._use_result.text = (this._obj as Organism).getUse_result();
         }
         else if(this._obj is Goods)
         {
            this._background._name.text = (this._obj as Goods).getName();
            this._background._use_condition.text = (this._obj as Goods).getUseCondition();
            this._background._use_result.text = (this._obj as Goods).getUseResult();
         }
         else if(this._obj is GameMoney)
         {
            this._background._name.text = (this._obj as GameMoney).getName();
            this._background._use_condition.text = (this._obj as GameMoney).getUseCondition();
            this._background._use_result.text = (this._obj as GameMoney).getUseResult();
         }
         else if(this._obj is Rmb)
         {
            this._background._name.text = (this._obj as Rmb).getName();
            this._background._use_condition.text = (this._obj as Rmb).getUseCondition();
            this._background._use_result.text = (this._obj as Rmb).getUseResult();
         }
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background._name,1118481);
         TextFilter.MiaoBian(this._background._use_condition,1118481);
         TextFilter.MiaoBian(this._background._use_result,1118481);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
         this.clearAllEvent();
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
   }
}

