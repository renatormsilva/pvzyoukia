package tip
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.ArtWordsManager;
   import utils.FuncKit;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class OrgComposeTip extends Tips
   {
      
      private var _background:MovieClip;
      
      private var _o:InteractiveObject;
      
      public function OrgComposeTip()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("orgcomptip");
         this._background = new _loc1_();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      public function setTxt(param1:InteractiveObject, param2:String, param3:Object) : void
      {
         var o:InteractiveObject = param1;
         var txt1:String = param2;
         var data:Object = param3;
         var addDisplay:Function = function(param1:DisplayObjectContainer, param2:Number):void
         {
            var _loc3_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(param2,16777215,12,true);
            param1.addChild(_loc3_);
         };
         FuncKit.clearAllChildrens(this._background._num_node1);
         FuncKit.clearAllChildrens(this._background._num_node2);
         FuncKit.clearAllChildrens(this._background._num_node3);
         this._o = o;
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
         this._background._txt1.text = txt1;
         addDisplay(this._background._num_node1,data.att1);
         addDisplay(this._background._num_node2,data.att2);
         addDisplay(this._background._num_node3,data.att3);
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background._txt_base1,0);
         TextFilter.MiaoBian(this._background._txt_base2,0);
         TextFilter.MiaoBian(this._background._txt_base3,0);
         TextFilter.MiaoBian(this._background._txt1,0);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1 - 185;
         this.y = this._o.y + param2 - 15;
      }
   }
}

