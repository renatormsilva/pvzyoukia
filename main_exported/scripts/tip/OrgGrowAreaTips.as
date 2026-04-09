package tip
{
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class OrgGrowAreaTips extends Tips
   {
      
      private var _background:MovieClip;
      
      private var _o:InteractiveObject;
      
      public function OrgGrowAreaTips()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("orgGrowAreaTip");
         this._background = new _loc1_();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background._txt_base,0);
         TextFilter.MiaoBian(this._background._grow_txt,0);
      }
      
      public function setTxt(param1:InteractiveObject, param2:String, param3:String) : void
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
         this._background._txt_base.text = param2;
         this._background._grow_txt.text = param3;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1 - 185;
         this.y = this._o.y + param2 - 15;
      }
   }
}

