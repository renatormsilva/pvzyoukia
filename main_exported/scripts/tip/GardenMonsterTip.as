package tip
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import pvz.garden.rpc.GardenMonster;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class GardenMonsterTip extends Tips
   {
      
      private var _background:MovieClip;
      
      private var _o:InteractiveObject;
      
      private var _temp_class:Class;
      
      private var _st:GardenMonster;
      
      public function GardenMonsterTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("gardenMonstertip");
         this._background = new this._temp_class();
         this.visible = false;
         this.miaobian();
         FuncKit.clearAllChildrens(this);
         this.addChild(this._background);
         this.cacheAsBitmap = true;
      }
      
      public static function layoutGrid(param1:DisplayObjectContainer, param2:int, param3:Number, param4:Number) : void
      {
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc5_:int = param1.numChildren;
         if(_loc5_ == 0)
         {
            return;
         }
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            _loc8_ = _loc6_ / param2;
            _loc9_ = _loc6_ % param2;
            _loc7_.x = _loc9_ * _loc7_.width + _loc9_ * param3;
            _loc7_.y = _loc8_ * _loc7_.height + _loc8_ * param4;
            _loc6_++;
         }
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
      
      public function setTooltip(param1:InteractiveObject, param2:GardenMonster) : void
      {
         this._o = param1;
         this._st = param2;
         this.setText();
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
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function miaobian() : void
      {
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function setText() : void
      {
         var _loc3_:String = null;
         var _loc4_:TextField = null;
         FuncKit.clearAllChildrens(this._background._info2);
         this._background._name.text = this._st.name;
         this._background._grade.text = "lv" + this._st.grade_min + " - lv" + this._st.grade_max;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:TextFormat = new TextFormat(null,12,16777215,null,null,null,null,null,TextFormatAlign.LEFT);
         for each(_loc3_ in this._st.getToolName())
         {
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc4_ = new TextField();
               _loc4_.selectable = false;
               _loc4_.wordWrap = false;
               _loc4_.defaultTextFormat = _loc2_;
               _loc4_.text = _loc3_;
               _loc4_.width = 65;
               _loc4_.height = 18;
               _loc1_.addChild(_loc4_);
            }
         }
         layoutGrid(_loc1_,2,3,3);
         this._background._info2.addChild(_loc1_);
      }
   }
}

